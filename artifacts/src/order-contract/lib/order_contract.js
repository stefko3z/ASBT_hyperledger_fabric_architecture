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
        let cid = new ClientIdentity(ctx.stub);

        // Counter for ids
        let id = 1000;
        await ctx.stub.putState('counter', Buffer.from(id.toString()));
	placeOrder(ctx, "Producer1MSP", 5)

	console.info('============= END : Initialize Ledger ===========');
    }

    async getOrder(ctx, orderId) {
        const orderAsBytes = await ctx.stub.getState(orderId);
        if(!orderAsBytes || orderAsBytes.length === 0) {
            throw new Error(`${orderId} does not exist`);
        }

        return orderAsBytes.toString();
    }

    async getAllOrders(ctx) {
        const startKey = 'o1000';
        const endKey = 'o9999';
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

    // Commisions an order of a certain size to a producer of choice
    async placeOrder(ctx, acceptorMSPID, size) {
        let cid = new ClientIdentity(ctx.stub);
        let n = parseInt(size);

        if(!HospitalMSPIDs.includes(cid.getMSPID())) {
            throw new Error(`Error: ${cid.getMSPID()} is not a valid hospital`);
        }
        if(!ProducerMSPIDs.includes(acceptorMSPID)) {
            throw new Error(`Error: ${acceptorMSPID} is not a valid producer`);
        }
        if(n <= 0) {
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
        let order = JSON.parse(getOrder(ctx, orderId));

        if(order.acceptor != cid.getMSPID()) {
            throw new Error(`Error: ${cid.getMSPID()} is not authorized to accept`);
        }

        order.status = OrderStatus.accepted;
        await ctx.stub.putState(orderId, Buffer.from(JSON.stringify(order)));
    }

    async checkAcceptor(orderId, acceptorMSPID) {
	let order = JSON.parse(getOrder(ctx, orderId));
	if(order.acceptor != acceptorMSPID) {
	   throw new Error(`Error: ${cid.getMSPID()} does not own ${orderId}`);
        }
    }

    async checkStatus(orderId) {
       let order = JSON.parse(getOrder(ctx, orderId));
       if(order.status == OrderStatus.placed) {
           throw new Error(`Error: ${orderId} has not been accepted`);
        }

       if(order.status == OrderStatus.completed) {
           throw new Error(`Error: ${orderId} is full`);
        }
    }

    async checkCapacity(orderId, quantity) {
      let order = JSON.parse(getOrder(ctx, orderId));
      if((order.vaccineList.length + quantity) > order.size) {
          throw new Error(`Error: ${orderId} can not fit that many vaccines`);
      }
    }

    async addVaccineToList(vaccineId, orderId) {
      let order = JSON.parse(getOrder(ctx, orderId));
      order.vaccineList.push(vaccineId);
      await ctx.stub.putState(orderId, Buffer.from(JSON.stringify(order)));
    }

    async checkCompleteness(orderId) {
      let order = JSON.parse(getOrder(ctx, orderId));
      if(order.vaccineList.length == order.size) {
	  order.status = OrderStatus.completed;
          await ctx.stub.putState(orderId, Buffer.from(JSON.stringify(order)));
      }
    }
}

module.exports = OrderContract;
