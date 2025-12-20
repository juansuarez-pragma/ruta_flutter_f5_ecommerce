# TRA-MIN-003: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de excepciones. El orden sigue `docs/TRA-MIN-003_proper_use_of_exceptions.md`.

---

## Todos los valores anulables manejados con `?`, `??`, `!`
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` (null-safety) | Detecta usos inseguros de null. Usar en CI. | Requiere migracion completa a null-safety. |

## Valores por defecto definidos para mapeo de datos externos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `json_serializable` (defaultValue) | Permite defaults al deserializar. Usar en modelos externos. | Requiere codegen. |

## No hay force unwrap (`!`) sin checks de null
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Lint `avoid-null-assertion` | Reporta uso de `!`. Usar en CI. | Puede requerir excepciones justificadas. |

## Clases de excepcion personalizadas creadas (no usar `Exception` generica)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` (regla de excepciones) | Bloquea `throw Exception()` y fuerza clases propias. Usar en CI. | Requiere regla custom. |

## Nombres de excepciones descriptivos y semanticos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` (naming rules) | Enforce convenciones de nombres por regex. Usar en CI. | No valida significado real. |

## Excepciones incluyen contexto relevante (message, code, stackTrace)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_test` (assert de campos) | Verifica que las excepciones incluyen metadata. Usar en unit tests. | Cobertura depende de casos. |

## Sealed classes usadas para implementacion Either/Optional
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `freezed` | Genera tipos sellados para resultados. Usar en dominio. | Requiere codegen. |

## Tipos de failure definidos y documentados
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Catalogo de failures + ADR | Documenta categorias y mapping. Usar en equipos grandes. | Requiere mantenimiento continuo. |

## Failures mapeados a mensajes amigables
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Tests de mapeo | Verifica que cada failure produce mensaje UX. Usar en unit tests. | Requiere mantener fixtures. |

## Alertas (no bloqueantes) diferenciadas de modales (bloqueantes)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Golden tests de UI | Valida comportamiento visual y tipos de alerta. Usar en CI de UI. | Sensible a cambios de tema. |

## Mensajes para usuario no tecnicos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Checklist de UX copy | Evalua lenguaje claro y sin tecnicismos. Usar en PRs. | Revision manual. |

## Funcionalidad de reintento disponible cuando aplica
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `integration_test` con fallas simuladas | Valida reintentos en flujos criticos. Usar en QA. | Requiere escenarios controlados. |

## Niveles de log usados apropiadamente (Info, Warning, Error, Debug)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Paquete `logger` | Provee niveles estandar y formatos. Usar como logger unico. | No evita mal uso de niveles. |

## Informacion sensible nunca se registra
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Scanner de logs por patrones | Detecta PII/secretos en logs de QA. Usar en pipeline. | Requiere patrones bien definidos. |

## Crashlytics o Sentry integrado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Firebase Crashlytics | Reporta crashes y errores fatales. Usar en apps mobile. | Dependencia de proveedor. |
| Sentry | Captura errores y performance. Usar cuando se requiere trazabilidad. | Requiere configuracion y muestreo. |

## Todas las excepciones no capturadas reportadas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Integracion global de error handler | Captura errores no manejados y los envia. Usar en bootstrap. | No cubre errores nativos si no se integra. |

## Identificadores de usuario configurados para trazabilidad
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Configuracion de user context | Asocia eventos a usuario anonimo. Usar en apps con login. | Considerar privacidad y GDPR. |

## Logs personalizados enviados para contexto de debugging
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Breadcrumbs en Crashlytics/Sentry | Adjunta eventos previos al error. Usar para contexto. | Puede aumentar volumen de datos. |

## No hay datos sensibles en mensajes de error
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Reglas de sanitizacion | Elimina PII antes de mostrar mensajes. Usar en capa de presentacion. | Requiere definicion de campos sensibles. |

## Stack traces no expuestos a usuarios
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Manejo global de errores | Reemplaza stack traces por mensajes UX. Usar en prod. | Requiere manejo consistente en UI. |

## API keys/tokens nunca en logs
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Filtros de logging | Enmascara patrones de tokens. Usar en logger central. | Puede omitir casos no contemplados. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Failure | Resultado de error controlado. |
| Unhandled exception | Error no capturado por la app. |
| Breadcrumb | Evento contextual previo a un error. |
| PII | Informacion personal identificable. |
