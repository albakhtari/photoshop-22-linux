# Adobe Photoshop CC 2021 installer for Linux!

![image](https://github.com/YoungFellow-le/photoshop-22-linux/blob/main/images/screenshot.png)

## DISCLAIMER:
**Please use this software only if you have an active Photoshop subscription. I'm not responsible for any illegal use of this product.**

## Requirements
- An internet connection
- All **read** and **write** rights on your home folder and the folder of installation
- `git`
- `wine` >=6.1 (Avoid 6.20 to 6.22)
- `gdown` - required to download the Photoshop components (To install: `pip install gdown`)
- `tar`
- `wget`
- `curl`
- Vulkan capable GPU or APU _(optional)_
- `appmenu-gtk-module` _(optional)_


## Installation guide:

>_**NOTE:** The total download size, is around 1.6GB_

>_**NOTE 2:** CLONE THIS REPO TO THE FOLDER YOU WANT TO KEEP PHOTOSHOP IN, EVERYTHING TO DO WITH THE PHTOTOSHOP INSTALLATION WILL HAPPEN THERE_

>_**NOTE 3:** THE ONLY FILE THAT WILL BE INSTALLED OUTSIDE THE CLONED FOLDER IS THE DESKTOP ENTRY: ~/.local/share/applications/photoshop.desktop_

Open your terminal and:

```bash
# Clone the repo

git clone https://github.com/YoungFellow-le/photoshop-22-linux.git
cd photoshop-22-linux

# Run the main-menu file:

./main-menu.sh

# In the main menu, you will see these options:

"
-------------- Adobe Photoshop CC 2021 (v22)  installer main menu on Linux --------------

1) Install Photoshop CC 2021 (v22)            5) Configure Photoshop wine prefix (winecfg)
2) Uninstall Photoshop CC 2021 (v22)          6) Update desktop integration
3) Install Adobe Camera Raw Plugin            7) Exit
4) Install/Uninstall vdk3d proton

[Choose options 1-6 or 7 to exit]:
"
# To install photoshop select option "1"
# The installer will ask you if you want to install the Adobe Camera Raw Plugin (that is yes in most cases)
# If you don't want to install it the enter 'y', otherwise enter 'n' (You can install it later from the menu if you like) e.g.

"Would you like to install Adobe Camera Raw at the end?
(y/n): y"

# The installer will also ask you weather you want to install vdk3d proton,
# this utility allows you to use your GPU with wine.

"Would you like to install vdk3d proton?
(y/n): n"

# However, it can be a bit buggy. Therefore it's up to you weather to install it or not.
# You can always install it afterwards by selecting option "4":

"[Choose options 1-6 or 7 to exit]: 4

Would you like to install or uninstall vkd3d proton [i=install u=uninstall]: i"

# And after the installer does it's stuff...

"Vdk3d proton installed!"

# And to uninstall:

"[Choose options 1-6 or 7 to exit]: 4

Would you like to install or uninstall vkd3d proton [i=install u=uninstall]: u"

# And after the installer does it's stuff...

"Vdk3d proton uninstalled!"


# To uninstall Photoshop:

"[Choose options 1-6 or 7 to exit]: 2

Are you sure you want to uninstall Adobe Photoshop? (y/n): y

Photoshop uninstalled!"

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
  # Navigate to the Photoshop clone folder and start the main menu e.g.
  
  cd ~/Documents/photoshop-22-linux
  ./main-menu.sh
  
  # And select option 5
  
  "[Choose options 1-6 or 7 to exit]: 5"
  
  # Now navigate to the "Desktop integration" tab and change the theme to "Light"
  
  ```
## How to run Photoshop:

After you run the installer, open your application menu, and search for "Photoshop CC", and click on it. As simple as that!


![image](https://user-images.githubusercontent.com/79008923/169689470-77dd0b17-b93a-4d91-819d-dabd8e9e401c.png)



>_**NOTE:** If you do not find the desktop entry, or if it doesn't work, then run the`launcher.sh` file. This command should launch Photoshop for you, or it will at least tell you what the error is. (This command is also printed at the end of the installation)_

## To-Do:

- [x] Add a sum verification for large downloaded files (`ps_components.tar.xz` `CameraRaw_12_2_1.exe`)

- [x] Check wether Photoshop is installed before installing (does the "_Ps-prefix_" folder exist?)

- [ ] Check that components are installed in the installer

- [ ] Sort out the "open with" issue

## CREDITS

+ All credit goes to [MiMillieuh](https://github.com/MiMillieuh) for finding the components that make Photoshop run using `wine`.
+ I only take credit for creating the installer itself, not for any testing or experimenting.
