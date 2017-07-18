var Escrow = artifacts.require("Escrow")
var USD = artifacts.require("USD");
var GBP = artifacts.require("GBP")
var world = web3.eth.accounts[0];
var alice = web3.eth.accounts[1];
var bob = web3.eth.accounts[2];

//save USD mint address
module.exports = function(callback,network,accounts) {

    USD.deployed().then(function(instance){
        return instance.transfer(alice,100,{from: world});
    }).then(function(result){
        console.log(result.logs[0].args);
    }).catch(function(e){ console.log(e)});

    USD.deployed().then(function(instance){
        return instance.approve(Escrow.address, 50, {from: alice});
    }).then(function(result){
        console.log(result.logs[0].args);
    }).catch(function(e){ console.log(e)});

    USD.deployed().then(function(instance){
        return instance.getAllowance.call(alice,Escrow.address,{from: world});
    }).then(function(result){
        console.log(result.toNumber());
    }).catch(function(e){ console.log(e)});

    Escrow.deployed().then(function(instance){
        return instance.seller_deposit(USD.address, 1, {from: alice});
    }).then(function(result){
        console.log(result.logs[0].args);
    }).catch(function(e){ console.log(e)});

    USD.deployed().then(function(instance){
        return instance.balanceOf.call(Escrow.address,{from: world});
    }).then(function(result){
        console.log(result.toNumber());
    }).catch(function(e){ console.log(e)});

}
