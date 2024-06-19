const std = @import("std");
const fs = std.fs.cwd();
const zlib = std.compress.zlib;
const Option = @import("../utils/option.zig").Option;
const String = @import("string").String;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();

    if (options.get("-p")) |entry| {
        if (entry.V) |value| {
            var path = String.init(arena.allocator());
            try path.concat(".lit/objects/" ++ value[0..2]);
            var dir = try fs.openDir(path.str(), .{ .iterate = true });
            var iterator = dir.iterate();
            while (try iterator.next()) |file| {
                if (file.kind == .file) {
                    if (std.mem.eql(u8, file.name, value[2..])) {
                        try path.concat("/");
                        try path.concat(value[2..]);
                        const target = try fs.openFile(path.str(), .{ .mode = .read_only });
                        defer target.close();

                        var buffered = std.io.bufferedReader(target.reader());
                        var reader = buffered.reader();

                        var arr = std.ArrayList(u8).init(alloc);
                        defer arr.deinit();

                        var buf: [1024]u8 = undefined;

                        while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
                            std.debug.print("{s}\n", .{line});
                        }
                    }
                }
            }
        }
    }
}
