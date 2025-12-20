# MO-BP-001: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de gestion de dependencias. El orden sigue `docs/MO-BP-001_dependency_management.md`.

---

## Versiones exactas en dependencias
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `pubspec.yaml` con versiones fijas | Bloquea versiones exactas y evita rangos abiertos. Usar en apps para reproducibilidad. | Reduce flexibilidad en actualizaciones; evitar en librerias publicas. |

## Archivo lock versionado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `pubspec.lock` versionado | Garantiza builds reproducibles. Usar en apps. | En paquetes distribuidos puede ser contraproducente. |

## Dependencias sin uso
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `flutter analyze` | Detecta imports no usados y warnings relacionados. Usar en CI. | No detecta dependencias no referenciadas pero instaladas. |
| `dart pub deps` + auditoria | Identifica dependencias declaradas y transitive. Usar en auditorias. | Requiere analisis manual de uso real. |

## Escaneo de vulnerabilidades
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `osv-scanner` | Escanea dependencias contra base OSV. Usar en CI. | Cobertura depende de base OSV. |
| `trivy` | Escaneo de dependencias y filesystem. Usar en CI/CD. | Puede requerir ajustes para reducir falsos positivos. |

## Paquetes internos versionados
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Versionado semantico interno | Trazabilidad de cambios y releases. Usar en monorepos con paquetes internos. | Requiere disciplina de versionado. |

## Dependencias VCS con refs inmutables
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Commit hash/tag | Fija el codigo exacto. Usar siempre que se use VCS. | Actualizaciones requieren gestion manual. |

## Límite de adaptador para dependencias nativas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Interfaces + adapters | Encapsula dependencias externas. Usar en capas de integracion. | Requiere disciplina en arquitectura. |

## Controles de seguridad en WebView
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Politicas de allowlist | Restringe dominios permitidos. Usar si hay WebView. | Requiere mantenimiento de lista. |

## Politica de actualizacion documentada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Documento de politica + checklist | Define cadencia, aprobacion y SLA. Usar en equipos con compliance. | Requiere mantenimiento y revision periodica. |

## Auditoria de dependencias <= 90 dias
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Calendario + ticketing | Registra fecha y responsable. Usar para trazabilidad. | Si no hay cultura de seguimiento, se pierde eficacia. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Ref inmutable | Identificador fijo de version (tag o commit) que no cambia. |
| Dependency drift | Diferencia entre versiones usadas y las recomendadas/soportadas. |
| Lock file | Archivo que fija versiones exactas del grafo de dependencias. |
