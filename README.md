# 电子科技大学 Beamer 模版

这是一个电子科技大学的 Beamer 模版，模版主要参考了[张冬呈的模版](https://www.overleaf.com/latex/templates/uestc-beamer-theme/ybqzdsgvrfdq)。修改后的模版可以帮助快速制作一份精美的组会汇报 slide.

## 模版展示

<!-- ![效果预览](https://drive.google.com/file/d/1Wdcnd10IIznqj6fpoy0PB7HkBTvmU6Dh/preview) -->
[效果预览](https://y006.github.io/slide_template/main.pdf)

## 快速开始

1. 克隆仓库

   ```shell
   git clone https://github.com/Y006/slide_template.git
   cd slide_template
   ```

2. 编辑标题页信息

   打开 `style/titlepage.sty`，编辑标题页信息。

3. 编辑 slide 内容

   打开 main.tex，在注释（第 57 行）

   ```
   % ====== 你的内容开始的地方 ======
   ```

   下方填写幻灯片主体内容。如需引用文献，请将 BibTeX 格式的引用条目粘贴至 `bibliography.bib`。

4. 编译 slide（下面三个方法中选一个即可）

    1. 使用 Makefile 进行编译（TODO：目前还没有在 win 系统上做测试）

       检查依赖项安装情况：

       ```shell
       make --version
       make check
       ```

       编译指令：

       ```shell
       make
       ```

       可以运行 `make h` 查看 `makefile` 的使用帮助。

    2. 使用 latex 编译链进行编译

       检查依赖项安装情况：

       ```shell
       xelatex --version       # 支持中文与 Unicode 的 LaTeX 引擎
       bibtex --version        # 文献处理工具（或 biber）
       ```

       使用配方 `xelatex->bibtex->xelatex->xelatex` 编译文件 `main.tex`；

    3. 使用 latexmk 进行编译

       检查依赖项安装情况：

       ```shell
       latexmk --version
       ```

       使用 `latexmk` 编译文件 `main.tex`。

## 更详细的使用方法

见 [tutorial_v1](tutorial_v1.md)