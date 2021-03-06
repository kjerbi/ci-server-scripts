#!/bin/bash

[ ! -d "$1" ] && echo "First argument must be the working directory" && exit 1
[ -z "$BUILDTYPE" ] && export BUILDTYPE="tests"

export ORCCWORK="$1"

ECLIPSEVERSION=kepler
# Used to download the base platform version of eclipse
export ECLIPSEURL="http://eclipse.ialto.com/eclipse/downloads/drops4/R-4.3-201306052000/eclipse-platform-4.3-linux-gtk-x86_64.tar.gz"
# Used to download dependencies (both runtime and build eclipse)
export ECLIPSEREPOSITORY=http://download.eclipse.org/releases/$ECLIPSEVERSION

export ECLIPSERUN=$ORCCWORK/eclipse.runtime
export ECLIPSEBUILD=$ORCCWORK/eclipse.build

export BUILDDIR=$ORCCWORK/build.dir.$BUILDTYPE
export PLUGINSDIR=$BUILDDIR/plugins
export FEATURESDIR=$BUILDDIR/features

ECLIPSECP=`echo $ECLIPSEBUILD/plugins/*.jar | sed -e "s/ /:/g"`

# Classpath for MWE2 generation
MWECP=$ECLIPSECP:`echo $ORCCWORK/antlr-generator-*.jar | sed -e "s/ /:/g"`
MWECP=$MWECP:$PLUGINSDIR/net.sf.orcc.cal/src:$PLUGINSDIR/net.sf.orcc.cal.ui/src
export MWECP

# Classpath for Xtend generation
XTENDCP=$ECLIPSECP:$PLUGINSDIR/org.jgrapht
for i in `ls $PLUGINSDIR`
do
	[ -d "$PLUGINSDIR/$i/src" ] && XTENDCP=$XTENDCP:$PLUGINSDIR/$i/src
	[ -d "$PLUGINSDIR/$i/src-gen" ] && XTENDCP=$XTENDCP:$PLUGINSDIR/$i/src-gen
done
export XTENDCP
