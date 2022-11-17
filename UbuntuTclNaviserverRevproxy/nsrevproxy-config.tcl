########################################################################
# Sample configuration file for NaviServer
########################################################################
set			server						default
set			server_desc					"NaviServer Reverse Proxy"

set			homedir						[file dirname [file dirname [info nameofexecutable]]]
set			bindir						${homedir}/bin
set			pageroot					${homedir}/pages
set			hostname					[ns_info hostname]

set			port						80
set			ssl_port					443
set			ip_addr						0.0.0.0
set			ipv6_addr					::1

########################################################################
# Global settings (for all servers)
########################################################################
ns_section			"ns/modules" {
	ns_param			nsssl					${bindir}/nsssl.so
	ns_param			nssock					${bindir}/nssock.so
}

ns_section			"ns/parameters" {
	ns_param			home					${homedir}
	ns_param			tcllibrary				tcl
	ns_param			serverlog				${homedir}/logs/error.log
	ns_param			formfallbackcharset		iso8859-1 
	ns_param			logusec					false
	ns_param			logusecdiff				false
	ns_param			logcolorize				true 
	ns_param			logprefixcolor			green
	ns_param			logprefixintensity		bright
	ns_param			jobsperthread			1000
	ns_param			joblogminduration		100s
	ns_param			schedsperthread			100
	ns_param			schedlogminduration		2s
	ns_param			progressminsize			1MB
}

ns_section			"ns/mimetypes" {
	ns_param			default					"text/plain"
	ns_param			noextension				"text/plain"
}

ns_section			"ns/threads" {
	ns_param			stacksize				[expr 512*1024]
}

ns_section			"ns/module/nssock" {
	ns_param			address						$ip_addr
	ns_param			port						$port
	ns_param			hostname					$hostname
	ns_param			defaultserver				${server}
	ns_param			backlog						1024
	ns_param			acceptsize					10
	ns_param			closewait					0s
}

ns_section			"ns/module/nsssl" {
	ns_param			address						$ip_addr
	ns_param			port						$ssl_port
	ns_param			hostname					$hostname
	ns_param			defaultserver				${server}
	ns_param			certificate					${homedir}/modules/nsssl/${server}.pem
	ns_param			ciphers						"ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!RC4"
	ns_param			protocols					"!SSLv2:!SSLv3"
	ns_param			verify						0
	ns_param			extraheaders {
				Strict-Transport-Security "max-age=31536000; includeSubDomains"
				X-Frame-Options SAMEORIGIN
				X-Content-Type-Options nosniff
	}
}

# Map headers to server-name
ns_section			"ns/servers" {
	ns_param			${server}					${server_desc}
}

ns_section			"ns/module/nssock/servers" {
	ns_param			${server}					localhost
}

ns_section			"ns/module/nsssl/servers" {
	ns_param			${server}					localhost
}





########################################################################
#  Settings for the "default" server
########################################################################
# Server parameters
ns_section			"ns/server/${server}" {
	ns_param		directoryfile		index.tcl,index.adp,index.html,index.htm
	ns_param		pageroot			$pageroot
	ns_param		enabletclpages		true  ;# default: false
	ns_param		checkmodifiedsince	false ;# default: true, check modified-since before returning files from cache. Disable for speedup
	ns_param		connsperthread		1000  ;# default: 0; number of connections (requests) handled per thread
	ns_param		minthreads			5     ;# default: 1; minimal number of connection threads
	ns_param		maxthreads			100   ;# default: 10; maximal number of connection threads
	ns_param		rejectoverrun		true  ;# default: false; send 503 when thread pool queue overruns
}

# Modules to load
ns_section			"ns/server/${server}/modules" {
	ns_param		revproxy			tcl
	ns_param		nslog				${bindir}/nslog.so
	ns_param		nsshell				tcl
}

# FastPath configuration
ns_section			"ns/server/$server/fastpath" {
	ns_param		pagedir				${pageroot}
	ns_param		directoryfile		"index.adp index.tcl index.html index.htm"
	ns_param		directoryproc		_ns_dirlist
	ns_param		directorylisting	fancy
}

# ADP (AOLserver Dynamic Page) configuration
ns_section			"ns/server/${server}/adp" {
	ns_param		map					/*.adp    ;# Extensions to parse as ADP's
	ns_param		enabletclpages		true
	ns_param		defaultparser		fancy
}

ns_section			"ns/server/${server}/adp/parsers" {
	ns_param		fancy				".adp"
	ns_param		enabledebug			true;
}

# Access log -- nslog
ns_section			"ns/server/${server}/module/nslog" {
	ns_param		file				${homedir}/logs/$server.log
	ns_param		maxbackup			7
	ns_param		logthreadname		true
	ns_param		masklogaddr			true
	ns_param		maskipv4			255.255.255.0
	ns_param		maskipv6			ff:ff:ff:ff::
}

ns_section			"ns/server/${server}/module/nsshell" {
	ns_param		url					/nsshell
	ns_param		kernel_heartbeat	5
	ns_param		kernel_timeout		10
}

ns_section			"ns/server/${server}/module/revproxy" {
	ns_param filters {
		ns_register_filter postauth GET  /shiny/* ::revproxy::upstream -target http://172.17.0.2:80 -regsubs {{/shiny ""}}
		ns_register_filter postauth POST /shiny/* ::revproxy::upstream -target http://172.17.0.2:80
		ns_register_filter postauth GET  /dirty/* ::revproxy::upstream -target http://172.17.0.3:80 -regsubs {{/dirty ""}}
		ns_register_filter postauth POST /dirty/* ::revproxy::upstream -target http://172.17.0.3:80
		ns_register_filter postauth GET  /d/* ::revproxy::upstream -target http://172.17.0.5:80 -regsubs {{/d ""}}
		ns_register_filter postauth POST /d/* ::revproxy::upstream -target http://172.17.0.5:80	
	
	}
}

set ::env(RANDFILE) ${homedir}/.rnd
set ::env(HOME) ${homedir}
set ::env(LANG) en_US.UTF-8



#
# For debugging, you might activate one of the following flags
#
#ns_logctl severity Debug(ns:driver) on
#ns_logctl severity Debug(request) on
#ns_logctl severity Debug(task) on
#ns_logctl severity Debug(sql) on
#ns_logctl severity Debug(nsset) on