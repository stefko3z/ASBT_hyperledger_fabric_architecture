#!/bin/bash
# Go to docker-compose file
pushd ./artifacts/

# Stop network and remove volumes
echo "Stopping Fabric network"
docker-compose down -v --remove-orphans

# Prune unused containers
docker container prune -f

# Prune unused volumes
docker volume prune -f

# Prune unused volumes
docker image prune -f

popd 