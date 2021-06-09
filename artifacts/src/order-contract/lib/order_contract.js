'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

class OrderContract extends Contract {
    
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        // demo
        const orders = [
            {
                attr1: 'Yes',
                attr2: 'Yash',
                attr3: 'Yay'
            }
        ];

        await ctx.stub.putState('o1', Buffer.from(JSON.stringify(orders[0])));

        // Counter for ids
        let init = 2;
        await ctx.stub.putState('counter', Buffer.from(init.toString()));  // Hacky solution
            
        console.info('============= END : Initialize Ledger ===========');
    }

}

module.exports = OrderContract;