# Makefile for LaTeX documents
FILENAME=main
TEXFILE=$(FILENAME).tex

# 编译选项：1=xelatex两次, 2=含bibtex, 3=四次xelatex
M ?= 1

.PHONY: main tikz cl h ch

main:
ifeq ($(M),1)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第一次编译失败\033[0m"; exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第二次编译失败\033[0m"; exit 1; \
	fi
	@echo "🔁 编译模式 1：xelatex -> xelatex"
	@echo "✅ 编译完成！"
endif
ifeq ($(M),2)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第一次编译失败\033[0m"; exit 1; \
	fi
	@bibtex $(FILENAME)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ bibtex 编译失败\033[0m"; \
		echo "📌 请确保 \\bibliography{} 和 \\bibliographystyle{} 存在，或使用 biber"; \
		exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第二次编译失败\033[0m"; exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第三次编译失败\033[0m"; exit 1; \
	fi
	@echo "🔁 编译模式 2：xelatex -> bibtex -> xelatex -> xelatex"
	@echo "✅ 编译完成！"
endif
ifeq ($(M),3)
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第一次编译失败\033[0m"; exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第二次编译失败\033[0m"; exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第三次编译失败\033[0m"; exit 1; \
	fi
	@xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE)
	@if [ $$? -ne 0 ]; then \
		echo "\033[31m❌ 第四次编译失败\033[0m"; exit 1; \
	fi
	@echo "🔁 编译模式 3：xelatex -> xelatex -> xelatex -> xelatex"
	@echo "✅ 编译完成！"
endif

	@echo "是否清理中间文件？(y/n)"
	@read -n 1 clanswer; echo ""; \
	if [ "$$clanswer" = "y" ]; then \
		$(MAKE) cl; \
	else \
		echo "❌ 未清理中间文件"; \
	fi

	@echo "是否清除终端输出？(y/n)"
	@read -n 1 answer; echo ""; \
	if [ "$$answer" = "y" ]; then \
		clear; \
		echo "✅ 清除终端输出！"; \
	else \
		echo "❌ 未清除终端输出"; \
	fi

tikz:
	@if [ -z "$(F)" ]; then \
		echo "❌ 请输入 tikz 文件路径：make tikz F=路径/文件名（不加.tex）"; \
		exit 1; \
	fi
	@echo "🛠️  正在编译 pictures/tikz/$(F).tex ..."
	@xelatex -output-directory=$(dir pictures/tikz/$(F)) pictures/tikz/$(F).tex || \
	( echo "\033[31m❌ 编译失败，终止 Make\033[0m"; exit 1 )
	@rm -f pictures/tikz/$(F).aux pictures/tikz/$(F).log pictures/tikz/$(F).synctex.gz
	@echo "✅ 编译完成，并已清除中间文件"
	@echo "是否清除终端输出？(y/n)"
	@read -n 1 answer; \
	if [ "$$answer" = "y" ]; then \
		clear; \
		echo "✅ 清除完成！"; \
	else \
		echo "❌ 未清除终端输出"; \
	fi

cl:
	@echo "🧹 正在清理中间文件..."
	@rm -f $(FILENAME).{aux,bbl,blg,log,nav,out,snm,toc,vrb,synctex.gz,brf}
	@echo "✅ 清理完成！"

h:
	@echo ""
	@echo "📘 LaTeX Makefile 使用指南"
	@echo "本 Makefile 提供一键编译、参考文献处理、TikZ 图绘制、中间文件清理等功能。"
	@echo "下表展示了可用的 make 命令及其对应功能："
	@echo ""
	@echo "┌──────────────────────────────────────────────┬────────────────────────────────────────────────────────┐"
	@echo "│ 命令                                         │ 功能                                                   │"
	@echo "├──────────────────────────────────────────────┼────────────────────────────────────────────────────────┤"
	@echo "│ make                                         │ 默认：双次 xelatex 编译，确保目录、交叉引用正常生成    │"
	@echo "│ make main                                    │ 同上                                                   │"
	@echo "│ make main COMPILE_MODE=2                     │ 可选：含 bibtex：用于引用文献，常用于含参考文献的论文  │"
	@echo "│ make main COMPILE_MODE=3                     │ 可选：四次 xelatex 编译，确保公式标注正确显示		│"
	@echo "│ make tikz FILE=路径/文件名（不加.tex）       │ 编译单个 TikZ 图（默认路径为 pictures/tikz/）          │"
	@echo "│ make cl                                      │ 清理中间文件（aux, log, toc 等）                       │"
	@echo "│ make ch                                      │ 检查是否安装 xelatex 和 bibtex                         │"
	@echo "│ make h                                       │ 打印本帮助菜单                                         │"
	@echo "└──────────────────────────────────────────────┴────────────────────────────────────────────────────────┘"

ch:
	@echo "─────────────────────┬──────────────────────────────────────────────────────────────────────────"
	@echo " 工具                │ 状态                                                                     "
	@echo "─────────────────────┼──────────────────────────────────────────────────────────────────────────"
	@if command -v xelatex >/dev/null 2>&1; then \
		printf " %-20s│ 已安装：%s\n" "xelatex" "$$(xelatex --version | head -n 1)"; \
	else \
		echo " xelatex             │ ❌ 未找到，请安装 TeX Live 或 MacTeX                                     "; \
		exit 1; \
	fi
	@if command -v bibtex >/dev/null 2>&1; then \
		printf " %-20s│ 已安装：%s\n" "bibtex" "$$(bibtex --version | head -n 1)"; \
	else \
		echo " bibtex              │ ❌ 未找到，参考文献功能将无法使用                                          "; \
		exit 1; \
	fi
	@echo "─────────────────────┴──────────────────────────────────────────────────────────────────────────"

