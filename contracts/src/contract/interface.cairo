use contracts::libraries::position::{Info, Key};
use starknet::ContractAddress;

#[starknet::interface]
pub trait UniswapV3PoolTrait<TContractState> {
    fn mint(ref self: TContractState, lower_tick: i32, upper_tick: i32, amount: u128);
    fn get_liquidity(self: @TContractState) -> u256;
    fn is_tick_init(self: @TContractState, tick: i32) -> bool;
    fn swap(
        ref self: TContractState, recipient: ContractAddress, callback_address: ContractAddress,
    ) -> (i128, i128);
}

#[starknet::interface]
pub trait IUniswapV3SwapCallback<TContractState> {
    fn swap_callback(
        ref self: TContractState, amount0_delta: i128, amount1_delta: i128, data: Array<felt252>,
    );
}

#[starknet::interface]
pub trait IUniswapV3Manager<TContractState> {
    fn mint_callback(ref self: TContractState, amount0: u128, amount1: u128, data: Array<felt252>);
    fn swap_callback(
        ref self: TContractState, amount0_delta: i128, amount1_delta: i128, data: Array<felt252>,
    );
    fn mint(ref self: TContractState, lower_tick: i32, upper_tick: i32, amount: u128);
}

#[starknet::interface]
pub trait ITickTrait<TContractState> {
    fn update(ref self: TContractState, tick: i32, liq_delta: u128);
    fn is_init(self: @TContractState, tick: i32) -> bool;
}

#[starknet::interface]
pub trait IPositionTrait<TContractState> {
    fn update(ref self: TContractState, key: Key, liq_delta: u128);
    fn get(self: @TContractState, key: Key) -> Info;
}

#[starknet::interface]
pub trait IERC20Trait<TContractState> {
    // view
    fn allowance(
        self: @TContractState, owner: ContractAddress, spender: ContractAddress,
    ) -> felt252;
    fn balance_of(self: @TContractState, account: ContractAddress) -> felt252;
    fn get_decimals(self: @TContractState) -> u8;
    fn get_name(self: @TContractState) -> felt252;
    fn get_symbol(self: @TContractState) -> felt252;
    fn get_total_supply(self: @TContractState) -> felt252;

    // write
    fn approve(ref self: TContractState, spender: ContractAddress, amount: felt252);
    fn decrease_allowance(
        ref self: TContractState, spender: ContractAddress, subtracted_value: felt252,
    );
    fn increase_allowance(ref self: TContractState, spender: ContractAddress, added_value: felt252);
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: felt252);
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: felt252,
    );
}
