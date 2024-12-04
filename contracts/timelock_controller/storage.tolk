global STORAGE_MIN_DELAY: int;
global STORAGE_TIMESTAMP_COUNT: int;
global STORAGE_ADMIN_ACCOUNTS: cell;
global STORAGE_PROPOSER_ACCOUNTS: cell;
global STORAGE_EXECUTOR_ACCOUNTS: cell;
global STORAGE_CANCELLER_ACCOUNTS: cell;
global STORAGE_TIMESTAMPS: cell;

@inline
fun loadStorage() {
    var ds = getContractData().beginParse();
    STORAGE_MIN_DELAY = ds.loadUint(32);
    STORAGE_TIMESTAMP_COUNT = ds.loadUint(32);
    var ref = ds.loadRef();
    var refDs = ref.beginParse();
    STORAGE_ADMIN_ACCOUNTS = refDs.loadDict();
    STORAGE_PROPOSER_ACCOUNTS = refDs.loadDict();
    STORAGE_EXECUTOR_ACCOUNTS = refDs.loadDict();
    STORAGE_CANCELLER_ACCOUNTS = refDs.loadDict();
    STORAGE_TIMESTAMPS = ds.loadDict();
}

@inline
fun saveStorage() {
    setContractData(beginCell()
        .storeUint(STORAGE_MIN_DELAY, 32)
        .storeUint(STORAGE_TIMESTAMP_COUNT, 32)
        .storeRef(beginCell()
            .storeDict(STORAGE_ADMIN_ACCOUNTS)
            .storeDict(STORAGE_PROPOSER_ACCOUNTS)
            .storeDict(STORAGE_EXECUTOR_ACCOUNTS)
            .storeDict(STORAGE_CANCELLER_ACCOUNTS)
            .endCell()
        )
        .storeDict(STORAGE_TIMESTAMPS)
    .endCell());
}
