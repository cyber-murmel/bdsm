NAME ?= firmware
PRJ_DIR ?= ../$(NAME)/

DOXYGEN ?= $(shell which doxygen)
SPHINX ?= $(shell which sphinx-build)


INCDIRS  =  $(PRJ_DIR)/inc/
INCDIRS  += $(PRJ_DIR)/lib/inc/
INCPATHS =  $(shell find $(INCDIRS) -type d)
HEADERS  =  $(wildcard $(addsuffix *.h,$(INCPATHS)))

DOXYGEN_INPUT   = $(INCDIRS)
DOXYGEN_OUTPUT  = ./doxygen/
DOXYGEN_INDEX = $(DOXYGEN_OUTPUT)/html/index.html

SPHINX_INPUT = ./
SPHINX_OUTPUT = ./sphinx
SPHINX_INDEX = $(SPHINX_OUTPUT)/index.html

all: sphinx

$(DOXYGEN_INDEX): ${HEADERS}
	cp Doxyfile.template Doxyfile
	sed --in-place --expression "s~{{ INPUT }}~$(DOXYGEN_INPUT)~g" Doxyfile
	sed --in-place --expression "s~{{ OUTPUT }}~$(DOXYGEN_OUTPUT)~g" Doxyfile
	$(DOXYGEN)

$(SPHINX_INDEX): $(DOXYGEN_INDEX) conf.py index.rst
	$(SPHINX) -b html -Dbreathe_projects.main=${DOXYGEN_OUTPUT}/xml/ $(SPHINX_INPUT) $(SPHINX_OUTPUT)

doxygen: $(DOXYGEN_INDEX)

sphinx: $(SPHINX_INDEX)

clean:
	rm -rf doxygen sphinx Doxyfile

.PHONY: all spinx doxygen clean 
