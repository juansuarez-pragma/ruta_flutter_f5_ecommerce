# TRA-MIN-004: Use of Linters

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-MIN-004 |
| **Type** | Minimum (Mandatory) |
| **Description** | Use of Linters |
| **Associated Quality Attribute** | Maintainability |
| **Technology** | Flutter, Dart |
| **Responsible** | Mobile |
| **Capability** | Mobile |

---

## 1. Why (Business Justification)

### Business Rationale

> Reduces the number of errors, improves quality, and accelerates the development process, optimizing implementation times and costs for the business.

### Business Impact

#### Direct Cost Savings
- **25-35% reduction in code review time**: Automated style checks free reviewers to focus on logic
- **40% fewer bugs in production**: Linters catch common mistakes before they ship
- **Faster onboarding**: New developers follow consistent patterns automatically
- **Reduced technical debt**: Consistent code is easier to maintain and refactor

#### Quality Metrics Impact
| Metric | Without Linters | With Linters |
|--------|-----------------|--------------|
| Code review time per PR | 45-60 min | 20-30 min |
| Style-related comments in PR | 15-20 | 0-2 |
| Lint violations in legacy code | 500+ | < 10 |
| Developer consistency | Varies by person | Team-wide standard |

#### Industry Statistics
- Teams with strict linting report **30% fewer bugs** (Google internal study)
- **50% of code review comments** are about style issues that linters can catch
- Projects with linters have **2x higher contribution rates** from new developers

---

## 2. What (Technical Objective)

### Technical Goal

> Find errors, bad practices, or inconsistencies, and ensure code follows a consistent format style (like indentation and spacing). Obtaining clean, readable, and error-free code, facilitating collaboration and long-term maintenance.

### What Linters Detect

1. **Style Violations**: Naming conventions, indentation, spacing
2. **Potential Bugs**: Unused variables, unreachable code, type mismatches
3. **Performance Issues**: Unnecessary rebuilds, inefficient patterns
4. **Best Practice Violations**: Deprecated APIs, anti-patterns
5. **Accessibility Issues**: Missing semantics, contrast problems

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Use customized configurations for linters and static code analysis using
  libraries or tools specific to the technology that improve rule configuration
- Implement dependencies only for development compilation
- Validate coding rules and style guides to configure rules depending on
  project needs
```

### Linting Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                     DEVELOPMENT PHASE                            │
├─────────────────────────────────────────────────────────────────┤
│  IDE Integration                                                 │
│  ├── Real-time analysis while coding                            │
│  ├── Inline warnings and errors                                  │
│  └── Quick fixes suggestions                                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     PRE-COMMIT PHASE                             │
├─────────────────────────────────────────────────────────────────┤
│  Local Validation                                                │
│  ├── flutter analyze                                             │
│  ├── dart format --set-exit-if-changed .                        │
│  └── dart fix --dry-run                                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       CI/CD PHASE                                │
├─────────────────────────────────────────────────────────────────┤
│  Pipeline Validation                                             │
│  ├── flutter analyze --fatal-infos                              │
│  ├── dart format --output=none --set-exit-if-changed .          │
│  └── Block merge if violations found                             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Install flutter_lints

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_lints: ^5.0.0
```

### 4.2 Configure analysis_options.yaml

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

  errors:
    # Treat these as errors (block compilation)
    missing_required_param: error
    missing_return: error
    must_be_immutable: error

    # Treat these as warnings
    unused_import: warning
    unused_local_variable: warning
    dead_code: warning

    # Ignore specific rules if needed (use sparingly)
    # invalid_annotation_target: ignore

  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "build/**"
    - ".dart_tool/**"

linter:
  rules:
    # Error Prevention
    - avoid_empty_else
    - avoid_print
    - avoid_relative_lib_imports
    - avoid_returning_null_for_future
    - avoid_slow_async_io
    - avoid_types_as_parameter_names
    - avoid_web_libraries_in_flutter
    - cancel_subscriptions
    - close_sinks
    - empty_statements
    - hash_and_equals
    - no_duplicate_case_values
    - no_logic_in_create_state
    - prefer_void_to_null
    - throw_in_finally
    - unnecessary_statements
    - unrelated_type_equality_checks
    - use_key_in_widget_constructors
    - valid_regexps

    # Style
    - always_declare_return_types
    - always_put_required_named_parameters_first
    - avoid_bool_literals_in_conditional_expressions
    - avoid_catches_without_on_clauses
    - avoid_catching_errors
    - avoid_field_initializers_in_const_classes
    - avoid_function_literals_in_foreach_calls
    - avoid_init_to_null
    - avoid_null_checks_in_equality_operators
    - avoid_positional_boolean_parameters
    - avoid_private_typedef_functions
    - avoid_redundant_argument_values
    - avoid_renaming_method_parameters
    - avoid_return_types_on_setters
    - avoid_returning_null_for_void
    - avoid_returning_this
    - avoid_setters_without_getters
    - avoid_shadowing_type_parameters
    - avoid_single_cascade_in_expression_statements
    - avoid_unnecessary_containers
    - avoid_unused_constructor_parameters
    - avoid_void_async
    - await_only_futures
    - camel_case_extensions
    - camel_case_types
    - constant_identifier_names
    - curly_braces_in_flow_control_structures
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - exhaustive_cases
    - file_names
    - implementation_imports
    - library_names
    - library_prefixes
    - no_leading_underscores_for_library_prefixes
    - no_leading_underscores_for_local_identifiers
    - non_constant_identifier_names
    - null_closures
    - omit_local_variable_types
    - one_member_abstracts
    - only_throw_errors
    - overridden_fields
    - package_names
    - package_prefixed_library_names
    - parameter_assignments
    - prefer_adjacent_string_concatenation
    - prefer_collection_literals
    - prefer_conditional_assignment
    - prefer_const_constructors
    - prefer_const_constructors_in_immutables
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_constructors_over_static_methods
    - prefer_contains
    - prefer_equal_for_default_values
    - prefer_expression_function_bodies
    - prefer_final_fields
    - prefer_final_in_for_each
    - prefer_final_locals
    - prefer_for_elements_to_map_fromIterable
    - prefer_function_declarations_over_variables
    - prefer_generic_function_type_aliases
    - prefer_if_elements_to_conditional_expressions
    - prefer_if_null_operators
    - prefer_initializing_formals
    - prefer_inlined_adds
    - prefer_int_literals
    - prefer_interpolation_to_compose_strings
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_is_not_operator
    - prefer_iterable_whereType
    - prefer_mixin
    - prefer_null_aware_method_calls
    - prefer_null_aware_operators
    - prefer_relative_imports
    - prefer_single_quotes
    - prefer_spread_collections
    - prefer_typing_uninitialized_variables
    - provide_deprecation_message
    - recursive_getters
    - sized_box_for_whitespace
    - sized_box_shrink_expand
    - slash_for_doc_comments
    - sort_child_properties_last
    - sort_constructors_first
    - sort_unnamed_constructors_first
    - type_annotate_public_apis
    - type_init_formals
    - unawaited_futures
    - unnecessary_await_in_return
    - unnecessary_brace_in_string_interps
    - unnecessary_const
    - unnecessary_constructor_name
    - unnecessary_getters_setters
    - unnecessary_lambdas
    - unnecessary_late
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_null_checks
    - unnecessary_null_in_if_null_operators
    - unnecessary_nullable_for_final_variable_declarations
    - unnecessary_overrides
    - unnecessary_parenthesis
    - unnecessary_raw_strings
    - unnecessary_string_escapes
    - unnecessary_string_interpolations
    - unnecessary_this
    - unnecessary_to_list_in_spreads
    - use_colored_box
    - use_decorated_box
    - use_enums
    - use_full_hex_values_for_flutter_colors
    - use_function_type_syntax_for_parameters
    - use_if_null_to_convert_nulls_to_bools
    - use_is_even_rather_than_modulo
    - use_late_for_private_fields_and_variables
    - use_named_constants
    - use_raw_strings
    - use_rethrow_when_possible
    - use_setters_to_change_properties
    - use_string_buffers
    - use_super_parameters
    - use_test_throws_matchers
    - use_to_and_as_if_applicable
    - void_checks
```

### 4.3 Running Analysis

```bash
# Run static analysis
flutter analyze

# Run with strict mode (fails on infos)
flutter analyze --fatal-infos

# Check formatting
dart format --output=none --set-exit-if-changed .

# Auto-format code
dart format .

# Apply automatic fixes
dart fix --apply

# Preview fixes without applying
dart fix --dry-run
```

### 4.4 IDE Integration

#### VS Code (settings.json)
```json
{
  "dart.analysisExcludedFolders": [
    "**/*.g.dart",
    "**/*.freezed.dart"
  ],
  "editor.formatOnSave": true,
  "dart.lineLength": 80,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}
```

#### Android Studio / IntelliJ
1. Go to Preferences > Editor > Code Style > Dart
2. Set line length to 80
3. Enable "Format on save"
4. Configure dart analysis in Preferences > Languages & Frameworks > Dart

### 4.5 Pre-commit Hook Setup

```bash
# Install pre-commit hooks
# Create .git/hooks/pre-commit
#!/bin/sh

echo "Running Flutter analyze..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "Flutter analyze failed. Please fix issues before committing."
  exit 1
fi

echo "Checking formatting..."
dart format --output=none --set-exit-if-changed .
if [ $? -ne 0 ]; then
  echo "Code is not formatted. Run 'dart format .' before committing."
  exit 1
fi

echo "Pre-commit checks passed!"
exit 0
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

### 4.6 CI/CD Integration

```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.29.2'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Analyze project source
        run: flutter analyze --fatal-infos

      - name: Run tests
        run: flutter test
```

### 4.7 Custom Rules Example

```yaml
# analysis_options.yaml - Project-specific additions
linter:
  rules:
    # Enforce documentation for public APIs
    - public_member_api_docs

    # Require specific patterns
    - always_use_package_imports

    # Disable rules for specific project needs
    # prefer_relative_imports: false
```

---

## 5. Verification Checklist

### Setup
- [ ] `flutter_lints` added to dev_dependencies
- [ ] `analysis_options.yaml` created and configured
- [ ] IDE configured for real-time analysis
- [ ] Format on save enabled

### Rules Configuration
- [ ] Strict type inference enabled
- [ ] Generated files excluded from analysis
- [ ] Team-specific rules documented
- [ ] Critical rules set as errors (not warnings)

### Automation
- [ ] Pre-commit hook installed
- [ ] CI/CD pipeline includes analysis step
- [ ] Pipeline fails on lint violations
- [ ] Formatting check in pipeline

### Maintenance
- [ ] Zero lint violations in codebase
- [ ] New violations addressed before merge
- [ ] Rules reviewed periodically
- [ ] Team trained on lint rules

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Exponential fix cost**: Fixing lint issues after months of development can require touching hundreds of files.

2. **Inconsistent patterns**: Without linters, each developer introduces their own style, creating chaos.

3. **Code review burden**: Reviewers waste time on style issues instead of logic.

4. **Merge conflicts**: Different formatting styles cause unnecessary merge conflicts.

5. **Onboarding friction**: New developers struggle to understand inconsistent code.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| No linter setup | 500+ violations accumulated over time |
| Late introduction | Major refactoring needed, high risk |
| Inconsistent formatting | Merge conflicts, unreadable diffs |
| Ignored warnings | Warnings become bugs in production |
| No CI enforcement | Violations bypass code review |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Linter Configuration
**Interviewer:** "How do you configure linting in a Flutter project and why is it important?"

**Expected Answer:**
```
Linting configuration starts with flutter_lints package and analysis_options.yaml:

1. **Setup**: Add flutter_lints as dev_dependency and create analysis_options.yaml
   that includes the base rules from the package.

2. **Customization**: Enable strict type checking with strict-casts, strict-inference,
   and strict-raw-types. Add project-specific rules and exclude generated files.

3. **Severity levels**: Configure critical rules as errors (blocking), style rules
   as warnings. This ensures serious issues prevent compilation.

4. **Integration**: Hook into IDE, pre-commit, and CI/CD. Analysis should run at
   every stage of development.

Why it matters:
- Catches bugs before runtime (40% reduction in production bugs)
- Enforces team standards automatically
- Reduces code review time by 50%
- Makes onboarding faster for new developers
- Creates self-documenting code through consistent patterns
```

### Question 2: Handling Legacy Code
**Interviewer:** "How would you introduce linting to a project with existing code that has many violations?"

**Expected Answer:**
```
Introducing linting to legacy code requires a strategic approach:

1. **Assess current state**: Run flutter analyze to count violations.
   Prioritize by severity and frequency.

2. **Phased rollout**:
   - Phase 1: Start with errors only (missing_required_param, etc.)
   - Phase 2: Add critical warnings as errors
   - Phase 3: Enable style rules

3. **Auto-fix first**: Use 'dart fix --apply' to automatically fix
   safe issues like unnecessary_new, prefer_const_constructors.

4. **Baseline approach**: Initially ignore existing violations in specific
   files using // ignore_for_file: rule_name, but track them for later fix.

5. **Dedicated sprints**: Allocate time for lint cleanup in sprints.
   Make it part of regular maintenance.

6. **CI enforcement for new code**: Configure CI to fail on new violations
   while allowing existing baseline.

7. **Incremental improvement**: Set monthly targets for reducing violations.
   Track progress in dashboards.
```

### Question 3: Rule Selection
**Interviewer:** "How do you decide which lint rules to enable for a project?"

**Expected Answer:**
```
Rule selection should balance strictness with practicality:

1. **Start with official recommendations**: flutter_lints provides
   battle-tested defaults from the Flutter team.

2. **Categorize by impact**:
   - Safety rules (always enable): avoid_print, cancel_subscriptions, close_sinks
   - Performance rules (enable): prefer_const_constructors, sized_box_for_whitespace
   - Style rules (team decision): prefer_single_quotes, sort_constructors_first

3. **Consider project type**:
   - Library: Enable public_member_api_docs
   - App: May relax documentation rules
   - Enterprise: Stricter null safety rules

4. **Team discussion**: Rules affecting coding style should be team decisions.
   Document rationale for non-default choices.

5. **Review periodically**: As Dart/Flutter evolves, new rules become available.
   Review analysis_options.yaml quarterly.

6. **Escape hatches**: Provide documented ways to ignore rules when justified,
   but require code review for ignores.
```

### Question 4: CI/CD Integration
**Interviewer:** "How do you enforce linting in a CI/CD pipeline?"

**Expected Answer:**
```
CI/CD enforcement ensures consistent quality across all contributions:

1. **Pipeline steps**:
   - Format check: dart format --output=none --set-exit-if-changed .
   - Static analysis: flutter analyze --fatal-infos
   - Tests: flutter test

2. **Fail fast**: Put lint checks early in pipeline to fail quickly
   and save compute resources.

3. **Branch protection**: Configure GitHub/GitLab to require passing
   checks before merge.

4. **Informative output**: Configure analysis to show file:line:column
   format for easy IDE navigation.

5. **Caching**: Cache pub dependencies to speed up analysis.

6. **Parallel execution**: Run analysis, tests, and build in parallel
   when possible.

7. **PR comments**: Use actions that comment violations directly on PRs
   for easy visibility.

Example GitHub Actions:
- subosito/flutter-action for Flutter setup
- dart format with --set-exit-if-changed
- flutter analyze with --fatal-infos
```

### Question 5: Real Challenge Solved
**Interviewer:** "Tell me about a time when linting helped catch a significant bug"

**Expected Answer:**
```
In a payment processing feature, linting prevented a critical bug:

Situation:
We were implementing a subscription renewal flow. A developer wrote:

  Future<void> renewSubscription() async {
    final subscription = await getSubscription();
    processPayment(subscription.id);  // Missing await!
    updateUI();
  }

The bug:
- processPayment is async but wasn't awaited
- UI updated before payment completed
- Users saw "success" before payment actually processed
- Could lead to service access without payment

How linting helped:
- The 'unawaited_futures' rule flagged the issue
- IDE showed warning immediately during development
- CI would have caught it if developer missed IDE warning

Resolution:
- Added await to processPayment call
- Enabled 'unawaited_futures' as error (not warning)
- Added 'avoid_void_async' to catch similar patterns

Impact:
- Prevented potential revenue loss
- Avoided customer service issues
- Established pattern for team
- Zero similar bugs since enforcement
```

---

## 8. Anti-Patterns to Avoid

### 8.1 Ignoring All Warnings
```dart
// INCORRECT: analysis_options.yaml
analyzer:
  errors:
    unused_import: ignore
    unused_local_variable: ignore
    // Ignoring everything defeats the purpose!

// CORRECT: Fix issues or disable specific instances
// ignore: unused_local_variable
final debugValue = calculateDebug(); // Intentionally kept for debugging
```

### 8.2 No CI Enforcement
```yaml
# INCORRECT: Analysis not in pipeline
jobs:
  build:
    steps:
      - run: flutter build apk  # No analysis!

# CORRECT: Analysis before build
jobs:
  build:
    steps:
      - run: flutter analyze --fatal-infos
      - run: dart format --output=none --set-exit-if-changed .
      - run: flutter build apk
```

### 8.3 Inconsistent Team Configuration
```yaml
# INCORRECT: Each developer has different analysis_options.yaml

# CORRECT: Single analysis_options.yaml committed to repository
# All team members use same configuration
```

---

## 9. Additional Resources

### Official Documentation
- [Dart Linter Rules](https://dart.dev/tools/linter-rules)
- [Flutter Lints Package](https://pub.dev/packages/flutter_lints)
- [Effective Dart Style Guide](https://dart.dev/effective-dart/style)
- [Customizing Static Analysis](https://dart.dev/tools/analysis)

### Packages
- [flutter_lints](https://pub.dev/packages/flutter_lints) - Official Flutter lints
- [very_good_analysis](https://pub.dev/packages/very_good_analysis) - Stricter rules
- [lint](https://pub.dev/packages/lint) - Alternative strict rules

### Project References
- Alexandria: Linters - Flutter

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| analysis_options.yaml | Configuration file in repository |
| CI/CD logs | Pipeline showing successful analysis |
| flutter analyze output | Zero violations report |
| Pre-commit hook | Hook script in repository |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
