# Makefile for LaTeX documents (Windows版本)
FILENAME=main
TEXFILE=$(FILENAME).tex

# 编译选项：1=xelatex两次, 2=含bibtex, 3=四次xelatex
M ?= 1

.PHONY: main tikz cl h ch

main:
ifeq ($(M),1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第一次编译失败" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第二次编译失败" & exit /b 1)
	@echo 🔁 编译模式 1：xelatex -^> xelatex
	@echo ✅ 编译完成！
endif
ifeq ($(M),2)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第一次编译失败" & exit /b 1)
	@bibtex $(FILENAME)
	@if not errorlevel 0 (echo "❌ bibtex 编译失败" & echo "📌 请确保 \bibliography{} 和 \bibliographystyle{} 存在，或使用 biber" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第二次编译失败" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第三次编译失败" & exit /b 1)
	@echo 🔁 编译模式 2：xelatex -^> bibtex -^> xelatex -^> xelatex
	@echo ✅ 编译完成！
endif
ifeq ($(M),3)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第一次编译失败" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第二次编译失败" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第三次编译失败" & exit /b 1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if not errorlevel 0 (echo "❌ 第四次编译失败" & exit /b 1)
	@echo 🔁 编译模式 3：xelatex -^> xelatex -^> xelatex -^> xelatex
	@echo ✅ 编译完成！
endif
	@echo 提示：可使用 make cl 清理中间文件

tikz:
	@if "$(F)"=="" (echo "❌ 请输入 tikz 文件路径：make tikz F=路径/文件名（不加.tex）" & exit /b 1)
	@echo 🛠️ 正在编译 pictures/tikz/$(F).tex ...
	@xelatex -output-directory=$(dir pictures/tikz/$(F)) pictures/tikz/$(F).tex
	@if not errorlevel 0 (echo "❌ 编译失败，终止 Make" & exit /b 1)
	@del pictures\tikz\$(F).aux pictures\tikz\$(F).log pictures\tikz\$(F).synctex.gz 2>nul
	@echo ✅ 编译完成，并已清除中间文件

cl:
	@echo 🧹 正在清理中间文件...
	@del $(FILENAME).aux $(FILENAME).bbl $(FILENAME).blg $(FILENAME).log $(FILENAME).nav $(FILENAME).out $(FILENAME).snm $(FILENAME).toc $(FILENAME).vrb $(FILENAME).synctex.gz $(FILENAME).brf 2>nul || (echo 没有找到中间文件或清理失败)
	@echo ✅ 清理完成！

h:
	@echo.
	@echo 📘 LaTeX Makefile 使用指南
	@echo 本 Makefile 提供一键编译、参考文献处理、TikZ 图绘制、中间文件清理等功能。
	@echo 下表展示了可用的 make 命令及其对应功能：
	@echo.
	@echo ┌──────────────────────────────────────────────┬────────────────────────────────────────────────────────┐
	@echo │ 命令                                         │ 功能                                                   │
	@echo ├──────────────────────────────────────────────┼────────────────────────────────────────────────────────┤
	@echo │ make                                         │ 默认：双次 xelatex 编译，确保目录、交叉引用正常生成    │
	@echo │ make main                                    │ 同上                                                   │
	@echo │ make main M=2                                │ 可选：含 bibtex：用于引用文献，常用于含参考文献的论文  │
	@echo │ make main M=3                                │ 可选：四次 xelatex 编译，确保公式标注正确显示          │
	@echo │ make tikz F=路径/文件名（不加.tex）          │ 编译单个 TikZ 图（默认路径为 pictures/tikz/）          │
	@echo │ make cl                                      │ 清理中间文件（aux, log, toc 等）                       │
	@echo │ make ch                                      │ 检查是否安装 xelatex 和 bibtex                         │
	@echo │ make h                                       │ 打印本帮助菜单                                         │
	@echo └──────────────────────────────────────────────┴────────────────────────────────────────────────────────┘

ch:
	@echo ┌─────────────────────┬──────────────────────────────────────────────────────────────────────────┐
	@echo │ 工具                │ 状态                                                                     │
	@echo ├─────────────────────┼──────────────────────────────────────────────────────────────────────────┤
	@where xelatex >nul 2>&1 && (echo │ xelatex             │ 已安装                                                                   │) || (echo │ xelatex             │ ❌ 未找到，请安装 TeX Live 或 MiKTeX                                   │)
	@where bibtex >nul 2>&1 && (echo │ bibtex              │ 已安装                                                                   │) || (echo │ bibtex              │ ❌ 未找到，参考文献功能将无法使用                                      │)
	@echo └─────────────────────┴──────────────────────────────────────────────────────────────────────────┘