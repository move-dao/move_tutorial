# 模块及脚本

## 概要

本节课我们将介绍一下Move中两个不同的程序***Modules***和***Scripts***。

我们首先通过新建一个 Move 项目:
```shell
move new modules_and_scripts
cd  modules_and_scripts
```
创建完新的项目之后，不要忘记修改`Move.toml`文件，将MoveNursery依赖加上去。
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

### 模块(Module)

模块是定义结构类型以及对这些类型进行操作的函数的库。结构类型定义Move的全局存储的模式，模块函数定义更新存储的规则,模块本身也存储在全局存储中。模块相当于智能合约(Smart Contract)。

#### 语法(Syntax)

首先,模块名称可以以字母 `a` 到 `z` 或字母 `A` 到 `Z` 开头。在第一个字符之后，模块名可以包含下划线 `_` 、字母 `a` 到 `z` 、字母 `A` 到 `Z` 或数字 `0` 到 `9`。通常，模块名称以小写字母开头。

```rust
module my_module {}
module MyTestModule_1 {}
```

模块***Module***的语法结构如下

```rust
module <address>::<identifier> {
    (<use> | <friend> | <type> | <function> | <constant>)*
}
```

其中`<address>`是一个有效的命名地址或字面量地址。

模块中的所有元素可以以

在`sources/`目录下，新建文件，并命名为`my_module.move`, 然后编写如下代码：

```rust
module movedao::my_module{

    use std::debug;
    use std::string;

    struct Example {
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;

    public fun is_prime(x: u64): bool {
        debug::print(&string::utf8(b"Start"));
        
        let example = Example { i: x };

        if (example.i == 1) {
            false
        } else {
            let num = example.i - 1;
            let isp = true;
            while(num >= 2) {
                if (example.i % num == 0) {
                    isp = false;
                    break
                };
                num = num - 1;
            };

            isp
        }
    }

}
```

上述代码实现了一个简单的判断质数的方法。