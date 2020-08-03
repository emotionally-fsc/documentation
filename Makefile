SOURCE_DIR = ./src/
BASEFILENAME = Emotionally

.PHONY: pdf html clean pre

all: pdf html clean manual

pre:
	cd "$(SOURCE_DIR)" && py -3 helper.py scenarios

pdf: pre
	cd "${SOURCE_DIR}" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "${BASEFILENAME}.tex"
	cd "$(SOURCE_DIR)" && biber "$(BASEFILENAME)"
	cd "${SOURCE_DIR}" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "${BASEFILENAME}.tex"
	cd "${SOURCE_DIR}" && pdflatex -synctex=1 -interaction=batchmode --shell-escape "${BASEFILENAME}.tex"
	cd "$(SOURCE_DIR)" && cp "$(BASEFILENAME).pdf" ..

html: pre
	cd "${SOURCE_DIR}" && pandoc "${BASEFILENAME}.tex" -f latex -t html -s -o "${BASEFILENAME}.html" --template _template.html -V lang=it -V title="System Documentation" --table-of-contents
	cd "$(SOURCE_DIR)" && cp "$(BASEFILENAME).html" ..

clean: 
	cd "$(SOURCE_DIR)" && rm -f *.bcf *.run.xml *.aux *.glo *.idx *.log *.toc *.ist *.acn *.acr *.alg *.bbl *.blg *.dvi *.glg *.gls *.ilg *.ind *.lof *.lot *.maf *.mtc *.mtc1 *.out *.synctex.gz "*.synctex(busy)" *.thm

manual:
	cd "./user-manual/" && rake
