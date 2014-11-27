FIND_BASE=find bin lib test web
ALL_SRCS=$(shell $(FIND_BASE) -name *.dart)
TEST_SRCS=$(shell $(FIND_BASE) -name *_test.dart)

.PHONY: serve
serve:
	goapp serve -host 0.0.0.0 -use_mtime_file_watcher

.PHONY: pub_serve
pub_serve:
	pub serve --port 9090

.PHONY: deploy
deploy:
	pub build
	goapp deploy -oauth

.PHONY: test
test:
	for test in $(TEST_SRCS); do dart $$test; done

