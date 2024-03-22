const std = @import("std");
const log = std.log;
const colorLog = @import("colorlog");

pub const std_options = struct {
    // configure the std lib log api fn to use colorlog formatting
    pub const logFn = colorLog.logFn;
};

pub fn main() void {
    log.debug("a debug message", .{});
    log.info("an info message", .{});
    log.warn("a warning message", .{});
    log.err("an error message", .{});
}
