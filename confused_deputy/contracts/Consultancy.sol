pragma solidity ^0.4.11;
//Abstract Inbox that Consultancy uses
contract Inbox{
    function save(string _data);
}

contract Customer is Inbox{
    string message;
    function Customer(){}
    //the save function is public and accessible by everyone
    function save(string _data){ message = _data; }
}

contract Bill is Inbox{
    address owner;
    string billing;
    modifier ownerOnly(){ require(msg.sender == owner);_;}
    function Bill(){ owner = msg.sender; }
    //the save function call can only be triggered by the owner(Consultant)
    function save(string _data) ownerOnly { billing = _data; }
}

contract Consultant{
    address owner;
    address myBill;
    function Consultant(address _bill) {
        owner = msg.sender;
        myBill = _bill;
    }
    function hire(address _customer, string _price){
        //the consultant is supposed to bill the customer in a separate contract
        Inbox(myBill).save(_price); 
        //then deliver the work into the customer ...
        Inbox(_customer).save("Work done for you");
        //confused deputy problem arises when a malicious customer passes the address of the myBill as _customer
        //even though the customer cannot call save on myBill, this is done through the confused deputy (Consultancy)
        //the consultant overwrites his bill with the work intended for the customer
    }
}
