---
title: LLVM's IR Core Concepts - Values, Registers, Memory
date: 2022-03-20
---

(This is still early draft)

There are three key abstractions on top of which LLVM IR is built: Values,
Registers and Memory.

## Values

In LLVM IR, **a Value is a piece of data, and data is described by a type**.
For example, the integer `42` is a Value, and its representation using 32 bits
is spelled `i32 42`.

## Registers and Memory

There are two places where Values may live: in a Register or in Memory.

### Registers

A register is an entity that can hold exactly one Value; it will have a "size"
big enough to hold its Value regardless of the Value's type; for example, a
register may hold a single integer or even an entire array.

Registers have _names_, and we use their _name_ to access the underlying Value.
Any name starting with the `%` symbol is the name of a register. For example:
`%0, %hi, %___` are all register names.

LLVM IR provides infinitely many registers.

### Memory

(TODO define memory, region of bytes, addresses, not typed, load/store operations)

### Registers have Names, Memory has Addresses


Note the difference: registers have names but not addresses (they are *not*
memory locations). Memory does not have "names", only addresses.

This is a core principle, so excuse the repetition: to access a Value inside a
register, we use the _register's name_. To access a Value in memory, we
use its _memory address_.


# Instructions

(Should I move this to a separate post?)

An Instruction is an operation that may have Values as input, may define a
Register as output, and may modify state in a program (like writing Values to
memory). Each Instruction has semantics describing the expected input, the
produced output and changes it makes to the program state.

Here's an example instruction:

```llvm
  %result = add i32 10, 11
```

It adds the Values `i32 10` and `i32 11`, and defines (creates) a new register
`%result` to hold the resulting Value.

Input Values can also be provided by using the name of a register:

```llvm
  %another_result = add i32 %result, %result
```

Here's an example of Instructions affecting memory:

```llvm
%address = alloca i32
store i32 %result, i32* %address
```

The `alloca i32` instruction allocates enough memory to contain an `i32` Value.
It returns a Value corresponding to the address of that memory location, and
that Value is placed in the register named `%address`. What is the type of this
Value? It is a pointer type: `i32*`.

The second instruction, `store i32`, does not produce a Value. However, it
takes the memory address Value in the register `%address`, an integer Value in
the register `%result`, and stores the integer into that memory location.
