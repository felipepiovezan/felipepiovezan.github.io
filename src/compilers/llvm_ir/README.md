---
title: LLVM's Intermediate Representation
slug: ../LLVM_IR
---

Intermediate Representations (IRs) are representations employed by compilers in
order to facilitate parts of the compilation pipeline.

/// TODO: Mention what we will do, using llvm ir, and that it enables us to
//look at IR generated from other languages.

# Compilers and Transformations

To understand what an IR is, let's look at what compilers do and how they are
structured. In essence, a compiler receives a program written in some source
language and _transforms_ it into an executable program. This _transformation_
has a key property: it preserves some kind of behavior.

For example, a program written in C++ describes what happens in some abstract
machine defined by the C++ standard. When the compiler _transforms_ this
program into a program for a real world machine, it must ensure that the real
world machine will behave like the C++ abstract machine does.

// image here

In reality, the compiler performed many such behaviour-preserving
_transformations_ before producing the final program, using many different
representations along the way. Here's one possible flow that an LLVM-based
compiler may follow:

1. Start with the source program.
2. _Transform_ the source program into a Parse Tree.  * Usually, this step can fail for ill-formed programs.
3. _Transform_ the Parse Tree into an Abstract Syntax Tree (AST).
4. Perform semantic analysis on the AST, _transforming_ it into a different AST.
    * Usually, this step can fail for ill-formed programs.
5. _Transform_ the AST into an Intermediate Representation (IR).
6. Perform "optimizations" on the IR, _transforming_ it into equivalent IR.
    * This is done many times.
7. _Transform_ the IR into a Selection DAG.
8. _Transform_ the Selection DAG into a Machine DAG.
9. _Transform_ the Machine DAG into a sequence of machine instructions.
10. _Transform_ the machine instructions into the final program.

// insert picture here.

The list is not comprehensive, especially in the later stages which I am not
familiar with; the important observation is the number of _transformations_,
and how __all__ of them must preserve behavior specified by each input
representation in the output representation.

While each representation in the list above is "intermediate" in the sense that
it is neither the input program nor the final executable, when we say
Intermediate Representation we usually mean the IR generated in step 5,
"optimized" (_transformed_) in step 6, and lowered in step 7.

Steps 1-5 are specific to the source language of the input program, all other
steps are agnostic to the language, and the IR is the first such agnostic
representation.

# Enter the IR

In the compilation pipeline, the IR sits between representations specific to
source languages and representations specific to the target machine.

// picture here (no arrrows)

From where the IR sits, we can derive some of its design goals:

* it must be able to represent concepts from any high level language,
* it must be amenable to analysis required by "optimizating" transformations,
* it must be able to represent concepts required by target specific
representations.

// picture here with arrows

To accomplish these design goals, LLVM's IR:

* is a RISC-like language
* has a type system
* is highly configurable

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
