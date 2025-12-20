# MOFE-MIN-002: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de minificacion y ofuscacion. El orden sigue `docs/MOFE-MIN-002_minification_obfuscation.md`.

---

## Ofuscacion activada en compilaciones de release
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter build con ofuscacion | Aplica ofuscacion en builds de release. Usar para proteger codigo en distribucion. | Requiere manejo de symbol files para debugging. |

## Archivos de mapeo/simbolos generados y almacenados de forma segura
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter `split-debug-info` | Genera symbol files por build. Usar junto con ofuscacion. | Requiere almacenamiento seguro y versionado interno. |

## Herramientas de minificacion habilitadas en plataformas objetivo
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Tree shaking de Flutter | Elimina codigo no usado en release. Usar siempre en builds finales. | No elimina codigo referenciado dinamicamente. |

## Configuraciones de strip verificadas en plataformas objetivo
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Reportes de build size | Verifica reduccion de simbolos y binarios. Usar para validar stripping. | Requiere baseline historico para comparar. |

## Sin credenciales hardcodeadas en el codigo fuente
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `gitleaks` | Detecta secretos en repositorio. Usar en CI y pre-commit. | Puede generar falsos positivos. |
| `trufflehog` | Escanea historial de git por secretos. Usar en auditorias completas. | Requiere tiempo en repos grandes. |

## Variables de entorno usadas para secretos de compilacion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| CI/CD secrets | Inyecta variables de entorno en build. Usar en pipelines. | Requiere control de acceso y rotacion. |

## Secretos almacenados en el gestor de secretos de CI/CD
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| HashiCorp Vault | Centraliza secretos con politicas. Usar en entornos regulados. | Requiere operacion y mantenimiento. |
| Secret Manager (cloud) | Gestiona secretos con rotacion. Usar en cloud nativo. | Dependencia de proveedor. |

## Almacenamiento seguro usado para secretos en runtime
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter Secure Storage | Guarda secretos con cifrado a nivel dispositivo. Usar para tokens. | Limitado a secretos pequenos. |

## Archivos sensibles excluidos del control de versiones
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `gitignore` + revisiones de PR | Previene commit accidental de secretos. Usar como baseline. | No elimina secretos ya comprometidos. |

## Solo permisos necesarios solicitados
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Auditoria de permisos | Revisa permisos contra funcionalidades. Usar en cada release. | Requiere checklist y evidencia. |

## Solicitudes de permisos incluyen justificacion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| QA checklist de UX | Valida textos de rationale. Usar en validaciones de tienda. | Requiere criterios claros por permiso. |

## Permisos justificados en listings de app store
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Revision de metadatos | Verifica listings antes de publicar. Usar en release checklist. | Requiere acceso a consola de tienda. |

## Logs de debug deshabilitados en produccion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Verificacion de build release | Garantiza que se compila en modo release. Usar en CI/CD. | No detecta logs manuales si no se revisan. |

## Datos sensibles nunca se registran
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Scanner de logs con patrones | Detecta PII/secretos en logs. Usar en pruebas y staging. | Requiere definicion de patrones. |

## Reportes de crash sanitizados antes de enviar
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Filtros de eventos en herramienta de crashes | Elimina campos sensibles antes de envio. Usar en integraciones. | Depende de la herramienta de monitoreo. |

## Tamano de compilacion comparado antes/despues de optimizacion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Comparacion de artefactos | Mide diferencias de tamano por release. Usar en CI. | Requiere baseline y reglas de alerta. |

## Prueba de decompilacion realizada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Auditoria de ingenieria inversa | Verifica resistencia a decompilacion. Usar en releases mayores. | Requiere herramientas especializadas. |

## Archivos de mapeo cargados en monitoreo de crashes
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Integracion con Crashlytics/Sentry | Subida automatica de symbols por build. Usar en CI. | Dependencia de servicio externo. |

## Lista de exclusiones documentada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Registro de exclusiones | Documenta paquetes excluidos y motivo. Usar en revisiones. | Requiere mantenimiento continuo. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Ofuscacion | Transformacion del codigo para dificultar su lectura. |
| Minificacion | Reduccion de tamaño eliminando codigo redundante. |
| Symbol files | Archivos para mapear codigo ofuscado en errores. |
| Stripping | Eliminacion de simbolos y metadata de binarios. |
