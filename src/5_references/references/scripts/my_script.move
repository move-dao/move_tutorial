script {
    //use std::debug;
    use move_dao::my_module;

    fun main(a: u64, b: u64) {
        // Write the code here
        //my_module::manipulate_value(a, b);
        my_module::manipulate_token_amount(a, b);
    }
}