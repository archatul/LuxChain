// Abstract contract for Luxury Good Blockchain
// Contract for creation, selling, reselling, insurance of Luxury Goods 

pragma solidity ^0.4.8;

contract LuxChain {

    // to store manufactuer name, only manufacturer will be allowed to create a product
    address owner;
    
    // to store all details & history about a praticular product
    struct Product {
        address[] owner;
        address insurer;
        bool stolen;
    }
    
    // map to store the product # and Product details
    mapping (uint => Product) provenance;

    /// @param productNumber The Product that is created/manufactured
    /// @return Whether the product was created or not    
    function createProduct(uint productNumber) public returns (bool success);

    /// @param productNumber The Product that needs to be sold
    /// @param toAddress The address to which the product needs to be sold
    /// @return Whether the product was sold or not
    function sellProduct(uint productNumber, address toAddress) public returns (bool success);

    /// @param productNumber The Product that needs to be transferred
    /// @param toAddress The address to which the product needs to be transferred to
    /// @return Whether the product was transferred or not
    function resellProduct(uint productNumber, address toAddress) public returns (bool success);
    
    /// @param productNumber The Product for which owner will be returned
    /// @return curren owner of the product
    function currentOwner(uint productNumber) public constant returns (address ownerAddress);
    
    /// @param productNumber The Product that needs to be insured
    /// @param ownerAddress The address to which the product currently belongs
    /// @return Whether the insurer was successfully added or not
    function recordInsurance(uint productNumber, address ownerAddress) public returns (bool success);
    
    /// @param productNumber The Product that needs to be reported as stolen
    /// @return Whether the product was reported stolen or not
    function reportStolen(uint productNumber) public returns (bool success);
    
    /// @param productNumber The Product for which ownership needs to be verified
    /// @param ownerAddress The owner address for the product
    /// @return Whether the ownership is verified or not
    function verifyOwnership(uint productNumber, address ownerAddress) public constant returns (bool verified);

    /// @param productNumber The Product for which ownership needs to be changed
    /// @param ownerAddress The owner address for the product
    /// @return Whether the ownership is changed or not
    function changeOwnership(uint productNumber, address ownerAddress) public returns (bool success);
    
    /// @param productNumber The Product for which the current state will be returned
    /// @return whether the product is stolen or not
    function isProductStolen(uint productNumber) public constant returns (bool isStolen);
    
    /// event to be triggered when a product is reported stolen
    event ProductStolen (uint productNumber, address currentOwner);
    /// event to be triggered when an attempt to resell stolen product is made
    event AttemptToResellSolenProduct (uint productNumber, address fromAddress, address toAddress, address insurer);
}
