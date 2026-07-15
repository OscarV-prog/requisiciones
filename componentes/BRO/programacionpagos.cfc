<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="obtenerprogramacion" access="public" returntype="Any">
        <cfargument name="id_programacionpago"  type="numeric" required="yes">
        <cfargument name="id_Empresa"           type="numeric" required="yes">
        <cfargument name="id_Sucursal"          type="numeric" required="yes">

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                  method="obtenerprogramacion"
                  id_Empresa            ="#id_Empresa#"
                  id_Sucursal           ="#id_Sucursal#"
                  id_programacionpago   ="#id_programacionpago#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setDATA(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerprogramacionAutorizacion" access="public" returntype="Any">
        <cfargument name="id_programacionpago"  type="numeric" required="yes">
        <cfargument name="id_Empresa"  type="string" required="false">
        <cfargument name="id_Sucursal"  type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                  method="obtenerprogramacionAutorizacion"
                  id_Empresa            ="#arguments.id_Empresa NEQ nullValue() ? arguments.id_Empresa : session.ID_EMPRESA#"
                  id_Sucursal           ="#arguments.id_Sucursal NEQ nullValue() ? arguments.id_Sucursal : SESSION.ID_SUCURSAL#"
                  id_programacionpago   ="#id_programacionpago#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setDATA(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="actualizarestatus" access="public" returntype="Any">
        <cfargument name="id_programacionpago"  type="numeric" required="yes">
        <cfargument name="accion"               type="numeric" required="yes">
        <cfargument name="id_Empresa"           type="string"  required="yes"/>
        <cfargument name="id_Sucursal"          type="string"  required="yes"/>
        <cfargument name="de_Comentarios"       type="string"  required="no"  default="">

        <cfif accion eq 1>
            <!--- estatus pendiente de autorizar --->
            <cfset estatus = '1112'>
        <cfelseif accion eq 2>
            <!--- estatus cancelada --->
            <cfset estatus = '1111'>
        <cfelse>
            <cfset variables.RBR.seterror('La acción que mandaste no esta permitida.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                  method="actualizarestatus"
                  id_Empresa            ="#arguments.id_Empresa#"
                  id_Sucursal           ="#arguments.id_Sucursal#"
                  id_programacionpago   ="#id_programacionpago#"
                  id_estatus            ="#estatus#"
                  accion                ="#accion#"
                  de_Comentarios        ="#de_Comentarios#">

        <!---/**
        * Se realiza la actualizacion de estatus de la requisicionCMF
        * (si es que es una, lo verifica dentro del SP)
        */--->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="ActualizarEstatusCMF"
                  id_Empresa="#arguments.id_Empresa#"
                  id_Sucursal="#arguments.id_Sucursal#"
                  id_programacionpago="#id_programacionpago#"
                  id_estatus="#estatus#">

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="guardarprogramacionpago" access="public" returntype="Any">
        <cfargument name="documentos"           type="array"        required="true"/>
        <cfargument name="im_total"             type="string"       required="true"/>
        <cfargument name="id_Moneda"            type="numeric"      required="true"/>
        <cfargument name="id_programacionpago"  type="string"       required="false"/>
        <cfargument name="id_Empresa"           type="string"       required="false"/>
        <cfargument name="id_Sucursal"          type="string"       required="false"/>
        <cfargument name="sn_AjusteCentavos"    type="numeric"      required="false" default="#0#">
        <cfargument name="id_UsuarioAutoriza"   type="string"      required="false" default="">

        <cfif #arguments.sn_AjusteCentavos EQ 1#>
            <!--- SISTEMA SIPP --->
            <cfset arguments.id_UsuarioAutoriza = 1>
        </cfif>

        <!--- se hace el proceso de guardar la programacion de pago --->
        <cfif not isDefined("id_programacionpago") or id_programacionpago eq ''>
            <!---se manda registrar la programcion  --->
            <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                method="agregar"
                id_Empresa          ="#arguments.id_Empresa NEQ nullValue() ? arguments.id_Empresa : session.ID_EMPRESA#"
                id_Sucursal         ="#arguments.id_Sucursal NEQ nullValue() ? arguments.id_Sucursal : SESSION.ID_SUCURSAL#"
                im_monto            ="#arguments.im_total#"
                id_usuario          ="#session.ID_USUARIO#"
                id_estatus          ="#1110#"
                id_Moneda           ="#arguments.id_Moneda#"
                returnvariable="Local.programacion">

            <cfloop from="1" to="#arrayLen(documentos)#" index="local.i">
                <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                    method="agregardetalleAll"
                    id_EmpresaProgramacion  ="#arguments.id_Empresa NEQ nullValue() ? arguments.id_Empresa : session.ID_EMPRESA#"
                    id_SucursalProgramacion ="#arguments.id_Sucursal NEQ nullValue() ? arguments.id_Sucursal : SESSION.ID_SUCURSAL#"
                    id_sucursalDocumento    ="#documentos[local.i].ID_SUCURSALDOCUMENTO#"
                    cl_tipodocumento        ="#documentos[local.i].CL_TIPODOCUMENTO#"
                    id_documento            ="#documentos[local.i].ID_DOCUMENTO#"
                    im_Saldo                ="#documentos[local.i].IM_PAGO#"
                    sn_AnticipoPagar        ="#documentos[local.i].SN_ANTICIPOPAGAR#"
                    id_proveedor            ="#documentos[local.i].ID_PROVEEDOR#"
                    id_DeudorDiverso        ="#documentos[local.i].ID_DEUDORDIVERSO#"
                    id_AcreedorDiverso      ="#documentos[local.i].ID_ACREEDORDIVERSO#"
                    id_programacionpago     ="#local.programacion.ID_PROGRAMACIONPAGO#"
                    id_EmpresaEmpleado      ="#session.ID_EMPRESAOPERADORA#"
                    id_Empleado             ="#SESSION.ID_EMPLEADO#"
                    sn_AjusteCentavos       ="#arguments.sn_AjusteCentavos#">
            </cfloop>
        <cfelse>
        <!--- se hace el proceso para editar la progrmacion de pagos  --->

            <!--- se manda  a eliminar el detalle de la programacion de pago --->
            <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                method="deleteprogramaciondetalle"
                id_Empresa              ="#arguments.id_Empresa#"
                id_Sucursal             ="#arguments.id_Sucursal#"
                id_programacionpago     ="#id_programacionpago#">

            <!--- se manda insertar el detalle nuevo que viene de la interfaz --->
            <!---se manda Actualizar la programacion  --->
            <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                method="ActualizarProgamacion"
                id_Empresa          ="#arguments.id_Empresa#"
                id_Sucursal         ="#arguments.id_Sucursal#"
                im_monto            ="#im_total#"
                id_usuario          ="#session.ID_USUARIO#"
                id_estatus          ="1110"
                id_Moneda           ="#arguments.id_Moneda#"
                id_programacionpago ="#arguments.id_programacionpago#">

            <cfloop from="1" to="#arrayLen(documentos)#" index="local.i">
                <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                    method="agregardetalleAll"
                    id_EmpresaProgramacion  ="#arguments.id_Empresa#"
                    id_SucursalProgramacion ="#arguments.id_Sucursal#"
                    id_sucursalDocumento    ="#documentos[local.i].ID_SUCURSALDOCUMENTO#"
                    cl_tipodocumento        ="#documentos[local.i].CL_TIPODOCUMENTO#"
                    id_documento            ="#documentos[local.i].ID_DOCUMENTO#"
                    im_Saldo                ="#documentos[local.i].IM_PAGO#"
                    sn_AnticipoPagar        ="#documentos[local.i].SN_ANTICIPOPAGAR#"
                    id_proveedor            ="#documentos[local.i].ID_PROVEEDOR#"
                    id_programacionpago     ="#id_programacionpago#"
                    id_EmpresaEmpleado      ="#session.ID_EMPRESAOPERADORA#"
                    id_Empleado             ="#SESSION.ID_EMPLEADO#"
                    sn_AjusteCentavos       ="#arguments.sn_AjusteCentavos#">
            </cfloop>

        </cfif>


        <!--- ESTO SE HACE YA UNO POR UNO --->
        <cfif #arguments.sn_AjusteCentavos EQ 1#>

            <!--- LISTAR PROGRAMACION PAGOS --->
            <cfinvoke
                component="#Application.RF.getPath('dao','Proveedores')#"
                method="listarprogramacionpagos"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#session.ID_SUCURSAL#"
                clprogramacion="#local.programacion.ID_PROGRAMACIONPAGO#"
                accion="#1#"
                page="#1#"
                pageSize="#10#"
                returnvariable="Local.Programacion">

            <!--- LISTAR PROGRAMACION PAGOS DETALLE --->
            <cfinvoke
                component="#Application.RF.getPath('dao','programacionpagos')#"
                method="obtenerprogramacion"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#session.ID_SUCURSAL#"
                id_programacionpago   ="#local.programacion.ID_PROGRAMACIONPAGO#"
                returnvariable="Local.ProgramacionDetalle">


            <cfinvoke
                component="#Application.RF.getPath('dao','Monedas')#"
                method="getTiposCambio"
                id_Moneda="#local.programacion.id_Moneda#"
                fh_Inicial="#dateformat(now(), 'yyyy-mm-dd')#"
                fh_Final="#dateformat(now(), 'yyyy-mm-dd')#"
                returnvariable="Local.tiposCambios">

            <cfinvoke
                component="#Application.RF.getPath('dao','CuentasBancarias')#"
                method="Listar"
                id_Empresa="#session.ID_EMPRESA#"
                id_Moneda="#local.programacion.id_Moneda#"
                returnvariable="Local.cuentasBancarias"/>


            <!--- <cfcontent type="text/html">
            <cfdump var="#Local.cuentasBancarias#" format="simple" label="Local.cuentasBancarias" abort="true"> --->

            <!--- Agrupar documentos por proveedor --->
            <cfset Local.proveedores = StructNew()>

            <cfloop query="Local.ProgramacionDetalle.documentos">
                <cfset var proveedorID = id_proveedor>
                <cfif NOT StructKeyExists(Local.proveedores, proveedorID)>
                    <cfset Local.proveedores[proveedorID] = {
                        id_proveedor = proveedorID,
                        nb_proveedor = nb_proveedor,
                        im_TotalPago = 0,
                        documentos = ArrayNew(1)
                    }>
                </cfif>
                <cfset Local.proveedores[proveedorID].im_TotalPago += im_Pago>
                <cfset ArrayAppend(Local.proveedores[proveedorID].documentos, {
                    id_Documento = id_Documento,
                    cl_TipoDocumento = cl_TipoDocumento,
                    im_Saldo = im_Saldo,
                    id_ProgramacionPago = local.programacion.ID_PROGRAMACIONPAGO,
                    id_ProgramacionPagoDetalle = id_ProgramacionPagoDetalle,
                    id_SucursalDocumento = id_SucursalDocumento
                })>
            </cfloop>

            <!--- Procesar cada proveedor agrupado --->
            <cfloop collection="#Local.proveedores#" item="proveedorID">
                <cfset var proveedor = Local.proveedores[proveedorID]>

                <!--- Agregar Movimiento Bancario --->
                <cfset mbArgs                      = StructNew()>
                <cfset mbArgs.id_Empresa           = session.ID_EMPRESA>
                <cfset mbArgs.id_CuentaBancaria    = Local.cuentasBancarias.id_CuentaBancaria>
                <cfset mbArgs.de_Concepto          = "Emisión de Pago">
                <cfset mbArgs.cl_Naturaleza        = "E">
                <cfset mbArgs.fh_Movimiento        = dateformat(now(), 'yyyy-mm-dd')>
                <cfset mbArgs.im_Movimiento        = proveedor.im_TotalPago>
                <cfset mbArgs.id_Moneda            = local.programacion.id_Moneda>
                <cfset mbArgs.im_TipoCambio        = Local.tiposCambios.im_TipoCambio>
                <cfset mbArgs.fh_Captura           = dateformat(now(), 'yyyy-mm-dd')>
                <cfset mbArgs.id_Estatus           = 1105>
                <cfset mbArgs.sn_Conciliado        = 0>
                <cfset mbArgs.sn_PolizaGenerada    = 0>
                <cfset mbArgs.id_empleado          = SESSION.ID_EMPLEADO>
                <cfset mbArgs.id_empresaoperadora  = session.ID_EMPRESAOPERADORA>
                <cfset mbArgs.fh_Registro          = dateformat(now(), 'yyyy-mm-dd')>
                <cfset mbArgs.id_proveedor         = proveedor.id_proveedor>
                <cfset mbArgs.nb_beneficiario      = proveedor.nb_proveedor>

                <cfinvoke
                    component="#Application.RF.getPath('dao','cuentasbancarias')#"
                    method="agregarmovimientocuentabancaria"
                    argumentcollection="#mbArgs#"
                    returnvariable="local.idcuentamov"
                >

                <!--- Agregar Pago General --->
                <cfset Local.id_Estatus          = 1105>
                <cfset Local.id_PolizaCont       = 0>
                <cfset Local.fh_PolizaCont       ='1900-01-01'>
                <cfset Local.id_PolizaCancel     = 0>
                <cfset Local.fh_PolizaCancel     ='1900-01-01'>

                <!--- Agregar Pago a Proveedor --->
                <cfset ppArgs = {
                    id_Empresa: session.id_Empresa,
                    id_Sucursal: session.id_Sucursal,
                    fh_Pago: dateformat(now(), 'yyyy-mm-dd'),
                    id_Moneda: local.programacion.id_Moneda,
                    im_TipoCambio: Local.tiposCambios.im_TipoCambio,
                    im_TotalPago: proveedor.im_TotalPago,
                    im_TotalPagoMN: proveedor.im_TotalPago * Local.tiposCambios.im_TipoCambio,
                    im_TotalMovBancario: proveedor.im_TotalPago,
                    im_TotalMovBancarioMN: proveedor.im_TotalPago * Local.tiposCambios.im_TipoCambio,
                    sn_Anticipo: "N",
                    im_AnticipoAplicado: "0",
                    id_Proveedor: proveedorID,
                    id_CuentaBancaria: Local.cuentasBancarias.id_CuentaBancaria,
                    id_CuentaBancariamov: local.idcuentamov.id_CuentaBancariamov,
                    id_Estatus: Local.id_Estatus,
                    id_empleado: SESSION.ID_EMPLEADO,
                    id_empresaempleado: session.ID_EMPRESAOPERADORA,
                    fh_Registro: dateformat(now(), 'yyyy-mm-dd'),
                    id_PolizaCont: Local.id_PolizaCont,
                    fh_PolizaCont: Local.fh_PolizaCont,
                    id_PolizaCancel: Local.id_PolizaCancel,
                    fh_PolizaCancel: Local.fh_PolizaCancel,
                }>
                <cfinvoke
                    component="#Application.RF.getPath('dao','Proveedores')#"
                    method="agregarpagoproveedor"
                    argumentcollection="#ppArgs#"
                    returnvariable="local.nextidpago"
                >

                <!--- Agregar Detalles del Pago --->
                <cfloop array="#proveedor.documentos#" index="documento">
                    <cfset ppdArgs = {
                        id_Empresa: session.id_Empresa,
                        id_Sucursal: session.id_Sucursal,
                        id_Pago: local.nextidpago.id_pago,
                        cl_TipoPago: documento.cl_TipoDocumento,
                        cl_TipoDocumento: documento.cl_TipoDocumento,
                        id_Documento: documento.id_Documento,
                        im_Documento: documento.im_Saldo,
                        id_ProgramacionPago: documento.id_ProgramacionPago,
                        id_ProgramacionPagoDetalle: documento.id_ProgramacionPagoDetalle,
                        id_SucursalDocumento: documento.id_SucursalDocumento,
                        im_TipoCambio: Local.tiposCambios.im_TipoCambio,
                        id_Moneda: local.programacion.id_Moneda,
                        im_DocumentoMN: documento.im_Saldo * Local.tiposCambios.im_TipoCambio
                    }>
                    <cfinvoke
                        component="#Application.RF.getPath('dao','Proveedores')#"
                        method="agregarpagoproveedordetalle"
                        argumentcollection="#ppdArgs#"
                        returnvariable="local.nextidndpago"
                    >

                    <cfset dpmArgs                       = StructNew()>
                    <cfset dpmArgs.id_Empresa            = "#session.id_Empresa#">
                    <cfset dpmArgs.id_Sucursal           = "#documento.id_SucursalDocumento#">
                    <cfset dpmArgs.cl_TipoDocumento      = "#documento.cl_TipoDocumento#">
                    <cfset dpmArgs.id_Documento          = "#documento.id_Documento#">
                    <!--- <cfset dpmArgs.nd_Movimiento   = "#RSSiguienteDPM_NF.RS.NextID#"> --->
                    <cfset dpmArgs.fh_Movimiento         = dateformat(now(), 'yyyy-mm-dd')>
                    <cfset dpmArgs.cl_Naturaleza         = "C">
                    <cfset dpmArgs.im_Movimiento         = "#documento.im_Saldo#">
                    <cfset dpmArgs.id_OrigenMovimiento   = 4>
                    <cfset dpmArgs.id_Pago               = "#Local.nextidpago.id_pago#">
                    <!--- <cfset dpmArgs.nd_Pago         = "#RSSiguientePagoDetalleNF.RS.NextID#"> --->

                    <cfset dpmArgs.nd_Pago               = "#local.nextidndpago.nd_Pago#">
                    <cfset dpmArgs.sn_AfectacionContable = 0>
                    <cfset dpmArgs.id_Estatus            = 1105>

                    <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                                method="agregardocumentoproveedoresmovimientos"
                                argumentcollection="#dpmArgs#">

                </cfloop>
            </cfloop>

            <cfloop query="Local.ProgramacionDetalle.documentos">

                <cfinvoke
                    component="#Application.RF.getPath('dao','programacionpagos')#"
                    method="ActualizarEstatusProgramacionesDocumentos"
                    id_Empresa                      = "#Local.ProgramacionDetalle.documentos.id_Empresa#"
                    id_Sucursal                     = "#Local.ProgramacionDetalle.documentos.id_Sucursal#"
                    id_SucursalDocumento            = "#Local.ProgramacionDetalle.documentos.id_SucursalDocumento#"
                    id_ProgramacionPago             = "#Local.ProgramacionDetalle.documentos.id_ProgramacionPago#"
                    id_ProgramacionPagoDetalle      = "#Local.ProgramacionDetalle.documentos.id_ProgramacionPagoDetalle#"
                    id_Documento                    = "#Local.ProgramacionDetalle.documentos.id_Documento#"
                    id_Proveedor                    = "#Local.ProgramacionDetalle.documentos.id_Proveedor#">

            </cfloop>

        </cfif>

    <cfif NOT isDefined("id_programacionpago") OR id_programacionpago EQ "">
        <cfset variables.RBR.setQuery(Local.programacion)>
    </cfif>
    <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="avisoAticipoProveedor" access="public" returntype="Any">
        <cfargument name="documentos"           type="array"        required="true"/>

            <cfloop from="1" to="#arrayLen(documentos)#" index="local.i">
                <cfif documentos[local.i].ID_PROVEEDOR NEQ nullValue()>
                    <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                        method="avisoAticipoProveedor"
                        id_proveedor ="#documentos[local.i].ID_PROVEEDOR#">
                </cfif>
            </cfloop>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="enviarapago" access="public" returntype="Any">
        <cfargument name="id_programacionpago"  type="numeric" required="yes">
        <cfargument name="documentos"           type="array" required="yes">
        <cfargument name="parcial"              type="numeric" required="yes">
        <cfargument name="id_Empresa"           type="numeric" required="yes">
        <cfargument name="id_Sucursal"          type="numeric" required="yes">

        <cfset estatus = 0>

        <cfloop from="1" to="#arrayLen(documentos)#" index="local.i">
            <cfif documentos[local.i].ID_ESTATUS NEQ 1115>

                <cfif documentos[local.i].ACCION.ID_ACCION EQ 1>
                    <cfset estatus = 1113>
                    <cfset estatusSol = 1127>
                </cfif>
                <cfif documentos[local.i].ACCION.ID_ACCION EQ 2>
                    <cfset estatus = 1111>
                    <cfset estatusSol = 1124>
                </cfif>

                <cfif documentos[local.i].ACCION.ID_ACCION NEQ 0>
                    <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                        method="actualizarestatus"
                        id_Empresa                 ="#documentos[local.i].ID_EMPRESADETALLE#"
                        id_Sucursal                ="#documentos[local.i].ID_SUCURSALDETALLE#"
                        id_programacionpago        ="#id_programacionpago#"
                        id_programacionpagoDetalle ="#documentos[local.i].ID_PROGRAMACIONPAGODETALLE#"
                        id_estatus                 ="#estatus#"
                        accion                     ="3"
                        id_documento               ="#documentos[local.i].ID_DOCUMENTO#"
                        cl_tipodocumento           ="#documentos[local.i].CL_TIPODOCUMENTO#"
                        id_sucursaldocumento       ="#documentos[local.i].ID_SUCURSALDOCUMENTO#"
                        de_Comentarios             ="#documentos[local.i].DE_COMENTARIOS#"
                        id_SolicitudPago           ="#documentos[local.i].ID_SOLICITUDPAGO#"
                        id_SolicitudPagoDetalle    ="#documentos[local.i].ID_SOLICITUDPAGODETALLE#"
                        returnvariable="Local.rs">

                    <cfif Local.rs.sn_Exist EQ 1>
                        <!---/**
                        * Se realiza la actualizacion de estatus de la requisicionCMF
                        * (si es que es una, lo verifica dentro del SP)
                        */--->
                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                            method="ActualizarEstatusCMF"
                            id_Empresa="#documentos[local.i].ID_EMPRESADETALLE#"
                            id_Sucursal="#id_Sucursal#"
                            id_programacionpago="#id_programacionpago#"
                            id_programacionpagoDet="#documentos[local.i].ID_PROGRAMACIONPAGODETALLE#"
                            id_estatus="#estatus#">
                    </cfif>
                </cfif>

            </cfif>
        </cfloop>

        <cfif parcial EQ 0>
            <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                method="actualizarestatus"
                id_Empresa          = "#id_Empresa#"
                id_Sucursal         = "#id_Sucursal#"
                id_programacionpago = "#id_programacionpago#"
                id_estatus          = "#estatus#"
                accion              = "4">
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerListadoOC" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="yes">
        <cfargument name="id_sucursal"          type="numeric" required="yes">
        <cfargument name="cl_tipodocumento"     type="string" required="yes">
        <cfargument name="id_Documento"         type="numeric" required="yes">

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                  method="obtenerListadoOC"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setDATA(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- jc generacion de excel para la pantalla de valuacion de inventarios 15-12-2015 --->
    <cffunction name="generarExcel"    access="public"     returntype="Any">
        <cfargument name="id_programacionpago" type="numeric"  required="false"/>
        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>
        <cfset arguments.id_Sucursal = #SESSION.ID_SUCURSAL#>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                    method="getDocumentosDetalleExcel"
                    argumentcollection="#arguments#"
                    returnvariable="Local.data">

        <cfset LocalResult = Local.data>
        <cfif #LocalResult.recordcount# EQ 0>
            <cfset variables.RBR.setError('No existen registros para mostrar.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset variables.RBR.setData(LocalResult)>
        <cfreturn variables.RBR>
        <!---
        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para generar el excel.')>
            <cfreturn variables.RBR>
        </cfif>
        <!--- <cfdump var="#Local.data#">
        <cfabort> --->

            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="ProgramacionPago#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
            }>

            <!--- Import the POI tag library. --->
            <cfimport taglib="/lib/tags/poi/" prefix="poi" />

            <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
                <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
            </cfif>
            <!---
                Create an excel document and store binary data into
                REQUEST variable.
            --->

            <poi:document
                name="REQUEST.ExcelData"
                file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                style="font-family: Arial ; font-size: 8pt ; color: black ; white-space: nowrap ;">


                <!--- Define style classes. --->
                <poi:classes>
                        <poi:class
                            name="title"
                            style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                            />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                        <poi:class
                            name="fondo"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT;"
                        />

                        <poi:class
                            name="familia"
                            style="border-bottom:2px;  background-color: GREY_40_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="subFamilia"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-bottom:2px; border-left:2px; border-rigth:2px;"
                        />
                        <poi:class
                            name="header"
                            style="font-family: Arial ; color: sky-blue ; font-size: 8pt; font-weight: bold;height: 35px"
                            />
                    </poi:classes>

                <!--- Define Sheets. --->
                <poi:sheets>
                    <poi:sheet
                        name="Reporte"
                        freezerow="8"
                        orientation="landscape"
                        zoom="80%">

                        <!--- Define global column styles. --->
                        <poi:columns>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px  ;"/>
                            <poi:column style="width: 100px  ;"/>
                            <poi:column style="width: 300px ;"/>
                            <poi:column style="width: 250px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                        </poi:columns>

                        <poi:row class=''>
                        </poi:row>

                        <!--- Title row. --->
                        <poi:row>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value="#Local.data.nb_empresa#" colspan="3"  class="title" style="text-align: center;"/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                        </poi:row>
                        <poi:row>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
                            <poi:cell value="Solicitud de pago a Proveedores" colspan="3"  class="title" style="text-align: center;font-size:8pt"/>
                        </poi:row>

                        <poi:row class=''>
                        </poi:row>

                        <poi:row class=''>
                        </poi:row>

                        <poi:row class=''>
                        </poi:row>

                        <poi:row class=''>
                        </poi:row>
                        <!--- Header row. --->
                        <poi:row >
                            <poi:cell value="Fecha Fact." class="header fondo borders"/>
                            <poi:cell value="Fecha Vto." class="header fondo borders"/>
                            <poi:cell value="Días de Crédito" class="header fondo borders"/>
                            <poi:cell value="Días Vencidos" class="header fondo borders"/>
                            <poi:cell value="Documento" class="header fondo borders"/>
                            <poi:cell value="Folio" class="header fondo borders"/>
                            <poi:cell value="Proveedor" class="header fondo borders"/>
                            <poi:cell value="Descripción y en que se utilizó:" class="header fondo borders"/>
                            <poi:cell value="PLAZA" class="header fondo borders"/>
                            <poi:cell value="TOTAL IVA DESGLOSADO" class="header fondo borders"/>
                            <poi:cell value="TOTAL IVA" class="header fondo borders"/>
                            <poi:cell value="Total" class="header fondo borders"/>
                            <poi:cell value="Anticipo" class="header fondo borders"/>
                            <poi:cell value="Total Neto" class="header fondo borders"/>
                            <poi:cell value="Total por Proveedor" class="header fondo borders"/>
                        </poi:row>
                        <cfset totalrows = 0>
                        <cfoutput query="local.data">
                            <poi:row>
                                <poi:cell value="#fh_vencimientoconvert#" class="Contenido borders"/>
                                <poi:cell value="#fh_documentoconvert#" class="Contenido borders"/>
                                <poi:cell value="#nu_diasCredito#" class="Contenido borders"/>
                                <poi:cell value="#nu_diasVencidos#" class="Contenido borders"/>
                                <poi:cell value="#nb_TipoDocumento#" class="Contenido borders"/>
                                <poi:cell value="#nu_FolioDocumento#" class="Contenido borders"/>
                                <poi:cell value="#nb_Proveedor#" class="Contenido borders"/>
                                <poi:cell value="" class="Contenido borders"/>
                                <poi:cell value="#nb_Sucursal#" class="Contenido borders"/>
                                <poi:cell value="#im_Gravado#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="im_GravadoRow#currentRow#"/>
                                <cfif #facturas# EQ #indice#>
                                    <poi:cell value="#im_sumaIVA#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="im_sumaIVARow#currentRow#"/>
                                <cfelse>
                                    <poi:cell value="" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha borders" alias="im_sumaIVARow#currentRow#"/>
                                </cfif>
                                <poi:cell value="#total#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="im_totalRow#currentRow#"/>
                                <poi:cell value="#anticipo#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="anticipoRow#currentRow#"/>
                                <cfset subtotal = #total# - #anticipo#>
                                <poi:cell value="#subtotal#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="subtotalRow#currentRow#"/>
                                <cfif #facturas# EQ #indice#>
                                    <poi:cell value="#im_SumaTOTAL#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="im_SumaTOTALRow#currentRow#"/>
                                <cfelse>
                                    <poi:cell value="" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha Contenido borders" alias="im_SumaTOTALRow#currentRow#"/>
                                </cfif>
                            </poi:row>

                            <cfset totalrows = totalrows + 1>
                        </cfoutput>
                        <poi:row>
                            <poi:cell index="2" value="" colspan="8"/>
                            <poi:cell value="SUM(@im_GravadoRow1:@im_GravadoRow#totalrows#)"     type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                            <poi:cell value="SUM(@im_sumaIVARow1:@im_sumaIVARow#totalrows#)"     type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                            <poi:cell value="SUM(@im_totalRow1:@im_totalRow#totalrows#)"         type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                            <poi:cell value="SUM(@anticipoRow1:@anticipoRow#totalrows#)"         type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                            <poi:cell value="SUM(@subtotalRow1:@subtotalRow#totalrows#)"         type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                            <poi:cell value="SUM(@im_SumaTOTALRow1:@im_SumaTOTALRow#totalrows#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="Contenido borders"/>
                        </poi:row>
                    </poi:sheet>
                </poi:sheets>

            </poi:document>

            <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                      method="addImage"
                      nb_excelFile="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                      src_image="#SERVER.ar_ImagenReporteBinary[session.ID_EMPRESA]#"
                      nb_sheet="Reporte"
                      nu_startRow="2"
                      nu_startCol="2"
                      nu_colWidth="2.7">

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>--->
    </cffunction>

    <cffunction name="cancelardocumento" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"                 type="numeric" required="true"/>
        <cfargument name="id_Sucursal"                type="numeric" required="true"/>
        <cfargument name="id_ProgramacionPago"        type="numeric" required='true'>
        <cfargument name="id_ProgramacionPagoDetalle" type="numeric" required="true"/>
        <cfargument name="id_Estatus"                 type="numeric" required="true"/>
        <cfargument name="de_MotivoCancelacion"       type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
            method="cancelardocumento"
            argumentcollection="#arguments#"
            returnvariable="local.rs"/>

        <!--- Enviar correo de notificacion al Gerente de Administracion --->
        <cfset correo = structNew()>
        <cfset correo.destinatarios = arrayNew(1)>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
            method="getEmailporCancelacionProg"
            id_Empresa="#arguments.id_Empresa#"
            id_ProgramacionPago="#arguments.id_ProgramacionPago#"
            id_ProgramacionPagoDetalle="#arguments.id_ProgramacionPagoDetalle#"
            returnvariable="local.Email"/>

        <cfloop query="local.Email">
            <cfif local.Email.DE_EMAIL NEQ '' && not arrayFind(correo.destinatarios, local.Email.DE_EMAIL)>
                <cfset arrayAppend(correo.destinatarios, local.Email.DE_EMAIL)>
            </cfif>
        </cfloop>

        <cfset correo.asunto = 'Notificación de Cancelación de Pago en Programación de Pago'>
        <cfset correo.sn_plantilla = "true">
        <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailCancelarDetalleProgramacion.html">
        <cfset correo.parametros = structNew()>
        <cfset correo.parametros.asunto = 'Cancelación de un pago en una Programación de Pago.'>
        <cfset correo.parametros.de_Mensaje = 'La factura en <b>' & local.rs.NB_EMPRESA & '</b> - <b>' & local.rs.NB_SUCURSAL & '</b> con el Folio: <b>'
            & local.rs.NU_FOLIODOCUMENTO & '</b> del Proveedor <b>' & local.rs.NB_PROVEEDOR & '</b>, su programación de pago fue cancelada.'>
        <cfset correo.parametros.nb_Empleado = UCase(session.NB_EMPLEADOCOMPLETO)>
        <cfset correo.parametros.de_Fecha = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >
        <cfset correo.parametros.de_Motivo = #arguments.de_MotivoCancelacion#>

        <cfset correo.imagenes=[
            {
                dir="#session.AR_IMAGENREPORTE#",
                disposicion='inline',
                name="logo"
            },
            <!--- {
                dir="assets/img/greenLeaf.jpg",
                disposicion='inline',
                name="footer"
            } --->
        ]>
        <!--- <cfif arrayLen(correo.destinatarios) GT 0> --->

        <!--- <cfcontent type="text/html">
        <cfdump var="#correo#" format="simple" label="arguments" abort="true"> --->

        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
            method="sendMail"
            argumentcollection="#correo#"
            returnvariable="Local.rbr"/>

        <cfif Local.rbr.hasError()>
            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
            <cfreturn variables.RBR>
        <cfelse>
            <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al comprador. Operaci&oacute;n exitosa. ")>
            <cfreturn variables.RBR>
        </cfif>

        <!--- </cfif> --->

        <cfreturn variables.RBR>
    </cffunction>



    <cffunction name="MarcarDocumentosValePesqueros" access="public" returntype="Any">
        <cfargument name="documentos"           type="array"        required="true"/>

            <cfloop from="1" to="#arrayLen(documentos)#" index="local.i">
                <cfif #documentos[local.i].CL_TIPODOCUMENTO# EQ "NF">
                    <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                        method="MarcarDocumentosValePesqueros"
                        id_Empresa         ="#session.ID_EMPRESA#"
                        id_Sucursal        ="#documentos[local.i].ID_SUCURSALDOCUMENTO#"
                        cl_TipoDocumento   ="#documentos[local.i].CL_TIPODOCUMENTO#"
                        id_Documento       ="#documentos[local.i].ID_DOCUMENTO#"
                        id_Usuario         ="#session.ID_USUARIO#">
                <cfelse>
                    <cfset variables.RBR.seterror('Solo se permite ajustar documentos de tipo Factura.')>
                    <cfreturn variables.RBR>
                </cfif>
            </cfloop>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="PagoDirecto" access="public" returntype="Any">
        <cfargument name="id_Sucursal"   type="string" required="true">
        <cfargument name="id_Proveedor"  type="string" required="true">
        <cfargument name="id_Solicitud"  type="string" required="true">

        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                  method="PagoDirecto"
                  argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="regresarCaptura" access="public" returntype="Any">
        <cfargument name="id_Empresa"          type="numeric" required="true"/>
        <cfargument name="id_ProgramacionPago" type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
            method="regresarCaptura"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
