#!/bin/bash
if [[ $1 == "--help" || $1 == "-h" ]]; then
	echo "libbie.sh - script for replacing LibreOffice images"
	echo "libbie.sh needs priviliges to write to files in /usr/";echo "" # <-- too lazy to check how to do it properly
	echo "Syntax:"
	echo "./libbie.sh [--splash | --all] [--local]";echo ""
	echo "Options:"
	echo "--splash - replace ONLY splash screen"
	echo "--all - replace icons and splash screen"
	echo "--local - do not download images; assume files intro.png and libreoffice-[progname].png"
	echo "          are in the working directory, and HighContrast directory with b/w icons is present." # <-- customizeable in the future?
fi
if [[ $1 == "--splash" || $2 == "--splash" || $1 == "--all" || $2 == "--all" ]]; then
	if [[ $1 == "--local" || $2 == "--local" ]]; then
		cp intro.png /usr/lib/libreoffice/program/intro.png
		cp intro.png.1 /usr/lib/libreoffice/program/intro.png # too lazy for an if
	else
		mkdir libbie_icons
		wget "http://github.com/redsPL/libbieoffice/raw/master/intro.png" -O libbie_icons/intro.png -q
		cp libbie_icons/intro.png /usr/lib/libreoffice/program/intro.png
		echo "Splash should now be installed!"
fi
if [[ $1 == "--all" || $2 == "--all" ]]; then
	if [[ $1 != "--local" && $2 != "--local" ]]; then
		mkdir libbie_icons
		cd libbie_icons
		mv intro.png intro.png.1
		mkdir HighContrast 32x32 48x48 64x64 256x256 512x512 HighContrast/22x22 HighContrast/24x24 HighContrast/32x32 HighContrast/48x48 HighContrast/256x256 HighContrast/512x512
		echo "Downloading icons..."
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-base.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-calc.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-draw.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-impress.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-math.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-writer.png -q
		echo "Downloading High Contrast (B/W) icons..."
		cd HighContrast
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-base.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-calc.png -q 
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-draw.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-impress.png -q 
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-math.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-writer.png -q
		echo "OK, download done."
		cd ..
	fi
		echo "Converting icons to..."
		echo "32x32"
		mogrify -resize 32x32 -path 32x32 *.png
		echo "48x48"
		mogrify -resize 48x48 -path 48x48/ *.png
		echo "64x64"
		mogrify -resize 64x64 -path 64x64/ *.png
		echo "256x256"
		mogrify -resize 256x256 -path 256x256/ *.png
		cp *.png 512x512/
		cd HighContrast
		echo "22x22 (B/W)"
		mogrify -resize 22x22 -path 22x22/ *.png
		echo "24x24 (B/W)"
		mogrify -resize 24x24 -path 24x24/ *.png
		echo "32x32 (B/W)"
		mogrify -resize 32x32 -path 32x32/ *.png
		echo "256x256 (B/W)"
		mogrify -resize 256x256 -path 256x256/ *.png
		cp *.png 512x512/
		echo "Conversion done."
		echo "Copying color icons.."
		cd ../32x32
		cp -Rf *.png /usr/share/icons/hicolor/32x32/apps/
		cp -Rf *.png /usr/share/icons/hicolor/32x32/mimetypes/
		cd ../48x48
		cp -Rf *.png /usr/share/icons/hicolor/48x48/apps/
		cd ../64x64
		cp -Rf *.png /usr/share/icons/hicolor/64x64/apps/
		cd ../256x256
		cp -Rf *.png /usr/share/icons/hicolor/256x256/apps/
		cd ../512x512
		cp -Rf *.png /usr/share/icons/hicolor/512x512/apps/
		echo "Copying B/W icons.."
		cd ../HighContrast/22x22
		cp -Rf *.png /usr/share/icons/HighContrast/22x22/apps/
		cd ../24x24
		cp -Rf *.png /usr/share/icons/HighContrast/24x24/apps/
		cd ../32x32
		cp -Rf *.png /usr/share/icons/HighContrast/32x32/apps/
		cd ../48x48
		cp -Rf *.png /usr/share/icons/HighContrast/48x48/apps/
		cd ../256x256
		cp -Rf *.png /usr/share/icons/HighContrast/256x256/apps/
		cd ../512x512
		cp -Rf *.png /usr/share/icons/HighContrast/512x512/apps/
		echo "If everything went smoothly, you should have new icons installed."
		echo "Enjoy! :>"
	fi
fi