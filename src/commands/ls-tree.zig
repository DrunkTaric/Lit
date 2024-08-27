const std = @import("std");
const fs = std.fs.cwd();
const String = @import("string").String;
const Option = @import("../utils/option.zig").Option;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    defer arena.deinit();
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();

    if (options.get("-h")) |entry| {
        if (options.get("--name-only")) |_| {
            if (entry.V) |hash| {
                var path = String.init(arena.allocator());
                defer path.deinit();

                try path.concat(".lit/objects/" ++ hash[0..2]);
                var dir = try fs.openDir(path.str(), .{ .iterate = true });
                var iterator = dir.iterate();
                while (try iterator.next()) |file| {
                    if (file.kind == .file) {
                        var filename = String.init(arena.allocator());
                        defer filename.deinit();

                        try filename.concat(hash[2..]);

                        if (std.mem.eql(u8, file.name, filename.str())) {
                            try path.concat("/");
                            try path.concat(filename.str());

                            const target = try fs.openFile(path.str(), .{ .mode = .read_only });
                            defer target.close();

                            var input_buffer = std.io.bufferedReader(target.reader());
                            const in_reader = input_buffer.reader();

                            var decompressed_data = String.init(alloc);

                            const result = std.compress.zlib.decompress(in_reader, decompressed_data.writer());

                            if (result) |_| {
                                std.log.debug("Decompressed data: {s}\n", .{decompressed_data.str()[0..]});
                            } else |err| {
                                std.debug.print("Decompression failed: {}\n", .{err});
                            }
                        }
                    }
                }
            }
        }
    }
}
