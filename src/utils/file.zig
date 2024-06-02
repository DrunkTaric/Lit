const std = @import("std");
const fs = std.fs.cwd();

const File = struct {
    file: ?std.fs.File,

    pub fn init() File {
        return File{ .file = null };
    }

    pub fn open(self: *File, path: []const u8, mode: std.fs.File.OpenFlags) !void {
        if (self.file) |file| {
            file.close();
        }
        self.file = try fs.openFile(path, mode);
    }

    pub fn close(self: *File) void {
        if (self.file) |file| {
            file.close();
            self.file = null;
        }
    }

    pub fn read(self: *File, buffer: []u8) !usize {
        return try self.file.?.read(buffer);
    }

    pub fn write(self: *File, buffer: []const u8) !void {
        try self.file.?.write(buffer);
    }

    pub fn print(self: *File) !void {
        var buffer: [1024]u8 = undefined;
        const read_count = try self.read(&buffer);
        const contents = buffer[0..read_count];

        std.debug.print("File contents: {s}", .{contents});
    }
};
