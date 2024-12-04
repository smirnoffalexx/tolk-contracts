import "../timelock_controller/error.tolk";

@inline
fun accountExists(accounts: cell, account: slice): (int, int) {
    val (_, key) = parseStandardAddress(account);
    val (_, exists) = accounts.uDictGet(256, key);
    return (key, exists);
}

@inline
fun addAccount(accounts: cell, account: slice): cell {
    val (key, exists) = accountExists(accounts, account);
    assert(!exists, ERROR_ACCOUNT_EXISTS);

    accounts.uDictSet(256, key, beginCell().endCell().beginParse());
    return accounts;
}

@inline
fun removeAccount(accounts: cell, account: slice): cell {
    val (key, exists) = accountExists(accounts, account);
    assert(exists, ERROR_ACCOUNT_NOT_EXISTS);

    accounts.uDictDelete(256, key);
    return accounts;
}
