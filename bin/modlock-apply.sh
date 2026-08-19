#!/bin/bash
# set -euo pipefail
for LOC in $*; do
  # LOC="http://testbot.nvidia.com/testbot-ws/query?func=GetOutputsLocation&bsid=7&eventid=8564366&buildid=12313699&vid=3"
  OUTPUT_DIR=$(wget --no-verbose --quiet --output-document - ${LOC} \
    | grep "<title>.*</title>"        \
    | sed -e "s/<title>//" -e "s/<\/title>//" -e "s/Index of//" \
    | tr -d "[:space:]")
  MODLOCK_ARCHIVE=$(mktemp)
  wget --no-verbose --quiet http://buildbrain/${OUTPUT_DIR}/modlock_output.tbz2 --output-document ${MODLOCK_ARCHIVE}.tar.bz2
  tar --directory ${VR} \
    --bzip2 \
    --extract \
    --verbose \
    --file ${MODLOCK_ARCHIVE}.tar.bz2 ./tools/modlock/data/bin
done
git -C ${VR}/tools/modlock/data/bin add -A .
git -C ${VR}/tools/modlock/data/bin commit -m "Modlock"
