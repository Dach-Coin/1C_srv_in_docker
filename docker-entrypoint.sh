#!/bin/bash

if [ "$1" = "ragent" ]; then
  exec gosu usr1cv8 /opt/1cv8/x86_64/${ENTERPRISE_VER}/ragent -d /home/usr1cv8/.1cv8/1C/1cv8 -port 1540 \
  -regport 1541 -range 1560:1591 -seclev 0 -pingPeriod 1000 -pingTimeout 5000 -debug -http -debugServerPort 1550
fi

exec "$@"