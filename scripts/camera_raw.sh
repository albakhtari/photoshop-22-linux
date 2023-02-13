#!/bin/bash

source "./shared.sh"

export WINEPREFIX="$PWD/Ps-prefix/"

sleep 1
print_important "- Downloading Camera Raw installer if not already downloaded..."

if ! [ -f installation_files/CameraRaw_12_2_1.exe ]; then
  curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > installation_files/CameraRaw_12_2_1.exe
elif md5sum --status -c .camera_raw.md5; then
  echo -e "The file CameraRaw_12_2_1.exe is available"
else  
  echo ""
  choice="0"
  read -p "The \"CameraRaw_12_2_1.exe\" file is corrupted, would you like to remove and re-download it? (y/n): " choice
  if [ "$choice" = "y" ]; then
    rm installation_files/CameraRaw_12_2_1.exe
    echo ""
    echo "Removed corrupted file and downloading again..."
    echo ""
    curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > installation_files/CameraRaw_12_2_1.exe
  else
    echo ""
    echo "Aborting installation!"
    echo ""
    exit 1
  fi
fi

print_important "Installing Adobe Camera Raw, please follow the instructions on the installer window...\n"

sleep 1
wine installation_files/CameraRaw_12_2_1.exe
sleep 1


print_important "Adobe Camera Raw installed!"