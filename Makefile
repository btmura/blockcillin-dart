GCLOUD=DOCKER_HOST=unix:///var/run/docker.sock gcloud preview app

.PHONY: run
run:
	$(GCLOUD) run app.yaml

.PHONY: serve
serve:
	pub serve web --hostname 172.17.42.1 --port 7777

.PHONY: deploy
deploy:
	pub build
	$(GCLOUD) deploy app.yaml
