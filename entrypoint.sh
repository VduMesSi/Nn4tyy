#!/bin/sh

# Global variables
DIR_CONFIG="/etc/xray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

ID=9506a4e2-0754-4bb5-a495-eb7719449b31
WSPATH=/tectra
PORT=4044

# Write V2Ray configuration
cat << EOF > ${DIR_CONFIG}/flym.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
          "network": "grpc",
          "grpcSettings": {
            "serviceName": "tusktik"
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o ${DIR_TMP}/Xray-linux-64.zip.dgst
busybox unzip ${DIR_TMP}/Xray-linux-64.zip.dgst -d ${DIR_TMP}

# Convert to protobuf format configuration

# Install V2Ray
install -m 755 ${DIR_TMP}/xray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/xray -config=${DIR_CONFIG}/flym.json
