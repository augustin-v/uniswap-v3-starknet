#[derive(Copy, Drop, Serde, starknet::Store)]
pub struct Info {
    inited: bool,
    liq: u128,
}

#[starknet::contract]
pub mod Tick {
    use contracts::contract::interface::ITickTrait;
    use starknet::storage::{Map, StorageMapReadAccess, StorageMapWriteAccess};
    use super::*;

    #[storage]
    struct Storage {
        ticks: Map<felt252, Info>,
    }
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    pub impl ITickImpl of ITickTrait<ContractState> {
        fn update(ref self: ContractState, tick: i32, liq_delta: u128) {
            let mut info = self.ticks.read(tick.into());

            let liq_before = info.liq;
            let liq_after = liq_before + liq_delta;

            if liq_before == 0 {
                info.inited = true;
            }
            info.liq = liq_after;
            self.ticks.write(tick.into(), info);
        }

        fn is_init(self: @ContractState, tick: i32) -> bool {
            self.ticks.read(tick.into()).inited
        }
    }
}
