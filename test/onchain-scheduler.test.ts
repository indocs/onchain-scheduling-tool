import { expect } from "chai";
import { ethers } from "hardhat";

describe("OnchainScheduler", function () {
  it("emits ScheduleUpdated on updateSchedule", async function () {
    const [owner] = await ethers.getSigners();

    const OnchainScheduler = await ethers.getContractFactory("OnchainScheduler", owner);
    const scheduler = await OnchainScheduler.deploy();
    await scheduler.deployed();

    // seed a schedule so updateSchedule can be called
    await scheduler.setSchedule(1, Math.floor(Date.now() / 1000));

    // perform update
    const tx = await scheduler.updateSchedule(1, Math.floor(Date.now() / 1000) + 3600);
    const receipt = await tx.wait();

    // check event
    const event = receipt.events?.find((e: any) => e.event === "ScheduleUpdated");
    expect(event).to.not.equal(undefined);
    const args = event!.args;
    expect(args!.taskId).to.equal(1);
  });
});
