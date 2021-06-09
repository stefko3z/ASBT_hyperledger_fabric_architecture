#!/bin/bash
# Initial network setup
echo Starting network setup

bash scripts/02_network_up.sh
bash scripts/03_create_channel.sh
bash scripts/04_deploy_chaincodes.sh