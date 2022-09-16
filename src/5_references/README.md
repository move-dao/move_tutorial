# 引用

## 概要

本节课我们将介绍一下 Move 中引用***References***。
Move 支持两种类型的引用：不可变引用`&` 和可变引用`&mut`。不可变引用是只读的，不能修改相关值(或其任何字段)。可变引用通过写入该引用进行修改。Move的类型系统强制执行所有权规则，以避免引用错误。

我们首先新建一个 Move 项目:
```shell
move new references
cd  references
```
创建完新的项目之后，不要忘记修改`Move.toml`文件，将命名地址move_dao和MoveNursery依赖加上去。
```toml
[package]
name = "references"
version = "0.0.0"

[addresses]
std =  "0x1"
#将下列命名地址添加到Move.toml文件中
move_dao = "0xC0FFEE"

[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib", rev = "main" }
#将下面MoveNursery依赖添加到Move.toml文件中。
MoveNursery = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib/nursery", rev = "main" }
```

新建一个scripts/ 目录，在这个目录下新建脚本文件 my_script.move，编写下面的代码:
```rust
script {
    use std::debug;

    fun main() {
        // Write the code here
    }
}
```

## 引用运算符（Reference Operators）

Move 提供了引用运算符,可以用来创建引用、扩展引用以及把一个可变引用转换成不可变引用。下面的列表是这些运算符的语法，其中，`e: T`的表示的是“类型为`T`的表达式`e`”.

| 语法 | 类型 | 描述 |
| ------      | ------ |------ |
| `&e`        | `&T` 其中 `e: T` 和 `T` 是非引用类型      | 创建一个不可变的引用 `e`
| `&mut e`    | `&mut T` 其中 `e: T` 和 `T` 是非引用类型  | 创建一个可变的引用 `e`
| `&e.f`      | `&T` 其中 `e.f: T`                       | 创建结构 `e` 的字段 `f` 的不可变引用
| `&mut e.f`  | `&mut T` 其中`e.f: T`                    | 创建结构 `e` 的字段 `f` 的可变引用
| `freeze(e)` | `&T` 其中`e: &mut T`                     | 将可变引用 `e` 转换为不可变引用


### 不可变引用

运算符`&e`和`&e.f`可以用来创建新的不可变引用, 但是要注意的是，多重引用在Move语言里是不允许的：

```rust
let token = Token{amount: 1};
let x: u64 = 0;
let y: &u64 = &x; //创建u64类型的不可变引用y
let t_ref : &Token = &token; //创建Token类型的不可变引用t_ref
//下面的语句是错误的，编译时会报错。
let z: &&u64 = &y;
```

在结构中，运算符`&e`和`&e.f`也可以扩展不可变引用：

```rust
let token = Token{amount: 1};
let t_ref : &Token = &token;
let a_ref : &u64 = &t_ref.amount;
```

只要两个结构都在同一个模块中，具有多个字段的引用表达式也是可以的：

```rust
struct Token { amount: B }
struct Balance { token : Token }
fun f(bal: &Balance): &u64 {
  &bal.token.amount
}
```

### 可变引用

运算符`&mut e`和`&mut e.f`可以用来创建新的可变引用, 同样也不能多重引用：

```rust
let token = Token{amount: 1};
let x: u64 = 0;
let y: &mut u64 = &mut x; //创建u64类型的可变引用y
let t_ref : &mut Token = &mut token; //创建Token类型的可变引用t_ref
```

在结构中，运算符`&mut e`和`&mut e.f`也可以扩展不可变引用, 但是在扩展的时候需要注意的是被扩展的引用必须是可变的，除非扩展的是一个不可变引用：

```rust
let token = Token{amount: 1};
let t_ref : &mut Token = &mut token;
let a_ref : &mut u64 = &mut t_ref.amount;

//下列代码是有效的, 但引用a不能更新原token的值, 而引用t可以
let t: &mut Token = &mut token;
let a :&u64 = &t.amount;

//下列代码无效，编译器会报错
let t: &Token = &token;
let a :&mut u64 = &mut t.amount;
```

可以调用freeze将一个不可变引用转换成不可变引用.

```rust
let x: u64 = 0;
let y: &mut u64 = &mut x; //创建u64类型的可变引用y
let z = freeze(y);  //将可变引用y转换成不可变引用并赋给z
```

#### freeze推断（freeze inference）

在Move中，可变引用可以用在期望是不可变引用的位置, 这是因为编译器会在底层需要的地方插入freeze指令。如下:

```rust
fun takes_immut_returns_immut(x: &u64): &u64 { x }

// freeze推断，因为返回值的类型是可变引用，但是期望返回的是不可变类型
fun takes_mut_returns_immut(x: &mut u64): &u64 { x }

fun expression_examples() {
    let x = 0;
    let y = 0;
    takes_immut_returns_immut(&x); // 无freeze推断
    takes_immut_returns_immut(&mut x); // 有freeze推断，因为期望的参数是一个不可变引用
    takes_mut_returns_immut(&mut x); // 无freeze推断

    assert!(&x == &mut y, 42); // freeze推断, 因为不等号要求左右两边类型一致
}

fun assignment_examples() {
    let x = 0;
    let y = 0;
    let imm_ref: &u64 = &x;

    imm_ref = &x; // 无freeze推断
    imm_ref = &mut y; // freeze推断，因为imm_ref期望被赋值为一个不可变引用
}
```

通过freeze推断，Move 类型检查器可以将 `&mut T` 视为 `&T` 的子类型。 如上所示，这意味着对于使用 `&T` 值的任何表达式，也可以使用 `&mut T` 值。反之则不允许，即不可以在期望使用可变引用的地方，使用不可变引用，这样的程序会报错。

## 读写操作 (Reading and Writing)

通过引用进行读写的操作的语法如下：

| 语法 | 类型 | 描述 |
| ------ | ------ |------ |
| `&e` | `T` 其中 `e` 为 `&T` 或 `&mut T` | 读取 `e` 所指向的值
| `*e1 = e2` | () 其中 `e1: &mut T` 和 `e2: T` | 用 `e2` 更新 `e1` 中的值

从上述列表中，可以看到读取和写入两种操作都是使用了类C语言中的`*`语法, 其中读取中的`*e`是一种表达式，但是写入中的`*e`是必须发生在行号左边的改动。

### 读取

在 Move 中，可以读取可变引用和不可变引用来生成引用值的副本

```rust
let x: u64 = 0;
let a: &u64 = &x;
let b: &mut u64 = &mut x;

let c = *a;
let d = *b;
```

读取引用会创建值的新副本，为了读取引用，相关类型必须具有`copy 能力`, 这样的限制是为了防止复制资源值:

```rust
struct Token has key {amount: u64}

public fun ref_token(t: Token){
    let t_ref : &Token = &t;
    //下面语句会报错，因为Token没有copy能力
    let another_token: Token = *t_ref;
}
```

### 写入

Move 中只可以写入可变引用。在执行写入表达式 `*x = v` 会丢弃 `x` 中的值，并用 `v` 更新。

```rust
let x: u64 = 0;
let y: &mut u64 = &mut x;
*y = 1;
assert!(x == 0, 42);
```

为了写入引用，相关类型必须具备`drop能力`，因为写入引用将丢弃(或“删除”)旧值。此规则可防止破坏资源值：

```rust
struct Token has key, copy {amount: u64}

public fun ref_token(t: Token){
    let t_ref : &mut Token = &mut t;
    //下面语句会报错，因为Token没有drop能力
    *t_ref = Token{amount: 100};
}
```

## 所有权(Ownership)

***即使同一引用已经有了副本或者扩展***, 它依然是可以被复制和扩展的:

```rust
public fun tokenTest(token: &mut Token){
    let t_ref = token;
    let t_ext = &mut t_ref.amount;
    let t_ref2 = token;

    *t_ext = 100;  //1
    *t_ref = Token{amount: 99};//2
    *t_ref = Token{amount: 98};//3
    *t_ref2 = Token{amount: 96};//4
    }
```

对于熟悉Rust所有权系统的程序员来说，这可能会令人惊讶，因为他们并不能接受上面的代码。Move 的类型系统在处理副本方面更加宽松 ，但在写入前确保可变引用的唯一所有权方面同样严格。可以尝试把上面代码中有注释的四行打乱下顺序看会是什么样的结果。

由于 Move 的持久化全局存储，要求每一个 Move 值都必须是可序列化的，而引用无法被序列化, 所以引用不能存储为结构的字段值的类型,进而了不能存在于全层存储中， 这个规则同样适用于元组。当 Move 程序终止时，程序执行期间创建的所有引用都将被销毁；它们完全是短暂的。这种不变式也适用于没有`store能力`的类型的值，不同的是，引用和元组在创建结构类型的时候就不补允许。

## 示例代码

### 模块Module

```rust
module move_dao::my_module{

    struct Token has copy, key, drop{
        amount: u64
    }

    use std::debug;

    const EVALUE_NOT_CHANGED :u64 = 1;

    public fun publish_token(): Token{
        Token{amount:0}
    }

    public fun manipulate_value(x: u64, y : u64){
        let temp :u64 = x;
        let a: &mut u64 = &mut x;
        *a = y;
        assert!(x != temp, EVALUE_NOT_CHANGED);
        debug::print(&x);
    }

    public fun manipulate_token(x: u64, y: u64){
        let token = Token{amount: x};
        let t: &mut Token = &mut token;
        *t = Token{amount: y};
        assert!(token.amount != x, EVALUE_NOT_CHANGED);
        debug::print(&token.amount);
    }

    public fun manipulate_token_amount(x: u64, y:u64){
        let token = Token{amount: x};
        let t: &mut Token = &mut token;
        let t_ext :&mut u64 = &mut t.amount;
        *t_ext = y;
        assert!(token.amount != x, EVALUE_NOT_CHANGED);
        debug::print(&token.amount);
    }

    public fun tokenTest(token: &mut Token){

        let t_ref = token;
        let t_ext = &mut t_ref.amount;
        let t_ref2 = token;

        *t_ext = 100;
        *t_ref = Token{amount: 99};
        *t_ref = Token{amount: 98};
        *t_ref2 = Token{amount: 96};
        assert!(token.amount == 96, 0);
        debug::print(token);
    }
}
```

### 脚本Script

```rust
script {
    use move_dao::my_module;

    fun main(a: u64, b: u64) {
        // Write the code here
        let token = my_module::publish_token();
        my_module::manipulate_value(a, b);
        my_module::manipulate_token(a, b);
        my_module::manipulate_token_amount(a, b);
        my_module::tokenTest(&mut token);
    }
}
```

执行脚本，查看结果：

```shell
move sandbox publish
#--args 1 2是告诉VM给script中函数传入参数值1和2
move sandbox run scripts/my_script.move --args 1 2
```