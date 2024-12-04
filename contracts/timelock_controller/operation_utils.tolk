@inline
fun hashOperation(tonValue: int, predecessor: int, salt: int, account: slice, msgToSend: cell): int {
    return cellHash(
            beginCell()
                .storeCoins(tonValue)
                .storeUint(predecessor, 256)
                .storeUint(salt, 256)
                .storeSlice(account)
                .storeRef(msgToSend)
                .endCell()
    );
}
