#!/usr/bin/env bash
set -e

WORKDIR=$(dirname $V8_DIR)
cd $WORKDIR

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:$WORKDIR/depot_tools

cd $WORKDIR
rm -rf v8
fetch v8

cd v8
git checkout $V8_VERSION
gclient sync
tools/dev/v8gen.py x64.release -- v8_monolithic=true v8_use_external_startup_data=false use_custom_libcxx=false

cd $V8_DIR/out.gn/x64.release
echo "starting build"
ninja 

cd $WORKDIR

sysOS=`uname -s`
zip -q -r prebuilt-v8-$sysOS-$V8_VERSION.zip v8/include v8/out.gn
mv prebuilt-v8-$sysOS-$V8_VERSION.zip $BUILD_DIR
