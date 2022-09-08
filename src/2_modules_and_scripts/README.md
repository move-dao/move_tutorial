# 模块及脚本

## 概要

本节课我们将介绍一下Move中两个不同的程序**_Modules_**和**_Scripts_**。

### 模块*(Module)*

模块是定义结构类型以及对这些类型进行操作的函数的库。结构类型定义Move的全局存储的模式，模块函数定义更新存储的规则,模块本身也存储在全局存储中。模块相当于智能合约**_(Smart Contract)_**。

####语法**_(Syntax)_**

Module的语法结构如下

```rust
module <address>::<identifier> {
    (<use> | <friend> | <type> | <function> | <constant>)*
}
```

其中`<address>`是一个有效的命名地址或字面量地址。
