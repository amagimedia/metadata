#!/bin/bash

set -u
#set -x

#----[globals]------------------------------------------------------------------------

DIRNAME=$(readlink -e $(dirname $0))
MODNAME=$(basename $0)

XPATHS_SPEC_FILE=$DIRNAME/../amgrss_schemas/amgrss_xpaths_description.csv
AMGRSS_MASTER_FILE=$DIRNAME/../amgrss_schemas/amgrss_master.xml

#----[sources]---------------------------------------------------------------

#----[options]---------------------------------------------------------------

#----[temp files and termination]--------------------------------------------

function fnxOnEnd
{
    rm -f $TMP1 $TMP2
}

TMP1=`mktemp`
TMP2=`mktemp`

trap 'fnxOnEnd;' 0 1 2 3 6 9 11

#----[helper functions]------------------------------------------------------

function usage
{
    cat <<EOD
NAME

    $MODNAME - Checks coverage of $(basename $AMGRSS_MASTER_FILE) against
    $(basename $XPATHS_SPEC_FILE).
                   
SYNOPSIS

    $MODNAME [-h]
    
DESCRIPTION

    Lists xpaths in $(basename $XPATHS_SPEC_FILE) not present in
    $(basename $AMGRSS_MASTER_FILE) to stdout.
    The goal is to have zero xpaths listed out.

OPTIONS

    -h
       displays help and quits.
EOD
}

#----------------------------------------------------------------------------
# MAIN
#----------------------------------------------------------------------------

#+---------------------+
#| argument processing |
#+---------------------+

TEMP=`getopt -o "h" -n "$0" -- "$@"`
eval set -- "$TEMP"

while true 
do
	case "$1" in
        -h) usage; exit 0;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done

#+------+
#| main |
#+------+

XPATHS_SPEC_FILE=$DIRNAME/../amgrss_schemas/amgrss_xpaths_description.csv
AMGRSS_MASTER_FILE=$DIRNAME/../amgrss_schemas/amgrss_master.xml

cat $XPATHS_SPEC_FILE | sed '1d' | gawk -F ',' '{ print $1; }' | sort | uniq > $TMP1
#cat $TMP1

xmlstarlet el -a $AMGRSS_MASTER_FILE | sort | uniq | sed 's/^/\//' > $TMP2
#cat $TMP2

comm -23 $TMP1 $TMP2

