# TRA-MIN-004: Uso de linters

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | TRA-MIN-004 |
| **Tipo** | Minimo (Obligatorio) |
| **Descripcion** | Uso de linters |
| **Atributo de calidad asociado** | Mantenibilidad |
| **Responsable** | Mobile |
| **Capacidad** | Mobile |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> Reduce la cantidad de errores, mejora la calidad y acelera el proceso de desarrollo, optimizando tiempos de implementacion y costos para el negocio.

### Impacto en el negocio

#### Ahorro directo de costos
- **Reduccion del 25-35% en tiempo de revision de codigo**: las validaciones automaticas liberan a los revisores para enfocarse en la logica
- **40% menos bugs en produccion**: los linters detectan errores comunes antes del release
- **Onboarding mas rapido**: los nuevos desarrolladores siguen patrones consistentes automaticamente
- **Reduccion de deuda tecnica**: el codigo consistente es mas facil de mantener y refactorizar

#### Impacto en metricas de calidad
| Metrica | Sin linters | Con linters |
|---------|------------|-------------|
| Tiempo de revision por PR | 45-60 min | 20-30 min |
| Comentarios de estilo en PR | 15-20 | 0-2 |
| Violaciones de lint en codigo legado | 500+ | < 10 |
| Consistencia entre desarrolladores | Varia por persona | Estandar de equipo |

#### Estadisticas de la industria
- Equipos con linting estricto reportan **30% menos bugs** (estudio interno de Google)
- **50% de los comentarios en revision de codigo** son sobre estilo y pueden ser detectados por linters
- Proyectos con linters tienen **2x mayor tasa de contribucion** de nuevos desarrolladores

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Encontrar errores, malas practicas o inconsistencias, y asegurar que el codigo siga un estilo consistente de formato (como indentacion y espaciado). Obtener un codigo limpio, legible y libre de errores, facilitando la colaboracion y el mantenimiento a largo plazo.

### Que detectan los linters

1. **Violaciones de estilo**: convenciones de nombres, indentacion, espaciado
2. **Bugs potenciales**: variables sin uso, codigo inalcanzable, incompatibilidades de tipos
3. **Problemas de rendimiento**: reconstrucciones innecesarias, patrones ineficientes
4. **Violaciones de buenas practicas**: APIs deprecadas, anti-patrones
5. **Problemas de accesibilidad**: falta de semantica, problemas de contraste

---

## 3. Como (Estrategia de implementacion)

### Enfoque de implementacion

### Pipeline de linting

---

## 5. Lista de verificacion

Ver anexo de herramientas: `docs/anexos/TRA-MIN-004_use_of_linters_tools.md`.

### Configuracion
- [ ] Reglas de analisis estatico configuradas en el proyecto (significa que existe un archivo de reglas versionado)
- [ ] IDE configurado para analisis en tiempo real (significa que el IDE ejecuta el analyzer en vivo)
- [ ] Formato al guardar habilitado (significa que el autoformato se ejecuta al guardar)

### Configuracion de reglas
- [ ] Inferencia estricta de tipos habilitada (significa que el analyzer usa opciones de tipo estrictas)
- [ ] Archivos generados excluidos del analisis (significa que el codegen esta fuera del alcance del lint)
- [ ] Reglas especificas del equipo documentadas (significa que la lista de reglas custom esta documentada)
- [ ] Reglas criticas configuradas como errores (no warnings) (significa que las reglas criticas fallan el build)

### Automatizacion
- [ ] Hook pre-commit instalado (significa que el repositorio incluye hook y guia de instalacion)
- [ ] Pipeline CI/CD incluye analisis (significa que el CI ejecuta lint en cada PR)
- [ ] El pipeline falla ante violaciones de lint (significa que no se permite merge con violaciones)
- [ ] Validacion de formato en el pipeline (significa que el formatter se ejecuta y falla si hay cambios)

### Mantenimiento
- [ ] Cero violaciones de lint en el base de codigo (significa que el reporte de lint retorna 0 issues)
- [ ] Nuevas violaciones corregidas antes de merge (significa que los PRs no se aprueban con violaciones)
- [ ] Reglas revisadas periodicamente (significa que se revisan en una cadencia definida y registrada)
- [ ] Equipo entrenado en reglas de lint (significa que existe onboarding y material de referencia)

---

## 6. Importancia de definirlo al inicio del proyecto

### Por que no puede esperar

1. **Costo de correccion exponencial**: arreglar issues de lint despues de meses de desarrollo puede requerir tocar cientos de archivos.

2. **Patrones inconsistentes**: sin linters, cada desarrollador introduce su propio estilo, generando caos.

3. **Carga de revision de codigo**: los revisores pierden tiempo en estilo en lugar de logica.

4. **Conflictos de merge**: estilos de formato diferentes causan conflictos innecesarios.

5. **Friccion en onboarding**: nuevos desarrolladores luchan para entender codigo inconsistente.

### Consecuencias de no hacerlo

| Problema | Consecuencia |
|----------|-------------|
| Sin configuracion de linter | 500+ violaciones acumuladas en el tiempo |
| Introduccion tardia | Refactorizacion mayor necesaria, alto riesgo |
| Formato inconsistente | Conflictos de merge, diffs ilegibles |
| Warnings ignorados | Warnings se convierten en bugs en produccion |
| Sin enforcement en CI | Violaciones pasan revision de codigo |

---

## 8. Anti-patrones a evitar

### 8.1 Ignorar todas las advertencias

### 8.2 Sin enforcement en CI

### 8.3 Configuracion inconsistente del equipo

---

## 9. Recursos adicionales

### Documentacion oficial

### Paquetes
- [very_good_analysis](https://pub.dev/packages/very_good_analysis) - Reglas mas estrictas
- [lint](https://pub.dev/packages/lint) - Reglas alternativas estrictas

### Referencias de proyecto

---

## 10. Evidencia de cumplimiento

Para validar el cumplimiento de este requisito, documentar:

| Evidencia | Descripcion |
|----------|-------------|
| Logs CI/CD | Pipeline mostrando analisis exitoso |
| Hook pre-commit | Script de hook en el repositorio |

---

**Ultima actualizacion:** diciembre 2024
**Autor:** Equipo de Arquitectura
**Version:** 1.0.0
