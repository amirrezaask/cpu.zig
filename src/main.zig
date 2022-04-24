const std = @import("std");
const Inst = @import("cpu.zig").Inst;
const CPU = @import("cpu.zig").CPU;

//TODO: 
    // - make cpu agnostic about stuff in a register each inst should infer that for itself []
    // - cpu loads insts from memory. []
    // - stack and heap are on the same memory space []


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
    // var insts = [_]Inst{ 
    //     Inst.Set(0, 10), 
    //     Inst.Set(1, 10), 
    //     Inst.Add(1, 0, 1), 
    //     Inst.Set(3, 3),
    //     Inst.Pow(2, 0, 3), 
    //     Inst.Sub(12, 2, 2) 
    // };
    // Inst.display(&insts);
    // var cpu = CPU.init();
    // try cpu.run(&insts);
    // cpu.registers_state();
}


test "SET" {
    var insts = [_]Inst{ 
        Inst.Set(0, 10), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 10), cpu.registers[0]);
}

test "Add" {
    var insts = [_]Inst{ 
        Inst.Set(0, 10), 
        Inst.Set(1, 10), 
        Inst.Add(2, 0, 1), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 20), cpu.registers[2]);

}

test "Sub" {
    var insts = [_]Inst{ 
        Inst.Set(0, 20), 
        Inst.Set(1, 10), 
        Inst.Sub(2, 0, 1), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 10), cpu.registers[2]);

}
test "Mul" {
    var insts = [_]Inst{ 
        Inst.Set(0, 20), 
        Inst.Set(1, 10), 
        Inst.Mul(2, 0, 1), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 200), cpu.registers[2]);

}
test "Div" {
    var insts = [_]Inst{ 
        Inst.Set(0, 20), 
        Inst.Set(1, 10), 
        Inst.Div(2, 0, 1), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 2), cpu.registers[2]);

}
test "Pow" {
    var insts = [_]Inst{ 
        Inst.Set(0, 20), 
        Inst.Set(1, 2), 
        Inst.Pow(2, 0, 1), 
    };
    var cpu = CPU.init();
    try cpu.run(&insts);
    try std.testing.expectEqual(@as(u64, 400), cpu.registers[2]);
}

