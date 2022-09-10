module move_dao::my_module{

    use std::debug;
    use std::string;

    struct Example has drop{
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;
    
    public fun is_even(x: u64): bool {
        debug::print(&string::utf8(b"Start"));     
        let example = Example { i: x };
        if(example.i % 2 == 0){
            true
        }else{
            false
        }
    }
}