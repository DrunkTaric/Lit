const ExportHash = struct {
    directory: []u8,
    file: []u8,
};

const Hash = struct {
    fn create() void {}
    fn validate() void {}
};
