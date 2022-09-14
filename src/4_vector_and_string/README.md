# vector 与 string

## vector
向量是 Move 唯一的基本集合类型。`vector<T>` 是类型为 `T` 的元素的同构集合，可以通过从**末端**推入/弹出值来增加和删减向量中的元素。
其中 `T` 可以是任意的类型，例如：`vector<u64>`， `vector<address>`，`vector<0x42::MyModule::MyResource>`, 以及 `vector<vector<u8>>` 都是合法的。

任何类型的向量都可以通过字面值创建：
```rust
let v = vector[1, 2, 3];
```
当然也可以创建一个空向量：
```rust
let v = vector[];
```
但是当我们单独执行上面这行代码时，编译器会报错：
```shell
error[E04010]: cannot infer type
  ┌─ ./scripts/debug_script.move:8:9
  │
8 │         vector[];    
  │         ^^^^^^^^ Could not infer this type. Try adding an annotation

```
编译器告诉我们，无非推断向量的类型，尝试添加标注。这是因为向量的类型是从元素的类型或从向量的使用上推断出来的。我们声明了一个空向量，也没有使用它，编译器自然无法判断它的类型。
只要我们后续使用了这个向量，编译器就可以进行推断，例如：
```rust
let v = vector[]; 
let another_v =  vector[1, 2, 3];
assert!(v != another_v, 0);
```
我们知道整型的默认类型是 `u64` ，所以 `another_v` 是一个 `u64` 的向量，当 `v` 和 `another_v` 比较时，编译器就会推断出 `v` 也是一个 `u64` 的向量。

或者我们可以显式的指明向量的类型：
```rust
vector<u8>[];
vector<u64>[];
vector<u128>[];
vector<address>[];
vector<bool>[];
vector<M::Coin>[];
let _v: vector<u8> = vector[];
```