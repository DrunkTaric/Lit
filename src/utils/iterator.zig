const Entry = struct { prev: ?Entry, next: ?Entry, value: []u8 };

const Args = struct {
    cursor: ?Entry,
    tree: []Entry,

    pub fn init() void {}
    pub fn has() void {}
    pub fn next() void {}
    pub fn before() void {}
};
