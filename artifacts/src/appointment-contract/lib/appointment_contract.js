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

const PrivateDataCollection = "collectionAppointments";

class AppointmentContract extends Contract {

    // Dummy function to prepopulate the ledger with info
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');

        // Counter for ids
        let id = 1000;
        await ctx.stub.putState('counter', Buffer.from(id.toString()));

        console.info('============= END : Initialize Ledger ===========');
    }
    
    // Creates a private data appointment for the user by using his personalId as a number
    async createAppointment(ctx) {
        let data = await ctx.stub.getTransient();

        let parsedDetails = JSON.parse(Buffer.from(data.get("details")).toString('utf8'));
        console.info(parsedDetails);
        // IMPORTANT: This is not a real hash function, we use it as a placeholder as it is inbuilt
        // in the future or if you use the project as refference please use a real hash function
        let hashedId = parsedDetails.personalId;

        let entry = {
            name: parsedDetails['name'],
            personalId: parsedDetails['personalId'],
            age: parsedDetails['age'],
            gender: parsedDetails['gender']
        }
        entry = JSON.stringify(entry);

        await ctx.stub.putPrivateData(PrivateDataCollection, hashedId, entry);
    }

    async getAppointment(ctx, personalId) {
        let cid = new ClientIdentity(ctx.stub);

        // IMPORTANT: This is not a real hash function, we use it as a placeholder as it is inbuilt
        // in the future or if you use the project as refference please use a real hash function
        let hashedId = personalId;
 
        let data = await ctx.stub.getPrivateData(PrivateDataCollection, hashedId);

        return Buffer.from(data).toString('utf-8');
    }
}

module.exports = AppointmentContract;
