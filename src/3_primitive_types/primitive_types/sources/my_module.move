module 0x42::M {
    struct Coin has key, store{
        value: u64
    }

    public fun give_coin(account: &signer) {
        let coin = Coin { value: 1 };
        move_to(account, coin);
    }

    public fun balance_of(owner: address): u64 acquires Coin {
        borrow_global<Coin>(owner).value
    }

}