# TRA-BP-007: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de DDD. El orden sigue `docs/TRA-BP-007_domain_driven_design.md`.

---

## Lenguaje ubicuo definido y documentado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Glosario versionado en Markdown | Permite trazabilidad y revision por PR. Usar en equipos distribuidos. | Requiere disciplina de actualizacion. |
| Context Mapper (context map) | Modela lenguaje y contextos. Usar en discovery y revisiones. | Curva de aprendizaje inicial. |

## Bounded contexts identificados y separados
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Context Mapper | Define limites y relaciones entre contextos. Usar para acuerdos de equipo. | Requiere modelado explicito. |
| Structurizr DSL | Documenta arquitectura y limites. Usar para versionar mapas. | Requiere mantenimiento continuo. |

## Entities con identidad clara
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_test` + pruebas de identidad | Verifica igualdad por identidad vs. valor. Usar en unit tests. | No detecta errores fuera de casos cubiertos. |

## Value objects inmutables
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `freezed` | Genera clases inmutables y comparacion por valor. Usar para VO. | Requiere build_runner. |

## Aggregates hacen cumplir invariantes
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_test` con casos de invariantes | Verifica reglas internas del aggregate. Usar en unit tests. | Requiere definir invariantes medibles. |

## Domain services para logica entre entidades
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` (reglas por capa) | Fuerza ubicacion de logica transversal en servicios de dominio. Usar en CI. | Requiere reglas customizadas. |

## Domain events para ocurrencias significativas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| JSON Schema o Protobuf | Define contrato de eventos con versionado. Usar si hay integraciones. | Impone mantenimiento de esquemas. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Bounded Context | Limite donde un modelo de dominio es consistente. |
| Value Object | Objeto definido por sus atributos y sin identidad propia. |
| Aggregate | Conjunto de entidades con reglas de consistencia. |
| Domain Event | Evento que representa un hecho relevante del dominio. |
