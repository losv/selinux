#!/bin/bash

#первая часто скрипта проверяет включен ли SELINUX
selinux_state=$(getenforce)

if [ "$selinux_state" == "Enforcing" ]; then
  echo "SELinux is enabled"

elif [ "$selinux_state" == "Permissive" ]; then
  echo "SELinux is permissive"

else
  echo "SELinux is disabled (or missing)"
fi

# вторая часть скрипта проверяет включен ли SELINUX в конфиге

selinux_status=$(sestatus)
if [ "$selinux_status" == "SELinux status:                 disabled" ]; then
  echo "Selinux disabled  in config file!"

else
  echo "Selinux enabled in config file!"
fi

# третья часть скрипта изменяет состояние SELINUX в enabled или disabled.

if [ "$selinux_status" != "SELinux status:                 disabled" ]; then
  echo "Если хотите выключить SELINUX нажмите 'd'"
  read d
  echo $d
  if [ "$d" == 'd' ]; then
     $(setenforce 0)
  fi
else
  echo "Если хотите включить SELINUX нажмите 'e'"
  read d
  echo $d
  if [ "$d" == 'e' ]; then
    $(setenforce 1)
  fi
fi

selinux_state=$(getenforce)
echo "Selinux $selinux_state"

# четвертая часть скрипта вносит изменения в конфиг файлы и перегружает систему

echo "Хотите изменить настройки SELINUX в config файле,нажмите 'y', систему нужно будет перегрузить."
read q
if [ "$q" == "y" ]; then
  selinux_status=$(sestatus)
  if [ "selinux_status" != "disabled" ]; then
  echo "Если хотите изменить SELINUX в config файле с 'enabled' на 'disabled', то нажмите 'd', с 'disabled' на 'enabled'  то нажмите 'e' для применения конфига система должна перегрузиться"
  read d
    if [ "$d" == "d" ]; then 
      $(sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config)
      $(shutdown -r now)
    elif [ "$d" == "e" ]; then
      $(sed -i s/^SELINUX=.*$/SELINUX=enable/ /etc/selinux/config)
      $(shutdown -r now)
    fi
  fi
fi

