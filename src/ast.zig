const std = @import("std");

pub const PageNode = struct {
    name: []const u8,
    states: []StateNode,
    elements: []ElementNode,
};

pub const StateNode = struct {
    key: []const u8,
    value: []const u8,
};

pub const ElementNode = struct {
    tag: []const u8,
    children: []ElementChild,
};

pub const ElementChild = union(enum) {
    Text: TextNode,
    Element: *ElementNode,
};

pub const TextNode = struct {
    content: []const u8,
};
