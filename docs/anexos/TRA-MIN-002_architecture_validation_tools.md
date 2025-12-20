# TRA-MIN-002: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de validacion de arquitectura. El orden sigue `docs/TRA-MIN-002_architecture_validation.md`.

---

## Proyecto organizado en capas: `data`, `domain`, `presentation`
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` (reglas de arquitectura) | Valida dependencias entre capas por carpetas. Usar en CI. | Requiere configuracion inicial. |

## Cada funcionalidad tiene su propia estructura por capas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` (reglas por feature) | Enforce estructura por feature y capa. Usar en PRs. | Requiere reglas customizadas. |

## Carpeta `core` existe para componentes transversales
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Check de estructura en CI | Verifica presencia de carpetas requeridas. Usar en pipelines. | No valida contenido interno. |

## Carpeta `shared` existe para widgets reutilizables
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Check de estructura en CI | Verifica carpeta `shared` y su uso. Usar en pipelines. | Requiere reglas complementarias de import. |

## Entidades inmutables (todas las propiedades `final`)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `avoid_mutable_fields_in_immutable_classes` | Detecta campos mutables en clases inmutables. Usar en CI. | Depende de anotaciones `@immutable`. |

## Repositorios definidos como interfaces abstractas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` (regla de abstracciones) | Enforce que el dominio solo depende de interfaces. Usar en CI. | Requiere reglas customizadas. |

## Un caso de uso por operacion de negocio
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Checklist de PR + naming conventions | Verifica correspondencia entre casos de uso y operaciones. Usar en revisiones. | No valida automaticamente la semantica. |

## Casos de uso invocables a traves de una interfaz estable
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dartdoc` + validacion de API publica | Obliga contratos publicos estables y documentados. Usar en releases. | Requiere mantenimiento de docs. |

## Modelos incluyen `fromJson`, `toJson`, `copyWith`
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `json_serializable` + `build_runner` | Genera metodos de serializacion y copia. Usar en data models. | Requiere codegen. |

## Modelos definen valores por defecto para campos nulos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `freezed` (defaults) | Permite defaults en constructores inmutables. Usar en modelos. | Requiere codegen. |

## Repositorios implementan interfaces del Dominio
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `implementing_interfaces` | Detecta implementaciones faltantes. Usar en CI. | Depende de reglas habilitadas. |

## fuentes de datos abstraidos con interfaces
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `custom_lint` (data sources) | Obliga interfaces para fuentes de datos. Usar en CI. | Requiere reglas customizadas. |

## El repositorio es la unica fuente de acceso a datos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` (import rules) | Bloquea import directos a data sources. Usar en CI. | Requiere mapeo de carpetas. |

## Eventos en pasado: `ProductsLoadRequested`, `CartItemAdded`
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` (naming rules) | Aplica convenciones de nombres por regex. Usar en CI. | Puede requerir ajustes por idioma. |

## States como sustantivos/adjetivos: `ProductsLoading`, `ProductsLoaded`
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart_code_metrics` (naming rules) | Aplica convenciones de nombres por regex. Usar en CI. | No valida significado semantico. |

## Componentes de presentacion registrados con ciclo de vida transitorio
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `injectable` | Permite declarar scopes/transitorios en DI. Usar con `get_it`. | Requiere codegen. |

## Casos de uso registrados como singleton de carga diferida
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `get_it` + `injectable` | Registra singletons lazy. Usar en arquitectura limpia. | Requiere convenciones de registro. |

## Fuentes de datos y repositorios como singleton de carga diferida
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `get_it` + `injectable` | Controla el ciclo de vida en DI. Usar para servicios compartidos. | Riesgo de estado global si no se controla. |

## Entornos configurados por ambiente (dev, qa, prod)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flavors en Flutter | Permite builds por ambiente. Usar en CI. | Configuracion adicional en pipeline. |

## Variables de entorno por ambiente (dev, qa, prod)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter_dotenv` | Carga variables por ambiente. Usar para configs no sensibles. | No sustituye un gestor de secretos. |

## README documenta reglas de dependencia
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Checklist de documentacion | Valida secciones minimas en README. Usar en PRs. | Requiere revision manual. |

## Centralizacion de labels para i18n
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter l10n (`intl`) | Centraliza strings y genera recursos. Usar en apps multi-idioma. | Requiere disciplina para evitar hardcodes. |

## Rangos solo para paquetes bien mantenidos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart pub outdated` + revision | Evalua frecuencia de releases y compatibilidad. Usar en auditorias. | Requiere criterio humano de "bien mantenido". |

---

## Glosario

| Termino | Definicion |
|---|---|
| SoC | Separacion de responsabilidades entre capas. |
| Use case | Operacion de negocio encapsulada. |
| DI | Inyeccion de dependencias. |
| Flavor | Variante de build por ambiente. |
