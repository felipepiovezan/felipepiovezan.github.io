---
title: Build System Basics - CMake Concepts
date: 2020-02-22
---

There are _many_ good CMake tutorials out there, but their aim is usually to
teach through practical examples. I want to take a more fundamental approach
here, focusing on the concepts rather than on their implementation; this will
make other tutorials, talks and documentation easier to understand.

## CMake is Not a Build System.

Strictly speaking, CMake is a __build system generator__. In other words, CMake
reads the _project description_ and, instead of building the project, it
generates _build description_ files for a [build system of your choice]. In
other words, CMake by itself is not enough to build a project.

![](system_gen.svg)

CMake places the build system description file (Makefile, build.ninja, etc)
inside the _build directory_. This makes sense if one views the build system as
a property of a particular build, not as a property of the project itself. For
example, a build on Windows may use a different build system than a build on
Mac.

Consider, for instance, a project based exclusively on the Ninja build system.
A Windows developer who wants to work on this project and use Visual Studio
would need some kind of Visual Studio / Ninja integration. The same applies for
the Mac/Xcode combination. Alternatively, the project can use CMake and
generate native Visual Studio / Xcode build descriptions.

## The Canonical CMake Invocation

To start a CMake-based build, gather the following information:

1. The source directory path, `$SOURCE_DIRECTORY`.
2. The build directory path, `$BUILD_DIRECTORY`.
3. The desired build system, `$BUILD_SYSTEM`. (`Ninja`, `Unix Makefiles`, etc)

That's all the information CMake needs to get started:

```bash
cmake  [-G $BUILD_SYSTEM] -S $SOURCE_DIRECTORY -B $BUILD_DIRECTORY
```

CMake generates the required files inside the build directory. To build, either
run the build system specific command inside the build directory (`make`,
`ninja`, etc) or let CMake abstract this in a system-agnostic way:

```bash
cmake --build $BUILD_DIRECTORY
```

## `CMakeLists.txt` Files

A CMake-based project will contain many `CMakeLists.txt` files throughout its
directory hierarchy. These files contain a description of each module
(_target_) in the project and their relationship (_properties_); it is the
programmer's goal to express those ideas as cleanly as possible using the
_CMake language_.

## The CMake Language

The CMake language is just a programming language, it has functions, loops,
conditionals, etc.  It also has its quirks and oddities. Like any language, it
is merely a tool to express intent, and getting the basics right is crucial to
writing expressive code.

It's impossible to fully describe the language in a blog, but there is one
concept that is key to understanding the language.

### Strings, String Everywhere!

In the CMake language, almost everything is a string. The contents of a
variable are a string, the variable name itself is a string.

Here's how one would write an assignment command:

```CMake
set(my_var hello)
```

The mental model I use when thinking about the CMake language is that
"assignment to a variable creates a map from a string to another". In other
words:

```c++
map["my_var"] = "hello";
```

Dereferencing a variable is done with the `${}` operator:

```CMake
${my_var}
```

We can think of it simply querying the map:

```c++
map["my_var"]
```

Have a look at these examples:

```CMake
set(hello_str hello)                 # map[“hello_str”] = “hello”
set(world_str world)                 # map[“world_str”] = “world”
set(helloworld “Hello world!”)       # map[“helloworld”] = “Hello world!”
${hello_str}                         # Queries map[“hello_str”] finds “hello”
${${hello_str}}                      # Queries map[“hello”]... empty!
${${hello_str}${world_str}}          # Queries map[“helloworld”] finds “Hello world!”
```

### A Word on Whitespaces

Whitespaces separating two strings cause those strings to be interpreted as a
list, internally represented as a semicolon-separated concatenation of the
strings.

```CMake
set(my_var hello world)              # map[“my_var”] = “hello;world”
set(my_var hello;world)              # same as above.
set(my_var “hello world”)            # map[“my_var”] = “hello world”
```

## Targets

In CMake, a `target` is anything one wants to build. It is typically an
executable or a library, but it's possible to define any custom set of
commands.

```CMake
add_executable(
  executable1
    executable1_source.cpp
)

add_library(
  library1
    library1_source.cpp
)
```

## Properties

Properties provide information on `targets`. There are three flavors of properties:

* Private: information about __how__ the target does something. Other targets
need not be aware of private properties.
* Interface: information about __what__ the target does. Other targets need to
know about interfaces.
* Public: information that is both private and on the interface.

Let's look at one such property: include directories. This specifies paths the
compiler should use when looking for header files.

```CMake
target_include_directories(
  library1
    PRIVATE /my/private/path
    PUBLIC /my/public/path
)
```

Note the two distinct paths specified above. The `PRIVATE` path will not be
visible to any other targets using `library1`, whereas the `PUBLIC` path will be
visible both when compiling `library1` and any targets that link to it.
To understand this, let's look at the link libraries property:

```CMake
target_link_libraries(
  executable1
    PRIVATE library1
)
```

Here, `executable1` needs to be linked against `library1` and it depends
privately on everything that is part of `library1`'s interface. In particular,
the `/my/public/path` include path will also be visible to `executable1`.


## Visual Representation

Targets are the building blocks of a CMake project description and properties
tell CMake how to build targets. Linking targets cause public/interface
properties to flow from one target to another transitively and create
dependencies that define an order in which actions must happen at build time.

The dependency between targets and the flow of properties can be visualized by
passing ``--graphviz=<some_prefix>`` to the CMake command call, producing a
graph file:

![](dot_graph.svg){style="display:block; margin: auto;"}

If you can produce such a graph for your project - and it looks manageable in
complexity - you have a clear understanding of the project as a whole.


## Conclusion

At the end of [Part 1], we listed some symptoms of problematic build systems.
Let's see how a CMake-based project handles those issues.

> How easy is it to spawn a second build from the same source directory?

Create a new empty build directory and rerun the CMake configure command.

> How easy is it to identify files that must be under version control?

A file must be under version control if and only if it is inside the source
directory.

> Can you identify the compiler that is used in a given build? How easily can
that be changed?

The CMake command prints out the C and C++ compilers detected as part of the
configure command, and CMake comes with tools that allow inspection of the
build configuration, like `ccmake` or `cmake-gui`.

Different compilers may be used by passing extra flags to the configure
command: `-DCMAKE_CXX_COMPILER=path/to/c++/compiler` and
`-DCMAKE_C_COMPILER=path/to/c/compiler`.

> Can you build a single component of the project and its dependencies,
without building anything unnecessary?

Yes, run `cmake --build $BUILD_DIRECTORY --target <target_name>`.

> If a source file is changed, how easy is it to incrementally build the
affected components?

Rerun `cmake --build $BUILD_DIRECTORY`.

-----

Here I stop, having gone from the basics of building in [Part 1] to the basics
of CMake, with the hopes that you'll now understand other tutorials faster than
I did.

-----

## Further reading

* The [CMake documentation] is really good and comprehensive, I use it a lot
and it rarely disappoints. For example, read the [normal libraries] section of
the `add_library` documentation, a command we used in this tutorial. Reading
the docs is general advice when using any software.

* The "official" [CMake tutorial] covers a __lot__ of material. As such, it is
a good way to survey everything that can be done with CMake, without going into
too much detail.

* Craig Scott's [Professional CMake] book is great both as a learning tool
and as a reference. Whenever I find myself thinking _How do I do X again?_ or
_I'm sure there is a better way to this_, this book comes to the rescue.  It
was also my primary way to learn about CMake.

* Daniel Pfeifer's [Effective CMake] talk is a good introduction to the CMake
language and to good CMake practices. The second half of the talk is pretty
heavy on details though.

[Part 1]: ../build_systems1
[build system of your choice]: https://cmake.org/cmake/help/latest/manual/cmake-generators.7.html#cmake-generators
[CMake documentation]: https://cmake.org/cmake/help/v3.17/
[CMake tutorial]: https://cmake.org/cmake/help/latest/guide/tutorial/index.html
[Professional CMake]: https://crascit.com/professional-cmake/
[normal libraries]: https://cmake.org/cmake/help/latest/command/add_library.html#normal-libraries
[Effective CMake]: https://www.youtube.com/watch?v=bsXLMQ6WgIk
