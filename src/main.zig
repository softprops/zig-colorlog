const std = @import("std");

pub const std_options = struct {
    pub const logFn = colorLog;
};

pub fn colorLog(
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    impl(
        std.io.getStdErr().writer(),
        level,
        scope,
        format,
        args,
    );
}

fn impl(
    writer: anytype,
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const scope_prefix = "(" ++ @tagName(scope) ++ "): ";
    const prefix = switch (level) {
        .err => "\x1b[91m",
        .warn => "\x1b[93m",
        .info => "\x1b[92m",
        .debug => "\x1b[95m",
    } ++ comptime level.asText() ++ "\x1b[0m " ++ scope_prefix;
    nosuspend writer.print(prefix ++ format ++ "\n", args) catch return;
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    std.log.debug("test 1", .{});
    std.log.info("test 2", .{});
    std.log.warn("test 3", .{});
    std.log.err("test 4", .{});
}

test "simple test" {
    const allocator = std.testing.allocator;
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();
    var writer = list.writer();

    impl(writer, .info, .bar, "test", .{});
    const actual = try list.toOwnedSlice();
    defer allocator.free(actual);
    try std.testing.expectEqualStrings(
        \\info (bar): test
        \\
    , actual);
}
