
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

export CHANNEL_NAME=mychannel

# setGlobalsForOrderer(){
#     export CORE_PEER_LOCALMSPID="OrdererMSP"
#     export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
#     export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp
    
# }

# Producer1
export PEER0_PRODUCER1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer1.example.com/peers/peer0.producer1.example.com/tls/ca.crt

setGlobalsForProducer1Peer0(){
    export CORE_PEER_LOCALMSPID="Producer1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PRODUCER1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer1.example.com/users/Admin@producer1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForProducer1Peer1(){
    export CORE_PEER_LOCALMSPID="Producer1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PRODUCER1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer1.example.com/users/Admin@producer1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
}

# Producer2
export PEER0_PRODUCER2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer2.example.com/peers/peer0.producer2.example.com/tls/ca.crt

setGlobalsForProducer2Peer0(){
    export CORE_PEER_LOCALMSPID="Producer2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PRODUCER2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer2.example.com/users/Admin@producer2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051   
}

setGlobalsForProducer2Peer1(){
    export CORE_PEER_LOCALMSPID="Producer2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_PRODUCER2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/producer2.example.com/users/Admin@producer2.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
}