module cafe::M{

    struct Coin has drop, copy {
        value: u64
    }

    public fun create_coin(value: u64): Coin {
        Coin{ value }
    }

    fun destroy_any_vector<T: drop>(_vec: vector<T>) { }

    public fun move_or_copy(x: Coin): Coin {
        x
    }

    #[test]
    fun coin_vec(){
        use std::vector;

        let v = vector<Coin>[
            Coin { value: 72},
            Coin { value: 172},
            Coin { value: 272},
            ];
            
        assert!(vector::borrow(&v, 0) == &Coin {value: 72}, 0);
        assert!(vector::borrow(&v, 1) == &Coin {value: 172}, 0);
        assert!(vector::borrow(&v, 2) == &Coin {value: 272}, 0);
    }

}