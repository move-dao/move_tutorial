module 0xCAFE::my_module {
    use std::string;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }
}
