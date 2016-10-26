#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir>

set -e

BUILD_DIR=$1
CACHE_DIR=$2

BIN_PATH="$BUILD_DIR/bin"
TMP_PATH="$BUILD_DIR/tmp"
mkdir -p $CACHE_DIR $BIN_PATH $TMP_PATH

# MYSQL_URL="http://security.debian.org/pool/updates/main/m/mysql-5.5/mysql-client-5.5_5.5.52-0+deb8u1_amd64.deb"
MYSQL_PKG="$CACHE_DIR/mysql.deb"
MYSQL_PATH="$TMP_PATH/mysql"
MYSQL_BINARIES="$MYSQL_PATH/usr/bin"

BASE_MYSQL_URL="http://security.debian.org/pool/updates/main/m/mysql-5.5/"
REGEX=".*(mysql-client-5\.5_5\.5\...-0\+deb.u._amd64.deb)"
LATEST_CLIENT=""

if [ -f $MYSQL_PKG ]; then
  echo "-----> Using MySQL Client package from cache"
else
  echo "-----> Downloading MySQL Client package"
  RESPONSE=`curl -s ${BASE_MYSQL_URL}`

  for LINE in $RESPONSE
  do
    if [[ $LINE =~ $REGEX ]]; then
      if [ "${BASH_REMATCH[1]}" \> "${LATEST}" ]; then
        # BASH_REMATCH[1] contains the match from the regex
        LATEST_CLIENT="${BASH_REMATCH[1]}"
      fi
    fi
  done

  MYSQL_URL=$BASE_MYSQL_URL$LATEST_CLIENT

  echo "${MYSQL_URL}"

  curl $MYSQL_URL -L -s -o $MYSQL_PKG

  echo "HERE"
fi

echo "-----> Installing MySQL Client"
dpkg -x $MYSQL_PKG $MYSQL_PATH
chmod +x $MYSQL_BINARIES/*
mv $MYSQL_BINARIES/* $BIN_PATH/

echo "-----> Cleaning up"
rm -rf $MYSQL_PATH
