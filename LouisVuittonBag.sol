/* 
// Contract for creation, selling, reselling, insurance of Luxury Bag 

*/
pragma solidity 0.4.19;

import "./LuxChain.sol";

contract LouisVuittonBag is LuxChain {
    
    /* Constructor to assign the owner of the contract - manufacturer */
    function LouisVuittonBag () public {
        owner = msg.sender;
    }
    
    // modifier to check if the manufacturer is invoking a function
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function createProduct(uint productNumber) onlyOwner public returns (bool success) {
         // Only manufacturer can create a product
            var newProduct = provenance[productNumber];
            newProduct.owner.push(msg.sender);
            newProduct.insurer = 0;
            newProduct.stolen = false;
            return true;
    }
    
    function sellProduct(uint productNumber, address toAddress) public returns (bool success) {
        // Only manufacturer can initially sell the product
        // manufacturer can sell a product only if it was already created and not sold
        if(provenance[productNumber].owner.length == 1 && provenance[productNumber].owner[0] == msg.sender){
            provenance[productNumber].owner.push(toAddress);
            return true;
        }
    }
    
    function resellProduct(uint productNumber, address toAddress) public returns (bool success) {
        // Current Owner can only resell a product
        uint length = provenance[productNumber].owner.length;
        if(!isProductStolen(productNumber)) {
            if(provenance[productNumber].owner[length-1] == msg.sender){
                provenance[productNumber].owner.push(toAddress);
                return true;
            }
            return false;
        }
        // Record an event when resell is called on stolen product
        AttemptToResellSolenProduct (productNumber, msg.sender, toAddress, provenance[productNumber].insurer);
    }
    
    function currentOwner(uint productNumber) public constant returns (address ownerAddress) {
        // anyone can request this information
        uint length = provenance[productNumber].owner.length;
        return provenance[productNumber].owner[length-1];
    }
    

    function recordInsurance(uint productNumber, address ownerAddress) public returns (bool success){
        // Product has to be created and sold for insurance to be recorded
        uint length = provenance[productNumber].owner.length;
        if(length > 1 && provenance[productNumber].owner[length-1] == ownerAddress){
            provenance[productNumber].insurer = 0;
            provenance[productNumber].insurer = msg.sender;
            return true;
        }
        return false;
    }

    function reportStolen(uint productNumber) public returns (bool success){
        // Product has to be created and sold for reporting it to be stolen
        uint length = provenance[productNumber].owner.length;
        if(length > 1 && provenance[productNumber].owner[length-1] == msg.sender){
            provenance[productNumber].stolen = true;
            // Record a ProductStolen event
            ProductStolen(productNumber, provenance[productNumber].owner[length-1]);
            return true;
        }
        return false;
    }
    

    function verifyOwnership(uint productNumber, address ownerAddress) public constant returns (bool verified) {
        uint length = provenance[productNumber].owner.length;
        if(provenance[productNumber].owner[length-1] == ownerAddress){
            return true;
        }
        return false;
    }


    function changeOwnership(uint productNumber, address ownerAddress) public returns (bool success){
        // Called by Insurance company to claim ownership after an insurance claim is fulfilled
        // Original owner should have reported this product as stolen before the ownership can be changed
        if(verifyOwnership(productNumber,ownerAddress) && provenance[productNumber].insurer == msg.sender && provenance[productNumber].stolen){
            provenance[productNumber].owner.push(msg.sender);
            return true;
        }
        return false;
    }
    
    function isProductStolen(uint productNumber) public constant returns (bool isStolen){
        return provenance[productNumber].stolen;
    }
    
}