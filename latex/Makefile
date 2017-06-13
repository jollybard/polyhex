FILENAME = doc

$(FILENAME).pdf: $(FILENAME).tex
	pdflatex $(FILENAME).tex

.PHONY: all clean

all:
	pdflatex $(FILENAME).tex
	pdflatex $(FILENAME).tex

clean:
	rm -f *.aux *.log *.out $(FILENAME).pdf
