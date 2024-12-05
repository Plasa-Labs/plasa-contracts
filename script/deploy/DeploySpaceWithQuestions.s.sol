// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script, console } from "forge-std/Script.sol";
import { Space } from "../../src/spaces/Space.sol";
import { DeployArgs } from "./DeployArgs.sol";
import { FixedQuestion } from "../../src/questions/FixedQuestion.sol";
import { OpenQuestion } from "../../src/questions/OpenQuestion.sol";

contract DeploySpaceWithQuestions is Script {
	function deployFixedQuestion(
		address spaceAddress,
		address pointsAddress,
		DeployArgs.QuestionArgs memory args,
		address plasaAddress
	) private returns (FixedQuestion) {
		return
			new FixedQuestion(
				spaceAddress,
				pointsAddress,
				args.title,
				args.description,
				args.tags,
				args.deadline,
				args.optionTitles,
				args.optionDescriptions,
				plasaAddress
			);
	}

	function deployOpenQuestion(
		address spaceAddress,
		address pointsAddress,
		DeployArgs.OpenQuestionArgs memory args,
		address plasaAddress
	) private returns (OpenQuestion) {
		return
			new OpenQuestion(
				spaceAddress,
				pointsAddress,
				args.title,
				args.description,
				args.tags,
				args.deadline,
				plasaAddress
			);
	}

	function run() public {
		uint256 superAdminPrivateKey = vm.envUint("SUPER_ADMIN_PRIVATE_KEY");
		address superAdmin = vm.addr(superAdminPrivateKey);
		uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
		address deployer = vm.addr(deployerPrivateKey);

		address pointsAddress = vm.envAddress("POINTS_ADDRESS");
		console.log("Points address:", pointsAddress);

		address plasaAddress = vm.envAddress("PLASA_ADDRESS");
		console.log("Plasa address:", plasaAddress);

		console.log("Super Admin address:", superAdmin);
		console.log("Deployer address:", deployer);

		DeployArgs deployArgs = new DeployArgs();
		DeployArgs.DeploymentArgs memory args = deployArgs.getArgs();

		vm.startBroadcast(deployerPrivateKey);

		// Deploy Space
		Space space = new Space(
			args.common.initialSuperAdmins,
			args.space.name,
			args.space.description,
			args.space.imageUrl,
			pointsAddress,
			args.common.minPointsToAddOpenQuestionOption
		);

		vm.stopBroadcast();

		vm.startBroadcast(superAdminPrivateKey);

		// Deploy Fixed Questions
		FixedQuestion fixedQuestion1 = deployFixedQuestion(
			address(space),
			pointsAddress,
			args.fixedQuestion1,
			plasaAddress
		);
		FixedQuestion fixedQuestion2 = deployFixedQuestion(
			address(space),
			pointsAddress,
			args.fixedQuestion2,
			plasaAddress
		);
		FixedQuestion fixedQuestion3 = deployFixedQuestion(
			address(space),
			pointsAddress,
			args.fixedQuestion3,
			plasaAddress
		);

		// Deploy Open Questions
		OpenQuestion openQuestion1 = deployOpenQuestion(
			address(space),
			pointsAddress,
			args.openQuestion1,
			plasaAddress
		);
		OpenQuestion openQuestion2 = deployOpenQuestion(
			address(space),
			pointsAddress,
			args.openQuestion2,
			plasaAddress
		);

		// Add questions to space
		space.addQuestion(address(fixedQuestion1));
		space.addQuestion(address(fixedQuestion2));
		space.addQuestion(address(fixedQuestion3));
		space.addQuestion(address(openQuestion1));
		space.addQuestion(address(openQuestion2));

		vm.stopBroadcast();

		// Log deployed contract addresses
		console.log("Space deployed at:", address(space));
		console.log("Fixed Question 1 deployed at:", address(fixedQuestion1));
		console.log("Fixed Question 2 deployed at:", address(fixedQuestion2));
		console.log("Fixed Question 3 deployed at:", address(fixedQuestion3));
		console.log("Open Question 1 deployed at:", address(openQuestion1));
		console.log("Open Question 2 deployed at:", address(openQuestion2));
	}
}
