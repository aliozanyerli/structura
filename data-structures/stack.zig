const std = @import("std");
const math = std.math;
const mem = std.mem;
const debug = std.debug;
const testing = std.testing;
const expectEqual = testing.expectEqual;

const Allocator = std.mem.Allocator;
const test_allocator = testing.allocator;

pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        const SNode = struct {
            data: T,
            prev: ?*SNode,
        };

        head: ?*SNode,
        len: usize,
        alloc: Allocator,

        pub fn init(alloc: Allocator) Self {
            return Self {
                .head = null,
                .len = 0,
                .alloc = alloc,
            };
        }

        pub fn push(self: *Self, value: T) !void {
            const node = try self.alloc.create(SNode);
            node.* = .{.data = value, .prev = null};

            if (self.head) |head| {
                node.prev = head;
                self.head = node;
            } else {
                self.head = node;
            }

            self.len += 1;
        }

        pub fn pop(self: *Self) ?T {
            const popped_node = self.head orelse return null;
            defer self.alloc.destroy(popped_node);

            if (popped_node.prev) |prev| {
                self.head = prev;
                popped_node.prev = null;
            } else {
                self.head = null;
            }

            self.len -= 1;

            return popped_node.data;
        }
    };
}

test "Managed Stack" {
    var numbers = Stack(u8).init(test_allocator);

    try numbers.push(0);
    try numbers.push(1);
    try numbers.push(2);

    try expectEqual(numbers.len, 3);

    try expectEqual(numbers.pop(), 2);
    try expectEqual(numbers.pop(), 1);
    try expectEqual(numbers.pop(), 0);

    try expectEqual(numbers.pop(), null);
    try expectEqual(numbers.head, null);
    try expectEqual(numbers.len, 0);
}