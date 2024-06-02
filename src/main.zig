const std = @import("std");
const fs = std.fs.cwd();

const CommandTypes = union(enum) {
    help,
    push,
    pull,
    init,
    clone,
    fetch,
    deinit,
    branch,
    checkout,
    cat_file,

    fn keyword(word: [:0]const u8) CommandTypes {
        const map = std.ComptimeStringMap(CommandTypes, .{
            .{ "help", .help },
            .{ "push", .push },
            .{ "pull", .pull },
            .{ "init", .init },
            .{ "clone", .clone },
            .{ "fetch", .fetch },
            .{ "deinit", .deinit },
            .{ "branch", .branch },
            .{ "checkout", .checkout },
            .{ "cat-file", .cat_file },
        });

        if (map.get(word)) |command| {
            return command;
        }

        return .help;
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    // Skipping the first arg
    _ = argsIterator.next();

    if (argsIterator.next()) |command| {
        switch (CommandTypes.keyword(command)) {
            .init => @import("./commands/init.zig").init() catch |err| switch (err) {
                error.PathAlreadyExists => std.log.err("Project already initialized", .{}),
                else => std.log.err("{?}", .{err}),
            },
            .deinit => @import("./commands/deinit.zig").init() catch |err| switch (err) {
                else => std.log.err("{?}", .{err}),
            },
            .cat_file => @import("./commands/cat-file.zig").init(argsIterator, allocator) catch |err| switch (err) {
                else => std.log.err("{?}", .{err}),
            },
            else => std.log.err("Command not found", .{}),
        }
    } else {
        return std.log.err("please put a command example: lit [command] [other]", .{});
    }
}
