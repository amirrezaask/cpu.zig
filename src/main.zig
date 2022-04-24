const std = @import("std");
const Inst = @import("cpu.zig").Inst;
const CPU = @import("cpu.zig").CPU;

// Memory []u8 => array of bytes(8 bit unsigned integers)
// 1GB Memory = [10**9]u8

fn Memory(comptime stack_size: u8, comptime heap_size: u8) type {
    return struct {
        stack: Stack(stack_size),
        heap: [heap_size]u8,
    };
}

fn Stack(comptime size: u64) type {
    return struct {
        const Self = @This();
        data: [size]u64,
        top: u8,

        pub fn pop(self: Self) u64 {
            self.top -= 1;
            return self.data[self.top];
        }
        pub fn push(self: Self, val: u64) void {
            self.top += 1;
            self.data[self.top] = val;
            return;
        }
    };
}

pub fn main() anyerror!void {
    var insts = [_]Inst{ Inst.Set(0, .{ .Value = 10 }), Inst.Set(1, .{ .Value = 10 }), Inst.Add(
        1,
        .{ .Register = 0 },
        .{ .Register = 1 },
    ), Inst.Pow(2, .{ .Register = 0 }, .{ .Value = 3 }), Inst.Sub(12, .{ .Value = 1000 }, .{ .Value = 2 }) };
    Inst.display(&insts);
    var cpu = CPU.init();
    try cpu.run(&insts);
    cpu.registers_state();
}
// todos:
// change register into just being a simple u64, based on inst we should decide to see it as a value or a memory addr
// memory should be a simple array of u8
// from start we work with it as stack and from end as heap
// loading insts at the end and reserve that for program insts

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
