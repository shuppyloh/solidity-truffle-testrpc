pragma solidity ^0.4.11;
contract AbstractMint { 
    function balanceOf(address user) returns (uint256);
    function transfer(address to, uint256 value) returns (bool success);
    function transferFrom(address from, address to, uint256 value) returns (bool success);
} 

contract Escrow {
    address public escrowOwner;

    address public seller;
    AbstractMint public seller_mint;
    uint256 public seller_value;

    address public buyer;
    AbstractMint public buyer_mint;
    uint256 public buyer_value;

    enum State { None, Confirm, Locked }
    State public seller_state;
    State public buyer_state;
    event BuyerDeposit(address indexed buyer, uint256 buyer_value);
    event SellerDeposit(address indexed seller, uint256 seller_value);
    event Deal(address indexed seller, uint256 seller_value, address indexed buyer, uint256 buyer_value);

    //modifiers (access controls)
    modifier buyerOnly() { require(msg.sender == buyer);_; }
    modifier sellerOnly() { require(msg.sender == seller);_; }
    modifier atState(State _caller, State _state){
        assert(_caller == _state);
        _caller = State.Locked;
        _;
    }

    function Escrow(){
        escrowOwner = msg.sender;
        buyer_state = State.None;
        seller_state = State.None;
    }

    //deposit throws if the deposit failed.
    //returns false if (deposit is successful && deal is NOT successful)
    //returns true if (deposit is successful && deal IS successful)
    function buyer_deposit(address _buyer_mint, uint256 _buyer_value) 
            atState(buyer_state, State.None) 
            returns (bool success) {
        buyer = msg.sender;
        buyer_mint = AbstractMint(_buyer_mint);
        buyer_value = _buyer_value;
        if (buyer_mint.transferFrom(buyer, address(this), buyer_value)==true){
            BuyerDeposit(buyer,buyer_value);
            if (seller_state == State.Confirm && buyer_state == State.Confirm){
                deal();
            }
            return true;
        } else throw; 
    }
    function seller_deposit(address _seller_mint, uint256 _seller_value) 
            atState(seller_state, State.None) 
            returns (bool success) {
        seller = msg.sender;
        seller_mint = AbstractMint(_seller_mint);
        seller_value = _seller_value;
        if(seller_mint.transferFrom(seller, this, seller_value)==true){
            SellerDeposit(seller, seller_value);
            if (seller_state == State.Confirm && buyer_state == State.Confirm){
                deal();
            }
            return true;
        } else throw; 
            
    }
    function buyer_cancel()
            buyerOnly 
            atState(buyer_state, State.Confirm) 
            returns (bool success) {
        buyer_mint.transfer(buyer, buyer_value);
        buyer_state = State.None;
        return true;
    }

    function seller_cancel() 
            sellerOnly 
            atState(seller_state, State.Confirm) 
            returns (bool success) {
        seller_mint.transfer(seller, seller_value);
        seller_state = State.None;
        return true;
    }


    function deal() private {
        seller_mint.transfer(buyer, seller_value);
        buyer_mint.transfer(seller, buyer_value);
        Deal(seller, seller_value, buyer, buyer_value);
    }
}
