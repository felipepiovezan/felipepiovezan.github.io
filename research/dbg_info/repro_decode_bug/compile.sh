set -xeo pipefail

LLVM_PATH=/extra_ssd/workspace/llvm-project/build14/bin/

$LLVM_PATH/clang++ -g -gdwarf-4 -Og test.cpp -o executable_O1

$LLVM_PATH/lldb executable_O1 --batch \
    -o "b test.cpp:5" \
    -o "run" \
    -o "image lookup -va \$pc"

# observe the line:
# Variable: id = {0x00000148}, name = "a", type = "int",
#           location = <decoding error> 01 00 00 00, decl = test.cpp:5
