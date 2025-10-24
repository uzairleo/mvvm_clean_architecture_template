# MVVM Clean Architecture Template

Opinionated Flutter template that applies Clean Architecture principles with an MVVM presentation layer. Use it to bootstrap production-ready mobile apps with a clear separation of concerns, testable code, and scalable feature modules.

## Architecture At A Glance

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ Presentation │ --> │   Domain     │ --> │     Data      │
│ (View/ViewModel)   │ (Use Cases,  │     │ (Repositories,│
│                    │  Entities)   │ <-- │  Data Sources)│
└──────────────┘     └──────────────┘     └──────────────┘
```

![clean_architecture_extendedMVVM](https://github.com/user-attachments/assets/fcb25247-8715-4a1b-9cb6-f56c849471d2)


- **Presentation layer** owns UI, state, and navigation. Widgets talk only to ViewModels, which expose reactive state and delegate work to the domain layer.
- **Domain layer** is framework-agnostic. It contains entities, value objects, use cases, and repository interfaces. This layer defines *what* the app does.
- **Data layer** provides implementations for the repositories declared in the domain. It orchestrates remote APIs, local caches, and models to satisfy domain contracts. This layer decides *how* data is fetched or persisted.

## Folder Structure

- `lib/app/` – global app concerns (routing, themes, core utilities, DI setup).
- `lib/features/` – vertical feature modules (e.g., `auth`, `profile`), each with `presentation`, `domain`, and `data` subfolders.
- `lib/core/` – cross-cutting abstractions (failures, use case base classes, networking, storage).
- `lib/injection_container.dart` – service locator wiring for repositories, use cases, and view models.

## Layer Responsibilities

### Presentation (MVVM)
- Flutter widgets represent Views; they consume state from ViewModels.
- ViewModels contain UI logic only and expose inputs/outputs via `StateNotifier`, `ChangeNotifier`, `Stream`, or another reactive primitive used in the template.
- ViewModels depend on domain use cases, never on repositories or data sources directly.

### Domain
- Entities: business models without framework imports.
- Value Objects: small, immutable types that enforce invariants.
- Use Cases: single-action classes (e.g., `SendOtpUsecase`) with a `call()` method to keep intent explicit.
- Repository Contracts: abstract classes describing operations the domain needs; implemented in the data layer.

### Data
- Repository Implementations: fulfill domain contracts by orchestrating data sources and mapping DTOs to domain entities.
- Data Sources: remote (REST/GraphQL), local (cache, database), or platform services.
- Models: serializable representations of API or storage responses/requests.

## Working With The Template

1. **Clone & Install**
   ```bash
   flutter pub get
   ```
2. **Run the App**
   ```bash
   flutter run
   ```
3. **Analyze & Format**
   ```bash
   flutter analyze
   dart format .
   ```

## Extending The Template

1. **Create a Feature Module**
   - Add a new folder under `lib/features/<feature_name>/`.
   - Inside, scaffold `presentation/`, `domain/`, and `data/` subfolders.

2. **Define Domain Contracts**
   - Model entities and value objects.
   - Add use cases with a clear `call()` interface.
   - Declare repository interfaces describing required operations.

3. **Implement Data Layer**
   - Map API or local storage responses into domain models.
   - Use DTOs for serialization; keep domain models pure.
   - Provide repository implementations that satisfy domain contracts.

4. **Wire Dependencies**
   - Register new classes in `lib/injection_container.dart`.
   - Inject use cases into ViewModels via constructors to keep dependencies explicit.

5. **Build Presentation**
   - Create ViewModels that compose use cases.
   - Expose UI state streams or notifiers, handle loading/error states.
   - Connect widgets to ViewModels using your preferred state management solution.

## Testing Strategy

- **Domain tests**: pure unit tests for use cases and entities.
- **Data tests**: verify repositories and data sources (mock APIs, use integration tests for storage).
- **Presentation tests**: widget tests for UI, ViewModel tests for state transitions.

## Deployment & Environment

- Keep environment keys and endpoints inside configuration files under `lib/app/` or `lib/core/config/`.
- Inject environment-specific services at runtime via the DI container.
- Use flavors or build-time environment variables to swap implementations without touching domain code.

## Why This Matters

- Predictable scaling: each feature remains modular and self-contained.
- Testability: business logic lives in pure Dart classes.
- Replaceable infrastructure: swap APIs or persistence layers with minimal churn.
- Developer onboarding: consistent structure accelerates comprehension and collaboration.

Use this template as a baseline, adapting conventions (state management, networking, storage) to match your team’s preferences while preserving the core Clean Architecture separation.
