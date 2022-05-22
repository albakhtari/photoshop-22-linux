# Adobe Photoshop CC 2021 installer for Linux!

![image](https://github.com/YoungFellow-le/Ps-22-Linux/blob/main/Images/screenshot.png)

**DISCLAIMER :**
**Please use this software only if you have an active Photoshop subscription. I'm not responsible for any illegal use of this product.**

This repo used to be a fork of [@MiMillieuh's repo](https://github.com/MiMillieuh/Photoshop-CC2022-Linux) they have GUI installer too. (I find that a terminal script is more transparent and flexible).
However, my changes were too significant to be a fork, so I moved it to my own repo; as I changed the hosted files and there host to my own, and completely re-wrote the installation script.  
## Requirements
- An internet connection
- wine >=6.1 (Avoid 6.20 to 6.22)
- appmenu-gtk-module
- tar
- wget
- curl
- All R/W rights on your home folder and the installer folder
- Vulkan capable GPU or APU (optional)


## How to install:

>_**NOTE:** The total download size, is about 1.6GB_

>_**NOTE 2:** CLONE THIS REPO TO THE FOLDER YOU WANT TO KEEP PHOTOSHOP IN, EVERYTHING TO DO WITH THE PHTOTOSHOP INSTALLATION WILL HAPPEN THERE_

>_**NOTE 3:** THE ONLY FILE THAT WILL BE INSTALLED OUTSIDE THE CLONED FOLDER IS THE DESKTOP ENTRY: ~/.local/share/applications/photoshop.desktop_

Open your terminal and:

```bash
# Clone the repo

git clone https://github.com/YoungFellow-le/Ps-22-Linux.git
cd Ps-22-Linux

# To install:

bash installer.sh

# The installer will ask you if you want to install the Adobe Camera Raw Plugin (that is yes in most cases)
# If you don't want to install it the enter '0', otherwise enter '1' e.g.

"Would you like to install Adobe Camera Raw at the end?
(1 - Yes, 0 - No): 1"

# The installer will also ask you weather you want to install vdk3d proton,
# this utility allows you to use your GPU with wine.

"Would you like to install vdk3d proton?
(1 - Yes, 0 - No): 0"

# However, it can be a bit buggy. There for it's up to you weather to install it or not.
# You can always install it afterwards by running the following command in the "Ps-22-Linux" folder:

WINEPREFIX=$PWD/Ps-prefix/ sh Installation_files/setup_vkd3d_proton.sh install

# And to uninstall:

WINEPREFIX=$PWD/Ps-prefix/ sh Installation_files/setup_vkd3d_proton.sh uninstall


# To uninstall Photoshop:

bash uninstaller.sh

# If you want to completely remove this installer, then delete the cloned folder after running the uninstaller.
```
## Configure Photoshop:
<br>

**1-** Launch Photoshop and go to: `Edit -> preferences -> tools`, and uncheck "_Show Tooltips_" (You will not be able to use any plugins otherwise).

<br>

**2-** **ONLY IF YOU INSTALLED VKD3D PROTON**:  Go to: `Edit -> preferences -> Camera raw... -> performance` and set "_Use graphic processor_" to "_Off_"

<br>

## To change the wine theme to light Windows 10:
  ```bash
  # Navigate to the Photoshop clone folder e.g.
  
  cd ~/Documents/Ps-22-Linux
  
  # Open winecfg
  
  WINEPREFIX=$PWD/Ps-prefix winecfg
  
  # Now navigate to the "Desktop integration" tab and change the theme to "Light"
  
  ```
## How to run Photoshop:

After you run the installer, open your application menu, and search for "Photoshop CC", and click on it. As simple as that!


![image](https://user-images.githubusercontent.com/79008923/169689470-77dd0b17-b93a-4d91-819d-dabd8e9e401c.png)



>_**NOTE:** If you do not find the desktop entry, or if it doesn't work, then run the command that is in the `launcher.sh` file. This command should launch Photoshop for you, or it will at least tell you what the error is. (This command is also printed at the end of the installation)_
