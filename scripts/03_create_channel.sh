#!/bin/bash
# source definitions
. scripts/00_environmental_variables.sh

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForProducer1Peer0
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

joinChannel(){
    setGlobalsForProducer1Peer0
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForProducer1Peer1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForProducer2Peer0
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForProducer2Peer1
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
}

updateAnchorPeers(){
    setGlobalsForProducer1Peer0
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForProducer2Peer0
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

createChannel
joinChannel
updateAnchorPeers