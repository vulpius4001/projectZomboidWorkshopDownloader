hello
here are some "flags" to set when executing the script on terminal

example: SKIPEXISTING=1 AUTOCOPY=1 CLEANINSTALL=0 EXIT=1 ./DownloadProjectMods.sh

SKIPEXISTING  [0/1] = Default: 0, Will skip any ID if found matching folder at Download dir
AUTOCOPY      [0/1] = Default: 1, Will Copy folders to set Project Zomboid Mod folder at Home Directory
CLEANINSTALL  [0/1] = Default: 0, Will Delete all workshop cache and every mods at Project Zomboid Mod folder then download it all over again. Overwrites SKIPEXISTING to 0 and AUTOCOPY to 1
EXIT          [0/1] = Default: 0, Will not wait for user input to exit the script

you can also edit the script file, to change some variables as you see fit

zomboidDir          = Default: "$HOME/Zomboid", the folder where project zomboid save data, settings and mod folder are located
scmdInstallDir      = Default: "$scriptDir/.scmd/zomboid", the folder where the script will set steamcmd to set as install dir
scmdOutputFile      = Default: "$scriptDir/steamCmdOut.txt", steamcmd output file
logOutputFile       = Default: "$scriptDir/DownloadProjectMods.log", script output file
urlFile             = Default: "$scriptDir/urlInput.txt", a text file containing all the URLs to the steam workshop mod page
