#!/bin/sh
sync; watch -n1 "echo 3 > /proc/sys/vm/drop_caches"