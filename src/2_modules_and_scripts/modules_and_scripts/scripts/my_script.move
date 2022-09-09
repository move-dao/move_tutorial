script{
    use std::debug;
    use std::string;
    use move_dao::my_module::is_prime;

    fun my_script(){
        if (is_prime(7)){
            debug::print(&string::utf8(b"Is a Prime Number"));
        }else{
            debug::print(&string::utf8(b"Not a Prime Number"));
        }
    }
}