use core::starknet::ContractAddress;
#[starknet::interface]
trait IAccountManagement<TContractState> {
    fn get_balance(self: @TContractState, account: ContractAddress) -> u256;
    fn increment_balance(ref self: TContractState, account: ContractAddress, amount: u256);
    fn decrement_balance(ref self: TContractState, account: ContractAddress, amount: u256);
}

#[starknet::contract]
mod AccountManagement {
    use core::starknet::ContractAddress;
    use core::starknet::storage::{
        StorageMapReadAccess, StorageMapWriteAccess, Map
    };

    #[storage]
    struct Storage {
        balances: Map<ContractAddress, u256>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        // No initial actions needed for constructor in this case.
    }

    #[abi(embed_v0)]
    impl AccountManagement of super::IAccountManagement<ContractState> {
        fn get_balance(self: @ContractState, account: ContractAddress) -> u256 {
            self.balances.read(account)
        }

        fn increment_balance(ref self: ContractState, account: ContractAddress, amount: u256) {
            let current_balance = self.balances.read(account);
            self.balances.write(account, current_balance + amount);
        }

        // Function to decrement balance
        // Function to decrement balance
        fn decrement_balance(ref self: ContractState, account: ContractAddress, amount: u256) {
            let current_balance = self.balances.read(account);
            // Ensure the account has enough balance to avoid underflow
            // Here 101 could be a predefined error code for "Insufficient Balance"
            assert(current_balance >= amount, 101);
            self.balances.write(account, current_balance - amount);
        }


    }
}
