# MOFE-MIN-002: Minificacion y ofuscacion

## Ficha tecnica

| Campo | Valor |
|-------|-------|
| **Codigo** | MOFE-MIN-002 |
| **Tipo** | Minimo (Obligatorio) |
| **Descripcion** | Minificacion y ofuscacion |
| **Atributo de calidad asociado** | Seguridad |
| **Responsable** | FrontEnd, Mobile |
| **Capacidad** | Mobile/Frontend |

---

## 1. Por que (Justificacion de negocio)

### Razonamiento de negocio

> Dificulta que terceros intercepten, entiendan y modifiquen el sistema, protegiendo la propiedad intelectual.

### Impacto en el negocio

#### Impacto en seguridad
- **Proteccion contra ingenieria inversa**: el codigo ofuscado es mucho mas dificil de decompilar
- **Proteccion de IP**: logica de negocio y algoritmos quedan ocultos
- **Seguridad de APIs**: URLs y llaves son mas dificiles de extraer
- **Ventaja competitiva**: algoritmos propietarios permanecen en secreto

#### Impacto en optimizacion de tamano
| Metrica | Antes de optimizar | Despues de optimizar |
|--------|--------------------|----------------------|
| Tamano del paquete | 50-80 MB | 15-25 MB |
| Tiempo de descarga (3G) | 2-4 minutos | 30-60 segundos |
| Exito de instalacion | 85% | 95% |
| Quejas por almacenamiento | Alto | Bajo |

#### Contexto de industria
- **60% de apps moviles** son vulnerables a ingenieria inversa
- **$12 mil millones** se pierden anualmente por pirateria
- Las tiendas penalizan apps grandes en ranking de busqueda
- Usuarios son **2x mas propensos** a descargar apps mas pequenas

---

## 2. Que (Objetivo tecnico)

### Objetivo tecnico

> Reducir el tamano de archivos y ocultar el codigo original, mejorando velocidad de carga/descarga y dificultando su comprension o modificacion por terceros, optimizando rendimiento y protegiendo la propiedad intelectual. Aplicar practicas de codificacion segura que favorezcan la prevencion de ataques.

### Principios de seguridad

1. **Defensa en profundidad**: multiples capas de proteccion
2. **Menor privilegio**: solicitar solo permisos necesarios
3. **Seguro por defecto**: compilaciones de produccion siempre protegidos
4. **Validacion de entrada**: nunca confiar en datos externos
5. **Almacenamiento seguro**: datos sensibles cifrados correctamente

---

## 3. Como (Estrategia de implementacion)

### Enfoque de implementacion

- Habilitar ofuscacion y minificacion en compilaciones de release
- Mantener y proteger archivos de mapeo para simbolicacion de crashes
- Centralizar gestion de secretos en el pipeline
- Verificar permisos y configuraciones de seguridad antes del release

---

## 5. Lista de verificacion

Ver anexo de herramientas: `docs/anexos/MOFE-MIN-002_minification_obfuscation_tools.md`.

### Configuracion de compilacion
- [ ] Ofuscacion activada en compilaciones de release (significa que los builds de release se generan con ofuscacion habilitada)
- [ ] Archivos de mapeo/simbolos generados y almacenados de forma segura (significa que cada release genera symbol files y se guardan con control de acceso)
- [ ] Herramientas de minificacion habilitadas en plataformas objetivo (significa que la minificacion esta activa y verificada por plataforma)
- [ ] Configuraciones de strip verificadas en plataformas objetivo (significa que el stripping de simbolos se valida con reportes por plataforma)

### Gestion de secretos
- [ ] Sin credenciales hardcodeadas en el codigo fuente (significa que no existen claves, tokens o passwords literales en el repositorio)
- [ ] Variables de entorno usadas para secretos de compilacion (significa que los secretos de build se inyectan via CI/CD)
- [ ] Secretos almacenados en el gestor de secretos de CI/CD (significa que se usa un vault con control de acceso y rotacion)
- [ ] Almacenamiento seguro usado para secretos en runtime (significa que los secretos se guardan en almacenamiento cifrado del dispositivo)
- [ ] Archivos sensibles excluidos del control de versiones (significa que archivos con secretos estan ignorados y sin historial)

### Gestion de permisos
- [ ] Solo permisos necesarios solicitados (significa que la lista de permisos se alinea con funcionalidades documentadas)
- [ ] Solicitudes de permisos incluyen justificacion (significa que cada permiso muestra rationale al usuario)
- [ ] Permisos justificados en listings de app store (significa que la justificacion aparece en metadatos de tienda)

### Logging
- [ ] Logs de debug deshabilitados en produccion (significa que los builds de release no emiten logs de debug)
- [ ] Datos sensibles nunca se registran (significa que los logs no contienen PII ni secretos detectables por patrones)
- [ ] Reportes de crash sanitizados antes de enviar (significa que se remueven datos sensibles antes del envio)

### Verificacion
- [ ] Tamano de compilacion comparado antes/despues de optimizacion (significa que se registran metricas de tamano y se comparan con baseline)
- [ ] Prueba de decompilacion realizada (significa que se ejecuta un intento de decompilar y se documenta resultado)
- [ ] Archivos de mapeo cargados en monitoreo de crashes (significa que los symbol files se cargan en la herramienta de crashes)
- [ ] Lista de exclusiones documentada (significa que se documentan paquetes o simbolos excluidos)

---

## 6. Importancia de definirlo al inicio del proyecto

### Por que no puede esperar

1. **Mentalidad de seguridad**: practicas seguras deben ser habitos desde el dia uno, no afterthoughts.

2. **Pipeline de compilacion**: configurar firmado, ofuscacion y secretos es mas facil antes de crecer en complejidad.

3. **Seleccion de dependencias**: algunas librerias no funcionan con ofuscacion; mejor conocerlo temprano.

4. **Presupuesto de tamano**: definir limites temprano evita crecimiento descontrolado.

5. **Cumplimiento**: muchas industrias requieren ofuscacion; adaptarlo despues es costoso.

### Consecuencias de no hacerlo

| Problema | Consecuencia |
|---------|-------------|
| Sin ofuscacion | Logica de negocio facilmente invertida |
| Secretos hardcodeados | Credenciales extraibles del paquete de distribucion |
| Sin archivos de mapeo | Reportes de crash ilegibles |
| App pesada | Menor tasa de instalacion, peor ranking |
| Logs de debug en prod | Exposicion de datos sensibles |

---

## 8. Anti-patrones a evitar

### 8.1 Secretos hardcodeados
No incluir credenciales en codigo fuente ni en repositorio.

### 8.2 Almacenamiento en texto plano
Evitar guardar datos sensibles sin cifrado.

### 8.3 Logs de debug en produccion
No exponer informacion sensible por logs en release.

---

## 9. Recursos adicionales

### Documentacion oficial
- Guia de minificacion del proveedor de plataforma

### Recursos de seguridad
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- Almacenamiento seguro de secretos en runtime

### Referencias de proyecto
- Alexandria: Obfuscation and Minification - mobile
- LearnWorlds: Obfuscation and Minification - mobile
- Toolkit for agentive minification and obfuscation configuration

---

## 10. Evidencia de cumplimiento

Para validar el cumplimiento de este requisito, documentar:

| Evidencia | Descripcion |
|----------|-------------|
| Logs de compilacion | Evidencia de ofuscacion aplicada |
| Archivos de mapeo | Almacenados en ubicacion segura |
| Comparacion de tamano | Antes/despues de optimizacion |
| Escaneo de seguridad | Sin secretos en codigo decompilado |
| Auditoria de permisos | Solo permisos necesarios |

---

**Ultima actualizacion:** diciembre 2024
**Autor:** Equipo de Arquitectura
**Version:** 1.0.0
