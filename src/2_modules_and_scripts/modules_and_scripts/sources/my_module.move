module move_dao::my_module{

    struct Example has drop{
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;
    
    public fun is_even(x: u64): bool {  
        let example = Example { i: x };
        if(example.i % 2 == 0){
            true
        }else{
            false
        }
    }
}
