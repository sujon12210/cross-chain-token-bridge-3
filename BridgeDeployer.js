const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const Token = await hre.ethers.getContractFactory("BridgeToken");
  
  // Deploying the token on "Chain A"
  const token = await Token.deploy("Bridgeable Token", "BTK");
  await token.waitForDeployment();

  console.log("BridgeToken deployed to:", await token.getAddress());
  
  // Grant Relayer Role to a specific address (e.g., your backend relayer)
  const RELAYER_ADDRESS = "0x..."; 
  const RELAYER_ROLE = hre.ethers.keccak256(hre.ethers.toUtf8Bytes("RELAYER_ROLE"));
  await token.grantRole(RELAYER_ROLE, RELAYER_ADDRESS);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
