script {
    use std::debug;
    //use move_dao::my_module;

    fun main(a: u64, b: u64) {
        // Write the code here
        //my_module::manipulate_value(a, b);
        let x: u64 = 0;
        let y: &u64 = &x;
        debug::print(y);
        y = &mut 1;
        debug::print(y);
        //my_module::manipulate_token_amount(a, b);
    }
}