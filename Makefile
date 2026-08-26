TAP_NAME := 3leaps/tap
FORMULA_DIR := Formula
UPDATE_SCRIPT := ./scripts/update-formula.sh
TAG ?=

.PHONY: help update update-decernor update-kitfly update-gonimbus update-mdmeld update-seclusor audit test test-updater clean clean-tap style precommit release

help:
	@echo "3 Leaps Homebrew Tap"
	@echo ""
	@echo "Usage:"
	@echo "  make update APP=kitfly TAG=vX.Y.Z  Update a formula to a published GitHub release"
	@echo "  make update-decernor TAG=vX.Y.Z     Update decernor"
	@echo "  make update-kitfly          Update kitfly"
	@echo "  make update-gonimbus        Update gonimbus"
	@echo "  make update-mdmeld          Update mdmeld"
	@echo "  make update-seclusor        Update seclusor"
	@echo "  make style                  Run Ruby style checks"
	@echo "  make test-updater           Run updater tests"
	@echo "  make audit APP=kitfly       Run brew audit on one formula"
	@echo "  make test APP=kitfly        Install and test one formula locally"
	@echo "  make clean APP=kitfly       Uninstall one formula"
	@echo "  make clean-tap              Untap the local tap"
	@echo "  make precommit              Run local quality checks"
	@echo "  make release APP=kitfly     Update + style + audit + test"

update:
ifndef APP
	$(error APP is required. Usage: make update APP=kitfly)
endif
	@$(UPDATE_SCRIPT) "$(APP)" "$(TAG)"

update-decernor:
	@$(MAKE) update APP=decernor TAG="$(TAG)"

update-kitfly:
	@$(MAKE) update APP=kitfly

update-gonimbus:
	@$(MAKE) update APP=gonimbus

update-mdmeld:
	@$(MAKE) update APP=mdmeld

update-seclusor:
	@$(MAKE) update APP=seclusor

style:
	@brew style .

test-updater:
	@bash tests/update-formula_test.sh

audit:
ifndef APP
	$(error APP is required. Usage: make audit APP=kitfly)
endif
	@brew tap $(TAP_NAME) $(CURDIR) 2>/dev/null || true
	@mkdir -p $$(brew --repository $(TAP_NAME))/Formula
	@cp $(FORMULA_DIR)/$(APP).rb $$(brew --repository $(TAP_NAME))/Formula/$(APP).rb
	brew audit --strict $(APP)

test:
ifndef APP
	$(error APP is required. Usage: make test APP=kitfly)
endif
	@brew tap $(TAP_NAME) $(CURDIR) 2>/dev/null || true
	@mkdir -p $$(brew --repository $(TAP_NAME))/Formula
	@cp $(FORMULA_DIR)/$(APP).rb $$(brew --repository $(TAP_NAME))/Formula/$(APP).rb
	brew reinstall --formula $(APP)
	brew test $(APP)

clean:
ifndef APP
	$(error APP is required. Usage: make clean APP=kitfly)
endif
	@brew uninstall --formula $(APP) || true

clean-tap:
	@brew untap $(TAP_NAME) 2>/dev/null || true

precommit: style test-updater
	@for formula in $(FORMULA_DIR)/*.rb; do \
		app=$$(basename "$$formula" .rb); \
		$(MAKE) audit APP="$$app"; \
	done

release:
ifndef APP
	$(error APP is required. Usage: make release APP=kitfly)
endif
	@$(MAKE) update APP=$(APP)
	@$(MAKE) style
	@$(MAKE) audit APP=$(APP)
	@$(MAKE) test APP=$(APP)
