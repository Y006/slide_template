# API 来源: https://platform.closeai-asia.com

from openai import OpenAI
from datetime import datetime
import os
import sys

API_KEY = "sk-..."  # ← 请替换为你的真实 API key
BASE_URL = "https://api.openai-proxy.org/v1"

def read_latex_log(filepath: str) -> str:
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read()

def build_prompt(log_text: str) -> str:
    return f"""
你是一个 LaTeX 编译专家。请你阅读下面的编译日志，提取并总结以下关键信息：

1. 编译是否成功？生成了几页？是否生成 PDF？
2. 所有错误（error），包括未定义命令、语法问题等，并指出出现的行号
3. 所有警告（warning），特别是：
   - 引用未定义（undefined citation）
   - 字符缺失（Missing character）
   - 公式/文本溢出（Overfull \\hbox）
4. BibTeX 是否成功？是否需要再次运行 XeLaTeX？
5. 给出改进建议，包括引用缺失、字体编码问题、Overfull 解决建议等

以下是日志内容，请按结构化方式回答：

--- BEGIN LOG ---
{log_text}
--- END LOG ---
""".strip()

def write_markdown(output_dir: str, content: str):
    os.makedirs(output_dir, exist_ok=True)
    timestamp = datetime.now().strftime("%Y-%m-%dT%H-%M")
    filename = f"latex_log_summary_{timestamp}.md"
    output_path = os.path.join(output_dir, filename)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"✅ 分析结果已写入: {output_path}")
    return output_path

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ 请传入 LaTeX 编译日志文件路径作为参数。示例：")
        print("   python latex-log-process.py output/building_log.log")
        sys.exit(1)

    log_path = sys.argv[1]
    if not os.path.exists(log_path):
        print(f"❌ 找不到指定的日志文件: {log_path}")
        sys.exit(1)

    client = OpenAI(api_key=API_KEY, base_url=BASE_URL)
    log_text = read_latex_log(log_path)
    prompt = build_prompt(log_text)

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        temperature=0.3,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )

    result = response.choices[0].message.content
    output_dir = os.path.dirname(log_path)
    filename = "latex_log_summary.md"
    output_path = os.path.join(output_dir, filename)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(result)
    print(f"✅ 分析结果已写入: {output_path}")