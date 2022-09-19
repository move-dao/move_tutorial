script{
    use std::debug;
    use std::string;

    use move_dao::my_module::is_even;

    fun my_script(_x: u64){
        assert!(is_even(_x), 0);
        debug::print(&string::utf8(b"Even"));
    }
}
