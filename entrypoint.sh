#!/bin/bash
set -e

cd /home/container

export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`
 
if [ ! -e mtasa/mods/deathmatch/mtaserver.conf ]; then
    echo "Downloading server..."
    wget -O mta.tar.gz https://linux.mtasa.com/dl/153/multitheftauto_linux_x64-1.5.3.tar.gz
    tar xfz mta.tar.gz
    mv multitheftauto_linux_* mtasa
    rm mta.tar.gz
    
    echo "Downloading config and resources..."
    wget -O baseconfig.tar.gz https://linux.mtasa.com/dl/153/baseconfig-1.5.3.tar.gz
    tar xfz baseconfig.tar.gz
    mv baseconfig/* mtasa/mods/deathmatch/
    rmdir baseconfig
    mkdir mtasa/mods/deathmatch/resources
    cd mtasa/mods/deathmatch/resources/
    wget -O resources.zip http://mirror.mtasa.com/mtasa/resources/mtasa-resources-latest.zip
    unzip resources.zip
    rm resources.zip
fi

cd /home/container/mtasa/mods/deathmatch

MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}

# Start mtasa server
# exec /home/mtasa/mtasa/mta-server64 -n -t -u --maxplayers $SERVER_SLOT
