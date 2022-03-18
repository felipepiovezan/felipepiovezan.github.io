

# The Anatomy of an IR Module

One LLVM IR file (`.ll`) contains one LLVM IR Module, a top-level entity
encapsulating all other data structures in the IR. There are four such
data structures:

1. A structure describing the target architecture and platform.
2. Global Variables.
3. Functions.
4. Debug information and other metadata.

// Picture here

In this text, we will focus on Global Variables and Functions.

# Values

In LLVM IR, a Value is any piece of data that is described by a type. For
example, the integer 42 is a Value, and its representation using 32 bits is
spelled `i32 42`.

Values are everywhere in LLVM: **every** operand of an operation is a Value.

# Registers and Memory

There are two places where Values may live:

1. In registers: these are entities that can be referred to by name.
2. In  memory: memory locations have addresses, and loading/storing Values
from/to memory is done using addresses.

Note the difference: registers have names but not addresses (they are *not*
memory locations). Memory does not have "name", only addresses.

This is a core principle, so excuse the repetition: to access a Value inside a
register, we **must** use the register's name. To access a Value in memory, we
**must** use its memory address.

In LLVM IR, there are infinitely many registers. Any name starting with the `%`
symbol is the name of a register. For example: `%0, %hi, %___` are all register
names.

A register will have a "size" big enough to hold its Value, regardless of the
Value's type; for example, a register may hold an entire array.
