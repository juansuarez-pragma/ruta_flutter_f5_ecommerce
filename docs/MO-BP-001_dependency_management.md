# MO-BP-001: Gestion de dependencias

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | MO-BP-001 |
| **Tipo** | Buena practica |
| **Descripcion** | Gestion de dependencias |
| **Atributo de calidad asociado** | Escalabilidad |
| **Tecnologia** | Mobile |
| **Responsable** | Mobile |
| **Capacidad** | Mobile |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

### Impacto en el negocio

| Metrica | Mala gestion | Buena gestion |
|---------|--------------|---------------|
| Vulnerabilidades de seguridad | Alto riesgo | Riesgo minimo |
| Tiempo de compilacion | Lento | Optimizado |
| Tamano de la app | Inflado | Ligero |
| Esfuerzo de actualizacion | Dias/semanas | Horas |

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Gestionar las librerias y componentes externos que el proyecto requiere para funcionar correctamente. Asegurar que existan versiones apropiadas de dependencias, evitando conflictos y errores.

---

## 3. Lista de verificacion
Ver anexo de herramientas: `docs/anexos/MO-BP-001_dependency_management_tools.md`

- [ ] Todas las dependencias de produccion estan ancladas a versiones exactas (sin rangos abiertos) (significa que no existen rangos abiertos; toda version es deterministica)
- [ ] El archivo lock se versiona para aplicaciones (compilaciones reproducibles) (significa que builds sucesivos generan el mismo grafo de dependencias)
- [ ] Cada dependencia declarada esta referenciada en codigo de produccion/pruebas o herramientas de compilacion (sin entradas sin uso) (significa que no hay dependencias declaradas sin uso real)
- [ ] La CI ejecuta escaneo automatico de vulnerabilidades de dependencias en cada PR/merge y almacena resultados (significa que todo cambio pasa por escaneo y queda evidencia)
- [ ] Los paquetes internos se referencian mediante artefactos versionados explicitos o rutas y tienen sus propios manifiestos (significa que cada paquete interno es trazable y versionado)
- [ ] Las dependencias desde VCS estan ancladas a refs inmutables (tag o hash de commit) (significa que la fuente es inmutable y reproducible)
- [ ] Las dependencias de plataforma/nativas se invocan solo a traves de un limite de adaptador/modulo definido (sin llamadas directas fuera de el) (significa que el acoplamiento se controla por interfaz)
- [ ] Si se usa WebView, se verifican los controles de seguridad (lista de URLs permitidas, puente JS restringido, mixed-content deshabilitado) (significa que el acceso web cumple reglas de seguridad definidas)
- [ ] La politica de actualizacion de dependencias esta documentada con cadencia y criterios de aprobacion (significa que existe un proceso formal verificable)
- [ ] La cadencia de auditoria de dependencias esta definida (<= 90 dias) y se registra la proxima fecha de auditoria (significa que el siguiente control esta calendarizado)

---

## 5. Recursos adicionales

- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [Melos (Monorepo)](https://melos.invertase.dev/)

### Referencias de seguridad
- MCP Trivy: Tool -> scan_filesystem

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
