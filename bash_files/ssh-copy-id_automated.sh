#!/bin/bash

# Read the hosts.ini file and extract the IP addresses and usernames
while read line; do
  if [[ $line == \[*] ]]; then
    group=$(echo $line | sed 's/\[//g; s/\]//g')
  elif [[ $line == *ansible_host=* ]]; then
    ip=$(echo $line | sed 's/.*ansible_host=//; s/ .*//')
    user=$(echo $line | sed 's/.*ansible_user=//; s/ .*//')
    if [[ $ip != "" && $user != "" && $ip != "127.0.0.1" ]]; then
      ssh-copy-id $user@$ip
    fi
  fi
done < hosts.ini
