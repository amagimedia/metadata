#!/bin/bash

set -u
#set -x

#----[globals]------------------------------------------------------------------------

DIRNAME=$(realpath -e $(dirname $0))
MODNAME=$(basename $0)

XPATHS_SPEC_FILE=$DIRNAME/../amgrss_schemas/amgrss_xpaths_description.csv
AMGRSS_MASTER_FILE=$DIRNAME/../amgrss_schemas/amgrss_master.xml

#----[sources]---------------------------------------------------------------

#----[options]---------------------------------------------------------------

OPT_INVERT=0

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

    -i
       invert option. Lists xpaths in $(basename $AMGRSS_MASTER_FILE) 
       not in $(basename $XPATHS_SPEC_FILE).
EOD
}

#----------------------------------------------------------------------------
# MAIN
#----------------------------------------------------------------------------

#+---------------------+
#| argument processing |
#+---------------------+

TEMP=`getopt -o "ih" -n "$0" -- "$@"`
eval set -- "$TEMP"

while true 
do
	case "$1" in
        -i) OPT_INVERT=1; shift ;;
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

if ((OPT_INVERT))
then
    comm -13 $TMP1 $TMP2
else
    comm -23 $TMP1 $TMP2
fi

