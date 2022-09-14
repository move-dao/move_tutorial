module cafe::M{
    // use std::vector;

    struct Coin has drop, copy {
        value: u64
    }

    public fun create_coin(value: u64): Coin {
        Coin{ value }
    }

    #[test]
    fun coin_vec(){
        let v = vector<Coin>[
            Coin { value: 72},
            Coin { value: 172},
            Coin { value: 272},
            ];
            
        assert!(*vector::borrow(&v, 0) == Coin {value: 72}, 0);
        assert!(*vector::borrow(&v, 1) == Coin {value: 172}, 0);
        assert!(*vector::borrow(&v, 2) == Coin {value: 272}, 0);
    }

}