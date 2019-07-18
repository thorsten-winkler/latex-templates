###############################################################################
CURRENT_DIR_NAME=$(shell basename $(PWD))
LATEX_MASTER=$(CURRENT_DIR_NAME)
LATEX_MASTERFILE_TEX = $(LATEX_MASTER).tex
LATEX_MASTERFILE_PDF = $(LATEX_MASTER).pdf
TARGET_DIR=pdf
TARGET_PDF=$(TARGET_DIR)/$(LATEX_MASTERFILE_PDF)
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
TEXSRC = $(LATEX_MASTERFILE_TEX)

.PHONY: all addbib clean clean1 collect-styles debug rename

all : clean_deep collect-styles addbib compile rename clean1

compile : $(LATEX_MASTERFILE_TEX)
	@echo "####################################################################\
############"
	@echo "Compiling latex documents: RUN 1"
	$(PDFLATEXBIN) -draftmode $(PDFLATEXOPTS) $(LATEX_MASTERFILE_TEX) >\
$(LATEX_MASTER)_pass1.log
	@echo "####################################################################\
############"
	@echo "BiBering"
	$(BIBERBIN) $(LATEX_MASTER)
	@echo "####################################################################\
############"
	@echo "Compiling latex documents: RUN 2"
	$(PDFLATEXBIN) -draftmode $(PDFLATEXOPTS) $(LATEX_MASTERFILE_TEX) > $(LATEX_MASTER)_pass2.log
	@echo "################################################################################"
	@echo "Compiling latex documents: RUN 3"
	$(PDFLATEXBIN) $(PDFLATEXOPTS) $(LATEX_MASTERFILE_TEX)

#https://www.gnu.org/software/make/manual/make.html#Foreach-Function
clean clean1 :
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

clean_deep : clean
	@echo "################################################################################"
	@echo "Deep cleaning..."
	find . -type f -name "*.pdf" -exec rm '{}' \;
	rm -rf styles

addbib : collect-styles
	@echo "################################################################################"
	@echo "Add bibliography file $(LATEX_MASTER).bib"
	touch "$(LATEX_MASTER).bib"
	@echo "Add $(LATEX_MASTER).bib to $(LATEX_MASTERFILE_TEX)"
	sed -i '.bak' 's/__BIB-PLACEHOLDER__/$(LATEX_MASTER).bib/g' $(LATEX_MASTERFILE_TEX)

collect-styles :
	@echo "################################################################################"
	@echo "Collect styles and templates ($(LATEX_MASTERFILE_TEX))"
	cp -r ../styles .
	cp ../$(LATEX_MASTERFILE_TEX) .

debug : clean_deep collect-styles addbib compile rename

rename :
	@echo "################################################################################"
	@echo "Move $(LATEX_MASTERFILE_PDF) to $(TARGET_PDF)"
	mkdir -p $(TARGET_DIR)
	mv $(LATEX_MASTERFILE_PDF) $(TARGET_PDF)
