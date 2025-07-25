# Halmak Keyboard Layout for Linux

## Key Mapping Note
Given a personal preference, this version of the Halmak keyboard layout uses `<` and `>` with `,` and `.` respectively, instead of the alternative mappings for `(` and `)` or other setups. Another note is that the CapsLock has been replaced by a secondary Backspace, given the original Halmak design philosophy and realizaiton that no one uses it. (I should probably work on adding either as an options in the script)

![keyboard-layout](https://github.com/user-attachments/assets/c3442835-49e3-4f10-b180-ca0feb915fe7)

## Script Details:
The lastest version of the script will install the required fires for the layout in a newly created directory under /home/.config/xkb.
there are different versions of the script in the repo that use different methods:
```
halmak-linux/
├── contains the files used by the default linux_halmak.sh installer script.
halmak-mutable/
├── contains a script that installs the keyboard layout by editing the '/usr/share/X11/xkb/' directory.
halmak-immutable/
├── contains a script that detects a select set of immutable and mutable distros and installs 
│   the files inside '/home/.config/xkb/' or '/usr/share/X11/xkb/' respectively.
halmak-nix/
├── contains a configuration file that can be imported to your configuration.nix,
│   which edits the xkb rules of your NixOS system.
halmak-kanata/
├── contains a kanata kbd file that has a one-layer remap of the layout for your kanata-enabled system.
halmak-osx/
└── contains a Halmak.bundle file for installation on OSX systems.
```

## Additional Packages
I have included OSX keyboard bundle files alongside the Linux files if you also want to install it on a Mac (though take into account that this version has `(` and `)` with `,` and `.` respectively, like traditionally.

## Installation Instructions

### ✅ Tested Environments

#### Desktop Environments (DEs)

| Desktop Environment | Status        | Notes                                   |
| ------------------- | ------------- | --------------------------------------- |
| **KDE (Wayland)**   | ✅ Working     | —                                       |
| **KDE (X11)**       | ❌ Not Working | Use the `halmak-mutable` script instead |
| **GNOME (Wayland)** | ✅ Working     | —                                       |
| **GNOME (X11)**     | ❌ Not Working | Use the `halmak-mutable` script instead |
| **Hyprland**        | ✅ Working     | —                                       |
| **LXQt**            | ✅ Working     | —                                       |
| **DDE (Deepin)**    | ✅ Working     | —                                       |

#### Linux Distributions

| Linux Distribution     | Status               | Notes                                                                                                                                              |
| ---------------------- | -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fedora 40–42**       | ✅ Working            | —                                                                                                                                                 |
| **Debian 11–13**       | ✅ Working            | —                                                                                                                                                 |
| **NixOS 24.05–25.11**  | ✅ Working            | —                                                                                                                                                 |
| **VanillaOS 2 Orchid** | ✅ Working            | —                                                                                                                                                 |
| **Bazzite**            | ✅ Working            | —                                                                                                                                                 |
| **Deepin 25**          | ✅ Working            | —                                                                                                                                                 |
| **Red Hat 10**         | ✅ Working            | —                                                                                                                                                 |
| **Ubuntu 25.04**       | ✅ Working            | —                                                                                                                                                 |
| **SteamOS**            | ❌ Not Working        | Default script runs but doesn’t work due to X11. On Wayland it works, **but virtual keyboard and trackpad may stop working** (not script-related) |
| **openSUSE**           | ⚠️ Partially Working  | Only works after switching to Wayland; on X11, use `halmak-mutable`                                                                               |

  
### Automated Installation:

1. Download this project's files.

2. Open a terminal and navigate to the directory where the files are located.

3. Run the installation script with root privileges:
   ```bash
   sh ./install_halmak.sh
   ```
   no need to run in `sudo` as this will add the files to the root user instead.

4. Restart your computer to apply the changes. (not always necessary)

5. After restarting, open your system's keyboard settings, add a new input source, select 'Other', and then choose 'Halmak' from the list.

It should now be available in the top right corner of your menu, a drop-down menu that allows you to click and select the keyboard layout you want (default would probably be "en" with a down arrow next to it).

### Manual Installation Instructions (if you prefer not to use the script):

1. Download this project's files.

2. Put the `zz` file (from the `halmak-linux` folder) in `/usr/share/X11/xkb/symbols/`.

3. Put the `evdev.xml` file (from the `halmak-linux` folder) in `/usr/share/X11/xkb/rules/` and overwrite the file that's in there (see "Troubleshooting" for more info).

4. Restart your computer.

5. Go to `System Settings -> Region & Language`. Click the `+` button, select `English (United States)`, scroll and click `Halmak`, then click the `Add` button.

### Troubleshooting (And Notes)

A. Steps 4 and 5 might need to be flipped; you may need to restart again after step 5, but I don't think so.

B. In step 3, I got the file from this [link](#) which was basically what I used to figure out how to create the layout (if you want to check the steps); this [Ubuntu guide](#) was also helpful.

C. I skipped one of the steps of updating `xorg.lst` (it was an optional step on the first link).

D. You could probably copy the `zz` file's contents and paste it in the `en` file and it should still show up, if you don't want `zz` to show up (it should appear as "en" in your top right corner).

E. This might work for any system using `xkb`.

F. The default keyboard shortcuts for switching between keyboard layouts are `Shift+Super+Space` (to go to the previous layout) and `Super+Space` (to shift to the next layout in order). If you want to change this, you can go to `Settings -> Devices -> Keyboard Shortcuts` (then scroll to the "Typing" section).

G. I used Colemak's mappings as the base when I switched the keys to Halmak's layout, so third and fourth layers might work with the same mappings; of important note is that I left the CAPS lock as a Backspace key, which isn't specified in the default Halmak layout. This could be changed probably pretty easily by editing the `zz` file, then going to the "CAPS" line and changing the codes on the line, but I don't know what the code is for CAPS lock.

H. For learning a layout, I find it helpful on a second screen (or smartphone) to pull up the layout to look at while typing and memorizing on some kind of typing test like [typeracer.com](https://typeracer.com).

I. If you'd like to try to create a custom layout of your own, you just need to go to the `zz` file for instance and switch around the values of the keys. I don't know what all the codes are for the keys, but you can get some ideas by finding other codes in the files in the `/usr/share/X11/xkb/symbols/` folder.

## Special Thanks and Recognitions:

To [kaievins](https://github.com/kaievns) for creating the [halmak](https://github.com/kaievns/halmak) keybard layout, and the OSX files.

To [pguerin](https://github.com/pguerin3) for creating [halmak4windows](https://github.com/pguerin3/halmak4windows)

To random redditors for giving me clues on how to make the script better.
