script {
    use std::debug;
    use std::vector;
    use std::string;
    use cafe::M;

    fun main() {

        // create an empty vector
        let first_v = vector[1, 2, 3];
        debug::print(&fir)
        let v = vector[]; 
        assert!(v != first_v, 0);
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

        // byte string
        let s = b"Hello, world!";
        debug::print(&s);

        // hex string
        let s = x"48656C6C6F210A";
        debug::print(&s);

        // `byte string` and `hex string` are essentially `vector<u8>`
        assert!(b"" == vector<u8>[], 0);
        // assert!(b"" == vector<u64>[], 0);    // Error: Incompatible arguments to '=='
        assert!(b"" == x"", 1);
        assert!(b"Hello!\n" == x"48656C6C6F210A", 2);
        assert!(b"\x48\x65\x6C\x6C\x6F\x21\x0A" == x"48656C6C6F210A", 3);
        assert!(
            b"\"Hello\tworld!\"\n \r \\Null=\0" ==
                x"2248656C6C6F09776F726C6421220A200D205C4E756C6C3D00",
            4
        );

        // [std::vector functions]
        // Create an empty vector
        let _empty_v = vector::empty<u128>();

        // Return an vector of size one containing element `e`
        let v = vector::singleton<u64>(123u64);

        // Return the length of the vector
        assert!(vector::length(&v) == 1, 0);

        // Add element `e` to the end of the vector `v`
        vector::push_back(&mut v, 456u64);
        vector::push_back(&mut v, 789u64);
        assert!(v == vector[123u64, 456u64, 789u64], 0);
        assert!(vector::length(&v) == 3, 0);

        // Pop an element from the end of vector `v`. Aborts if `v` is empty.
        assert!(vector::pop_back(&mut v) == 789u64, 0);
        assert!(vector::length(&v) == 2, 0);
        // vector::pop_back(&mut _empty_v); // Abort!

        // Acquire an immutable reference to the `i`th element of the vector `v`. 
        // Aborts if `i` is out of bounds.
        assert!(*vector::borrow(&v, 0) == 123u64, 0);
        assert!(vector::borrow(&v, 1) == &456u64, 0);
        // vector::borrow(&v, 2); // Abort!

        // Return a mutable reference to the `i`th element in the vector `v`. 
        // Aborts if `i` is out of bounds.
        assert!(v == vector[123, 456], 0);
        *vector::borrow_mut(&mut v, 0) = 321u64;
        assert!(v == vector[321, 456], 0);

        // Destroy the vector `v`. Aborts if `v` is not empty.
        vector::destroy_empty(_empty_v);
        
        // Swaps the elements at the `i`th and `j`th indices in the vector `v`. 
        // Aborts if `i` or `j` is out of bounds.
        assert!(v == vector[321, 456], 0);
        vector::swap(&mut v, 0, 1);
        assert!(v == vector[456, 321], 0);
        // vector::swap(&mut v, 0, 2);  // Abort!

        // Reverses the order of the elements in the vector `v` in place.
        assert!(v == vector[456, 321], 0);
        vector::reverse(&mut v);
        assert!(v == vector[321, 456], 0);

        // Pushes all of the elements of the `other` vector into the `lhs` vector.
        assert!(v == vector[321, 456], 0);
        vector::append(&mut v, vector[1001, 1002, 1003]);
        assert!(v == vector[321, 456, 1001, 1002, 1003], 0);

        //  Return true if `e` is in the vector `v`. Otherwise, returns false.
        assert!(vector::contains(&v, &321), 0);

        // Return `(true, i)` if `e` is in the vector `v` at index `i`. 
        // Otherwise, returns `(false, 0)`.
        let (if_exist, index) = vector::index_of(&v, &456);
        assert!(if_exist == true, 0);
        assert!(index == 1 , 0);
        let (if_exist, index) = vector::index_of(&v, &999);
        assert!(if_exist == false, 0);
        assert!(index == 0 , 0);

        // Remove the `i`th element of the vector `v`, shifting all subsequent elements.
        // This is O(n) and preserves ordering of elements in the vector.
        // Aborts if `i` is out of bounds.
        assert!(v == vector[321, 456, 1001, 1002, 1003], 0);
        assert!(vector::remove(&mut v, 2) == 1001, 0);
        assert!(v == vector[321, 456, 1002, 1003], 0);

        // Swap the `i`th element of the vector `v` with the last element and then pop the element.
        // This is O(1), but does not preserve ordering of elements in the vector.
        // Aborts if `i` is out of bounds.
        assert!(v == vector[321, 456, 1002, 1003], 0);
        assert!(vector::swap_remove(&mut v, 1) == 456, 0);
        assert!(v == vector[321, 1003, 1002], 0);

        // copy vector
        let x = vector::singleton<u64>(10);
        let y = copy x;
        assert!(x == y, 0);
        
        // without copy ability
        // let p = vector::singleton<M::Coin>( M::create_coin(1) );
        // let q = copy p;
        // debug::print(&q);
        // assert!(p == q, 0);

        // [std::string functions]
        // Creates a new string from a sequence of bytes. 
        // Aborts if the bytes do not represent valid utf8.
        let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
        debug::print(&s);

        // Tries to create a new string from a sequence of bytes.
        let valid_s = string::try_utf8(vector[72, 101, 108, 108, 111, 33, 10]);
        let invalid_s = string::try_utf8(vector[72, 101, 108, 108, 111, 33, 255]);
        debug::print(&valid_s);
        debug::print(&invalid_s);

        // Returns a reference to the underlying byte vector.
        assert!(*string::bytes(&s) == vector[72, 101, 108, 108, 111, 33, 10], 0);

        // Checks whether this string is empty.
        assert!(string::is_empty(&string::utf8(vector[])) == true, 0);
        assert!(string::is_empty(&s) == false, 0);

        // Returns the length of this string, in bytes.
        let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
        assert!(string::length(&s) == 7, 0);

        // Appends a string.
        let s = string::utf8(vector[72, 101, 108]);
        let r = string::utf8(vector[111, 33, 10]);
        string::append(&mut s, r);
        debug::print(&s);

        // Appends bytes which must be in valid utf8 format.
        let s = string::utf8(vector[72, 101, 108]);
        let r = vector[111, 33, 10];
        string::append_utf8(&mut s, r);
        debug::print(&s);

        // Insert the other string at the byte index in given string. 
        // The index must be at a valid utf8 char boundary.
        let s = string::utf8(vector[72, 101, 108]);
        let o = string::utf8(vector[111, 33, 10]);
        string::insert(&mut s, 2, o);
        debug::print(&s);

        // Returns a sub-string using the given byte indices
        // The indices must be at valid utf8 char boundaries, guaranteeing that the result is valid utf8.
        let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
        let sub_s = string::sub_string(&s, 2, 5);
        debug::print(&sub_s);

        // Computes the index of the first occurrence of a string. 
        // Returns `length(s)` if no occurrence found.
        let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
        let sub_s = string::utf8(vector[108, 108, 111]);
        let another_s = string::utf8(vector[108, 108, 112]);
        assert!(string::index_of(&s, &sub_s) == 2, 0);
        assert!(string::index_of(&s, &another_s) == string::length(&s), 0);
    }

}