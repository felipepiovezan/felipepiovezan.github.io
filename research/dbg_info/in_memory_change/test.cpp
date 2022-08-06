
void update_ptr(int *ptr) {
  *ptr = 42;
}

int main() {
  int array[3] = {1,2,3};
  array[1] = 10;
  update_ptr(&array[1]);
}
