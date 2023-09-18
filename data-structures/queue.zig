const std = @import("std");
const math = std.math;
const mem = std.mem;
const debug = std.debug;
const testing = std.testing;
const expectEqual = testing.expectEqual;

const Allocator = std.mem.Allocator;
const test_allocator = testing.allocator;

pub fn Queue(comptime T: type) type {
    return struct {
        const Self = @This();

        const QNode = struct {
            data: T,
            next: ?*QNode,
        };

        start: ?*QNode,
        end: ?*QNode,
        len: usize,
        alloc: Allocator,

        pub fn init(alloc: Allocator) Self {
            return Self{
                .start = null,
                .end = null,
                .len = 0,
                .alloc = alloc
            };
        }

        pub fn enqueue(self: *Self, value: T) !void {
            const node = try self.alloc.create(QNode);
            node.* = .{.data = value, .next = null};

            if (self.end) |end| {
                end.next = node;
            } else{
                self.start = node;
                self.end = node;
            }

            self.len += 1;
        }

        pub fn dequeue(self: *Self) ?T {
            const start = self.start orelse return null;
            defer self.alloc.destroy(start);

            if (start.next) |next| {
                self.start = next;                
            } else {
                self.start = null;
                self.end = null;
            }

            self.len -= 1;

            return start.data;
        }
    };
}

test "Managed Queue of Strings" {
    var messages = Queue([]const u8).init(test_allocator);

    try expectEqual(messages.start, null);
    try expectEqual(messages.end, null);
    try expectEqual(messages.len, 0);

    try messages.enqueue("Hello, world!");
    try messages.enqueue("This is another message");

    try expectEqual(messages.len, 2);

    try expectEqual(messages.dequeue(), "Hello, world!");
    try expectEqual(messages.dequeue(), "This is another message");
    try expectEqual(messages.dequeue(), null);

    try expectEqual(messages.len, 0);
}