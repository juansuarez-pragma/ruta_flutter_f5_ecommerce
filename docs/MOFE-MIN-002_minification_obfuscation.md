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
3. **Seguro por defecto**: builds de produccion siempre protegidos
4. **Validacion de entrada**: nunca confiar en datos externos
5. **Almacenamiento seguro**: datos sensibles cifrados correctamente

---

## 3. Como (Estrategia de implementacion)

### Enfoque de implementacion

- Habilitar ofuscacion y minificacion en builds de release
- Mantener y proteger archivos de mapeo para simbolicacion de crashes
- Centralizar gestion de secretos en el pipeline
- Verificar permisos y configuraciones de seguridad antes del release

---

## 5. Lista de verificacion

### Configuracion de build
- [ ] Ofuscacion activada en builds de release
- [ ] Archivos de mapeo/simbolos generados y almacenados de forma segura
- [ ] Herramientas de minificacion habilitadas en plataformas objetivo
- [ ] Configuraciones de strip verificadas en plataformas objetivo

### Gestion de secretos
- [ ] Sin credenciales hardcodeadas en el codigo fuente
- [ ] Variables de entorno usadas para secretos de build
- [ ] Secretos almacenados en el gestor de secretos de CI/CD
- [ ] Almacenamiento seguro usado para secretos en runtime
- [ ] Archivos sensibles excluidos del control de versiones

### Gestion de permisos
- [ ] Solo permisos necesarios solicitados
- [ ] Solicitudes de permisos incluyen justificacion
- [ ] Permisos justificados en listings de app store

### Logging
- [ ] Logs de debug deshabilitados en produccion
- [ ] Datos sensibles nunca se registran
- [ ] Reportes de crash sanitizados antes de enviar

### Verificacion
- [ ] Tamano de build comparado antes/despues de optimizacion
- [ ] Prueba de decompilacion realizada
- [ ] Archivos de mapeo cargados en monitoreo de crashes
- [ ] Lista de exclusiones documentada

---

## 6. Importancia de definirlo al inicio del proyecto

### Por que no puede esperar

1. **Mentalidad de seguridad**: practicas seguras deben ser habitos desde el dia uno, no afterthoughts.

2. **Pipeline de build**: configurar firmado, ofuscacion y secretos es mas facil antes de crecer en complejidad.

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
| Logs de build | Evidencia de ofuscacion aplicada |
| Archivos de mapeo | Almacenados en ubicacion segura |
| Comparacion de tamano | Antes/despues de optimizacion |
| Escaneo de seguridad | Sin secretos en codigo decompilado |
| Auditoria de permisos | Solo permisos necesarios |

---

**Ultima actualizacion:** diciembre 2024
**Autor:** Equipo de Arquitectura
**Version:** 1.0.0
