#!/bin/sh
export TARGET_ARCH=armv7-a
export CFLAGS="-Os -mfloat-abi=softfp -mfpu=vfpv3-d16 -mthumb -marm -march=${TARGET_ARCH}"
export LDFLAGS="-Wl,-z,max-page-size=16384"
ARCH=arm HOST_COMPILER=armv7a-linux-androideabi "$(dirname "$0")/android-build.sh"
