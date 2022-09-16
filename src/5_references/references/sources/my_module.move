module move_dao::my_module{

    struct Token has copy, key, drop{
        amount: u64
    }

    use std::debug;
    use std::string;

    const EVALUE_NOT_CHANGED :u64 = 1;

    public fun manipulate_value(x: u64, y : u64){
        let temp :u64 = x;
        let a: &mut u64 = &mut x;
        *a = y;
        assert!(x != temp, EVALUE_NOT_CHANGED);
        debug::print(&string::utf8(b"Changed"));
    }

    public fun manipulate_token(x: u64, y: u64){
        let token = Token{amount: x};
        debug::print(&token.amount);
        let temp: Token = token;
        let t: &mut Token = &mut token;
        *t = Token{amount: y};
        assert!(token != temp, EVALUE_NOT_CHANGED);
        debug::print(&token.amount);
        debug::print(&string::utf8(b"Changed"));
    }

    public fun manipulate_token_amount(x: u64, y:u64){
        let token = Token{amount: x};
        //let temp = token;
        let t: &mut Token = &mut token;
        let _a :&u64 = &t.amount;
        _a = &y;
        debug::print(&t.amount);
    }

}