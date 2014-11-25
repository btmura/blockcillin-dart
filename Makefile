GCLOUD=DOCKER_HOST=unix:///var/run/docker.sock gcloud preview app

FIND_BASE=find bin lib test web
ALL_SRCS=$(shell $(FIND_BASE) -name *.dart)
TEST_SRCS=$(shell $(FIND_BASE) -name *_test.dart)

.PHONY: run
run:
	$(GCLOUD) run app.yaml

.PHONY: serve
serve:
	pub serve web --hostname 172.17.42.1 --port 7777

.PHONY: test
test:
	for test in $(TEST_SRCS); do dart $$test; done

.PHONY: fmt
fmt:
	dartfmt --write --transform --max_line_length Inf $(ALL_SRCS)

.PHONY: deploy
deploy:
	pub build
	$(GCLOUD) deploy app.yaml
