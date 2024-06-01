const std = @import("std");

const Entry = struct {
    K: ?[]const u8,
    V: ?[]const u8,
    next: ?*Entry,
};

pub const Option = struct {
    length: usize,
    head: ?*Entry,
    alloc: std.mem.Allocator,
    iterator: std.process.ArgIterator,

    pub fn init(allocator: std.mem.Allocator, argIterator: std.process.ArgIterator) Option {
        return Option{
            .length = 0,
            .head = null,
            .alloc = allocator,
            .iterator = argIterator,
        };
    }

    pub fn parse(self: *Option) void {
        while (self.next()) |param| {
            self.add(param);
        }
    }

    pub fn get(self: *Option, val: []const u8) ?*Entry {
        const current = block: {
            var value: ?*Entry = null;
            var cursor = self.head;
            while (cursor) |entry| {
                if (std.mem.eql(u8, entry.K.?, val)) {
                    value = entry;
                    break;
                }
                cursor = entry.next;
            }
            break :block value;
        };
        return current;
    }

    pub fn print(self: *Option) void {
        var current = self.head;
        std.log.info("Options", .{});
        while (current) |entry| {
            std.log.info("-> key: {any}, value: {any}", .{ entry.K, entry.V });
            current = entry.next;
        }
    }

    pub fn free(self: *Option) void {
        while (self.head) |entry| {
            const clone = entry.next;
            self.alloc.destroy(entry);
            self.head = clone;
        }
    }

    fn add(self: *Option, entry: *Entry) void {
        self.length += 1;
        entry.next = self.head;
        self.head = entry;
    }

    fn next(self: *Option) ?*Entry {
        if (self.iterator.next()) |key| {
            var entry = self.alloc.create(Entry) catch |err| switch (err) {
                error.OutOfMemory => @panic("Nigga i am out of memory"),
            };
            if (std.mem.eql(u8, key[0..2], "--")) {
                entry.K = key;
                entry.V = null;
                entry.next = null;
                return entry;
            } else {
                if (self.iterator.next()) |value| {
                    entry.K = key;
                    entry.V = value;
                    entry.next = null;
                    return entry;
                }
            }
        }
        return null;
    }
};
