#! /bin/bash

echo "[ytdl] Updating Termux package indexes...";
pkg update -y;
echo "[ytdl] Upgrading Termux packages...";
pkg upgrade -y;
echo "[ytdl] Installing Termux packages...";
pkg install -y curl ffmpeg python;

echo "[ytdl] Installing pip and setuptools...";
pip install --user --upgrade pip setuptools;
echo "[ytdl] Installing $1...";
pip install --user --upgrade "$1";

echo "Creating config directory...";
mkdir -p "$HOME/.config/$1/";
echo "Retrieving config script...";
curl --proto '=https' --tlsv1.2 -sSf -o "$HOME/.config/$1/config" https://raw.githubusercontent.com/nth10sd/ytdl/master/cfg/config

echo "Creating destination directories...";
mkdir -p "$HOME/storage/downloads/Youtube/Songs";
mkdir -p "$HOME/storage/downloads/Youtube/Videos";

echo "Creating ~/bin directory...";
mkdir "$HOME/bin";
echo "Retrieving termux-url-opener script...";
urlopener="$HOME/bin/termux-url-opener"
curl --proto '=https' --tlsv1.2 -sSf -o "$urlopener" https://raw.githubusercontent.com/nth10sd/ytdl/master/cfg/termux-url-opener
if [[ -f "$urlopener" ]]; then
    echo "Replacing placeholder with intended program...";
    sed "s/PLACEHOLDERNAME/$1/g" "$urlopener";
fi
