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
		cp /usr/lib/libreoffice/program/intro.png /usr/lib/libreoffice/program/intro.png.old
		cp intro.png /usr/lib/libreoffice/program/intro.png
	else
		mkdir libbie_icons
		wget "http://github.com/redsPL/libbieoffice/raw/master/intro.png" -O libbie_icons/intro.png -q
		cp /usr/lib/libreoffice/program/intro.png /usr/lib/libreoffice/program/intro.png.old
		cp libbie_icons/intro.png /usr/lib/libreoffice/program/intro.png
fi
if [[ $1 == "--all" || $2 == "--all" ]]; then
	mkdir libbie_icons
	cd libbie_icons
	mkdir HighContrast 32x32 48x48 64x64 256x256 512x512 HighContrast/24x24 HighContrast/32x32 HighContrast/256x256
	if [[ $1 != "--local" && $2 != "--local" ]]; then
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-base.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-calc.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-draw.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-impress.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-math.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/libreoffice-writer.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-base.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-calc.png -q 
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-draw.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-impress.png -q 
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-math.png -q
		wget http://github.com/redsPL/libbieoffice/raw/master/HighContrast/libreoffice-writer.png -q
	fi
		mogrify *.png -size 32x32 -path 32x32/
		mogrify *.png -size 48x48 -path 48x48/
		mogrify *.png -size 64x64 -path 64x64/
		mogrify *.png -size 256x256 -path 256x256/
		cp *.png 512x512/
		cd HighContrast
		mogrify *.png -size 24x24 -path 24x24/
		mogrify *.png -size 32x32 -path 32x32/
		mogrify *.png -size 256x256 -path 256x256/
	fi
fi