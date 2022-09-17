module move_dao::my_module{

    struct Token has copy, key, drop{
        amount: u64
    }

    use std::debug;

    const EVALUE_NOT_CHANGED :u64 = 1;

    public fun publish_token(): Token{
        Token{amount:0}
    }

    public fun manipulate_value(x: u64, y : u64){
        let temp :u64 = x;
        let a: &mut u64 = &mut x;
        *a = y;
        assert!(x != temp, EVALUE_NOT_CHANGED);
        debug::print(&x);
    }

    public fun manipulate_token(x: u64, y: u64){
        let token = Token{amount: x};
        let t: &mut Token = &mut token;
        *t = Token{amount: y};
        assert!(token.amount != x, EVALUE_NOT_CHANGED);
        debug::print(&token.amount);
    }

    public fun manipulate_token_amount(x: u64, y:u64){
        let token = Token{amount: x};
        let t: &mut Token = &mut token;
        let t_ext :&mut u64 = &mut t.amount;
        *t_ext = y;
        assert!(token.amount != x, EVALUE_NOT_CHANGED);
        debug::print(&token.amount);
    }

    public fun tokenTest(token: &mut Token){

        let t_ref = token;
        let t_ext = &mut t_ref.amount;
        let t_ref2 = token;

        *t_ext = 100;
        *t_ref = Token{amount: 99};
        *t_ref2 = Token{amount: 98};
        assert!(token.amount == 98, 0);
        debug::print(token);
    }

}