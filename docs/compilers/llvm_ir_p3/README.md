---
title: LLVM's IR Structure
date: 2022-03-20
---

# The Anatomy of an LLVM IR Module

One LLVM IR file (`.ll`) represents an LLVM IR Module, a top-level entity
encapsulating all other data structures in the IR. There are four such data
structures:

1. A structure describing the target architecture and platform.
2. Global Variables.
3. Functions.
4. Metadata: debug information, optimization hints, etc.

![](module_anatomy.svg){style="display:block; margin: auto;"}

