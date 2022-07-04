#include "global_ctor.h"
#include "shared_lib1_header.h"
#include "shared_lib2_header.h"
#include <iostream>

int main() {
  std::cout << "GlobalCtor::exported_ptr = " << GlobalCtor::exported_ptr
            << "\n";
  std::cout << "SharedLib1::exported_ptr = " << SharedLib1::exported_ptr
            << "\n";
  std::cout << "SharedLib2::exported_ptr = " << SharedLib2::exported_ptr
            << "\n";
  return 0;
}
