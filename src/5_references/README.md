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
| `&e` | `T` 其中 `e` 为 `&T` 或 `&mut T` | 读取 `e` 所指向的值
| `*e1 = e2` | () 其中 `e1: &mut T` 和 `e2: T` | 用 `e2` 更新 `e1` 中的值

### 不可变引用

运算符`&e`和`&e.f`可以用来创建新的引用, 但是要注意的是，多重引用在Move语言里是不允许的：

```rust
let token = Token{amount: 1};
let x: u64 = 0;
let y: &u64 = &x; //创建u64类型的引用y
let t_ref : &Token = &token; //创建Token类型的引用t_ref
//下面的语句是错误的，编译时会报错。
let z: &&u64 = &y;
```

在结构中，运算符`&e`和`&e.f`也可以扩展引用：

```rust
let token = Token{amount: 1};
let t_ref : &Token = &token;
let a_ref : &u64 = &t_ref.amount;
```
