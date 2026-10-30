MAKEFLAGS += --no-print-directory
BOOTSTRAP_DIR := .imported_make
BOOTSTRAP_FILE := bootstrap.makefile
BOOTSTRAP_PATH := $(BOOTSTRAP_DIR)/$(BOOTSTRAP_FILE)
BOOTSTRAP_URL := https://gitlab.com/fabriktor/pkg/-/raw/main/makefiles/$(BOOTSTRAP_FILE)
$(BOOTSTRAP_PATH):
	@mkdir -p $(BOOTSTRAP_DIR)
	@echo "Downloading $(BOOTSTRAP_FILE) into $(BOOTSTRAP_DIR)/..."
	@curl -sSfL $(BOOTSTRAP_URL)?ref_type=heads -o $@
-include $(BOOTSTRAP_PATH)
