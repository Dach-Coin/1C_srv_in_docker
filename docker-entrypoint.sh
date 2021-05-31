#!/bin/bash

if [ "$1" = "ragent" ]; then
  exec gosu usr1cv8 /opt/1cv8/x86_64/${ENTERPRISE_VER}/ragent -d /home/usr1cv8/.1cv8/1C/1cv8 -port 2540 \
  -regport 2541 -range 2560:2591 -seclev 0 -pingPeriod 1000 -pingTimeout 5000 -debug -http -debugServerPort 2550
fi

exec "$@"