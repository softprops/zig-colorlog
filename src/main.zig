const std = @import("std");

const defaultLogger = Logger(std.io.getStdErr().writer());

/// A colorful logging impl that writes to stderr
pub const logFn = defaultLogger.func;

var MAX_WIDTH: usize = 0;

fn Logger(comptime writer: anytype) type {
    return struct {
        fn func(
            comptime level: std.log.Level,
            comptime scope: @TypeOf(.EnumLiteral),
            comptime format: []const u8,
            args: anytype,
        ) void {
            impl(
                writer,
                level,
                scope,
                format,
                args,
            );
        }
    };
}

fn impl(
    writer: anytype,
    comptime level: std.log.Level,
    comptime scope: @TypeOf(.EnumLiteral),
    comptime format: []const u8,
    args: anytype,
) void {
    const max_width = blk: {
        const level_len = level.asText().len;
        const cur_max = MAX_WIDTH;
        if (cur_max < level_len) {
            MAX_WIDTH = level_len;
            break :blk level_len;
        } else {
            break :blk cur_max;
        }
    };
    _ = max_width;

    const scope_prefix = "\x1b[1m" ++ @tagName(scope) ++ ":\x1b[0m ";
    const prefix = switch (level) {
        .err => "\x1b[91m",
        .warn => "\x1b[93m",
        .info => "\x1b[92m",
        .debug => "\x1b[95m",
    } ++ comptime level.asText() ++ (" " ** (7 - level.asText().len)) ++ "\x1b[0m " ++ scope_prefix;
    nosuspend writer.print(prefix ++ format ++ "\n", args) catch return;
}

test "simple test" {
    var buf: [100]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buf);
    const writer = fbs.writer();

    impl(writer, .info, .bar, "test", .{});
    const actual = fbs.getWritten();
    try std.testing.expectEqualStrings("\x1b[92minfo   \x1b[0m \x1b[1mbar:\x1b[0m test\n", actual);
}
