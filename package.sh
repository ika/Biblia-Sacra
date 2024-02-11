#!/bin/bash
#
# package.sh
#
echo "---------------------------------------------\n"
echo "Building linux release\n"
echo "---------------------------------------------\n"

flutter build linux --release

sleep 1

echo "---------------------------------------------\n"
echo "Removing old files\n"
echo "---------------------------------------------\n"

if [ -f AppDir/bibliasacra ]; then
	rm -f AppDir/bibliasacra
fi

if [ -d AppDir/data ]; then
	rm -r AppDir/data
fi
	
if [ -d AppDir/lib ]; then
	rm -r AppDir/lib
fi

if [ -f bibliasacra.AppImage ]; then
	rm -f bibliasacra.AppImage
fi

if [ -f bibliasacra.tar.gz ]; then
	rm -f bibliasacra.tar.gz
fi

sleep 1
echo "---------------------------------------------\n"
echo "Copying release to AppDir\n"
echo "---------------------------------------------\n"

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

echo "---------------------------------------------\n"
echo "Running appimagetool\n"
echo "---------------------------------------------\n"

if [ -f /usr/local/bin/appimagetool ]; then
	appimagetool AppDir/ bibliasacra.AppImage
fi

sleep 1

echo "---------------------------------------------\n"
echo "tar and gzipinf\n"
echo "---------------------------------------------\n"

if [ -f bibliasacra.AppImage ]; then
	tar -czvf bibliasacra.tar.gz bibliasacra.AppImage
fi

sleep 1

echo "---------------------------------------------\n"
echo "Packaging finished\n"
echo "---------------------------------------------\n"
