#!/bin/sh

EXTRA_FILES="$(ls /addons/*.kart) $(ls /addons/*.pk3) $(ls /addons/*.wad)"
INITIAL_MAP=$(echo map11 map05 map47 | xargs shuf -n1 -e)

echo "Rebuilding asset directory."
rm -rf /assets/*

echo "Copying base assets to /wads"
cp -rv /Kart-Public/assets/installer/* /assets

echo "Copying addons over base assets"
cp -rv /addons/* /assets

echo "Launching with extra assets: bonuschars.kart $EXTRA_FILES"

SRB2WADDIR=/assets /Kart-Public/_build/bin/srb2kart -dedicated -config /config/kartserv.cfg -home /data -file bonuschars.kart $EXTRA_FILES +map $INITIAL_MAP
