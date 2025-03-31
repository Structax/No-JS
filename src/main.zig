const std = @import("std");
const parser = @import("parser.zig");
const render = @import("render.zig");

pub fn main() !void {
    const gpa = std.heap.page_allocator;
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len < 3 or !std.mem.eql(u8, args[1], "build")) {
        std.debug.print("Usage:\n  nojs build <input.nojs>\n", .{});
        return;
    }

    const input_path = args[2];
    const basename = std.fs.path.basename(input_path);
    const dot_index = std.mem.lastIndexOfScalar(u8, basename, '.') orelse basename.len;
    const stem = basename[0..dot_index];
    const output_path = try std.fmt.allocPrint(gpa, "output/{s}.html", .{stem});

    const page = try parser.parseFixedAst(gpa);
    defer gpa.destroy(page);

    const html = try render.renderHtml(page, gpa);
    defer gpa.free(html);

    const file = try std.fs.cwd().createFile(output_path, .{ .truncate = true });
    defer file.close();
    try file.writer().writeAll(html);

    std.debug.print("✅ HTML generated: {s}\n", .{output_path});
}

