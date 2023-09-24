#!/bin/bash
scriptDir=$(dirname "$(realpath "$0")")
zomboidDir="$HOME/Zomboid"
scmdInstallDir="$scriptDir/.scmd/zomboid"
scmdModsDir="$scmdInstallDir/steamapps/workshop/content/108600"
scmdOutputFile="$scriptDir/steamCmdOut.txt"
logOutputFile="$scriptDir/DownloadProjectMods.log"
urlFile="$scriptDir/urlInput.txt"

errorcode=0 # unknow error, 1 success, 2 url input not found, 3 invalid flag, 4 steamcmd not found

function echoLog() {
	echo $*
	echo $*  >> $logOutputFile
	return
}

vartemp=$(date +"%H:%M:%S - %d/%m/%Y")
echo "" >> $logOutputFile
echo "[=== Download Project Zomboid Mods Script (Vulpius4001) - $vartemp ===]" >> $logOutputFile

echo "[!] If not exists, Creating SteamCMD install directory at [$scmdInstallDir]..." >> $logOutputFile
mkdir -p $scmdInstallDir

if ! command -v steamcmd &> /dev/null
then
	echolog "[!] steamcmd Not found! please install it using the command \"sudo apt install steamcmd -y\""
	errorcode=4
	exit $errorcode
fi


[[ -z "${SKIPEXISTING}" ]] && skipExisting=0 || skipExisting=${SKIPEXISTING}
[[ -z "${AUTOCOPY}" ]] && autoCopyToFolder=1 || autoCopyToFolder=${AUTOCOPY}
[[ -z "${CLEANINSTALL}" ]] && cleanMod=0 || cleanMod=${CLEANINSTALL}
[[ -z "${EXIT}" ]] && exitOnEnd=0 || exitOnEnd=${EXIT}

skipValid=0
autoValid=0
exitValid=0
cleanValid=0

if [ $skipExisting -eq 0 ]; then
	echoLog "[!] Downloading everything."
	skipValid=1
elif [ $skipExisting -eq 1 ]; then
	echoLog "[!] Skipping already Downloaded IDs..."
	skipValid=1
else
	echoLog "[!] Invalid SKIPEXISTING flag (got $skipExisting, expecting 0 or 1). exiting the script..."
	errorcode=3
	exit $errorcode
fi

if [ $autoCopyToFolder == 0 ]; then
	echoLog "[!] Will NOT copy mods."
	autoValid=1
elif [ $autoCopyToFolder == 1 ]; then
	echoLog "[!] Will copy mods when finished downloading."
	autoValid=1
else
	echoLog "[!] Invalid AUTOCOPY flag (got $autoCopyToFolder, expecting 0 or 1). exiting the script..."
	errorcode=3
	exit $errorcode
fi

if [ $exitOnEnd == 0 ]; then
	exitValid=1
elif [ $exitOnEnd == 1 ]; then
	echoLog "[!] Auto Exiting when the Script ends."
	exitValid=1
else
	echoLog "[!] Invalid EXIT flag (got $exitOnEnd, expecting 0 or 1). exiting the script..."
	errorcode=3
	exit $errorcode
fi

if [ $cleanMod == 0 ]; then
	cleanValid=1
elif [ $cleanMod == 1 ]; then
	echoLog "[!] Will delete all mods in Project Zomboid mod directory and copy new ones."
	echoLog "[!] Overwriting AUTOCOPY flag to 1"
	echoLog "[!] Overwriting SKIPEXISTING flag to 0"
	sleep 2
	autoCopyToFolder=1
	skipExisting=0
	cleanValid=1
else
	echoLog "[!] Invalid CLEANINSTALL flag (got $cleanMod, expecting 0 or 1). exiting the script..."
	errorcode=3
	exit $errorcode
fi

if [ $cleanMod -eq 1 ]; then
	echoLog "[!] Cleaning Mod Download folder in 5s, press CTRL+C to abort the script execution..."
	sleep 5
	echoLog "[!] Deleting Mod Cache..."
	rm -rf $scmdModsDir/*
fi

if (test -f $urlFile); then
	inputUrlsIds=$(grep "id=" $urlFile | cut -d "=" -f2 | cut -d "&" -f1)
	
	vartemp=$(date +"%H:%M:%S - %d/%m/%Y")
	echo "[=== $vartemp ===]" >> $scmdOutputFile
	
	rm -f /tmp/tempScript > /dev/null
	echo "@ShutdownOnFailedCommand 1" >> /tmp/tempScript
	echo "@NoPromptForPassword 1" >> /tmp/tempScript
	echo "force_install_dir $scmdInstallDir" >> /tmp/tempScript
	echo "login anonymous anonymous" >> /tmp/tempScript
	
	for urlId in $inputUrlsIds
	do
		re="^[0-9]+$"
		if [[ $urlId =~ $re ]] ; then
			if (test -d $scmdModsDir"/"$urlId) && [ "$skipExisting" -eq 1 ]; then
				echoLog "[!] [Download URL Input] $urlId already downloaded, skipping..."
			else
				echoLog "[!] [Download URL Input] Working on $urlId..."
				echo "workshop_download_item 108600 $urlId" >> /tmp/tempScript
				rm -rfv "$scmdModsDir/$urlId/*"
			fi
		else
			echoLog "[!] [Download URL Input] Not a ID ($urlId), skipping..."
		fi
	done
	echo "quit" >> /tmp/tempScript
	
	echoLog "[!] [Download URL Input] Running generated download script..."
	steamcmd +runscript /tmp/tempScript >> $scmdOutputFile
	echoLog "[!] [Download URL Input] Deleting generated download script..."
	rm -f /tmp/tempScript > /dev/null
else
	echoLog "[!] [Download URL Input] ($urlFile) not found."
	errorcode=2
	read -r -p "[!] Continue executing the script? [Y/n] " response
	case "$response" in
	    [yY]) 
	    	echo "[!] Continue executing the script? [Y/n] $response" >> $logOutputFile
		echoLog "[!] Resuming..."
		sleep 1.5
		;;
	    [nN])
	    	echo "[!] Continue executing the script? [Y/n] $response" >> $logOutputFile
		read -s -n 1 -p "[!] Press any key to exit the script . . ."
		echo ""
		exit $errorcode
		;;
	    *)
	    	echo "[!] Continue executing the script? [Y/n] $response" >> $logOutputFile
	    	read -s -n 1 -p "[!] Invalid Option, Press any key to exit the script . . ."
	    	echo "[!] Invalid Option, Press any key to exit the script . . ." >> $logOutputFile
		echoLog ""
	    	exit $errorcode
	    	;;
	esac
fi

if [ $cleanMod -eq 1 ]; then
	zomboidModDir=$zomboidDir"/mods"
	echoLog "[!] Cleaning Mod folder in 5s, press CTRL+C to abort the script execution..."
	sleep 5
	echoLog "[!] Deleting Mods..."
	rm -rf $zomboidModDir/*
fi

if [ $autoCopyToFolder -eq 1 ]; then
	echoLog "[!] [AutoCopy] Copying..."
	
	outputs=$(ls $scmdModsDir | cut -f1 -d'/')
	mkdir -p $zomboidDir
	for id in $outputs
	do
	    echoLog "[!] [AutoCopy] Working on Folder $id..."
	    tempDir=$scmdModsDir"/"$id
	    if ! (cp -r -n -u $tempDir"/mods" $zomboidDir); then
		echoLog "[!] [AutoCopy] Some error while Working on Folder $id... (Error Code: $?)"
	    else
		echoLog "[!] [AutoCopy] Working on Folder $id... Copied!"
	    fi
	done
else
	echoLog "[!] AutoCopy not enabled."
fi

duplicates=$(sort $urlFile | uniq -c | grep -v '^ *1 ' | tr -s ' ' | cut -d ' ' -f 3)
for dup in $duplicates; do
	id=$(echo $dup | cut -d "=" -f2 | cut -d "&" -f1)
	echoLog "[!] [Duplicate] there is a duplicate for $id in URL Input file"
	echoLog "[!] you can find URL Input file at $urlFile"
done

echoLog "[!] Done, ending script..."
if [ $exitOnEnd -eq 1 ]; then
	echoLog "[!] exiting the script..."
	echoLog ""
	errorcode=1
	exit $errorcode
else
	read -s -n 1 -p "[!] Press any key to exit the script . . ."
	echo "[!] Press any key to exit the script . . ." >> $logOutputFile
	echoLog ""
	errorcode=1
	exit $errorcode
fi

