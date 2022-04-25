const std = @import("std");

// Memory is a array of bytes(u8) so size is basically length of array of bytes(u8)
fn Memory(comptime size: u64) type {
    return struct {
        const Self = @This();
        data: [size]u8 = undefined,
        stack_cur: u64 = 0,

        pub fn get_ref(self: *Self, ref: u64) u8 {
            return self.data[self.data.len - ref - 1];
        }

        pub fn get_ref_range(self: *Self, start: u64, length: u64) []u8 {
            const start_byte = self.data.len - start - 1;
            return self.data[start_byte .. start_byte + length];
        }

        pub fn set_ref(self: *Self, ref: u64, val: u8) void {
            self.data[self.data.len - ref - 1] = val;
            return;
        }

        pub fn pop(self: *Self) u8 {
            const val = self.data[self.stack_cur];
            self.stack_cur -= 1;
            return val;
        }

        pub fn push(self: *Self, val: u8) void {
            self.stack_cur += 1;
            self.data[self.stack_cur] = val;
        }
    };
}

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
    registers: [16]u64 = undefined,

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

test "memory push and pop from stack" {
    var mem = Memory(100){};
    mem.push(1);
    mem.push(2);
    try std.testing.expect(mem.pop() == 2);
    mem.push(3);
    try std.testing.expect(mem.pop() == 3);
    try std.testing.expect(mem.pop() == 1);
}

test "memory heap" {
    var mem = Memory(100){};
    mem.set_ref(10, 11);
    try std.testing.expect(mem.get_ref(10) == 11);
    mem.set_ref(0, 10);
    try std.testing.expect(mem.get_ref(0) == 10);
    mem.set_ref(10, 10);
    try std.testing.expect(mem.get_ref(10) == 10);
}
