const std = @import("std");
const fs = std.fs.cwd();

const Directory = struct {
    dir: ?std.fs.Dir,
    alloc: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) Directory {
        return Directory{ .dir = null, .alloc = allocator };
    }

    pub fn open(self: *Directory, dirName: []u8) !void {
        if (self.dir) |dir| {
            dir.close();
        }
        self.dir = try fs.openDir(dirName, .{ .iterate = true });
    }

    pub fn close(self: *Directory) void {
        if (self.dir) |dir| {
            dir.close();
            self.dir = null;
        }
    }

    pub fn print(self: *Directory) !void {
        var iterator = self.dir.?.iterate();
        std.log.info("Directory", .{});
        while (try iterator.next()) |file| {
            if (file.kind == .file) {
                std.log.info("{s}", .{file.name});
            }
        }
    }

    pub fn exist(self: *Directory) bool {
        var iterator = self.dir.?.iterate();
        std.log.info("Directory", .{});
        while (try iterator.next()) |file| {
            if (file.kind == .file) {
                return true;
            }
        }
        return false;
    }
};
