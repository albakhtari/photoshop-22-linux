#!/bin/bash
export WINEPREFIX="$PWD/Ps-prefix"

red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
yellow=$'\e[1;93m'
white=$'\e[0m'
bold=$'\e[1m'
norm=$'\e[21m'
reset=$'\e[0m'


clear
echo "${bold}-------------- Adobe Photoshop CC 2021 (v22)  installer main menu on Linux --------------${reset}"
echo ""
PS3="
[Choose options 1-6 or 7 to exit]: "
options=("Install Photoshop CC 2021 (v22)" "Uninstall Photoshop CC 2021 (v22)" "Install Adobe Camera Raw Plugin" "Install/Uninstall vdk3d proton" "Configure Photoshop wine prefix (winecfg)"  "Update desktop inegration" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Install Photoshop CC 2021 (v22)")
			echo ""
            bash scripts/installer.sh | tee logs/installer.log
            ;;
        "Uninstall Photoshop CC 2021 (v22)")
            echo ""
			bash scripts/uninstaller.sh | tee logs/uninstaller.log
            ;;
        "Install Adobe Camera Raw Plugin")
            echo ""
			bash scripts/camera_raw.sh | tee logs/camera_raw.log
            ;;
        "Install/Uninstall vdk3d proton")
            choice="u"
            echo ""
            read -p "Would you like to install or uninstall vkd3d proton [i=install u=uninstall]: " choice
            if [[ $choice = "i" ]]
            then
                sh scripts/setup_vkd3d_proton.sh install
                echo ""
                echo "Vdk3d proton installed!"
                echo ""
            elif [[ $choice = "u" ]]
            then
                sh scripts/setup_vkd3d_proton.sh uninstall
                echo ""
                echo "Vdk3d proton uninstalled!"
                echo ""
            else
                echo "Invalid choice: $choice"
            fi
            ;;
		"Configure Photoshop wine prefix (winecfg)")
			echo ""
            echo "Starting winecfg..."
            echo ""
            winecfg | tee logs/winecfg.log
			sleep 1
			;;
		"Update desktop inegration")
            echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c '$PWD/scripts/launcher.sh'
Type=Application
Comment=Photoshop CC 2021
Categories=Graphics;2DGraphics;RasterGraphics;Production;
Icon=$PWD/images/photoshop.svg
StartupWMClass=photoshop.exe
MimeType=image/png;image/psd;" > ~/.local/share/applications/photoshop.desktop

            echo "echo "#\!/bin/bash
cd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\"
WINEPREFIX=\"$PWD/Ps-prefix\" wine photoshop.exe $1" > scripts/launcher.sh

            chmod u+x scripts/launcher.sh
            chmod u+x ~/.local/share/applications/photoshop.desktop
			echo ""
            echo "Desktop entry updated!"
            echo ""
			;;
		"Exit")
			echo ""
            echo "Exiting Photoshop Main Menu."
            break
            ;;
        *) echo "Invalid option: $REPLY";;
    esac
done
