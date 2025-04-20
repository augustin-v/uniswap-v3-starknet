use contracts::contract::interface::{IUniswapV3PoolDeployerDispatcher, IUniswapV3PoolDeployerDispatcherTrait};
use starknet::{ContractAddress};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use super::utils::get_token0_n_1;

fn deploy_factory() -> (IUniswapV3PoolDeployerDispatcher, ContractAddress) {
    let contract = declare("UniswapV3Factory").unwrap().contract_class();
    let owner: ContractAddress = 0x08.try_into().unwrap();
    let constructor_call_data = array![owner.into()];
    let (contract_address, _) = contract.deploy(@constructor_call_data).unwrap();
    let dispatcher = IUniswapV3PoolDeployerDispatcher { contract_address };
    (dispatcher, contract_address)
}

// Setup test
#[test]
fn test_factory_setup() {
    let (dispatcher, _) = deploy_factory();
    let (token0, token1) = (0x1.try_into().unwrap(), 0x2.try_into().unwrap());
    let pool = dispatcher.get_pool(token0, token1, 60); // test example pool

    assert!(pool == 0x0.try_into().unwrap(), "Initial pools must be empty");
}

// Success case
#[test]
fn test_factory_create_pool() {
    let (dispatcher, _) = deploy_factory();
    let (token0, token1) = (0x1.try_into().unwrap(), 0x2.try_into().unwrap());
    let pool = dispatcher.create_pool(token0, token1, 10);
    let created_pool = dispatcher.get_pool(token0, token1, 10);
    assert!(created_pool != 0x0.try_into().unwrap(), "Invalid pool address returned");
    assert!(pool == created_pool, "Mismatch in created and returned pool addresses");
}
