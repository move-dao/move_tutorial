script {
    use move_dao::my_module;

    fun main(a: u64, b: u64) {
        // Write the code here
        let token = my_module::publish_token();
        my_module::manipulate_value(a, b);
        my_module::manipulate_token(a, b);
        my_module::manipulate_token_amount(a, b);
        my_module::tokenTest(&mut token);
    }
}