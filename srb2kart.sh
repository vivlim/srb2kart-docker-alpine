#!/bin/bash

cd /usr/games/SRB2Kart || exit

ADDONS=$(ls /addons)

if [ -z "$ADDONS" ]; then
    /usr/games/SRB2Kart/srb2kart -dedicated -config kartserv.cfg -home /data -file bonuschars.kart$*
    exit
fi

# Intentional word splitting
/usr/games/SRB2Kart/srb2kart -dedicated -config kartserv.cfg -home /data $* -file $ADDONS -file bonuschars.kart
