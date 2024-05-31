const std = @import("std");
const fs = std.fs.cwd();

pub fn init() anyerror!void {
    std.log.info("Lit is being deinitialized", .{});
    try fs.deleteTree(".lit");
    std.log.info("Lit is deinitialized", .{});
}
