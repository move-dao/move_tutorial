script{
    use 0x42::example;

    fun main(account: signer) {
        example::permissioned(&account);
    }
}