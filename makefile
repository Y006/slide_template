TEXFILE = main.tex
FILENAME = main

# 从 main.tex 读取标记
COMPILE_CHAIN := $(shell grep '^% *!compile_chain' $(TEXFILE) | sed 's/.*= *//')
CLEAN_MID := $(shell grep '^% *!clean_midfiles' $(TEXFILE) | sed 's/.*= *//')

# 默认目标
main:
	@echo "🧠 检测编译链: $(COMPILE_CHAIN)"
	@echo "🧹 是否清理中间文件: $(CLEAN_MID)"
	@echo "🚀 开始编译..."

	@echo "$(COMPILE_CHAIN)" | sed 's/->/\n/g' | while read cmd; do \
		cmd=$$(echo $$cmd | xargs); \
		echo "🔧 执行指令：$$cmd"; \
		if [ "$$cmd" = "xelatex" ]; then \
			xelatex -halt-on-error -interaction=nonstopmode $(TEXFILE) >> build.log 2>&1; \
		elif [ "$$cmd" = "bibtex" ]; then \
			bibtex $(FILENAME) >> build.log 2>&1; \
		elif [ "$$cmd" = "biber" ]; then \
			biber $(FILENAME) >> build.log 2>&1; \
		else \
			echo "\033[33m⚠️ 未知命令：$$cmd\033[0m"; \
		fi; \
		if [ $$? -ne 0 ]; then \
			echo "\033[31m❌ 编译阶段 $$cmd 失败\033[0m"; \
			echo "🔍 请检查 build.log 获取详细错误信息"; \
			exit 1; \
		fi; \
	done

	@echo "✅ 编译完成！"

	@if [ "$(CLEAN_MID)" = "true" ]; then \
		$(MAKE) cl; \
	fi

cl:
	@echo "🧹 正在清理中间文件..."
	@rm -f $(FILENAME).{aux,bbl,blg,log,nav,out,snm,toc,vrb,synctex.gz,brf}
	@echo "✅ 清理完成！"

h:
	@echo ""
	@echo "📘 LaTeX Makefile 使用指南"
	@echo ""
	@echo "本 Makefile 支持通过在 main.tex 文件中添加注释来控制编译流程。"
	@echo ""
	@echo "🛠️ 标记规则（写在 main.tex 顶部）："
	@echo "   % !compile_chain = xelatex -> bibtex -> xelatex -> xelatex"
	@echo "   % !clean_midfiles = true"
	@echo ""
	@echo "📌 compile_chain："
	@echo "   - 设置编译顺序，可包含 xelatex、bibtex、biber"
	@echo "   - 多次 xelatex 用于处理交叉引用、目录、annotated equations"
	@echo ""
	@echo "📌 clean_midfiles："
	@echo "   - 若为 true，编译完成后自动删除中间文件（aux, log 等）"
	@echo ""
	@echo "📦 常用命令说明："
	@echo ""
	@echo "┌────────────────────────┬────────────────────────────────────────────┐"
	@echo "│ 命令                   │ 功能                                       │"
	@echo "├────────────────────────┼────────────────────────────────────────────┤"
	@echo "│ make                   │ 默认编译，自动读取 main.tex 中的编译链     │"
	@echo "│ make main              │ 与 make 相同，执行自定义编译链             │"
	@echo "│ make cl                │ 清理中间文件（aux, log, toc 等）           │"
	@echo "│ make ch                │ 检查是否安装 xelatex 和 bibtex 工具        │"
	@echo "│ make h                 │ 打印本帮助菜单                             │"
	@echo "└────────────────────────┴────────────────────────────────────────────┘"
	@echo ""
	@echo "📂 编译日志已重定向至 build.log，如失败请使用："
	@echo "   tail -n 50 build.log"
	@echo ""
	@echo "📄 更多文档说明请见 README.md 或 main.tex 顶部注释区"

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

