###############################################################################
LATEX_MASTER=main
LATEX_MASTERFILE = $(LATEX_MASTER).tex
TARGER_PDF=$(LATEX_MASTER).pdf
#------------------
# TeX Live installation
TEXLIVE = docker run --rm -v $(PWD):/docs thorwink/texlive:2019
#------------------
# pdflatex
PDFLATEXBIN = $(TEXLIVE) pdflatex
PDFLATEXOPTS = -no-shell-escape -file-line-error -halt-on-error
#------------------
# biber
BIBERBIN= $(TEXLIVE) biber

###############################################################################
# Source files
TEXSRC = $(LATEX_MASTERFILE)

.PHONY: all test clean

compile : main.tex
	@echo "################################################################################"
	@echo "Compiling latex documents: RUN 1"
	$(PDFLATEXBIN) -draftmode $(PDFLATEXOPTS) $(LATEX_MASTERFILE) > $(LATEX_MASTER)_pass1.log
	@echo "################################################################################"
	@echo "BiBering"
	$(BIBERBIN) $(LATEX_MASTER)
	@echo "################################################################################"
	@echo "Compiling latex documents: RUN 2"
	$(PDFLATEXBIN) -draftmode $(PDFLATEXOPTS) $(LATEX_MASTERFILE) > $(LATEX_MASTER)_pass2.log
	@echo "################################################################################"
	@echo "Compiling latex documents: RUN 3"
	$(PDFLATEXBIN) $(PDFLATEXOPTS) $(LATEX_MASTERFILE)


all : clean compile

#https://www.gnu.org/software/make/manual/make.html#Foreach-Function
clean :
	@echo "################################################################################"
	@echo "Normal cleaning..."
	find . -type f \( \
			-name "*.aux" -o\
			-name "*.bbl" -o\
			-name "*.bcf" -o\
			-name "*.blg" -o\
			-name "*.run.xml" -o\
			-name "*.log" -o\
			-name "*.out" -o\
			-name "*.toc" \)\
			-exec rm '{}' \;
