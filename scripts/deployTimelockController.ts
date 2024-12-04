import { Address, toNano } from '@ton/core';
import { compile, NetworkProvider } from '@ton/blueprint';
import { TimelockController, createAccountsDictionary } from '../wrappers/TimelockController';

export async function run(provider: NetworkProvider) {
    const deployerAddress = provider.sender().address!;
    const timelockController = provider.open(
        TimelockController.createFromConfig(
            {
                minDelay: 3600,
                adminAccounts: createAccountsDictionary([deployerAddress]),
                proposerAccounts: createAccountsDictionary([deployerAddress]),
                cancellerAccounts: createAccountsDictionary([deployerAddress]),
                executorAccounts: createAccountsDictionary([deployerAddress]),
            },
            await compile('TimelockController'),
        ),
    );

    await timelockController.sendTopUp(provider.sender(), { value: toNano('0.05') });

    await provider.waitForDeploy(timelockController.address);

    console.log('Data', await timelockController.getTimelockControllerData());
}
