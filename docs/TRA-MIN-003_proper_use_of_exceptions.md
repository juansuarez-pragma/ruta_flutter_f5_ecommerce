# TRA-MIN-003: Uso adecuado de excepciones

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-MIN-003 |
| **Tipo** | Minimo (Obligatorio) |
| **Descripcion** | Uso adecuado de excepciones |
| **Atributo de calidad asociado** | Trazabilidad |
| **Tecnologia** | Flutter |
| **Responsable** | FrontEnd, BackEnd, Mobile |
| **Capacidad** | Transversal |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> - Detectar y gestionar excepciones temprano y de forma efectiva, reduciendo el riesgo de fallas y costos de soporte/mantenimiento.
> - Evitar crashes inesperados, ofreciendo mensajes claros en lugar de bloquear usuarios.
> - Asegurar cumplimiento de estandares de calidad y seguridad, evitando penalizaciones para la compania.
> - Facilitar identificacion y resolucion de errores, optimizando desarrollo y debugging.

### Impacto en el negocio

#### Impacto financiero
- **Reduccion de costos de soporte**: cada crash no manejado genera tickets que cuestan $15-50 por ticket
- **Retencion de usuarios**: apps con crashes frecuentes tienen 3x mayor tasa de desinstalacion
- **Calificaciones en tiendas**: los crashes son la causa #1 de reviews 1 estrella
- **Perdida de ingresos**: cada minuto de downtime puede costar $5,600 en promedio para e-commerce

#### Impacto operativo
- **Debugging mas rapido**: el manejo adecuado reduce el tiempo de resolucion de bugs en 60%
- **Monitoreo proactivo**: el monitoreo remoto permite arreglar issues antes de que los usuarios los reporten
- **Cumplimiento**: GDPR y PCI-DSS requieren manejo de errores adecuado para evitar exponer datos sensibles

#### Metricas de impacto
| Metrica | Manejo deficiente | Manejo adecuado |
|---------|-------------------|----------------|
| Crash-free rate | < 95% | > 99.5% |
| MTTR (Tiempo medio de resolucion) | 4-8 horas | 30-60 minutos |
| Bugs reportados por usuarios | 80% | 20% |
| Tickets de soporte/mes | 500+ | < 50 |

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Responder adecuadamente a situaciones inesperadas y mejorar la experiencia del usuario, capturando y registrando cada evento ejecutado en el sistema. Facilitar debugging y mantenimiento proporcionando informacion detallada sobre fallas.

### Principios fundamentales

1. **Nunca fallar en silencio**: toda excepcion debe ser capturada y manejada
2. **Mensajes amigables**: errores tecnicos nunca deben llegar al usuario
3. **Logging completo**: todo error debe dejar rastro para debugging
4. **Fallo con degradacion**: la app debe degradar funcionalidad, no caer por completo
5. **Seguridad primero**: nunca exponer informacion sensible en mensajes de error

---

## 3. Como (Estrategia de implementacion)

### Enfoque de implementacion

### Arquitectura de flujo de errores

---

## 5. Lista de verificacion

### Null Safety
- [ ] Todos los valores anulables manejados con `?`, `??`, `!`
- [ ] Valores por defecto definidos para mapeo de datos externos
- [ ] No hay force unwrap (`!`) sin checks de null

### Excepciones personalizadas
- [ ] Clases de excepcion personalizadas creadas (no usar `Exception` generica)
- [ ] Nombres de excepciones descriptivos y semanticos
- [ ] Excepciones incluyen contexto relevante (message, code, stackTrace)

### Patron Failure
- [ ] Sealed classes usadas para implementacion Either/Optional
- [ ] Tipos de failure definidos y documentados
- [ ] Failures mapeados a mensajes amigables

### Manejo de errores en BLoC
- [ ] Alertas (no bloqueantes) diferenciadas de modales (bloqueantes)
- [ ] Mensajes para usuario no tecnicos
- [ ] Funcionalidad de reintento disponible cuando aplica

### Logging
- [ ] `print` no se usa para debugging (usar `dart:developer` log)
- [ ] Niveles de log usados apropiadamente (Info, Warning, Error, Debug)
- [ ] Informacion sensible nunca se registra

### Monitoreo remoto
- [ ] Crashlytics o Sentry integrado
- [ ] Todas las excepciones no capturadas reportadas
- [ ] Identificadores de usuario configurados para trazabilidad
- [ ] Logs personalizados enviados para contexto de debugging

### Seguridad
- [ ] No hay datos sensibles en mensajes de error
- [ ] Stack traces no expuestos a usuarios
- [ ] API keys/tokens nunca en logs

---

## 6. Importancia de definirlo al inicio del proyecto

### Por que no puede esperar

1. **Los patrones de error se propagan**: una vez que los devs empiezan a capturar excepciones incorrectamente, el patron se esparce por el codebase.

2. **El monitoreo requiere configuracion temprana**: integrar Crashlytics/Sentry es mas facil antes de que la app sea compleja.

3. **Base de UX**: el manejo de errores impacta directamente la calidad percibida desde el dia uno.

4. **Eficiencia de debugging**: logging correcto desde el inicio facilita debugging a medida que se agregan features.

5. **Cumplimiento de seguridad**: muchas regulaciones exigen manejo correcto de errores; adaptar despues es costoso.

### Consecuencias de no hacerlo

| Problema | Consecuencia |
|---------|-------------|
| Bloques catch vacios | Fallas silenciosas, imposible de depurar |
| Excepciones genericas | Sin significado semantico, dificil de manejar |
| Print statements | Logs mezclados con output de produccion, impacto en rendimiento |
| Mensajes tecnicos | Mala UX, posible vulnerabilidad de seguridad |
| Sin monitoreo remoto | Ceguera ante issues en produccion hasta que usuarios reclaman |

---

## 7. Preguntas tecnicas de entrevista - Senior Flutter

### Pregunta 1: Estrategia de manejo de excepciones
**Entrevistador:** "Como manejas errores a traves de las diferentes capas de tu aplicacion Flutter?"

**Respuesta esperada:**

### Pregunta 2: Patron Either
**Entrevistador:** "Por que usas el patron Either en lugar de lanzar excepciones?"

**Respuesta esperada:**

### Pregunta 3: Null Safety
**Entrevistador:** "Como manejas valores nulos al mapear respuestas JSON a modelos?"

**Respuesta esperada:**

### Pregunta 4: Estrategia de logging
**Entrevistador:** "Cual es tu enfoque de logging en apps Flutter?"

**Respuesta esperada:**

### Pregunta 5: Mensajes de error al usuario
**Entrevistador:** "Como manejas mostrar mensajes de error a los usuarios?"

**Respuesta esperada:**

### Pregunta 6: Reto real resuelto
**Entrevistador:** "Cuentame de una situacion compleja de manejo de errores que resolviste"

**Respuesta esperada:**

---

## 8. Anti-patrones a evitar

### 8.1 Bloques catch vacios

### 8.2 Mensajes genericos

### 8.3 Exponer detalles tecnicos

### 8.4 Usar print para logging

---

## 9. Recursos adicionales

### Documentacion oficial
- [Dart Error Handling](https://dart.dev/language/error-handling)
- [Flutter Error Handling](https://docs.flutter.dev/testing/errors)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)
- [Sentry for Flutter](https://docs.sentry.io/platforms/flutter/)

### Paquetes
- [dartz](https://pub.dev/packages/dartz) - Programacion funcional
- [fpdart](https://pub.dev/packages/fpdart) - Alternativa a dartz
- [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics)
- [sentry_flutter](https://pub.dev/packages/sentry_flutter)

### Referencias de proyecto
- Alexandria: RUM Flutter, Logs - Mobile
- LearnWorlds: Exceptions - Mobile

---

## 10. Evidencia de cumplimiento

Para validar el cumplimiento de este requisito, documentar:

| Evidencia | Descripcion |
|----------|-------------|
| Diagrama de clases de excepcion | Visualizacion de jerarquia de excepciones |
| Dashboard crash-free rate | Metricas Crashlytics/Sentry |
| Mapeo de mensajes de error | Documento de mapeo failure -> mensaje usuario |
| Checklist de code review | Verificacion de manejo de excepciones en PRs |

---

**Ultima actualizacion:** diciembre 2024
**Autor:** Equipo de Arquitectura
**Version:** 1.0.0
