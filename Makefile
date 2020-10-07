.PHONY: docs
docs: docs_registry


.PHONY: docs_registry
docs_registry:
	make -C scripts/make-docs registry
