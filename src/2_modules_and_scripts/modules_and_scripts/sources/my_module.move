module 0xC0FFEE::my_module{
    struct Example has copy, drop{i: u64}
    
    use std::debug;
    use std::string;

    const ENOT_POSITIVE_NUMBER: u64 = 0;

    public fun isprime(x: u64):bool{
        debug::print(&string::utf8(b"Start"));
        //assert!(x > 0, ENOT_POSITIVE_NUMBER);
        let example = Example{i:x};
        if (example.i == 1) {
            false
        }else{
            let num = example.i - 1;
            let isp = true;
            while(num>=2){
                if (example.i % num == 0){
                    isp = false;
                    break
                };
                num = num - 1;
            };
            isp
        }
    }

}