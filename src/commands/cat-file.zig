const std = @import("std");
const fs = std.fs.cwd();
const zlib = std.compress.zlib;
const Option = @import("../utils/option.zig").Option;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();

    if (options.get("-p")) |entry| {
        const dirname = entry.V.?[0..2];
        const filename = entry.V.?[2..];
        const path = ".lit/objects/" ++ dirname ++ "/" ++ filename;
        var file = try fs.openFile(path, .{ .iterate = true });
        if (file) {
            file.readAll();
            std.debug.print("Lebron is real with value: {any}\n", .{dirname});
        } else {
            std.log.err("Error happend while trying to access the file", .{});
        }
    }
}
