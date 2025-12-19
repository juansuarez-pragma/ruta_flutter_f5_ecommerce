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

### TDD en Flutter

#### 1. RED: Escribir prueba fallida primero

#### 2. GREEN: Implementacion minima

#### 3. REFACTOR: Mejorar sin cambiar comportamiento

### Piramide de pruebas en Flutter

#### Unit Tests (BLoC)

#### Widget Tests

#### Integration Tests

### Requisitos de cobertura de pruebas

---

## 4. Lista de verificacion

- [ ] Pruebas escritas antes de la implementacion (ciclo TDD)
- [ ] Unit tests para todos los casos de uso
- [ ] Unit tests para todos los BLoCs
- [ ] Widget tests para componentes clave
- [ ] Integration tests para flujos criticos
- [ ] Mocks usados para dependencias externas
- [ ] Cobertura cumple thresholds
- [ ] Pruebas corren en pipeline CI/CD

---

## 5. Preguntas de entrevista

### Pregunta: Explica TDD y sus beneficios
**Respuesta:**

### Pregunta: Cual es la diferencia entre pruebas unitarias, de widget e integracion?
**Respuesta:**

### Pregunta: Como pruebas un BLoC?
**Respuesta:**

---

## 6. Recursos adicionales

- [Flutter Testing](https://docs.flutter.dev/testing)
- [Paquete bloc_test](https://pub.dev/packages/bloc_test)
- [Paquete mocktail](https://pub.dev/packages/mocktail)
- "Test-Driven Development" - Kent Beck

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
