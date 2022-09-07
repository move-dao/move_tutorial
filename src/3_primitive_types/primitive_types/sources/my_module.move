module 0x42::M {
    struct Coin has key, store{
        value: u64
    }

    public fun give_coin(account: &signer) {
        let coin = Coin { value: 1 };   // Create a 'Coin' 
        move_to(account, coin);     // move the coin to account's address as a resource
    }

    public fun balance_of(owner: address): u64 acquires Coin {
        borrow_global<Coin>(owner).value    // query the value of the Coin at owner's address
    }
}