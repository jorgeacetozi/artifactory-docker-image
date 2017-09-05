#!/bin/bash
set -e

sed -i "s/-Xms512m/$MIN_HEAP_SIZE/g" /opt/artifactory/bin/artifactory.default
sed -i "s/-Xmx2g/$MAX_HEAP_SIZE/g" /opt/artifactory/bin/artifactory.default

echo -e "Starting artifactory..."
./opt/artifactory/bin/artifactory.sh
