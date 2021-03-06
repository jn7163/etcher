#!/bin/bash

###
# Copyright 2016 resin.io
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###

set -u
set -e

./scripts/build/check-dependency.sh wget

function usage() {
  echo "Usage: $0"
  echo ""
  echo "Options"
  echo ""
  echo "    -r <electron architecture>"
  echo "    -v <electron version>"
  echo "    -s <electron operating system>"
  echo "    -o <output directory>"
  exit 1
}

ARGV_ARCHITECTURE=""
ARGV_ELECTRON_VERSION=""
ARGV_OPERATING_SYSTEM=""
ARGV_OUTPUT=""

while getopts ":r:v:s:o:" option; do
  case $option in
    r) ARGV_ARCHITECTURE=$OPTARG ;;
    v) ARGV_ELECTRON_VERSION=$OPTARG ;;
    s) ARGV_OPERATING_SYSTEM=$OPTARG ;;
    o) ARGV_OUTPUT=$OPTARG ;;
    *) usage ;;
  esac
done

if [ -z "$ARGV_ARCHITECTURE" ] \
  || [ -z "$ARGV_ELECTRON_VERSION" ] \
  || [ -z "$ARGV_OPERATING_SYSTEM" ] \
  || [ -z "$ARGV_OUTPUT" ]
then
  usage
fi

ELECTRON_ARCHITECTURE=$ARGV_ARCHITECTURE
if [ "$ELECTRON_ARCHITECTURE" == "x86" ]; then
  ELECTRON_ARCHITECTURE="ia32"
fi

ELECTRON_GITHUB_REPOSITORY=https://github.com/electron/electron
ELECTRON_DOWNLOADS_BASEURL="$ELECTRON_GITHUB_REPOSITORY/releases/download/v$ARGV_ELECTRON_VERSION"
ELECTRON_FILENAME="electron-v$ARGV_ELECTRON_VERSION-$ARGV_OPERATING_SYSTEM-$ELECTRON_ARCHITECTURE.zip"
ELECTRON_CHECKSUM=$(wget --no-check-certificate -O - "$ELECTRON_DOWNLOADS_BASEURL/SHASUMS256.txt" | grep "$ELECTRON_FILENAME" | cut -d ' ' -f 1)

./scripts/build/download-tool.sh \
  -u "$ELECTRON_DOWNLOADS_BASEURL/$ELECTRON_FILENAME" \
  -c "$ELECTRON_CHECKSUM" \
  -o "$ARGV_OUTPUT"
