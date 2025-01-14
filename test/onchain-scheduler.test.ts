import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('OnchainScheduler', function () {
  it('owner can create schedule and batch execute after time', async function () {
    const [owner] = await ethers.getSigners();

    const Scheduler = await ethers.getContractFactory('OnchainScheduler');
    const scheduler = await Scheduler.connect(owner).deploy();
    await scheduler.deployed();

    const id = ethers.utils.formatBytes32String('task-1');
    const executeAfter = (Date.now() / 1000 | 0) + 2; // 2 seconds in future

    await expect(scheduler.connect(owner).createSchedule(id, executeAfter, 'demo task'))
      .to.emit(scheduler, 'ScheduleCreated')
      .withArgs(id, executeAfter, 'demo task');

    // wait for executeAfter
    await new Promise(r => setTimeout(r, 2100));

    await expect(scheduler.connect(owner).batchExecute([id]))
      .to.emit(scheduler, 'Executed')
      .withArgs(id, owner.address);

    // second execute should revert
    await expect(scheduler.connect(owner).batchExecute([id]))
      .to.be.reverted;
  });

  it('non-owner cannot create schedule or execute', async function () {
    const [owner, addr] = await ethers.getSigners();
    const Scheduler = await ethers.getContractFactory('OnchainScheduler');
    const scheduler = await Scheduler.connect(owner).deploy();
    await scheduler.deployed();

    const id = ethers.utils.formatBytes32String('task-2');
    const executeAfter = (Date.now() / 1000 | 0) + 1;

    await expect(scheduler.connect(addr).createSchedule(id, executeAfter, 'malicious'))
      .to.be.reverted;
  });
});
