const std = @import("std");
const math = std.math;
const debug = std.debug;
const testing = std.testing;
const expect = testing.expect;


// Binary Search
pub fn binary_search(
    comptime T: type,
    haystack: []const T,
    needle: T
) bool {
    var low: usize = 0;
    var high: usize = haystack.len;
    var mid: usize = undefined;
    var mid_value: usize = undefined;

    while (low < high) {
        mid = low + (high - low) / 2;
        mid_value = haystack[mid];

        if (mid_value == needle) {
            return true;
        } else if (mid_value > needle) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }

    return false;
}

test "Binary Search List" {
    // String
    var word: []const u8 = "Pancho Villa";

    try expect(binary_search(u8, word, ' ') == true); // Space Character
    try expect(binary_search(u8, word, 32) == true);  // ASCII Code
    try expect(binary_search(u8, word, 'V') == true); // Char

    // Integers
    var numbers = [_]u8{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    for (0..10) |i| {
        try expect(binary_search(u8, &numbers, @as(u8, @truncate(i))) == true);
    }

    try expect(binary_search(u8, &numbers, 10) == false);
}
