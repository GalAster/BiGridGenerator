# BiGridGenerator[项目已废弃]

该项目已废弃, 现在是代码垃圾堆.

敬请关注我的其他开发, 使用了更先进的架构.


1. Geis: 项目的主要继承者
2. Deus: 与游戏有关的一些项目
3. Illusive:

## BiGridGenerator(逼格场发生器)

一个收集了各种Mathematica有趣代码的程序包,为了方便新手使用封装成了一个个函数,并且附有说明文档.

所有代码均开源,代码来源有StackExchange、WolframBlog、还有我知乎上的朋友们以及我自己写的一些代码.

- **安装方式:平台为 Win10 且Mathematica10.0+直接拖入安装目录即可使用**

- **其他平台以及低版本因为种种bug暂时没有好的安装方式**

- **可以通过直接运行一个程序包来启动,也可以使用Get命令直接读取封装好的mx包**

## ![开发与部署](http://image.flaticon.com/icons/png/32/180/180012.png)开发与部署
### 开发环境

本程序包几乎所有代码使用Intellij编写,文档使用Wolfram Workbench生成,运行于Mathematica 10.0+

### 程序封装

介于Get函数有点毛病不支持中文,所以需要对程序进行封装:

- 使用`$ContextPath`命令获取当前加载的包

- ``DumpSave[FileNameJoin[{NotebookDirectory[],main.mx"}], {"MagicSquare`"}];``把代码封装成mx文件

- `Get[FileNameJoin[{NotebookDirectory[], "main.mx"}]]`读取封装的包


## ![许可协议](http://image.flaticon.com/icons/png/32/180/180005.png)License

该软件包遵从CC 3.0协议:NA+NC(非商业性使用、相同方式共享)