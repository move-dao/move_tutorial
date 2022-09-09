script{
    use std::debug;
    use std::string;
    //use 0xC0FFEE::my_module;

    fun my_script(){
        if (0xC0FFEE::my_module::isprime(7)){
            debug::print(&string::utf8(b"Is a Prime Number"));
        }else{
            debug::print(&string::utf8(b"Not a Prime Number"));
        }
    }
}