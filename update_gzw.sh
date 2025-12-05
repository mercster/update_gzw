#!/bin/bash

# set game dir.  edit per your Steam installation

GZW_PATH="/home/USERNAME/.steam/steam/steamapps/common/Gray Zone Warfare"

# revert perms
#
echo -n "Reverting permissions..."
chmod 755 "$GZW_PATH/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xaf497c273f87b6e4_0x7a22fc105639587d.dat"

chmod 755 "$GZW_PATH/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xb9af63cee2e43b6c_0x3cb3b3354fb31606.dat"
echo "done."

# use steamcmd to verify GZW files.  gzw_verify.txt is provided, edit it 
# this script and the gzw_verify.txt should be in your steamcmd directory

./steamcmd.sh +runscript "gzw_verify.txt"

echo -n "Setting cachefiles read-only..."
sleep 2

# setting cachefiles readonly so EAC works

chmod 400 "$GZW_PATH/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xaf497c273f87b6e4_0x7a22fc105639587d.dat"

chmod 400 "$GZW_PATH/GZW/Content/SKALLA/PrebuildWorldData/World/cache/0xb9af63cee2e43b6c_0x3cb3b3354fb31606.dat"

echo "done."
