# Launcher for Tomb Raider Legend (GOG Version)
# See how to create / mount at https://steamcommunity.com/sharedfiles/filedetails/?id=2003124788
# Image disk must be named TRL.vhdx
# Saves folders in GOG version is C:$UserPath\Documents\Tomb Raider - Legend
# Install folder is set to C:/Games/TRL
# VHD disk must be on same script folder
# ---
# This script run easly Tomb Raider Legend Series Games, this is for Tomb Raider Legend.
# ---
# Assuming you have already created a virtual disk VHD for program game folder.
# This PowerShell script must run with administrative privilege (requested in the first part)
# Operations:
# -Check administrative privilege else elevate
# -Check if exist else create mount folders
# -Check if mounted else mount VHD disk
# -Check if mounted else mount virtual disk partition on game and user folders
# -Run Game
# -On exit unmount all and erase folders
#
# Run with doubleclick on TRL-Launcher.bat
