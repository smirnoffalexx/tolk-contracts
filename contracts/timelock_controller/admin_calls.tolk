import "./op.tolk";
import "./error.tolk";
import "./params.tolk";
import "./storage.tolk";
import "../common/accounts.tolk";

@inline
fun handleAdminMessages(op: int, queryID: int, myBalance: int, msgValue: int, msgBody: slice): int {
    if (op == OP_UPDATE_ACCOUNTS) {
        val operation = msgBody.loadUint(1);
        val role = msgBody.loadUint(32);
        val account = msgBody.loadAddress();
        msgBody.assertEndOfSlice();

        assert(role <= EXECUTOR_ROLE, ERROR_INVALID_ROLE);

        if (role == ADMIN_ROLE) {
            if (operation == ADD_ACCOUNT) {
                STORAGE_ADMIN_ACCOUNTS = addAccount(STORAGE_ADMIN_ACCOUNTS, account);
            } else {
                STORAGE_ADMIN_ACCOUNTS = removeAccount(STORAGE_ADMIN_ACCOUNTS, account);
            }
        }

        if (role == PROPOSER_ROLE) {
            if (operation == ADD_ACCOUNT) {
                STORAGE_PROPOSER_ACCOUNTS = addAccount(STORAGE_PROPOSER_ACCOUNTS, account);
            } else {
                STORAGE_PROPOSER_ACCOUNTS = removeAccount(STORAGE_PROPOSER_ACCOUNTS, account);
            }
        }

        if (role == CANCELLER_ROLE) {
            if (operation == ADD_ACCOUNT) {
                STORAGE_CANCELLER_ACCOUNTS = addAccount(STORAGE_CANCELLER_ACCOUNTS, account);
            } else {
                STORAGE_CANCELLER_ACCOUNTS = removeAccount(STORAGE_CANCELLER_ACCOUNTS, account);
            }
        }

        if (role == EXECUTOR_ROLE) {
            if (operation == ADD_ACCOUNT) {
                STORAGE_EXECUTOR_ACCOUNTS = addAccount(STORAGE_EXECUTOR_ACCOUNTS, account);
            } else {
                STORAGE_EXECUTOR_ACCOUNTS = removeAccount(STORAGE_EXECUTOR_ACCOUNTS, account);
            }
        }

        saveStorage();
        return -1;
    }

    if (op == OP_UPDATE_DELAY) {
        val delay = msgBody.loadUint(32);
        msgBody.assertEndOfSlice();
        STORAGE_MIN_DELAY = delay;
        saveStorage();
        return -1;
    }

    if (op == OP_CLEAR_TIMESTAMPS) {
        val length = msgBody.loadUint(32);
        
        repeat(length) {
            val id = msgBody.loadUint(256);
            val (_, exists) = STORAGE_TIMESTAMPS.uDictGet(256, id);
            if (exists) {
                STORAGE_TIMESTAMPS.uDictDelete(256, id);
                STORAGE_TIMESTAMP_COUNT -= 1;
            }  
        }

        saveStorage();
        return -1;
    }

    if (op == OP_UPGRADE) {
        val (newData, newCode) = (msgBody.loadRef(), msgBody.loadRef());
        msgBody.assertEndOfSlice();
        setContractData(newData);
        setContractCodePostponed(newCode);
        return -1;
    }

    return 0;
}
