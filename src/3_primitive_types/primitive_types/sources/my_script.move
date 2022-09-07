script{
    use 0x1::debug;
    use std::signer;
    use 0x42::M;

    fun main(account: signer) {

        M::give_coin(&account);

        let r = M::balance_of(signer::address_of(&account));
        debug::print(&r);
    }
}