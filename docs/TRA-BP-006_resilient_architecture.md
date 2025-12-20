# TRA-BP-006: Arquitectura resiliente

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-BP-006 |
| **Tipo** | Buena practica |
| **Descripcion** | Arquitectura resiliente |
| **Atributo de calidad asociado** | Arquitectura |
| **Tecnologia** | BackEnd, Mobile, FrontEnd |
| **Responsable** | BackEnd, Mobile, FrontEnd |
| **Capacidad** | Backend |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> - Los cambios en necesidades del cliente o del mercado pueden implementarse mas rapido y eficientemente
> - Asegura estabilidad, lo que se traduce en mayor satisfaccion del cliente y mejor reputacion de marca
> - Garantiza mayor satisfaccion del cliente y mejor reputacion de marca

### Impacto en el negocio

| Metrica | Sin resiliencia | Con arquitectura resiliente |
|---------|----------------|-----------------------------|
| Uptime del sistema | 95-98% | 99.9%+ |
| Tiempo de recuperacion | Horas | Minutos |
| Implementacion de funcionalidades | Riesgosa, lenta | Segura, rapida |
| Confianza del usuario | Fragil | Fuerte |

---

## 2. Que (Objetivo tecnico)

### Objetivos tecnicos

> - Centralizar operaciones de acceso a datos, simplificar el codigo y mejorar mantenibilidad desacoplando la persistencia del resto de la aplicacion
> - Incrementar flexibilidad y reutilizacion de codigo, facilitar la extension del sistema agregando nuevas estrategias sin modificar codigo existente
> - Proteger el sistema detectando fallas en cualquier punto de la aplicacion
> - Asegurar el procesamiento de todas las transacciones

---

## 3. Como (Estrategia de implementacion)

### Patrones de diseno para resiliencia

#### Patron repositorio
Provee una abstraccion entre la logica de negocio y la capa de acceso a datos.

#### Patron Strategy
Permite cambiar el comportamiento del sistema en tiempo de ejecucion.

#### Patron Circuit Breaker
Previene fallas en cascada deteniendo temporalmente solicitudes a servicios con fallas.

#### Patron Retry
Reintenta automaticamente operaciones fallidas.

---

## 4. Lista de verificacion

Ver anexo de herramientas: `docs/anexos/TRA-BP-006_resilient_architecture_tools.md`.

- [ ] Patron repositorio implementado para todo acceso a datos (significa que todo acceso a datos pasa por repositorios y no hay accesos directos fuera de la capa definida)
- [ ] Patron Strategy usado para comportamientos intercambiables (significa que las variantes se seleccionan por configuracion/entrada sin condicionales monoliticos)
- [ ] Logica de reintentos implementada para operaciones de red (significa que existe una politica de reintentos con maximo de intentos y backoff)
- [ ] Circuit breaker para llamadas a servicios externos (significa que hay umbrales de fallos y ventanas de recuperacion definidos)
- [ ] Degradacion controlada cuando servicios no estan disponibles (significa que existen respuestas de fallback documentadas y medibles)
- [ ] Cache local como mecanismo de fallback (significa que hay cache con TTL/invalidez definida para escenarios de indisponibilidad)

---

## 6. Recursos adicionales

- [repositorio patron](https://martinfowler.com/eaaCatalog/repositorio.html)
- [Strategy patron](https://refactoring.guru/design-patrones/strategy)
- [Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
- Referencias de proyecto: Alexandria, LearnWorlds

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
