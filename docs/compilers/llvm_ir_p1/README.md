---
title: What is an Intermediate Representation?
date: 2022-03-17
---

Intermediate Representations (IRs) are used by compilers to represent programs
throughout the compilation pipeline. To understand what an IR is, let's look at
what compilers do and how they are structured.

# Compilers and Transformations

In essence, a compiler takes a program written in some source language and
_transforms_ it into an executable program; this _transformation_ has a key
property: it preserves behavior defined by the source language.

For example, a program written in C++ describes what happens in the abstract
machine defined by the C++ standard. When the compiler _transforms_ this
program into a program for a real world machine, it must ensure that the real
world machine will behave like the C++ abstract machine would.

![](behavior_preserving_transformation.svg){style="display:block; margin: auto;"}

## Many Transformations

In reality, the compiler performs many behaviour-preserving _transformations_
before producing the final program; along the way, it uses many different
representations for the program, like graphs, high-level instruction sequences,
and real machine instructions. Let's look at one possible flow that an
LLVM-based compiler may follow; don't worry about the names of each stage, as
we're only interested in the fact that they exist, and where _the_ IR is
located.

![](expanded_transformations.svg){style="display:block; margin: auto;"}

We start with the source program, and then we:

1. _Transform_ it into a Parse Tree.
   * Usually, this step can fail for ill-formed programs.
2. _Transform_ it into an Abstract Syntax Tree (AST).
3. _Transform_ it into a semantically valid AST.
   * Usually, this step can fail for ill-formed programs.
4. _Transform_ it into Intermediate Representation (IR).
5. _Transform_ it into equivalent IR.
   * Often referred to as "optimizations".
6. _Transform_ it into a Selection DAG.
7. _Transform_ it into sequence of machine instructions.
8. _Transform_ it into the final program.

The list is not comprehensive, especially in the later stages which I am not
familiar with; the important observation is the number of _transformations_ and
how __all__ of them must preserve behavior.

Each representation in the list above is "intermediate" in the sense that it is
neither the input program nor the final executable, but we usually define
Intermediate Representation to mean the IR generated in Step 4, "optimized"
(_transformed_) in Step 5, and lowered in Step 6.

## Different Languages, Same IR

Steps 1-5 are specific to the source language of the input program, whereas all
other steps are agnostic to the language; the IR is the first such agnostic
representation. Using this scheme, one can conceive different compilers that
all share the "middle" and "back"-ends of the sequence above:

![](more_frontends.svg){style="display:block; margin: auto;"}

As a side-effect of a language-agnostic IR, the behavior required by the input
language specification must be captured using generic mechanisms provided by
the IR; the language specification can't exist in that level, otherwise it
would no longer be language-agnostic. Because of this, one can inspect IR and
understand how language concepts are mapped to simpler and lower level code
abstractions.

# Goals of the IR

In the compilation pipeline, the IR sits between representations specific to
source languages and representations specific to the target machine:

![](ir_position.svg){style="display:block; margin: auto;"}

We can derive some of its design goals from where the IR is positioned in the
compilation pipeline. It must be:

* Able to represent concepts from any high level language,
* Amenable to analysis required by "optimizing" transformations,
* Able to represent concepts required by target specific representations.

![](ir_position_and_goals.svg){style="display:block; margin: auto;"}

LLVM's IR attempts to achieve these design goals by:

* Being a RISC-like language,
* Having a type system,
* Being highly configurable.

# Up Next

The [next post] in this series will dig into the core concepts of LLVM's IR!

[Values, Registers, Memory]: ../compilers/llvm_ir_p2
[next post]: ../llvm_ir_p2
