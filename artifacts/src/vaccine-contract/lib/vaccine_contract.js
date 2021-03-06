'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;


const ProducerMSPIDs = [
    "Producer1MSP",
    "Producer2MSP"
];

const HospitalMSPIDs = [
    "Hospital1MSP",
    "Hospital2MSP"
];

const VaccineStatus = {
    produced: "PRODUCED",
    shipped: "SHIPPED",
    received: "RECEIVED",
    administered: "ADMINISTERED",
    disposed: "DISPOSED"
}

class VaccineContract extends Contract {

    // Dummy function to prepopulate the ledger with info
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');

        // Counter for ids
        let id = 1000;
        await ctx.stub.putState('counter', Buffer.from(id.toString()));

        console.info('============= END : Initialize Ledger ===========');
    }

    async getVaccine(ctx, vaccineId) {
        const vaccineAsBytes = await ctx.stub.getState(vaccineId);
        if (!vaccineAsBytes || vaccineAsBytes.length === 0) {
            throw new Error(`${vaccineId} does not exist`);
        }

        return vaccineAsBytes.toString();
    }

    async getAllVaccines(ctx) {
        const startKey = 'v1000';
        const endKey = 'v9999';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push({ Key: key, Record: record });
        }

        return JSON.stringify(allResults);
    }

    async getAllVaccinesForOrder(ctx, orderId) {
        const startKey = 'v1000';
        const endKey = 'v9999';
        const allResults = [];
        for await (const { key, value } of ctx.stub.getStateByRange(startKey, endKey)) {
            const strValue = Buffer.from(value).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            if(record.orderId == orderId) {
                allResults.push({ Key: key, Record: record });
            }  
        }

        return JSON.stringify(allResults);
    }

    // Creates n numbers and puts them on the blockchain
    async produce(ctx, orderId, quantity) {
        let cid = new ClientIdentity(ctx.stub);
        let n = parseInt(quantity);

        if (!ProducerMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid producer`);
        }

        if (n <= 0) {
            throw new Error(`Error: quantity: ${quantity} must be > 0`);
        }
        
        let ccArgs = ['verifyOrderUpdate', orderId, cid.getMSPID(), quantity];
        await ctx.stub.invokeChaincode('order', ccArgs, 'mychannel');

        let id = parseInt(await ctx.stub.getState('counter'));
        for (var i = 0; i < n; i++) {

            let vaccine = {
                id: `v${id}`,
                producerMSPID: cid.getMSPID(),
                status: VaccineStatus.produced,
                owner: cid.getMSPID(),
                orderId: orderId,
                location: cid.getMSPID(),
                administeredOnPerson: null,
                administeredAtLocation: null,
                administeredOnDate: null
            }
            // place vaccine on ledger
            await ctx.stub.putState(`v${id}`, Buffer.from(JSON.stringify(vaccine)));

            // increment ledger
            id = id + 1;
            await ctx.stub.putState('counter', Buffer.from(id.toString()));
        }
    }

    // Ships the listed vaccines to the hospital in recipient
    async ship(ctx, recipientMSPID, vaccineListAsString) {
        let cid = new ClientIdentity(ctx.stub);
        let vaccineList = JSON.parse(vaccineListAsString);

        if (!ProducerMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid producer`);
        }

        if (!HospitalMSPIDs.includes(recipientMSPID)) {
            throw new Error(`Error: ${recipientMSPID} is not a valid hospital`);
        }

        if (!Array.isArray(vaccineList) || vaccineList.length == 0) {
            throw new Error(`Error: vaccineList is empty or not an array`);
        }

        for (let id of vaccineList) {
            let vaccineAsBytes = await ctx.stub.getState(id);
            if (!vaccineAsBytes || vaccineAsBytes.length === 0) {
                throw new Error(`${id} does not exist`);
            }

            let vaccine = JSON.parse(Buffer.from(vaccineAsBytes).toString('utf8'));

            if (vaccine.producerMSPID != cid.getMSPID()) {
                throw new Error(`Error: ${cid.getMSPID()} does not own ${id}`);
            }

            if (vaccine.status != VaccineStatus.produced) {
                throw new Error(`Error: Invalid state for ${id}`);
            }

            vaccine.owner = recipientMSPID;
            vaccine.status = VaccineStatus.shipped;
            vaccine.location = "TRANSIT";

            await ctx.stub.putState(vaccine.id, Buffer.from(JSON.stringify(vaccine)));
        };
    }

    // Acknowledges vaccines as successfuly shipped
    async acknowledgeShipment(ctx, vaccineListAsString) {
        let cid = new ClientIdentity(ctx.stub);
        let vaccineList = JSON.parse(vaccineListAsString);

        if (!HospitalMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid hospital`);
        }

        if (!Array.isArray(vaccineList) || vaccineList.length == 0) {
            throw new Error(`Error: vaccineList is empty or not an array`);
        }

        for (let id of vaccineList) {
            let vaccineAsBytes = await ctx.stub.getState(id);
            if (!vaccineAsBytes || vaccineAsBytes.length === 0) {
                throw new Error(`${id} does not exist`);
            }

            let vaccine = JSON.parse(Buffer.from(vaccineAsBytes).toString('utf8'));

            if (vaccine.owner != cid.getMSPID()) {
                throw new Error(`Error: ${cid.getMSPID()} does not own ${id}`);
            }

            if (vaccine.status != VaccineStatus.shipped) {
                throw new Error(`Error: Invalid state for ${id}`);
            }

            vaccine.status = VaccineStatus.received;
            vaccine.location = cid.getMSPID;

            await ctx.stub.putState(vaccine.id, Buffer.from(JSON.stringify(vaccine)));
        };
    }
}

module.exports = VaccineContract;
