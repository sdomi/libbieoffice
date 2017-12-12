#!/usr/bin/env bash
GH_REPOSITORY="https://github.com/redsPL/libbieoffice"
LIBREOFFICE_PROGRAM_DIR=$(dirname $(readlink -f $(which libreoffice)))
LIBREOFFICE_SHARE_DIR=$(dirname $LIBREOFFICE_PROGRAM_DIR)/share
if [[ ! -d $LIBREOFFICE_SHARE_DIR ]]; then
    LIBREOFFICE_SHARE_DIR=/usr/share/libreoffice/share; # Fallback to this directory
fi

for (( i=1; i<7; i++ )); do
	if [[ ${!i} == "--help" || ${!i} == "--icons" || ${!i} == "--theme" || ${!i} == "--local" ]]; then
		j=$(echo ${!i} | cut -c 3-)
		eval $j=true;
	elif [[ ${!i} == "--all" ]]; then
		splash=true;
		splashname="default";
		icons=true;
		theme=true;
	elif [[ ${!i} == "--splash" ]]; then
		splash=true;
		splashName=${!(($i+1))}
	elif [[ ${!i} == "" || !${!i} ]]; then
		break
	else
		echo "Unknown parameter: ${!i} :<"
		break
	fi
done

if [[ $help == true ]]; then
	echo "libbie.sh - script for replacing LibreOffice images"
	echo "libbie.sh needs priviliges to write to files in /usr/"
	echo "Syntax:"
	echo "$0 [--all] [--local] [--splash (name)] [--icons] [--theme]"
	echo "Options:"
	echo "--splash - replace ONLY splash screen OR specify splash to be installed with --all"  #!
	echo "--icons  - replace ONLY icons" # different iconpacks and themes will come soon.
	echo "--theme  - replace ONLY theme"
	echo "--all    - replace icons, splash screen and theme"
	echo "--local  - do not download images; assume files intro.png and libreoffice-[progname].png"
	echo "           are in the working directory, HighContrast directory with b/w icons is present,"
	echo "           and splashes are in the splash directory." # <-- customizeable in the future?
	echo "Splash names:"
	echo "default - LibbieOffice splash supplied by anon from 8ch.net/tech"
	echo "libbie_blue - LibbieOffice splash supplied by the same anon; Blue eye version"
	echo "libbie_no8ch, libbie_blue_no8ch - same as above, but without 8ch watermark"
	echo "libre - the original splash with libbie instead of 5"
	echo "libre_alt - splash by KarlFish ( http://github.com/KarlFish )"
	echo "all - download all splashes, install default. does nothing if executed with --local"
fi

if [[ $splash == true ]]; then
	if [[ $local == true && $splashname != "all" ]]; then
		if [[ $splashname == "" || !$splashname ]]; then
			splashname = "default";
		fi
		cp "splash/$splashname.png" "$LIBREOFFICE_PROGRAM_DIR/intro.png"
		printf "Splash should now be installed!\n"
	else
		mkdir libbie_icons libbie_icons/splash
		printf "Downloading splash image(s)...\n"
		if [[ $splashname == "all" ]]; then
			wget "$GH_REPOSITORY/raw/master/splash/default.png" -O libbie_icons/splash/default.png -q
			wget "$GH_REPOSITORY/raw/master/splash/libbie_blue.png" -O libbie_icons/splash/libbie_blue.png -q
			wget "$GH_REPOSITORY/raw/master/splash/libbie_no8ch.png" - O libbie_icons/splash/libbie_no8ch.png -q
			wget "$GH_REPOSITORY/raw/master/splash/libbie_blue_no8ch.png" - O libbie_icons/splash/libbie_blue_no8ch.png -q
			wget "$GH_REPOSITORY/raw/master/splash/libre.png" - O libbie_icons/splash/libre.png -q
			wget "$GH_REPOSITORY/raw/master/splash/libre_alt.png" - O libbie_icons/splash/libre_alt.png -q
			cp libbie_icons/splash/default.png $LIBREOFFICE_PROGRAM_DIR/libreoffice/program/intro.png
		else
			wget "$GH_REPOSITORY/raw/master/splash/$splash.png" -O libbie_icons/splash/$splash.png -q
			cp libbie_icons/splash/$splash.png $LIBREOFFICE_PROGRAM_DIR/intro.png
		fi
		printf "Splash should now be installed!\n"
	fi
fi
if [[ $theme == true ]]; then
	if [[ $local == true ]]; then
		mkdir libbie_icons libbie_icons/theme
		cd libbie_icons/theme
		printf "Downloading theme(s)...\n0/1\r"
		wget "$GH_REPOSITORY/raw/master/images_galaxy.zip" -q;printf "1/1 (DONE)\n"
	fi
	cp -Rf images_galaxy.zip $LIBREOFFICE_SHARE_DIR/config/images_galaxy.zip
	printf "Built-in icons should now be installed!\n"
fi
if [[ $1 == "--icons" || $2 == "--icons" || $3 == "--icons" || $4 == "--icons" || $5 == "--icons" || $1 == "--all" || $2 == "--all" || $3 == "--all" || $4 == "--all" || $5 == "--all" ]]; then
	if [[ $1 != "--local" && $2 != "--local" && $3 != "--local" ]]; then
		mkdir libbie_icons mkdir libbie_icons/HighContrast
		cd libbie_icons
		printf "Downloading icons...\n"
		wget "$GH_REPOSITORY/raw/master/libreoffice-base.png" -q;printf "1/7.. \r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-calc.png" -q;printf "2/7...\r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-draw.png" -q;printf "3/7.  \r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-impress.png" -q;printf "4/7.. \r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-math.png" -q;printf "5/7...\r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-writer.png" -q;printf "6/7.  \r"
		wget "$GH_REPOSITORY/raw/master/libreoffice-misc.png" -q;printf "7/7 (DONE)\n"
		printf "Downloading High Contrast (B/W) icons...\n0/7\r"
		cd HighContrast
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-base.png" -q;printf "1/7.. \r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-calc.png" -q;printf "2/7...\r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-draw.png" -q;printf "3/7.  \r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-impress.png" -q;printf "4/7.. \r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-math.png" -q;printf "5/7...\r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-writer.png" -q;printf "6/7.  \r"
		wget "$GH_REPOSITORY/raw/master/HighContrast/libreoffice-misc.png" -q;printf "7/7 (DONE)\n"
		cd ..
		printf "Downloading Built-in LibreOffice icons...\n0/1\r"
		wget "$GH_REPOSITORY/raw/master/images_galaxy.zip" -q;printf "1/1 (DONE)\n"
		printf "OK, download done.\n"
	fi
	mkdir HighContrast 32x32 48x48 64x64 256x256 512x512 HighContrast/22x22 HighContrast/24x24 HighContrast/32x32 HighContrast/48x48 HighContrast/256x256 HighContrast/512x512
	printf "Converting icons to...\n"
	printf "32x32\r"
	mogrify -resize 32x32 -path 32x32 *.png
	printf "48x48\r"
	mogrify -resize 48x48 -path 48x48/ *.png
	printf "64x64\r"
	mogrify -resize 64x64 -path 64x64/ *.png
	printf "256x256\r"
	mogrify -resize 256x256 -path 256x256/ *.png
	cp *.png 512x512/
	cd HighContrast
	printf "22x22 (B/W)\r"
	mogrify -resize 22x22 -path 22x22/ *.png
	printf "24x24 (B/W)\r"
	mogrify -resize 24x24 -path 24x24/ *.png
	printf "32x32 (B/W)\r"
	mogrify -resize 32x32 -path 32x32/ *.png
	printf "256x256 (B/W)\n"
	mogrify -resize 256x256 -path 256x256/ *.png
	cp *.png 512x512/
	printf "Conversion done.\n"
	printf "Copying color icons.. "
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
	printf "Done.\n"
	printf "Copying B/W icons.. "
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
	cd ../
	printf "Done.\n"
	printf "Copying icons to mimetypes (this may take a while)...\n"
	res="32x32"
	type="hicolor"
	while true; do
		cd "../"$res"/" # \/ THESE SHOULD BE ln -s
		cp libreoffice-draw.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-drawing-template.png"
		cp libreoffice-writer.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-text-template.png"
		cp libreoffice-impress.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-presentation.png"
		cp libreoffice-math.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-formula.png"
		cp libreoffice-impress.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-presentation.png"
		cp libreoffice-misc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-master-document.png"
		cp libreoffice-math.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-formula.png"
		cp libreoffice-calc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-spreadsheet.png"
		cp libreoffice-writer.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-text.png"
		cp libreoffice-misc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-extension.png"
		cp libreoffice-writer.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-text-template.png"
		cp libreoffice-misc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-master-document.png"
		cp libreoffice-base.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-database.png"
		cp libreoffice-misc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-web-template.png"
		cp libreoffice-calc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-spreadsheet-template.png"
		cp libreoffice-draw.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-drawing.png"
		cp libreoffice-writer.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-text.png"
		cp libreoffice-draw.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-drawing-template.png"
		cp libreoffice-impress.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-presentation-template.png"
		cp libreoffice-draw.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-drawing.png"
		cp libreoffice-base.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-database.png"
		cp libreoffice-calc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-spreadsheet.png"
		cp libreoffice-calc.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-spreadsheet-template.png"
		cp libreoffice-impress.png "/usr/share/icons/"$type"/"$res"/mimetypes/libreoffice-oasis-presentation-template.png"
		if [[ $res == "32x32" ]]; then
			res="48x48";
		elif [[ $res == "48x48" ]]; then
			res="64x64";
		elif [[ $res == "64x64" ]]; then
			res="256x256";
		elif [[ $res == "256x256" ]]; then
			res="512x512";
		elif [[ $res == "512x512" ]]; then
			if [[ $type == "hicolor" ]]; then
				type="gnome";
				res="32x32";
			elif [[ $type == "gnome" ]]; then
				break
			fi
		fi
	done
	printf "If everything went smoothly, you should have new icons installed.\n"
	printf "Enjoy! :>\n"
	printf "PS: if something crashed, it doesn't mean that installation failed;\n"
	printf "    Some systems don't have icon folders for some resolutions,\n"
	printf "    and that's why some copy errors may occur.\n"
	printf "    Please also make sure that you can write to /usr/, usually sudo will do.\n"
fi

