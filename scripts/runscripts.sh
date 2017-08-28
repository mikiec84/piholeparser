#!/bin/bash
## This is the central script that ties the others together

## Variables
SCRIPTBASEFILENAME=$(echo `basename $0 | cut -f 1 -d '.'`)
script_dir=$(dirname $0)
SCRIPTVARSDIR="$script_dir"/scriptvars/
STATICVARS="$SCRIPTVARSDIR"staticvariables.var
if
[[ -f $STATICVARS ]]
then
source $STATICVARS
else
echo "Static Vars File Missing, Exiting."
exit
fi
if
[[ -f $SUBMAINVAR ]]
then
source $SUBMAINVAR
else
echo "Sub Main Vars File Missing, Exiting."
exit
fi

## Run Logs
if
[[ -f $RUNLOGSCRIPT ]]
then
bash $RUNLOGSCRIPT
fi

## Logo
if
[[ -f $AVATARSCRIPT ]]
then
bash $AVATARSCRIPT
else
echo "Deathbybandaid Logo Missing."
fi

echo ""

## Start File Loop
## For .sh files In The mainscripts Directory
for f in $ALLTOPLEVELSCRIPTS
do

LOOPSTART=$(date +"%s")

## Loop Vars
BASEFILENAME=$(echo `basename $f | cut -f 1 -d '.'`)
BASEFILENAMENUM=$(echo $BASEFILENAME | sed 's/[0-9]//g')
BASEFILENAMEDASHNUM=$(echo $BASEFILENAME | sed 's/[0-9\-]/ /g')
BNAMEPRETTYSCRIPTTEXT=$(echo $BASEFILENAMEDASHNUM)
TAGTHEREPOLOG="[Details If Any]("$TOPLEVELLOGSDIRRAW""$BASEFILENAME".md)"
BREPOLOG="$TOPLEVELLOGSDIR""$BASEFILENAME".md
timestamp=$(echo `date`)

printf "$blue"    "$DIVIDERBAR"
echo ""
printf "$cyan"   "$BNAMEPRETTYSCRIPTTEXT $timestamp"

## Log Section
echo "## $BNAMEPRETTYSCRIPTTEXT $timestamp" | tee --append $RECENTRUNA &>/dev/null

## Create Log
if
[[ -f $BREPOLOG ]]
then
rm $BREPOLOG
fi
echo "# $BNAMEPRETTYSCRIPTTEXT" | tee --append $BREPOLOG &>/dev/null
echo "" | tee --append $BREPOLOG

## Clear Temp Before
if
[[ -f $DELETETEMPFILE ]]
then
bash $DELETETEMPFILE
else
echo "Error Deleting Temp Files."
exit
fi

## Run Script
bash $f

## Clear Temp After
if
[[ -f $DELETETEMPFILE ]]
then
bash $DELETETEMPFILE
else
echo "Error Deleting Temp Files."
exit
fi

LOOPEND=$(date +"%s")

DIFFTIMELOOPSEC=`expr $LOOPEND - $LOOPSTART`
DIFFTIMELOOP=`expr $DIFFTIMESEC / 60`

if
[[ $DIFFTIMELOOPSEC -ge 60 && $DIFFTIME -gt 0 ]]
then
LOOPTIMEDIFF="$DIFFTIMELOOP Minutes."
elif
[[ $DIFFTIMELOOPSEC -lt 60 && $DIFFTIME -eq 0 ]]
then
LOOPTIMEDIFF="$DIFFTIMELOOPSEC Seconds."
fi

echo "Process Took $LOOPTIMEDIFF" | sudo tee --append $RECENTRUNA &>/dev/null
echo "$TAGTHEREPOLOG" | sudo tee --append $RECENTRUNA &>/dev/null
echo "" | sudo tee --append $RECENTRUNA

printf "$magenta" "$DIVIDERBAR"
echo ""

## End Of Loop
done
