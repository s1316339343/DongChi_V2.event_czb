#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
build-doc.py — 把 技术文档.md 渲染成 技术文档.docx

为什么要有这个脚本：
    技术文档有三个载体（md / docx / pdf），手工同步必然漂移。
    这里以 md 为唯一源，docx 由脚本生成，pdf 再由 LibreOffice 从 docx 转出，
    保证三者内容一致、且随时可重新生成。

用法：
    <python> tools/build-doc.py 技术文档.md 技术文档.docx
"""

import re
import sys

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK
from docx.shared import Cm, Pt, RGBColor

CJK_FONT = "Microsoft YaHei"
CODE_FONT = "Consolas"
ACCENT = RGBColor(0xFF, 0x6B, 0x35)   # 与 App 主色一致
MUTED = RGBColor(0x66, 0x66, 0x66)

# ----------------------------------------------------------------- 字体工具


def set_run_font(run, name, size=None, bold=None, color=None):
    run.font.name = name
    if size is not None:
        run.font.size = Pt(size)
    if bold is not None:
        run.font.bold = bold
    if color is not None:
        run.font.color.rgb = color
    # 中文必须显式指定 eastAsia，否则 Word/WPS 会回退到默认字体
    rpr = run._element.get_or_add_rPr()
    rfonts = rpr.find('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}rFonts')
    if rfonts is None:
        from docx.oxml import OxmlElement
        rfonts = OxmlElement('w:rFonts')
        rpr.append(rfonts)
    rfonts.set('{http://schemas.openxmlformats.org/wordprocessingml/2006/main}eastAsia', name)


INLINE_RE = re.compile(r'(\*\*.+?\*\*|`[^`]+`)')


def add_inline(paragraph, text, size=10.5, base_bold=False, color=None):
    """处理 **粗体** 与 `代码` 两种行内标记"""
    for part in INLINE_RE.split(text):
        if not part:
            continue
        if part.startswith('**') and part.endswith('**') and len(part) > 4:
            run = paragraph.add_run(part[2:-2])
            set_run_font(run, CJK_FONT, size, True, color)
        elif part.startswith('`') and part.endswith('`') and len(part) > 2:
            run = paragraph.add_run(part[1:-1])
            set_run_font(run, CODE_FONT, size - 0.5, base_bold, RGBColor(0xC7, 0x25, 0x4E))
        else:
            run = paragraph.add_run(part)
            set_run_font(run, CJK_FONT, size, base_bold, color)


def shade(cell_or_par, hex_fill):
    from docx.oxml import OxmlElement
    from docx.oxml.ns import qn
    el = cell_or_par._element
    pr = el.find(qn('w:tcPr')) if el.tag.endswith('tc') else el.get_or_add_pPr()
    if pr is None:
        pr = OxmlElement('w:tcPr')
        el.append(pr)
    shd = OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), hex_fill)
    pr.append(shd)


# ----------------------------------------------------------------- 解析 markdown

def parse(md_text):
    """把 markdown 拆成块：heading / para / code / table / quote / bullet"""
    blocks = []
    lines = md_text.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if stripped.startswith('```'):
            i += 1
            buf = []
            while i < len(lines) and not lines[i].strip().startswith('```'):
                buf.append(lines[i])
                i += 1
            i += 1
            blocks.append(('code', '\n'.join(buf)))
            continue

        if stripped.startswith('#'):
            level = len(stripped) - len(stripped.lstrip('#'))
            blocks.append(('h', level, stripped[level:].strip()))
            i += 1
            continue

        if stripped.startswith('|') and i + 1 < len(lines) and re.match(r'^\s*\|[\s:\-|]+\|\s*$', lines[i + 1]):
            rows = []
            while i < len(lines) and lines[i].strip().startswith('|'):
                rows.append(lines[i].strip())
                i += 1
            blocks.append(('table', rows))
            continue

        if stripped.startswith('>'):
            buf = []
            while i < len(lines) and lines[i].strip().startswith('>'):
                buf.append(re.sub(r'^\s*>\s?', '', lines[i]))
                i += 1
            blocks.append(('quote', '\n'.join(buf)))
            continue

        if re.match(r'^\s*[-*]\s+', line):
            buf = []
            while i < len(lines) and re.match(r'^\s*[-*]\s+', lines[i]):
                buf.append(re.sub(r'^\s*[-*]\s+', '', lines[i]).strip())
                i += 1
            blocks.append(('bullets', buf))
            continue

        if stripped in ('', '---'):
            i += 1
            continue

        buf = []
        while i < len(lines):
            s = lines[i].strip()
            if (not s or s == '---' or s.startswith('#') or s.startswith('```')
                    or s.startswith('|') or s.startswith('>') or re.match(r'^\s*[-*]\s+', lines[i])):
                break
            buf.append(lines[i].strip())
            i += 1
        blocks.append(('para', ' '.join(buf)))
    return blocks


# ----------------------------------------------------------------- 渲染

def build(md_path, docx_path):
    with open(md_path, 'r', encoding='utf-8') as f:
        blocks = parse(f.read())

    doc = Document()

    # 页面：A4 + 适中页边距
    sec = doc.sections[0]
    sec.page_width = Cm(21.0)
    sec.page_height = Cm(29.7)
    sec.left_margin = Cm(2.2)
    sec.right_margin = Cm(2.2)
    sec.top_margin = Cm(2.0)
    sec.bottom_margin = Cm(2.0)

    # 正文默认样式
    normal = doc.styles['Normal']
    normal.font.name = CJK_FONT
    normal.font.size = Pt(10.5)
    normal.paragraph_format.line_spacing = 1.35
    normal.paragraph_format.space_after = Pt(4)

    # ---- 封面 ----
    for _ in range(4):
        doc.add_paragraph()

    t = doc.add_paragraph()
    t.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_run_font(t.add_run('懂 吃  DongChi'), CJK_FONT, 30, True, ACCENT)

    s = doc.add_paragraph()
    s.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_run_font(s.add_run('检索增强的饮食决策系统'), CJK_FONT, 15, False, RGBColor(0x33, 0x33, 0x33))

    doc.add_paragraph()
    s2 = doc.add_paragraph()
    s2.alignment = WD_ALIGN_PARAGRAPH.CENTER
    set_run_font(s2.add_run('技 术 文 档'), CJK_FONT, 20, True, RGBColor(0x22, 0x22, 0x22))

    for _ in range(6):
        doc.add_paragraph()

    meta = [
        ('参赛赛道', '第九届传智杯 · AI 创新应用挑战赛（个人赛）'),
        ('运行平台', 'HarmonyOS 6.0.2（API 22）｜ArkTS / ArkUI'),
        ('版本', '2.0.0'),
        ('代码仓库', 'github.com/s1316339343/DongChi_V2.event_czb'),
        ('文档版本', 'v2.0 · 2026-10-30'),
    ]
    for k, v in meta:
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        set_run_font(p.add_run(k + '：'), CJK_FONT, 10.5, True, MUTED)
        set_run_font(p.add_run(v), CJK_FONT, 10.5, False, RGBColor(0x44, 0x44, 0x44))

    doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)

    # ---- 章节速览（静态，不带页码）----
    h = doc.add_paragraph()
    set_run_font(h.add_run('章节速览'), CJK_FONT, 14, True, ACCENT)
    chapters = [b[2] for b in blocks if b[0] == 'h' and b[1] == 2]
    for idx, name in enumerate(chapters, 1):
        p = doc.add_paragraph()
        p.paragraph_format.line_spacing = 1.6
        set_run_font(p.add_run('%02d  ' % idx), CJK_FONT, 10.5, True, ACCENT)
        set_run_font(p.add_run(name), CJK_FONT, 10.5, False, RGBColor(0x33, 0x33, 0x33))
    doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)

    # ---- 正文 ----
    first_h1 = True
    skipped_meta_quote = False
    for blk in blocks:
        kind = blk[0]

        if kind == 'quote' and not skipped_meta_quote:
            # 文首那段元信息（赛道/平台/仓库）已由封面承载，正文不再重复
            skipped_meta_quote = True
            continue

        if kind == 'h':
            level, text = blk[1], blk[2]
            if level == 1:          # 文档主标题已在封面呈现，正文跳过
                continue
            p = doc.add_paragraph()
            if level == 2:
                if first_h1:
                    p.paragraph_format.space_before = Pt(6)
                else:
                    p.add_run().add_break(WD_BREAK.PAGE)   # 每章另起一页
                p.paragraph_format.space_after = Pt(8)
                set_run_font(p.add_run(text), CJK_FONT, 17, True, RGBColor(0x1A, 0x1A, 0x1A))
                first_h1 = False
            elif level == 3:
                p.paragraph_format.space_before = Pt(12)
                p.paragraph_format.space_after = Pt(5)
                set_run_font(p.add_run(text), CJK_FONT, 13, True, ACCENT)
            else:
                p.paragraph_format.space_before = Pt(8)
                p.paragraph_format.space_after = Pt(4)
                set_run_font(p.add_run(text), CJK_FONT, 11.5, True, RGBColor(0x33, 0x33, 0x33))
            continue

        if kind == 'para':
            p = doc.add_paragraph()
            p.paragraph_format.space_after = Pt(6)
            add_inline(p, blk[1])
            continue

        if kind == 'bullets':
            for item in blk[1]:
                p = doc.add_paragraph()
                p.paragraph_format.left_indent = Cm(0.6)
                p.paragraph_format.space_after = Pt(3)
                set_run_font(p.add_run('• '), CJK_FONT, 10.5, False, ACCENT)
                add_inline(p, item)
            continue

        if kind == 'quote':
            p = doc.add_paragraph()
            p.paragraph_format.left_indent = Cm(0.5)
            p.paragraph_format.space_before = Pt(4)
            p.paragraph_format.space_after = Pt(8)
            add_inline(p, blk[1].replace('\n', ' '), size=10, color=MUTED)
            shade(p, 'F4F5F7')
            continue

        if kind == 'code':
            for line in blk[1].split('\n'):
                p = doc.add_paragraph()
                p.paragraph_format.left_indent = Cm(0.4)
                p.paragraph_format.space_after = Pt(0)
                p.paragraph_format.line_spacing = 1.05
                run = p.add_run(line if line else ' ')
                set_run_font(run, CODE_FONT, 8.5, False, RGBColor(0x33, 0x33, 0x33))
                shade(p, 'F6F7F9')
            doc.add_paragraph().paragraph_format.space_after = Pt(2)
            continue

        if kind == 'table':
            rows = [r for r in blk[1] if not re.match(r'^\|[\s:\-|]+\|$', r)]
            parsed = []
            for r in rows:
                cells = [c.strip() for c in r.strip('|').split('|')]
                parsed.append(cells)
            if not parsed:
                continue
            cols = max(len(r) for r in parsed)
            table = doc.add_table(rows=len(parsed), cols=cols)
            table.style = 'Table Grid'
            table.alignment = WD_TABLE_ALIGNMENT.CENTER
            for ri, row in enumerate(parsed):
                for ci in range(cols):
                    cell = table.cell(ri, ci)
                    text = row[ci] if ci < len(row) else ''
                    cell.text = ''
                    cp = cell.paragraphs[0]
                    cp.paragraph_format.space_after = Pt(2)
                    cp.paragraph_format.space_before = Pt(2)
                    cp.paragraph_format.line_spacing = 1.15
                    if ri == 0:
                        add_inline(cp, text, size=9, base_bold=True, color=RGBColor(0x22, 0x22, 0x22))
                        shade(cell, 'FFF1EA')
                    else:
                        add_inline(cp, text, size=9)
            doc.add_paragraph().paragraph_format.space_after = Pt(4)
            continue

    # ---- 页脚页码 ----
    footer_p = sec.footer.paragraphs[0]
    footer_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run = footer_p.add_run()
    set_run_font(run, CJK_FONT, 9, False, MUTED)
    fld = run._element.makeelement(
        '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}fldSimple',
        {'{http://schemas.openxmlformats.org/wordprocessingml/2006/main}instr': 'PAGE'})
    run._element.addnext(fld)

    doc.save(docx_path)
    print('写出 %s' % docx_path)


if __name__ == '__main__':
    md = sys.argv[1] if len(sys.argv) > 1 else '技术文档.md'
    out = sys.argv[2] if len(sys.argv) > 2 else '技术文档.docx'
    build(md, out)
