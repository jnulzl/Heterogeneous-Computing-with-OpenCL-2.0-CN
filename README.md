# Heterogeneous Computing with OpenCL 2.0（中文翻译版 · LaTeX 工程）

把 Benedict R. Gaster 等人的 *Heterogeneous Computing with OpenCL 2.0*（第 3 版，Morgan Kaufmann, 2014）译为中文，
并按 Manning 风格模版重排为可直接编译的 LaTeX 源文件。

- 原书：*Heterogeneous Computing with OpenCL 2.0 — Developing Portable, High-Performance Applications*
- 作者：Benedict R. Gaster、Lee Howes、David R. Kaeli、Perhaad Mistry、Dana Schaa
- 中文名：**异构计算：基于 OpenCL 2.0**

---

## 模版来源

版式、字体、页边距、章首装饰、代码清单标题条、图注样式、页眉页脚等**全部沿用**
`D:/Ego/trans/CPP-17-STL-cookbook/latex_source`（Manning 风格模版，`book/ccs.tex`）。

相对模版只做了四处适配，均在 `book/ccs.tex` 里有注释说明：

| 改动 | 原因 |
|---|---|
| 新增 `\myFormula{宽}{图}{编号}` | 本书公式以图片给出，需要「居中 + 编号右对齐」的行间公式版式 |
| 新增 `myRefs` / `mySign` / `\myRefRule` | 译稿用「-----」分隔线引出节末注释与参考文献，需要小字悬挂缩进版式 |
| `\my_breakinject` 增加「:」为自然断点 | `concurrency::array_view` 这类标识符在 `::` 处折行，避免生切成 `con\|currency` |
| `\myGraphic` 由原地排版改为 `figure[!htbp]` 浮动体 | 原地「居中 + `\nopagebreak`」在页面快满时会把图注单独挤到下一页；改浮动后图与图注永不分离，且页底大块空白从 20 页（最大 400pt）降到 7 页（其中 6 页是章末自然留白） |

---

## 目录结构

```
latex_source/                     # 本目录即工程根
├── main.tex                      # 编译入口：\input{book/ccs.tex} + \subfile{book/index.tex}
├── build.bat                     # 一键编译：三遍 xelatex，成功后清理 *.minted 缓存
├── main.pdf                      # 编译成品（306 页）
├── images/                       # 84 张插图（按章分目录，全部从英文原版 PDF 400dpi 裁切）+ cover.jpg
├── tools/
│   └── convert.py                # Markdown → LaTeX 转换器（同时生成 index.tex；详见下文「校订与插图」）
└── book/
    ├── ccs.tex                   # 导言区：版式 / 字体 / 自定义命令与环境 / minted 缓存配置
    ├── index.tex                 # 章节装配（由 tools/convert.py 生成，勿手改）
    ├── manning-pygments-style.tex# 代码高亮配色
    └── content/
        ├── front/                # 00-cover（封面图）/ 00-title（书名页）/ foreword（序）
        └── main/                 # chapter1.tex … chapter13.tex
```

本次校订用的辅助脚本放在**工程根**的 `tools/`（与 `latex_source/tools/` 不是同一个目录），需从工程根运行：

| 脚本 | 作用 |
|---|---|
| `tools/extract_figures.py` | 从英文原版 PDF 裁切全部插图 → `images_src/<章>/<图号>.png`，并写出 `images_src/rects.json` |
| `tools/fix_captions.py` | 整批重写各章 `\myGraphic` 的图片路径、图注与宽度 |

> `book/content/*.tex` 目前是**唯一正本**：原 Markdown 译稿（`content/`）已不在工程内，且这些 tex 已包含人工校订，
> `tools/convert.py` 只用于首次生成或新增章节（`--chapter N`），**整体重跑会覆盖校订成果**。

> 正文源文件必须放 `book/content/` 下：`\subfile` 的相对基准是 `book/`，图片路径写作 `images/...`（相对工程根）。
> 上一级目录放原书 PDF（`Heterogeneous Computing with OpenCL 2.0.pdf`）、裁切出的插图（`images_src/`）与校订记录（`work/`）。

---

## 环境依赖

| 依赖 | 版本 / 说明 |
|---|---|
| TeX Live | 2026（`xelatex`、minted **v3** / `latexminted`、`tcolorbox`、`tabularx`、`booktabs`、`tikz`） |
| Python | 3.x + **Pygments**（`latexminted` 调它做语法高亮）；本机 `D:\anaconda3` |
| 中文字体 | **Source Han Serif SC（思源宋体）**、**Microsoft YaHei** |
| 拉丁字体 | Cambria、Franklin Gothic Medium |
| 等宽字体 | Consolas（`book/ccs.tex` 里写死 `C:/Windows/Fonts/consola*.ttf`） |

---

## 编译

```bat
build.bat          :: 三遍 xelatex，成功后删除 *.minted 缓存
build.bat keep     :: 三遍 xelatex，保留缓存（改稿期间更快）
```

手动编译时**必须**把 minted 缓存目录指成绝对路径：

```bash
export PATH="/d/anaconda3:/d/ProgramData/texlive/2026/bin/windows:$PATH"
export TEXMF_OUTPUT_DIRECTORY="D:/Ego/trans/Heterogeneous-Computing-with-OpenCL-2.0/latex_source"
export TEXMFOUTPUT="$TEXMF_OUTPUT_DIRECTORY"

xelatex -shell-escape -interaction=nonstopmode main.tex     # 跑三遍
```

- `-shell-escape` 是必须的（minted 调外部高亮器）。
- **必须三遍**：目录、书签、交叉引用要收敛；封面用 `remember picture` 定位。
- 耗时：缓存清空后首遍约 4–5 分钟（202 个代码块逐个高亮），第二、三遍各约 1 分钟。

---

## 校订与插图（2026-11-03）

以工程根的英文原版 PDF 为准，对译文和插图各做了一轮全面校订。

### 1. 译文校订：282 处

逐章对照英文原文核对，改动存于 `work/fix/ch01…ch13.json`（每条含 `file`/`line`/`before`/`after`/`why`，可回溯），
应用时强制校验「`before` 在该文件中恰好出现 1 次」，不满足即跳过。

| 类别 | 典型修正 |
|---|---|
| 术语统一 | work-item 工作项、work-group 工作组、kernel 内核、command-queue 命令队列、compute unit 计算单元、processing element 处理单元、local/constant/global/private memory 局部/常量/全局/私有内存、coalescing 合并访问、reduction 归约、barrier 栅栏 |
| 明显误译 | `波面阵` → `波前`（wavefront，53 处）；「线程块」→「线程束」（warp）；`一副`→`一幅`；`的的`→`的` |
| 语义/数量偏差 | 按原文补齐漏译的限定语、修正数量与单位、订正代码标识符拼写（`cl_mem` 等按 LaTeX 规则转义） |
| 体例统一 | `程序清单` → `代码清单`（31 处）；「表中展示了…」→「图中展示了…」 |

第 3 章另有一处结构性调整：clinfo 的输出在原书里是 **Listing 3.2**，中文版误排成了图，已改回 `codeboxt` 代码清单。

### 2. 插图全部重做

原工程的插图是随译稿仓库提供的位图（多为 EPUB 提取），分辨率偏低、与英文版图号也不完全对齐。现改为直接从英文原版 PDF 裁切：

- `tools/extract_figures.py`：逐页按 `FIGURE X.Y` 图注定位，把图注**上方**的视觉元素（位图、矢量绘图、小字号标注文字）求并集 →
  400 dpi 渲染 → 自动裁白边 → `images_src/<章>/<图号>.png`。页眉页脚横线（高 < 2pt 且宽 > 380pt）与正文字号（≥ 9.4pt）
  作为边界排除；5 处特殊版式（图上方紧跟代码块/表格、子图标注低于图体）用 `OVERRIDES` 手工限界。
- `tools/fix_captions.py`：整批重写 `\myGraphic` —— 路径换成 `images/chapter<N>/<N>-<M>.png`，图注按英文原版重译（81 条），
  宽度按图片宽高比自适应（`0.95 × w/h`，限制在 0.36–0.85 倍版心）。

结果：正文 84 张图（82 个 `\myGraphic` + 2 个 `\myFormula` 公式图），与英文原版图号一一对应。
两个特例：第 11 章原书的 11.1、11.3–11.7 是代码清单，中文版排成 `codeboxt`，只保留 11.2 为图；
书末二项期权柱状图为中文版增补，编号 **图 11.8**。

### 3. 排版检查结果

| 项目 | 结果 |
|---|---|
| 页数 | 306 页 |
| 编译错误 | 0 |
| Overfull box | 9 处，均 ≤ 9.7pt（表格单元格内一行字） |
| 图注分离 | 无（`figure[!htbp]` 浮动放置后彻底消除） |
| 页底大块空白（> 200pt） | 7 页，其中 6 页为章末自然留白 |

---

> 如果环境配置遇到问题或者编译失败可以直接到[releases](https://github.com/jnulzl/Heterogeneous-Computing-with-OpenCL-2.0-CN/releases)下载最新的pdf文件

Heterogeneous Computing with OpenCL 2.0
=========================
*Third Edition*
-------------------------
- 作者：David Kaeli, Perhaad Mistry, Dana Schaa, Dong Ping Zhang
- 译者：陈晓伟

## 本书概述

作为对《Heterogeneour Computing with OpenCL 2.0 (Thrid Edition)》英文版的中文翻译。

本书将介绍在复杂环境下的OpenCL和并行编程。这里的复杂环境包含多种设备架构，比如：多芯CPU，GPU，以及完全集成的加速处理单元(APU)。在本修订版中将包含OpenCL 2.0最新的改进：
- 共享虚拟内存(*Shared virtual memory*)可增强编程的灵活性，从而能大幅度减少在数据转换上所消耗的资源和精力 
- 动态并行(*Dynamic parallelism*)将减少处理器上的负载，并避免瓶颈出现
- 对图像的支持有很大改善，并且集成OpenGL

为了能在不同的平台上进行工作，OpenCL将有助你充分发挥出异构平台的能力。本书的作者们都是异构计算和OpenCL社区的佼佼者，本书涉及到的内容有：内存空间、优化技能、相关扩展、调试与分析。书中还会涉及多个实际的案例，来展示高性能的算法、异构系统如何分配工作，以及嵌入式领域特殊的语言。当然，也会让读者使用OpenCL来实现一些基本算法的并行版本：
- 使用最新OpenCL 2.0标准的特性，包括内存处理、动态并行和图像特性
- 对实际的程序进行测试和调试，从而对抽象的模型概念进行理解，并解释使用OpenCL进行并行编程的准则及策略
- 本书的案例包含：图像分析、Web插件、粒子模拟、视频编辑、性能优化，等等

## 本书作者

### David Kaeli

David Kaeli在罗格斯大学(Rutgers University)获得电气工程学士和博士学位，在雪城大学(Syracuse University)获得计算机工程硕士学位，并管理东北大学计算机体系研究室(NUCAR)。1993年Kaeli加入东北大学，他之前在IBM任职12年，任职的最后7年在T.J. Watson研究中心(位于纽约，约克敦海茨)度过。现在，在东北大学工程学院(本科)(位于美国东北部，马萨诸塞州，州府波士顿)任职副院长，为ECE(电子和计算机工程专业，Electrical and Computer Engineering)系的系主任。

Kaeli博士合著超过200个学术出版物，其研究领域跨度也非常大，从微体系结构到后端编译器和软件工程。他主导了很多GPU计算方面的研究项目，并且现在是IEEE技术委员会，计算机体系结构方面的主席。他也是IEEE院士，以及ACM(国际计算机学会，Association for Computing Machinery)成员。

### Perhaad Mistry

Perhaad Mistry作为AMD公司工具组开发成员，任职于在位于波士顿设计中心，主要研究异构结构下使用的调试和性能分析工具，现居波士顿。他目前主要研究的是“共享内存及离散式GPU平台”(将要到来的平台)上的调试工具的研究。自2007年CUDA0.8发布后，Perhaad就开始研究GPU的架构和并行计算。他很喜欢使用GPGPU来实现医学成像算法，以及设计外科模拟器的感知数据结构。Perhaad目前在为下一代GPU平台研究调试工具和性能分析工具。

David Kaeli博士曾在学校建议Perhaad加入NUCAR。虽然，已经离开东北大学已经7年(在东北大学电子和计算机工程专业取得博士学位)，但是Perhaad仍然是NUCAR的一员，并且在并行相关的性能分析项目上给出中肯的建议。其在孟买大学(印度3所历史最悠久、规模最大的综合性大学之一)获得电气工程学士学位，并在东北大学获得计算机工程硕士学位。

### Dana Schaa

Dana Schaa在加州州立理工大学(Cal Poly，位于神路易斯奥比斯波，旧金山和洛杉矶的中间位置)获得计算机工程学士学位，并在东北大学获得电子和计算机专业硕士和博士学位。他在AMD公司为GPU架构建模，并且对GPU的内存系统、微架构、性能分析和通用计算十分感兴趣，也在这些方面表现的相当专业。他开发了一些基于OpenCL的医学影像应用，从实时三维超声到异构CT(电子计算机断层扫描，Computed Tomography)图像重构。2010年，Dana与其女友Jenny完婚，现在他们和他们可爱的喵都住在圣何塞。

### 张东萍(Dong Ping Zhang)

东萍(音译)在英国帝国学院(Imperial College London)获得计算机博士学位。她博士期间的研究方向是“时域和空域上的大型多模态生物医学分析”。现任职与AMD公司，为“百亿亿次级计算研究组”工作。其研究方向和AMD公司“异构系统架构组”有着很密切的合作。

加入AMD公司之前，她在帝国学院计算机系做博士后研究。2006年，在先进计算方面获得理学硕士学位。2010年，在计算机科学方面获得博士学位。这两个学位均由Daniel Rueckert教授授予(Daniel Rueckert教授曾在医学图像分析领域获得“2010年度世界最佳导师”称号)。2009年，她还曾在鹿特丹Erasmus医学中心作为生物医学成像组成员，短暂的工作过一段时间。

## 本书相关

- github 翻译地址：https://github.com/xiaoweiChen/Heterogeneous-Computing-with-OpenCL-2.0
