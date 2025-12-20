# TRA-BP-008: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de TDD. El orden sigue `docs/TRA-BP-008_tdd.md`.

---

## Pruebas escritas antes de la implementacion (ciclo TDD)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Politica de PR + plantillas | Exige evidencia de test previo en revisiones. Usar en equipos con flujo PR. | No valida automaticamente el orden real de escritura. |
| Git hooks (pre-commit) | Fuerza ejecucion de tests antes de commit. Usar en equipos disciplinados. | Puede ser omitido si no se aplica en CI. |

## Unit tests para todos los casos de uso
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter test` | Ejecuta pruebas unitarias de Dart. Usar en CI. | No mide cobertura por si solo. |

## Unit tests para componentes de logica de presentacion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter test` + `bloc_test` | Facilita pruebas de BLoC/estado. Usar en apps con arquitectura reactiva. | Puede acoplarse a la implementacion del estado. |

## Integration tests para flujos criticos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `integration_test` | Ejecuta flujos end-to-end en dispositivos. Usar en CI con emuladores. | Mas lento y fragil que unit tests. |

## Mocks usados para dependencias externas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `mocktail` | Crea doubles sin codegen. Usar en unit tests. | Requiere mantener stubs alineados. |
| `mockito` | Mocks con codegen y verificacion avanzada. Usar en suites grandes. | Requiere build_runner. |

## Cobertura cumple thresholds
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter test --coverage` + `lcov` | Genera reportes y permite gates por porcentaje. Usar en CI. | Cobertura no garantiza calidad de pruebas. |

## Pruebas corren en pipeline CI/CD
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| GitHub Actions / GitLab CI | Automatiza ejecucion de tests en cada PR. Usar como gate de merge. | Requiere mantenimiento de runners y caches. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Unit test | Prueba aislada de una unidad de codigo. |
| Integration test | Prueba de multiples componentes trabajando juntos. |
| Mock | Sustituto controlado de una dependencia externa. |
| Cobertura | Porcentaje de codigo ejecutado por pruebas. |
