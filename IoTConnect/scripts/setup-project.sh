#!/bin/bash

echo "Unzipping en.x-cube-aws-h5-v1-0-0.zip"
unzip -q ../en.x-cube-aws-h5-v1-0-0.zip

echo "Ensure all shell scripts are executable."
find STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/ -name "*.sh" -exec chmod +x {} \;

echo "Move & tidy of sources"
mv STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/* .
rm -r STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/

echo "Patching sources"
patch --strip=1 < IoTConnect/scripts/STM32CubeExpansion_Cloud_AWS_H5_V1.0.0.patch

