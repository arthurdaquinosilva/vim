VIM ?= vim

.PHONY: test

test:
	@rm -f test/results.tap; LOCAL_TEST_LOG=test/results.tap $(VIM) -Nu NONE -i NONE -n --not-a-term \
		-S test/run.vim </dev/null >/dev/null 2>&1; status=$$?; \
		cat test/results.tap 2>/dev/null || echo "no report: editor exited early"; exit $$status
