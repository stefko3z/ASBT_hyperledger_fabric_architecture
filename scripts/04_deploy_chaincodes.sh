#!/bin/bash
# import definitions
. scripts/00_environmental_variables.sh

# Deploy order chaincode
deployOrderChaincode() {
    echo "===================== Starting deployment of Order Chaincode ===================== "
    
    setGlobalsForOrderChaincode

    . scripts/deploy_chaincode.sh

    echo "===================== Finished deployment of Order Chaincode ===================== "
}

# Deploy vaccine chaincode
deployVaccineChaincode() {
    echo "===================== Starting deployment of Vaccine Chaincode ===================== "

    setGlobalsForVaccineChaincode

    . scripts/deploy_chaincode.sh

    echo "===================== Finished deployment of Vaccine Chaincode ===================== "
}

# Deploy appointment chaincode
deployAppointmentChaincode() {
    echo "===================== Starting deployment of Appointment Chaincode ===================== "

    setGlobalsForAppointmentChaincode

    . scripts/deploy_chaincode_with_private_data.sh

    echo "===================== Finished deployment of Appointment Chaincode ===================== "
}

# Deployments
# deployOrderChaincode
# sleep 2s
# deployVaccineChaincode
# sleep 2s
deployAppointmentChaincode
sleep 2s