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

- [ ] Todas las dependencias de produccion estan ancladas a versiones exactas (sin rangos abiertos)
- [ ] El archivo lock se versiona para aplicaciones (compilaciones reproducibles)
- [ ] Cada dependencia declarada esta referenciada en codigo de produccion/pruebas o herramientas de compilacion (sin entradas sin uso)
- [ ] La CI ejecuta escaneo automatico de vulnerabilidades de dependencias en cada PR/merge y almacena resultados
- [ ] Los paquetes internos se referencian mediante artefactos versionados explicitos o rutas y tienen sus propios manifiestos
- [ ] Las dependencias desde VCS estan ancladas a refs inmutables (tag o hash de commit)
- [ ] Las dependencias de plataforma/nativas se invocan solo a traves de un limite de adaptador/modulo definido (sin llamadas directas fuera de el)
- [ ] Si se usa WebView, se verifican los controles de seguridad (lista de URLs permitidas, puente JS restringido, mixed-content deshabilitado)
- [ ] La politica de actualizacion de dependencias esta documentada con cadencia y criterios de aprobacion
- [ ] La cadencia de auditoria de dependencias esta definida (<= 90 dias) y se registra la proxima fecha de auditoria

---

## 5. Recursos adicionales

- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [Melos (Monorepo)](https://melos.invertase.dev/)

### Referencias de seguridad
- MCP Trivy: Tool -> scan_filesystem

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
