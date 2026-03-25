#! /usr/bin/env bash

# sometimes USBs randomly stop working man :(
# surely this won't brick my pc

while read -r file; do
  id=$(basename "$file") || exit
  set -x
  echo -n "$id" | sudo tee /sys/bus/pci/drivers/xhci_hcd/unbind || exit
  echo -n "$id" | sudo tee /sys/bus/pci/drivers/xhci_hcd/bind || exit
  set +x
done < <(find /sys/bus/pci/drivers/xhci_hcd -type l -regex ".*[0-9]+:[0-9]+:[0-9]+\.[0-9]")
