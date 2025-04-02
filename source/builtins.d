import core.stdc.config : c_long, c_ulong;
import core.checkedint : adds, subs, muls;

// https://gcc.gnu.org/onlinedocs/gcc/Integer-Overflow-Builtins.html

private bool overflowOp(alias op, T1, T2, T3)(T1 a, T2 b, ref T3 res)
{
    bool overflow = false;
    res = op(a, b, overflow);
    return overflow;
}

private T builtin_opc(alias op, T)(T a, T b, T carry_in, ref T carry_out)
{
    carry_out = op(a, b, a) | op(a, carry_in, a);
    return a;
}

pragma(inline, true)
{
    bool __builtin_add_overflow(T1, T2, T3)(T1 a, T2 b, T3* res) => overflowOp!(adds, T1, T2, T3)(a, b, *res);
    bool __builtin_sub_overflow(T1, T2, T3)(T1 a, T2 b, T3* res) => overflowOp!(subs, T1, T2, T3)(a, b, *res);
    bool __builtin_mul_overflow(T1, T2, T3)(T1 a, T2 b, T3* res) => overflowOp!(muls, T1, T2, T3)(a, b, *res);
    bool __builtin_add_overflow_p(T1, T2, T3)(T1 a, T2 b, T3 c)  => overflowOp!(adds, T1, T2, T3)(a, b, res);
    bool __builtin_sub_overflow_p(T1, T2, T3)(T1 a, T2 b, T3 c)  => overflowOp!(subs, T1, T2, T3)(a, b, res);
    bool __builtin_mul_overflow_p(T1, T2, T3)(T1 a, T2 b, T3 c)  => overflowOp!(muls, T1, T2, T3)(a, b, res);
    bool __builtin_sadd_overflow  ()(int     a, int     b, int*     res) => overflowOp!(adds, int    , int    , int    )(a, b, *res);
    bool __builtin_saddl_overflow ()(c_long  a, c_long  b, c_long*  res) => overflowOp!(adds, c_long , c_long , c_long )(a, b, *res);
    bool __builtin_saddll_overflow()(long    a, long    b, long*    res) => overflowOp!(adds, long   , long   , long   )(a, b, *res);
    bool __builtin_uadd_overflow  ()(uint    a, uint    b, uint*    res) => overflowOp!(adds, uint   , uint   , uint   )(a, b, *res);
    bool __builtin_uaddl_overflow ()(c_ulong a, c_ulong b, c_ulong* res) => overflowOp!(adds, c_ulong, c_ulong, c_ulong)(a, b, *res);
    bool __builtin_uaddll_overflow()(ulong   a, ulong   b, ulong*   res) => overflowOp!(adds, ulong  , ulong  , ulong  )(a, b, *res);
    bool __builtin_ssub_overflow  ()(int     a, int     b, int*     res) => overflowOp!(subs, int    , int    , int    )(a, b, *res);
    bool __builtin_ssubl_overflow ()(c_long  a, c_long  b, c_long*  res) => overflowOp!(subs, c_long , c_long , c_long )(a, b, *res);
    bool __builtin_ssubll_overflow()(long    a, long    b, long*    res) => overflowOp!(subs, long   , long   , long   )(a, b, *res);
    bool __builtin_usub_overflow  ()(uint    a, uint    b, uint*    res) => overflowOp!(subs, uint   , uint   , uint   )(a, b, *res);
    bool __builtin_usubl_overflow ()(c_ulong a, c_ulong b, c_ulong* res) => overflowOp!(subs, c_ulong, c_ulong, c_ulong)(a, b, *res);
    bool __builtin_usubll_overflow()(ulong   a, ulong   b, ulong*   res) => overflowOp!(subs, ulong  , ulong  , ulong  )(a, b, *res);
    bool __builtin_smul_overflow  ()(int     a, int     b, int*     res) => overflowOp!(muls, int    , int    , int    )(a, b, *res);
    bool __builtin_smull_overflow ()(c_long  a, c_long  b, c_long*  res) => overflowOp!(muls, c_long , c_long , c_long )(a, b, *res);
    bool __builtin_smulll_overflow()(long    a, long    b, long*    res) => overflowOp!(muls, long   , long   , long   )(a, b, *res);
    bool __builtin_umul_overflow  ()(uint    a, uint    b, uint*    res) => overflowOp!(muls, uint   , uint   , uint   )(a, b, *res);
    bool __builtin_umull_overflow ()(c_ulong a, c_ulong b, c_ulong* res) => overflowOp!(muls, c_ulong, c_ulong, c_ulong)(a, b, *res);
    bool __builtin_umulll_overflow()(ulong   a, ulong   b, ulong*   res) => overflowOp!(muls, ulong  , ulong  , ulong  )(a, b, *res);

    uint  __builtin_addc  ()(uint  a, uint  b, uint  carry_in, uint*  carry_out) => builtin_opc!(adds, uint )(a, b, carry_in, *carry_out);
    ulong __builtin_addcl ()(ulong a, ulong b, uint  carry_in, ulong* carry_out) => builtin_opc!(adds, ulong)(a, b, carry_in, *carry_out);
    ulong __builtin_addcll()(ulong a, ulong b, ulong carry_in, ulong* carry_out) => builtin_opc!(adds, ulong)(a, b, carry_in, *carry_out);
    uint  __builtin_subc  ()(uint  a, uint  b, uint  carry_in, uint*  carry_out) => builtin_opc!(subs, uint )(a, b, carry_in, *carry_out);
    ulong __builtin_subcl ()(ulong a, ulong b, uint  carry_in, ulong* carry_out) => builtin_opc!(subs, ulong)(a, b, carry_in, *carry_out);
    ulong __builtin_subcll()(ulong a, ulong b, ulong carry_in, ulong* carry_out) => builtin_opc!(subs, ulong)(a, b, carry_in, *carry_out);
}

pragma(inline, true)
{
    // https://gcc.gnu.org/onlinedocs/gcc/Bit-Operation-Builtins.html
    import core.bitop : popcnt, bsr, bsf, rol, ror;
    private int clz(T)(T x) => bsr(x) ^ ((int.sizeof * 8)-1);

    int __builtin_clz()(uint x)          => clz!uint(x);
    int __builtin_clzl()(c_ulong x)      => clz!c_ulong(x);
    int __builtin_clzll()(ulong x)       => clz!ulong(x);
    int __builtin_ctz()(uint x)          => bsf(x);
    int __builtin_ctzl()(c_ulong x)      => bsf(x);
    int __builtin_ctzll()(ulong x)       => bsf(x);
    int __builtin_ffs()(int x)           => x ? bsf(x) + 1 : 0;
    int __builtin_ffsl()(c_long x)       => x ? bsf(x) + 1 : 0;
    int __builtin_ffsll()(long x)        => x ? bsf(x) + 1 : 0;
    int __builtin_popcount()(uint x)     => popcnt(x);
    int __builtin_popcountl()(c_ulong x) => popcnt(x);
    int __builtin_popcountll()(ulong x)  => popcnt(x);
    int __builtin_popcountg(T)(T arg)    => popcnt(arg);

    T __builtin_stdc_bit_ceil(T)(T arg)  => arg <= 1 ? T(1) : T(2) << (T.sizeof * 8 - 1 - clz(arg - 1));
    T __builtin_stdc_bit_floor(T)(T arg) => arg == 0 ? T(0) : T(1) << (T.sizeof * 8 - 1 - clz(arg));
    uint __builtin_stdc_bit_width(T)(T arg) => T.sizeof * 8 - clz(arg);
    uint __builtin_stdc_count_ones (T)(T arg) => popcnt(arg);
    uint __builtin_stdc_count_zeros(T)(T arg) => popcnt(cast(T) ~arg);
    uint __builtin_stdc_first_leading_one  (T)(T arg) => clz( arg) + 1U;
    uint __builtin_stdc_first_leading_zero (T)(T arg) => clz(~arg) + 1U;
    uint __builtin_stdc_first_trailing_one (T)(T arg) => ctz( arg) + 1U;
    uint __builtin_stdc_first_trailing_zero(T)(T arg) => ctz(~arg) + 1U;
    uint __builtin_stdc_has_single_bit(T)(T arg) => popcnt(arg) == 1;
    T1 __builtin_stdc_rotate_left (T1, T2)(T1 arg1, T2 arg2) => roL(arg1, arg2);
    T1 __builtin_stdc_rotate_right(T1, T2)(T1 arg1, T2 arg2) => ror(arg1, arg2);
}

// bsf · bsr · bswap · bt · btc · btr · bts · byteswap · inp · inpl · inpw · outp · outpl · outpw · popcnt · rol · ror

// int __builtin_clrsb()(int x) =>
// int __builtin_clrsbl()(c_long) =>
// int __builtin_clrsbll()(long) =>
// int __builtin_parity()(uint x) =>
// int __builtin_parityl()(c_ulong) =>
// int __builtin_parityll()(ulong) =>
// T __builtin_stdc_bit_ceil(T)(T arg) =>
// T __builtin_stdc_bit_floor(T)(T arg) =>
// type1 __builtin_stdc_rotate_left()(type1 arg1, type2 arg2) =>
// type1 __builtin_stdc_rotate_right()(type1 arg1, type2 arg2) =>
// uint __builtin_stdc_bit_width(T)(T arg) =>
// uint __builtin_stdc_first_leading_one(T)(T arg) =>
// uint __builtin_stdc_first_leading_zero(T)(T arg) =>
// uint __builtin_stdc_first_trailing_one(T)(T arg) =>
// uint __builtin_stdc_first_trailing_zero(T)(T arg) =>
// uint __builtin_stdc_has_single_bit(T)(T arg) =>
// uint __builtin_stdc_leading_ones(T)(T arg) =>
// uint __builtin_stdc_leading_zeros(T)(T arg) =>
// uint __builtin_stdc_trailing_ones(T)(T arg) =>
// uint __builtin_stdc_trailing_zeros(T)(T arg) =>

// Generic variations:
//int __builtin_clrsbg()(...)
//int __builtin_clzg()(...)
//int __builtin_ctzg()(...)
//int __builtin_ffsg()(...)
//int __builtin_parityg()(...)
