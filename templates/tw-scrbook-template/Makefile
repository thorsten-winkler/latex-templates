################################################################################
# Each output master/pdf document will be called like the directory where it
# resides
CURRENT_DIR_NAME=$(shell basename $(PWD))
LATEX_MASTER=$(CURRENT_DIR_NAME)
LATEX_MASTERFILE_TEX = $(LATEX_MASTER).tex
LATEX_MASTERFILE_PDF = $(LATEX_MASTER).pdf
# The name of the template you choose and the directory where all template
# folders located
TEMPLATE=tw-scrbook-template
TEMPLATE_DIR=../../templates
TEMPLATE_TEX=$(TEMPLATE).tex
# The name of the folder, where the output PDF will be created
TARGET_DIR=pdf
TARGET_PDF=$(TARGET_DIR)/$(LATEX_MASTERFILE_PDF)
# The directory and name of the overall style folder
STYLE_FOLDER_NAME=styles
STYLE_FOLDER_DIR=../../$(STYLE_FOLDER_NAME)
#------------------
# Dockerized TeX Live installation
# 	- https://github.com/thorsten-winkler/docker-texlive
TEXLIVE = docker run --rm -v $(PWD):/docs thorwink/texlive:2019
#------------------
# pdflatex
PDFLATEXBIN = $(TEXLIVE) pdflatex
PDFLATEXOPTS = -no-shell-escape -file-line-error -halt-on-error
#------------------
# makeglossaries
MKGLOSS = $(TEXLIVE) makeglossaries
#------------------
# biber
BIBERBIN= $(TEXLIVE) biber

################################################################################
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
	@echo "Making glossaries" && $(MKGLOSS) $(LATEX_MASTER) >>\
$(LATEX_MASTER)_pass1.log
	@echo "####################################################################\
############"
	@echo "BiBering"
	$(BIBERBIN) $(LATEX_MASTER)
	@echo "####################################################################\
############"
	@echo "Compiling latex documents: RUN 2"
	$(PDFLATEXBIN) -draftmode $(PDFLATEXOPTS) $(LATEX_MASTERFILE_TEX) >\
$(LATEX_MASTER)_pass2.log
	@echo "####################################################################\
############"
	@echo "Compiling latex documents: RUN 3" >\
$(LATEX_MASTER)_pass3.log
	$(PDFLATEXBIN) $(PDFLATEXOPTS) $(LATEX_MASTERFILE_TEX)

#https://www.gnu.org/software/make/manual/make.html#Foreach-Function
clean clean1 :
	@echo "####################################################################\
############"
	@echo "Normal cleaning..."
	find . -type f \( \
			-name "*.aux" -o\
			-name "*.acri" -o\
			-name "*.acrl" -o\
			-name "*.acro" -o\
			-name "*.bak" -o\
			-name "*.bbl" -o\
			-name "*.bcf" -o\
			-name "*.blg" -o\
			-name "*.run.xml" -o\
			-name "*.ist" -o\
			-name "*.log" -o\
			-name "*.lol" -o\
			-name "*.out" -o\
			-name "*.toc" \)\
			-exec rm '{}' \;

clean_deep : clean
	@echo "####################################################################\
############"
	@echo "Deep cleaning..."
	find . -type f -name "*.bak" -exec rm '{}' \;
	find . -type f -name "*.pdf" -exec rm '{}' \;
	rm -rf $(STYLE_FOLDER_NAME) $(LATEX_MASTERFILE_TEX)

addbib : collect-styles
	@echo "####################################################################\
############"
	@echo "Add bibliography file $(LATEX_MASTER).bib"
	touch "$(LATEX_MASTER).bib"
	@echo "Add $(LATEX_MASTER).bib to $(LATEX_MASTERFILE_TEX)"
	sed -i '.bak' 's/__BIB-PLACEHOLDER__/$(LATEX_MASTER).bib/g' \
$(LATEX_MASTERFILE_TEX)

collect-styles :
	@echo "####################################################################\
############"
	@echo "Collect styles and templates ($(LATEX_MASTERFILE_TEX))"
	cp -r ../../$(STYLE_FOLDER_NAME) .
	cp $(TEMPLATE_DIR)/$(TEMPLATE_TEX) .
	mv $(TEMPLATE_TEX) $(LATEX_MASTERFILE_TEX)

debug : clean_deep collect-styles addbib compile rename

rename :
	@echo "####################################################################\
############"
	@echo "Move $(LATEX_MASTERFILE_PDF) to $(TARGET_PDF)"
	mkdir -p $(TARGET_DIR)
	mv $(LATEX_MASTERFILE_PDF) $(TARGET_PDF)
