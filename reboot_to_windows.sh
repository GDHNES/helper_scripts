#!/bin/bash

# 查找 Windows Boot Manager 的行号
index=$(sudo grep -E "^menuentry|submenu" /boot/grub/grub.cfg | grep -n  "Windows Boot Manager" | cut -d: -f1)

# 计算 GRUB 索引（从 0 开始）
grub_index=$((index - 1))

# 设置 grub-reboot
sudo grub-reboot $grub_index

# 重启系统
sudo reboot

