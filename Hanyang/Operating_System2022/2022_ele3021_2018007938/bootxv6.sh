#!/bin/bash

qemu-system-i386 -nongraphic -serial mon:stdio -hdb fs.img xv6.img -smp 1 -m 512
