#include "global_ctor.h"
#include "shared_lib1_header.h"

void *SharedLib1::exported_ptr = GlobalCtor::exported_ptr;
