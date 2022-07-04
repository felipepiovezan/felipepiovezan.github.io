#include "global_ctor.h"
#include "shared_lib2_header.h"

void *SharedLib2::exported_ptr = GlobalCtor::exported_ptr;
