// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  await deployContract();

  //await contract.deployed();
}

async function deployContract() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const unlockTime = currentTimestampInSeconds + 60;
  const lockedAmount = hre.ethers.utils.parseEther("0.001");

  const contractFactory = await hre.ethers.getContractFactory("Lock");
  const contract = await contractFactory.deploy(unlockTime, {
    value: lockedAmount,
  });
  await contract.deployTransaction.wait();

  const receipt = await contract.deployTransaction.wait();
  console.log(
    `contract deployed at address ${contract.address} at block${receipt.blockNumber}`
  );

  const initialText = await contract.retrieve();
  console.log(`the initial text is ${initialText}`);
  const setTextTx = await contract.store("New Text here!");
  const setTextTxReceipt = await setTextTx.wait();
  console.log(
    `The tx Recepit block Number is: ${setTextTxReceipt.blockNumber}`
  );
  const newText = await contract.retrieve();
  console.log(`The new text in the contract is: ${newText}`);
  console.log(
    `Lock with ${ethers.utils.formatEther(
      lockedAmount
    )}ETH and unlock timestamp ${unlockTime} deployed to ${contract.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
