# Halmak Keyboard Layout for Linux

## Key Mapping Note

Given a personal preference, this version of the Halmak keyboard layout uses `<` and `>` with `,` and `.` respectively, instead of the traditional mappings for `(` and `)` or other setups. Another note is that the CapsLock has been replaced by a secondary Backspace, given the original Halmak design philosophy and realizaiton that no one uses it. (I should probably work on adding either as an options in the script)

![keyboard-layout](https://github.com/user-attachments/assets/c3442835-49e3-4f10-b180-ca0feb915fe7)

## Script Details:
the script will detect whether your system is immutable (e.g. Bazzite) and/or declarative (e.g. NixOS) or not, and it will tell you. Currently immutable and declarative distros are not supported because my limited habilities. (working on adding VanillaOS support ATM)

## Additional Packages
I have included OSX keyboard bundle files alongside the Linux files if you also want to install it on a Mac (though take into account that this version has `(` and `)` with `,` and `.` respectively, like traditionally.

## Installation Instructions

### Automated Installation (Tested on Fedora 40, Debian 12, Ubuntu 19.10):

1. Download this project's files.

2. Open a terminal and navigate to the directory where the files are located.

3. Run the installation script with root privileges:
   ```bash
   sudo ./install_halmak.sh
   ```

4. Restart your computer to apply the changes. (not always necessary)

5. After restarting, go to `System Settings -> Region & Language`. Click the `+` button, select `English (United States)`, scroll and click `Halmak`, then click the `Add` button.

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
