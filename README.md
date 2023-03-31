# GoldNFT by QuillAcademy

# Description
You are a magician, Just wave your wand and magically bypass the password required to mint these NFTs.

# Objective of CTF
Retrieve the password from IPassManager and mint at least 10 NFTs.

# Hacking Process
Reverse engineered the bytecode provided in the etherscan by;
 - Downloading/Exporting function signatures provided by the [openchain api](https://openchain.xyz/signatures)
 - Loop through the downloded function signatures and compared with those found in the bytcode by making requests against the [etherface api](https://api.etherface.io)
 - Printed out the possible matches found in the bytecode

Here is a snapshot of the result
<img width="1007" alt="Screenshot 2023-03-31 at 16 57 55" src="https://user-images.githubusercontent.com/26023424/229170906-1f40baff-deb0-4f05-bfa1-e2425d377b6f.png">

 - The set function accepts a bytes32 and a boolean
 - The read function implemented in the GoldNFT contract accepts a bytes32

So by calling `set(bytes32,bool)`, we are able to set the bytes32 to a valid data type and also set the boolean to true

# Vulnerability Detail
The _safeMint function called at https://github.com/pasDamola/QuillCTF-Gold-NFT/blob/88d92f7b9974de71c52bf5e94258adc0348ae0b8/contracts/GoldNFT.sol#L24 triggers the inherited https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7e7060e00e107460fc57c178859d3cf0c6ac64ef/contracts/token/ERC721/ERC721.sol#L247 which in turn triggers a callback to the destination address. 
The contract then goes on to update the `minted` variable to true after the external call is made. This allows for re-entrancy attack

# Impact
All the gold nfts in the contract could be minted out by this malicious attack

# Recommendation
Reset `minted` variable to true before making the `_safeMint()` call. This follows the Check-Effects-Interaction pattern recommended as a best practice


