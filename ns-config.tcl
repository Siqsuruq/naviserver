########################################################################
# Sample configuration file for NaviServer
########################################################################
set port 8000
set address "0.0.0.0"  ;

set home [file dirname [file dirname [info nameofexecutable]]]


########################################################################
# Global settings (for all servers)
########################################################################

ns_section ns/parameters {
    ns_param    home                $home
    ns_param    tcllibrary          tcl
    ns_param    serverlog           error.log
    ns_param formfallbackcharset iso8859-1 ;# retry with this charset in case of failures
    ns_param    jobsperthread       1000     ;# default: 0
    ns_param	joblogminduration   100s     ;# default: 1s
    ns_param    schedsperthread     10       ;# default: 0
}

ns_section ns/threads {
    ns_param    stacksize           512kB
}

ns_section ns/mimetypes {
    ns_param    default             text/plain
    ns_param    noextension         text/plain
}

ns_section ns/fastpath {
    ns_param    gzip_static         true       ;# check for static gzip; default: false
    ns_param    gzip_refresh        true       ;# refresh stale .gz files on the fly using ::ns_gzipfile
    ns_param    gzip_cmd            "/usr/bin/gzip -9"  ;# use for re-compressing
    ns_param    brotli_static       true       ;# check for static brotli files; default: false
    ns_param    brotli_refresh      true       ;# refresh stale .br files on the fly using ::ns_brotlifile
    ns_param    brotli_cmd          "/usr/bin/brotli -f -Z"  ;# use for re-compressing
}

ns_section ns/servers {
    ns_param default "My First NaviServer Instance"
}

#
# Global modules (for all servers)
#
ns_section ns/modules {
    ns_param    nssock              nssock
}

ns_section ns/module/nssock {
    ns_param    defaultserver            default
    ns_param    port                     $port
    ns_param    address                  $address     ;# Space separated list of IP addresses
    ns_param    maxinput                 10MB         ;# default: 1MB, maximum size for inputs (uploads)
    ns_param    backlog                  1024         ;# default: 256; backlog for listen operations
    ns_param    acceptsize               10           ;# default: value of "backlog"; max number of accepted (but unqueued) requests
    ns_param    closewait                0s           ;# default: 2s; timeout for close on socket
    ns_param    keepalivemaxuploadsize   0.5MB        ;# 0, don't allow keep-alive for upload content larger than this
    ns_param    keepalivemaxdownloadsize 1MB          ;# 0, don't allow keep-alive for download content larger than this
    ns_param    maxupload		1MB     ;# default: 0, when specified, spool uploads larger than this value to a temp file
    ns_param    writerthreads		1	;# default: 0, number of writer threads
}

#
# The following section defines, which hostnames map to which
# server. In our case for example, the host "localhost" is mapped to
# the nsd server named "default".
#
ns_section ns/module/nssock/servers {
    ns_param default    localhost
    ns_param default    [ns_info hostname]
}

########################################################################
#  Settings for the "default" server
########################################################################

ns_section ns/server/default {
    ns_param    enabletclpages      true  ;# default: false
    ns_param    checkmodifiedsince  false ;# default: true, check modified-since before returning files from cache. Disable for speedup
    ns_param    connsperthread      1000  ;# default: 0; number of connections (requests) handled per thread
    ns_param    minthreads          5     ;# default: 1; minimal number of connection threads
    ns_param    maxthreads          100   ;# default: 10; maximal number of connection threads
    ns_param    rejectoverrun       true  ;# default: false; send 503 when thread pool queue overruns
}

ns_section ns/server/default/modules {
    ns_param    nslog               nslog
	ns_param	nsfortune			/opt/ns/bin/nsfortune.so
}

ns_section ns/server/default/fastpath {
    #ns_param    pagedir             pages
    #ns_param   serverdir           ""
    #ns_param   directoryfile       "index.adp index.tcl index.html index.htm"
    #ns_param   directoryproc       _ns_dirlist
    ns_param    directorylisting    fancy    ;# default: simple
    #ns_param   directoryadp       dir.adp
}


ns_section ns/server/default/adp {
    ns_param    map                 "/*.adp"
}

ns_section ns/server/default/tcl {
    ns_param    nsvbuckets          16       ;# default: 8
    ns_param    nsvrwlocks          false    ;# default: true
    ns_param    library             modules/tcl
}


ns_section ns/server/default/module/nslog {
    #ns_param   file                access.log
    #ns_param   rolllog             true     ;# default: true; should server log files automatically
    #ns_param   rollonsignal        false    ;# default: false; perform roll on a sighup
    #ns_param   rollhour            0        ;# default: 0; specify at which hour to roll
    ns_param    maxbackup           7        ;# default: 10; max number of backup log files
    #ns_param   rollfmt             %Y-%m-%d-%H:%M	;# format appended to log filename
    #ns_param   logpartialtimes     true     ;# default: false
    #ns_param   logreqtime          true     ;# default: false; include time to service the request
    ns_param    logthreadname       true     ;# default: false; include thread name for linking with error.log

    ns_param	masklogaddr         true    ;# false, mask IP address in log file for GDPR (like anonip IP anonymizer)
    ns_param	maskipv4            255.255.255.0  ;# mask for IPv4 addresses
    ns_param	maskipv6            ff:ff:ff:ff::  ;# mask for IPv6 addresses
}

ns_section "ns/server/default/module/nsfortune" {
	ns_param path /usr/share/games/fortunes 
	ns_param line_count 0 
	ns_param text_load 0
}

ns_section ns/server/default/module/nscp/users {
    ns_param user "::"
}

set ::env(RANDFILE) $home/.rnd
set ::env(HOME) $home
set ::env(LANG) en_US.UTF-8

#
# For debugging, you might activate one of the following flags
#
#ns_logctl severity Debug(ns:driver) on
#ns_logctl severity Debug(request) on
#ns_logctl severity Debug(task) on
#ns_logctl severity Debug(sql) on
#ns_logctl severity Debug(nsset) on
