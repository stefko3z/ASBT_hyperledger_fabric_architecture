#!/bin/bash
# import definitions
. scripts/00_environmental_variables.sh

presetup() {
    echo Installing npm dependencies ...
    pushd ${CC_SRC_PATH}
    npm install
    popd
    echo Finished installing node dependencies
}

packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.producer1 ===================== "
}

installChaincode() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.producer1 ===================== "

    # setGlobalsForProducer1Peer1
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.producer1 ===================== "

    setGlobalsForProducer2Peer0
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.producer2 ===================== "

    # setGlobalsForProducer2Peer1
    # peer lifecycle chaincode install ${CC_NAME}.tar.gz
    # echo "===================== Chaincode is installed on peer1.producer2 ===================== "

    setGlobalsForHospital1Peer0
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.hospital1 ===================== "

    setGlobalsForHospital2Peer0
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.hospital2 ===================== "
}

queryInstalled() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.producer1 on channel ===================== "
}

approveForMyProducer1() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION}

    echo "===================== chaincode approved from Producer1 ===================== "
}

approveForMyProducer2() {
    setGlobalsForProducer2Peer0
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION} \

    echo "===================== chaincode approved from Producer2 ===================== "
}

approveForMyHospital1() {
    setGlobalsForHospital1Peer0
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION} \

    echo "===================== chaincode approved from Hospital1 ===================== "
}

approveForMyHospital2() {
    setGlobalsForHospital2Peer0
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --version ${VERSION} --init-required --package-id ${PACKAGE_ID} \
        --sequence ${VERSION} \

    echo "===================== chaincode approved from Hospital2 ===================== "
}

checkCommitReadyness() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from Producer1 ===================== "
}

commitChaincodeDefinition() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        --version ${VERSION} --sequence ${VERSION} --init-required
}

queryCommitted() {
    setGlobalsForProducer1Peer0
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
}

chaincodeInvokeInit() {
    setGlobalsForProducer1Peer0
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        --isInit -c '{"Args":[]}'
}

chaincodeInitLedger() {
    ## Init ledger
    setGlobalsForProducer1Peer0
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_PRODUCER1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_PRODUCER2_CA \
        --peerAddresses localhost:11051 --tlsRootCertFiles $PEER0_HOSPITAL1_CA \
        --peerAddresses localhost:12051 --tlsRootCertFiles $PEER0_HOSPITAL2_CA \
        -c '{"function": "initLedger","Args":[]}'
}

# Run this function if you add any new dependency in chaincode
presetup

packageChaincode
installChaincode
queryInstalled
approveForMyProducer1
checkCommitReadyness
approveForMyProducer2
checkCommitReadyness
approveForMyHospital1
checkCommitReadyness
approveForMyHospital2
checkCommitReadyness
commitChaincodeDefinition
queryCommitted
chaincodeInvokeInit
sleep 5s
chaincodeInitLedger