hello <br />
here are some "flags" to set when executing the script on terminal <br />
<br />
example: SKIPEXISTING=1 AUTOCOPY=1 CLEANINSTALL=0 EXIT=1 ./DownloadProjectMods.sh <br />
<br />
SKIPEXISTING  [0/1] = Default: 0, Will skip any ID if found matching folder at Download dir <br />
AUTOCOPY      [0/1] = Default: 1, Will Copy folders to set Project Zomboid Mod folder at Home Directory <br />
CLEANINSTALL  [0/1] = Default: 0, Will Delete all workshop cache and every mods at Project Zomboid Mod folder then download it all over again. Overwrites SKIPEXISTING to 0 and AUTOCOPY to 1 <br />
EXIT          [0/1] = Default: 0, Will not wait for user input to exit the script <br />
<br />
you can also edit the script file, to change some variables as you see fit <br />
<br /> 
zomboidDir          = Default: "$HOME/Zomboid", the folder where project zomboid save data, settings and mod folder are located <br />
scmdInstallDir      = Default: "$scriptDir/.scmd/zomboid", the folder where the script will set steamcmd to set as install dir <br />
scmdOutputFile      = Default: "$scriptDir/steamCmdOut.txt", steamcmd output file <br />
logOutputFile       = Default: "$scriptDir/DownloadProjectMods.log", script output file <br />
urlFile             = Default: "$scriptDir/urlInput.txt", a text file containing all the URLs to the steam workshop mod page <br />
<br />
on urlInput.txt file, you need to add the steam workshop mod page per line <br />
example:<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=2169435993<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=2619072426<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=2297098490<br />
https://steamcommunity.com/sharedfiles/filedetails/?id=2200148440<br />
and so on<br />
