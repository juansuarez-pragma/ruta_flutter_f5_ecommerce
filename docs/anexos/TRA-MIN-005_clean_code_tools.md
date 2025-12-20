# TRA-MIN-005: Anexo de herramientas (Dart/Flutter)

Este anexo describe, por cada item automatizable del checklist, las opciones de herramientas disponibles en Dart/Flutter, sus capacidades, restricciones y cuando usarlas. El orden sigue el checklist de `docs/TRA-MIN-005_clean_code.md`.

---

## Nombres

### Convenciones de nombres (camelCase, PascalCase, snake_case)
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `flutter_lints` | Valida convenciones basicas (nombres de clases, libs, archivos). | Reglas fijas del paquete, no cubre reglas personalizadas. | Proyectos Flutter estandar con reglas oficiales. | Si necesitas reglas de nomenclatura no incluidas. |
| `custom_lint` | Reglas personalizadas por proyecto (nombres y prefijos). | Requiere escribir reglas propias. | Cuando la convencion es especifica del negocio. | Si no hay capacidad para mantener reglas propias. |

### Prefijos booleanos (is/has/can/should)
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla para validar prefijos en variables booleanas. | Implementacion propia de la regla. | Cuando el equipo exige prefijos semanticos. | Si el equipo no puede mantener lint customizado. |

### Longitud minima de identificadores
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla para longitud minima y allowlist de excepciones. | Requiere mantener allowlist. | Para evitar nombres opacos en base de codigo grande. | En bases con mucho legacy donde se requiere migracion gradual. |

### Abreviaturas aprobadas
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Valida tokens contra glosario aprobado. | Requiere mantener glosario. | Equipos con multiples dominios y vocabulario controlado. | Equipos pequenos con bajo riesgo de ambiguedad. |

---

## Formato

### Formateador automatico sin cambios pendientes
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart format` | Formato oficial del SDK; salida deterministica. | Estilo no configurable. | Opcion recomendada en Dart/Flutter. | Si se requiere un estilo distinto al oficial. |

### Longitud maxima de linea
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `analysis_options.yaml` + linter | Reglas de linea max con lint. | El formateador puede ignorar el limite en casos extremos. | Para consistencia visual en PRs. | Si el equipo no quiere limite fijo. |

### Reglas de bloques y llaves
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `flutter_lints` | Reglas base para estructura y estilo. | Cobertura limitada a reglas oficiales. | Proyectos Flutter con reglas estandar. | Si se necesitan reglas extra. |
| `custom_lint` | Reglas de estructura personalizadas. | Requiere desarrollo de reglas. | Cuando se define una guia interna estricta. | Si no hay mantenimiento para reglas custom. |

---

## Documentacion

### Cobertura de documentacion en APIs publicas
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `public_member_api_docs` (linter) | Exige doc en miembros publicos. | No mide porcentaje, es regla de presencia. | Cuando la API publica debe estar 100% documentada. | Si el proyecto es solo interno y no requiere docs publicas. |

### Comentarios de reglas de negocio con ticket
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla con regex para ticket (ej. ABC-123). | Requiere mantener regex y convencion. | Organizaciones con trazabilidad formal. | Equipos sin tracker estandarizado. |

### Comentarios sin referencia documentada
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla para exigir referencia en comentarios no documentales. | Puede generar ruido en codigo legado. | Cuando se exige trazabilidad estricta. | En bases antiguas sin plan de remediacion. |

---

## Calidad de codigo

### Literales repetidos por encima del umbral
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart_code_metrics` | Regla para magic numbers y literales repetidos. | Requiere configuracion de allowlist. | Para forzar centralizacion de constantes. | Si el equipo no desea restriccion estricta. |

### Complejidad ciclomática por funcion
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart_code_metrics` | Mide complejidad por funcion y aplica umbrales. | Puede requerir ajustes por dominio. | Para evitar funciones con mucha ramificacion. | Si el proyecto es exploratorio/prototipo. |

### Longitud maxima de funcion
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart_code_metrics` | Mide lineas por funcion. | No siempre detecta complejidad semantica. | Para mantener cohesion y legibilidad. | Si hay funciones generadas o auto‑compuestas. |

### Numero maximo de parametros
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart_code_metrics` | Mide parametros por funcion. | Puede requerir excepciones en builders. | Para evitar APIs con alta complejidad. | Si se usan patrones con muchos parametros por diseno. |

### Duplicacion de codigo
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `jscpd` | Deteccion de duplicacion por tokens en Dart. | Requiere excluir generated code. | Para reducir copy‑paste. | Si hay codigo generado que domina el repo. |

### Simbolos no usados
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `flutter analyze` | Reporta imports y simbolos sin uso. | Depende del analizador de Dart. | En cualquier proyecto Flutter. | Nunca (es baseline). |

### Codigo comentado
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla para detectar patrones de codigo en comentarios. | Puede requerir excepciones para headers. | Para evitar codigo muerto. | Si el equipo usa comentarios de seccion extensivos. |

### TODO/FIXME sin ticket
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `custom_lint` | Regla con regex para exigir ticket en TODO/FIXME. | Requiere convencion de tickets. | Para trazabilidad estricta. | Si el tracker no es obligatorio. |

---

## Cumplimiento SOLID

### Reglas de dependencias y capas
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `import_lint` | Define reglas de imports permitidos/prohibidos. | Requiere archivo de reglas. | Arquitecturas por capas claras. | Si la arquitectura es altamente dinamica. |
| `custom_lint` | Reglas personalizadas de dependencias. | Requiere desarrollo de reglas. | Cuando `import_lint` no cubre el caso. | Si no hay capacidad de mantenimiento. |

### Tamaño de interfaces
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `dart_code_metrics` | Mide cantidad de metodos por clase/interfaz. | Puede requerir exclusiones. | Para evitar contratos demasiado grandes. | Si hay interfaces framework‑driven. |

### Dependencias a implementaciones concretas prohibidas
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| `import_lint` | Prohibe imports a implementaciones en capas internas. | Requiere reglas por capa. | Para enforcear inversion de dependencias. | Si no hay capas definidas. |

---

## Higiene de Git

### Patron de mensajes de commit
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| Hooks de Git / CI | Regex para mensajes, validacion en rango de commits. | Requiere politica en CI. | Para historiales consistentes. | Si el flujo no acepta validacion estricta. |

### Longitud de mensajes de commit
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| Hooks de Git / CI | Valida longitud minima y maxima. | Requiere estandar definido. | Para legibilidad de historial. | Si el equipo no controla el flujo de commits. |

### Codigo comentado en cambios
| Opcion | Capacidades | Restricciones | Cuando usar | Cuando evitar |
|---|---|---|---|---|
| Hook/CI basado en diff | Escanea diffs y detecta codigo comentado nuevo. | Puede requerir excepciones para docs. | Para evitar nueva deuda. | Si el equipo usa comentarios extensivos como guia. |
