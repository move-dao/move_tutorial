# Hello World

## 概要

本节课我们将安装开发环境、配置IDE并在move、aptos、sui下分别写一个简单的Hello World程序

## 开发环境配置

目前move开发只能在linux或mac下，使用windows的小伙伴可以开启WSL后在linux环境使用，必要情况下需要使用代理加速模块下载速度或使用加速节点替换为国内下载源，参见[附录](#附录)。已经安装过的小伙伴可以自行跳过相关安装指令

- [安装 rust](https://rustup.rs/)
```shell
# 安装rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 遇到Proceed with installation (default)时按enter键
# 安装完成后，提示Rust is installed now. Great!
# 会提示让你配置环境变量，跟着他的提示做
# 例如：
# To configure your current shell, run:
# source "$HOME/.cargo/env"
# 检测安装是否成功
cargo --version
```

- [安装move cli](https://github.com/move-language/move/blob/main/language/documentation/tutorial/README.md#step-0-installation)
```shell
# 在用户目录下创建项目集目录
mkdir -p ~/projects && cd ~/projects
# clone项目
git clone https://github.com/move-language/move.git
# 安装编译依赖工具
cd move
./scripts/dev_setup.sh -ypt
# 安装所需依赖
# Proceed with installing necessary dependencies? (y/N) > y
# 更新终端环境
source ~/.profile
# 编译并安装 move cli（需要一段时间）
cargo install --path language/tools/move-cli
# 检测安装是否成功
move --version
```

- [安装aptos cli](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)
```shell
# 在用户目录下创建项目集目录
mkdir -p ~/projects && cd ~/projects
# clone项目
git clone https://github.com/aptos-labs/aptos-core.git
# 安装编译依赖工具
cd aptos-core
./scripts/dev_setup.sh
# 更新终端环境
source ~/.cargo/env
# 切换到devnet分支
git checkout --track origin/devnet
# 编译并安装 aptos cli（需要一段时间）
cargo install --path crates/aptos
# 检测安装是否成功
aptos --version
```

- [安装sui cli](https://github.com/MystenLabs/sui/blob/main/doc/src/build/install.md)
```shell
# 在用户目录下创建项目集目录
mkdir -p ~/projects && cd ~/projects
# clone项目
git clone https://github.com/MystenLabs/sui.git
# 安装编译依赖工具
cd sui
# 切换到devnet分支
git checkout --track origin/devnet
# 编译并安装 sui cli（需要一段时间）
cargo install --path crates/sui
# 检测安装是否成功
sui --version
```

## Hello World

### hello move

```shell
# 创建项目
mkdir -p ~/projects/move_tutorial && cd ~/projects/move_tutorial
move new hello_move
cd hello_move
```

添加&编辑项目文件

`Move.toml` 添加MoveNursery依赖
```toml
[package]
name = "hello_move"
version = "0.0.0"

[addresses]
std =  "0x1"

[dependencies]
MoveStdlib = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib", rev = "main" }
MoveNursery = { git = "https://github.com/move-language/move.git", subdir = "language/move-stdlib/nursery", rev = "main" }
```

`sources/my_module.move` 在0xCAFE下创建my_module模块，包含speak方法返回字符串
```move
module 0xCAFE::my_module {
    use std::string;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }
}
```

`scripts/my_script.move` 调用my_module::speak方法，打印字符串
```move
script {
    use std::debug;
    use 0xCAFE::my_module;

    fun my_script() {
        debug::print(&my_module::speak());
    }
}
```

```shell
# 在沙盒环境下发布模块
move sandbox publish
# 运行script
move sandbox run scripts/my_script.move
# 上述命令输出字符串以char code形式展现，我们利用node转换下查看内容
node -e "console.log([72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100].map(code => String.fromCharCode(code)).join(''))"
```

### hello aptos

```shell
# 创建项目
mkdir -p ~/projects/move_tutorial && cd ~/projects/move_tutorial
aptos move init --package-dir hello_aptos --name hello_aptos
cd hello_aptos
```

`sources/my_module.move` 在0xCAFE下创建my_module模块，包含speak方法返回字符串
```move
module 0xCAFE::my_module {
    use std::string;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        use aptos_std::debug;

        debug::print(&speak());
    }
}
```

```shell
# 运行测试
aptos move test
# 上述命令输出字符串以char code形式展现，我们利用node转换下查看内容
node -e "console.log([72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100].map(code => String.fromCharCode(code)).join(''))"
```

### hello sui

```shell
# 创建项目
mkdir -p ~/projects/move_tutorial && cd ~/projects/move_tutorial
sui move new --install-dir hello_sui hello_sui
cd hello_sui
```

`sources/my_module.move` 在hello_sui下创建my_module模块，包含speak方法返回字符串
```move
module hello_sui::my_module {
    use std::string;

    public fun speak(): string::String {
        string::utf8(b"Hello World")
    }

    #[test]
    public fun test_speak() {
        assert!(*string::bytes(&speak()) == b"Hello World", 0);
    }
}
```

```shell
# 修改Move.toml
# 将rev修改为devnet
```

```shell
# 运行测试
sui move test
```


## 总结
本节我们学习了如何搭建开发环境，并在move、aptos、sui下分别写了hello world小程序。我们发现语法上几乎一致，每种环境又有特有的内容。同学们可以随意修改代码编译测试，另外可以查看`move`、`aptos`、`sui`命令行的帮助内容，看看这些命令下还有哪些好玩的东西。接下来我们要专注于Move语法本身，学习Move模块及脚本相关内容，那我们接下来见。

## 附录

### [Windows WSL安装Ubuntu](https://docs.microsoft.com/en-us/windows/wsl/install)

```powershell
# 安装 Ubuntu-20.04
wsl --install Ubuntu-20.04
```

如果是初次安装WSL，需要重启电脑。

```powershell
# 进入wsl环境
wsl -d Ubuntu-20.04
```

### 代理配置

安装过程如果出现`timeout`的错误说明你的电脑无法正常下载相关资源，包括编译工具、git代码仓库等。

首先我们需要检测你的代理有效

```shell
# 终端中输入此命令，网络无法连通情况下，会卡住没有消息返回，此时按ctrl+c结束执行
curl google.com
# 终端中输入此命令，将ip、port替换为你的代理信息，代理运行正常情况下会输出
HTTP_PROXY=[ip]:[port] curl google.com
```

代理配置包括两部分：

- 配置终端环境代理，可以解决大部分终端运行命令无法正常连接情况

```shell
# 终端中输入命令，将ip、port替换为你的代理信息
export HTTP_PROXY=[ip]:[port]
export HTTPS_PROXY=[ip]:[port]
```

- 配置git代理，可以解决连接github下载源码问题

```shell
# 终端中输入命令，将ip、port替换为你的代理信息
git config --global http.proxy [ip]:[port]
git config --global https.proxy [ip]:[port]
```

### github替换为国内下载源

如果配置代理仍然不稳定无法成功运行，可以通过在`github.com`前添加`gitclone.com/`前缀，来使用国内下载源加速下载过程，这种办法适用于`git clone`项目源码，`Move.toml`依赖链接。例如

`https://github.com/davidiw/aptos-core.git`

添加前缀

`https://gitclone.com/github.com/davidiw/aptos-core.git`

### `dev_setup.sh` 脚本
```shell
# 通过 -h 参数可以查看脚本说明，可以发现 -ypt 安装了 cmake clang pkg-config libssl-dev nodejs z3 cvc5 dotnet boogie 等命令，并更新了终端配置
./scripts/dev_setup.sh -h
# -b batch mode, no user interactions and minimal output
# -p update /home/user/.profile
# -t install build tools
# -y installs or updates Move prover tools: z3, cvc5, dotnet, boogie
# -d installs the solidity compiler
# -g installs Git (required by the Move CLI)
# -v verbose mode
# -i installs an individual tool by name
# -n will target the /opt/ dir rather than the /home/user dir.  /opt/bin/, /opt/rustup/, and /opt/dotnet/ rather than /home/user/bin/, /home/user/.rustup/, and /home/user/.dotnet/
```

### VSCode Move 插件安装

[https://marketplace.visualstudio.com/items?itemName=move.move-analyzer](https://marketplace.visualstudio.com/items?itemName=move.move-analyzer)

搜索move-analyzer插件安装

```shell
# 进入 move 源码目录
cd ~/projects/move
# 编译安装 move-analyzer 命令行
cargo install --path language/move-analyzer
```

注意插件和命令行并非同一个，插件会探测系统安装的命令行并利用命令行执行分析

### JetBrains 系列 IDE 插件安装

[https://plugins.jetbrains.com/plugin/14721-move-language](https://plugins.jetbrains.com/plugin/14721-move-language)

搜索Move Language插件安装，配置aptos命令行位置。由于本插件由aptos生态的Pontem开发团队开发，主要针对aptos开发，所以部分IDE build功能在其它环境下运行不正常，但不影响move文件语法高亮等基础功能，仍然可以使用。

## 参考

- [https://move-language.github.io/move/](https://move-language.github.io/move/)
- [https://github.com/move-language/move/blob/main/language/documentation/tutorial/README.md](https://github.com/move-language/move/blob/main/language/documentation/tutorial/README.md)
