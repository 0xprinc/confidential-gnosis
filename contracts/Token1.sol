pragma solidity >=0.7.0 <0.9.0;

contract Token1 {
    string public name = "token1";
    string public symbol = "token1";
    uint8  public decimals = 18;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);

    mapping(address => uint) public  balanceOf;
    mapping(address => mapping(address => uint)) internal  allowance;

    function getallowance(address from, address to) public view returns (uint) {
        return allowance[from][to];
    }

    function mint(address to, uint256 amount) public {
        balanceOf[to] += amount;
    }

    function burn(uint256 wad) public {
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] -= wad;
    }

    function totalSupply() public view returns (uint) {
        return address(this).balance;
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    function approve(address guy, uint256 wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }

    function transfer(address dst, uint wad) public returns (bool){
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
    public
    returns (bool)
    {
        // require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        // balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        emit Transfer(src, dst, wad);

        return true;
    }
}