#!/bin/bash

cd ..

export WINEPREFIX=$PWD/Ps-prefix/

echo ""
echo "- Starting Adobe Photoshop CC 2021 (v22) installer..."
echo ""
sleep 1

cameraraw="0"
echo ""
echo "- Would you like to install Adobe Camera Raw at the end?"
read -p "[y/n]: " cameraraw
sleep 1

vdk3d="0"
echo ""
echo "- Would you like to install vdk3d proton?"
read -p "[y/n]: " vdk3d
sleep 1

echo ""
echo "- Making PS prefix..."
echo ""
sleep 1
rm -rf $PWD/Ps-prefix
mkdir $PWD/Ps-prefix/
sleep 1

mkdir -p scripts

echo ""
echo "- Downloading winetricks and making executable if not already so..."
echo ""
sleep 1
wget -nc --directory-prefix=scripts/ https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
if ! [ -f scripts/winetricks ]; then
  chmod +x scripts/winetricks
fi
sleep 1


echo ""
echo "- Downloading Photoshop files and compnents if not already downloaded..."
echo ""
sleep 1
mkdir -p installation_files

if ! [ -f installation_files/ps_components.tar.xz ]; then
  gdown 1VqIUUzCDuyxOXM-q99ySKEKU_n8DbB26 -O installation_files/ps_components.tar.xz
fi
else
  echo -e "The file ps_components.tar.xz exists"
fi


if [ $cameraraw = "y" ]; then
  echo ""
  echo "- Downloading Camera Raw installer if not already downloaded..."
  echo ""
  if ! [ -f installation_files/CameraRaw_12_2_1.exe ]; then
    curl -L "https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe" > installation_files/CameraRaw_12_2_1.exe
  else
    echo -e "The file CameraRaw_12_2_1.exe exists"
    echo ""
  fi
fi

sleep 1

echo ""
echo "- Extracting files..."
echo ""
sleep 1
rm -fr installation_files/redist installation_files/x64 installation_files/x86
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
./installation_files/winetricks win10
sleep 1

echo ""
echo "- Installing & configuring winetricks components..."
echo ""

./installation_files/winetricks fontsmooth=rgb gdiplus msxml3 msxml6 atmlib corefonts dxvk
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
prefix=$PWD/Ps-prefix
pwd=$PWD
rm -f scripts/launcher.sh
rm -f scripts/photoshop.desktop

echo "#!/bin/bash
cd \"/home/myms/Software/01 ADOBE/Linux-PhotoshopCC-v22/PS-Prefix/drive_c/Program Files/Adobe/Adobe Photoshop 2021/\"
WINEPREFIX=\"$prefix\"
wine photoshop.exe $1" >> scripts/launcher.sh


echo "[Desktop Entry]
Name=Photoshop CC
Exec=bash -c \'$PWD/scripts/launcher.sh\'
Type=Application\nComment=Photoshop CC 2021
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
echo -e "Use this command to run Photoshop if the launcher and desktop files don't work, then make your own desktop entry:\n\nbash -c \'$PWD/scripts/launcher.sh\'"
