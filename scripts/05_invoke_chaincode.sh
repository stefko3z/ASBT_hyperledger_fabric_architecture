#!/bin/bash
# import definitions
. scripts/00_environmental_variables.sh

# This script contains all the invocations
placeOrder() {
    setGlobalsForHospital1Peer0
    setGlobalsForOrderChaincode
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
        -c '{"function":"placeOrder","Args":["Producer1MSP", "5"]}'

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getOrder","Args":["o1000"]}'

}

# This script contains all the invocations
acceptOrder() {
    setGlobalsForProducer1Peer0
    setGlobalsForOrderChaincode
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
        -c '{"function":"accept","Args":["o1000"]}'

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getOrder","Args":["o1000"]}'  
}

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
        -c '{"function":"produce","Args":["o1000", "5"]}'

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1004"]}'

    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getAllVaccines","Args":[]}'    
}

addVaccinesToOrder() {
    setGlobalsForProducer1Peer0
    setGlobalsForOrderChaincode
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
        -c '{"function":"addVaccineToOrder","Args":["o1000", "v1000"]}'

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
        -c '{"function":"addVaccineToOrder","Args":["o1000", "v1001"]}'
    
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
        -c '{"function":"addVaccineToOrder","Args":["o1000", "v1002"]}'
    
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
        -c '{"function":"addVaccineToOrder","Args":["o1000", "v1003"]}'
    
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
        -c '{"function":"addVaccineToOrder","Args":["o1000", "v1004"]}'

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getOrder","Args":["o1000"]}'   
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
        -c '{"function":"ship","Args":["Hospital1MSP", "[\"v1000\", \"v1001\", \"v1002\", \"v1003\", \"v1004\"]"] }'

     peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1000"]}'
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
        -c '{"function":"acknowledgeShipment","Args":["[\"v1000\", \"v1001\", \"v1002\", \"v1003\", \"v1004\"]"] }'

     peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getVaccine","Args":["v1000"]}'
}

completeOrder() {
    setGlobalsForProducer1Peer0
    setGlobalsForOrderChaincode
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
        -c '{"function":"completeOrder","Args":["o1000"] }'

     peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "getOrder","Args":["o1000"]}'   
}

# --- Invoke all functions here ---

# Invoke order
placeOrder
acceptOrder

# Invoke vaccine
produceVaccine
addVaccinesToOrder
shipVaccine
acknowledgeShipmentOfVaccine
completeOrder


