const std = @import("std");
const fs = std.fs.cwd();

pub fn init() anyerror!void {
    std.log.info("Lit is being initialized", .{});

    try fs.makeDir(".lit");

    try fs.makeDir(".lit/objects");
    try fs.makeDir(".lit/refs");
    const file = try fs.createFile(".lit/HEAD", .{});
    const content: []const u8 = "ref: refs/heads/master\n";
    _ = try file.write(content);
    file.close();

    std.log.info("Lit is initialized", .{});
}
