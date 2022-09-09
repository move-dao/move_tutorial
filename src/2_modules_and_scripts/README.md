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

首先,模块名称可以以字母 `a` 到 `z` 或字母 `A` 到 `Z` 开头。在第一个字符之后，模块名可以包含下划线 `_` 、字母 `a` 到 `z` 、字母 `A` 到 `Z` 或数字 `0` 到 `9`。通常，模块名称以小写字母开头。名为`my_module`的模块应该存储在名为`my_module.move`的源文件中。

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

从语法结构中可以看出，`Move`语言的模块包含了五种元素，分别是`use`、`friend`、`type`、`function`和`constant`。从根本上说，模块是`types`和`functions`的集合, `Uses`用来导入其它模块,或者直接导入其它模块中的结构类型和函数。`Friends`用来指定同一地址下可信的模块列表。`Constants`定义可以在模块中用使用的私有常量。这些元素的详细介绍会在后面的内容中展示。

在`sources/`目录下，新建文件并命名为`my_module.move`, 然后编写如下代码：

```rust
module 0xC0FFEE::my_module{

    use std::debug;
    use std::string;

    struct Example has drop{
        i: u64
    }

    const ENOT_POSITIVE_NUMBER: u64 = 0;
    
    //判断输入参数是否为质数的函数
    public fun is_prime(x: u64): bool {
        debug::print(&string::utf8(b"Start"));
        
        let example = Example { i: x };

        if (example.i == 1) {
            false
        } else if(example.i % 2 == 0){
                    false
               }else{
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

`module 0xC0FFEE::my_module`这部分指定模块`my_module`会被发布到全局存储中0xC0FFEE这个地址之下。

模块也可以用命名地址来声明，在使用命名地址之前，要将该地址的命名和要分配给它的字面量地址添加到`Move.toml`文件中。

```toml
[package]
name = "modules_and_scripts"
version = "0.0.0"

[addresses]
std =  "0x1"
#下面的命名地址添加到Move.toml文件中。
move_dao = "0xC0FFEE"

[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib", rev = "main" }
#将下面MoveNursery依赖添加到Move.toml文件中。
MoveNursery = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib/nursery", rev = "main" }
```

修改完`Move.toml`文件之后，修改在`sources/`目录下的`my_module.move`文件。
将

```rust
module 0xC0FFEE::my_module{
```

修改为

```rust
module move_dao::my_module{
```

即可。

命名地址只存在于源码级别，并且在编译期间，命名地址会被转换成字节码。例如，如果我们有下面的代码:

```rust
script {
    fun example() {
        move_dao::my_module::is_prime(7);
    }
}
```

我们会将`move_dao`编译为`0xC0FFEE`，将和下面的代码是等价的:

```rust
script {
    fun example() {
        0xC0FFEE::my_module::is_prime(7);
    }
}
```

但是在源码级别，这两个并不等价 - 函数`my_module::is_prime`必须通过`move_dao`命名地址访问，而不是通过分配给该地址的数值访问。

### 脚本(Script)

脚本(***Scripts***)是可执行的入口点，类似于传统语言中的主函数`main`。脚本通常调用已发布模块的函数来更新全局存储。***Scripts***是暂时的代码片段，没有发布到全局存储中。

#### 语法(Syntax)

脚本***script***具有以下结构:

```rust
script {
    <use>*
    <constants>*
    fun <identifier><[type parameters: constraint]*>([identifier: type]*) <function_body>
}
```

一个***Script***块必须在开头声明`use`，然后是`constants`的内容,最后声明主函数`function`。主函数的名称可以是任意的(也就是说，它不一定命名为 `main`)，是***Script block***中唯一的函数，可以有任意数量的参数，并且不能有返回值。

在`scripts/`目录下，新建文件并命名为`my_script.move`, 将下面示例代码编写到文件中:

```rust
script{
    use std::debug;
    use std::string;
    use move_dao::my_module::is_prime;

    fun my_script(){
        if (is_prime(7)){
            debug::print(&string::utf8(b"Is a Prime Number"));
        }else{
            debug::print(&string::utf8(b"Not a Prime Number"));
        }
    }
}
```

代码完成以后，我们把模块发布出去，并执行脚本，查看结果：

```shell
move sandbox publish
move sandbox run scripts/my_script.move
# 上述命令输出字符串以char code形式展现，我们利用node转换下查看内容
node -e "console.log([73, 115, 32, 97, 32, 80, 114, 105, 109, 101, 32, 78, 117, 109, 98, 101, 114].map(code => String.fromCharCode(code)).join(''))"
```

