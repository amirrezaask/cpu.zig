const std = @import("std");
const Inst = struct {
    const Ref = union(enum) {
        Value: u64,
        Register: u8,
    };
    op_code: CPU.OpCodes,
    out: u8, // is always a register number
    arg1: Ref = undefined,
    arg2: Ref = undefined,

    pub fn Set(out_reg: u8, in_ref: Ref) Inst {
        return .{
            .op_code = .Set,
            .out = out_reg,
            .arg1 = in_ref,
        };
    }

    pub fn Add(out_reg: u8, arg1: Ref, arg2: Ref) Inst {
        return .{
            .op_code = .Add,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn display(insts: []Inst) void {
        for (insts) |inst, idx| {
            std.debug.print("{}: OP_CODE={} OUT={} ARG1={} ARG2={}\n", .{ idx, inst.op_code, inst.out, inst.arg1, inst.arg2 });
        }
    }
};

const CPU = struct {
    const Self = @This();
    pub const OpCodes = enum {
        Set,
        Add,
    };
    const Register = union(enum) {
        // HeapReference: u64, // heap reference
        Value: u64, // value in register like an int
        // CodeReference: u64, // reference to data part of binary
    };

    registers: [16]Register = undefined,

    pub fn init() CPU {
        return .{};
    }

    pub fn registers_state(self: Self) void {
        for (self.registers) |reg, idx| {
            std.debug.print("{}: {}\n", .{ idx, reg.Value });
        }
    }

    pub fn run(self: *Self, insts: []Inst) !void {
        for (insts) |inst| {
            switch (inst.op_code) {
                .Set => {
                    self.registers[inst.out] = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg],
                        Inst.Ref.Value => |val| CPU.Register{ .Value = val },
                    };
                },

                .Add => {
                    const arg1 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    const arg2 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    self.registers[inst.out] = .{ .Value = arg1 + arg2 };
                },
            }
        }
    }
};

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
    var insts = [_]Inst{
        Inst.Set(0, .{ .Value = 10 }),
        Inst.Set(1, .{ .Value = 10 }),
        Inst.Add(
            1,
            .{ .Register = 0 },
            .{ .Register = 1 },
        ),
    };
    Inst.display(&insts);
    var cpu = CPU.init();
    try cpu.run(&insts);
    cpu.registers_state();
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}
