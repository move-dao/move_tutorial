module 0xCAFE::my_module {
    use std::string;
    use std::debug;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        
        let res = speak();
        
        debug::print(&res);

        let except = string::utf8(b"Hello World");
        assert!(res == except, 0);
    }
}
