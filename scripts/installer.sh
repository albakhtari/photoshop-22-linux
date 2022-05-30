#!/bin/bash

export WINEPREFIX="$PWD/Ps-prefix"

echo ""
echo "- Starting Adobe Photoshop CC 2021 (v22) installer..."
echo ""
sleep 1

if [ -d "Ps-prefix" ]; then
  choice="0"
  read -p "A Photoshop installation seems to be present, would you like to override that installation? (y/n): " choice
  if ! [ $choice = "y" ]; then
    echo ""
    echo "Aborting installation!"
    echo ""
    exit 1
  fi
  sleep 1
fi

cameraraw="0"
echo ""
read -p "- Would you like to install Adobe Camera Raw at the end? (y/n): " cameraraw
sleep 1

vdk3d="0"
echo ""
read -p "- Would you like to install vdk3d proton? (y/n): " vdk3d
sleep 1

echo ""
echo "- Making PS prefix..."
sleep 1
rm -rf $PWD/Ps-prefix
mkdir $PWD/Ps-prefix
sleep 1

mkdir -p scripts

echo ""
echo "- Downloading winetricks and making executable if not already so..."
echo ""
sleep 1
wget -nc --directory-prefix=scripts/ https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x scripts/winetricks

sleep 1


echo ""
echo "- Downloading Photoshop files and compnents if not already downloaded..."
echo ""
sleep 1
mkdir -p installation_files

if ! [ -f installation_files/ps_components.tar.xz ]; then
  gdown 1VqIUUzCDuyxOXM-q99ySKEKU_n8DbB26 -O installation_files/ps_components.tar.xz
else
  if md5sum --status -c .ps_components.md5; then
    echo -e "The file ps_components.tar.xz is available"
  else  
    echo ""
    choice="0"
    read -p "The \"ps_components.tar.xz\" file is corrupted, would you like to remove and re-download it? (y/n): " choice
    if [ $choice = "y" ]; then
      rm installation_files/ps_components.tar.xz
      echo ""
      echo "Removed corrupted file and downloading again..."
      echo ""
      gdown 1VqIUUzCDuyxOXM-q99ySKEKU_n8DbB26 -O installation_files/ps_components.tar.xz
    else
      echo ""
      echo "Aborting installation!"
      echo ""
      exit 1
    fi
  fi
fi


if [ $cameraraw = "y" ]; then
  echo ""
  echo "- Downloading Camera Raw installer if not already downloaded..."
  echo ""
  if ! [ -f installation_files/CameraRaw_12_2_1.exe ]; then
    curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > installation_files/CameraRaw_12_2_1.exe
  elif md5sum --status -c .camera_raw.md5; then
    echo -e "The file CameraRaw_12_2_1.exe is available"
  else  
    echo ""
    choice="0"
    read -p "The \"CameraRaw_12_2_1.exe\" file is corrupted, would you like to remove and re-download it? (y/n): " choice
    if [ $choice = "y" ]; then
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
fi

sleep 1

echo ""
echo "- Extracting files..."
echo ""
sleep 1
rm -fr installation_files/Adobe\ Photoshop\ 2021 installation_files/redist installation_files/x64 installation_files/x86
tar -xvf installation_files/ps_components.tar.xz -C installation_files/
sleep 1


echo ""
echo "- Booting & creating new prefix"
echo ""
sleep 1
wineboot
sleep 1

echo ""
echo "- Setting win version to win10"
echo ""
sleep 1
./scripts/winetricks win10
sleep 1

echo ""
echo "- Installing & configuring winetricks components..."
echo ""

./scripts/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk
sleep 1

echo ""
echo "- Installing redist components..."
echo ""

sleep 1

wine installation_files/redist/2010/vcredist_x64.exe /q /norestart
wine installation_files/redist/2010/vcredist_x86.exe /q /norestart
wine installation_files/redist/2012/vcredist_x86.exe /install /quiet /norestart
wine installation_files/redist/2012/vcredist_x64.exe /install /quiet /norestart
wine installation_files/redist/2013/vcredist_x86.exe /install /quiet /norestart
wine installation_files/redist/2013/vcredist_x64.exe /install /quiet /norestart
wine installation_files/redist/2019/VC_redist.x64.exe /install /quiet /norestart
wine installation_files/redist/2019/VC_redist.x86.exe /install /quiet /norestart

sleep 1


if [ $vdk3d = "y" ]; then
  echo ""
  echo "- Installing vdk3d proton..."
  echo ""
  sleep 1
  sh scripts/setup_vkd3d_proton.sh install
  sleep 1
fi

echo ""
echo "- Making PS directory and copying files..."
echo ""

sleep 1

mkdir $PWD/Ps-prefix/drive_c/Program\ Files/Adobe
mv installation_files/Adobe\ Photoshop\ 2021 $PWD/Ps-prefix/drive_c/Program\ Files/Adobe/Adobe\ Photoshop\ 2021

sleep 1

echo ""
echo "- Copying launcher files..."
echo ""

sleep 1
rm -f scripts/launcher.sh
rm -f scripts/photoshop.desktop

echo "#\!/bin/bash
cd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\"
WINEPREFIX=\"$PWD/Ps-prefix\" wine photoshop.exe $1" >> scripts/launcher.sh


echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c '$PWD/scripts/launcher.sh'
Type=Application
Comment=Photoshop CC 2021
Categories=Graphics;2DGraphics;RasterGraphics;Production;
Icon=$PWD/images/photoshop.svg
StartupWMClass=photoshop.exe
MimeType=image/png;image/psd;" >> scripts/photoshop.desktop

chmod +x scripts/launcher.sh
chmod +x scripts/photoshop.desktop

rm -f ~/.local/share/applications/photoshop.desktop
mv scripts/photoshop.desktop ~/.local/share/applications/photoshop.desktop

sleep 1

if [ $cameraraw = "y" ]; then
  echo ""
  echo "- Installing Adobe Camera Raw, please follow the instructions on the installer window..."
  echo ""
  sleep 1
  wine installation_files/CameraRaw_12_2_1.exe
  sleep 1
fi

echo ""
echo "- Adobe Photoshop CC 2021 (v22) has been Installed!"
echo ""
echo -e "Use this command to run Photoshop from the terminal:\n\nbash -c '$PWD/scripts/launcher.sh'"
