.PHONY: all build report pdfcopy tikz md2tex check help h

# Python 环境和日志分析脚本路径
PYTHON := /opt/homebrew/anaconda3/envs/openai/bin/python
LOG_ANALYZER := /Users/qiujinyu/Documents/slide/slide_template/llm_support/latex_log_openai.py

TEXFILE := main.tex
OUTDIR := build
LOGFILE := $(OUTDIR)/compile_trace.log

# Pandoc 路径设置
PANDOC ?= your pandoc path

# 一键执行
all: build report pdfcopy

# 编译并记录详细日志 + 记录耗时
build:
	@echo "📦 正在编译 $(TEXFILE)..."
	@if [ ! -d $(OUTDIR) ]; then \
		echo "📁 创建目录：$(OUTDIR)"; \
		mkdir -p $(OUTDIR); \
	else \
		echo "📁 目录已存在：$(OUTDIR)"; \
	fi
	@echo "📂 所有中间文件和 PDF 输出目录为：$(OUTDIR)/"
	@start_time=$$(date +%s); \
	latexmk -xelatex -verbose -outdir=$(OUTDIR) $(TEXFILE) > $(LOGFILE) 2>&1; \
	end_time=$$(date +%s); \
	elapsed=$$((end_time - start_time)); \
	echo "⏱️ 编译耗时：$${elapsed} 秒" | tee -a $(LOGFILE)

# 提取工具调用信息并统计
report:
	@echo "📊 编译工具调用统计："
	@if [ ! -f $(LOGFILE) ]; then \
		echo "⚠️ 日志文件 $(LOGFILE) 不存在，请先运行 make build"; \
		exit 1; \
	fi
	@grep -E 'Run number [0-9]+ of rule' $(LOGFILE) \
		| sed 's/.*rule '\''//;s/'\''.*//' \
		| sort | uniq -c \
		| awk '{printf "🔧 工具：%-10s 次数：%s\n", $$2, $$1}'

# 复制 PDF 到根目录，命名为 main.pdf
pdfcopy:
	@echo "📄 正在复制 PDF..."
	@if [ -f $(OUTDIR)/main.pdf ]; then \
		cp $(OUTDIR)/main.pdf ./main.pdf; \
		echo "✅ 已将 PDF 从 '$(OUTDIR)/main.pdf' 复制到根目录：./main.pdf"; \
	else \
		echo "❌ 未找到 '$(OUTDIR)/main.pdf'，请先运行 make build"; \
		exit 1; \
	fi

# 使用 ai 工具进行日志分析
ai:
	@echo "🧠 正在使用 AI 分析日志..."
	@echo "📄 日志绝对路径为：$$(realpath $(LOGFILE))"
	@$(PYTHON) $(LOG_ANALYZER) $$(realpath $(LOGFILE)) || echo "❌ 日志分析失败"

# 编译 TikZ 子图：make tikz F=文件名（不含.tex，默认路径 pictures/tikz）
tikz:
	@if [ -z "$(F)" ]; then \
		echo "❌ 请输入 TikZ 文件路径：make tikz F=相对路径/文件名（不含.tex）"; \
		exit 1; \
	fi
	@TEX=pictures/tikz/$(F).tex; \
	OUTDIR=$$(dirname $$TEX); \
	echo "🛠️  正在编译 $$TEX ..."; \
	xelatex -output-directory=$$OUTDIR $$TEX > /dev/null || \
	( echo "\033[31m❌ 编译失败，终止 Make\033[0m"; exit 1 ); \
	rm -f $$OUTDIR/*.aux $$OUTDIR/*.log $$OUTDIR/*.synctex.gz; \
	echo "✅ 编译完成并已清理中间文件。"

# 将 Markdown 转换为 LaTeX Beamer 幻灯片（用于代码高亮）
md2tex:
	@echo "📄 使用方法：请将你希望放入幻灯片的代码块内容写在 code/source.md 中"
	@echo "📝 正在使用 Pandoc ($(PANDOC)) 将 code/source.md 转换为 code/source.tex ..."
	@if ! command -v $(PANDOC) >/dev/null 2>&1; then \
		echo "❌ 错误：未检测到 Pandoc，请确认 $(PANDOC) 是否存在"; \
		exit 1; \
	fi
	@if [ ! -f code/source.md ]; then \
		echo "❌ 错误：未找到 code/source.md"; \
		exit 1; \
	fi
	@$(PANDOC) code/source.md -t beamer -o code/source.tex --highlight-style=pygments
	@if [ $$? -eq 0 ]; then \
		echo "✅ 转换成功：code/source.tex 已创建"; \
	else \
		echo "❌ 转换失败，请检查 Markdown 内容格式"; \
	fi

# 检查你需要的工具
check:
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo " 工具                │ 状态"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@for tool in latexmk xelatex pdflatex lualatex bibtex biber makeindex; do \
		if command -v $$tool >/dev/null 2>&1; then \
			if [ "$$tool" = "makeindex" ]; then \
				printf " %-20s│ ✅ 已安装：%s\n" "$$tool" "MakeIndex (版本未知，--version 不支持)"; \
			else \
				version=$$($$tool --version 2>/dev/null | head -n 1); \
				printf " %-20s│ ✅ 已安装：%s\n" "$$tool" "$$version"; \
			fi \
		else \
			printf " %-20s│ ❌ 未安装\n" "$$tool"; \
		fi; \
	done
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 主帮助命令
help:
	@echo ""
	@echo "📘 LaTeX Makefile 使用指南"
	@echo ""
	@echo "💡 已通过 VSCode 配置 tasks.json，可使用快捷键 Cmd+Shift+B 快速构建项目"
	@echo ""
	@echo "📂 所有中间文件和 PDF 输出目录为：build/"
	@echo "📄 编译日志已重定向至：build/compile_trace.log"
	@echo ""
	@echo "📦 可选命令说明："
	@echo ""
	@echo "┌────────────────────────┬────────────────────────────────────────────────────────────────┐"
	@echo "│ 命令                   │ 功能                                                           │"
	@echo "├────────────────────────┼────────────────────────────────────────────────────────────────┤"
	@echo "│ make 或 make all       │ 编译文档，统计工具调用次数，并复制 PDF 到根目录                │"
	@echo "│ make build             │ 使用 latexmk 编译 main.tex，输出到 build 文件夹                │"
	@echo "│ make report            │ 从编译日志中统计 xelatex、bibtex 等工具的调用次数              │"
	@echo "│ make pdfcopy           │ 将生成的 PDF 从 build/main.pdf 复制为 ./main.pdf               │"
	@echo "│ make tikz F=xx         │ 编译 TikZ 子图 pictures/tikz/xx.tex，并清理中间文件            │"
	@echo "│ make md2tex            │ 将 code/source.md 中的代码块转换为可供 Beamer 使用的代码块     │"
	@echo "│ make check             │ 检查 latexmk/xelatex/bibtex 等工具是否安装及其版本             │"
	@echo "│ make help 或 make h    │ 打印本帮助菜单                                                 │"
	@echo "└────────────────────────┴────────────────────────────────────────────────────────────────┘"

# 别名目标
h: help