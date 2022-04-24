const std = @import("std");

pub const Inst = struct {
    op_code: CPU.OpCodes,
    out: u64,
    arg1: u64 = undefined,
    arg2: u64 = undefined,

    pub fn Set(out_reg: u64, value: u64) Inst {
        return .{
            .op_code = .Set,
            .out = out_reg,
            .arg1 = value,
        };
    }

    pub fn Add(out_reg: u64, arg1: u64, arg2: u64) Inst {
        return .{
            .op_code = .Add,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }
    pub fn Sub(out_reg: u64, arg1: u64, arg2: u64) Inst {
        return .{
            .op_code = .Sub,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Div(out_reg: u64, arg1: u64, arg2: u64) Inst {
        return .{
            .op_code = .Div,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Mul(out_reg: u64, arg1: u64, arg2: u64) Inst {
        return .{
            .op_code = .Mul,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Pow(out_reg: u64, arg1: u64, arg2: u64) Inst {
        return .{
            .op_code = .Pow,
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

pub const CPU = struct {
    const Self = @This();
    pub const OpCodes = enum { Set, Add, Sub, Div, Mul, Pow };
    
    // 64 bit integer value can be either a reference to memory or value itself
    registers: [16]u64= undefined,

    pub fn init() CPU {
        return .{};
    }

    pub fn registers_state(self: Self) void {
        for (self.registers) |reg, idx| {
            std.debug.print("{}: {}\n", .{ idx, reg });
        }
    }

    pub fn run(self: *Self, insts: []Inst) !void {
        for (insts) |inst| {
            switch (inst.op_code) {
                .Set => {
                    self.registers[inst.out] = inst.arg1;
                },

                .Add => {
                    self.registers[inst.out] = self.registers[inst.arg1] + self.registers[inst.arg2];
                },

                .Sub => {
                    self.registers[inst.out] = self.registers[inst.arg1] - self.registers[inst.arg2];
                },

                .Div => {
                    self.registers[inst.out] = self.registers[inst.arg1] / self.registers[inst.arg2];
                },
                .Mul => {
                    self.registers[inst.out] = self.registers[inst.arg1] * self.registers[inst.arg2];
                },
                .Pow => {
                    self.registers[inst.out] = std.math.pow(u64, self.registers[inst.arg1], self.registers[inst.arg2]);
                },
            }
        }
    }
};