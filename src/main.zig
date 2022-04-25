const std = @import("std");
const Inst = @import("cpu.zig").Inst;
const CPU = @import("cpu.zig").CPU;

//TODO:
// - make cpu agnostic about stuff in a register each inst should infer that for itself [x]
// - come up with an encoding of inst -> []u8 []
// - cpu loads insts from memory. []
// - stack and heap are on the same memory space [x]

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

test "root" {
    _ = @import("cpu.zig");
}
