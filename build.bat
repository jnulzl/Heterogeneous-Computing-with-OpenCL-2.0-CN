@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM ============================================================================
REM  Heterogeneous Computing with OpenCL 2.0 中文版 —— 一键编译
REM  (Windows / TeX Live 2026 + latexminted)
REM
REM    build.bat        3 遍 xelatex，完成后清理 *.minted 缓存
REM    build.bat keep   3 遍 xelatex，保留缓存（改稿期间更快）
REM
REM  NOTE: latexminted 会为每个代码块缓存 <hash>.highlight.minted，
REM        保留缓存时重编译约 1–2 分钟/遍，清空后首遍约 10 分钟。
REM ============================================================================
set TEXBIN=D:\ProgramData\texlive\2026\bin\windows
set PYTHON=D:\anaconda3
set "PATH=%PYTHON%;%TEXBIN%;%PATH%"
set "PYTHONPATH="
for %%A in ("%~dp0.") do set "TEXMF_OUTPUT_DIRECTORY=%%~fA"
set "TEXMFOUTPUT=%TEXMF_OUTPUT_DIRECTORY%"
cd /d "%~dp0."

xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err
xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err
xelatex -shell-escape -interaction=nonstopmode -synctex=1 main.tex
if errorlevel 1 goto :err

echo.
echo Build finished. Output: main.pdf

REM ---------------------------------------------------------------------------
REM  Clean the minted cache (skip with: build.bat keep)
REM ---------------------------------------------------------------------------
if /i "%~1"=="keep" (
    echo minted cache kept.
    goto :done
)

set N=0
if exist "*.minted" (
    for %%F in ("*.minted") do (
        del /q "%%~fF" >nul 2>&1
        if not exist "%%~fF" set /a N+=1
    )
)
if exist "main.listing" del /q "main.listing" >nul 2>&1
echo Cleaned !N! minted cache file^(s^).
goto :done

:err
echo.
echo Build FAILED. See main.log
echo minted cache kept for debugging.
pause

:done
endlocal
