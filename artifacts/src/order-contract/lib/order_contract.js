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

const OrderStatus = {
    placed: "PLACED",
    accepted: "ACCEPTED",
    completed: "COMPLETED"
}

class OrderContract extends Contract {

    // Dummy function to prepopulate the ledger with info
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');

        // Counter for ids
        let id = 1000;
        await ctx.stub.putState('counter', Buffer.from(id.toString()));

        console.info('============= END : Initialize Ledger ===========');
    }

    async getOrder(ctx, orderId) {
        const orderAsBytes = await ctx.stub.getState(orderId);
        if (!orderAsBytes || orderAsBytes.length === 0) {
            throw new Error(`${orderId} does not exist`);
        }

        return orderAsBytes.toString();
    }

    async getAllOrders(ctx) {
        const startKey = 'o1000';
        const endKey = 'o9999';
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

    // Commisions an order of a certain size to a producer of choice
    async placeOrder(ctx, acceptorMSPID, size) {
        let cid = new ClientIdentity(ctx.stub);
        let n = parseInt(size);

        if (!HospitalMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid hospital`);
        }
        if (!ProducerMSPIDs.includes(acceptorMSPID)) {
            throw new Error(`Error: ${acceptorMSPID} is not a valid producer`);
        }
        if (n <= 0) {
            throw new Error(`Error: size: ${size} must be > 0`);
        }

        let id = parseInt(await ctx.stub.getState('counter'));

        let order = {
            id: `o${id}`,
            status: OrderStatus.placed,
            creator: cid.getMSPID(),
            acceptor: acceptorMSPID,
            size: n,
            vaccineList: []
        }
        await ctx.stub.putState(`o${id}`, Buffer.from(JSON.stringify(order)));

        id = id + 1;
        await ctx.stub.putState('counter', Buffer.from(id.toString()));
    }

    // Accepts the placed order
    async accept(ctx, orderId) {
        let cid = new ClientIdentity(ctx.stub);
        let order = JSON.parse(await this.getOrder(ctx, orderId));

        if (order.acceptor != cid.getMSPID()) {
            throw new Error(`Error: ${cid.getMSPID()} is not authorized to accept`);
        }

        order.status = OrderStatus.accepted;
        await ctx.stub.putState(orderId, Buffer.from(JSON.stringify(order)));
    }

    async getOrderStatusEnum(ctx) {
        return OrderStatus;
    }

    async addVaccineToOrder(ctx, orderId, vaccineId) {
        let cid = new ClientIdentity(ctx.stub);

        let order = JSON.parse(await this.getOrder(ctx, orderId));

        let ccArgs = ['getVaccine', vaccineId];
        let vaccineString = await ctx.stub.invokeChaincode('vaccine', ccArgs, 'mychannel');
        let vaccine = JSON.parse(Buffer.from(vaccineString.payload));
        
        if(order.acceptor != cid.getMSPID()) {
            throw new Error(`Error: ${cid.getMSPID()} is not assigned ${order.id}. Order is assigned to ${order.acceptor}`);
        }

        if(vaccine.orderId != orderId) {
            throw new Error(`Error: ${vaccine.orderId} does not match order ${order.id}`);
        } 

        if(order.vaccineList.includes(vaccine.orderId)) {
            throw new Error(`Error: ${order.id} already includes ${vaccine.orderId}`);
        }

        order.vaccineList.push(vaccine.id);
        await ctx.stub.putState(order.id, Buffer.from(JSON.stringify(order)));
    }

    async verifyOrderUpdate(ctx, orderId, producerMSPID, numberOfVaccines) {
        let order = JSON.parse(await this.getOrder(ctx, orderId));
        if (order.status == OrderStatus.placed) {
            throw new Error(`Error: ${orderId} has not been accepted`);
        }

        if (order.status == OrderStatus.completed) {
            throw new Error(`Error: ${orderId} has been completed`);
        }

        if (order.acceptor != producerMSPID) {
            throw new Error(`Error: ${cid.getMSPID()} does is not assigned to ${orderId}`);
        }

        if (order.vaccineList.length + numberOfVaccines > order.size) {
            throw new Error(`Error: ${order.vaccineList.length + numberOfVaccines} exceeds ${orderId} capacity`);
        }

        return true;
    }
}

module.exports = OrderContract;
