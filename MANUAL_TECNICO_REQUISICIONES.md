# PROCESO DE REQUISICIONES — MANUAL TÉCNICO (SISTEMA SIPP/CORE)

> Basado en el diagrama de flujo oficial del sistema SIPP y complementado con el manual operativo.  
> Solo se documentan los procesos externos que **directamente afectan** el ciclo de la requisición.

---

## 1. ACCESO AL SISTEMA

**Ruta:** `SIPP Login → Configuración de usuario → Empresa → Sucursal → Módulo Requisiciones`

El usuario inicia sesión y el sistema carga su perfil.  
Antes de entrar a cualquier módulo, selecciona:
- **Empresa** (Abastecedora)
- **Sucursal** (ej. Corporativo)

> Estos dos valores determinan qué centros de costo, almacenes y autorizadores son visibles para el usuario durante todo el proceso.

---

## 2. LISTADO DE REQUISICIONES

Al entrar al módulo, el usuario ve el listado con los siguientes datos por requisición:

| Campo visible | Descripción |
|---|---|
| Empresa | Empresa que solicita |
| Folio | ID único de la requisición |
| Sucursal | Sucursal de origen |
| División | División interna del área |
| Área | Departamento solicitante |
| Clasificación | Tipo de gasto (Consumible, Mantenimiento, etc.) |
| Fecha de registro | Fecha en que se creó |
| Estatus | Estado actual (Borrador, Pendiente, Autorizada, etc.) |
| Tipo de Requisición | Materiales o Servicios |

**Acciones disponibles desde el listado:**
- **Detalle** → Ver el contenido de la requisición.
- **Seguimiento** → Ver en qué paso del flujo está.
- **Imprimir** → Generar PDF de la solicitud.
- **Historial de cambios** → Ver quién modificó qué y cuándo.
- **Clonar** → Crear una copia de una requisición anterior.
- **Editar** → Solo disponible cuando el estatus es **Borrador**.

---

## 3. NUEVA REQUISICIÓN

El usuario hace clic en **"Nueva Requisición"** y captura la información de encabezado:

| Campo | Descripción |
|---|---|
| Empresa | Heredada de la sesión |
| Sucursal | Heredada de la sesión |
| Tipo de Requisición | **Materiales** o **Servicios** |
| Usuario Requisitante | El empleado que solicita |
| Fecha de Solicitud | Fecha del requerimiento |
| Departamento | Área que genera la necesidad |
| Nombre de la Requisición | Descripción breve del pedido |
| Observaciones | Justificación adicional o contexto |

### 3A. Si el Tipo es MATERIALES
Las clasificaciones disponibles son:
- Nuevos
- Sustitución
- Consumibles
- Mantenimiento Preventivo
- Mantenimiento Correctivo
- Otros Servicios
- Siniestros
- Equipo de Seguridad
- Adecuaciones o Adaptaciones

### 3B. Si el Tipo es SERVICIOS
Las clasificaciones disponibles son:
- Instalaciones Nuevas
- Servicio o Mantenimiento a Instalación
- Mantenimiento Predictivo
- Mantenimiento Preventivo
- Mantenimiento Correctivo
- Otros Servicios
- Siniestros
- Equipo de Seguridad
- Adecuaciones o Adaptaciones

---

## 4. CAPTURA DE DETALLE (PARTIDAS)

El usuario agrega los insumos o servicios que necesita. Por cada partida se captura:

| Campo | Descripción |
|---|---|
| Insumo / Clave | Artículo del catálogo (Clave, Nombre, Unidad, Familia, Subfamilia) |
| Cantidad | Unidades solicitadas |
| Unidad de Medida | UM del insumo |
| Precio Unitario | Precio estimado |
| Importe | Cantidad × Precio Unitario |
| Moneda | MXN u otra divisa |
| GCC | Grupo Centro de Costo |
| Utilizarse en (CC) | Centro de Costo específico donde se usará |

> Si el insumo no existe en el catálogo, el usuario puede solicitar su alta desde el modal **"Sol Nuevo Recurso"**: selecciona si es Material o Servicio, captura el nombre y da clic en Agregar.

### ⚡ PROCESO EXTERNO: ACTIVOS FIJOS
**Cuándo entra:** Si el insumo está marcado como Activo Fijo.  
**Qué pasa:** El sistema habilita campos técnicos adicionales obligatorios (Marca, Modelo, Número de Serie, Valor de adquisición). Estos datos son los que después usa el módulo de Activos para calcular la depreciación mensual del bien.  
**Impacto:** Sin capturar estos campos, el sistema no permite agregar la partida.

### ⚡ PROCESO EXTERNO: MANO DE OBRA / SERVICIOS
**Cuándo entra:** Si `Tipo de Requisición = Servicios`.  
**Qué pasa:** Se habilita el campo **Colaborador** (nombre del técnico externo o interno que ejecutará el servicio) y el campo **Kilometraje** (si el servicio está vinculado a una unidad vehicular).  
**Diferencia clave:** En una requisición de Servicios, el "insumo" es el servicio mismo. El sistema lo maneja contablemente distinto a una pieza física.

---

## 5. GUARDAR COMO BORRADOR

Al guardar, la requisición queda en **Estatus: Borrador**.  
En este estado:
- No ha iniciado ningún flujo de autorización.
- Puede ser editada o clonada libremente.
- No consume presupuesto aún.

---

## 6. ENVIAR REQUISICIÓN (PASO CRÍTICO)

El usuario regresa al listado y ejecuta la acción **"Enviar Req."** desde la columna de Acciones.

### ⚡ PROCESO EXTERNO: VALIDACIÓN DE PRESUPUESTO
**Cuándo entra:** Justo en el momento del envío, ANTES de que cambie el estatus.  
**Qué pasa:** El sistema consulta el módulo de Presupuestos y verifica si el Centro de Costo tiene saldo disponible para el mes en curso.

- **Si hay presupuesto suficiente:** La requisición avanza. El monto queda marcado como "Comprometido" en el presupuesto del departamento (ya no está disponible para otras solicitudes).
- **Si NO hay presupuesto:** El sistema muestra un error indicando el grupo de gasto sin saldo, el monto faltante y el nombre del jefe del área. La requisición **NO se envía** y queda en Borrador.

Tras pasar la validación de presupuesto:
- El estatus cambia a **Pendiente**.
- El sistema registra en la bitácora que el usuario solicitó la requisición.
- Se identifica al **Jefe Inmediato** como autorizador del primer nivel.
- Se genera automáticamente un **PDF de la requisición** y se envía por correo al autorizador.

---

## 7. AUTORIZACIÓN DEL JEFE INMEDIATO

El autorizador recibe el correo, entra al módulo **"Autorización de Requisición"** y ve:

| Dato | Descripción |
|---|---|
| Folio | ID de la requisición |
| Empleado Solicita | Quien pidió |
| Empresa / Sucursal | Origen de la solicitud |
| Área | Departamento |
| Fecha expedición | Cuándo se creó |
| Tipo de Requisición | Materiales o Servicios |
| Estatus / Estatus Autorización | Estado actual |

> **Nota importante del sistema:** El autorizador puede agregar insumos al detalle y editar los ya solicitados antes de tomar una decisión.

### El autorizador tiene 4 opciones:

---

### OPCIÓN A: AUTORIZAR ALMACÉN
El autorizador decide que primero se revise si hay existencias físicas antes de comprar.  
El sistema lleva la requisición al módulo de **Consulta Almacén**.

**Lo que ocurre en Consulta Almacén:**

#### Si hay existencia COMPLETA:
→ Se procede a una **Salida por Consumo**.  
El material sale directamente de la bodega hacia el área solicitante. No se genera compra.

#### Si NO hay existencia:
→ Se genera una **Solicitud de Compra** para todos los insumos faltantes.  
El proceso continúa en el módulo de Compras (ver Paso 8).

#### Si la existencia es PARCIAL:
→ Se generan **dos acciones simultáneas:**
1. **Salida por Consumo** para los insumos que sí hay en bodega.
2. **Solicitud de Compra** para los insumos que no hay.

---

### OPCIÓN B: AUTORIZAR (DIRECTO A COMPRA)
El autorizador aprueba la requisición y la envía directamente al proceso de compra sin pasar por almacén.  
→ Se genera la **Solicitud de Compra**.

---

### OPCIÓN C: RECHAZAR
El autorizador rechaza la solicitud.  
→ El sistema obliga a capturar el **motivo del rechazo**.  
→ Se notifica al solicitante por correo.  
→ **Fin del proceso** para esa requisición.

---

### OPCIÓN D: REGRESAR
El autorizador devuelve la requisición al solicitante para que la corrija.  
→ La requisición regresa al estado editable.  
→ El solicitante puede modificarla y reenviarla (lo que reinicia el flujo desde el Paso 6).

---

## 8. SOLICITUD DE COMPRA Y PROCESO DE COMPRAS

*(Aplica cuando el resultado de la autorización genera una Solicitud de Compra)*

### ⚡ PROCESO EXTERNO: MÓDULO DE COMPRAS
**Cuándo entra:** Cuando no hay stock suficiente o el autorizador decide comprar directamente.

**Pasos del proceso de compras:**

1. **Solicitud de Compra (SC):** Se genera un documento formal de requerimiento de compra ligado al folio de la requisición.

2. **Cotización a Proveedores:** El departamento de compras solicita cotizaciones. El proveedor puede responder por correo o mediante la carga de un archivo en el sistema.

3. **Captura de Precios:** Se registran los precios unitarios, descuentos y condiciones comerciales de cada proveedor en el cuadro comparativo.

4. **Cuadro Comparativo:** El sistema consolida todas las ofertas. El responsable elige al proveedor ganador.

5. **Orden de Compra (OC):** Se genera el documento legal de compra con los precios confirmados. Se especifica el almacén de destino.  
   - Si el monto es alto, la OC requiere una autorización adicional antes de enviarse al proveedor.

6. **Recepción de Material en Almacén:** El proveedor entrega la mercancía. El almacenista registra la **Entrada por Compra** capturando:
   - Serie o folio de la factura del proveedor.
   - Nombre de quien entrega.
   - Cantidad y condición del material recibido.

7. **Encuesta de Satisfacción:** El sistema exige llenar una evaluación del proveedor/servicio antes de cerrar la recepción.

   > **Para Activos Fijos:** En este punto es obligatorio adjuntar **fotografías** del bien recibido y confirmar los números de serie. Sin esto, no se puede proceder al pago.

8. **Surtido Final:** El almacenista ejecuta la acción **"Surtir Seleccionados"** en Consulta Almacén. Esto:
   - Genera el documento de salida que firma quien recibe.
   - Rebaja el stock físico en la bodega.
   - Registra definitivamente el gasto en el Centro de Costo.

---

## 9. FACTURACIÓN Y PAGO A PROVEEDOR

### ⚡ PROCESO EXTERNO: MÓDULO FISCAL Y TESORERÍA
**Cuándo entra:** Después de confirmar la recepción del material o servicio.

1. **Subir Factura al Portal:** El responsable de cuentas por pagar carga el XML y el PDF de la factura del proveedor, vinculándola con el folio de entrada al almacén.

2. **Recepción de Facturas:** El sistema valida los datos fiscales (UUID, RFC, importe) y confirma que la factura corresponde a lo recibido en la requisición.

3. **Programación de Pagos:** Se seleccionan las facturas validadas para incluirlas en la próxima dispersión de pagos.

4. **Autorización de Programación:** La Gerencia Financiera revisa y autoriza la lista de pagos programados.

5. **Emisión del Pago:** Se registra el egreso seleccionando la cuenta bancaria de origen.
   - Soporta pagos parciales (abonos) y pago total.
   - Al registrar el pago, el monto pasa de "Comprometido" a "Gasto Real" en el presupuesto del departamento.
   - La factura queda marcada como **PAGADA** y el folio de la requisición cierra su ciclo.

---

## RESUMEN DEL FLUJO COMPLETO

```
Login → Empresa/Sucursal → Módulo Requisiciones
    ↓
Listado de Requisiciones
    ↓
Nueva Requisición (Cabecera: Tipo, Departamento, Clasificación)
    ↓
Agregar Detalle (Insumos/Servicios + GCC + CC)
    ↓
[EXTERNO] Activos Fijos → campos técnicos adicionales
[EXTERNO] Servicios/M.O. → campo Colaborador + Kilometraje
    ↓
Guardar → Estatus: BORRADOR
    ↓
Enviar Requisición
    ↓
[EXTERNO] Validación de Presupuesto → BLOQUEA si no hay saldo
    ↓
Estatus: PENDIENTE → PDF generado → Correo al autorizador
    ↓
Autorización del Jefe Inmediato
    ├── RECHAZAR → Captura motivo → FIN
    ├── REGRESAR → Vuelve al solicitante para corrección
    ├── AUTORIZAR ALMACÉN →
    │       ├── Existencia COMPLETA → Salida por Consumo → FIN
    │       ├── Existencia PARCIAL → Salida por Consumo (lo que hay)
    │       │                      + Solicitud de Compra (lo que falta)
    │       └── Sin existencia → Solicitud de Compra
    └── AUTORIZAR (directo) → Solicitud de Compra
            ↓
    [EXTERNO] Módulo de Compras
        Cotizaciones → Cuadro Comparativo → OC → Recepción
            ↓
    [EXTERNO] Almacén: Entrada por Compra + Encuesta + Surtido
            ↓
    [EXTERNO] Fiscal: Carga XML → Validación UUID → CxP
            ↓
    [EXTERNO] Tesorería: Programación → Autorización → Pago
            ↓
    Requisición PAGADA / CERRADA
```
