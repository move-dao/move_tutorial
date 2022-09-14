script {
    use std::debug;
    use cafe::M;

    fun main() {

        // create an empty vector
        let v = vector[]; 
        let another_v = vector[1, 2, 3];
        assert!(v != another_v, 0);
        vector<u8>[];
        vector<u64>[];
        vector<u128>[];
        vector<address>[];
        vector<bool>[];
        vector<M::Coin>[];
        (vector<u64>[]: vector<u64>);   // Parentheses are required
        (vector[]: vector<u64>);
        let _v: vector<u8> = vector[];
        // (vector<u64>[]: vector);    // Error
        

        // create a vector with elements
        vector[1, 2, 3];
        vector[true, false];
        (vector<bool>[true, false]: vector<bool>); 
        (vector[true, false]: vector<bool>);
        let coin_vec = vector<M::Coin>[M::create_coin(2), M::create_coin(7)];
        debug::print(&coin_vec);

        // type inference
        // the type of the first vector is inferred to be `u8`
        let v = vector[1, 2, 3];
        assert!(v == vector<u64>[1, 2, 3], 0);
        // assert!(v == vector<u8>[1, 2, 3], 0); // Error: Incompatible arguments to '=='

        
    }

}