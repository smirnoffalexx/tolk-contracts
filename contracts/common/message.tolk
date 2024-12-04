const MSG_INFO_REST_BITS = 1 + 4 + 4 + 64 + 32;
const MSG_WITH_STATE_INIT_AND_BODY_SIZE = MSG_INFO_REST_BITS + 1 + 1 + 1;
const MSG_HAVE_STATE_INIT = 4;
const MSG_STATE_INIT_IN_REF = 2;
const MSG_BODY_IN_REF = 1;
const MSG_ONLY_BODY_SIZE = MSG_INFO_REST_BITS + 1 + 1;

// const int BOUNCEABLE = 0x18; ;; 0b011000 tag - 0, ihr_disabled - 1, bounce - 1, bounced - 0, src = adr_none$00
// const int NON_BOUNCEABLE = 0x10; ;; 0b010000 tag - 0, ihr_disabled - 1, bounce - 0, bounced - 0, src = adr_none$00

// const int SEND_MODE_CARRY_ALL_REMAINING_MESSAGE_VALUE = 64;
// const int SEND_MODE_CARRY_ALL_BALANCE = 128;

// ;;; Creates an output action which would reserve exactly x nanograms (if y = 0).
// const int RESERVE_REGULAR = 0;
// ;;; Creates an output action which would reserve at most x nanograms (if y = 2).
// ;;; Bit +2 in y means that the external action does not fail if the specified amount cannot be reserved; instead, all remaining balance is reserved.
// const int RESERVE_AT_MOST = 2;
// ;;; in the case of action fail - bounce transaction. No effect if RESERVE_AT_MOST (+2) is used. TVM UPGRADE 2023-07. https://docs.ton.org/learn/tvm-instructions/tvm-upgrade-2023-07#sending-messages
// const int RESERVE_BOUNCE_ON_ACTION_FAIL = 16;

@inline
fun storeMsgFlagsAndAddressNone(b: builder, msgFlags: int): builder {
    return b.storeUint(msgFlags, 6);
}

// fun store_statinit_ref_and_body_ref(builder b, cell state_init, cell body): builder {
//     return b
//     .store_uint(MSG_HAVE_STATE_INIT + MSG_STATE_INIT_IN_REF + MSG_BODY_IN_REF, MSG_WITH_STATE_INIT_AND_BODY_SIZE)
//     .store_ref(state_init)
//     .store_ref(body);
// }

@inline
fun storeOnlyBodyRef(b: builder, body: cell): builder {
    return b
        .storeUint(MSG_BODY_IN_REF, MSG_ONLY_BODY_SIZE)
        .storeRef(body);
}

// builder store_prefix_only_body(builder b) inline {
//     return b
//     .store_uint(0, MSG_ONLY_BODY_SIZE);
// }

// () send_simple_message(int amount, slice to, cell body, int mode) impure inline_ref {
//     cell msg = begin_cell()
//         .store_uint(0x18, 6)
//         .store_slice(to)
//         .store_coins(amount)
//         .store_uint(1, 107)
//         .store_ref(body)
//     .end_cell();
//     send_raw_message(msg, mode);
// }
