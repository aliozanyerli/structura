const std = @import("std");
const testing = std.testing;
const expect = testing.expect;

// Generic Linear Search
pub fn linear_search(
    comptime T: type,
    haystack: []const T, 
    needle: T
) bool {
    for (haystack) |value| {
        if (value == needle) return true;
    }

    return false;
}

test "Generic Linear Search" {
    // String
    var word: []const u8 = "hello";
    
    try expect(linear_search(u8, word, 'h') == true);
    try expect(linear_search(u8, word, 'g') == false);
    try expect(linear_search(u8, word, 32) == false);

    // Integers
    var numbers = [_]u8{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

    for (0..10) |i| {
        try expect(linear_search(u8, &numbers, @as(u8, @truncate(i))) == true);
    }

    try expect(linear_search(u8, &numbers, 10) == false);
}
