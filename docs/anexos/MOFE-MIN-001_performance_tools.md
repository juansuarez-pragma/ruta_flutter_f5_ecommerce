# MOFE-MIN-001: Anexo de herramientas (Dart/Flutter)

Este anexo describe opciones de herramientas para cada item del checklist de rendimiento. El orden sigue `docs/MOFE-MIN-001_performance.md`.

---

## Componentes UI inmutables usados cuando el contenido no cambia
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + `flutter_lints` | Detecta oportunidades de `const` y literales inmutables. Usar en CI para consistencia. | No valida cambios de estado en runtime. |
| Flutter DevTools (Rebuild Stats) | Muestra reconstrucciones para detectar widgets que deberian ser inmutables. Usar en perfilado. | Requiere ejecucion en modo profile. |

## Contenedores solo cuando aportan estilo o layout necesario
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `avoid_unnecessary_containers` | Identifica contenedores redundantes. Usar como regla obligatoria. | No detecta casos semanticos complejos. |

## Espaciado con componentes ligeros
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `sized_box_for_whitespace` | Fuerza uso de widgets ligeros para espaciado. Usar en estilos UI. | No valida costo de renderizado en runtime. |

## Re-render aislado en componentes hoja
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Rebuild Stats) | Visualiza alcance de reconstrucciones. Usar para validar aislamiento. | Requiere sesion de profiling representativa. |

## Renderizado diferido para listas largas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Performance) | Detecta picos de render y build por lista larga. Usar en escenarios de scroll. | No confirma por si solo el mecanismo de diferido. |

## Paginacion o virtualizacion para colecciones grandes
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Pruebas de scroll con `integration_test` | Mide tiempo de frame y memoria durante scroll. Usar en CI de rendimiento. | Requiere dispositivos o emuladores estables. |

## Evitar renderizar todos los elementos al mismo tiempo
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Memory + Performance) | Correlaciona consumo y picos de render. Usar para detectar sobrecarga. | Analisis manual para confirmar causa. |

## Tamaño/altura fija declarada cuando sea posible
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Layout/Widget Inspector) | Permite inspeccionar constraints y tamaños. Usar en auditorias de UI. | Requiere revisiones puntuales por pantalla. |

## Controladores y listeners liberados correctamente
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lints `close_sinks`, `cancel_subscriptions` | Detecta recursos no cerrados o cancelados. Usar en CI. | Puede requerir lints adicionales personalizados. |
| Flutter DevTools (Memory) | Identifica crecimiento de memoria y retencion. Usar para confirmar leaks. | No localiza automaticamente el origen. |

## Flujos de datos cerrados correctamente
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `close_sinks` | Verifica cierres de streams y sinks. Usar en CI. | No valida cierres en rutas dinamicas. |

## Suscripciones canceladas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `dart analyze` + lint `cancel_subscriptions` | Reporta suscripciones sin cancelacion. Usar en CI. | Requiere adopcion consistente del lint. |

## Computo pesado ejecutado fuera del hilo principal
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (CPU Profiler) | Identifica funciones costosas en el hilo principal. Usar en profile. | Necesita carga de trabajo realista. |

## Formatos modernos usados (WebP, SVG)
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| `file` o ImageMagick `identify` | Detecta el formato real de imagenes. Usar en auditorias de assets. | Requiere herramientas instaladas en CI. |

## Cache de imagenes implementada
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Memory) | Observa cache y comportamiento de GC. Usar en sesiones de imagenes intensivas. | No garantiza politica correcta por si sola. |
| Proxy HTTP (Charles, mitmproxy) | Verifica headers de cache y reutilizacion. Usar si hay carga remota. | Requiere configuracion de red. |

## Dimensionado correcto para evitar sobrecarga de memoria
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Memory) | Compara tamanos decodificados vs. render. Usar para detectar sobrecarga. | Analisis manual para cuantificar diferencias. |

## Placeholders y estados de error definidos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Pruebas de UI (golden tests) | Valida estados de carga y error en UI. Usar en CI de UI. | Sensible a cambios de tema y resolucion. |

## Variables de entorno para tree shaking
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter build size analysis | Verifica eliminacion de codigo no usado en release. Usar en auditorias de tamano. | Requiere build release y comparacion historica. |

## Codigo de debug removido en produccion
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Verificacion de build release | Confirma que el build es de release y sin flags debug. Usar en CI/CD. | No detecta logs de debug si se inyectan manualmente. |

## Instrumentacion de rendimiento habilitada en entornos de prueba
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Performance) | Habilita trazas y timeline en QA/test. Usar antes de release. | Impacto minimo en rendimiento si se deja activo. |

## Profiling con herramientas estandar ejecutado
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Flutter DevTools (Performance + Memory) | Ejecuta profiling integral en sesiones controladas. Usar en cada release. | Requiere disciplina de captura y almacenamiento. |

## Marcadores en timeline para paths criticos
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Timeline events (dart:developer) | Permite marcar rutas criticas y medir duracion. Usar en flows clave. | Requiere instrumentacion explicita en codigo. |

## Metricas de rendimiento registradas
| Opcion | Capacidades / Cuando usar | Restricciones / Cuando evitar |
|---|---|---|
| Firebase Performance Monitoring | Registra latencias y trazas en produccion. Usar si se requiere telemetria. | Dependencia externa y costos asociados. |
| Sentry Performance | Recolecta spans y transacciones. Usar para correlacion con errores. | Requiere configuracion y muestreo. |

---

## Glosario

| Termino | Definicion |
|---|---|
| Jank | Frames con saltos o retrasos perceptibles. |
| FPS | Frames por segundo renderizados. |
| Tree shaking | Eliminacion de codigo no usado en build de release. |
| Profiling | Medicion de tiempos, memoria y CPU en ejecucion. |
| Timeline markers | Eventos temporales para medir duracion de procesos. |
