# Move 基础类型

## 概要

本节课我们会介绍一下 Move 中的基本类型，以及演示一些如何声明和使用的代码。 Move 语言的础类型有整型（integers）、布尔型（bool）、地址（address)。Move没有浮点型（float）和字符串（string）。
我们这节课还会从地址类型延伸讲一下签署人（signer）。

我们首先通过新建一个 Move 项目，以便我们边讲边写:
```shell
move new primitive_types
cd primitive_types
```
在 `Move.toml` 中添加我们需要的依赖，这里主要是我们后面可能需要用到 `std::debug::print()` 来查看一些结果：
```toml
[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib", rev = "main" }
MoveNursery = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib/nursery", rev = "main" }
```
然后我们新建一个`scripts/` 目录，在这个目录下新建脚本文件 `my_script.move`，编写下面的代码，作为我们这节课程的“白板”：
```rust
script {
    use std::debug;

    fun main() {
        // Write the code here
    }
}
```
当我们想运行一下 main 函数时，可以在命令行中执行如下指令
```shell
move sandbox run scripts/my_script.move
```


## 整型 Integers

### 整型变量定义
Move中的整型目前只有3种，分别是`u8`、`u64`和`u128`，都是无符号整型。Move不支持有符号整型（signed integers），从目前来看未来也并没有引入有符号整型的计划，但后续应该会引入其他字节长度的无符号整型。

和其他语言的整型一样，占用字节长度决定了可以表示数值大小的范围：

| 类型 |      范围       |
| :--: | :-------------: |
|  u8  |   0 ~ $2^8-1$   |
| u64  | 0 ~ $2^{64}-1$  |
| u128 | 0 ~ $2^{128}-1$ |

我们可以有几种不同的方式来声明变量：  
1）先定义一个空的变量和类型，再设定它的值
```rust
let v: u8;
v = 10; 
```
2）在定义变量和类型的同时设定值
```rust
let v: u8 = 10;
```
3)我们也可以不用显式的写明变量的类型，编译器可以通过代码的上下文对变量的类型进行推断，当无法进行推断的时候，编译器默认会认为是`u64`类型
```rust
let v = 10;
```
4）也可以将类型添加在字面值的后面
```rust
let v = 10u64
```

但如果字面值对于变量指定的(或编译器推断的)类型来说太大了，比如下面我们把 256 赋给一个 `u8` 类型的变量，而 `u8` 类型的范围是 0-255：
```rust
let _v: u8 = 256;
```
编译器就会报错：
```shell
error[E04021]: invalid number after type inference
  ┌─ ./sources/my_script.move:4:21
  │
4 │        let _v: u8 = 256;
  │                --   ^^^
  │                │    │
  │                │    Invalid numerical literal
  │                │    Annotating the literal might help inference: '256u64'
  │                Expected a literal of type 'u8', but the value is too large.
```

### 整型变量运算

#### 数学运算
Move 中的整型都可以执行 `+`、`-`、`*`、`/`、`%` 运算，但符号两边变量的类型要求完全一致，也就是说 `u8` 只能和 `u8` 进行这些操作，`u8` 和 `u64` 就会报错，我们可以尝试一下：
```rust
let a: u8 = 10;
let b: u64 = 10;
a + b;
```
编译器会提示两个参数不相容
```shell
error[E04007]: incompatible types
  ┌─ ./sources/my_script.move:6:11
  │
4 │         let a: u8 = 10;
  │                -- Found: 'u8'. It is not compatible with the other type.
5 │         let b: u64 = 10;
  │                --- Found: 'u64'. It is not compatible with the other type.
6 │         a + b;
  │           ^ Incompatible arguments to '+'
```

#### 按位运算
整型还支持按位运算 按位与`&`、按位或`|`、按位亦或`^`
```rust
let a:u8 = 10;      // 1010
let b:u8 = 9;       // 1001
let r_and = a & b;  // 1000 -> 8
let r_or = a | b;   // 1011 -> 11
let r_xor = a ^ b;  // 0011 -> 3

debug::print(&r_and);
debug::print(&r_or);
debug::print(&r_xor);
```
同样，按位运算符两侧变量的类型也要求一致。

#### 位移运算
位移运算有两种，左位移 `<<` 和右位移 `>>`
```rust
let a: u8 = 10;     // 1010
let b = a << 1;     // 10100 -> 20
let c = a >> 2;     // 10 -> 2

debug::print(&b);
debug::print(&c);
```
这里不要求位移符号的两侧类型相等，但是右侧只能是 `u8` 类型，这也很容易理解， `u8` 最大是255，但目前 Move 最多只有 `u128`。

需要注意的是位移的位数不能**超过或等于**类型的字节数，也就是说 `u8`、`u64`、`u128` 分别最多只能位移 7、63、127 位：
```rust
let a: u8 = 10;     // 1010
let b = a << 8;     // Abort!
// Execution failed because of an arithmetic error (i.e., integer overflow/underflow, div/mod by zero, or invalid shift) in script at code offset 2
```

#### 对比运算
Move 中只有整型可以进行对比运算 `<`、`>`、`>=`、`<=`，同样，符号两边的变量类型要一致
```rust
let a: u8 = 10;
let b: u8 = 11;
a > b;  // false
b < b;  // true
a >= b; // false
a <= b ; // true
```

#### 等号与不等号
虽然 Move 中只有整型可以进行对比运算，但是 `==` 和 `!=` 并不是整型独占的。不过不论如何，符号两侧的类型还是要求一致。
```rust
let a: u8 = 10;
let b: u8 = 11;
a == b;  // false
a != b;  // true
```
关于相等性其他的一些知识点，会在学习 Move 语言后续的一些特性时讲到。

#### 类型映射
前面的运算基本要求符号两侧的变量类型一致，这样的限制可能会带来一些麻烦。因此 Move 提供了类型映射（casting），可以临时地转换类型，让符号两侧的变量可以执行运算。
只需要通过 `(e as T)` 的形式就可以实现类型的映射：
```rust
let a: u8 = 10;
let b: u64 = 2;
let c = a + (b as u8); 

debug::print(&c);
```
但需要注意的是，**只有整型之间**可以进行类型映射，并且变量的值不能超出目标类型的范围，例如 `256u64` 就无法转换成 `u8`, 程序会报错退出。

## 布尔型
布尔型（bool）的字面值只有 `true` 和 `false`。布尔类型可以执行 逻辑与`&&`、逻辑或`||`、逻辑非`!` 的运算。
```rust
let a = true;
let b = true;
let c = false;
let r1 = a || b;        // true
let r2 = a || b && c;   // true
let r3 = !a            // false

debug::print(&r1);
debug::print(&r2);
debug::print(&r3);
```
在一些语言中，整型在与布尔型运算时会自动进行转换，但在 Move 中是不可以的，尽管整型有类型映射，但类型映射只限制在不同字节长度的整型之间，因此 Move 的整型无法转化为布尔型。
也因此逻辑运算也只能在布尔型之间执行。

## 地址
地址（Address） 是 Move 中的一种类型，用于表示全局存储中的位置(或者称为帐户)，地址是一个 128bit 数值的标识符。

尽管地址是一个128位的整型，但 Move 并不允许通过整型来创建地址，也不允许地址进行任何的数学运算，也不允许改变地址，总的来说 Move 不允许地址发生动态的变化。

你可以在运行时通过地址的值来访问对应地址上的资源（Resources，这部分后面的章节会讲到），但不能在运行时通过来访问地址上的模块。
那么怎么来理解这句话呢，首先我们要看一下 Move 链的全局状态是怎么样的，官方提供了一张示意图：
![](https://github.com/move-language/move/raw/main/language/documentation/tutorial/diagrams/move_state.png)

全局状态在 Rust 中的表示大致如下：
```rust
struct GlobalStorage {
    resources: Map<address, Map<ResourceType, ResourceValue>>
    modules: Map<address, Map<ModuleName, ModuleBytecode>>
}
```
也就是说全局存储了两个 Map ，一个用来存每个地址有哪些资源，一个用来存每个地址有哪些模块。通过运行时只能访问第一个 Map 中的数据，也就是存储资源的那个 Map。

我们再介绍一下关于地址类型的语法，地址有两种类型：数值地址 和 命名地址。 任何有效的 u128 数值都可以用作地址的值。为了和整型区分，地址在使用的时候语法会根据上下文有所差异：

1）被用作表达式时，需要在地址的字面值或者命名标志符前加上 `@` 符号，这里的表达式也包括作为函数的参数等，例如：
```rust
let addr_1 = @0xAB;
let addr_2 = @1234;
let addr_3 = @std; 
```
2）除此之外可以不用 `@` ，例如：
```rust
// import module
use 0x9::my_module;
// call function
std::debug::print(&1);
```
命名地址需要我们在 Move.toml 中声明：
```toml
[address]
std = "0x1"
addr = "0xC0FFEECAFE"
```
当编译的时候，编译器会把源码中的命名地址标识符转换成对应的字节码。
所以在编写源码时，一定要注意不要一会儿用命名地址，一会儿用它的数值地址，这会导致代码的可读性变差，并且从源码层面来说，两者并不相同，一个是编译时的参数，一个是常量。

## Signer
签署人（signer）是 Move 内建的一种类型，不可以被复制，包含了交易发送者的地址信息。它代表了发送者的权利，也就是说它可以访问发送者地址下的资源。
可以把签署人类型看作是对地址类型的一种结构体封装：
```rust
struct signer has drop { addr: address }
```
我们无法在代码中创建签署人类型的变量，只能通过给 Move 虚拟机传参来创建。 `signer` 可以通过 `address_of` 来获取它内部地址的值。
有了签署人类型后，某些函数就可以验证交易发送者是否真的有权限来做这些事情，避免了弄虚作假。

## Address & Signer 演示
然后我们简单的演示一下 `address` 和 `signer` 的使用，我们先在 `sources/` 下创建 `my_module.move` 文件：
```rust
module 0x42::M {
    struct Coin has key, store{
        value: u64
    }

    public fun give_coin(account: &signer) {
        let coin = Coin { value: 1 };   // Create a 'Coin' 
        move_to(account, coin);     // move the coin to account's address as a resource
    }

    public fun balance_of(owner: address): u64 acquires Coin {
        borrow_global<Coin>(owner).value    // query the value of the Coin at owner's address
    }
}
```
这里我们简单的创建了一个 `Coin` 结构体，并提供了给某个地址一个 `Coin` 的方法 `give_coin`，以及检查某个地址上 `Coin` 的值的方法 `balance_of`。
这里可能涉及到一些特性和知识点，可以先不管他，只要知道这两个方法是做什么的就行了，后面的课程中会讲到这些点，这里只作简单的演示。

然后我们修改 `my_script.move`：
```rust
script{
    use 0x1::debug;
    use std::signer;
    use 0x42::M;

    fun main(account: signer) {

        M::give_coin(&account);

        let r = M::balance_of(signer::address_of(&account));
        debug::print(&r);
    }
}
```
脚本做的事情就是，先给 **account** 一个 `Coin`，然后我们再通过查看地址下 `Coin` 的 `value` 来确认是否执行成功了。

代码完成以后，我们把模块发布出去，并执行脚本，查看结果：
```shell
move sandbox publish
move sandbox run scripts/my_script.move --signers 0xCD
```
这里的参数 `--signer 0xCD` 就是告诉 VM 我们的发送者地址是 `0xCD`。
我们可以看到打印的结果，输出 `1`，表明操作成功了：
```shell
[debug] 1
```
