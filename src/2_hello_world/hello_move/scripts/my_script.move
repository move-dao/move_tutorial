script {
    use std::debug;
    use 0xCAFE::my_module;

    fun my_script() {
        debug::print(&my_module::speak());
    }
}
