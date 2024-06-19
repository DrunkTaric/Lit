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




                }
            }
        }
    }
}
