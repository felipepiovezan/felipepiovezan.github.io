---
title: LLVM's IR Core Concepts - Values, Registers, Memory
date: 2022-03-20
---

There are three key abstractions on top of which LLVM IR is built: Values,
registers and memory.

## Values

In LLVM IR, **a Value is a piece of data, and data is described by a type**.
For example, the integer `42` is a Value, and its representation using 32 bits
is spelled `i32 42`.

## Registers and Memory

There are two places where Values may live: in a register or in memory.

### Registers

A register is an entity that can hold exactly one Value; Values are placed into
registers through instructions (more on this later). Once a register is
defined, its value never changes.

A register will have a "size" big enough to hold its Value regardless of the
Value's type; for example, a register may hold a single integer or even an
entire array.

Registers have _names_, and we use their _name_ to access the underlying Value.
Any name starting with the `%` symbol is the name of a register. For example:
`%0, %hi, %___` are all register names.

LLVM IR provides infinitely many registers.

### Memory

Memory is a sequence of bytes, each of which has an address. Addresses, also
known as pointers, are Values and therefore may be placed into a register.

To load a Value previously stored in memory, we can write a memory address into
a register, and then use that register in a load operation.

Note an important property of this characterization of memory: it is a sequence
of bytes with addresses. Memory does not hold information about the types of
Values that were previously stored in it; it is how we use memory addresses
that give meaning (a type) to a sequence of bytes.

# Registers have Names, Memory has Addresses

Note the difference in the definition of registers and memory: registers have
names but not addresses (they are *not* memory locations). Memory does not have
names, only addresses.

This is a core principle, so excuse the repetition: to access a Value inside a
register, we use the _register's name_. To access a Value in memory, we
use its _memory address_, which may be placed into a register.


# Instructions

Having defined values, registers, and memory, we're now ready to talk about
instructions.

An instruction is an operation that may have Values as input, may define a
register as output, and may modify state in a program (like writing Values to
memory). Each Instruction has semantics describing the expected input, the
produced output and changes it makes to the program state ("side effects").

Here's an example instruction:

```llvm
  %result = add i32 10, %two
```

It adds the Value `i32 10` and the Value inside register `%two`, and defines
(creates) a new register `%result` to hold the resulting Value.

LLVM's type system is very strict, so here there is an implicit assumption that
`%two` has a Value of type `i32` as well. This is statically checked, and the
IR is invalid otherwise.

Instructions can also interact with memory:

```llvm
%address = alloca i32
store i32 %result, i32* %address
```

The `alloca i32` instruction allocates enough memory to contain an `i32` Value.
It returns a Value corresponding to the address of that memory location, and
that Value is placed in the register named `%address`. What is the type of this
Value? It is a pointer type: `i32*`.

The second instruction, `store i32`, does not produce a Value. It takes the
memory address in the register `%address`, an integer in the register
`%result`, and stores the integer into that memory location.

Recall this paragraph from our memory definition:

> Memory does not hold information about the types of Values that were
> previously stored in it; it is how we use memory addresses that give meaning
> (a type) to a sequence of bytes.

In the case of the `store i32` instruction, it uses the input address as a
memory region containing a Value of type `i32`. In other words, the store
instruction gave meaning (a type) to that address. One could argue that the
type of `%address` also encodes this information; this is true, but LLVM IR is
in a transition period and soon there will be a single type of pointer:
`void*`.
