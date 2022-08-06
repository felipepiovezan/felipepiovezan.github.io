set -eou pipefail
set -v

clang++ -Og -g test.cpp -o Og.out
clang++ -Og -g test.cpp -c -emit-llvm -S -o Og.ll
clang++ -Og -g test.cpp -c -emit-llvm -S -o /dev/null -mllvm --print-after-all &> afterallOg.ll

clang++ -O0 -g test.cpp -o O0.out
clang++ -O0 -g test.cpp -c -emit-llvm -S -o O0.ll


LLVM_PATH=/extra_ssd/workspace/llvm-project/build14/bin/
$LLVM_PATH/lldb Og.out --batch \
    -o "b main" \
    -o "run" \
    -o "print array"

# Notice the state that has never happened before!
# (lldb) print array
# (int[3]) $0 = ([0] = 0, [1] = 42, [2] = 0)

