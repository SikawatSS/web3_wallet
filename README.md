# web3_wallet

A Web3 wallet Flutter application with local database caching using Drift.

## Prerequisites

Before running this project, ensure you have the following installed:

- **Dart SDK**: `^3.9.2` or higher
- **Flutter SDK**: `>=3.35.0` or higher

You can verify your installations by running:

```bash
dart --version
flutter --version
```

## Getting Started

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Drift Database Files

This project uses Drift for local database. Generate the required files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Setup Environment Variables

Create a `.env.development` file in the root directory:

```bash
cp .env.example .env.development
```

Then add your environment variables (e.g., API keys, Etherscan API key).

### 4. Run the Application

```bash
flutter run
```

## Features

- ✅ Web3 wallet balance tracking
- ✅ Token balance management
- ✅ Local database caching with Drift
- ✅ Cache-first loading strategy for better UX

## How to Run Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
# Widget tests
flutter test test/presentation/wallet/page/wallet_landing_page_test.dart

# BLoC tests
flutter test test/presentation/wallet/bloc/wallet_bloc_test.dart

# Repository tests
flutter test test/data/repositories/wallet_repository_impl_test.dart

# Property-based tests
flutter test test/domain/entities/balance_property_test.dart
flutter test test/domain/entities/token_balance_property_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### Generate Golden Files (UI Snapshot Tests)

```bash
flutter test --update-goldens test/presentation/wallet/widget/
```

### Test Categories

- **Unit Tests**: Domain entities, models, use cases
- **Widget Tests**: UI components, loading states, error handling
- **Integration Tests**: Repository implementations, data sources
- **BLoC Tests**: State management and event handling
- **Golden Tests** ✨ (Bonus): UI snapshot/visual regression tests
- **Property-Based Tests** ✨ (Bonus): Mathematical property verification with random inputs

### Bonus Tests Implemented

#### 1. Golden Tests (UI Snapshot Tests)

Golden tests capture screenshots of widgets and compare them to reference images to ensure UI consistency:

- **Wallet Address Display**: Verifies shortened address format (0x742d...0bEb) ✅
- **Balance Amount Widget**: Tests ETH and USD display with different values ✅
- **Token Card Widget**: Validates token symbol, name, and balance rendering ✅
- **Shimmer Loading States**: Ensures loading UI appears correctly ✅

**Location**: `test/presentation/wallet/widget/*_golden_test.dart`

#### 2. Property-Based Tests

Property-based tests verify mathematical properties and invariants using randomly generated inputs:

**Balance Properties** (`balance_property_test.dart`):

- ✅ Wei ↔ ETH conversion is always non-negative
- ✅ Zero wei always equals zero ETH
- ✅ Doubling wei amount doubles ETH amount (proportionality)
- ✅ USD conversion maintains correct proportions
- ✅ String formatting consistency
- ✅ Addition is commutative
- ✅ Very large balances do not overflow
- ✅ Equality is based on wei amount

**Token Balance Properties** (`token_balance_property_test.dart`):

- ✅ Token amount calculation is always non-negative
- ✅ Zero quantity always equals zero amount
- ✅ Doubling quantity doubles amount
- ✅ Handles all decimal places (1-18)
- ✅ String formatting is consistent
- ✅ Very small amounts do not underflow
- ✅ JSON serialization preserves all data

**Why Property-Based Testing?**

- Tests **general properties** instead of specific examples
- Uses **random/generated inputs** to find edge cases
- Verifies **mathematical invariants** (e.g., reversibility, proportionality)
- Provides **higher confidence** than example-based tests

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

### Layer Structure

```
lib/
├── domain/          # Business logic (entities, use cases, repository interfaces)
├── data/            # Data handling (models, data sources, repository implementations)
└── presentation/    # UI layer (BLoC, pages, widgets)
```

### Domain Layer

- **Entities**: Pure business objects (`Balance`, `TokenBalance`)
- **Use Cases**: Single-responsibility business operations
- **Repository Interfaces**: Contracts for data operations

### Data Layer

- **Models**: Data transfer objects that extend entities
- **Remote Data Sources**: API integration (Etherscan)
- **Local Data Sources**: SQLite/Drift database operations
- **Repository Implementations**: Combine remote and local data sources

### Presentation Layer

- **BLoC**: Business Logic Component for state management
- **Pages**: Screen-level widgets
- **Widgets**: Reusable UI components

### Key Architectural Decisions

1. **Cache-First Strategy**

   - Load cached data immediately for instant UI feedback
   - Fetch fresh data in background and update UI
   - Fallback to cache when API fails

2. **Parallel Data Fetching**

   - Use `Future.wait()` to fetch balance and tokens simultaneously
   - Reduces total loading time
   - Independent error handling for each data source

3. **Error Resilience**

   - Continue operation when one API fails
   - Show error toast with retry option
   - Maintain shimmer state on error

4. **Dependency Injection**

   - Use GetIt for service locator pattern
   - Enables easy mocking in tests
   - Clear dependency graph

5. **Functional Error Handling**
   - Use `Either<Failure, Success>` pattern from dartz
   - Explicit error propagation
   - Type-safe error handling

## Technologies

- **State Management**: flutter_bloc
- **Local Database**: Drift (SQLite)
- **Dependency Injection**: get_it
- **API Client**: dio
- **Functional Programming**: dartz
- **Testing**: mocktail, bloc_test
