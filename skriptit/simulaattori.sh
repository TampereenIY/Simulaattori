#!/bin/bash
killall extplane-panel
extplane-panel &
pushd /home/tiy/X-Plane11
./X-Plane-x86_64
popd

