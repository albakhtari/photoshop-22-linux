#!/bin/bash

choice="0"
echo ""
read -p "Are you sure you want to uninstall Adobe Photoshop? (y/n): " choice

if [ "$choice" = "y" ]
then
    rm -rf Ps-prefix
    rm -rf  ~/.local/share/applications/photoshop.desktop
    echo ""
    echo "Photoshop uninstalled!"
    echo ""
elif [ "$choice" = "n" ]
then
    echo ""
    echo "Uninstallation canceled!"
    echo ""
else
    echo ""
    echo "Invalid input, exiting Adobe Photoshop uninstaller!"
    echo ""
fi

