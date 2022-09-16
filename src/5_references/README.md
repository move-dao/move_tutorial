# 引用

## 概要

本节课我们将介绍一下Move中引用***References***。
Move支持两种类型的引用：不可变引用`&` 和可变引用`&mut`。不可变引用是只读的，不能修改相关值(或其任何字段)。可变引用通过写入该引用进行修改。Move的类型系统强制执行所有权规则，以避免引用错误。

我们首先新建一个 Move 项目:
```shell
move new modules_and_scripts
cd  modules_and_scripts
```
创建完新的项目之后，不要忘记修改`Move.toml`文件，将MoveNursery依赖加上去。
```toml
[package]
name = "references"
version = "0.0.0"

[addresses]
std =  "0x1"

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

Move提供了引用运算符,可以用来创建引用、扩展引用以及把一个可变引用转换成不可变引用。下面的列表是这些运算符的语法，其中，`e: T`的表示的是“类型为`T`的表达式`e`”.

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

### 不可变引用

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