#!/bin/bash
#
# package.sh
#

pkgver='1.0.4-x86_64'

echo "---------------------------------------------"
echo "Building linux release"
echo "---------------------------------------------"

flutter build linux --release

sleep 1

echo "---------------------------------------------"
echo "Removing old files"
echo "---------------------------------------------"

if [ -f AppDir/bibliasacra ]; then
	rm -f AppDir/bibliasacra
fi

if [ -d AppDir/data ]; then
	rm -r AppDir/data
fi
	
if [ -d AppDir/lib ]; then
	rm -r AppDir/lib
fi

if [ -f bibliasacra-${pkgver}.AppImage ]; then
	rm -f bibliasacra-${pkgver}.AppImage
fi

sleep 1

echo "---------------------------------------------"
echo "Copying release to AppDir"
echo "---------------------------------------------"

if [ -f build/linux/x64/release/bundle/bibliasacra ]; then
	cp build/linux/x64/release/bundle/bibliasacra AppDir
fi
if [ -d build/linux/x64/release/bundle/data ]; then
	cp -r build/linux/x64/release/bundle/data AppDir
fi
if [ -d build/linux/x64/release/bundle/lib ]; then
	cp -r build/linux/x64/release/bundle/lib AppDir
fi

sleep 1

echo "---------------------------------------------"
echo "Running appimagetool"
echo "---------------------------------------------"

if [ -f /usr/local/bin/appimagetool ]; then
	appimagetool AppDir/ bibliasacra-${pkgver}.AppImage
fi

sleep 1

echo "---------------------------------------------"
echo "Packaging finished"
echo "---------------------------------------------"
