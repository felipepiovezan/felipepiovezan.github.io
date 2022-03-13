---
title: Build system basics
slug: ../build_system_basics
date: 2020-01-27
---

Having a build system in a project is something many developers take for
granted, never paying attention to the work involved in maintaining the build's
quality and health. Can we identify whether a build system is good or not?

During my first years as a software engineer, I would feel like there was
something wrong with the way we built our project; but being my first job and
being mostly ignorant on build systems, I assumed we did things right. Until I
decided to study a bit on the topic - oh was I wrong.

This post is meant as a high level introduction to building C++ software.

## To build

On a high level, building a project is a two-step process: first, a set of
build files is converted into build artifacts. Then, a subset of those build
artifacts is moved into some installation directory.

![example 1](to_build.svg)

The first step is where the compiler and linker are involved, doing most of the
work. But a lot more can happen in this stage, like running scripts to generate
code, creating test inputs, generating documentation, etc.

In the second step, some build artifacts are moved into an installation
directory, making the project available to anyone in the system. It's possible
for developers to skip the installation step when developing, because
developers can execute all components of the project using the build
artifacts alone.

In the steps above, we have identified three important directories:

1. Source directory, where the source files are located.
2. Build directory, where the build artifacts are placed.
3. Install directory, where the installed program is placed.

![example 2](locations.svg)

## A wrong way to build

In some build methods, the source directory and the build directory are the
same, this is known as an __in-source build__:

![example 3](in_source.svg)

In other words, source code, scripts and test inputs are all in the same
directory as object files, script-generated code, compiled libraries and
executables, automatically generated documentation, etc.

Let's pause here for a moment and consider the implications of this build
method:

1. The version control system has to distinguish between files that should be
committed and files that are build artifacts.
2. Because the build process places files in the same directory where source
code is located, it needs special care not to overwrite or delete important
files[^1].
3. Cleaning a build (deleting all build artifacts) becomes a non-trivial task.
4. Sharing the same source files for independent builds becomes non-trivial
(more on this later).

Note that it's possible to overcome each of those problems at the cost of added
complexity. However, when striving for simplicity, we must ask if there are
simpler ways of achieving the goals above; the answer is yes.

## A cleaner approach

The build method in which the source and build directories are distinct is
called an __out-of-source__ build. The complete separation between source files
and build artifacts makes for a simpler and more practical organization of the
project:

1. A file is under version control if and only if it is inside the source
directory.
2. The build process only ever outputs files to the build directory, therefore
there is no risk of changing the source material.
3. Cleaning a build is simple: `rm -r <build_directory>`.
4. Because the source directory is not aware of the build directory, the same
source can _easily_ be used for multiple builds.

This last point is so important that it deserves elaborating. Let's imagine a
scenario where we have to develop an application on both Windows and Linux.  We
can place the source directory in network storage, and maintain build
directories in the local (faster) storage of each system. One build does not
affect the other by design.

Suppose that building on debug mode is expensive, so we don't want to do it all
the time. When we want debug mode because of a faulty change, we simply create
another build directory, configure it to debug, and build. There is no need to
clone the repository and to apply the faulty changes on top of the new copy.

Suppose that we want to compare the performance of an application when built
with two different compilers. We simply keep two distinct build directories,
one for each compiler.

![example 4](out_of_source.svg)

## Systematically building

We've talked about what it means to build software, but this article started
talking about build __systems__. What is a build system?

A build system is a description of how to build a particular software, combined
with a program that reads this description and acts upon it. Here's the world's
simplest build system:

```bash
#build.sh

gcc main.cpp -o main
cp main /usr/local/bin/main
```

In this example, our build system is a simple shell script that, when invoked,
compiles `main.cpp` and installs the generated executable `main` into
`/usr/local/bin`[^2]. It is an example of an in-source build. A better example
would be:

```bash
#build.sh

mkdir $BUILD_DIRECTORY
gcc main.cpp -o $BUILD_DIRECTORY/main
cp $BUILD_DIRECTORY/main $INSTALL_DIRECTORY/bin/main
```

The new script can be invoked multiple times, with different values for
`BUILD_DIRECTORY` and `INSTALL_DIRECTORY`. This is an example of an
out-of-source build.

There are many build systems out there, but they all follow this pattern: a
file that describes the build process using some language is placed in the
source directory, and a program is invoked to read that description and build
the project.

Some examples: `make` uses `Makefile`, `ninja` uses `build.ninja`, `Xcode` uses
`.pbxproj`, `MSVC` uses `vscxxproj`, etc.

![example 4](different_systems.svg)

It is the build system's job to:

* Figure out how to run code generation scripts.
* Find header files.
* Find external dependencies.
* Move files around.
* Determine the order in which build steps must happen.
* Determine which steps can be done in parallel.
* Determine where to find tools like the compiler.
* Understand how the compiler is invoked.

Depending on the expressiveness of the build system's language, the programmer
might have to perform a lot of "hand-holding" for some or all of the steps
above. In other words, the build description file might allow for higher level
abstractions and be easy to reason about, or it might require low level
commands to be spelled out (as the shell example showed).

Each build system has its own view on how to achieve those features. Is it
possible to get all of them and still be operating system agnostic? For the C++
case, that's what CMake aims to do and we will explore how it does that in a
future article.

## Conclusion

Given all that we've discussed, it's possible to identify symptoms of a bad
build system:

1. How easy is it to spawn a second build from the same source directory?
2. How easy is it to identify files that must be under version control?
3. Can you identify the compiler that is used in a given build? How easily can
that be changed?
4. Can you build a single component of the project and its dependencies,
without building anything unnecessary?
5. If a source file is changed, how easy is it to incrementally build the
affected components?

A good build system will also allow you to reason about individual components
of your project and how they relate to each other, so that you can easily
identify circular dependencies, or add new components with the correct
dependencies.

Furthermore, a good build system is capable of inferring a lot of information
given a description of the project. For instance, it should be able to find
system libraries, understand how to invoke the compiler and automatically infer
parallelism between build steps.

From the number of times I wrote _easily_ in the text above, you can tell how
much I value simplicity. When things are complicated, few developers know how
to maintain a healthy build, and the build quality slowly deteriorates.

Once enough components are added, the project reaches a point where no one
truly understands the dependencies between components, how to fix build breaks,
or how to reduce the number of components built as result of dependencies. The
consequence is a generalized loss in productivity as developers have to context
switch while wainting for the subpar build.

Thanks for reading! Next time we'll talk about how CMake accomplishes most of
the goals we talked about. In the meantime, try to identify how good the build
system of your project is.

edit: [Part 2] is out!

[^1]: If one has used Perforce as a version control system, one could argue
that Perforce is so great it prevents the aforementioned issue from happening.
Please don't use an objectively wrong build methodology as an excuse to use an
objectively bad (and expensive) version control system.

[^2]: Note that `/usr/local/bin` is probably a write-protected directory. As
such, sudo permissions might be needed to run this script.

[Part 2]: http://felipepiovezan.gitlab.io/blog/build_system_p2/
