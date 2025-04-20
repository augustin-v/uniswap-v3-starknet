use starknet::ContractAddress;

#[starknet::contract]
pub mod UniswapV3Factory {
    use contracts::contract::interface::IUniswapV3PoolDeployer;
    use starknet::ContractAddress;
    use starknet::storage::{
        Map, StorageMapReadAccess, StorageMapWriteAccess, StoragePointerReadAccess,
        StoragePointerWriteAccess,
    };
    use super::PoolParameters;

    #[storage]
    struct Storage {
        parameters: PoolParameters,
        tick_spacings: Map<i32, bool>,
        pools: Map<ContractAddress, Map<ContractAddress, Map<i32, ContractAddress>>>,
        owner: ContractAddress
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.owner.write(0x08.try_into().unwrap()); // placeholder address
        self.tick_spacings.write(10, true);
        self.tick_spacings.write(60, true);
        self.tick_spacings.write(200, true);
    }

    #[abi(embed_v0)]
    impl IUniswapV3PoolDeployerImpl of IUniswapV3PoolDeployer<ContractState> {
        fn get_parameters(self: @ContractState) -> PoolParameters {
            self.parameters.read()
        }

        fn create_pool(
            ref self: ContractState,
            token0: ContractAddress,
            token1: ContractAddress,
            tick_spacing: i32,
        ) -> ContractAddress {
            assert(token0 != token1, 'tokens must be different');
            assert(self.tick_spacings.read(tick_spacing), 'unsupported tick spacing');

            let (token0, token1) = if token0 < token1 {
                (token0, token1)
            } else {
                (token1, token0)
            };
        }
    }
}

#[derive(Drop, Serde, starknet::Store)]
pub struct PoolParameters {
    factory: ContractAddress,
    token0: ContractAddress,
    token1: ContractAddress,
    tick_spacing: i32,
}
