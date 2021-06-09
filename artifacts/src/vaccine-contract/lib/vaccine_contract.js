'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;


const ProducerMSPIDs = [
    "Producer1MSP",
    "Producer2MSP"
];

const VaccineStatus = {
    produced: "PRODUCED",
    shipped: "SHIPPED",
    received: "RECEIVED",
    instock: "INSTOCK",
    administered: "ADMINISTERED",
    disposed: "DISPOSED"
}

class VaccineContract extends Contract {
    
    // Dummy function to prepopulate the ledger with info
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        let cid = new ClientIdentity(ctx.stub);

        // Counter for ids
        let id = 1000;

        const vaccines = [
            {
                id: `v${id}`,
                name: 'Zenika',
                producerMSPID: cid.getMSPID(),
                status: VaccineStatus.disposed,
                location: cid.getMSPID(),
                administeredOnPerson: null,
                administeredAtLocation:null,
                administeredOnDate: null
            }
        ];
        await ctx.stub.putState(`v${id}`, Buffer.from(JSON.stringify(vaccines[0])));
        
        id = id + 1;
        await ctx.stub.putState('counter', Buffer.from(id.toString())); 
            
        console.info('============= END : Initialize Ledger ===========');
    }

    async getVaccine(ctx, vaccineId) {
        const vaccineAsBytes = await ctx.stub.getState(vaccineId);
        if(!vaccineAsBytes || vaccineAsBytes.length === 0) {
            throw new Error(`${vaccineId} does not exist`);
        }

        return vaccineAsBytes.toString();
    }

    async getAllVaccines(ctx) {
        const startKey = 'v1000';
        const endKey = 'v9999';
        const allResults = [];
        for await (const {key, value} of ctx.stub.getStateByRange(startKey, endKey)) {
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

    // Creates n numbers and puts them on the blockchain
    async produce(ctx, name, quantity) {
        let cid = new ClientIdentity(ctx.stub);
        let n = parseInt(quantity);

        if(!ProducerMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid producer`);
        }

        if(n <= 0) {
            throw new Error(`Error: quantity: ${quantity} must be > 0`);
        }

        let id = parseInt(await ctx.stub.getState('counter'));
        for(var i = 0; i < n; i++) {
            
            let vaccine = {
                id: `v${id}`,
                name: name,
                producerMSPID: cid.getMSPID(),
                status: VaccineStatus.produced,
                location: cid.getMSPID(),
                administeredOnPerson: null,
                administeredAtLocation:null,
                administeredOnDate: null
            }
            id = id + 1;
            await ctx.stub.putState(`v${id}`, Buffer.from(JSON.stringify(vaccine)));
            await ctx.stub.putState('counter', Buffer.from(id.toString()));
        }
    }

    async ship(ctx, recipient, vaccineList) {

    }
}

module.exports = VaccineContract;