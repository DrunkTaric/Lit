const std = @import("std");

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

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
