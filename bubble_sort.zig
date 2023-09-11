const std = @import("std");
const math = std.math;
const mem = std.mem;
const debug = std.debug;
const testing = std.testing;
const expect = testing.expect;

pub fn bubble_sort(items: []u8) void {
    for (0..items.len) |i| {
        for (0..((items.len - 1) - i)) |j| {
            if (items[j] > items[j + 1]) {
                const tmp = items[j];
                items[j] = items[j + 1];
                items[j + 1] = tmp;
            }
        }
    }
}

test "Bubble Sort" {
    const expected_order = [_]u8{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    var numbers = [_]u8{9, 8, 7, 6, 5, 4, 3, 2, 1, 0};

    bubble_sort(&numbers);

    try expect(mem.eql(u8, &numbers, &expected_order));
}