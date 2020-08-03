@echo off

SET SOURCE_DIR=.\src\
SET BASEFILENAME=Emotionally

IF /I "%1"=="all" GOTO all
IF /I "%1"=="pre" GOTO pre
IF /I "%1"=="pdf" GOTO pdf
IF /I "%1"=="html" GOTO html
IF /I "%1"=="clean" GOTO clean
IF /I "%1"=="manual" GOTO manual
IF /I "%1"=="" GOTO all
GOTO error

:all
	CALL make.bat pdf
	CALL make.bat html
	CALL make.bat clean
	CALL make.bat manual
	GOTO :EOF

:pre
	PUSHD "%SOURCE_DIR%" && py -3 helper.py scenarios && POPD
	GOTO :EOF

:pdf
	CALL make.bat pre
	PUSHD "%SOURCE_DIR%" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "%BASEFILENAME%.tex" && POPD
	PUSHD "%SOURCE_DIR%" && biber "%BASEFILENAME%" && POPD
	PUSHD "%SOURCE_DIR%" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "%BASEFILENAME%.tex" && POPD
	PUSHD "%SOURCE_DIR%" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "%BASEFILENAME%.tex" && POPD
	PUSHD "%SOURCE_DIR%" && XCOPY /Y "%BASEFILENAME%.pdf" ..  && POPD
	GOTO :EOF

:html
	CALL make.bat pre
	PUSHD "%SOURCE_DIR%" && pandoc "%BASEFILENAME%.tex" -f latex -t html -s -o "%BASEFILENAME%.html" --template _template.html -V lang=it -V title="System Documentation" --table-of-contents && POPD
	PUSHD "%SOURCE_DIR%" && XCOPY /Y "%BASEFILENAME%.html" ..  && POPD
	GOTO :EOF

:clean
	PUSHD "%SOURCE_DIR%" && DEL /Q *.bcf *.run.xml *.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg *.dvi *.glg *.gls *.ilg *.ind *.lof *.lot *.maf *.mtc *.mtc1 *.out *.synctex.gz "*.synctex(busy)" *.thm /F && POPD
	GOTO :EOF

:manual
	PUSHD "./user-manual/" && rake && POPD
	GOTO :EOF

:error
    IF "%1"=="" (
        ECHO make: *** No targets specified and no makefile found.  Stop.
    ) ELSE (
        ECHO make: *** No rule to make target '%1%'. Stop.
    )
    GOTO :EOF
