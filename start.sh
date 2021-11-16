#! /bin/bash

echo "[ytdl] Updating Termux package indexes...";
pkg remove -y game-repo science-repo
pkg update -y;
pkg upgrade -y;
echo "[ytdl] Installing needed packages...";
pkg install --no-install-recommends -y ffmpeg libffi openssl python;

echo "[ytdl] Installing latest versions of pip and setuptools...";
pip install --user --upgrade pip setuptools;
echo "[ytdl] Installing $1...";
pip install --user --upgrade "$1";

echo "[ytdl] Creating ytdl config directory if it does not exist.";
mkdir -p "$HOME/.config/ytdl/";

echo "[ytdl] Retrieving default ytdl-config file...";
onlineycfgmd5sum="$(curl -sL https://git.io/JJ670 | md5sum | cut -d ' ' -f 1)";
ycfgpath="$HOME/.config/ytdl/ytdl-config";
if [[ -f "$ycfgpath" ]]; then
    if [[ "$(md5sum "$ycfgpath" | cut -d ' ' -f 1)" \
            == "$onlineycfgmd5sum" ]]; then
        echo "[ytdl] Found identical ytdl-config, not getting remote one.";
    else
        echo "[ytdl] Found custom ytdl-config, not getting remote one.";
    fi
else
    echo "[ytdl] Retrieving ytdl config script...";
    ytdlcfgurl="https://raw.githubusercontent.com/nth10sd";
    ytdlcfgurl+="/ytdl/master/cfg/ytdl-config";
    curl --proto '=https' --tlsv1.2 -sSf \
        -o "$ycfgpath" "$ytdlcfgurl";
fi

echo "Creating ~/bin directory if it does not yet exist...";
mkdir -p "$HOME/bin/";
echo "Retrieving termux-url-opener script...";
urlopenerpath="$HOME/bin/termux-url-opener"
urlopenerurl="https://raw.githubusercontent.com/nth10sd"
urlopenerurl+="/ytdl/master/cfg/termux-url-opener"
curl --proto '=https' --tlsv1.2 -sSf \
    -o "$urlopenerpath" "$urlopenerurl";
if [[ -f "$urlopenerpath" ]]; then
    sed -i "s/PLACEHOLDERNAME/$1/g" "$urlopenerpath";
fi

echo "Installation complete!";
echo;
echo 'Type "exit" to quit Termux when you are done.';
echo;
