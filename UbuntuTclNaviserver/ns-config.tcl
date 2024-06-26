########################################################################
# Sample configuration file for NaviServer
########################################################################

set			server						[ns_info hostname]
set			server_desc					"NaviServer: ${server}"

set parts [split $server "."]
# Check if there are at least two parts to avoid errors
if {[llength $parts] >= 2} {
	set cert_file [join [lrange $parts end-1 end] "."]
} else {
	set cert_file $server  ;# Fallback to the original server if it doesn't have two parts
}

set			db_host						$::env(DB_HOST_IP) ;# Mother host IP or where Postgres is running (hostname -I), passed in env variable
set			db_port						$::env(DB_PORT)
set			db_user						$::env(DB_USER)
set			db_pass						$::env(DB_PASS)
set			db_name						$::env(DB_NAME)

set			homedir						[file dirname [file dirname [info nameofexecutable]]]
set			bindir						${homedir}/bin
set			pageroot					${homedir}/pages
set			hostname					[ns_info hostname]
set			logdir						${homedir}/logs

set			max_file_upload_mb			50
set			max_file_upload_min			5
set			port						80
set			ssl_port					443
set			ip_addr						[ns_info address]
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
	ns_param			serverlog				${logdir}/error.log
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

ns_section			"ns/fastpath" {
	ns_param			gzip_static				true       ;# check for static gzip; default: false
	ns_param			gzip_refresh			true       ;# refresh stale .gz files on the fly using ::ns_gzipfile
	ns_param			gzip_cmd				"/bin/gzip -9"  ;# use for re-compressing
	ns_param			brotli_static			true       ;# check for static brotli files; default: false
	ns_param			brotli_refresh			true       ;# refresh stale .br files on the fly using ::ns_brotlifile
	ns_param			brotli_cmd				"/usr/bin/brotli -f -Z"  ;# use for re-compressing
}

ns_section			"ns/module/nssock" {
	ns_param			address						$ip_addr
	ns_param			port						$port
	ns_param			hostname					$hostname
	ns_param			defaultserver				${server}
	ns_param			maxinput					[expr {$max_file_upload_mb * 1024 * 1024}]
	ns_param			backlog						1024
	ns_param			acceptsize					10
	ns_param			closewait					0s
	ns_param			keepalivemaxuploadsize		0.5MB
	ns_param			keepalivemaxdownloadsize	1MB
	ns_param			maxupload					10MB
	ns_param			writerthreads				1
	ns_param			recvwait					[expr {$max_file_upload_min * 60}]
}

ns_section			"ns/module/nsssl" {
	ns_param			address						$ip_addr
	ns_param			port						$ssl_port
	ns_param			hostname					$hostname
	ns_param			defaultserver				${server}
	ns_param			certificate					${homedir}/modules/nsssl/${cert_file}.pem
	ns_param			ciphers						"ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305"
	ns_param			protocols					"!SSLv2:!SSLv3:!TLSv1.0:!TLSv1.1"
	ns_param			verify						0
	ns_param			extraheaders {
				Strict-Transport-Security "max-age=31536000; includeSubDomains"
				X-Frame-Options SAMEORIGIN
				X-Content-Type-Options nosniff
	}
	ns_param			maxinput					[expr {$max_file_upload_mb * 1024 * 1024}]
	ns_param			recvwait					[expr {$max_file_upload_min * 60}]
	ns_param			writerthreads				1
    ns_param			writersize					4kB
    ns_param			writerstreaming				true
}

ns_section			"ns/module/nsstats" {
	ns_param			enabled						1
	ns_param			user						"nsadmin"
	ns_param			password					"Pa5sw0rd."
}

# Map headers to server-name
ns_section			"ns/servers" {
	ns_param			${server}					${server_desc}
}

ns_section			"ns/module/nssock/servers" {
	ns_param			${server}					${server}
}

ns_section			"ns/module/nsssl/servers" {
	ns_param			${server}					${server}
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
	ns_param		minthreads			3     ;# default: 1; minimal number of connection threads
	ns_param		maxthreads			100   ;# default: 10; maximal number of connection threads
	ns_param		rejectoverrun		true  ;# default: false; send 503 when thread pool queue overruns
}

# Modules to load
ns_section			"ns/server/${server}/modules" {
	ns_param		nsdb				${bindir}/nsdb.so
	ns_param		nslog				${bindir}/nslog.so
	ns_param		nsfortune			${bindir}/nsfortune.so
	ns_param		nsshell				tcl
}

# Tcl Configuration
ns_section			"ns/server/${server}/tcl" {
	ns_param		library				${pageroot}/tcl
	ns_param		nsvbuckets			16       ;# default: 8
	ns_param		nsvrwlocks			false 
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
	ns_param		enabledebug			true
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

ns_section			"ns/server/${server}/module/nsfortune" {
	ns_param path /usr/share/games/fortunes 
	ns_param line_count 0 
	ns_param text_load 0
}

ns_section			"ns/server/${server}/module/nsshell" {
	ns_param		url					/nsshell
	ns_param		kernel_heartbeat	5
	ns_param		kernel_timeout		10
}

ns_section ns/server/${server}/module/nscp/users {
    ns_param user "::"
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


############################ PostgreSQL configurations ############################
ns_section			"ns/db/drivers" {
	ns_param			postgres					${bindir}/nsdbpg.so
}

# Database
ns_section			"ns/db/pools" {
	ns_param			${server}pool1				"${server} DB_POOL"
}

ns_section			"ns/db/pool/${server}pool1" {
	ns_param			driver					postgres
	ns_param			datasource				${db_host}:${db_port}:${db_name}
	ns_param			user					${db_user}
	ns_param			password				${db_pass}
	ns_param			connections				10
}

ns_section			"ns/server/${server}/db" {
	ns_param			pools					"*"
	ns_param			defaultpool				"${server}pool1"
}