#!/bin/bash

# Mikrotik RouterOS Downloader Script (bash) v1.0
# Usage:
#   ./ros-download.sh <version> [destination directory]
# Examples:
#   ./ros-download.sh 7.20.6
#   ./ros-download.sh 6.49.19 /path/to/downloads
# Notes:
# - Supports RouterOS v6 and v7; selects the correct file list automatically.
# - Creates destination directory if needed; downloads files one-by-one.
# License: MIT
# GitHub: https://github.com/bajodel/mikrotik-routeros-downloader


# usage information
usage() {
    echo "Usage: $0 <version> [destination directory]"
    echo "Example: $0 7.20.6 /tmp/downloads"
    exit 1
}

# check for version (first argument)
if [ -z "$1" ]; then
    echo "Error: No version specified."
    usage
fi

VERSION="$1"
#old# DEST="${2:-.}" # default: download to current directory if a path is not provided (as second argument)
DEST="${2:-${VERSION}}" # create a folder named "$VERSION if a custom path is not provided (as second argument)

# validate destination directory (optional second argument)
if [ ! -d "$DEST" ]; then
    echo "Destination directory '$DEST' does not exist. Creating.."
    mkdir -p "$DEST" || { echo "Error: Could not create destination directory."; exit 2; }
fi

# evaluate major version (first number) to select the correct URL list
MAJOR_VERSION="${VERSION%%.*}"

if [ "$MAJOR_VERSION" = "6" ]; then
    echo "Requested RouterOS v6, using URL6 list."
    URLS=$(cat <<EOF

## URL6 - RouterOS v6 files##

## CHR x86
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.img.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vdi.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vhdx.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.ova
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vhd.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vmdk.zip

## Note: CHR ARM64 not available for v6
## Note: ISO ARM64 not available for v6

## x86
https://download.mikrotik.com/routeros/${VERSION}/routeros-x86-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/mikrotik-${VERSION}.iso
https://download.mikrotik.com/routeros/${VERSION}/install-image-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/all_packages-x86-${VERSION}.zip

## ARM64
https://download.mikrotik.com/routeros/${VERSION}/routeros-arm64-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-arm64-${VERSION}.zip

## ARM
https://download.mikrotik.com/routeros/${VERSION}/routeros-arm-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-arm-${VERSION}.zip

## MIPSBE
https://download.mikrotik.com/routeros/${VERSION}/routeros-mipsbe-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-mipsbe-${VERSION}.zip

## MMIPS
https://download.mikrotik.com/routeros/${VERSION}/routeros-mmips-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-mmips-${VERSION}.zip

## PPC
https://download.mikrotik.com/routeros/${VERSION}/routeros-powerpc-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-ppc-${VERSION}.zip

## SMIPS
https://download.mikrotik.com/routeros/${VERSION}/routeros-smips-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-smips-${VERSION}.zip

## TILE
https://download.mikrotik.com/routeros/${VERSION}/routeros-tile-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-tile-${VERSION}.zip

## NETINSTALL
https://download.mikrotik.com/routeros/${VERSION}/netinstall64-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/netinstall-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/netinstall-${VERSION}.tar.gz

## MIBs
https://download.mikrotik.com/routeros/${VERSION}/mikrotik.mib

## DUDE (install and client)
https://download.mikrotik.com/routeros/${VERSION}/dude-install-${VERSION}.exe
https://download.mikrotik.com/routeros/${VERSION}/dude-install-${VERSION}.exe

## Bandwidth Test
https://download.mikrotik.com/routeros/${VERSION}/btest.exe

## FLASHFIG
https://download.mikrotik.com/routeros/${VERSION}/flashfig.exe

EOF
)

elif [ "$MAJOR_VERSION" = "7" ]; then
    echo "Requested RouterOS v7, using URL7 list."
    URLS=$(cat <<EOF

## URL7 - RouterOS v7 files##

## CHR x86
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.img.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vdi.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vhdx.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.ova
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vhd.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}.vmdk.zip

## CHR ARM64
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}-arm64.img.zip
https://download.mikrotik.com/routeros/${VERSION}/chr-${VERSION}-arm64.vdi.zip

## x86
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}.npk
https://download.mikrotik.com/routeros/${VERSION}/mikrotik-${VERSION}.iso
https://download.mikrotik.com/routeros/${VERSION}/install-image-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/all_packages-x86-${VERSION}.zip

## ARM64
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-arm64.npk
https://download.mikrotik.com/routeros/${VERSION}/mikrotik-${VERSION}-arm64.iso
https://download.mikrotik.com/routeros/${VERSION}/all_packages-arm64-${VERSION}.zip

## ARM
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-arm.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-arm-${VERSION}.zip

## MIPSBE
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-mipsbe.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-mipsbe-${VERSION}.zip

## MMIPS
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-mmips.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-mmips-${VERSION}.zip

## PPC
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-ppc.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-ppc-${VERSION}.zip

## SMIPS
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-smips.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-smips-${VERSION}.zip

## TILE
https://download.mikrotik.com/routeros/${VERSION}/routeros-${VERSION}-tile.npk
https://download.mikrotik.com/routeros/${VERSION}/all_packages-tile-${VERSION}.zip

## NETINSTALL
https://download.mikrotik.com/routeros/${VERSION}/netinstall64-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/netinstall-${VERSION}.zip
https://download.mikrotik.com/routeros/${VERSION}/netinstall-${VERSION}.tar.gz

## MIBs
https://download.mikrotik.com/routeros/${VERSION}/mikrotik.mib

## DUDE (install and client)
https://download.mikrotik.com/routeros/${VERSION}/dude-install-${VERSION}.exe
https://download.mikrotik.com/routeros/${VERSION}/dude-install-${VERSION}.exe

## Bandwidth Test
https://download.mikrotik.com/routeros/${VERSION}/btest.exe

## FLASHFIG
https://download.mikrotik.com/routeros/${VERSION}/flashfig.exe

EOF
)
else
    echo "Error: Unsupported version ($VERSION). Only major version 6 or 7 is supported."
    exit 3
fi

# filter valid URLs (skip comment and empty lines)
URL_LIST=()
while IFS= read -r line; do
    if [[ -n "$line" && ! "$line" =~ ^# ]]; then
        URL_LIST+=("$line")
    fi
done <<< "$URLS"

TOTAL=${#URL_LIST[@]}
SUCCESS=0
FAILED=0

echo "Starting downloads for version '$VERSION' to destination '$DEST'"
echo "Total files to download: $TOTAL"
COUNTER=1

for url in "${URL_LIST[@]}"; do
    fname=$(basename "$url")
    echo "[$COUNTER/$TOTAL] Downloading $fname .."
    curl -L -o "$DEST/$fname" --fail --silent --show-error "$url"
    if [ $? -eq 0 ]; then
        echo "    Done: $fname"
        SUCCESS=$((SUCCESS + 1))
    else
        echo "    Failed: $fname"
        FAILED=$((FAILED + 1))
    fi
    COUNTER=$((COUNTER + 1))
done

echo ""
echo "Download summary:"
echo "---------------------------"
echo "Total files listed : $TOTAL"
echo "Successfully downloaded: $SUCCESS"
echo "Failed downloads: $FAILED"

if [ "$FAILED" -gt 0 ]; then
    echo "WARNING: There were $FAILED failed downloads."
fi

echo "All downloads completed."
