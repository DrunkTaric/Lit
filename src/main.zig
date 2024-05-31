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
    } else {
        return std.log.err("please put a command example: lit [command] [other]", .{});
    }
}
