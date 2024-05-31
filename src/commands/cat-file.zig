const std = @import("std");
const Option = @import("../utils/option.zig").Option;

pub fn init(argIter: std.process.ArgIterator, alloc: std.mem.Allocator) void {
    var arena = std.heap.ArenaAllocator.init(alloc);
    var options = Option.init(arena.allocator(), argIter);
    defer options.free();

    options.parse();
    options.print();
    std.debug.print("the value is: {?}\n", .{options.get("-p")});
    std.debug.print("the value is: {?}\n", .{options.get("-su")});
}
