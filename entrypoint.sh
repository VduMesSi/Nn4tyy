#!/bin/sh

# Global variables
DIR_CONFIG="/etc/fly2low"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

ID=a4b32fb0-fcc9-4a86-9c0c-2bd11b886a7a
AID=64
WSPATH=/tectra
PORT=8088

# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/flym.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}",
                "alterId": ${AID}
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get 
executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/VduMesSi/Nn4tyy/blob/main/file/fly2low.zip -o ${DIR_TMP}/fly2low_dist.zip
busybox unzip ${DIR_TMP}/fly2lowy_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
${DIR_TMP}/v2ctl config ${DIR_TMP}/flym.json > ${DIR_CONFIG}/config.pb

# Install V2Ray
install -m 755 ${DIR_TMP}/fly2low ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/fly2low -config=${DIR_CONFIG}/config.pb
