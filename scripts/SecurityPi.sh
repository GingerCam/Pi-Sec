#!/bin/bash

source /opt/functions.sh

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  network=online
else
  network=offline
fi