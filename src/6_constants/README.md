# 常量

## 概要

本节课我们将学习 Move 中的常量。
首先我们先新建一个 Move 项目，

```shell
move new constants
cd constants
```

添加依赖项MoveNursery到Move.toml
```toml
[package]
name = "modules_and_scripts"
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

常量可以让我们定义一个在`module`或`script`内使用的静态值。

常量声明以 const 关键字开头，后跟名称、类型和值。他们可以存在于脚本或模块中
```rust
const <name>: <type> = <expression>;
```

## 例子：

假如，有一家商店，一些操作我只想让我自己能够去做，例如拿出收银机里所有的钱。
我可以把我自己的地址设为一个常量，常量的值是无法修改的。
当我们要做操作的时候我们就先去鉴权。

我们先在 sources/ 下创建 my_module.move 文件：
```rust
address 0x42 {
    module example {
        use std::signer;
        const MY_ADDRESS: address = @0x42;
        const MY_ERROR_CODE: u64 = 1;

        public fun permissioned(s: &signer) {
            assert!(signer::address_of(s) == MY_ADDRESS, MY_ERROR_CODE);
        }
    }
}
```
将MY_ADDRESS和MY_ERROR_CODE设为常量

然后我们修改 script/my_script.move 文件：
```rust
script{
    use 0x42::example;

    fun main(account: signer) {

        example::permissioned(&account);
    }
}
```

代码完成以后，我们把模块发布出去，并执行脚本

```shell
move sandbox publish
move sandbox run scripts/my_script.move --signers 0x43
```

这里的参数 --signer 0x43 就是告诉 VM 调用permissoned方法的地址是 0x43。 
如果参数不为0x42，则会终止,并返回以下信息

```
Execution aborted with code 1 in module 00000000000000000000000000000042::example.
```

需要注意的是，常量必须以大写字母`A`到`Z`开头，后面可以用可以包含下划线 `_`、字母 `a` 到 `z`、字母 `A` 到 `Z` 或数字 `0` 到 `9`,否则将会报错
虽然不包含小写字母的写法是被允许的,但是[编码规范](https://move-dao.github.io/move-book-zh/coding-conventions.html)中常量的定义只使用大写字母，
每个单词之间用下划线分割。

```rust
const FLAG: bool = false;
const MY_ERROR_CODE: u64 = 0;
const ADDRESS_42: address = @0x42;
```

这种以 A 到 Z 开头的命名限制是为了给未来的语言特性留出空间。此限制未来可能会保留，也可能会删除。

### 可见性 (Visibility)

目前不支持 public 常量。 const 值只能在声明的模块中使用。

### 有效值

目前，常量仅限于原始类型 bool、u8、u64、u128、address 和vector<u8>。其他 vector 值(除了“string”风格的字面量)将在不远的将来获得支持。

```rust
const MY_BOOL: bool = false;
const MY_ADDRESS: address = @0x70DD;
const BYTES: vector<u8> = b"hello world";
const HEX_BYTES: vector<u8> = x"DEADBEEF";
```

### 表达式作为值

除了字面量，常量也可以包含更复杂的表达式，只要编译器能够在编译时将表达式reduce为一个值。
目前，相等运算、布尔运算、按位运算和算术运算都是可以使用。

```rust
const RULE: bool = true && false;
const CAP: u64 = 10 * 100 + 1;
const SHIFTY: u8 = {
  (1 << 1) * (1 << 2) * (1 << 3) * (1 << 4)
};
const HALF_MAX: u128 = 340282366920938463463374607431768211455 / 2;
const EQUAL: bool = 1 == 1;
```

如果操作会导致运行时异常，编译器会给出无法生成常量值的错误。


还有一点需要补充的是，常量当前不能引用其他常量。将来会支持。