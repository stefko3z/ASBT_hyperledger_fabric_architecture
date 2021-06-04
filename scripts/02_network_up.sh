#!/bin/bash
# Go to docker-compose file
pushd ./artifacts/

# Start network
echo "Starting Fabric network"
docker-compose up -d 

# Wait for all containers to start
sleep 5s
docker ps

popd 