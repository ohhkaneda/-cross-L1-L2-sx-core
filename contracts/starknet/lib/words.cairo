from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math import unsigned_div_rem
from starkware.cairo.common.bitwise import bitwise_and

const MASK_4 = 2 ** 64 - 1
const MASK_3 = 2 ** 128 - 2 ** 64
const MASK_2 = 2 ** 192 - 2 ** 128
const MASK_1 = 2 ** 251 - 2 ** 192

const SHIFT_8 = 2 ** 8
const SHIFT_64 = 2 ** 64
const SHIFT_72 = 2 ** 72
const SHIFT_120 = 2 ** 120

# Big endian - word_1 is the most significant word and word_4 the least.
struct Words:
    member word_1 : felt
    member word_2 : felt
    member word_3 : felt
    member word_4 : felt
end

# Convert a felt to a struct of 4 words of 8 bytes each.
func felt_to_words{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(value : felt) -> (words : Words):
    let (word_4) = bitwise_and(value, MASK_4)

    let (t3) = bitwise_and(value, MASK_3)
    let (word_3, _) = unsigned_div_rem(t3, SHIFT_64)

    let (t2) = bitwise_and(value, MASK_2)
    let (t2, _) = unsigned_div_rem(t2, SHIFT_120)
    let (word_2, _) = unsigned_div_rem(t2, SHIFT_8)

    let (t1) = bitwise_and(value, MASK_1)
    let (t1, _) = unsigned_div_rem(t1, SHIFT_120)
    let (word_1, _) = unsigned_div_rem(t1, SHIFT_72)

    return (Words(word_1, word_2, word_3, word_4))
end
