# 向量与字符串

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

## vector\<u8\> 
Move 中向量的一个常见用例是表示“字节数组”，用 `vector<u8>` 表示。这些值通常用于加密目的，例如公钥或哈希结果。
这些值非常常见，以至于提供了特定的语法使其更具可读性，而不是必须使用 `vector[]`，其中每个单独的 `u8` 值都以数字形式指定。

目前支持两种类型的 `vector<u8>` 字面量，**字节字符串**（Byte Strings）和**十六进制字符串**（Hex Sstrings）。

### Byte Strings
字节字符串是带引号的字符串字面值，以 `b` 为前缀，例如：
```rust
let s = b"Hello, world!";
debug::print(&s);
```
可以看到打印的结果是一串整型：
```shell
[debug] (&) [72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33]
```
字节字符串是允许转义序列的 ASCII 编码字符串。目前，支持的转义序列如下：
| 转义序列 |                   描述                    |
| :------: | :---------------------------------------: |
|    \n    |                   换行                    |
|    \r    |                   回车                    |
|    \t    |                  制表符                   |
|    \\\\    |                  反斜杠                   |
|    \0    |                   Null                    |
|    \\"    |                   引号                    |
|   \xHH   | 十六进制进制转义，插入十六进制字节序列 HH |

### Hex Sstrings
十六进制字符串是以 `x` 为前缀的带引号的字符串字面值，例如：
```rust
let s = x"48656C6C6F210A";
debug::print(&s);
```
可以看到打印的结果是：
```shell
[debug] (&) [72, 101, 108, 108, 111, 33, 10]
```
每个字节对，范围从 00 到 FF 都被解析为十六进制编码的 `u8` 值。
所以每个字节对对应于结果 `vector<u8>` 中的单个元素。

**字节字符串**和**十六进制字符串**本质上都是 `vector<u8>`，因此它们的类型实际上是一样的：
```rust
assert!(b"" == vector<u8>[], 0);
// assert!(b"" == vector<u64>[], 0);    // Error: Incompatible arguments to '=='
assert!(b"" == x"", 1);
assert!(b"Hello!\n" == x"48656C6C6F210A", 2);
assert!(b"\x48\x65\x6C\x6C\x6F\x21\x0A" == x"48656C6C6F210A", 3);
assert!(
    b"\"Hello\tworld!\"\n \r \\Null=\0" ==
        x"2248656C6C6F09776F726C6421220A200D205C4E756C6C3D00",
    4
);
```

## 标准库 std::vector
Move 标准库中的 `std::vector` 模块提供了一些用于操作 `vector` 的函数

- `empty<Element>(): vector<Element>;`   
  创建一个类型为 `Element` 的空向量
```rust
let _empty_v = vector::empty<u128>();
```
- `singleton<Element>(e: Element): vector<Element>`   
  返回一个包含元素 `e` 的长度为1的向量
```rust
let v = vector::singleton<u64>(123u64);
```
- `length<Element>(v: &vector<Element>): u64`  
  返回向量的长度
```rust
assert!(vector::length(&v) == 1, 0);
```
这时候向量 `v` 中只有一个元素 `123u64`，所以长度是 `1`。
- `push_back<Element>(v: &mut vector<Element>, e: Element)`  
  将元素 `e` 添加到向量 `v` 的末尾
```rust
vector::push_back(&mut v, 456u64);
vector::push_back(&mut v, 789u64);
assert!(vector::length(&v) == 3, 0);
```
这里需要注意，因为需要对向量 `v` 的内容进行修改，所以需要传入 `v` 的**可变引用**。
- `pop_back<Element>(v: &mut vector<Element>): Element`   
  从向量 `v` 中移除最后一个元素，并返回
```rust
assert!(vector::pop_back(&mut v) == 789u64, 0);
assert!(vector::length(&v) == 2, 0);
// vector::pop_back(&mut _empty_v); // Abort!
```
当我们对一个空向量执行这个函数时，程序回异常退出。
- `borrow<Element>(v: &vector<Element>, i: u64): &Element`   
  获得向量在索引 `i` 处的不可变引用
```rust
assert!(*vector::borrow(&v, 0) == 123u64, 0);
assert!(vector::borrow(&v, 1) == &456u64, 0);
// vector::borrow(&v, 2); // Abort!
```
函数返回的是 `&Element`，使用的时候需要注意类型的匹配。引用一个超出索引范围的元素时，程序会异常退出。
- `borrow_mut<Element>(v: &mut vector<Element>, i: u64): &mut Element`  
  获得向量在索引 `i` 处的可变引用
```rust
assert!(v == vector[123, 456], 0);
*vector::borrow_mut(&mut v, 0) = 321u64;
assert!(v == vector[321, 456], 0);
```
我们可以通过这个函数来修改向量内部的元素，注意这里需要用到解引用 `*`。
- `destroy_empty<Element>(v: vector<Element>)`    
  销毁一个空的向量
```rust
vector::destroy_empty(_empty_v);
```
- `swap<Element>(v: &mut vector<Element>, i: u64, j: u64)`   
  交换向量 `i` 和 `j` 索引处的元素
```rust
assert!(v == vector[321, 456], 0);
vector::swap(&mut v, 0, 1);
assert!(v == vector[456, 321], 0);
// vector::swap(&mut v, 0, 2);  // Abort!
```
当 `i` 或者 `j` 超出向量索引范围时，程序会异常退出。
- `reverse<Element>(v: &mut vector<Element>)`
  反转向量中元素的顺序
```rust
assert!(v == vector[456, 321], 0);
vector::reverse(&mut v);
assert!(v == vector[321, 456], 0);
```
- `append<Element>(lhs: &mut vector<Element>, other: vector<Element>)`
  把 `other` 向量中的元素全部添加到 `lhs` 的末尾
```rust
assert!(v == vector[321, 456], 0);
vector::append(&mut v, vector[1001, 1002, 1003]);
assert!(v == vector[321, 456, 1001, 1002, 1003], 0);
```
- `contains<Element>(v: &vector<Element>, e: &Element): bool`  
  判断 `e` 是否在向量中，存在返回 `true` ，否则返回 `false`
```rust
assert!(vector::contains(&v, &321), 0);
```
注意这里的 `e` 是引用类型 `&Element` 。
- `index_of<Element>(v: &vector<Element>, e: &Element): (bool, u64)`   
  如果元素 `e` 位于向量的索引 `i` 处，返回 `(true, i)`，否则返回 `false, 0`
```rust
let (if_exist, index) = vector::index_of(&v, &456);
assert!(if_exist == true, 0);
assert!(index == 1 , 0);
let (if_exist, index) = vector::index_of(&v, &999);
assert!(if_exist == false, 0);
assert!(index == 0 , 0);
```
- `remove<Element>(v: &mut vector<Element>, i: u64): Element`.
  移除索引 `i` 处的元素，并返回该元素，后续的元素按照原来顺序往前移
```rust
assert!(v == vector[321, 456, 1001, 1002, 1003], 0);
assert!(vector::remove(&mut v, 2) == 1001, 0);
assert!(v == vector[321, 456, 1002, 1003], 0);
```
- `swap_remove<Element>(v: &mut vector<Element>, i: u64): Element`   
  首先将索引 `i` 处的元素与最后的元素交换，然后将最后的元素弹出。上一个函数的复杂度是 O(n)，这个函数的复杂度是 O(1)，但是不能保持原有的顺序
```rust
assert!(v == vector[321, 456, 1002, 1003], 0);
assert!(vector::swap_remove(&mut v, 1) == 456, 0);
assert!(v == vector[321, 1003, 1002], 0);
```

## 销毁和复制 vector
`vector<T>` 的某些行为取决于元素类型 `T` 的能力（ability），
例如：如果向量中包含不具有 `drop` 能力的元素，就不能隐式的丢弃，必须用 `vector::destroy_empty` 显式销毁。
但前面讲到 `vector::destroy_empty` 只能销毁空向量，那对于非空的向量，我们应该如何销毁呢？
我们尝试在 module 中编写一个函数来销毁任意向量：
```rust
fun destroy_any_vector<T>(_vec: vector<T>) { }
```
我们想把向量传入函数中，然后隐式的丢弃它，但编译器会报错：
```shell
error[E06001]: unused value without 'drop'
   ┌─ ./sources/debug_module.move:12:47
   │  
12 │       fun destroy_any_vector<T>(vec: vector<T>) {
   │                                 ---  ---------
   │                                 │    │      │
   │                                 │    │      The type 'vector<T>' can have the ability 'drop' but the type argument 'T' does not have the required ability 'drop'
   │                                 │    The type 'vector<T>' does not have the ability 'drop'
   │                                 The parameter 'vec' still contains a value. The value does not have the 'drop' ability and must be consumed before the function returns
   │ ╭───────────────────────────────────────────────^
13 │ │             // vector::destroy_empty(vec) 
14 │ │     }
   │ ╰─────^ Invalid return
```
编译器告诉我们，`T` 没有 `drop` 的能力，因此不能这样丢弃。但如果我们给 `T` 加上一个限制，要求它具备 `drop` 的能力：
```rust
fun destroy_any_vector<T: drop>(_vec: vector<T>) { }
```
这样子我们就可以销毁具有 `drop` 能力的 `T` 组成向量了。

同样，除非元素类型具有 `copy` 能力，否则无法复制向量。换句话说，当且仅当 `T` 具有 `copy` 能力时，`vector<T>` 才具有 `copy` 能力。
```rust
let x = vector::singleton<u64>(10);
let y = copy x;
assert!(x == y, 0);

// without copy ability
// let p = vector::singleton<M::Coin>( M::create_coin(1) );
// let q = copy p;
// assert!(p == q, 0);
```
`u64` 因为具有 `copy` 能力，因此可以复制，但我们在实现 `M::Coin` 时没有赋予它 `copy` 的能力，当我们复制时，编译器就会报错。

ps：`let y = copy x;` 这行代码中，如果不加 `copy` 关键词也可以编译成功。
这是因为在 rust 中 place expressions 在被求值时，如果该类型实现了 `Copy` trait，那么值就会被copy。
如果该类型实现了 `Sized` trait，则会被move。[【参考资料】](https://doc.rust-lang.org/reference/expressions.html#place-expressions-and-value-expressions)

## 标准库 std::string
前面讲到，字节字符串 和 十六进制字符串 本质上是 `vector<u8>` ，Move 标准库中也提供了 `std::string` 模块。并提供了 `String` 类型：
```rust
/// A `String` holds a sequence of bytes which is guaranteed to be in utf8 format.
struct String has copy, drop, store {
    bytes: vector<u8>,
}
```
`String` 就是对 `vector<u8>` 的封装，模块内部也提供了一些操作函数：
- `utf8(bytes: vector<u8>): String`       
  从 `vector<u8>` 构建一个 `String` ，如果字节不能表示一个合法的utf8，则程序终止。
```rust
let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
debug::print(&s);
```
输出结果是：
```shell
[debug] (&) { [72, 101, 108, 108, 111, 33, 10] }
```
- `try_utf8(bytes: vector<u8>): Option<String>`     
  这个函数和上面类似，但输出是 `Option`，成功的话 `Option` 内部的向量会包含一个 `String`, 否则就只有一个空向量:
```rust
let valid_s = string::try_utf8(vector[72, 101, 108, 108, 111, 33, 10]);
let invalid_s = string::try_utf8(vector[72, 101, 108, 108, 111, 33, 255]);
debug::print(&valid_s);
debug::print(&invalid_s);
```
输出结果为：
```shell
[debug] (&) { [{ [72, 101, 108, 108, 111, 33, 10] }] }
[debug] (&) { [] }
```
- `bytes(s: &String): &vector<u8>`    
  返回对基础字节向量的引用:
```rust
assert!(*string::bytes(&s) == vector[72, 101, 108, 108, 111, 33, 10], 0);
```
- `is_empty(s: &String): bool`     
  检查字符串是否为空：
```rust
assert!(string::is_empty(&string::utf8(vector[])) == true, 0);
assert!(string::is_empty(&s) == false, 0);
```
- `length(s: &String): u64`    
  返回字符串的长度：
```rust
let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
assert!(string::length(&s) == 7, 0);
```
- `append(s: &mut String, r: String)`
  在 `s` 后面追加字符串 `r` ：
```rust
let s = string::utf8(vector[72, 101, 108]);
let r = string::utf8(vector[111, 33, 10]);
string::append(&mut s, r);
debug::print(&s);
```
可以看到输出结果是连个字符串的拼接：
```shell
[debug] (&) { [72, 101, 108, 111, 33, 10] }
```
- `append_utf8(s: &mut String, bytes: vector<u8>)`.   
  另一种方法是，直接在字符串后面追加合法的 utf8 字节向量 `vector<u8>`：
```rust
let s = string::utf8(vector[72, 101, 108]);
let r = vector[111, 33, 10];
string::append_utf8(&mut s, r);
debug::print(&s);
```
输出结果和前面一致：
```shell
[debug] (&) { [72, 101, 108, 111, 33, 10] }
```
- `insert(s: &mut String, at: u64, o: String)`   
  在 `s` 中给定的字节索引位置处插入新字符串 `o`
```rust
let s = string::utf8(vector[72, 101, 108]);
let o = string::utf8(vector[111, 33, 10]);
string::insert(&mut s, 2, o);
debug::print(&s);
```
可以看到新的字符串从第二位开始被插入：
```shell
[debug] (&) { [72, 101, 111, 33, 10, 108] }
```
- `sub_string(s: &String, i: u64, j: u64): String`
  根据给定的索引 `i` 和 `j` 返回子字符串：
```rust
let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
let sub_s = string::sub_string(&s, 2, 5);
debug::print(&sub_s);
```
从结果可以看到，子字符串包括开始的索引 `i` 但不包括结束的索引 `j` ：
```shell
[debug] (&) { [108, 108, 111] }
```
- `index_of(s: &String, r: &String): u64 `
  查询 `r` 字符串在 `s` 中第一次出现的索引值，若果 `r` 不是 `s` 的子字符串，则返回 `s` 的长度：
```rust
let s = string::utf8(vector[72, 101, 108, 108, 111, 33, 10]);
let sub_s = string::utf8(vector[108, 108, 111]);
let another_s = string::utf8(vector[108, 108, 112]);
assert!(string::index_of(&s, &sub_s) == 2, 0);
assert!(string::index_of(&s, &another_s) == string::length(&s), 0);
```   
  