
.PHONY: test
test:
	xcodebuild test -scheme sourcery-plugin-example -destination 'platform=iOS Simulator'
