MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: run help

help:
	@echo "usage: make run MODULE=<module>"

run:
	@if [ -z "$(MODULE)" ]; then \
		echo "Error: MODULE is not specified."; \
		exit 1; \
	fi
	@if [ -z "$$TLA" ]; then \
		echo "Error: TLA environment variable is not set."; \
		exit 1; \
	fi
	@if [ ! -d "$(MODULE)" ]; then \
		echo "Error: Directory '$(MODULE)' does not exist"; \
		exit 1; \
	fi
	@if [ ! -f "$(MODULE)/$(MODULE).tla" ]; then \
		echo "Error: File '$(MODULE)/$(MODULE).tla' not found"; \
		exit 1; \
	fi
	@echo "Checking TLA+ module $(MODULE)..."
	@cd $(MODULE) && java -jar $$TLA $(MODULE).tla