# AGENTS.md

This file provides guidance to Agent (AI Coding Agent) when working with code in this repository.

## Project overview

FlutterKaigi 2025 hands-on workshop repository: a mock "reading support" (読書支援) app used to teach layering animations/decoration on top of a plain base UI. Every presentation widget intentionally exists in three parallel variants (`default` / `challenge` / `complete`, see below). Do not "clean up" the duplication; it is the point of the workshop. The requirements are in `SPECIFICATION.md` (the single source of requirements; there is no `docs/` directory in this repository).

## Commands

The Flutter SDK is pinned with `fvm` (3.35.1, `.fvmrc`). Run commands through `fvm`, not a bare system `flutter`. There is no `Makefile` in this repository.

- Setup: `fvm install && fvm flutter pub get`
- Run: `fvm flutter run`
- All tests: `fvm flutter test test/`
- Single test file: `fvm flutter test test/riverpod_reading_books_widget_test.dart`
- Single test by name: `fvm flutter test test/riverpod_reading_books_widget_test.dart --plain-name 'addReadingBook smoke test'`
- Lint/type check: `fvm dart analyze`
- Build check (AGENTS.md requires `fvm dart analyze` plus a build before a change counts as done): `fvm dart analyze && fvm flutter build apk --debug`. A bare `flutter build` needs a target subcommand.
- Release Android app bundle: `fvm flutter build appbundle`

The project deliberately uses no code generation.

## Architecture

### Layers (strict top-down dependency)

Upper layers hold and depend on lower layers, never the reverse. A lower layer exposes only state-read and state-update interfaces upward.

```
lib/src
├── app/             App root (StagedWidget hosting MaterialApp.router) + screen/** page widgets
├── routing/         app_router.dart: GoRouter named routes, AppRoutes enum, context.goXxx() extensions
├── presentation/
│   ├── model/       ViewModels (Riverpod Notifiers) + barrel view_model_packages.dart
│   └── ui_widget/   UI widgets in default/ challenge/ complete/ + barrel widget_packages.dart
├── application/     ApplicationModel: creates/disposes domain models for the app lifetime
├── domain/model/    DomainModel, StateModel, ValueObjects
├── infrastructure/  near-empty on purpose (no persistence)
└── fundamental/     base classes: base_objects_model, equatable_utils, StagedWidget/ConsumerStagedWidget, error handling, debug_logger
```

### State flow: ViewModel → DomainModel → StateModel → ValueObject

- **Domain models are not Riverpod providers.** `readingBooksDomainModelProvider(approver, cycle: ...)` in `reading_books_domain_model.dart` is a plain function backed by a file-level global, and it is gated by `modelProvider()` in `fundamental/model/base_objects_model.dart`. Only `ApplicationModel` may `init`/`dispose` the model, and only `ReadingBooksViewModel` may `get` it. Any other caller throws `ArgumentError('Unauthorized approver.')`. A new domain model that needs a new accessor must be registered in that approver check.
- `ApplicationModel` is the widget state of the root `App` (`StagedWidget`). It initializes the domain model in `initState`.
- ViewModels are `Notifier<ValueObject>` behind `NotifierProvider`s (for example `readingBooksProvider`). The domain model knows nothing about Riverpod, so after mutating the domain a ViewModel must assign `state = _domainModel.stateModel.valueObject` itself to trigger UI rebuilds (see `commitReadingBook`).
- Book editing is a modal flow on the domain model: `select`/`create`/`add`/`update`/`remove` set an edit mode, and `commitReadingBook()` applies the change to the list and state model.
- `ReadingBooksState.init()` seeds hard-coded dummy books. There is no storage (the `FIXME`s are intentional for this mock).
- ValueObjects are immutable and hand-written: `props`, `==`/`hashCode` via `equatable_utils`, `copyWith`, `toJson`/`fromJson`. There is no freezed. Follow `reading_book_value_object.dart` when adding one.

### default / challenge / complete UI variants

`presentation/ui_widget/{default,challenge,complete}/` mirror each other with the same file and widget names. Page widgets import UI widgets only through the barrel `presentation/ui_widget/widget_packages.dart`. To switch the variant the app builds, change which single `export` line is uncommented in that barrel. All three variants share the ViewModels in `presentation/model/default/`, so only the widget layer differs.

- `default/`: plain base UI (normally the active export)
- `challenge/`: workshop exercise with gaps that participants fill in (see CHL-01 in `SPECIFICATION.md`)
- `complete/`: finished animated reference

When asked to work on "challenge" or "complete", edit that subtree and keep the three trees structurally parallel. The widget tests drive the real `App` and assert on the rendered UI, so run them with the `default` export active.

### StagedWidget / ConsumerStagedWidget

These live in `fundamental/ui_widget/` and replace `StatefulWidget`+`State` (instead of `hooks_riverpod`). A subclass declares an internal state type `T` and implements `createWidgetState`/`initState`/`disposeState`, and it receives `state` as a build parameter. It can observe the app lifecycle with `isWidgetsBindingObserve: true`. `ConsumerStagedWidget<R, T>` also takes a Riverpod `provider` constructor param, reads value `R`, and uses `selectBuild` to choose among `build`, `build2` … `build20`, so that rendering switches by state (for example progress thresholds). See `default/home/currently_tasks_widget.dart` for the canonical usage.

## Constraints (intentional; don't "fix")

- Dependencies are limited to `flutter_riverpod` and `go_router`. Do not add code generation (freezed, riverpod_generator, json_serializable) or `hooks_riverpod`.
- The rules from AGENTS.md: business logic goes in the domain/state/ViewModel layers, never in leaf UI widgets. Use Riverpod only (no BLoC or other patterns). Screen navigation uses GoRouter named routes only (add routes to `AppRoutes` + `AppRouterExtension`).
- No persistence, timers, or alarms. Behavior is faked.

## Testing

`test/` holds Riverpod unit tests (`ProviderContainer` via `createContainer()`) and widget smoke tests for add, update, and remove. Both inject a controlled initial state by building `ReadingBooksState(overrideValue:)` → `ReadingBooksDomainModel(overrideStateModel:)`. Unit tests pass it to `ApplicationModel(overrideReadingBooksDomain:)`, and widget tests pass it to `App(overrideReadingBooksDomain:)`. The helper file name `riverpod_unit_test_utillity.dart` contains an existing typo; keep it as is.

## Style

`analysis_options.yaml` builds on `flutter_lints` with a large rule set from FlutterKaigi 2024 and enables `strict-casts`/`strict-inference`/`strict-raw-types`. Notable rules:
- `always_specify_types` (annotate locals and generic literals, e.g. `<RouteBase>[...]`)
- `prefer_single_quotes`
- `require_trailing_commas`
- `always_put_control_body_on_new_line`
- 80-column lines

Code comments and doc comments are written in Japanese.
