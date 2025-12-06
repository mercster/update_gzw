# update_gzw
Bash script and steamcmd script to "fix" Gray Zone Warfare EAC for Linux users

Credit to @Wifiik_CZ on GZW Discord for finding the two files that need permissions removed.

## Usage

```
update_gzw.sh [-d <steam_dir>] [-u <steam_user>] [-r]
```

The script operates in two modes. Update and Revert. The default mode is Update.

### Update

```bash
./update_gzw.sh
```

If you run the script in this bare form, it is assumed you have the game installed in the default steam directory in `~/.local/share`. If you want to specify a different steam directory, use the `-d` flag. The directory must be parent of `steamapps` directory.

```bash
./update_gzw.sh -d "/storage/games/SteamLibrary"
```

The script will ask you for your Steam username and password. If you want to skip this, use the `-u` flag to specify your username. Steam password will be requested automatically and can only be provided this way. This tool doesn't store it anywhere in plain text, as is a good security practice.

### Revert

In a case your GUI Steam app fails to do an upgrade, use the `-r` flag to revert the changes.

```bash
./update_gzw.sh -r
```

Steam credentials are not needed for this. Your Steam upgrade should work now easily
