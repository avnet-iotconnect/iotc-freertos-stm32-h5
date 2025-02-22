#!/bin/bash

echo "Check on submodule."
git submodule init
git submodule update

echo "Unzipping en.x-cube-aws-h5-v1-0-0.zip"
unzip -q ../en.x-cube-aws-h5-v1-0-0.zip

echo "Unzipping en.x-cube-sec-m-h5-v1-1-2.zip"
unzip -q ../en.x-cube-sec-m-h5-v1-1-2.zip

echo "Ensure all shell scripts are executable."
find STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/ \
	X-Cube-SEC-M-H5_V1.1.2/ \
	-name "*.sh" -exec chmod +x {} \;

echo "Move & tidy of sources"
cp -rn STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/* .
cp -rn X-Cube-SEC-M-H5_V1.1.2/* .

rm -r STM32CubeExpansion_Cloud_AWS_H5_V1.0.0/ \
	X-Cube-SEC-M-H5_V1.1.2

echo "Patching sources"
patch --strip=1 < IoTConnect/scripts/STM32CubeExpansion_Cloud_AWS_H5_V1.0.0.patch

