# ytdl

Download Termux from any of the following places:

* [F-Droid](https://f-droid.org/en/packages/com.termux/)
* [Google Play Store](https://play.google.com/store/apps/details?id=com.termux)

    Note that a rooted device is **not** necessary.

Give Termux permissions to access storage:

```termux-setup-storage```

Run the script:

```curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nth10sd/ytdl/master/start.sh | sh -s -- REPLACEME```

### Single-line command in Termux

```termux-setup-storage && curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nth10sd/ytdl/master/start.sh | sh -s -- REPLACEME```