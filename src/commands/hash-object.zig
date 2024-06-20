const std = @import("std");
const fs = std.fs.cwd();
const zlib = std.compress.zlib;
const sha = std.crypto.hash.Sha1;
const String = @import("string").String;
const Option = @import("../utils/option.zig").Option;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();

    if (options.get("-w")) |entry| {
        if (entry.V) |filepath| {
            var file = try fs.openFile(filepath, .{ .mode = .read_only });
            defer file.close();

            var compressed_content = String.init(alloc);

            _ = try zlib.compress(file.reader(), compressed_content.writer(), .{ .level = .level_9 });

            var sha1 = sha.init(.{});
            sha1.update(compressed_content.str());
            const hash_result = sha1.finalResult();
            const hash = try std.fmt.allocPrint(
                alloc,
                "{s}",
                .{std.fmt.fmtSliceHexLower(&hash_result)},
            );
            defer alloc.free(hash);

            var path = String.init(alloc);
            try path.concat(".lit/objects/");
            try path.concat(hash[0..2]);

            try fs.makeDir(path.str());

            try path.concat("/");
            try path.concat(hash[2..]);

            const created_file = try fs.createFile(path.str(), .{ .read = true });
            defer created_file.close();

            try created_file.writeAll(compressed_content.str());

            std.log.debug("Hash: {s}", .{hash});
        }
    }
}
