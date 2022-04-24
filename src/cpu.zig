const std = @import("std");

pub const Inst = struct {
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
    pub fn Sub(out_reg: u8, arg1: Ref, arg2: Ref) Inst {
        return .{
            .op_code = .Sub,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Div(out_reg: u8, arg1: Ref, arg2: Ref) Inst {
        return .{
            .op_code = .Div,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Mul(out_reg: u8, arg1: Ref, arg2: Ref) Inst {
        return .{
            .op_code = .Mul,
            .out = out_reg,
            .arg1 = arg1,
            .arg2 = arg2,
        };
    }

    pub fn Pow(out_reg: u8, arg1: Ref, arg2: Ref) Inst {
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
    const Register = union(enum) {
        Value: u64, // value in register like an int
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
                    const arg2 = switch (inst.arg2) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    self.registers[inst.out] = .{ .Value = arg1 + arg2 };
                },

                .Sub => {
                    const arg1 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    const arg2 = switch (inst.arg2) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };

                    self.registers[inst.out] = .{ .Value = arg1 - arg2 };
                },

                .Div => {
                    const arg1 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    const arg2 = switch (inst.arg2) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };

                    self.registers[inst.out] = .{ .Value = arg1 / arg2 };
                },
                .Mul => {
                    const arg1 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    const arg2 = switch (inst.arg2) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };

                    self.registers[inst.out] = .{ .Value = arg1 * arg2 };
                },
                .Pow => {
                    const arg1 = switch (inst.arg1) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };
                    const arg2 = switch (inst.arg2) {
                        Inst.Ref.Register => |reg| self.registers[reg].Value,
                        Inst.Ref.Value => |val| val,
                    };

                    self.registers[inst.out] = .{ .Value = std.math.pow(u64, arg1, arg2) };
                },
            }
        }
    }
};