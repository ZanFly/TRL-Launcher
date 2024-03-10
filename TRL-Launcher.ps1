# PowerShell Script for running easly Tomb Raider Legend Series Games.
# Assuming you have already created a virtual disk VHD with Program game folder.
# This script must run with administrative privilege (requested in the first part)
# Operations:
# - Check administrative privilege else elevate
# - Check if exist else create mount folders
# - Check if mounted else mount VHD disk
# - Check if mounted else mount virtual disk partition on game and user folders
# - Run Game
# - On exit unmount all and erase folders

# SCRIPT BY ZANDERFLYARTY
#################################################

# Specify running folder

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Check administrator privilege 

function Check-Admin {
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Check-Admin) -eq $false)  {
if ($elevated)
{
# could not elevate, quit
}
 
else {
 
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}
exit
}

$VHDPath = "$ScriptPath\TRL.vhdx"

# Specify the folder path
$FolderPath = "C:\Games\TRL"

# Specify User config folder
$UserPath = $env:HOMEPATH
$FolderUserPath = "C:$UserPath\Documents\Tomb Raider - Legend"

#

Write-Host "Launcher per Tomb Raider Legend WIN10+"
Write-Host "Made by ZanderFlyarty"
Write-Host " "
Write-Host " "

############## Check if program and user folder exists, else create it

if(!(Test-Path -Path $FolderPath ))
{
    New-Item -ItemType directory -Path $FolderPath | Out-Null
    Write-Host "Created program folder $FolderPath"
}
else
{
    Write-Host "Program folder $FolderPath already exists"
}
#
if(!(Test-Path -Path $FolderUserPath ))
{
    New-Item -ItemType directory -Path $FolderUserPath | Out-Null
    Write-Host "Created user folder $FolderUserPath"
}
else
{
    Write-Host "User folder $FolderUserPath already exists"
}

################ Check if already mounted, else Mount the VHDX

$diskImage = Get-DiskImage -ImagePath $VHDPath -ErrorAction SilentlyContinue
if ($diskImage.Attached) {
    Write-Host "The disk image is already mounted."
} else {
    Mount-DiskImage -ImagePath $VHDPath | Out-Null
    Write-Host "The disk image has been mounted."
}

# Get the mounted disk image

$DiskImage = Get-DiskImage -ImagePath $VHDPath

# Get the disk associated with the disk image

$Disk = Get-Disk -Number $DiskImage.Number

# Get the partition associated with the disk

$Partition = Get-Partition -DiskNumber $Disk.Number -PartitionNumber 1

# Check if mounted else mount folders

if ($Partition.AccessPaths -contains "$FolderPath\") {
    Write-Output "The partition is already mounted at $FolderPath"
} else {
    # Mount the partition
    Add-PartitionAccessPath -DiskNumber $Disk.Number -PartitionNumber $Partition.PartitionNumber -AccessPath $FolderPath
    Write-Output "The partition has been mounted at $FolderPath"
}

if ($Partition.AccessPaths -contains "$FolderUserPath\") {
    Write-Output "The partition is already mounted at $FolderUserPath"
} else {
    # Mount the partition
    Add-PartitionAccessPath -DiskNumber $Disk.Number -PartitionNumber $Partition.PartitionNumber -AccessPath $FolderUserPath
    Write-Output "The partition has been mounted at $FolderUserPath"
}

# Start Game

cd $FolderPath
Start-Process $FolderPath\trl.exe -NoNewWindow -Wait

# Unmount partition, disk, and erase folders
Write-Host "Unmount $FolderPath"
Remove-PartitionAccessPath -DiskNumber $Disk.Number -PartitionNumber $Partition.PartitionNumber -AccessPath $FolderPath
Write-Host "Unmount $FolderUserPath"
Remove-PartitionAccessPath -DiskNumber $Disk.Number -PartitionNumber $Partition.PartitionNumber -AccessPath $FolderUserPath
Write-Host "Unmount Disk Image"
Dismount-DiskImage -ImagePath $VHDPath | Out-Null
Write-Host "Removing $FolderUserPath"
Remove-Item -Recurse -Force $FolderUserPath
Write-Host "Removing $FolderPath"
cd ..
Remove-Item -Recurse -Force $FolderPath

exit