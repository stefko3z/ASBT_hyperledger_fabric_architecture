'use strict';

const { Contract } = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

class VaccineContract extends Contract {
    
    async initLedger(ctx) {
        console.info('============= START : Initialize Ledger ===========');
        // demo
        const vaccines = [
            {
                attr1: 'Yes',
                attr2: 'Yash',
                attr3: 'Yay'
            }
        ];

        await ctx.stub.putState('v1', Buffer.from(JSON.stringify(vaccines[0])));

        // Counter for ids
        let init = 2;
        await ctx.stub.putState('counter', Buffer.from(init.toString()));  // Hacky solution
            
        console.info('============= END : Initialize Ledger ===========');
    }

}

module.exports = VaccineContract;