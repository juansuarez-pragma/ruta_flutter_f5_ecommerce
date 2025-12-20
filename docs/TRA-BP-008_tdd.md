# TRA-BP-008: Desarrollo guiado por pruebas (TDD)

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-BP-008 |
| **Tipo** | Buena practica |
| **Descripcion** | Desarrollo guiado por pruebas |
| **Atributo de calidad asociado** | Calidad |
| **Tecnologia** | FrontEnd, BackEnd, Mobile |
| **Responsable** | FrontEnd, BackEnd, Mobile |
| **Capacidad** | Transversal |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> - Reduce errores y mejora la experiencia de usuario.
> - Los problemas se identifican en etapas tempranas, permitiendo soluciones mas rapidas y economicas.
> - Acelera el proceso de implementacion, reduciendo tiempos y costos.
> - Reduce costos de mantenimiento, actualizaciones y adaptacion a medida que el negocio evoluciona.

### Impacto en el negocio

| Metrica | Sin TDD | Con TDD |
|--------|---------|---------|
| Tasa de bugs en produccion | Alta | 40-80% menor |
| Tasa de regresiones | Alta | Minima |
| Confianza en refactorizacion | Baja | Alta |
| Exactitud de documentacion | Frecuentemente desactualizada | Siempre vigente (tests) |
| Velocidad a largo plazo | Decreciente | Sostenida |

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Mejorar la calidad del codigo creando pruebas antes de escribir la implementacion.

### Ciclo TDD: Red-Green-Refactor

---

## 3. Como (Estrategia de implementacion)

### Enfoque

#### 1. RED: Escribir prueba fallida primero

#### 2. GREEN: Implementacion minima

#### 3. REFACTOR: Mejorar sin cambiar comportamiento

#### Integration Tests

### Requisitos de cobertura de pruebas

---

## 4. Lista de verificacion

Ver anexo de herramientas: `docs/anexos/TRA-BP-008_tdd_tools.md`.

- [ ] Pruebas escritas antes de la implementacion (ciclo TDD) (significa que los commits muestran primero el test fallando y luego el codigo)
- [ ] Unit tests para todos los casos de uso (significa que cada caso de uso tiene al menos una prueba unitaria asociada)
- [ ] Unit tests para componentes de logica de presentacion (significa que los componentes de estado/controladores tienen cobertura unitaria)
- [ ] Integration tests para flujos criticos (significa que los flujos de negocio definidos tienen pruebas end-to-end automatizadas)
- [ ] Mocks usados para dependencias externas (significa que servicios externos se sustituyen por doubles en unit tests)
- [ ] Cobertura cumple thresholds (significa que la cobertura supera el umbral definido por modulo)
- [ ] Pruebas corren en pipeline CI/CD (significa que la ejecucion de pruebas es obligatoria en CI y bloquea el merge)

---

## 6. Recursos adicionales

- [Paquete bloc_test](https://pub.dev/packages/bloc_test)
- [Paquete mocktail](https://pub.dev/packages/mocktail)
- "Test-Driven Development" - Kent Beck

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
