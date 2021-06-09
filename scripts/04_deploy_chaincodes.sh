#!/bin/bash
# import definitions
. scripts/00_environmental_variables.sh

# Deploy order chaincode
deployOrderChaincode() {
    echo "===================== Starting deployment of Order Chaincode ===================== "
    
    export CHANNEL_NAME="mychannel"
    export CC_RUNTIME_LANGUAGE="node"  # as we're using javascript
    export CC_SRC_PATH="./artifacts/src/order-contract"
    export CC_NAME=order
    export VERSION=1

    . scripts/deploy_chaincode.sh

    echo "===================== Finished deployment of Order Chaincode ===================== "
}

# Deploy vaccine chaincode
deployVaccineChaincode() {
    echo "===================== Starting deployment of Vaccine Chaincode ===================== "

    export CHANNEL_NAME="mychannel"
    export CC_RUNTIME_LANGUAGE="node"
    export CC_SRC_PATH="./artifacts/src/vaccine-contract"
    export CC_NAME=vaccine
    export VERSION=1

    . scripts/deploy_chaincode.sh

    echo "===================== Finished deployment of Vaccine Chaincode ===================== "
}

# Deployments
deployOrderChaincode
sleep 2s
deployVaccineChaincode
sleep 2s
