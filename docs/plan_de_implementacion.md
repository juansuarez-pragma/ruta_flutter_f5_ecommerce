# Plan de Implementación - Fase 5 E-Commerce

**Objetivo:** Completar el 100% de los requerimientos de la Fase 5 siguiendo enfoque TDD (Test-Driven Development).

**Fecha:** 16 de diciembre de 2025

---

## Resumen Ejecutivo

| Aspecto | Estado Actual | Meta |
|---------|---------------|------|
| Requerimientos completados | 64% (9/14) | 100% (14/14) |
| Cobertura de tests | ~20% | >80% |
| Features implementadas | 7/9 | 9/9 |

### Requerimientos Pendientes

| # | Requerimiento | Estado | Prioridad |
|---|--------------|--------|-----------|
| 1 | Auth (Login/Registro) | ❌ No implementado | ALTA |
| 2 | Soporte/Contacto | ❌ No implementado | ALTA |
| 3 | Diseño Responsivo | ⚠️ Parcial | MEDIA |
| 4 | Diagrama de Flujo Visual | ⚠️ Parcial | MEDIA |
| 5 | Documentación Completa | ⚠️ Parcial | BAJA |

### Decisiones Técnicas

| Decisión | Elección | Justificación |
|----------|----------|---------------|
| **Auth Backend** | Mock local con SharedPreferences | Sin dependencia de API externa, funciona offline |
| **Testing E2E** | Unit/Widget + integration_test | Simplicidad, sin configuración nativa adicional |
| **Diagramas** | Mermaid en Markdown | Versionable, renderiza en GitHub/GitLab |

---

## Arquitectura de Pruebas

### Pirámide de Testing

```
                   ┌─────────────┐
                  /│ Integration │\   ← flutter integration_test
                 / │   Tests     │ \     10-15 tests (flujos completos)
                /  └─────────────┘  \
               /   ┌─────────────┐   \
              /    │   Widget    │    \  ← Widget Tests
             /     │   Tests     │     \    40-50 tests
            /      └─────────────┘      \
           /       ┌─────────────┐       \
          /        │    Unit     │        \  ← Unit Tests (BLoC, UseCase)
         /         │    Tests    │         \    80-100 tests
        ───────────┴─────────────┴───────────
```

### Niveles de Testing

| Nivel | Framework | Alcance | Cantidad |
|-------|-----------|---------|----------|
| **Unit** | flutter_test + mocktail | UseCases, Entities, Models, Repositories | 80-100 |
| **BLoC** | bloc_test | BLoC states/events transitions | 30-40 |
| **Widget** | flutter_test | Widgets individuales y páginas | 40-50 |
| **Integration** | integration_test | Flujos multi-página completos | 10-15 |

### Patrones de Testing

**Patrón AAA (Arrange-Act-Assert):**
```dart
test('should return user when login is successful', () async {
  // Arrange
  when(() => mockRepository.login(email, password))
      .thenAnswer((_) async => Right(user));

  // Act
  final result = await useCase(email: email, password: password);

  // Assert
  expect(result, Right(user));
  verify(() => mockRepository.login(email, password)).called(1);
});
```

**Patrón BLoC Test:**
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] when login succeeds',
  build: () {
    when(() => mockLoginUseCase(any(), any()))
        .thenAnswer((_) async => Right(user));
    return authBloc;
  },
  act: (bloc) => bloc.add(LoginRequested(email: email, password: password)),
  expect: () => [const AuthLoading(), AuthAuthenticated(user: user)],
);
```

---

## Flujos Críticos para Pruebas de Integración

### Prioridad ALTA

| # | Flujo | Ruta | Tipo |
|---|-------|------|------|
| 1 | **Checkout Completo** | Home → Producto → Add to Cart → Cart → Checkout → Confirmación | Integration |
| 2 | **Auth Flow** | Register → Login → Logout → Login | Integration |
| 3 | **Búsqueda → Compra** | Search → Resultados → Producto → Cart | Integration |

### Prioridad MEDIA

| # | Flujo | Ruta | Tipo |
|---|-------|------|------|
| 4 | **Navegación Principal** | Home → Categories → Products → Detail | Integration |
| 5 | **Gestión de Carrito** | Add → Update quantity → Remove → Clear | Integration |
| 6 | **Historial de Órdenes** | Checkout → Order History → Ver orden | Integration |
| 7 | **Soporte** | Soporte → FAQ → Contacto → Enviar mensaje | Integration |

### Prioridad BAJA (Widget Tests suficientes)

| # | Flujo | Descripción | Tipo |
|---|-------|-------------|------|
| 8 | Pull to Refresh | Refresh en Home | Widget |
| 9 | Error Recovery | Error → Retry → Success | Widget |
| 10 | Responsive Layout | Diferentes tamaños de pantalla | Widget |

---

## Checklist de Implementación TDD

### FASE 1: Infraestructura de Testing

#### 1.1 Configuración de Integration Tests
- [ ] Agregar `integration_test` a pubspec.yaml
- [ ] Crear estructura `integration_test/`
- [ ] Test de verificación: `app_test.dart` básico
- [ ] Configurar test helpers para integration tests

#### 1.2 Ampliar Test Helpers
- [ ] Crear fixtures para Auth (`UserFixtures`)
- [ ] Crear fixtures para Support (`FAQFixtures`, `ContactMessageFixtures`)
- [ ] Crear mocks para nuevos repositories
- [ ] Crear `IntegrationTestHelpers` para flujos multi-página

---

### FASE 2: Feature Auth (Login/Registro)

> **Enfoque TDD:** Escribir tests ANTES de la implementación

#### 2.1 Tests Unitarios (PRIMERO)

**Domain Layer Tests:**
- [ ] `test/features/auth/domain/entities/user_test.dart`
- [ ] `test/features/auth/domain/usecases/login_usecase_test.dart`
- [ ] `test/features/auth/domain/usecases/register_usecase_test.dart`
- [ ] `test/features/auth/domain/usecases/logout_usecase_test.dart`
- [ ] `test/features/auth/domain/usecases/get_current_user_usecase_test.dart`

**Data Layer Tests:**
- [ ] `test/features/auth/data/models/user_model_test.dart`
- [ ] `test/features/auth/data/datasources/auth_local_datasource_test.dart`
- [ ] `test/features/auth/data/repositories/auth_repository_impl_test.dart`

**BLoC Tests:**
- [ ] `test/features/auth/presentation/bloc/auth_bloc_test.dart`

#### 2.2 Widget Tests
- [ ] `test/features/auth/presentation/pages/login_page_test.dart`
- [ ] `test/features/auth/presentation/pages/register_page_test.dart`
- [ ] `test/features/auth/presentation/widgets/auth_form_test.dart`

#### 2.3 Implementación

**Domain Layer:**
- [ ] `lib/features/auth/domain/entities/user.dart`
- [ ] `lib/features/auth/domain/repositories/auth_repository.dart`
- [ ] `lib/features/auth/domain/usecases/login_usecase.dart`
- [ ] `lib/features/auth/domain/usecases/register_usecase.dart`
- [ ] `lib/features/auth/domain/usecases/logout_usecase.dart`
- [ ] `lib/features/auth/domain/usecases/get_current_user_usecase.dart`

**Data Layer:**
- [ ] `lib/features/auth/data/models/user_model.dart`
- [ ] `lib/features/auth/data/datasources/auth_local_datasource.dart`
- [ ] `lib/features/auth/data/repositories/auth_repository_impl.dart`

**Presentation Layer:**
- [ ] `lib/features/auth/presentation/bloc/auth_bloc.dart`
- [ ] `lib/features/auth/presentation/bloc/auth_event.dart`
- [ ] `lib/features/auth/presentation/bloc/auth_state.dart`
- [ ] `lib/features/auth/presentation/pages/login_page.dart`
- [ ] `lib/features/auth/presentation/pages/register_page.dart`
- [ ] `lib/features/auth/presentation/widgets/auth_form.dart`

**Integración:**
- [ ] Registrar en DI (`injection_container.dart`)
- [ ] Agregar rutas (`routes.dart`, `app_router.dart`)
- [ ] Agregar textos a `app_config.json`

#### 2.4 Integration Test
- [ ] `integration_test/auth_flow_test.dart`

---

### FASE 3: Feature Soporte/Contacto

#### 3.1 Tests Unitarios (PRIMERO)

**Domain Layer Tests:**
- [ ] `test/features/support/domain/entities/faq_item_test.dart`
- [ ] `test/features/support/domain/entities/contact_message_test.dart`
- [ ] `test/features/support/domain/usecases/get_faqs_usecase_test.dart`
- [ ] `test/features/support/domain/usecases/send_contact_message_usecase_test.dart`

**Data Layer Tests:**
- [ ] `test/features/support/data/models/faq_item_model_test.dart`
- [ ] `test/features/support/data/models/contact_message_model_test.dart`
- [ ] `test/features/support/data/datasources/support_local_datasource_test.dart`
- [ ] `test/features/support/data/repositories/support_repository_impl_test.dart`

**BLoC Tests:**
- [ ] `test/features/support/presentation/bloc/support_bloc_test.dart`
- [ ] `test/features/support/presentation/bloc/contact_bloc_test.dart`

#### 3.2 Widget Tests
- [ ] `test/features/support/presentation/pages/support_page_test.dart`
- [ ] `test/features/support/presentation/pages/faq_page_test.dart`
- [ ] `test/features/support/presentation/pages/contact_page_test.dart`
- [ ] `test/features/support/presentation/widgets/faq_card_test.dart`
- [ ] `test/features/support/presentation/widgets/contact_form_test.dart`

#### 3.3 Implementación

**Domain Layer:**
- [ ] `lib/features/support/domain/entities/faq_item.dart`
- [ ] `lib/features/support/domain/entities/contact_message.dart`
- [ ] `lib/features/support/domain/repositories/support_repository.dart`
- [ ] `lib/features/support/domain/usecases/get_faqs_usecase.dart`
- [ ] `lib/features/support/domain/usecases/send_contact_message_usecase.dart`

**Data Layer:**
- [ ] `lib/features/support/data/models/faq_item_model.dart`
- [ ] `lib/features/support/data/models/contact_message_model.dart`
- [ ] `lib/features/support/data/datasources/support_local_datasource.dart`
- [ ] `lib/features/support/data/repositories/support_repository_impl.dart`

**Presentation Layer:**
- [ ] `lib/features/support/presentation/bloc/support_bloc.dart`
- [ ] `lib/features/support/presentation/bloc/contact_bloc.dart`
- [ ] `lib/features/support/presentation/pages/support_page.dart`
- [ ] `lib/features/support/presentation/pages/faq_page.dart`
- [ ] `lib/features/support/presentation/pages/contact_page.dart`
- [ ] `lib/features/support/presentation/widgets/faq_card.dart`
- [ ] `lib/features/support/presentation/widgets/contact_form.dart`

**Integración:**
- [ ] Agregar textos a `app_config.json` (parametrización)
- [ ] Registrar en DI
- [ ] Agregar rutas

#### 3.4 Integration Test
- [ ] `integration_test/support_flow_test.dart`

---

### FASE 4: Diseño Responsivo Completo

#### 4.1 Tests
- [ ] `test/core/utils/responsive_utils_test.dart`
- [ ] `test/shared/widgets/responsive_builder_test.dart`
- [ ] Widget tests con diferentes tamaños de pantalla (mobile, tablet, desktop)

#### 4.2 Implementación

**Core:**
- [ ] `lib/core/constants/breakpoints.dart`
```dart
class Breakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1200;
}
```

- [ ] `lib/core/utils/responsive_utils.dart` (extensiones mejoradas)
```dart
extension ResponsiveExtensions on BuildContext {
  bool get isMobile => screenWidth < Breakpoints.tablet;
  bool get isTablet => screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.desktop;
  bool get isDesktop => screenWidth >= Breakpoints.desktop;

  int get gridColumns => isMobile ? 2 : (isTablet ? 3 : 4);
}
```

**Widgets:**
- [ ] `lib/shared/widgets/responsive_builder.dart`

**Páginas a Actualizar:**
- [ ] `ProductsPage` - Grid responsive con columnas dinámicas
- [ ] `HomePage` - Layout adaptativo
- [ ] `ProductDetailPage` - Two-pane layout para tablet/desktop

---

### FASE 5: Completar Tests Existentes

#### 5.1 BLoC Tests Faltantes (7 BLoCs)
- [ ] `test/features/home/presentation/bloc/home_bloc_test.dart`
- [ ] `test/features/products/presentation/bloc/products_bloc_test.dart`
- [ ] `test/features/products/presentation/bloc/product_detail_bloc_test.dart`
- [ ] `test/features/search/presentation/bloc/search_bloc_test.dart`
- [ ] `test/features/categories/presentation/bloc/categories_bloc_test.dart`
- [ ] `test/features/checkout/presentation/bloc/checkout_bloc_test.dart`
- [ ] `test/features/orders/presentation/bloc/order_history_bloc_test.dart`

#### 5.2 Data Layer Tests
**Cart:**
- [ ] `test/features/cart/data/datasources/cart_local_datasource_test.dart`
- [ ] `test/features/cart/data/models/cart_item_model_test.dart`
- [ ] `test/features/cart/data/repositories/cart_repository_impl_test.dart`

**Orders:**
- [ ] `test/features/orders/data/datasources/order_local_datasource_test.dart`
- [ ] `test/features/orders/data/models/order_model_test.dart`
- [ ] `test/features/orders/data/repositories/order_repository_impl_test.dart`
- [ ] `test/features/orders/domain/usecases/get_orders_usecase_test.dart`
- [ ] `test/features/orders/domain/usecases/save_order_usecase_test.dart`
- [ ] `test/features/orders/domain/usecases/get_order_by_id_usecase_test.dart`

#### 5.3 Widget Tests de Features (7 páginas)
- [ ] `test/features/home/presentation/pages/home_page_test.dart`
- [ ] `test/features/products/presentation/pages/products_page_test.dart`
- [ ] `test/features/products/presentation/pages/product_detail_page_test.dart`
- [ ] `test/features/cart/presentation/pages/cart_page_test.dart`
- [ ] `test/features/checkout/presentation/pages/checkout_page_test.dart`
- [ ] `test/features/orders/presentation/pages/order_history_page_test.dart`
- [ ] `test/features/search/presentation/pages/search_page_test.dart`

---

### FASE 6: Tests de Integración

#### 6.1 Configuración
- [ ] `integration_test/app_test.dart` (setup básico)
- [ ] `integration_test/helpers/integration_test_helpers.dart`
- [ ] `integration_test/robots/` (Page Object Pattern)

#### 6.2 Integration Tests Críticos
- [ ] `integration_test/checkout_flow_test.dart`
- [ ] `integration_test/auth_flow_test.dart`
- [ ] `integration_test/search_flow_test.dart`

#### 6.3 Integration Tests Secundarios
- [ ] `integration_test/navigation_test.dart`
- [ ] `integration_test/cart_management_test.dart`
- [ ] `integration_test/order_history_test.dart`
- [ ] `integration_test/support_flow_test.dart`

---

### FASE 7: Documentación

#### 7.1 Diagramas de Flujo (Mermaid)
- [ ] `docs/diagrams/user_flow.md` - Flujo principal del usuario
- [ ] `docs/diagrams/navigation_map.md` - Mapa de navegación
- [ ] `docs/diagrams/checkout_sequence.md` - Secuencia de checkout
- [ ] `docs/diagrams/architecture.md` - Arquitectura del sistema

#### 7.2 Documentación Técnica
- [ ] Actualizar `README.md` con nuevas features
- [ ] Crear `docs/TESTING_GUIDE.md`
- [ ] Crear `docs/ARCHITECTURE.md`
- [ ] Actualizar `CLAUDE.md` con Auth y Support

---

## Archivos Críticos a Modificar

### Configuración
| Archivo | Cambio |
|---------|--------|
| `pubspec.yaml` | Agregar `integration_test` |

### Nuevos Features
| Carpeta | Archivos |
|---------|----------|
| `lib/features/auth/` | 15+ archivos (Clean Architecture completa) |
| `lib/features/support/` | 12+ archivos (Clean Architecture completa) |

### Core
| Archivo | Cambio |
|---------|--------|
| `lib/core/di/injection_container.dart` | Registrar Auth y Support |
| `lib/core/router/routes.dart` | Agregar rutas nuevas |
| `lib/core/router/app_router.dart` | Implementar navegación |
| `lib/core/constants/breakpoints.dart` | Nuevo archivo |
| `lib/core/utils/extensions.dart` | Ampliar responsive |

### Assets
| Archivo | Cambio |
|---------|--------|
| `assets/config/app_config.json` | Agregar textos Auth y Support |

### Tests
| Archivo/Carpeta | Cambio |
|-----------------|--------|
| `test/helpers/mocks.dart` | Agregar mocks nuevos |
| `test/helpers/test_helpers.dart` | Ampliar helpers |
| `integration_test/` | Nueva carpeta completa |

---

## Cronograma de Ejecución

```
SEMANA 1: Infraestructura + Tests BLoCs
├── Día 1-2: Configurar integration_test, ampliar helpers
└── Día 3-5: Completar tests de 7 BLoCs faltantes

SEMANA 2: Feature Auth (TDD)
├── Día 1-2: Tests unitarios Auth (domain + data)
├── Día 3-4: Implementación Auth
└── Día 5: Widget tests + integration test

SEMANA 3: Feature Support + Responsive
├── Día 1-2: Tests unitarios Support
├── Día 3: Implementación Support
├── Día 4: Diseño Responsivo (breakpoints + widgets)
└── Día 5: Widget tests responsive

SEMANA 4: Integration Tests + Documentación
├── Día 1-2: Integration tests completos
├── Día 3-4: Diagramas Mermaid + documentación
└── Día 5: Revisión final, QA y coverage report
```

---

## Dependencias a Agregar

```yaml
dev_dependencies:
  # Existentes
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  flutter_lints: ^5.0.0

  # Nueva
  integration_test:
    sdk: flutter
```

---

## Métricas de Éxito

| Métrica | Actual | Meta | Incremento |
|---------|--------|------|------------|
| Cobertura de código | ~20% | >80% | +60% |
| Tests unitarios | 23 | 100+ | +77 |
| Tests de widgets | 8 | 50+ | +42 |
| Tests de integración | 0 | 10+ | +10 |
| BLoCs testeados | 1/8 | 10/10 | +9 |
| Features completas | 64% | 100% | +36% |
| Requerimientos Fase 5 | 9/14 | 14/14 | +5 |

---

## Comandos de Ejecución de Tests

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar con cobertura
flutter test --coverage

# Generar reporte HTML de cobertura
genhtml coverage/lcov.info -o coverage/html

# Ejecutar tests de integración
flutter test integration_test

# Ejecutar tests específicos
flutter test test/features/auth/
flutter test test/features/support/

# Ejecutar un archivo de test específico
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

---

## Referencias

- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [BLoC Test Package](https://pub.dev/packages/bloc_test)
- [Mocktail Package](https://pub.dev/packages/mocktail)
- [Mermaid Diagrams](https://mermaid.js.org/)

---

*Documento generado el 16 de diciembre de 2025*
