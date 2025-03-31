const std = @import("std");
const parser = @import("parser.zig");
const render = @import("render.zig");

pub fn main() !void {
    const gpa = std.heap.page_allocator;
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len < 2) {
        std.debug.print("Usage: zig build run <input.nojs>\n", .{});
        return;
    }

    const input_path = args[1];

    // 🌟 入力ファイル名から出力ファイル名生成
    const basename = std.fs.path.basename(input_path); // e.g. hello.nojs
    const dot_index = std.mem.lastIndexOfScalar(u8, basename, '.') orelse basename.len;
    const stem = basename[0..dot_index];
    const output_path = try std.fmt.allocPrint(gpa, "output/{s}.html", .{stem});

    // 📦 パース（今回は固定構文を返す）
    const page = try parser.parseFixedAst(gpa);
    defer gpa.destroy(page);

    // 🧠 HTML出力
    const html = try render.renderHtml(page, gpa);
    defer gpa.free(html);

    // 💾 書き出し
    var file = try std.fs.cwd().createFile(output_path, .{ .truncate = true });
    defer file.close();
    try file.writer().writeAll(html);

    std.debug.print("✅ Generated: {s}\n", .{output_path});
}
