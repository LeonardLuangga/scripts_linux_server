#!/bin/sh
#
# cr8-svn.sh (not yet completed)
# ==============================
# Copyright (c) Leonard Luangga


if [ "$(id -u)" != "0" ]; then
   echo 'This script must be run as root!'
   exit 1
fi


usage() {
  cat << EOF
	usage: $0 options

	OPTIONS:
	   -h   Show this message
	   -s   SVN Path
	   -f   Auth Filename   
	   -u   Auth Username (Must Be a Valid User)
	   -p   Auth Password
	   -v   Verbose
	EOF
}


SVNPATH=
AUTHFILE=
AUTHUSER=
AUTHPASS=
CONFIGFILE=
VERBOSE=


while getopts ":s:f:u:p:c h v" OPTION
do
	case $OPTION in
	h)
		usage
		exit 1
		;;
	s)
		SVNPATH=$OPTARG
		;;
	f)
		AUTHFILE=$OPTARG
		;;
	u)
		AUTHUSER=$OPTARG
		;;
	p)
		AUTHPASS=$OPTARG
		;;
	c)
		CONFIGFILE=$OPTARG
		;;
	v)
		VERBOSE=1
		;;
	?)
		usage
		exit
		;;
	esac
done


if [[ -z $SVNPATH ]] || [[ -z $AUTHFILE ]] || [[ -z $AUTHUSER ]] || [[ -z $AUTHPASS ]] || [[ -z $CONFIGFILE ]]; then
     usage
     exit 1
fi


sed '/</VirtualHost>/ i\
<Location /svn>
	DAV svn
	SVNPath $SVNPATH
	AuthType Basic
	AuthName "Subversion Repository"
	AuthUserFile $SVNPATH/$AUTHFILE
	Require valid-user
</Location>
' $CONFIGFILE


svnadmin create $SVNPATH
htpasswd -cm $SVNPATH/$AUTHFILE $AUTHUSER && $AUTHPASS
chown -R $AUTHUSER:$AUTHUSER $SVNPATH
service httpd restart
