.PHONY: pub_serve
pub_serve:
	pub serve --hostname 0.0.0.0 --port 9090

.PHONY: serve
serve:
	pub build
	goapp serve -host 0.0.0.0 -use_mtime_file_watcher

.PHONY: deploy
deploy:
	pub build
	goapp deploy -oauth

.PHONY: analyze
analyze:
	dartanalyzer --enable-enum lib/client.dart
