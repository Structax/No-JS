const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "nojs",
        .root_source_file = b.path("src/main.zig"), // ← 修正ポイント！
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.addArg("examples/hello.nojs");

    const run_step = b.step("run", "Run the nojs CLI");
    run_step.dependOn(&run_cmd.step);
}
