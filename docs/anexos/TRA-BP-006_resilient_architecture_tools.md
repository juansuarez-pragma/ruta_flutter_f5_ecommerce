# TRA-BP-006: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de arquitectura resiliente. El orden sigue `docs/TRA-BP-006_resilient_architecture.md`.

---

## Patron repositorio implementado para todo acceso a datos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` + reglas de arquitectura | Enforce que las capas de dominio no importen infraestructura. Usar en CI. | Requiere reglas propias y mantenimiento. |
| `dart_code_metrics` (arquitectura por capas) | Detecta dependencias prohibidas entre carpetas/paquetes. Usar en auditorias. | Configuracion inicial mas detallada. |

## Patron Strategy usado para comportamientos intercambiables
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_test` + `mocktail` | Permite verificar que se intercambian implementaciones por configuracion. Usar en unit tests. | No valida wiring en runtime sin pruebas de integracion. |

## Logica de reintentos implementada para operaciones de red
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `fake_async` + `flutter_test` | Simula tiempo para verificar backoff y max intentos. Usar en unit tests. | Requiere modelar tiempos de manera controlada. |

## Circuit breaker para llamadas a servicios externos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Pruebas de fallas controladas | Verifica apertura/cierre del circuito ante errores. Usar en integration tests. | Requiere escenarios de fallo repetibles. |

## Degradacion controlada cuando servicios no estan disponibles
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `integration_test` con simulacion offline | Valida fallback y mensajes al usuario. Usar en QA automatizado. | Necesita entornos con red controlada. |

## Cache local como mecanismo de fallback
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Pruebas de cache con `flutter_test` | Verifica TTL, invalidez y lectura offline. Usar en unit/integration tests. | No valida rendimiento de I/O en dispositivos reales. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Circuit breaker | Patron que corta llamadas tras umbral de fallos. |
| Backoff | Espera incremental entre reintentos. |
| Fallback | Respuesta alternativa cuando falla el servicio. |
| TTL | Tiempo de vida de un cache. |
