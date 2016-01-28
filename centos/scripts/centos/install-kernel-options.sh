#!/bin/bash -eux

printf '%s\n' "Disabling interface renaming in the kernel"
grubby --update-kernel=ALL --remove-args="rhgb quiet" --args="ipv6.disable=1 swapaccount=1 cgroup_enable=memory divider=10 tsc=reliable elevator=noop console=ttyS0 xen_emul_unplug=unnecessary net.ifnames=0 biosdevname=0"
