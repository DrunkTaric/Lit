const std = @import("std");
const fs = std.fs.cwd();
const zlib = std.compress.zlib;
const Option = @import("../utils/option.zig").Option;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();

    if (options.get("-p")) |entry| {
        const dirname = entry.V.?[0..2];
        const path = ".lit/objects/" ++ dirname;
        var dir = try fs.openDir(path, .{ .iterate = true });
        var iterator = dir.iterate();
        while (try iterator.next()) |file| {
            if (file.kind == .file) {
                if (std.mem.eql(u8, file.name, entry.V.?[2..])) {
                    const target = try fs.openFile(path ++ file.name, .{ .mode = .read_only });
                    defer target.close();

                    var buffered = std.io.bufferedReader(target.reader());
                    var reader = buffered.reader();

                    var arr = std.ArrayList(u8).init(alloc);
                    defer arr.deinit();

                    while (true) {
                        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
                            error.EndOfStream => break,
                            else => return err,
                        };
                        arr.clearRetainingCapacity();
                    }

                    std.debug.print("things: {?}", .{reader});
                }
            }
        }
    }
}
