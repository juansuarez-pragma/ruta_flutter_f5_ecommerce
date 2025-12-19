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

> - Mejora la capacidad de cambio manteniendo bajo el desfase de dependencias (por ejemplo, versiones dentro de rangos soportados), medible por "versions behind latest", tamano de PR de actualizacion y lead time de cambios (DORA).
> - Reduce el riesgo de integracion al disminuir fallas de resolucion de dependencias, medible por % de builds en CI que fallan por conflictos de version, tasa de fallas de cambio (DORA) e incidentes de rollback asociados a actualizaciones.
> - Reduce la carga de mantenimiento al mantener actualizaciones incrementales, medible por horas medianas por actualizacion de dependencias, MTTR (DORA) para incidentes de actualizaciones y conteo de avisos de seguridad pendientes (CVE).

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

## 4. Preguntas de entrevista

### Pregunta: Como gestionas las versiones de dependencias?
**Respuesta:**

### Pregunta: Como manejas las dependencias de plugins nativos?
**Respuesta:**

### Pregunta: Como auditas dependencias?
**Respuesta:**

---

## 5. Recursos adicionales

- [Gestion de paquetes Dart](https://dart.dev/tools/pub/dependencies)
- [Desarrollo de plugins Flutter](https://docs.flutter.dev/packages-and-plugins/developing-packages)
- [Trivy Scanner](https://github.com/aquasecurity/trivy)
- [Melos (Monorepo)](https://melos.invertase.dev/)

### Referencias de seguridad
- Pipeline Trivy: https://github.com/somospragma/devsecops-ci-pipe-yml-security
- MCP Trivy: Tool -> scan_filesystem

---

**Ultima actualizacion:** diciembre 2024
**Version:** 1.0.0
