#!/usr/bin/env bash
GH_REPOSITORY="https://github.com/redsPL/libbieoffice"
if [[ $1 == "--help" || $1 == "-h" ]]; then
	printf "libbie.sh - script for replacing LibreOffice images\n"
	printf "libbie.sh needs priviliges to write to files in /usr/\n"
	printf "Syntax:\n"
	printf "./libbie.sh [--splash (name) | --all] [--local]\n"
	printf "Options:\n"
	printf "--splash - replace ONLY splash screen\n"
	printf "--all - replace icons and splash screen\n"
	printf "--local - do not download images; assume files intro.png and libreoffice-[progname].png\n"
	printf "          are in the working directory, HighContrast directory with b/w icons is present,\n"
	printf "			and splash is in the splash directory.\n" # <-- customizeable in the future?
	printf "Splash names:\n"
	printf "default - the original splash with libbie instead of 5\n"
	printf "alt - splash by KarlFish ( http://github.com/KarlFish )\n"
	printf "all - download all splashes, install default. does nothing if executed with --local\n"
fi
if [[ $1 == "--splash" || $2 == "--splash" || $3 == "--splash" || $1 == "--all" || $2 == "--all" || $3 == "--all" ]]; then
	if [[ $1 == "--splash" ]]; then
		splash=$2;
	elif [[ $2 == "--splash" ]]; then
		splash=$3;
	elif [[ $3 == "--splash" ]]; then
		splash=$4;
	else
		splash="default";
	fi
	if [[ $splash == "" ]]; then
		splash="default";
	fi
	if [[ $1 == "--local" || $2 == "--local" || $3 == "--local" ]]; then
		if [[ $splash != "all" ]]; then
			cp "splash/$splash.png" "/usr/lib/libreoffice/program/intro.png"
			printf "Splash should now be installed!\n"
		else
			printf "I've told you, i won't do a thing if executed with --local! :P\n"
		fi
	else
		mkdir libbie_icons libbie_icons/splash
		printf "Downloading splash image(s)...\n"
		if [[ $splash == "all" ]]; then
			wget "$GH_REPOSITORY/raw/master/splash/default.png" -O libbie_icons/splash/default.png -q
			wget "$GH_REPOSITORY/raw/master/splash/alt.png" -O libbie_icons/splash/alt.png -q
			cp libbie_icons/default.png /usr/lib/libreoffice/program/intro.png
		else
			wget "$GH_REPOSITORY/raw/master/splash/$splash.png" -O libbie_icons/splash/$splash.png -q
			cp libbie_icons/$splash.png /usr/lib/libreoffice/program/intro.png
		fi
		printf "Splash should now be installed!\n"
		
fi
if [[ $1 == "--all" || $2 == "--all" || $3 == "--all" ]]; then
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
		cd ..
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
	cd ..
	printf "Copying built-in LO icons.. "
	cp -Rf images_galaxy.zip /usr/share/libreoffice/share/config/images_galaxy.zip
	printf "Done!\n"
	printf "If everything went smoothly, you should have new icons installed.\n"
	printf "Enjoy! :>\n"
	printf "PS: if something crashed, it doesn't mean that installation failed;\n"
	printf "    Some systems don't have icon folders for some resolutions,\n"
	printf "    and that's why some copy errors may occur.\n"
	printf "    Please also make sure that you can write to /usr/, usually sudo will do.\n"
	fi
fi
