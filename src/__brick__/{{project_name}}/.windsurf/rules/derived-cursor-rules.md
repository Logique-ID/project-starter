---
trigger: model_decision
description: AI rules derived by SpecStory from the project AI interaction history
globs: *
---

## PROJECT OVERVIEW

This file defines the project rules, coding standards, workflow guidelines, references, documentation structure, and best practices for the AI coding assistant. It is a living document that evolves with the project.

## CODE STYLE

*   Follow the Dart style guide.
*   Use effective comments and documentation.
*   Ensure consistent naming conventions. Firebase's recommended pattern uses past tense for user actions and prefixes for app lifecycle events.

## FOLDER ORGANIZATION

(No specific rules defined yet)

## TECH STACK

*   Dart
*   Flutter
*   Riverpod
*   Firebase Analytics

## PROJECT-SPECIFIC STANDARDS

*   When implementing analytics, use the Facade pattern with an `AnalyticsClient` abstraction.
*   Implementations should include `FirebaseAnalyticsClient` and `LoggerAnalyticsClient` for production and debug logging, respectively.
*   Riverpod providers should be correctly configured, for example with `keepAlive: true` when appropriate.
*   When dispatching events to multiple analytics clients, use parallel execution (e.g., `Future.wait(clients.map(work))`) for improved performance.

## WORKFLOW & RELEASE RULES

*   When generating Firebase configuration files using `flutterfire config`, ensure that analytics is enabled. If the command doesn't have a direct flag for `IS_ANALYTICS_ENABLED`, add a post-processing step to modify the generated plist files using `plutil` (macOS) or `sed`.

## REFERENCE EXAMPLES

(No specific rules defined yet)

## PROJECT DOCUMENTATION & CONTEXT SYSTEM

(No specific rules defined yet)

## DEBUGGING

*   Use `LoggerAnalyticsClient` for debug-mode logging of analytics events.
*   When using `GoRouter`, integrate `LoggerNavigatorObserver` into the observers list to enable screen view tracking in debug logs.
*   If analytics reports are missing, check the implementation for semantic correctness and ensure events are being triggered as expected. Also, verify the correct initialization of analytics and that the `trackLogin()` function is called upon login.
*   When debugging analytics issues, check:
    *   The initialization of the analytics client.
    *   That the `LoggerNavigatorObserver` is added to `GoRouter`'s observers.
    *   That the `trackLogin` function is called on login.
    *   Platform-specific configurations in `firebase.json`.
    *   That `IS_ANALYTICS_ENABLED` is set to `<true/>` in `GoogleService-Info.plist` files.

## FINAL DOs AND DON'Ts

*   **DO** ensure semantic correctness when tracking events (e.g., `trackLogin()` should be called on login, not `trackAppCreated()`).
*   **DO** ensure `IS_ANALYTICS_ENABLED` is set to `<true/>` in all `GoogleService-Info.plist` files.
*   **DON'T** forget to add the `LoggerNavigatorObserver()` to GoRouter observers.