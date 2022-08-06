class MyClass {
  int member_var;

public:
  MyClass(int a) : member_var{a} {}
};

MyClass* foo() {
  auto myclass = new MyClass(1);
  return myclass;
}

MyClass *mygv = nullptr;

int main() {
  mygv = foo();
}
