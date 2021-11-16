#! /bin/bash

echo "[ytdl] Updating Termux package indexes...";
pkg remove game-repo science-repo x11-repo
pkg update -y;
pkg install -y x11-repo
pkg update -y;
pkg upgrade -y;
echo "[ytdl] Installing Termux packages...";
pkg install --no-install-recommends -y ffmpeg libffi openssl python;

echo "[ytdl] Installing latest versions of pip and setuptools...";
pip install --user --upgrade pip setuptools;
echo "[ytdl] Updating $1...";
pip install --user --upgrade "$1";

echo "[ytdl] Parsing ytdl-config...";
ycfgpath="$HOME/.config/ytdl/ytdl-config";
# Default values
audq="3"
dlfolder="/data/data/com.termux/files/home/storage/downloads"
maxvidq="480"
IFS="=";
while read -r variable value; do
if [[ $variable == audq ]]; then
    echo "[ytdl] $variable value from config file is: ${value//\"/}";
    audq="${value//\"/}";
    echo "[ytdl] Quality for audio files (0-9, 0 is best): $audq";
elif [[ $variable == dlfolder ]]; then
    echo "[ytdl] $variable value from config file is: ${value//\"/}";
    dlfolder="${value//\"/}";
    echo "[ytdl] Files will be saved in: $dlfolder";
elif [[ $variable == maxvidq ]]; then
    echo "[ytdl] $variable value from config file is: ${value//\"/}";
    maxvidq="${value//\"/}";
    echo "[ytdl] Max video quality for video files: $maxvidq";
fi
done < "$ycfgpath";

echo "[ytdl] Running $1...";
if [[ "$3" == [yY] || "$3" == [yY][eE][sS] ]]; then
    echo "Creating destination directory...";
    mkdir -p "$HOME/storage/downloads/VideosObtained/";
    echo "Downloading both portions as preference was: $3";
    "/data/data/com.termux/files/home/.local/bin/$1" \
        --add-metadata --no-mtime --no-overwrites \
        --write-sub --embed-subs --all-subs \
        -f "best[height<=$maxvidq]" \
        -o "$dlfolder/VideosObtained/%(title)s-maxVq$maxvidq.%(ext)s" \
        "$2" \
    ;
else
    echo "Creating destination directory...";
    mkdir -p "$HOME/storage/downloads/SongsObtained/";
    if [[ "$audq" == BEST ]]; then
        echo "Downloading best audio-only quality available...";
        "/data/data/com.termux/files/home/.local/bin/$1" \
            --add-metadata --no-mtime --no-overwrites \
            --extract-audio --audio-format best \
            -o "$dlfolder/SongsObtained/%(title)s-Aq$audq.%(ext)s" \
            "$2" \
        ;
    else
        echo "Downloading audio-only and re-encoding to MP3...";
        "/data/data/com.termux/files/home/.local/bin/$1" \
            --add-metadata --no-mtime --no-overwrites \
            --extract-audio --audio-format mp3 --audio-quality "$audq" \
            --prefer-ffmpeg --postprocessor-args "-id3v2_version 3" \
            -o "$dlfolder/SongsObtained/%(title)s-Aq$audq.%(ext)s" \
            "$2" \
        ;
    fi
fi
