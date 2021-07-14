This project is part of the seminar Advanced Seminar Blockchain Technologies (IN2107, IN4909) and is part of a paper submitted for said course.

It represents a dummy model of a vaccine disbribution system with three chaincodes: vaccine, order, appointment

Prerequisites
To run the network please make sure the following have been installed:

1. hyperledger fabric binaries https://hyperledger-fabric.readthedocs.io/en/release-2.3/install.html
2. Go and the GOPATH variable
3. npm and node
4. create a `channel-artifacts` folder in project directory

Quickstart (run from root project directory):
1. Run `bash network_setup.sh` to create crypto configurations 
2. Run `bash network_start.sh` starts the network
3. Run `bash scripts/05_invoke_chaincode.sh` (run from project root directory) to execute an example workflow
4. Run `bash network_stop.sh` to stop the network
WARNING: step 4 deletes all containers, as Hyperledger Fabric creates anynomous containers for chaincode, this doesn't get picked up well by docker-compose

All scripts are available in the scripts directory:
Manual setup: Run scripts from 01 to 05 from project root directory.

The explorer directory contains a template for fabric explorer, wasn't used in the project.



