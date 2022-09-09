module 0xC0FFEE::my_module{

    use std::debug;
    use std::string;

    struct Example has drop{
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;
    
    //判断输入参数是否为质数的函数
    public fun is_prime(x: u64): bool {
        debug::print(&string::utf8(b"Start"));
        
        let example = Example { i: x };

        if (example.i == 1) {
            false
        } else if(example.i % 2 == 0){
                    false
               }else{
                    let num = example.i - 1;
                    let isp = true;
                    while(num >= 2) {
                        if (example.i % num == 0) {
                            isp = false;
                            break
                        };
                        num = num - 1;
                    };

                    isp
                }
    }

}