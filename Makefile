GCLOUD=DOCKER_HOST=unix:///var/run/docker.sock gcloud preview app

TEST_SRCS=$(shell find . -name *_test.dart)

.PHONY: run
run:
	$(GCLOUD) run app.yaml

.PHONY: serve
serve:
	pub serve web --hostname 172.17.42.1 --port 7777

.PHONY: test
test:
	for test in $(TEST_SRCS); do dart $$test; done

.PHONY: deploy
deploy:
	pub build
	$(GCLOUD) deploy app.yaml
