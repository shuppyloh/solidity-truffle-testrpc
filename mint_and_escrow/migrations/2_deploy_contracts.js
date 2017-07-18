var Escrow = artifacts.require("Escrow")
var USD = artifacts.require("USD");
var GBP = artifacts.require("GBP")

module.exports = function(deployer,network,accounts) {
    deployer.deploy(USD,1000,"USD",2,"USD",{from: accounts[0]});
    deployer.deploy(GBP,1000,"GBP",2,"GBP",{from: accounts[0]});
    deployer.deploy(Escrow, {from: accounts[1]}); 
};
