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
| Evolucion de features | Dificil | Natural |

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

### Implementacion DDD en Flutter

#### Estructura por bounded context

#### Value Objects

#### Entities

#### Aggregates

#### Domain Services

#### Domain Events

---

## 4. Lista de verificacion

- [ ] Lenguaje ubicuo definido y documentado
- [ ] Bounded contexts identificados y separados
- [ ] Entities con identidad clara
- [ ] Value objects inmutables
- [ ] Aggregates hacen cumplir invariantes
- [ ] Domain services para logica entre entidades
- [ ] Domain events para ocurrencias significativas

---

## 5. Preguntas de entrevista

### Pregunta: Explica Entity vs Value Object
**Respuesta:**

### Pregunta: Que es un Aggregate?
**Respuesta:**

### Pregunta: Como identificas Bounded Contexts?
**Respuesta:**

---

## 6. Recursos adicionales

- "Domain-Driven Design" - Eric Evans
- "Implementing Domain-Driven Design" - Vaughn Vernon
- [DDD Community](https://dddcommunity.org/)

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
