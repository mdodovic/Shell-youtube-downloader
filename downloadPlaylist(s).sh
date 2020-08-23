#!/bin/bash

options=':hp:d:f:u:'

fileOfPlaylists=0
urlOfPlaylist=0
while getopts $options opt
do
    case $opt in
	h)
	    cat<<EOF
Usage of the script:

downloadPlaylist.sh [-h] 
downloadPlaylist.sh [-f format] [-d directory] {-u url, -p path}
    -h help
    -p path to file with urls of the playlists for downloading
    -u url of the playlist for download
    -f audio format (default is mp3)
    -d path to download directorium (default is ./)
EOF
	    exit 0
	;;
	p)
	    fileOfPlaylists=1
	    playlistsFile=$OPTARG
	;;
	d)
	    saveDirectory=$OPTARG
	;;
	f)
	    formatOption="--"
	    format=$OPTARG
	;;
	u)
	    urlOfPlaylist=1
	    singleURL=$OPTARG
	;;
	*)
	    cat<<EOF
Error in usage - invalid parameter!
Allowed parameters:
    -h  help
    -p: path to file with urls of the playlists for downloading
    -u: url of the playlist for download
    -f: audio format (default is mp3)                                                                                                        
    -d: path to download directorium (default is ./)    
*Additional comments*
 : means argument is requested by this option
*********************
EOF
	    exit -1
	    ;;
    esac
    	
done

if [ $urlOfPlaylist -eq 1 ]
then
    if [ $fileOfPlaylists -eq 1 ]
    then
	cat<<EOF
Only one options -u or -p is allowed
EOF
	exit -1
    fi
    
fi

if [ ! -d $saveDirectory ]
then
    mkdir $saveDirectory
fi



#echo $playlistsFile
#echo $saveDirectory
#echo $format
#echo $singleURL

if [ $urlOfPlaylist -eq 1 ]
then
    echo 1 url
else
    echo Download is about to begin!
    playlists=$(cat $playlistsFile)
    if [ ! -z "$saveDirectory" ]
    then
	cd $saveDirectory
    fi
    oldIFS=$IFS
    IFS=$'\n'
    for i in $playlists
    do
#	echo $i
	youtube-dl -cit --extract-audio --audio-format mp3 "$i"
#	youtube-dl -cit --extract-audio --audio-format mp3 "https://www.youtube.com/playlist?list=PLB9465C52E66532A9" 
    done
    
    IFS=$oldIFS
fi

exit 0
#youtube-dl -cit --extract-audio --audio-format mp3 "https://www.youtube.com/playlist?list=PLB9465C52E66532A9" 
