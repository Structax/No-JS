const std = @import("std");
const ast = @import("ast.zig");

pub fn renderHtml(page: *const ast.PageNode, allocator: std.mem.Allocator) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    try renderElements(&out, page.elements, page.states, allocator);
    return out.toOwnedSlice();
}

fn renderElements(out: *std.ArrayList(u8), elements: []const ast.ElementNode, states: []const ast.StateNode, allocator: std.mem.Allocator) !void {
    for (elements) |el| {
        try out.writer().print("<{s}>", .{el.tag});
        for (el.children) |child| {
            switch (child) {
                .Text => |txt| {
                    const replaced = try replaceVars(txt.content, states, allocator);
                    try out.appendSlice(replaced);
                },
                .Element => |elem| {
                    try renderElements(out, &[_]ast.ElementNode{elem.*}, states, allocator);
                },
            }
        }
        try out.writer().print("</{s}>", .{el.tag});
    }
}

fn replaceVars(input: []const u8, states: []const ast.StateNode, allocator: std.mem.Allocator) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    var i: usize = 0;
    while (i < input.len) {
        if (input[i] == '{') {
            const end = std.mem.indexOfScalarPos(u8, input, i, '}') orelse return error.InvalidVarSyntax;
            const var_name = input[i + 1 .. end];
            const val = findState(var_name, states) orelse return error.UnknownVariable;
            try out.appendSlice(val);
            i = end + 1;
        } else {
            try out.append(input[i]);
            i += 1;
        }
    }
    return out.toOwnedSlice();
}

fn findState(name: []const u8, states: []const ast.StateNode) ?[]const u8 {
    for (states) |s| {
        if (std.mem.eql(u8, s.key, name)) return s.value;
    }
    return null;
}
