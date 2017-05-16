#!/bin/bash
set -e

hostsfile="/tmp/ansible-hosts-$(date '+%Y-%m-%d-%H-%M-%N')"
curl -so "${capfile}" "https://raw.githubusercontent.com/stiang/devops/master/data_files/ansible_hosts?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
ansible -i "${capfile}" $1
rm "${hostsfile}"
