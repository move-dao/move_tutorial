module hello_sui::my_module {
    use std::string;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        assert!(*string::bytes(&speak()) == b"Hello World", 0);
    }
}
