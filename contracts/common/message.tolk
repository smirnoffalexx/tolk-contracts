const MSG_INFO_REST_BITS = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT = 4;
const MSG_STATE_INIT_IN_REF = 2;
const MSG_BODY_IN_REF = 1;
const MSG_ONLY_BODY_SIZE = MSG_INFO_REST_BITS + 1 + 1;

@inline
fun storeMsgFlagsAndAddressNone(b: builder, msgFlags: int): builder {
    return b.storeUint(msgFlags, 6);
}

fun storeStatinitRefAndBodyRef(b: builder, stateInit: cell, body: cell): builder {
    return b
        .storeUint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + MSG_BODY_IN_REF, MSG_WITH_STATE_INIT_AND_BODY_SIZE)
        .storeRef(stateInit)
        .storeRef(body);
}

@inline
fun storeOnlyBodyRef(b: builder, body: cell): builder {
    return b
        .storeUint(MSG_BODY_IN_REF, MSG_ONLY_BODY_SIZE)
        .storeRef(body);
}

@inline
fun storePrefixOnlyBody(b: builder): builder {
    return b.storeUint(0, MSG_ONLY_BODY_SIZE);
}

@inline_ref
fun sendSimpleMessage(amount: int, to: slice, body: cell, mode: int) {
    val msg = beginCell()
        .storeUint(0x18, 6)
        .storeSlice(to)
        .storeCoins(amount)
        .storeUint(1, 107)
        .storeRef(body)
    .endCell();
    sendMessage(msg, mode);
}
