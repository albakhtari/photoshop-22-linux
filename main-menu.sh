#!/bin/bash
clear
echo "-------------- Adobe Photoshop CC 2021 (v22)  installer main menu on Linux --------------"
echo ""
PS3="
[Choose options 1-6 or 7 to exit]: "
options=("Install Photoshop CC 2021 (v22)" "Uninstall Photoshop CC 2021 (v22)" "Install Adobe Camera Raw Plugin" "Install/Uninstall vdk3d proton" "Configure Photoshop wine prefix (winecfg)"  "Update desktop inegration" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "Install Photoshop CC 2021 (v22)")
			echo ""
            bash scripts/installer.sh
            ;;
        "Uninstall Photoshop CC 2021 (v22)")
            echo ""
			bash scripts/uninstaller.sh
            ;;
        "Install Adobe Camera Raw Plugin")
            echo ""
			bash scripts/camera_raw.sh
            ;;
        "Install/Uninstall vdk3d proton")
            choice="u"
            echo ""
            read -p "Would you like to install or uninstall vkd3d proton [i=install u=uninstall]: " choice
            if [[ $choice = "i" ]]
            then
                WINEPREFIX=Ps-prefix/ sh scripts/setup_vkd3d_proton.sh install
                echo ""
                echo "Vdk3d proton installed!"
                echo ""
            elif [[ $choice = "u" ]]
            then
                WINEPREFIX=Ps-prefix/ sh scripts/setup_vkd3d_proton.sh uninstall
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
            WINEPREFIX=Ps-prefix/ winecfg
			sleep 1
			;;
		"Update desktop inegration")
            rm -f ~/.local/share/applications/photoshop.desktop
            echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c \'cd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\" && WINEPREFIX=\"$prefix\" wine photoshop.exe\'
Type=Application\nComment=Photoshop CC 2021
Categories=Graphics;2DGraphics;RasterGraphics;Production;
Icon=$PWD/Images/photoshop.svg
StartupWMClass=photoshop.exe
MimeType=image/png;image/psd;" >> ~/.local/share/applications/photoshop.desktop
            chmod +x ~/.local/share/applications/photoshop.desktop
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