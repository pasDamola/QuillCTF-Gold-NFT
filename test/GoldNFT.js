const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Reentrancy Exercise 2", function () {
  let deployer, attacker;
  const TOTAL_SUPPLY_TO_STEAL = 10;

  before(async function () {
    /**SETUP**/

    [deployer, attacker] = await ethers.getSigners();

    const GoldNFTFactory = await ethers.getContractFactory(
      "contracts/GoldNFT.sol:GoldNFT",
      deployer
    );
    this.goldNFT = await GoldNFTFactory.deploy();
  });

  it("Exploit", async function () {
    /** CODE YOUR SOLUTION HERE */

    const StealGoldNFTs = await ethers.getContractFactory(
      "contracts/StealGoldNFTs.sol:StealGoldNFTs",
      attacker
    );
    this.stealGoldNfts = await StealGoldNFTs.deploy(this.goldNFT.address);
    await this.stealApes.attack();
  });

  after(async function () {
    /** SUCCESS CONDITIONS */
    expect(await this.goldNFT.balanceOf(attacker.address)).to.equal(
      TOTAL_SUPPLY_TO_STEAL
    );
  });
});
