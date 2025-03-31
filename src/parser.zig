const std = @import("std");
const ast = @import("ast.zig");

pub fn parseFixedAst(allocator: std.mem.Allocator) !*ast.PageNode {
    const page = try allocator.create(ast.PageNode);

    // 状態
    const states = try allocator.alloc(ast.StateNode, 1);
    states[0] = ast.StateNode{
        .key = "username",
        .value = "Yuki",
    };

    // h1 TextNode
    const h1_text = ast.TextNode{ .content = "Welcome, {username}" };
    const h1_child = try allocator.alloc(ast.ElementChild, 1);
    h1_child[0] = .{ .Text = h1_text };

    const h1 = try allocator.create(ast.ElementNode);
    h1.* = ast.ElementNode{
        .tag = "h1",
        .children = h1_child,
    };

    // div → h1 を含む
    const div_child = try allocator.alloc(ast.ElementChild, 1);
    div_child[0] = .{ .Element = h1 };

    const elements = try allocator.alloc(ast.ElementNode, 1);
    elements[0] = ast.ElementNode{
        .tag = "div",
        .children = div_child,
    };

    // page node 完成
    page.* = ast.PageNode{
        .name = "home",
        .states = states,
        .elements = elements,
    };

    return page;
}
