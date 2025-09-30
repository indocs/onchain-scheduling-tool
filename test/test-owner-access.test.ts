import { expect } from "chai";
import { ethers } from "hardhat";

describe("TestOwner access control", function () {
  it("only owner can call ownerSay", async function () {
    const [owner, addr] = await ethers.getSigners();
    const TestOwner = await ethers.getContractFactory("TestOwner");
    const contract = await TestOwner.deploy();
    await contract.deployed();

    // owner should be able to call ownerSay
    const res = await contract.ownerSay("hello");
    expect(await res).to.equal("owner-hello");

    // non-owner should be blocked
    await expect(contract.connect(addr).ownerSay("x")).to.be.reverted;
  });
});
