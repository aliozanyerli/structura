const std = @import("std");
const math = std.math;
const debug = std.debug;
const testing = std.testing;
const expect = testing.expect;

pub fn two_crystal_balls(breaks: []bool) isize {
    const jump_amt = @divFloor(math.sqrt(breaks.len), 1);
    var i = jump_amt;
    var j: usize = 0;

    while (i < breaks.len) : (i += jump_amt) {
        if (breaks[i]) break;
    }

    i -= jump_amt;

    while(j <= jump_amt and i < breaks.len) : ({j += 1; i += 1;}) {
        if (breaks[i]) return i;
    }

    return -1;
}

test "Two Crystal Balls" {
    var falsy = [_]bool{false} ** 814;
    var truthy = [_]bool{true} ** 532;
    var bools = falsy ++ truthy;

    try expect(two_crystal_balls(&bools) == falsy.len);
    try expect(two_crystal_balls(&bools) != -1);
}