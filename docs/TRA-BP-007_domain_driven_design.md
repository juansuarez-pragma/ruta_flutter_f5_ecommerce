# TRA-BP-007: Diseno guiado por el dominio (DDD)

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-BP-007 |
| **Tipo** | Buena practica |
| **Descripcion** | Diseno guiado por el dominio |
| **Atributo de calidad asociado** | Escalabilidad |
| **Tecnologia** | BackEnd, Mobile |
| **Responsable** | BackEnd, Mobile |
| **Capacidad** | Transversal |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> Se enfoca en la colaboracion cercana entre expertos de dominio y desarrolladores para modelar el negocio de forma precisa y efectiva, usando un lenguaje comun.

### Impacto en el negocio

| Metrica | Sin DDD | Con DDD |
|--------|---------|---------|
| Malentendidos de requisitos | Alto | Minimo |
| Alineacion negocio-tecnologia | Pobre | Fuerte |
| Modelado de dominio complejo | Caotico | Estructurado |
| Evolucion de funcionalidades | Dificil | Natural |

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Crear un diseno de software flexible, modular y entendible que refleje las complejidades y reglas del dominio, facilitando evolucion y mantenimiento.

### Conceptos estrategicos de DDD

1. **Lenguaje ubicuo**: vocabulario compartido entre devs y expertos de dominio
2. **Bounded Contexts**: limites claros entre partes del sistema
3. **Entities**: objetos con identidad que persiste en el tiempo
4. **Value Objects**: objetos inmutables definidos por sus atributos
5. **Aggregates**: conjuntos de entidades tratadas como una unidad
6. **Domain Services**: operaciones que no pertenecen a entidades
7. **Repositories**: abstracciones para persistencia de datos

---

## 3. Como (Estrategia de implementacion)

### Enfoque

#### Estructura por bounded context

#### Value Objects

#### Entities

#### Aggregates

#### Domain Services

#### Domain Events

---

## 4. Lista de verificacion

Ver anexo de herramientas: `docs/anexos/TRA-BP-007_domain_driven_design_tools.md`.

- [ ] Lenguaje ubicuo definido y documentado (significa que existe un glosario de dominio versionado y aprobado)
- [ ] Bounded contexts identificados y separados (significa que cada contexto tiene limites documentados y no comparte modelos)
- [ ] Entities con identidad clara (significa que cada entidad tiene identificador unico y ciclo de vida definido)
- [ ] Value objects inmutables (significa que los value objects no cambian estado y se reemplazan por nuevas instancias)
- [ ] Aggregates hacen cumplir invariantes (significa que las reglas de consistencia se validan dentro del aggregate)
- [ ] Domain services para logica entre entidades (significa que la logica transversal vive en servicios de dominio)
- [ ] Domain events para ocurrencias significativas (significa que eventos de dominio se emiten y se registran con esquema)

---

## 6. Recursos adicionales

- "Domain-Driven Design" - Eric Evans
- "Implementing Domain-Driven Design" - Vaughn Vernon
- [DDD Community](https://dddcommunity.org/)

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
