#!/bin/bash

source "./shared.sh"

export WINEPREFIX="$PWD/Ps-prefix"

echo ""
print_important "Starting Adobe Photoshop CC 2021 (v22) installer..."
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


print_important "Checking for dependencies..."
sleep 0.5

if ! command -v curl &> /dev/null; then
  echo -e "- '${red}curl${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v wine &> /dev/null; then
  echo -e "- '${red}wine${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v tar &> /dev/null; then
  echo -e "- '${red}tar${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v wget &> /dev/null; then
  echo -e "- '${red}wget${reset}' is MISSING!"
  MISSING=1
  sleep 0.5
fi

if ! command -v gdown &> /dev/null; then
  echo -e "- '${red}gdown${reset}' is MISSING! (To install: \"${yellow}pip3 install gdown${reset}\")"
  MISSING=1
  sleep 0.5
fi

if [[ $MISSING == "1" ]]; then
  echo -e "\n${red}- ERROR:${reset} Please install the missing dependencies and then reattempt the isntallation"
  exit 1
fi

cameraraw="0"
echo ""
read -p "- Would you like to install Adobe Camera Raw at the end? (y/n): " cameraraw
sleep 1

vdk3d="0"
echo ""
read -p "- Would you like to install vdk3d proton? (y/n): " vdk3d
sleep 1

print_important "Making PS prefix..."
sleep 1
rm -rf $PWD/Ps-prefix
mkdir $PWD/Ps-prefix
sleep 1

mkdir -p scripts

print_important "Downloading winetricks and making executable if not already downloaded..."
sleep 1
wget -nc --directory-prefix=scripts/ https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x scripts/winetricks

sleep 1

print_important "Downloading Photoshop files and components if not already downloaded..."
sleep 1
mkdir -p installation_files

if ! [ -f installation_files/ps_components.tar.xz ]; then
  gdown "1esUAZkejzJARub9cessbVeUCDlzzzcQG" -O installation_files/ps_components.tar.xz
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
      gdown "1esUAZkejzJARub9cessbVeUCDlzzzcQG" -O installation_files/ps_components.tar.xz
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
  print_important "Downloading Camera Raw installer if not already downloaded..."
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

print_important "Extracting files..."
sleep 1
rm -fr installation_files/Adobe\ Photoshop\ 2021 installation_files/redist installation_files/x64 installation_files/x86
tar -xvf installation_files/ps_components.tar.xz -C installation_files/
sleep 1


print_important "Booting & creating new prefix"
sleep 1
wineboot
sleep 1

print_important "Setting win version to win10"
sleep 1
./scripts/winetricks win10
sleep 1

print_important "Installing & configuring winetricks components..."
./scripts/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk
sleep 1

print_important "Installing redist components..."
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
    print_important "Installing vdk3d proton..."
    sleep 1
  ./scripts/winetricks vdk3d
  sleep 1
fi

print_important "Making PS directory and copying files..."

sleep 1

mkdir $PWD/Ps-prefix/drive_c/Program\ Files/Adobe
mv installation_files/Adobe\ Photoshop\ 2021 $PWD/Ps-prefix/drive_c/Program\ Files/Adobe/Adobe\ Photoshop\ 2021

sleep 1

print_important "Copying launcher files..."

sleep 1
rm -f scripts/launcher.sh
rm -f scripts/photoshop.desktop

echo "#\!/bin/bash
cd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\"
WINEPREFIX=\"$PWD/Ps-prefix\" wine photoshop.exe $1" > scripts/launcher.sh


echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c '$PWD/scripts/launcher.sh'
Type=Application
Comment=Photoshop CC 2021
Categories=Graphics;2DGraphics;RasterGraphics;Production;
Icon=$PWD/images/photoshop.svg
StartupWMClass=photoshop.exe
MimeType=image/png;image/psd;" > scripts/photoshop.desktop

chmod u+x scripts/launcher.sh
chmod u+x scripts/photoshop.desktop

rm -f ~/.local/share/applications/photoshop.desktop
mv scripts/photoshop.desktop ~/.local/share/applications/photoshop.desktop

sleep 1

if [ $cameraraw = "y" ]; then
    print_important "Installing Adobe Camera Raw, please follow the instructions on the installer window..."
    sleep 1
  wine installation_files/CameraRaw_12_2_1.exe
  sleep 1
fi

print_important "Adobe Photoshop CC 2021 (v22) Installation has been completed!"
echo -e "Use this command to run Photoshop from the terminal:\n\n${yellow}bash -c '$PWD/scripts/launcher.sh'${reset}"