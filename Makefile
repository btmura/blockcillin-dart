.PHONY: pub_serve
pub_serve:
	pub serve --port 9090

.PHONY: serve
serve:
	pub build
	goapp serve -host 0.0.0.0 -use_mtime_file_watcher

.PHONY: deploy
deploy:
	pub build
	goapp deploy -oauth
