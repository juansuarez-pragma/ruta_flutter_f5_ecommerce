# TRA-MIN-004: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de linters. El orden sigue `docs/TRA-MIN-004_use_of_linters.md`.

---

## Reglas de analisis estatico configuradas en el proyecto
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + `analysis_options` | Aplica reglas de analyzer a todo el repo. Usar en CI. | Requiere mantenimiento de reglas. |

## IDE configurado para analisis en tiempo real
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Plugin Dart/Flutter (VS Code, Android Studio) | Muestra linting en tiempo real. Usar en desarrollo diario. | Depende de configuracion local. |

## Formato al guardar habilitado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart format` integrado en IDE | Formatea automaticamente al guardar. Usar para consistencia. | Puede generar diffs grandes si no se consensua. |

## Inferencia estricta de tipos habilitada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Analyzer strict mode | Activa reglas estrictas de tipos. Usar en proyectos nuevos. | Puede requerir refactors en legacy. |

## Archivos generados excluidos del analisis
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Exclusiones en analyzer | Evita ruido de lint en codegen. Usar en todos los repos. | Riesgo de excluir archivos relevantes. |

## Reglas especificas del equipo documentadas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Documentacion interna de lint | Explica reglas custom y rationale. Usar en onboarding. | Requiere mantenimiento. |

## Reglas criticas configuradas como errores (no warnings)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Severidades en analyzer | Bloquea build ante reglas criticas. Usar en CI. | Puede aumentar friccion si hay deuda. |

## Hook pre-commit instalado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `lefthook` / `pre-commit` | Ejecuta lint antes de commit. Usar para feedback rapido. | Puede ser ignorado sin enforcement en CI. |

## Pipeline CI/CD incluye analisis
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| GitHub Actions / GitLab CI | Automatiza ejecucion de lint en PR. Usar como gate. | Requiere mantenimiento de runners. |

## El pipeline falla ante violaciones de lint
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Step de lint obligatorio | Falla el pipeline si hay errores. Usar en todas las ramas protegidas. | Puede bloquear merges si hay deuda acumulada. |

## Validacion de formato en el pipeline
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart format` en modo check | Falla si hay archivos sin formatear. Usar en CI. | Requiere consenso de estilo. |

## Cero violaciones de lint en el base de codigo
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` sin issues | Confirma baseline limpia. Usar antes de release. | No cubre calidad semantica. |

## Nuevas violaciones corregidas antes de merge
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Branch protection + lint gate | Bloquea merge si hay errores. Usar en PRs. | Requiere disciplina de equipo. |

## Reglas revisadas periodicamente
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Revision trimestral de reglas | Ajusta lints a necesidades reales. Usar con registros. | Requiere tiempo de equipo. |

## Equipo entrenado en reglas de lint
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Sesiones de onboarding | Alinea a nuevos miembros. Usar en altas nuevas. | No reemplaza documentacion. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Lint | Regla automatica de estilo o calidad. |
| Analyzer | Motor que ejecuta reglas de lint. |
| CI | Integracion continua. |
| Codegen | Codigo generado automaticamente. |
