.PHONY: help createpackage
.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT
BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

clean: clean-dist ## remove everything
	rm -fr dist/

clean-dist: ## remove packaged distribution file
	rm -fr dist/ndex-*

dist: clean-dist ## builds package
	@echo "Creating tar file"
	./buildndex.sh
	./createtar.sh
 
