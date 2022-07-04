#include "global_ctor.h"
#include <cassert>
#include <cstdio>

/// Have a look at the IR for this file:
///   clang++ -g0 -c -S -emit-llvm -O3 -fno-threadsafe-statics -std=c++20 -o ir.ll global_ctor.cpp

constinit int counter = 0;

struct GlobalCtorClass {

  GlobalCtorClass() {
    /// iostream has static ctors, using printf to simplify IR.
    std::printf("%d\n", counter);

    assert(counter == 0);
    counter++;
  }
};

auto global_ctor_object = GlobalCtorClass{};
void *GlobalCtor::exported_ptr = &global_ctor_object;
