use starknet::ContractAddress;

#[starknet::contract]
pub mod UniswapV3Factory {
    use contracts::contract::interface::IUniswapV3PoolDeployer;
    use core::poseidon::poseidon_hash_span;
    use starknet::storage::{
        Map, StoragePathEntry, StoragePointerReadAccess, StoragePointerWriteAccess,
    };
    use starknet::syscalls::{deploy_syscall, get_class_hash_at_syscall};
    use starknet::{ContractAddress, get_contract_address};
    use super::PoolParameters;

    #[storage]
    struct Storage {
        tick_spacings: Map<i32, bool>,
        pools: Map<ContractAddress, Map<ContractAddress, Map<i32, ContractAddress>>>,
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        PoolCreated: PoolCreated,
    }

    #[derive(Drop, starknet::Event)]
    pub struct PoolCreated {
        #[key]
        token0: ContractAddress,
        #[key]
        token1: ContractAddress,
        #[key]
        tick_spacing: i32,
        pool: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.tick_spacings.entry(10).write(true);
        self.tick_spacings.entry(60).write(true);
        self.tick_spacings.entry(200).write(true);
    }

    fn generate_salt(
        token0: @ContractAddress, token1: @ContractAddress, tick_spacing: @i32,
    ) -> felt252 {
        let mut data = array![];
        Serde::serialize(token0, ref data);
        Serde::serialize(token1, ref data);
        Serde::serialize(tick_spacing, ref data);
        poseidon_hash_span(data.span())
    }

    fn serialize_call_data(parameters: @PoolParameters) -> Array<felt252> {
        let mut call_data = array![];
        Serde::serialize(parameters.factory, ref call_data);
        Serde::serialize(parameters.token0, ref call_data);
        Serde::serialize(parameters.token1, ref call_data);
        Serde::serialize(parameters.tick_spacing, ref call_data);
        call_data
    }

    #[abi(embed_v0)]
    impl IUniswapV3PoolDeployerImpl of IUniswapV3PoolDeployer<ContractState> {
        fn get_pool(self: @ContractState, token0: ContractAddress, token1: ContractAddress, tick_spacing: i32) -> ContractAddress {
            self.pools.entry(token0).entry(token1).entry(tick_spacing).read()
        }
        fn create_pool(
            ref self: ContractState,
            token0: ContractAddress,
            token1: ContractAddress,
            tick_spacing: i32,
        ) -> ContractAddress {
            assert(token0 != token1, 'tokens must be different');
            assert(self.tick_spacings.entry(tick_spacing).read(), 'unsupported tick spacing');

            let (token0, token1) = if token0 < token1 {
                (token0, token1)
            } else {
                (token1, token0)
            };

            assert(token0 != 0x0.try_into().unwrap(), 'token0 cannot be 0');
            assert(
                self
                    .pools
                    .entry(token0)
                    .entry(token1)
                    .entry(tick_spacing)
                    .read() == 0x0
                    .try_into()
                    .unwrap(),
                'pool already exists',
            );

            let parameters = PoolParameters {
                factory: get_contract_address(), token0, token1, tick_spacing,
            };

            let pool_class_hash = get_class_hash_at_syscall(get_contract_address()).unwrap();
            let contract_address_salt = generate_salt(@token0, @token1, @tick_spacing);
            let call_data = serialize_call_data(@parameters).span();

            let (pool, _) = deploy_syscall(pool_class_hash, contract_address_salt, call_data, false)
                .unwrap();

            self.pools.entry(token0).entry(token1).entry(tick_spacing).write(pool);
            self.pools.entry(token1).entry(token0).entry(tick_spacing).write(pool);

            self.emit(PoolCreated { token0, token1, tick_spacing, pool });

            pool
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
