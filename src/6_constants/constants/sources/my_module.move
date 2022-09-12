address 0x42 {
    module example {
        use std::signer;
        const MY_ADDRESS: address = @0x42;
        const MY_ERROR_CODE: u64 = 1;

        public fun permissioned(s: &signer) {
            assert!(signer::address_of(s) == MY_ADDRESS, MY_ERROR_CODE);
        }
    }
}