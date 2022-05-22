#!/bin/bash

echo -e "**************\nStarting Adobe Photoshop CC 2021 (v22) installer...\n"
sleep 1

cameraraw=0
echo -e "**************\nWould you like to install Adobe Camera Raw at the end?"
read -p "(1 - Yes, 0 - No): " cameraraw
sleep 1

vdk3d=0
echo -e "**************\nWould you like to install vdk3d proton?"
read -p "(1 - Yes, 0 - No): " vdk3d
sleep 1

echo -e "**************\nMaking PS prefix...\n"
sleep 1
rm -rf $PWD/Ps-prefix
mkdir $PWD/Ps-prefix/
sleep 1

echo -e "**************\nDownloading winetricks and making executable if not already so...\n"
sleep 1
wget -nc https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
if ! [ -f installation_files/winetricks ]; then
  chmod +x installation_files/winetricks
fi
sleep 1


echo -e "**************\nDownloading Photoshop files and compnents if not already downloaded...\n"
sleep 1

mkdir -p installation_files

if ! [ -f installation_files/ps_components.tar.xz ]; then
  curl -L "https://www.mediafire.com/file/6o7f7j2a3662oau/ps_components.tar.xz" > installation_files/ps_components.tar.xz
  fi
else
  echo -e "The file ps_components.tar.xz exists"
fi


if [ $cameraraw = 1 ]; then
  echo -e "**************\nDownloading Camera Raw installer if not already downloaded...\n"
  if ! [ -f installation_files/CameraRaw_12_2_1.exe ]; then
    curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > Installers/CameraRaw_12_2_1.exe
  else
    echo -e "The file CameraRaw_12_2_1.exe exists\n"
  fi
fi

if [ $vdk3d = "1" ]; then
  sleep 1
  echo -e "**************\nDownloading vkd3d-proton and making executable if not already so...\n"
  if ! [ -f installation_files/setup_vkd3d_proton.sh ]
    wget -P "https://github.com/HansKristian-Work/vkd3d-proton/blob/master/setup_vkd3d_proton.sh"
    chmod +x installation_files/setup_vkd3d_proton.sh
  else 
    echo -e "The file setup_vkd3d_proton.sh exists"
    sleep 1
  fi
fi

sleep 1

echo -e "**************\nExtracting files...\n"
sleep 1
rm -fr installation_files/redist
tar -xvf installation_files/ps_components.tar.xz -C installation_files/
sleep 1


echo -e "**************\nBooting & creating new prefix\n"
sleep 1
WINEPREFIX=$PWD/Ps-prefix/ wineboot
sleep 1

echo -e "**************\nSetting win version to win10\n"
sleep 1
WINEPREFIX=$PWD/Ps-prefix/ ./installation_files/winetricks win10
sleep 1

echo -e "**************\nInstalling & configuring winetricks components...\n"
WINEPREFIX=$PWD/Ps-prefix/ ./installation_files/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk
sleep 1

echo -e "**************\nInstalling redist components...\n"
sleep 1
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2010/vcredist_x64.exe /q /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2010/vcredist_x86.exe /q /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2012/vcredist_x86.exe /install /quiet /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2012/vcredist_x64.exe /install /quiet /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2013/vcredist_x86.exe /install /quiet /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2013/vcredist_x64.exe /install /quiet /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2019/VC_redist.x64.exe /install /quiet /norestart
WINEPREFIX=$PWD/Ps-prefix/ wine installation_files/redist/2019/VC_redist.x86.exe /install /quiet /norestart
sleep 1


if [ $vdk3d = "1" ]; then
  echo -e "**************\nInstalling vdk3d proton...\n"
  sleep 1
  WINEPREFIX=$PWD/Ps-prefix/ sh Installation_files/setup_vkd3d_proton.sh install
  sleep 1
fi

echo -e "**************\nMaking PS directory and copying files...\n"
sleep 1
mkdir $PWD/Ps-prefix/drive_c/Program\ Files/Adobe
mv installation_files/Adobe\ Photoshop\ 2021 $PWD/Ps-prefix/drive_c/Program\ Files/Adobe/Adobe\ Photoshop\ 2021
sleep 1

echo -e "**************\nCopying launcher files...\n"

sleep 1
prefix=$PWD/Ps-prefix
pwd=$PWD
rm -f launcher.sh
rm -f photoshop.desktop
echo -e "#\!/bin/bash\ncd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\" && WINEPREFIX=\"$prefix\" wine photoshop.exe" >> launcher.sh
echo -e "[Desktop Entry]\nName=Photoshop CC\nExec=bash -c \'cd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\" && WINEPREFIX=\"$prefix\" wine photoshop.exe\'\nType=Application\nComment=Photoshop CC 2021\nCategories=Graphics;2DGraphics;RasterGraphics;GTK;\nIcon=$PWD/Images/photoshop.svg\nStartupWMClass=photoshop.exe\nMimeType=image/png;image/psd;image;" >> photoshop.desktop
chmod +x launcher.sh
chmod +x photoshop.desktop
mv photoshop.desktop ~/.local/share/applications/photoshop.desktop
sleep 1

if [ $cameraraw = "1" ]; then
  echo -e "**************\nInstalling Adobe Camera Raw, please follow the instructions on the installer window...\n"
  sleep 1
  WINEPREFIX=$PWD/Ps-prefix/ wine Installers/CameraRaw_12_2_1.exe
  sleep 1
fi

echo -e "**************\nAdobe Photoshop CC 2021 Installed!\n"
echo -e "Use this command to run Photoshop if the launcher and desktop files don't work, then make your own desktop entry:\n\ncd \"$PWD/Ps-prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\" && WINEPREFIX=\"$prefix\" wine photoshop.exe"
