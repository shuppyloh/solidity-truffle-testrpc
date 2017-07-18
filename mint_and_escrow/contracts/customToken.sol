pragma solidity ^0.4.11;
contract customToken{
    /* Public variables of the token */
    address public minter;
    string public standard = 'Token';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address=>uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Approve(address indexed spender, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function customToken( uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) { 
        minter = msg.sender;
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
    }
    function mint(address _to, uint256 _value) returns (bool success) {
        if (msg.sender != minter) throw;
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[_to] += _value;
        Mint(_to, _value);
        return true;
    }

    /* Send coins*/
    function getAllowance(address origin, address approved) returns (uint256){
        return allowance[origin][approved];
    }
    function balanceOf(address user) returns (uint256){
        return balanceOf[user];
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }
    /* Send coins*/
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)  {
        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;    // Check if sender has authorisation AND enough allowance 
        allowance[_from][msg.sender] -= _value;              // Substract from allowance
        balanceOf[_from] -= _value;                           // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(_from, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }

    function approve(address _spender, uint256 _value) returns (bool success){
        allowance[msg.sender][_spender] = _value;
        Approve(_spender, _value);
        return true;
    }

    event Burn(address indexed from, uint256 value);
    function burn(uint256 _value) returns (bool success) {
        if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
        balanceOf[msg.sender] -= _value;                      // Subtract from the sender
        totalSupply -= _value;                                // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

}
