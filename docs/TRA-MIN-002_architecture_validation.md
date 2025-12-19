# TRA-MIN-002: Validacion de arquitectura

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-MIN-002 |
| **Tipo** | Minimo (Obligatorio) |
| **Descripcion** | Validacion de arquitectura |
| **Atributo de calidad asociado** | Mantenibilidad |
| **Tecnologia** | Flutter |
| **Responsable** | BackEnd, Mobile |
| **Capacidad** | Transversal |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> Reduce costos de mantenimiento, actualizaciones y adaptacion a medida que el negocio o la tecnologia evoluciona.

### Impacto en el negocio

#### Costos directos
- **40-60% de reduccion en costos de mantenimiento a largo plazo** segun estudios de la industria
- **Disminucion del tiempo de onboarding** para nuevos desarrolladores de semanas a dias
- **Menor deuda tecnica acumulada** que puede representar hasta 40% del presupuesto de desarrollo en proyectos mal estructurados

#### Costos indirectos
- **Aceleracion del time-to-market**: nuevas features se implementan mas rapido
- **Menor rotacion de personal**: los desarrolladores prefieren proyectos bien estructurados
- **Reduccion de bugs en produccion**: la separacion de responsabilidades facilita pruebas

#### Metricas de impacto
| Metrica | Sin arquitectura clara | Con arquitectura limpia |
|---------|-------------------------|-------------------------|
| Tiempo de implementacion de nuevas features | 2-3 semanas | 3-5 dias |
| Bugs por release | 15-25 | 3-5 |
| Cobertura de pruebas | < 30% | > 70% |
| Tiempo de onboarding | 4-6 semanas | 1-2 semanas |

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Separar responsabilidades, facilitar mantenimiento, escalabilidad y pruebas, creando un sistema modular facilmente adaptable a cambios tecnologicos y/o funcionales.

### Principios fundamentales

1. **Separacion de responsabilidades (SoC)**: cada capa tiene una sola razon para cambiar
2. **Independencia del framework**: la logica de negocio no depende de Flutter
3. **Independencia de UI**: la logica de negocio funciona sin interfaz grafica
4. **Independencia de base de datos**: el almacenamiento puede cambiar sin afectar el negocio
5. **Testeabilidad**: cada componente es testeable de forma aislada

---

## 3. Como (Estrategia de implementacion)

### Enfoque de implementacion

### Diagrama de capas

### Regla de dependencia

---

## 5. Lista de verificacion

### Estructura
- [ ] Proyecto organizado en capas: `data`, `domain`, `presentation`
- [ ] Cada feature tiene su propia estructura por capas
- [ ] Carpeta `core` existe para componentes transversales
- [ ] Carpeta `shared` existe para widgets reutilizables

### Capa de dominio
- [ ] Entidades inmutables (todas las propiedades `final`)
- [ ] Dominio es Dart puro (sin imports de `package:flutter`)
- [ ] Repositorios definidos como interfaces abstractas
- [ ] Un UseCase por operacion de negocio
- [ ] UseCases usan metodo `call()` para invocacion

### Capa de datos
- [ ] Modelos incluyen `fromJson`, `toJson`, `copyWith`
- [ ] Modelos definen valores por defecto para campos nulos
- [ ] Repositorios implementan interfaces del Dominio
- [ ] DataSources abstraidos con interfaces
- [ ] El repositorio es la unica fuente de acceso a datos

### Capa de presentacion
- [ ] BLoC/Cubit por caso de uso (no por pantalla)
- [ ] BLoC depende solo de abstracciones UseCase
- [ ] BLoC no accede repositorios directamente
- [ ] Eventos en pasado: `ProductsLoadRequested`, `CartItemAdded`
- [ ] States como sustantivos/adjetivos: `ProductsLoading`, `ProductsLoaded`

### Inyeccion de dependencias
- [ ] `get_it` configurado en `injection_container.dart`
- [ ] BLoCs registrados como `Factory`
- [ ] UseCases registrados como `LazySingleton`
- [ ] DataSources y Repositories como `LazySingleton`

### Configuracion
- [ ] Flavors configurados (Android) y Schemes (iOS)
- [ ] Variables de entorno por ambiente (dev, qa, prod)
- [ ] README documenta reglas de dependencia
- [ ] Centralizacion de labels para i18n

### Versionado
- [ ] Versiones fijas en `pubspec.yaml`
- [ ] Rangos solo para paquetes bien mantenidos

---

## 6. Importancia de definirlo al inicio del proyecto

### Por que no puede esperar

1. **Costo de refactorizacion exponencial**: cambiar la arquitectura despues de 6 meses de desarrollo puede costar 10x mas que definirla correctamente desde el inicio.

2. **Deuda tecnica acumulativa**: cada linea escrita sin arquitectura clara es deuda que se pagara con intereses.

3. **Consistencia del equipo**: si cada desarrollador usa su propio estilo, el codigo se vuelve un caos imposible de mantener.

4. **Facilita code reviews**: con reglas claras, las revisiones son objetivas y rapidas.

5. **Escalabilidad del equipo**: nuevos miembros pueden contribuir desde el dia 1 siguiendo convenciones establecidas.

### Consecuencias de no hacerlo

| Problema | Consecuencia |
|----------|-------------|
| Sin separacion de capas | Logica de negocio mezclada con UI, imposible de probar |
| BLoC accediendo DataSource | Cambiar la fuente requiere modificar presentacion |
| Dominio con dependencias de Flutter | No se puede reutilizar en otros proyectos Dart |
| Sin inyeccion de dependencias | Las pruebas requieren mocks complejos o son imposibles |

---

## 7. Preguntas tecnicas de entrevista - Senior Flutter

### Pregunta 1: Clean Architecture
**Entrevistador:** "Explica como implementarias Clean Architecture en un proyecto Flutter. Cuales son las capas y como se comunican?"

**Respuesta esperada:**

### Pregunta 2: Regla de dependencia
**Entrevistador:** "Por que es importante que la capa Dominio no tenga dependencias de Flutter?"

**Respuesta esperada:**

### Pregunta 3: Inyeccion de dependencias
**Entrevistador:** "Como manejas la inyeccion de dependencias en Flutter? Por que usas get_it?"

**Respuesta esperada:**

### Pregunta 4: BLoC y Use Cases
**Entrevistador:** "Cual es la relacion entre BLoC y UseCases? Por que un BLoC no deberia acceder al repositorio directamente?"

**Respuesta esperada:**

### Pregunta 5: Manejo de errores en arquitectura
**Entrevistador:** "Como manejas errores a traves de las capas?"

**Respuesta esperada:**

### Pregunta 6: Reto real resuelto
**Entrevistador:** "Cuentame sobre un reto arquitectonico que resolviste en un proyecto Flutter"

**Respuesta esperada:**

---

## 8. Anti-patrones a evitar

### 8.1 BLoC accediendo DataSource

### 8.2 Dominio con dependencias de Flutter

### 8.3 Entidades mutables

---

## 9. Recursos adicionales

### Documentacion oficial
- [Flutter Architecture Samples](https://fluttersamples.com)
- [Documentacion de BLoC](https://bloclibrary.dev)
- [Paquete get_it](https://pub.dev/packages/get_it)

### Libros recomendados
- "Clean Architecture" - Robert C. Martin
- "Domain-Driven Design" - Eric Evans

### Referencias de proyecto
- Alexandria: Clean Architecture Mobile
- LearnWorlds: Clean Architecture Mobile

---

## 10. Evidencia de cumplimiento

Para validar el cumplimiento de este requisito, documentar:

| Evidencia | Descripcion |
|----------|-------------|
| Captura de estructura | Evidencia de estructura de carpetas |
| Diagrama de dependencias | Visualizacion de imports entre capas |
| Reporte de cobertura | Pruebas unitarias por capa |
| Checklist de code review | Verificacion en PRs |

---

**Ultima actualizacion:** diciembre 2024
**Autor:** Equipo de Arquitectura
**Version:** 1.0.0
