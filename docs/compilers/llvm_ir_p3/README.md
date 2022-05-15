---
title: LLVM's IR Structure and Global Symbols
date: 2022-03-20
---

(This is an early draft)

# Modules

One LLVM IR file (`.ll`) represents an LLVM IR Module, a top-level entity
encapsulating all other data structures in the IR. There are four such data
structures:

1. A structure describing the target architecture and platform.
2. Global Symbols:
   1. Global Variables
   2. Functions
4. Metadata: debug information, optimization hints, etc.

![](module_anatomy.svg){style="display:block; margin: auto;"}

We will focus on global symbols (variables and functions).

# Global Symbols

Global symbols are top-level `Value`s visible to the entire Module. Their names
always start with the `@` symbol, for example: `@x`, `@__foo` and `@main`.

Unlike registers, the name of a global symbol may have semantic meaning in the
program; in other words, global symbols have [linkage]. For example, a global
symbol may have `external` linkage, which means its name is visible to _other
Modules_. For such a symbol, it would be illegal to rename it: doing so could
invalidate code in other Modules.

Global symbols define memory regions allocated at compilation time. For this
reason, the `Value` of a global symbol has a pointer type.

For example, if we declare a global variable of type `i32` called `x`, the type
of the `Value` `@x` is `ptr`. To access the underlying integer, we must first
load from that address.

There are two kinds of global symbols: global variables and functions.

## Global Variables

As a global symbol, global variables have a name and linkage. Additionally,
they require a type and a _constant_ initial `Value`:

```llvm
@gv1 = external global float 1.0
```

In this example, we have a global symbol that:

* Has name `gv1`.
* Has external linkage (its name is visible to other Modules).
* Is a global variable.
* Contains a `float` `Value`.
* Is initialized with `Value` `float 1.0`.

External linkage is the default and can be omitted:

```llvm
@gv1 = global float 1.0
```

From here on, we will be omitting linkage for all global symbols.

Recall that, because all global symbols define a memory region, the `Value`
`@gv1` has a pointer type. As such, to read or write the `Value` in that memory
location we use loads and stores:

```llvm
%1 = load float, ptr @gv1
store float 2.0, ptr @gv1
```

There is one other important variation of global variables, we may replace
`global` with the `constant` keyword:

```llvm
@gv1 = constant float 1.0
```

This means that stores to this memory region are illegal and the optimizer can
assume they do not exist.

## Functions

A function _declaration_ in LLVM IR has the following syntax:

```llvm
declare i64 @foo(i64, ptr)
```

* A keyword `declare`,
* The return type (`i64`),
* The symbol name (`foo`),
* The list of parameter types (`i64`, `ptr`).

A function _definition_ is very similar to the declaration, but we use a
different keyword (`define`), provide names to the parameters and include the
body of the function:

```llvm
define i64 @foo(i64 %val, ptr %myptr) {
  %temp = load i64, ptr %myptr
  %mul = mul i64 %val, %temp
  ret %mul
}
```

This function loads an `i64` `Value` from `%ptr`, multiplies it with `%val` and
returns the result (`ret` instruction).

What is the type of `@foo`? Like all global symbols, it defines a memory region
and therefore its type is a pointer type (`ptr`).

# Further Reading

It is a useful exercise to read the LLVM documentation on some of the topics
discussed:

* The existing [linkage types]. There are a lot of subtle variations between
the two extremes of: "this symbol is only visible in this Module" and "this
symbol is visible in all Modules"
* The full specification for [functions] and [global variables]. Don't try to
understand everything there, but note how many details can be added to those
global symbols.

# Up Next

Now that we understand the core concepts in LLVM, discussed global symbols and
explored some basic instructions, we are ready to dig into the biggest piece of
the puzzle: function bodies.

[linkage]: https://en.wikipedia.org/wiki/Linkage_(software)
[linkage types]: https://llvm.org/docs/LangRef.html#linkage-types
[functions]: https://llvm.org/docs/LangRef.html#functions
[global variables]: https://llvm.org/docs/LangRef.html#global-variables
