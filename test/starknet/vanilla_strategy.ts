import { StarknetContract } from 'hardhat/types/runtime';
import { expect } from 'chai';
import { starknet } from 'hardhat';
import { SplitUint256 } from './shared/types';

async function setup() {
  const vanillaVotingStrategyFactory = await starknet.getContractFactory(
    './contracts/starknet/voting_strategies/vanilla.cairo'
  );
  const vanillaVotingStrategy = await vanillaVotingStrategyFactory.deploy();
  return {
    vanillaVotingStrategy: vanillaVotingStrategy as StarknetContract,
  };
}

describe('Snapshot X Vanilla Voting Strategy:', () => {
  it('The voting strategy should return a voting power of 1', async () => {
    const { vanillaVotingStrategy } = await setup();
    const { voting_power: vp } = await vanillaVotingStrategy.call('get_voting_power', {
      timestamp: 1,
      address: { value: BigInt('0xffffffffffffffffffff') },
      params: [],
    });
    expect(new SplitUint256(vp.low, vp.high)).to.deep.equal(SplitUint256.fromUint(BigInt(1)));
  }).timeout(600000);
});
