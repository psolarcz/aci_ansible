#!/usr/bin/env bash
ssh -i ~/.ssh/git 192.168.206.237 'cd Documents/aci && git pull && ansible-playbook network_deploy.yaml  -e state=absent'