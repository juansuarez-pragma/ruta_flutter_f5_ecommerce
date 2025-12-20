# TRA-MIN-005: Anexo de herramientas (Dart/Flutter)

Este anexo describe, por cada item automatizable del checklist, las opciones de herramientas disponibles en Dart/Flutter, sus capacidades, restricciones y cuando usarlas. El orden sigue el checklist de `docs/TRA-MIN-005_clean_code.md`.

---

## Nombres

### Convenciones de nombres (camelCase, PascalCase, snake_case)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_lints` | Valida convenciones basicas (nombres de clases, libs, archivos). Usar en proyectos Flutter estandar con reglas oficiales. | Reglas fijas del paquete, no cubre reglas personalizadas. Evitar si necesitas reglas de nomenclatura no incluidas. |
| `custom_lint` | Reglas personalizadas por proyecto (nombres y prefijos). Usar cuando la convencion es especifica del negocio. | Requiere escribir reglas propias. Evitar si no hay capacidad para mantener reglas custom. |

### Prefijos booleanos (is/has/can/should)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla para validar prefijos en variables booleanas. Usar cuando el equipo exige prefijos semanticos. | Implementacion propia de la regla. Evitar si el equipo no puede mantener lint customizado. |

### Longitud minima de identificadores
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla para longitud minima y allowlist de excepciones. Usar para evitar nombres opacos en bases grandes. | Requiere mantener allowlist. Evitar en bases con mucho legacy sin plan de migracion. |

### Abreviaturas aprobadas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Valida tokens contra glosario aprobado. Usar en equipos con multiples dominios y vocabulario controlado. | Requiere mantener glosario. Evitar en equipos pequenos con bajo riesgo de ambiguedad. |

---

## Formato

### Formateador automatico sin cambios pendientes
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart format` | Formato oficial del SDK; salida deterministica. Usar como estandar recomendado en Dart/Flutter. | Estilo no configurable. Evitar si se requiere un estilo distinto al oficial. |

### Longitud maxima de linea
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `analysis_options.yaml` + linter | Reglas de linea max con lint. Usar para consistencia visual en PRs. | El formateador puede ignorar el limite en casos extremos. Evitar si el equipo no quiere limite fijo. |

### Reglas de bloques y llaves
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_lints` | Reglas base para estructura y estilo. Usar en proyectos Flutter con reglas estandar. | Cobertura limitada a reglas oficiales. Evitar si se necesitan reglas extra. |
| `custom_lint` | Reglas de estructura personalizadas. Usar cuando se define una guia interna estricta. | Requiere desarrollo de reglas. Evitar si no hay mantenimiento para reglas custom. |

---

## Documentacion

### Cobertura de documentacion en APIs publicas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `public_member_api_docs` (linter) | Exige doc en miembros publicos. Usar cuando la API publica debe estar 100% documentada. | No mide porcentaje, es regla de presencia. Evitar si el proyecto es solo interno y no requiere docs publicas. |

### Comentarios de reglas de negocio con ticket
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla con regex para ticket (ej. ABC-123). Usar en organizaciones con trazabilidad formal. | Requiere mantener regex y convencion. Evitar en equipos sin tracker estandarizado. |

### Comentarios sin referencia documentada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla para exigir referencia en comentarios no documentales. Usar cuando se exige trazabilidad estricta. | Puede generar ruido en codigo legado. Evitar en bases antiguas sin plan de remediacion. |

---

## Calidad de codigo

### Literales repetidos por encima del umbral
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` | Regla para magic numbers y literales repetidos. Usar para centralizar constantes. | Requiere configuracion de allowlist. Evitar si el equipo no desea restriccion estricta. |

### Complejidad ciclomática por funcion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` | Mide complejidad por funcion y aplica umbrales. Usar para evitar funciones con mucha ramificacion. | Puede requerir ajustes por dominio. Evitar en prototipos exploratorios. |

### Longitud maxima de funcion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` | Mide lineas por funcion. Usar para mantener cohesion y legibilidad. | No siempre detecta complejidad semantica. Evitar si hay funciones generadas. |

### Numero maximo de parametros
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` | Mide parametros por funcion. Usar para evitar APIs con alta complejidad. | Puede requerir excepciones en builders. Evitar si se usan patrones con muchos parametros por diseno. |

### Duplicacion de codigo
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `jscpd` | Deteccion de duplicacion por tokens en Dart. Usar para reducir copy‑paste. | Requiere excluir generated code. Evitar si hay mucho codigo generado. |

### Simbolos no usados
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter analyze` | Reporta imports y simbolos sin uso. Usar como baseline en todo proyecto Flutter. | Depende del analizador de Dart. Evitar nunca. |

### Codigo comentado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla para detectar patrones de codigo en comentarios. Usar para evitar codigo muerto. | Puede requerir excepciones para headers. Evitar si el equipo usa comentarios de seccion extensivos. |

### TODO/FIXME sin ticket
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` | Regla con regex para exigir ticket en TODO/FIXME. Usar para trazabilidad estricta. | Requiere convencion de tickets. Evitar si el tracker no es obligatorio. |

---

## Cumplimiento SOLID

### Reglas de dependencias y capas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `import_lint` | Define reglas de imports permitidos/prohibidos. Usar en arquitecturas por capas claras. | Requiere archivo de reglas. Evitar si la arquitectura es altamente dinamica. |
| `custom_lint` | Reglas personalizadas de dependencias. Usar cuando `import_lint` no cubre el caso. | Requiere desarrollo de reglas. Evitar si no hay capacidad de mantenimiento. |

### Tamaño de interfaces
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` | Mide cantidad de metodos por clase/interfaz. Usar para evitar contratos demasiado grandes. | Puede requerir exclusiones. Evitar si hay interfaces framework‑driven. |

### Dependencias a implementaciones concretas prohibidas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `import_lint` | Prohibe imports a implementaciones en capas internas. Usar para enforcear inversion de dependencias. | Requiere reglas por capa. Evitar si no hay capas definidas. |

---

## Higiene de Git

### Patron de mensajes de commit
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Hooks de Git / CI | Regex para mensajes, validacion en rango de commits. Usar para historiales consistentes. | Requiere politica en CI. Evitar si el flujo no acepta validacion estricta. |

### Longitud de mensajes de commit
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Hooks de Git / CI | Valida longitud minima y maxima. Usar para legibilidad de historial. | Requiere estandar definido. Evitar si el equipo no controla el flujo de commits. |

### Codigo comentado en cambios
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Hook/CI basado en diff | Escanea diffs y detecta codigo comentado nuevo. Usar para evitar nueva deuda. | Puede requerir excepciones para docs. Evitar si el equipo usa comentarios extensivos como guia. |

---\n+\n+## Enlaces a documentacion\n+\n+- `dart format`: https://dart.dev/tools/dart-format\n+- `flutter analyze`: https://docs.flutter.dev/testing/errors\n+- `flutter_lints`: https://pub.dev/packages/flutter_lints\n+- `custom_lint`: https://pub.dev/packages/custom_lint\n+- `import_lint`: https://pub.dev/packages/import_lint\n+- `dart_code_metrics`: https://pub.dev/packages/dart_code_metrics\n+- `jscpd`: https://github.com/kucherenko/jscpd\n*** End Patch")));
