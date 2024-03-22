<h1 align="center">
    colorlog
</h1>

<div align="center">
    A color to your zig logs
</div>

---

[![ci](https://github.com/softprops/zig-colorlog/actions/workflows/ci.yml/badge.svg)](https://github.com/softprops/zig-colorlog/actions/workflows/ci.yml) ![License Info](https://img.shields.io/github/license/softprops/zig-colorlog) ![Releases](https://img.shields.io/github/v/release/softprops/zig-colorlog) [![Zig Support](https://img.shields.io/badge/zig-0.11.0-black?logo=zig)](https://ziglang.org/documentation/0.11.0/)

## 🍬 features

- compatible with std zig logging interface
- colors

## examples

```zig
const std = @import("std");
const colorLog = @import("colorlog");
const log = std.log.scoped(.demo);

pub const std_options = struct {
    // configure the std lib log api fn to use colorlog formatting
    pub const logFn = colorLog.logFn;
};

pub fn main() void {
    // std log interface
    log.debug("DEBUG", .{});
    log.info("INFO", .{});
    log.warn("WARN", .{});
    log.err("ERR", .{});
}
```

## 📼 installing

Create a new exec project with `zig init-exe`. Copy the echo handler example above into `src/main.zig`

Create a `build.zig.zon` file to declare a dependency

> .zon short for "zig object notation" files are essentially zig structs. `build.zig.zon` is zigs native package manager convention for where to declare dependencies

```zig
.{
    .name = "my-app",
    .version = "0.1.0",
    .dependencies = .{
        // 👇 declare dep properties
        .colorlog = .{
            // 👇 uri to download
            .url = "https://github.com/softprops/zig-colorlog/archive/refs/tags/v0.1.0.tar.gz",
            // 👇 hash verification
            .hash = "...",
        },
    },
}
```

> the hash below may vary. you can also depend any tag with `https://github.com/softprops/zig-colorlog/archive/refs/tags/v{version}.tar.gz` or current main with `https://github.com/softprops/zig-colorlog/archive/refs/heads/main/main.tar.gz`. to resolve a hash omit it and let zig tell you the expected value.

Add the following in your `build.zig` file

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});
    // 👇 de-reference colorlog dep from build.zig.zon
    const colorlog = b.dependency("colorlog", .{
        .target = target,
        .optimize = optimize,
    });
    var exe = b.addExecutable(.{
        .name = "your-exe",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    // 👇 add the colorlog module to executable
    exe.addModule("colorlog", colorlog.module("colorlog"));

    b.installArtifact(exe);
}
```

## 🥹 for budding ziglings

Does this look interesting but you're new to zig and feel left out? No problem, zig is young so most us of our new are as well. Here are some resources to help get you up to speed on zig

- [the official zig website](https://ziglang.org/)
- [zig's one-page language documentation](https://ziglang.org/documentation/0.11.0/)
- [ziglearn](https://ziglearn.org/)
- [ziglings exercises](https://github.com/ratfactor/ziglings)

\- softprops 2024
