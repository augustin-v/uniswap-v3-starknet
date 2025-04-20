use contracts::contract::univ3factory::PoolParameters;
use contracts::contract::univ3pool::Slot0;
use contracts::contract::univ3quoter::QuoteParams;
use contracts::libraries::math::numbers::fixed_point::FixedQ64x96;
use contracts::libraries::position::{Info, Key};
use starknet::ContractAddress;

#[starknet::interface]
pub trait UniswapV3PoolTrait<TContractState> {
    fn mint(
        ref self: TContractState,
        lower_tick: i32,
        upper_tick: i32,
        amount: u128,
        data: Array<felt252>,
    ) -> (u256, u256);
    fn burn(
        ref self: TContractState, lower_tick: i32, upper_tick: i32, amount: u128,
    ) -> (u256, u256);
    fn get_liquidity(self: @TContractState) -> u256;
    fn is_tick_init(self: @TContractState, tick: i32) -> bool;
    fn simulate_swap(
        self: @TContractState,
        zero_for_one: bool,
        amount_specified: i128,
        sqrt_price_limit_x96: FixedQ64x96,
    ) -> (i128, i128, u256, i32);
    fn slot0(self: @TContractState) -> Slot0;
    fn swap(
        ref self: TContractState,
        recipient: ContractAddress,
        callback_address: ContractAddress,
        zero_for_one: bool,
        amount_specified: i128,
        sqrt_price_limit_x96: FixedQ64x96,
        data: Array<felt252>,
    ) -> (i128, i128);
}

#[starknet::interface]
pub trait IUniswapV3TickBitmap<TContractState> {
    fn flip_tick(ref self: TContractState, tick: i32, tick_spacing: i32);
    fn next_initialized_tick_within_one_word(
        self: @TContractState, tick: i32, tick_spacing: i32, lte: bool,
    ) -> (i32, bool);
}

#[starknet::interface]
pub trait IUniswapV3Manager<TContractState> {
    fn mint_callback(ref self: TContractState, amount0: u128, amount1: u128, data: Array<felt252>);
    fn burn_callback(ref self: TContractState, amount0: u128, amount1: u128);
    fn swap_callback(
        ref self: TContractState, amount0_delta: i128, amount1_delta: i128, data: Array<felt252>,
    );
    fn mint(
        ref self: TContractState,
        lower_tick: i32,
        upper_tick: i32,
        amount: u128,
        data: Array<felt252>,
    ) -> (u256, u256);
    fn burn(
        ref self: TContractState, lower_tick: i32, upper_tick: i32, amount: u128,
    ) -> (u256, u256);
}

#[starknet::interface]
pub trait IUniswapV3Quoter<TContractState> {
    fn quote(self: @TContractState, params: QuoteParams) -> (i128, i128, u256, i32);
}

#[starknet::interface]
pub trait ITickTrait<TContractState> {
    fn cross(ref self: TContractState, tick: i32) -> i128;
    fn update(ref self: TContractState, tick: i32, liq_delta: i128, upper: bool) -> bool;
    fn is_init(self: @TContractState, tick: i32) -> bool;
}

#[starknet::interface]
pub trait IPositionTrait<TContractState> {
    fn update(ref self: TContractState, key: Key, liq_delta: i128);
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
    fn burn(ref self: TContractState, amount: felt252);
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: felt252,
    );
}

#[starknet::interface]
pub trait IUniswapV3PoolDeployer<TContractState> {
    fn get_parameters(self: @TContractState) -> PoolParameters;
    fn create_pool(
        ref self: TContractState,
        token0: ContractAddress,
        token1: ContractAddress,
        tick_spacing: i32,
    ) -> ContractAddress;
}
