# 电子科技大学 Beamer 模版

这是一个电子科技大学的 Beamer 模版，模版主要参考了[张冬呈的模版](https://www.overleaf.com/latex/templates/uestc-beamer-theme/ybqzdsgvrfdq)。修改后的模版可以帮助快速制作一份精美的组会汇报 slide.

## 模版展示

见 [example]()

## 快速开始

#### 需要的配置：
|   工具  | 版本                                                   |
|:-------:|-------------------------------------------------------|
| xelatex | 已安装：XeTeX 3.141592653-2.6-0.999996 (TeX Live 2024) |
|  bibtex | 已安装：BibTeX 0.99d (TeX Live 2024)                   |

#### 编译方法：
- 配方：
    - 如果不需要参考文献和公式标注，请使用配方：`xelatex->xelatex`.
    - 如果需要参考文献，请使用配方：`xelatex -> bibtex -> xelatex -> xelatex`.
    - 如果需要公式标注，请使用配方：`xelatex -> xelatex -> xelatex`.
- 更推荐的方法：
    - 使用项目的 makefile 文件来进行编译，使用方法见：`make h`（终端输入，注意此 makefile 仅在 macos 上进行验证，win 可以尝试使用 bash）

#### 演示方法：

1. 使用任意 PDF 阅读器：VScode 中的LaTeX Workshop Internal PDF Viewer 为例，在阅读器顶部选择“页面滚动”、“单页视图”和“适合页面”。

2. 更推荐使用 [Pympress](https://github.com/Cimbali/pympress) 进行演示。

## 更详细的使用方法

见 [tutorial](tutorial.md)