#!/bin/sh
ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -L 5910:localhost:5901 -qA dpervushin@243.38.133.199 -o "proxycommand ssh -W %h:%p dpervushin@sw-ipp-drivefarm-gp-039.nvidia.com" bash -xc \'$*\'
