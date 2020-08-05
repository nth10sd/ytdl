#! /bin/bash

echo "[ytdl] Updating Termux package indexes...";
pkg update -y;
echo "[ytdl] Installing needed packages...";
pkg install --no-install-recommends -y ffmpeg python;

echo "[ytdl] Installing latest versions of pip and setuptools...";
pip install --user --upgrade pip setuptools;
echo "[ytdl] Installing $1...";
pip install --user --upgrade "$1";

echo "Creating ~/bin directory if it does not yet exist...";
mkdir -p "$HOME/bin/";
echo "Retrieving termux-url-opener script...";
urlopener="$HOME/bin/termux-url-opener"
x="https://raw.githubusercontent.com/nth10sd/ytdl/master/cfg/termux-url-opener"
curl --proto '=https' --tlsv1.2 -sSf -o "$urlopener" "$x";
if [[ -f "$urlopener" ]]; then
    sed -i "s/PLACEHOLDERNAME/$1/g" "$urlopener";
fi

echo "Installation complete!";
echo;
echo 'Type "exit" to quit Termux when you are done.';
echo;
