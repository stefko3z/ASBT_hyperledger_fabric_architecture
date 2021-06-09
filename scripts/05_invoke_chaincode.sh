#!/bin/bash
# import definitions
. scripts/00_environmental_variables.sh

# This script contains all the invocations
produceVaccine() {
    setGlobalsForProducer1Peer0
    setGlobalsForVaccineChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        --waitForEvent \
        -c '{"function":"produce","Args":["Pfizer", "20"]}'

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1010"]}'

    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAllVaccines","Args":[]}'    
}

shipVaccine() {
    setGlobalsForProducer1Peer0
    setGlobalsForVaccineChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        --waitForEvent \
        -c '{"function":"ship","Args":["Hospital1MSP", "[\"v1010\"]"] }'

     peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1010"]}'
}

acknowledgeShipmentOfVaccine() {
    setGlobalsForHospital1Peer0
    setGlobalsForVaccineChaincode
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        --waitForEvent \
        -c '{"function":"acknowledgeShipment","Args":["[\"v1010\"]"] }'

     peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1010"]}'
}

# Invoke all functions here
produceVaccine
shipVaccine
acknowledgeShipmentOfVaccine