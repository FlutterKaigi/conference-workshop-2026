.PHONY: setup get run unit-test build-bundle generate

setup:
	fvm flutter config --enable-ios --enable-android --enable-web --no-enable-linux-desktop --no-enable-macos-desktop --no-enable-windows-desktop

get:
	fvm flutter pub get

run:
	fvm use && fvm flutter run

unit-test:
	fvm flutter test test/

build-bundle:
	fvm flutter build appbundle

generate:
	@echo "No code generation in this project."
