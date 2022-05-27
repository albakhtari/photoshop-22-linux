#!bin/bash

cd ..
export WINEPREFIX="$PWD/Ps-prefix/"

sleep 1
echo ""
echo "- Starting Adobe Camera Raw installer..."
sleep 1

echo ""
echo "- Downloading Camera Raw installer if not already downloaded...\n"
if ! [ -f installation_files/CameraRaw_12_2_1.exe ]; then
  curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > Installers/CameraRaw_12_2_1.exe
else
  echo -e "The file CameraRaw_12_2_1.exe exists\n"
fi

echo ""
echo "- Installing Adobe Camera Raw, please follow the instructions on the installer window...\n"

sleep 1
wine installation_files/CameraRaw_12_2_1.exe
sleep 1

echo ""
echo "Adobe Camera Raw installed!"
echo ""