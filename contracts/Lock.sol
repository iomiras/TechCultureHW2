//SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

contract DumbToken {
    uint256 public tokenTotal = 1000000e18;

    address public minter;

    string tokenName = "DumbToken";
    string TokenSymbol = "DMB";
    uint tokenDecimals = 18;

    mapping(address => bool) private blackList;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allow;

    function blockUser(address addressToBlock) external returns (bool) {
        require(!blackList[addressToBlock], "This user is already blocked");
        blackList[addressToBlock] = true;
        return true;
    }

    constructor() {
        minter = msg.sender;
    }

    function name() public view returns (string memory) {
        return tokenName;
    }

    function symbol() public view returns (string memory) {
        return TokenSymbol;
    }

    function decimals() public view returns (uint) {
        return tokenDecimals;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "You're not allowed to mint!");
        balances[receiver] += amount;
    }

    function totalSupply() public view returns (uint256) {
        return tokenTotal;
    }

    function balanceOf(address account) external view returns (uint) {
        return balances[account];
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        require(
            !blackList[msg.sender],
            "You can't send money. You are in Black list"
        );
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        require(!blackList[msg.sender], "You are in Black list");
        allow[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allow[msg.sender][spender] = amount;
        emit Approve(msg.sender, spender, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return allow[owner][spender];
    }

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approve(address indexed owner, address indexed spender, uint amount);
}
