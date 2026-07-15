<cfcomponent>
    <!--- <cfprocessingdirective pageencoding="utf-8"> --->
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="OrdenCompraEnviarCorreo" access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_OrdenDeCompra"     type="numeric" required="true"/>
        <cfargument name="sn_Politica" type="string" required="false" default="0">

        <cfset local.DatosCompra = structNew()>
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                    method="listarInformacionOrdenCompra"
                    id_Empresa="#Arguments.id_Empresa#"
                    id_OrdenCompra ="#Arguments.id_OrdendeCompra#"
                    id_Usuario="#session.ID_USUARIO#"
                    id_Cotizacion="0"
                    returnvariable = "local.InfoCompra">

        <cfif local.InfoCompra.RecordCount GT 0>
            <cfset local.DatosCompra.id_OrdenDeCompra = local.InfoCompra.id_OrdenDeCompra>
            <cfset local.DatosCompra.nb_Empleado = local.InfoCompra.nb_Empleado>
            <cfset local.DatosCompra.fh_Entrega = local.InfoCompra.fh_Entrega>
            <cfset local.DatosCompra.nb_Almacen = local.InfoCompra.nb_Almacen>
            <cfset local.DatosCompra.de_ComentarioEleccion = local.InfoCompra.de_Comentarios>
            <cfset local.DatosCompra.im_subtotal = local.InfoCompra.im_subtotal>
            <cfset local.DatosCompra.im_Total = local.InfoCompra.im_Total>
            <cfset local.DatosCompra.nb_empleadoautorizo = local.InfoCompra.nb_EmpleadoCompletoAutoriza>
            <cfset local.DatosCompra.im_Descuento = local.InfoCompra.im_Descuento>
            <cfset local.DatosCompra.importes = local.InfoCompra>
            <cfset local.DatosCompra.totalletra = local.InfoCompra.im_totalletra>
            <cfset local.DatosCompra.id_Empresa= arguments.id_Empresa>
        </cfif>
        <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                    method="listarInsumosparaAutorizarOrdenCompra"
                                    id_Empresa = "#Arguments.id_Empresa#"
                                    id_OrdenCompra ="#Arguments.id_OrdenDeCompra#"
                                    id_Cotizacion= "#local.InfoCompra.id_Cotizacion#"
                                    sn_Genero = "1"
                                    returnvariable="local.Insumos">

        <cfif local.InfoCompra.id_EstatusAutorizacionOrdenDeCompra EQ 2>
            <!--- Contactos del proveedor --->
            <cfset local.destinatarios = arrayNew(1)>
            <cfinvoke   component="#Application.RF.getPath('dao','ProveedoresContactos')#"
                                        method="EmailContacto"
                                        id_Empresa = "#Arguments.id_Empresa#"
                                        id_OrdenCompra = "#Arguments.id_OrdendeCompra#"
                                        returnvariable="local.Email">

            <cfloop query="local.Email">
                <cfset arrayAppend(Local.destinatarios, local.Email.de_Email)>
            </cfloop>
            <cfset arrayAppend(Local.destinatarios, session.DE_EMAIL)>
            <!--- <cfset arrayAppend(Local.destinatarios, 'jibarra@petroil.com.mx')> --->



            <cfset local.nb_Archivo = 'Ordendecompra_' & Replace(local.InfoCompra.nb_Empresa,' ', '_', 'all') & 'No' & local.InfoCompra.id_OrdenDeCompra>
            <cfinvoke   component="#Application.RF.getPath('bro','OrdenesCompras')#"
                        method="crearReporte"
                        DatosCompra="#local.DatosCompra#"
                        Insumos="#local.Insumos#"
                        nb_Archivo="#local.nb_Archivo#"
                        sn_Politica="#arguments.sn_Politica#">

            <cfset sleep(500)><!--- Espera de medio segundo --->

            <cfset Local.archivos=[{
                dir="Reportes/" & local.nb_Archivo & '.pdf',
                name='reporte',
                sn_deleteFile= "yes"
            }]>

            <cfset Local.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
          isLocal:true
                }
            ]>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                  method="sendMail"
                  destinatarios="#Local.destinatarios#"
                  asunto="Orden de Compra"
                  imagenes="#Local.imagenes#"
                  archivos="#Local.archivos#"
                  parametros="#Local.DatosCompra#"
                  id_Empresa="#arguments.id_Empresa#"
                  sn_plantilla="YES"
                  dir_plantilla="templates\correos\Compras\templateMailSurtirInsumos.html"
                  returnvariable="Local.rbr"/>
        <cfelseif local.InfoCompra.id_EstatusAutorizacionOrdenDeCompra EQ 3>

            <cfset correo.destinatarios = arrayNew(1)>
            <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="leer_CorreoComprador"
                    id_Empresa="#Arguments.id_empresa#"
                    id_OrdenDeCompra="#Arguments.id_OrdendeCompra#"
                    returnvariable="rs.Empleados">

            <cfset arrayAppend(correo.destinatarios, 'SistemaPetroil@gmail.com')>
            <!--- <cfset arrayAppend(correo.destinatarios, session.DE_EMAIL)> --->
            <cfloop query="rs.Empleados">
                <cfif rs.Empleados.de_Email NEQ ''>
                    <cfset arrayAppend(correo.destinatarios, rs.Empleados.de_Email)>
                </cfif>
            </cfloop>



            <cfset correo.asunto = 'Notificacion de Rechazo de OC'>
            <cfset correo.destinatarios= correo.destinatarios>
            <cfset correo.id_Empresa= Arguments.id_empresa>
            <cfset correo.sn_plantilla = "true">
            <cfset correo.dir_plantilla = "templates/correos/Compras/templateMailCancelarOC.html">
            <cfset correo.parametros = structNew()>
            <cfset correo.parametros.asunto = 'Rechazo de orden de compra.'>
            <cfset correo.parametros.de_Mensaje = 'La orden de compra con el Folio: ' & local.InfoCompra.id_OrdenDeCompra & ' ha sid&oacute; rechazada.'>
            <cfset correo.parametros.nb_Movimiento = 'Rechaz&oacute;'>
            <cfset correo.parametros.nb_Empleado = local.InfoCompra.nb_EmpleadoCompletoAutoriza>
            <cfset correo.parametros.de_Fecha = local.InfoCompra.de_FechaAutorizacion >
            <cfset correo.parametros.de_Observaciones = local.InfoCompra.de_Comentarios>

            <cfset correo.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
          name="footer",
          isLocal:true
                }
            ]>
        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
            method="sendMail"
            argumentcollection="#correo#"
            returnvariable="Local.rbr"/>

        </cfif>



        <cfif Local.rbr.hasError()>
            <cfset Variables.RBR.setError('Ocurrio un error al enviar el correo.')>
        </cfif>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="generarOrdenCompra" access="public" returntype="Any">
        <cfargument name="id_Empresa"                  type="numeric" required="true">
        <cfargument name="id_cotizacion"               type="string"  required="true"/>
        <cfargument name="id_requisicion"              type="string"  required="false"/>
        <cfargument name="id_proveedor"                type="string"  required="true"/>
        <cfargument name='id_ProveedorContacto'        type='string'  required='yes'>
        <cfargument name="sn_cotizacionElegida"        type="boolean" required="true"/>
        <cfargument name="de_comentarios"              type="string"  required="true"/>
        <cfargument name="fh_EntregaProbable"          type="string"  required="true"/>
        <cfargument name="ordenCompraDetalle"          type="array"   required="true"/>
        <cfargument name="id_moneda"                   type="string"  required="true"/>
        <cfargument name="nb_moneda"                   type="string"  required="true"/>
        <cfargument name='im_SubTotal'                 type='string'  required='true'/>
        <cfargument name='im_Descuento'                type='string'  required='true'/>
        <cfargument name='im_Total'                    type='string'  required='true'/>
        <cfargument name="impuestos"                   type="array"   required="true"/>
        <cfargument name="insumosComprar"              type="array"   required="true"/>
        <cfargument name="totalesOrdenCompra"          type="struct"  required="true"/>
        <cfargument name="de_observaciones"            type="string"  required="false"/>
        <cfargument name="sn_CorreoProveedor"          type="string"  required="false"/>
        <cfargument name="id_Sucursal"                 type="string"  required="false"/>
        <cfargument name="sn_DescuentoNC"              type="string"  required="false"/>

        <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>

        <cfset Local.ordenCompra=structNew()>
        <cfset Local.ordenCompra.id_Empresa=Arguments.id_empresa>
        <cfset Local.ordenCompra.id_Cotizacion=Arguments.id_cotizacion>
        <cfset Local.ordenCompra.fh_RegistroOrdenCompra=dateFormat(now(),'yyyymmdd')>
        <cfset Local.ordenCompra.fh_EntregaProbable="#Arguments.fh_EntregaProbable#">
        <cfset Local.ordenCompra.id_UsuarioRegistroOrdenCompra=session.ID_USUARIO>
        <cfset Local.ordenCompra.id_EstatusSurtido=3><!--- Sin Surtir --->
        <cfset Local.ordenCompra.id_Proveedor=Arguments.id_proveedor>
        <cfset Local.ordenCompra.id_ProveedorContacto=Arguments.id_ProveedorContacto>
        <cfset Local.ordenCompra.id_moneda=Arguments.id_moneda>
        <cfset Local.ordenCompra.nb_moneda=Arguments.nb_moneda>
        <cfset Local.ordenCompra.im_SubTotal=Arguments.totalesOrdenCompra.im_SubTotal>
        <cfset Local.ordenCompra.im_Descuento=Arguments.totalesOrdenCompra.im_descuento>
        <cfset Local.ordenCompra.im_Envio = Arguments.totalesOrdenCompra.im_Envio>
        <cfset Local.ordenCompra.sn_CorreoProveedor = Arguments.sn_CorreoProveedor>
        <cfset Local.ordenCompra.sn_DescuentoNC = Arguments.sn_DescuentoNC ? 1 : 0>

        <cfif isDefined("arguments.de_observaciones")>
            <cfset Local.ordenCompra.de_observaciones = Arguments.de_observaciones>
        <cfelse>
            <cfset Local.ordenCompra.de_observaciones = ''>
        </cfif>

        <cfif isDefined("arguments.nb_sucursal")>
            <cfset Local.ordenCompra.nb_sucursal = Arguments.nb_sucursal>
        <cfelse>
            <cfset Local.ordenCompra.nb_sucursal = ''>
        </cfif>


        <!--- Se trae el proveedor Contacto de la cotizacion --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="upR_emailProveedorCotizacion"
                    id_Empresa="#Arguments.id_Empresa#"
                    id_Cotizacion="#arguments.id_Cotizacion#"
                    returnvariable="datosProveedor">

        <!--- Se setea el proveedor contacto --->
        <cfset Local.ordenCompra.id_Proveedor=datosProveedor.ID_PROVEEDOR>
        <cfset Local.ordenCompra.id_ProveedorContacto=datosProveedor.ID_PROVEEDORCONTACTO>

        <!--- se valida que realmente el total de la orden de compra vengo en numerico y no como una cadena de con formato en string --->
        <cfif LSIsNumeric(arguments.totalesOrdenCompra.im_Total)>
            <cfset local.total = arguments.totalesOrdenCompra.im_Total>
        <cfelse>
            <cfset local.total = local.fnc.unformatNumber(arguments.totalesOrdenCompra.im_Total)>
        </cfif>

        <cfset Local.ordenCompra.im_Total = local.total>
        <cfset Local.ordenCompra.id_EstatusAutorizacionOrdenDeCompra=1>

        <!--- Convertimos el importe en moneda nacional de acuerdo al ultimo tipo de cambio de la moneda --->
        <cfset local.im_TipoCambioAutorizar = 1>
        <cfinvoke component="#Application.RF.getPath('dao','MonedasTipoCambio')#"
                    method="getUltimoim_TipoCambio"
                    id_Moneda="#Arguments.id_Moneda#"
                    returnvariable="local.RSTipoCambio">
         <cfif isNumeric(local.RSTipoCambio.im_TipoCambio)>
            <cfset local.im_TipoCambioAutorizar = local.RSTipoCambio.im_TipoCambio>
         </cfif>


        <cfset local.im_TotalAutorizar = local.total * local.im_TipoCambioAutorizar>


        <!---<cfdump var="#local.im_TotalAutorizar#">--->


        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="quienAutoriza"
                    id_Empresa="#Arguments.id_Empresa#"
                    Total="#local.im_TotalAutorizar#"
                    returnvariable="empleado">

        <cfif NOT empleado.id_Empleado GT 0>
            <cfset variables.RBR.setError('No es posible registrar la orden de compra por que no hay alguien configurado para autorizarla.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset Local.cotizacion={
            id_Empresa= Arguments.id_Empresa,
            id_cotizacion= Arguments.id_Cotizacion,
            sn_cotizacionElegida= Arguments.sn_cotizacionElegida?1:0,
            de_comentarios= Arguments.de_comentarios
        }>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="AgregarOrdenCompra"
                  argumentcollection="#Local.ordenCompra#"
                  returnvariable="Local.ordenCompra.id_OrdenDeCompra">

        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="updateComentarioElegida"
                  argumentcollection="#Local.cotizacion#">


        <cfset Local.ordenDetalle=structNew()>
        <cfset  i = 1>
        <cfloop array="#Arguments.insumosComprar#" index="Local.detalle">
            <cfset structClear(Local.ordenDetalle)>

            <cfset Local.ordenDetalle.id_Empresa = Arguments.id_Empresa>
            <cfset Local.ordenDetalle.id_OrdenDeCompra=Local.ordenCompra.id_OrdenDeCompra>
            <cfset Local.ordenDetalle.id_Cotizacion = "#arguments.id_Cotizacion#">
            <cfset Local.ordenDetalle.id_CotizacionDetalle = Local.detalle.ID_COTIZACIONDETALLE>

            <cfset Local.ordenDetalle.id_insumo = Local.detalle.id_insumo>
            <cfset Local.ordenDetalle.nu_cantidad = Local.detalle.NU_CANTIDADCOMPRAR>
            <cfset Local.ordenDetalle.im_Descuento = Local.detalle.IM_DESCUENTO>

            <cfif isDefined("Local.detalle.im_precioUnitario") and !isNull(Local.detalle.im_precioUnitario)>
                <cfset Local.ordenDetalle.im_precioUnitario=Local.fnc.unformatNumber(Local.detalle.im_precioUnitario)>
            </cfif>

            <cfif Local.detalle.pj_Descuento EQ ''>
                <cfset Local.ordenDetalle.pj_Descuento = 0>
            <cfelse>
                <cfset Local.ordenDetalle.pj_Descuento=Local.fnc.unformatNumber(Local.detalle.pj_Descuento)>
            </cfif>
            <cfset Local.ordenDetalle.nu_cantidadSurtida=0>
            <cfset Local.ordenDetalle.id_Moneda=Local.detalle.moneda.id_moneda>
            <cfset Local.ordenDetalle.im_TipoCambio=Local.detalle.moneda.im_TipoCambio>
            <cfset Local.ordenDetalle.nb_UnidadMedida=Local.detalle.NB_UNIDADMEDIDA>

            <cfset Local.ordenDetalle.id_EstatusSurtido=3>

            <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                      method="AgregarOrdenCompraDetalle"
                      argumentcollection="#Local.ordenDetalle#"
                      returnvariable="Local.OrdenDeCompraDetalle.id_OrdenDeCompraDetalle">

            <cfinvoke component="#Application.RF.getPath('dao','configuracionCamposDetalle')#"
                  method="obtenerEspecificacionesOrdenesCompra"
                  argumentcollection="#Local.ordenDetalle#"
                  id_Empresa ='#Arguments.id_Empresa#'
                  id_OrdenDeCompra ="#Local.ordenCompra.id_OrdenDeCompra#"
                  id_OrdenDeCompraDetalle ="#local.OrdenDeCompraDetalle.id_OrdenDeCompraDetalle#"
                  returnvariable="local.DetalleValoresDetalle.ValoresDetalle">

            <cfset arguments.insumosComprar[i].ValoresDetalle = local.DetalleValoresDetalle.ValoresDetalle>

            <cfset  i = i+1>


        </cfloop>

        <!---
            VERIFICAR SI SE TIENE PREAUTORIZADOR
            JOSE IBARRA
            14/12/2016
            Se realizan ambas consultas para comprara si es el mismo preautorizador y autorizador
        --->

        <!--- PREAUTORIZADOR --->
        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionPreAutorizacionOrdenesCompra')#"
            method="getConfiguracionPorEmpresa"
            id_Empresa="#Arguments.id_Empresa#"
            id_OrdenDeCompra ="#Local.ordenCompra.id_OrdenDeCompra#"
            id_Sucursal = "#Arguments.id_Sucursal#"
            returnvariable="Local.usuariosPreAutorizan">

        <cfif "#Local.usuariosPreAutorizan.prn.RecordCount#" GT 0>
            <cfset Local.usuariosPreAutorizan = Local.usuariosPreAutorizan.prn>
        <cfelseif "#Local.usuariosPreAutorizan.keyExists('scd')#">
            <cfif"#Local.usuariosPreAutorizan.scd.RecordCount#" GT 0>
                <cfset Local.usuariosPreAutorizan = Local.usuariosPreAutorizan.scd>
            <cfelse>
                <cfset Local.usuariosPreAutorizan = Local.usuariosPreAutorizan.prn>
            </cfif>
        <cfelse>
            <cfset Local.usuariosPreAutorizan = Local.usuariosPreAutorizan.prn>
        </cfif>

        <!--- AUTORIZADOR --->
        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionOrdenesCompra')#"
            method="getConfiguracionPorEmpresa"
            id_Empresa="#Arguments.id_Empresa#"
            id_Sucursal="#Arguments.id_Sucursal#"
            im_Autorizado ="#local.im_TotalAutorizar#"
            id_OrdenDeCompra ="#Local.ordenCompra.id_OrdenDeCompra#"
            returnvariable="Local.usuariosAutorizan">

        <!--- Verificar si es el mismo preautorizador y autorizador --->
        <!--- <cfset id_UsuarioPreautoriza = Local.usuariosPreAutorizan.id_usuario>
        <cfset id_UsuarioAutoriza    = Local.usuariosAutorizan.id_usuario> --->

        <cfset sn_PreAutorizacion = 1>
        <cfif Local.usuariosPreAutorizan.RecordCount EQ 0 >
            <cfset sn_PreAutorizacion = 0>
        </cfif>
        <!--- fin verificar preautorizador y autorizador --->
        <!---
            ENVIAR LA ORDEN DE COMPRA A PRE-AUTORIZAR
        --->
        <cfset local.sn_EnvioCorreo = 0>
        <cfif #Local.usuariosPreAutorizan.RecordCount# GT 0> <!-- AND sn_PreAutorizacion EQ 1 -->
            <!--- <cfif local.sn_EnvioCorreo NEQ 1>
                <cfset local.sn_EnvioCorreo = Local.usuariosPreAutorizan.sn_EnvioCorreo>
            </cfif> --->
            <cfset Local.usuarioPreAut=structNew()>
            <cfset Local.usuarioPreAut_Insert=structNew()>
            <cfset Local.destinatarios=arrayNew()>

            <cfloop query="Local.usuariosPreAutorizan">
                <cfif   local.im_TotalAutorizar GTE Local.usuariosPreAutorizan.nu_rangoInicioImporte
                    AND local.im_TotalAutorizar LTE Local.usuariosPreAutorizan.nu_rangoFinalImporte>
                    <cfset structClear(Local.usuarioPreAut)>

                    <cfset Local.usuarioPreAut.id_Empresa                          = Arguments.id_Empresa>
                    <cfset Local.usuarioPreAut.id_Sucursal                          = Arguments.id_Sucursal>
                    <cfset Local.usuarioPreAut.id_OrdenDeCompra                    = Local.ordenCompra.id_OrdenDeCompra>
                    <cfset Local.usuarioPreAut.id_UsuarioAutoriza                  = Local.usuariosPreAutorizan.id_usuario>
                    <cfset Local.usuarioPreAut.id_EstatusAutorizacionOrdenDeCompra = 1>
                    <cfset Local.usuarioPreAut.fh_AsignacionEstatus                = dateFormat(now(),'yyyymmdd')>

                    <cfif Local.usuariosPreAutorizan.de_email NEQ '' && not arrayFind(Local.usuarioPreAut_Insert,Local.usuariosPreAutorizan.de_email)>
                        <cfif Local.usuariosPreAutorizan.sn_EnvioCorreo EQ 1>
                            <cfset arrayAppend(Local.destinatarios,Local.usuariosPreAutorizan.de_email)>
                        </cfif>

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraUsuariosPreAutorizan')#"
                            method="AgregarOrdenCompraPreAutoriza"
                            argumentcollection="#Local.usuarioPreAut#">

                        <cfset arrayAppend(Local.usuarioPreAut_Insert,Local.usuariosPreAutorizan.de_email)>
                    </cfif>
                </cfif>
            </cfloop>

        <!---
            ENVIAR LA ORDEN DE COMPRA A AUTORIZAR
        --->
        <cfelse>
            <!--- <cfif local.sn_EnvioCorreo NEQ 1>
                <cfset local.sn_EnvioCorreo = Local.usuariosAutorizan.sn_EnvioCorreo>
            </cfif> --->
            <cfset Local.usuarioAut=structNew()>
            <cfset Local.usuarioAut_Insert=structNew()>
            <cfset Local.destinatarios=arrayNew()>

            <cfloop query="Local.usuariosAutorizan">
                <cfif   local.im_TotalAutorizar GTE Local.usuariosAutorizan.nu_rangoInicioImporte
                    AND local.im_TotalAutorizar LTE Local.usuariosAutorizan.nu_rangoFinalImporte>
                    <cfset structClear(Local.usuarioAut)>

                    <cfset Local.usuarioAut.id_Empresa                          = Arguments.id_Empresa>
                    <cfset Local.usuarioAut.id_Sucursal                         = Arguments.id_Sucursal>
                    <cfset Local.usuarioAut.id_OrdenDeCompra                    = Local.ordenCompra.id_OrdenDeCompra>
                    <cfset Local.usuarioAut.id_UsuarioAutoriza                  = Local.usuariosAutorizan.id_usuario>
                    <cfset Local.usuarioAut.id_EstatusAutorizacionOrdenDeCompra = 1>
                    <cfset Local.usuarioAut.fh_AsignacionEstatus                = dateFormat(now(),'yyyymmdd')>

                    <cfif Local.usuariosAutorizan.de_email NEQ '' && not arrayFind(Local.usuarioAut_Insert,Local.usuariosAutorizan.de_email)>
                        <cfif Local.usuariosAutorizan.sn_EnvioCorreo EQ 1>
                            <cfset arrayAppend(Local.destinatarios,Local.usuariosAutorizan.de_email)>
                        </cfif>

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraUsuariosAutorizan')#"
                            method="AgregarOrdenCompraAutoriza"
                            argumentcollection="#Local.usuarioAut#">

                        <cfset arrayAppend(Local.usuarioAut_Insert,Local.usuariosAutorizan.de_email)>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>

        <!--- **********************************************************************************************
            *************** Envio de Correo Para Autorizar por Movil solo si esta configurado ******************
            ************************************************************************************************--->
        <!--- <cfif local.sn_EnvioCorreo EQ 1> --->
        <cfif arrayLen(Local.destinatarios) GT 0>

            <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getById"
                id_empresa="#session.ID_EMPRESA#"
                id_ordenDeCompra="#Local.ordenCompra.id_OrdenDeCompra#"
                returnvariable="local.Master"/>

            <cfset Local.ordenCompra.id_Almacen = local.Master.ID_ALMACENENTREGA>
            <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                method="upR_EmpresaById"
                id_Empresa="#Arguments.id_Empresa#"
                returnvariable="Local.Empresa">

            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="getByID"
                id_Empresa="#Arguments.id_Empresa#"
                id_proveedor="#Arguments.id_proveedor#"
                returnvariable="Local.Proveedor">

            <cfset Local.ordenCompra.nb_empleado=session.NB_EMPLEADOCOMPLETO>
            <cfset Local.ordenCompra.nb_proveedor=Local.Proveedor.nb_proveedor>
            <cfif NOT isDefined("Arguments.id_requisicion")>
                <cfset Arguments.id_requisicion = ''>
            </cfif>
            <cfset Local.ordenCompra.id_requisicion=Arguments.id_requisicion>

            <cfset storageUrl = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/">

            <cfset Local.imagenes=[
                {
                dir="#storageUrl##Local.Empresa.ar_ImagenReporte#",
                disposicion='inline',
                name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
                    isLocal:true
                }
            ]>
            <cfif isDefined("Arguments.nb_moneda") AND Len(Trim(Arguments.nb_moneda)) GT 0>
                <cfset Local.parametros.nb_Moneda = arguments.nb_Moneda>
            </cfif>

            <cfset theURLBase = "http://">
            <cfif CGI.HTTPS EQ "on">
                <cfset theURLBase = 'https://' />
            </cfif>
            <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

            <cfset nb_Asunto = "Solicitud de Autorizacion de Orden de Compra">
            <cfif sn_PreAutorizacion EQ 1>
            <cfset nb_Asunto = "Solicitud de Pre-Autorizacion de Orden de Compra">
            </cfif>

            <cfset Local.parametros={
                id_Empresa     = (sn_PreAutorizacion EQ 1) ? Local.usuarioPreAut.id_Empresa : Local.usuarioAut.id_Empresa,
                id_Sucursal    = (sn_PreAutorizacion EQ 1) ? Local.usuarioPreAut.id_Sucursal : Local.usuarioAut.id_Sucursal,
                id_Almacen     = Local.ordenCompra.id_Almacen,
                nu_ordenCompra = Local.ordenCompra.id_OrdenDeCompra,
                nb_sucursal    = Local.ordenCompra.nb_sucursal,
                nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                nb_proveedor   = Local.Proveedor.nb_proveedor,
                fh_programada  = Local.ordenCompra.fh_EntregaProbable,
                nu_requisicion = Arguments.id_requisicion,
                im_total       = Local.ordenCompra.im_Total,
                webPath        = Local.webPath,
                sn_PreAutorizacion = sn_PreAutorizacion,
                nb_Asunto = nb_Asunto
            }/>

            <cfif isDefined("Arguments.nb_moneda") AND Len(Trim(Arguments.nb_moneda)) GT 0>
                <cfset Local.parametros.nb_Moneda = arguments.nb_Moneda>
            </cfif>

            <!---   Se elimino el envio de notificacion al por peticion via correo de Procesos (Magda) el dia 03/07/2018--->
            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                    method="sendMail"
                    destinatarios="#Local.destinatarios#"
                    asunto="#nb_Asunto#"
                    imagenes="#Local.imagenes#"
                    parametros="#Local.parametros#"
                    sn_plantilla="YES"
                    dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                    returnvariable="Local.rbr"/>
        </cfif>
        <!--- </cfif> --->

            <!--- Gruarda un registro a la tabla OrdenesDeCompraMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method = "agregarOrdenesDeCompraMovimientos"
                    id_empresa         = "#session.ID_EMPRESA#"
                    id_ordenDeCompra   = "#Local.ordenCompra.id_OrdenDeCompra#"
                    id_EmpresaEmpleado = "#session.ID_EMPRESAOPERADORA#"
                    id_Empleado        = "#session.ID_USUARIO#">

        <cfloop array="#Arguments.totalesOrdenCompra.impuestos#" index="Local.impuesto">
            <cfif Local.impuesto.sn_aplicar>
                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeComprasImpuestos')#"
                          method="RSAgregarImpuesto"
                          id_Empresa="#Arguments.id_Empresa#"
                          id_OrdenDeCompra="#Local.ordenCompra.id_OrdenDeCompra#"
                          id_Impuesto="#Local.impuesto.id_Impuesto#"
                          id_Taza="#Local.impuesto.id_Taza#"
                          pj_Aplicar="#Local.impuesto.pj_Aplicar#"
                          im_AplicacionImpuesto="#Local.fnc.unformatNumber(Local.impuesto.im_AplicacionImpuesto)#">
            </cfif>
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="getByID"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_proveedor="#Arguments.id_proveedor#"
                  returnvariable="Local.Proveedor">

        <cfset Local.ordenCompra.nb_empleado=session.NB_EMPLEADOCOMPLETO>
        <cfset Local.ordenCompra.nb_proveedor=Local.Proveedor.nb_proveedor>
        <cfif NOT isDefined("Arguments.id_requisicion")>
            <cfset Arguments.id_requisicion = ''>
        </cfif>
        <cfset Local.ordenCompra.id_requisicion=Arguments.id_requisicion>


        <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                  method="upR_EmpresaById"
                  id_Empresa="#Arguments.id_Empresa#"
                  returnvariable="Local.Empresa">

        <cfif arrayLen(Local.destinatarios) GT 0>
            <cfset Local.imagenes=[
                {
                    dir="#Local.Empresa.ar_ImagenReporte#",
                    disposicion='inline',
                    name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
          isLocal:true
                }
            ]>

            <cfset Local.parametros={
                nu_ordenCompra= Local.ordenCompra.id_OrdenDeCompra,
                nb_sucursal = Local.ordenCompra.nb_sucursal,
                nb_empleado= session.NB_EMPLEADOCOMPLETO,
                nb_proveedor= Local.Proveedor.nb_proveedor,
                fh_programada= Local.ordenCompra.fh_EntregaProbable,
                nu_requisicion= Arguments.id_requisicion,
                im_total= Local.ordenCompra.im_Total
            }/>

            <cfif isDefined("Arguments.nb_moneda") AND Len(Trim(Arguments.nb_moneda)) GT 0>
                <cfset Local.parametros.nb_Moneda = arguments.nb_Moneda>
            </cfif>
            <!---
                VERIFICAR SI SE TIENE PREAUTORIZADOR PARA MANDAR EL CORREO
                JOSE IBARRA
                14/12/2016
            --->

            <!---<cfinvoke component="#Application.RF.getPath('dao','ConfiguracionPreAutorizacionOrdenesCompra')#"
                        method="getConfiguracionPorEmpresa"
                        id_Empresa="#Arguments.id_Empresa#"
                        id_OrdenDeCompra ="#Local.ordenCompra.id_OrdenDeCompra#"
                        returnvariable="Local.usuariosPreAutorizan">--->

            <!---
                Se elimino el envio de notificacion al por peticion via correo de Procesos (Magda) el dia 03/07/2018
            <cfif #Local.usuariosPreAutorizan.RecordCount# GT '0' >

                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                          method="sendMail"
                          destinatarios="#Local.destinatarios#"
                          asunto="Solicitud de pre-autorización de orden de compra"
                          imagenes="#Local.imagenes#"
                          archivos="#Local.archivos#"
                          parametros="#Local.parametros#"
                          sn_plantilla="YES"
                          dir_plantilla="templates/correos/Compras/templateMailOrdenesCompraPre.html"
                          returnvariable="Local.rbr"/>

            <cfelse>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                          method="sendMail"
                          destinatarios="#Local.destinatarios#"
                          asunto="Solicitud de autorización de orden de compra"
                          imagenes="#Local.imagenes#"
                          archivos="#Local.archivos#"
                          parametros="#Local.parametros#"
                          sn_plantilla="YES"
                          dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                          returnvariable="Local.rbr"/>
            </cfif>
            --->

        </cfif>
        <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
        <cfelse>
            <cfset Variables.RBR.id_ordenDeCompra = Local.ordenCompra.id_OrdenDeCompra>
        </cfif>

        <cfreturn Variables.RBR>
    </cffunction>

    <cffunction name="SubirRutaArchivoAutorizacion" access="public" returntype="any">
        <cfargument name="id_Empresa"       type="numeric"  required="true"/>
        <cfargument name="id_OrdenCompra"   type="numeric"  required="true"/>
        <cfargument name="nombre"           type="string"   required="false"/>
        <cfargument name="ruta"             type="string"   required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="SubirRutaArchivoAutorizacion"
                  argumentcollection="#arguments#" 
                  returnvariable="local.rs"/>

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="ordenCompra"        type="struct" required="true">
        <cfargument name="ordenCompraDetalle" type="array"  required="true">
        <cfargument name="impuestos"          type="array"  required="true">

        <!--- <cfdump var="#arguments.ordenCompraDetalle#" /><cfabort /> --->
        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteRequisicion">
            <cfinclude template="../../templates/reportes/Compras/reporteAutortizarOrdenCompra.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteRequisicion#"
                  pdf="ordenCompra#Arguments.ordenCompra.id_OrdenDeCompra#"
                  debug="no"
                  path="#expandPath('../reporteOrdenesCompra/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <!---
        Comentarios: Función para traer información de una orden de compra por id.
        Autor: Mario Mejia.
        Fecha: 11/03/2015 --->
    <cffunction name="getByID" access="remote" returntype="any">
        <cfargument name="id_Empresa"       type="string" required="false">
        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="id_Usuario"       type="string" required="false">
        <cfargument name="sn_ParaEntrada"   type="boolean" required="false" default="false">
        <!--- <cfdump var="#arguments#" /><cfabort /> --->

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getById"
                id_empresa="#Arguments.id_Empresa#"
                id_ordenDeCompra="#Arguments.id_ordenDeCompra#"
                id_Usuario="#arguments.id_Usuario#"
                returnvariable="local.Master"/>

        <!--- <cfif local.Master.id_sucursalAlmacenEntrega NEQ SESSION.ID_SUCURSAL AND local.Master.recordCount GT 0>
            <cfset variables.RBR.setError('La orden de compra no existe para esta sucursal.')>
            <cfreturn variables.RBR>
        </cfif> --->

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalle"
                  id_empresa="#Arguments.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  sn_ParaEntrada="#Arguments.sn_ParaEntrada#"
                  returnvariable="local.Detalle"/>

        <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
                  method="getByOrdenDeCompra"
                  id_empresa="#Arguments.ID_EMPRESA#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Impuestos"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalleinsumospordevolucion"
                  id_empresa="#Arguments.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Detalleinsumosdevolucion"/>

          <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="upR_DetalleRequisicionByOCD"
                  id_empresa="#Arguments.ID_EMPRESA#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.DetalleReq"/>



        <cfset local.Data.insumosdevolucion = local.Detalleinsumosdevolucion>
        <cfset local.Data.Master = local.Master>
        <cfset local.Data.Detalle = local.Detalle>
        <cfset local.Data.DetalleReq = local.DetalleReq>
        <cfset Local.Data.Impuestos = Local.Impuestos>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="getByIDOC" access="remote" returntype="any">
        <cfargument name="id_ordenDeCompra" type="string" required="true">

        <!--- <cfdump var="#arguments#" /><cfabort /> --->

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getById"
                id_empresa="#session.ID_EMPRESA#"
                <!--- id_sucursal="#SESSION.ID_SUCURSAL#" --->
                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                returnvariable="local.Master"/>

        <!--- <cfif local.Master.id_sucursalAlmacenEntrega NEQ SESSION.ID_SUCURSAL AND local.Master.recordCount GT 0>
            <cfset variables.RBR.setError('La orden de compra no existe para esta sucursal.')>
            <cfreturn variables.RBR>
        </cfif> --->

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalleExistencias"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Detalle"/>

        <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
                  method="getByOrdenDeCompra"
                  id_empresa="#session.ID_EMPRESA#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Impuestos"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalleinsumospordevolucion"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Detalleinsumosdevolucion"/>



        <cfset local.Data = structNew()>
        <cfset local.Data.insumosdevolucion = local.Detalleinsumosdevolucion>
        <cfset local.Data.Master = local.Master>
        <cfset local.Data.Detalle = local.Detalle>
        <cfset Local.Data.Impuestos = Local.Impuestos>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="getByFolioOC" access="remote" returntype="any">
        <cfargument name="Folio" type="string" required="true">

        <!--- <cfdump var="#arguments#" /><cfabort /> --->

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getByFolio"
                id_empresa="#session.ID_EMPRESA#"
                id_sucursal="#SESSION.ID_SUCURSAL#"
                folio="#Folio#"
                returnvariable="local.Master"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getByFolioOCDetalle"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  folio="#arguments.Folio#"
                  returnvariable="local.Detalle"/>


        <cfset local.Data = structNew()>
        <cfset local.Data.Master = local.Master>
        <cfset local.Data.Detalle = local.Detalle>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getByIdProveedor" access="remote" returntype="any">
        <!--- En algunas pantallas id_proveedor no es requerido --->
        <cfargument name="id_Proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">
        <cfset arguments.id_empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getByIdProveedor"
                argumentcollection="#arguments#"
                returnvariable="local.RS"/>

        <cfif local.RS.recordCount EQ 0>
            <cfset variables.RBR.setError('Tu busqueda no produjo resultados.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfset local.Data = structNew()>
        <cfset local.Data.RS = local.RS>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getOrdenesSinSurtir" access="remote" returntype="any">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">
        <cfset arguments.id_empresa = session.ID_EMPRESA>
        <cfset arguments.id_sucursal = SESSION.ID_SUCURSAL>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOrdenesSinSurtir"
                argumentcollection="#arguments#"
                returnvariable="local.RS"/>

        <cfset local.Data = structNew()>
        <cfset local.Data.RS = local.RS>
        <cfset variables.RBR.setData(Local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getOrdenesSinSurtirDevolucion" access="remote" returntype="any">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOrdenesSinSurtirDevolucion"
                argumentcollection="#arguments#"
                returnvariable="local.RS"/>

        <cfset local.Data = structNew()>
        <cfset local.Data.RS = local.RS>
        <cfset variables.RBR.setData(Local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getOrdenesIncumplidas" access="remote" returntype="any">
        <cfargument name="id_sucursal"                    type="string" required="false"/>
        <cfargument name="id_Proveedor"                   type="string" required="false"/>
        <cfargument name="id_Departamento"                type="string" required="false"/>
        <cfargument name="id_Almacen"                     type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="id_insumo"                      type="string" required="false"/>
        <cfargument name="id_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfargument name="fh_inicio"                      type="string" required="false"/>
        <cfargument name="fh_fin"                         type="string" required="false"/>
        <cfargument name="nb_sucursal"                    type="string" required="false"/>
        <cfargument name="nb_proveedor"                   type="string" required="false"/>
        <cfargument name="nb_Departamento"                type="string" required="false"/>
        <cfargument name="nb_Almacen"                     type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"                      type="string" required="false"/>
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOrdenesIncumplidas"
                argumentcollection="#arguments#"
                returnvariable="local.RS"/>

        <cfset variables.RBR.setQuery(Local.RS)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="reporteIncumplimientoPorProveedorPDF"    access="public"     returntype="Any">
        <cfargument name="id_sucursal"                    type="string" required="false"/>
        <cfargument name="id_Proveedor"                   type="string" required="false"/>
        <cfargument name="id_Departamento"                type="string" required="false"/>
        <cfargument name="id_Almacen"                     type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="id_insumo"                      type="string" required="false"/>
        <cfargument name="id_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfargument name="fh_inicio"                      type="string" required="false"/>
        <cfargument name="fh_fin"                         type="string" required="false"/>
        <cfargument name="nb_sucursal"                    type="string" required="false"/>
        <cfargument name="nb_proveedor"                   type="string" required="false"/>
        <cfargument name="nb_Departamento"                type="string" required="false"/>
        <cfargument name="nb_Almacen"                     type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"                      type="string" required="false"/>
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOrdenesIncumplidas"
                argumentcollection="#arguments#"
                returnvariable="datos"/>

        <cfif #datos.recordcount# EQ 0>
            <cfset variables.RBR.setError('No se encontraron registros para generar el reporte.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteIncumplimientoPorProveedor#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfif Arguments.sn_Acumulado EQ 1>
            <cfsavecontent variable="DocumentodeEntrega">
                <cfinclude template="../../templates/reportes/compras/ReporteIncumplimientoPorProveedor.html">
            </cfsavecontent>
        <cfelse>
            <cfsavecontent variable="DocumentodeEntrega">
                <cfinclude template="../../templates/reportes/compras/ReporteIncumplimientoPorProveedorDetallado.html">
            </cfsavecontent>
        </cfif>


        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#DocumentodeEntrega#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>

    <!---
        Autor: Mario Mejia
        Fecha: 15/05/2015
                Funcion que crea los reportes en excel de las ordenes de
                compra con incumplimiento por parte del proveedor
     --->
    <cffunction name="reporteIncumplimientoPorProveedor" access="public" returntype="any">
        <cfargument name="nb_sucursal" type="string" required="false">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteIncumplimientoPorProveedor#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
        </cfif>
        <cfif arguments.sn_Acumulado EQ 1>
            <poi:document   name="REQUEST.ExcelData"
                            file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;"
                            >

                <poi:classes>
                    <poi:class  name="title"
                                style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                                />

                    <poi:class  name="fondo"
                                style="background-color: GREY_25_PERCENT; "
                                />

                    <poi:class  name="Total"
                                style="font-family: Arial ; color: black ; text-align: right; font-weight: bold; background-color: GREY_25_PERCENT;"
                                />
                                <poi:class name="left" style="border-left:2px solid black"/>
                                <poi:class name="right" style="border-right:2px solid black"/>
                                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                                <poi:class name="top" style="border-top:2px solid black"/>
                                <poi:class name="filtros" style="text-align:right;color:blue;font-weight:bold"/>

                    <poi:class  name="header"
                                style="font-family: Arial ; color: sky-blue ; font-size: 12pt; font-weight: bold;"
                                />
                </poi:classes>

                <poi:sheets>
                    <poi:sheet  name="Reporte"
                                freezerow="11"
                                orientation="landscape"
                                zoom="100%">

                        <poi:columns>
                            <poi:column style="width: 50px ;"/>

                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 180px ;"/>
                        </poi:columns>

                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Reporte de Incumplimiento por Proveedor" class="title" colspan="3"/>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                        </poi:row>

                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Sucursal:" class="filtros"/>
                            <poi:cell value="#arguments.NB_SUCURSAL#" />

                            <poi:cell value="Proveedor:" class="filtros"/>
                            <poi:cell value="#arguments.NB_PROVEEDOR#" />

                            <poi:cell value="Departamento:" class="filtros" />
                            <poi:cell value="#arguments.nb_Departamento#"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Almacen:" class="filtros"/>
                            <poi:cell value="#arguments.NB_ALMACEN#" />

                            <poi:cell value="Familia Insumo:" class="filtros"/>
                            <poi:cell value="#arguments.NB_FAMILIAINSUMO#" />

                            <poi:cell value="SubFamilia Insumo:" class="filtros"/>
                            <poi:cell value="#arguments.NB_SUBFAMILIAINSUMO#" />
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Insumo:" class="filtros"/>
                            <poi:cell colspan="3" value="#arguments.NB_INSUMO   #" />

                            <poi:cell value="Estatus Surtido:" class="filtros" />
                            <poi:cell value="#arguments.de_estatusSurtidoOrdenDeCompra#"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value="Periodo de tiempo del:" class="filtros"/>
                            <poi:cell value="#arguments.de_inicio#" />
                            <poi:cell value="Al:" class="filtros"/>
                            <poi:cell value="#arguments.de_fin#" />
                        </poi:row>

                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Clave OC" class="header fondo left bottom top" style="text-align: center"/>
                            <poi:cell value="Fecha Para Entrega" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Ultima Fecha de Entrega" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="D#chr(237)#as de Retraso" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Sucursal" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Proveedor" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Importe de Compra" class="header fondo right bottom top" style="text-align: center"/>
                        </poi:row>

                        <cfset importeTotal = 0>
                        <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>

                        <cfloop array="#arguments.registros#" index="registro">
                            <cfset importeTotal += Local.fnc.unformatNumber(registro.IM_TOTAL)>
                            <poi:row>
                                <poi:cell value=""/>
                                <poi:cell value="#javaCast("int",registro.ID_ORDENDECOMPRA)#" class="Contenido left bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.FH_ENTREGAPROBABLE#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.FH_ULTIMAENTREGA#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#javaCast("int",registro.NU_DIASRETRASO)#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.NB_SUCURSAL#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.NB_PROVEEDOR#" class="Contenido bottom top" style="text-align: left"/>
                                <poi:cell value="#Local.fnc.unformatNumber(registro.IM_TOTAL)#" class="Contenido right bottom top" style="text-align: right;" type="numeric" numberformat="($##,####0.00_);[Red]($##,####0.00)"/>
                            </poi:row>
                        </cfloop>

                        <poi:row class=''></poi:row>
                        <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="Total:" style="text-align:right;font-weight:bold;"/>
                        <poi:cell value="#importeTotal#" type="numeric" style="text-align: right;" numberformat="($##,####0.00_);[Red]($##,####0.00)" />
                        </poi:row>
                    </poi:sheet>
                </poi:sheets>
            </poi:document>
        <cfelse>
            <poi:document   name="REQUEST.ExcelData"
                            file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;"
                            >

                <poi:classes>
                    <poi:class  name="title"
                                style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                                />

                    <poi:class  name="fondo"
                                style="background-color: GREY_25_PERCENT; "
                                />

                    <poi:class  name="Total"
                                style="font-family: Arial ; color: black ; text-align: right; font-weight: bold; background-color: GREY_25_PERCENT;"
                                />
                                <poi:class name="left" style="border-left:2px solid black"/>
                                <poi:class name="right" style="border-right:2px solid black"/>
                                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                                <poi:class name="top" style="border-top:2px solid black"/>
                                <poi:class name="filtros" style="text-align:right;color:blue;font-weight:bold"/>

                    <poi:class  name="header"
                                style="font-family: Arial ; color: sky-blue ; font-size: 12pt; font-weight: bold;"
                                />
                </poi:classes>

                <poi:sheets>
                    <poi:sheet  name="Reporte"
                                freezerow="11"
                                orientation="landscape"
                                zoom="100%">

                        <poi:columns>
                            <poi:column style="width: 50px ;"/>

                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 180px ;"/>
                        </poi:columns>

                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Reporte de Incumplimiento por Proveedor" class="title" colspan="3"/>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                        </poi:row>

                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>
                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Sucursal:" class="filtros"/>
                            <poi:cell value="#arguments.NB_SUCURSAL#" />

                            <poi:cell value="Proveedor:" class="filtros"/>
                            <poi:cell value="#arguments.NB_PROVEEDOR#" />

                            <poi:cell value="Departamento:" class="filtros" />
                            <poi:cell value="#arguments.nb_Departamento#"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Almacen:" class="filtros"/>
                            <poi:cell value="#arguments.NB_ALMACEN#" />

                            <poi:cell value="Familia Insumo:" class="filtros"/>
                            <poi:cell value="#arguments.NB_FAMILIAINSUMO#" />

                            <poi:cell value="SubFamilia Insumo:" class="filtros"/>
                            <poi:cell value="#arguments.NB_SUBFAMILIAINSUMO#" />
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Insumo:" class="filtros"/>
                            <poi:cell colspan="3" value="#arguments.NB_INSUMO   #" />

                            <poi:cell value="Estatus Surtido:" class="filtros" />
                            <poi:cell value="#arguments.de_estatusSurtidoOrdenDeCompra#"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value=""/>
                            <poi:cell value="Periodo de tiempo del:" class="filtros"/>
                            <poi:cell value="#arguments.de_inicio#" />
                            <poi:cell value="Al:" class="filtros"/>
                            <poi:cell value="#arguments.de_fin#" />
                        </poi:row>

                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell value=""/>
                            <poi:cell value="Clave OC" class="header fondo left bottom top" style="text-align: center"/>
                            <poi:cell value="Fecha Para Entrega" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Ultima Fecha de Entrega" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="D#chr(237)#as de Retraso" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Sucursal" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Proveedor" class="header fondo  bottom top" style="text-align: center"/>
                            <poi:cell value="Importe de Compra" class="header fondo right bottom top" style="text-align: center"/>
                        </poi:row>

                        <cfset importeTotal = 0>
                        <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>

                        <cfloop array="#arguments.registros#" index="registro">
                            <cfset importeTotal += Local.fnc.unformatNumber(registro.IM_TOTAL)>
                            <poi:row>
                                <poi:cell value=""/>
                                <poi:cell value="#javaCast("int",registro.ID_ORDENDECOMPRA)#" class="Contenido left bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.FH_ENTREGAPROBABLE#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.FH_ULTIMAENTREGA#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#javaCast("int",registro.NU_DIASRETRASO)#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.NB_SUCURSAL#" class="Contenido bottom top" style="text-align: center"/>
                                <poi:cell value="#registro.NB_PROVEEDOR#" class="Contenido bottom top" style="text-align: left"/>
                                <poi:cell value="#Local.fnc.unformatNumber(registro.IM_TOTAL)#" class="Contenido right bottom top" style="text-align: right;" type="numeric" numberformat="($##,####0.00_);[Red]($##,####0.00)"/>
                            </poi:row>
                        </cfloop>

                        <poi:row class=''></poi:row>
                        <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="Total:" style="text-align:right;font-weight:bold;"/>
                        <poi:cell value="#importeTotal#" type="numeric" style="text-align: right;" numberformat="($##,####0.00_);[Red]($##,####0.00)" />
                        </poi:row>
                    </poi:sheet>
                </poi:sheets>
            </poi:document>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="addImage"
                  nb_excelFile="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                  src_image="#SERVER.ar_ImagenReporteBinary[session.ID_EMPRESA]#"
                  nb_sheet="Reporte"
                  nu_startRow="3"
                  nu_startCol="2"
                  nu_colWidth="3">

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 18/05/2015
          Cambia el estatus a cancelado de la orden de compra --->
    <cffunction name="cancelarOrdenCompra" access="remote" returntype="any">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="de_MotivoCancelacion" type="string" required="true">
        <cfargument name="sn_CorreoProveedor"   type="string" required="true">

         <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                method="cancelarDetalleByOrdenDeCompra"
                id_empresa="#Arguments.id_empresa#"
                id_ordenDeCompra="#Arguments.id_ordenDeCompra#"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                method="getEstatusSurtidoByOrdenDeCompra"
                id_empresa="#Arguments.id_empresa#"
                id_ordenDeCompra="#Arguments.id_ordenDeCompra#"
                returnvariable="Local.estatus"/>

        <cfif Local.estatus.recordCount EQ 1>
                <!--- Si solo hay un estatus en el detalle, tomo el valor de ese estatus --->
                <cfset Local.estatusSurtido = Local.estatus.id_EstatusSurtido >
        <cfelse>
                <!--- Si no, tendra un Cancelado Parcial --->
                <cfset Local.estatusSurtido = 5 >
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="set_Id_estatusSurtido"
                id_Empresa="#Arguments.id_empresa#"
                id_OrdenDeCompra="#Arguments.id_ordenDeCompra#"
                id_EstatusSurtido="#Local.estatusSurtido#"
                de_Descripcion="#Arguments.de_MotivoCancelacion#"/>

            <!--- Gruarda un registro a la tabla OrdenesDeCompraMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method = "agregarOrdenesDeCompraMovimientos"
                    id_empresa         = "#Arguments.id_Empresa#"
                    id_ordenDeCompra   = "#arguments.id_ordenDeCompra#"
                    id_EmpresaEmpleado = "#session.ID_EMPRESAOPERADORA#"
                    id_Empleado        = "#session.ID_USUARIO#">


        <!--- Enviar correo de notificacion al comprador --->
        <cfset correo = structNew()>
        <cfset correo.destinatarios = arrayNew(1)>
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="leer_CorreoComprador"
                id_Empresa="#Arguments.id_empresa#"
                id_OrdenDeCompra="#Arguments.id_ordenDeCompra#"
                returnvariable="rs.Empleados">

        <cfset arrayAppend(correo.destinatarios, 'SistemaPetroil@gmail.com')>
        <cfloop query="rs.Empleados">
            <cfif rs.Empleados.de_Email NEQ ''>
                <cfset arrayAppend(correo.destinatarios, rs.Empleados.de_Email)>
            </cfif>
        </cfloop>

        <!--- NOS VAMOS POR EL REQUISITANTE CUANDO EL TIPO DE REQUISICION ES DE SERVICIOS --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                    method="getRequisitanteTipoServicios"
                    id_Empresa = "#Arguments.id_empresa#"
                    id_ordencompra ="#Arguments.id_ordenDeCompra#"
                    returnvariable="local.requisitante">

        <cfloop query="local.requisitante">
            <cfset arrayAppend(correo.destinatarios, local.requisitante.DE_EMAIL)>
        </cfloop>
        <!--- FIN ADD REQUISITANTE --->

        <cfset correo.asunto = 'Notificacion de Cancelacion de OC'>
        <cfset correo.sn_plantilla = "true">
        <cfset correo.dir_plantilla = "templates/correos/Compras/templateMailCancelarOC.html">
        <cfset correo.parametros = structNew()>
        <cfset correo.parametros.asunto = 'Cancelaci&oacute;n de orden de compra.'>
        <cfset correo.parametros.de_Mensaje = 'La orden de compra con el Folio: ' & Arguments.id_ordenDeCompra & ' ha sid&oacute; cancelada.'>
        <cfset correo.parametros.nb_Movimiento = 'Cancel&oacute;'>
        <cfset correo.parametros.nb_Empleado = UCase(session.NB_EMPLEADOCOMPLETO)>
        <cfset correo.parametros.de_Fecha = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >

        <cfset correo.imagenes=[
            {
                dir="#session.AR_IMAGENREPORTE#",
                disposicion='inline',
                name="logo"
            },
            {
                dir="assets/img/greenLeaf.jpg",
                disposicion='inline',
                name="footer",
                isLocal:true
            }
        ]>

        <!---
            Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018
        <cfif arrayLen(correo.destinatarios) GT 0>
            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                      method="sendMail"
                      argumentcollection="#correo#"
                      returnvariable="Local.rbr"/>

            <cfif Local.rbr.hasError()>
                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
            <cfelse>
                <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al comprador. Operaci&oacute;n exitosa. ")>
            </cfif>
        <cfelse>
            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        </cfif>
        --->

        <!--- Se le envia una notificacion por correo al proveedor en caso de cancelacion de OC --->
        <cfif arguments.sn_CorreoProveedor>
            <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getById"
                id_empresa = "#Arguments.id_empresa#"
                id_ordenDeCompra ="#Arguments.id_ordenDeCompra#"
                returnvariable="local.OC">

            <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                method="getByID"
                id_empresa = "#Arguments.id_empresa#"
                id_Proveedor ="#local.OC.id_Proveedor#"
                returnvariable="local.Proveedor">

            <cfset email = structNew()>
            <cfset email.destinatarios = arrayNew(1)>
            <cfloop array="#local.Proveedor.de_Email.ListtoArray(';',false)#" index="loop.email">
                <cfif loop.email NEQ '' && not arrayFind(email.destinatarios,loop.email)>
                    <cfset arrayAppend(email.destinatarios, loop.email)>
                </cfif>
            </cfloop>

            <!--- <cfcontent type="text/html">
            <cfdump var="#email.destinatarios#" format="simple" label="arguments" abort="true"> --->

            <cfset email.asunto = 'Notificacion de Cancelacion de OC'>
            <cfset email.sn_plantilla = "true">
            <cfset email.dir_plantilla = "templates/correos/Compras/templateMailCancelarOC.html">
            <cfset email.parametros = structNew()>
            <cfset email.parametros.asunto = 'Cancelaci&oacute;n de Orden de Compra.'>
            <cfset email.parametros.de_Mensaje = 'Estimado Proveedor "' & local.Proveedor.NB_PROVEEDOR &'".<br><br>
                Te informamos por este medio que la Orden de Compra "' & Arguments.id_ordenDeCompra & '" ha sido cancelada,
                por el siguiente motivo: "' & Arguments.de_MotivoCancelacion & '". <br>Agradecemos tu atención y comprensión, quedamos a tu disposición para futuras transacciones. <br>Gracias.'>
            <cfset email.parametros.nb_Movimiento = 'Cancel&oacute;'>
            <cfset email.parametros.nb_Empleado = UCase(session.NB_EMPLEADOCOMPLETO)>
            <cfset email.parametros.de_Fecha = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >

            <cfset email.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
                    isLocal:true
                }
            ]>

            <cfif arrayLen(email.destinatarios) GT 0>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                          method="sendMail"
                          argumentcollection="#email#"
                          returnvariable="Local.rbr"/>

                <!--- <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                          method="sendMail"
                          destinatarios="#email.destinatarios#"
                          asunto="#email.asunto#"
                          imagenes="#email.imagenes#"
                          parametros="#email.parametros#"
                          id_UsuarioAutoriza="#email.parametros.nb_Empleado#"
                          sn_plantilla="YES"
                          dir_plantilla="#email.dir_plantilla#"
                          returnvariable="Local.RBR"/> --->

                <cfif Local.rbr.hasError()>
                    <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                <cfelse>
                    <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al comprador. Operaci&oacute;n exitosa. ")>
                </cfif>
            <cfelse>
                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            </cfif>
        </cfif>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 18/05/2015
          Cambia el estatus a cancelado de la orden de compra --->
    <cffunction name="listadoControl" access="remote" returntype="any">
        <cfargument name="id_Empresa"             type="string"  required="false">
        <cfargument name="id_Sucursal"            type="string"  required="false">
        <cfargument name="id_ordenDeCompra"       type="string" required="false">
        <cfargument name="fh_inicio"              type="string" required="false">
        <cfargument name="fh_fin"                 type="string" required="false">
        <cfargument name="id_proveedor"           type="string" required="false">
        <cfargument name="id_estatusAutorizacion" type="string" required="false">
        <cfargument name="id_estatusSurtido"      type="string" required="false">
        <cfargument name="page"                   type="numeric" required="true">
        <cfargument name="pageSize"               type="numeric" required="true">
        <cfargument name="id_SolicitudCompra"     type="string" required="false">
        <cfargument name="id_Requisicion"           type="string" required="false">
        <cfargument name="id_TipoDivision"          type="string" required="false">
        <cfargument name="nu_Siniestro"             type="string" required="false">

        <cfset Local.args={
            id_usuario= session.ID_USUARIO
        }>

        <cfif isDefined("Arguments.id_Empresa") AND Arguments.id_Empresa NEQ ''>
            <cfset Local.args.id_Empresa = Arguments.id_Empresa>
        </cfif>

        <cfif isDefined("Arguments.id_Sucursal") AND Arguments.id_Sucursal NEQ ''>
            <cfset Local.args.id_Sucursal = Arguments.id_Sucursal>
        </cfif>

        <cfif isDefined("Arguments.id_ordenDeCompra") AND Arguments.id_ordenDeCompra NEQ ''>
            <cfset Local.args.id_ordenDeCompra = Arguments.id_ordenDeCompra>
        </cfif>
        <cfif isDefined("Arguments.fh_inicio") AND Arguments.fh_inicio NEQ ''>
            <cfset Local.args.fh_inicio = Arguments.fh_inicio>
        </cfif>
        <cfif isDefined("Arguments.fh_fin") AND Arguments.fh_fin NEQ ''>
            <cfset Local.args.fh_fin = Arguments.fh_fin>
        </cfif>
        <cfif isDefined("Arguments.id_proveedor") AND Arguments.id_proveedor NEQ ''>
            <cfset Local.args.id_proveedor = Arguments.id_proveedor>
        </cfif>
        <cfif isDefined("Arguments.id_estatusAutorizacion") AND Arguments.id_estatusAutorizacion NEQ ''>
            <cfset Local.args.id_estatusAutorizacion = Arguments.id_estatusAutorizacion>
        </cfif>
        <cfif isDefined("Arguments.id_estatusSurtido") AND Arguments.id_estatusSurtido NEQ ''>
            <cfset Local.args.id_estatusSurtido = Arguments.id_estatusSurtido>
        </cfif>
        <cfif isDefined("Arguments.id_SolicitudCompra") AND Arguments.id_SolicitudCompra NEQ ''>
            <cfset Local.args.id_SolicitudCompra = Arguments.id_SolicitudCompra>
        </cfif>

        <cfif isDefined("Arguments.id_Requisicion") AND Arguments.id_Requisicion NEQ ''>
            <cfset Local.args.id_Requisicion = Arguments.id_Requisicion>
        </cfif>

        <cfif isDefined("Arguments.id_TipoDivision") AND Arguments.id_TipoDivision NEQ ''>
            <cfset Local.args.id_TipoDivision = Arguments.id_TipoDivision>
        </cfif>

        <cfif isDefined("Arguments.nu_Siniestro") AND Arguments.nu_Siniestro NEQ ''>
            <cfset Local.args.nu_Siniestro = Arguments.nu_Siniestro>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="listadoControl"
                  argumentcollection="#Local.args#"
                  page="#page#"
                  pageSize="#pageSize#"
                  returnvariable="Local.rs"/>

        <cfset Variables.rbr.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>


    <!--- Jesus Reyes --->
    <cffunction name="imprimirOC"    access="public"     returntype="Any">
        <cfargument name="id_Empresa" type="string" required="false"/>
        <cfargument name="id_Sucursal" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true"/>
        <cfargument name="sn_Politica" type="string" required="false" default="0">

        <cfif session.LOGGEDIN NEQ TRUE>
            <cfset variables.RBR.setError('En esta ocasión es necesario Autorizar/Rechazar la OC para poder descargar el archivo.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif not isDefined("Arguments.id_Sucursal")>
            <cfset Arguments.id_Sucursal = session.ID_SUCURSAL>
        </cfif>

        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOCImprimir"
                argumentcollection="#arguments#"
                returnvariable="Local.ordenDeCompra">

        <cfif Local.ordenDeCompra.recordCount EQ 0>
            <cfthrow type="warning" message="No se encontro la Orden de Compra solicitada.">
            <cfreturn Variables.RBR>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
                  method="getByOrdenDeCompra"
                  argumentcollection="#arguments#"
                  returnvariable="local.Impuestos"/>
                  
        <cfinvoke component="#Application.RF.getPath('dao','EmpresasEvaluadoras')#"
                method="getSucursalEvaluacion"
                id_Empresa = "#arguments.id_Empresa#"
                id_Sucursal = "#arguments.id_Sucursal#"
                returnvariable="local.rs"/>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ordenDeCompra_#Local.ordenDeCompra.id_ordenDeCompra#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="valuaciondeinventarios">
            <cfinclude template="../../templates/reportes/Compras/ordenDeCompra.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#valuaciondeinventarios#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>


    <cffunction name="MarcarSolicitudCompra" access="remote" returntype="any">
        <cfargument name="id_SolicitudCompra" type="string" required="true">
        <cfargument name="id_Empresa" type="string" required="true">
        <cfargument name="sn_Comprar" type="string" required="true">
        <cfargument name="de_ObservacionesNoComprar"    type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="MarcarSolicitudCompra"
                  argumentcollection="#arguments#"
                  />

        <!--- ENVIAR CORREO AL ALMACENISTA Y/O REQUISITANTE --->
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getInsumosPorSolicitudCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.insumos"/>

        <cfif Local.insumos.RecordCount>

            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getByID"
                  argumentcollection="#arguments#"
                  returnvariable="Local.SolicitudCompra"
                  />

            <cfset local.destinatarios = arrayNew(1)>
            <cfset arrayAppend(Local.destinatarios, Local.SolicitudCompra.de_Email)>
            <cfset Local.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer"
                }
            ]>

            <cfset local.ax = structNew()>
            <cfset local.InsumosCompletos = ArrayNew(1)>
            <cfloop query="Local.insumos">
                <cfset local.ax.NB_NOMBREINSUMO = #Local.insumos.NB_NOMBREINSUMO#>
                <cfset local.ax.NU_CANTIDADPENDIENTECOMPRA = #Local.insumos.NU_CANTIDADPENDIENTECOMPRA#>
                <cfset local.ax.NB_UNIDADMEDIDA = #Local.insumos.NB_UNIDADMEDIDA#>

                <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                <cfset local.ax = structNew()>
            </cfloop>

            <cfset Local.parametros={
                nb_sucursal                 = Local.SolicitudCompra.NB_SUCURSAL,
                id_requisicion              = Local.SolicitudCompra.ID_REQUISICION,
                id_SolicitudCompra          = Local.SolicitudCompra.ID_SOLICITUDCOMPRA,
                de_ObservacionesNoComprar   = Local.SolicitudCompra.DE_OBSERVACIONESNOCOMPRAR,
                sn_NoComprar                = Local.SolicitudCompra.SN_NOCOMPRAR,
                insumos                     = Local.InsumosCompletos
            }/>
            <!---
                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#Local.destinatarios#"
                asunto="Solicitud de Compra No Trabajada"
                imagenes="#Local.imagenes#"
                parametros="#Local.parametros#"
                sn_plantilla="YES"
                dir_plantilla="templates/correos/Compras/templateMailSolicitudCompraNoTrabajar.html"
                returnvariable="Local.RBR"/>
            --->
        </cfif>

         <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
        </cfif>


        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="generarReporte"    access="public"     returntype="Any">

        <cfargument name="id_Empresa"              type="string"  required="false">
        <cfargument name="id_Sucursal"              type="string"  required="false">
        <cfargument name="id_ordenDeCompra"         type="string"  required="false">
        <cfargument name="fh_inicio"                type="string"  required="false">
        <cfargument name="fh_fin"                   type="string"  required="false">
        <cfargument name="id_proveedor"             type="string"  required="false">
        <cfargument name="id_estatusAutorizacion"   type="string"  required="false">
        <cfargument name="id_estatusSurtido"        type="string"  required="false">
        <cfargument name="id_SolicitudCompra"       type="string" required="false">
        <cfargument name="id_Requisicion"           type="string" required="false">
        <cfargument name="id_TipoDivision"          type="string" required="false">

        <cfargument name="empresa"          type="string" required="false">
        <cfargument name="sucursal"         type="string" required="false">
        <cfargument name="folioR"           type="string" required="false">
        <cfargument name="folioSC"          type="string" required="false">
        <cfargument name="folioOC"          type="string" required="false">
        <cfargument name="fechaInicio"      type="string" required="false">
        <cfargument name="fechaFin"         type="string" required="false">
        <cfargument name="estatusA"         type="string" required="false">
        <cfargument name="proveedor"        type="string" required="false">
        <cfargument name="estatusS"         type="string" required="false">
        <cfargument name="division"         type="string" required="false">

        <cfset Local.args={
            id_usuario= session.ID_USUARIO
        }>

        <cfif isDefined("Arguments.id_Empresa") AND Arguments.id_Empresa NEQ ''>
            <cfset Local.args.id_Empresa = Arguments.id_Empresa>
        </cfif>

        <cfif isDefined("Arguments.id_Sucursal") AND Arguments.id_Sucursal NEQ ''>
            <cfset Local.args.id_Sucursal = Arguments.id_Sucursal>
        </cfif>

        <cfif isDefined("Arguments.id_ordenDeCompra") AND Arguments.id_ordenDeCompra NEQ ''>
            <cfset Local.args.id_ordenDeCompra = Arguments.id_ordenDeCompra>
        </cfif>
        <cfif isDefined("Arguments.fh_inicio") AND Arguments.fh_inicio NEQ ''>
            <cfset Local.args.fh_inicio = Arguments.fh_inicio>
        </cfif>
        <cfif isDefined("Arguments.fh_fin") AND Arguments.fh_fin NEQ ''>
            <cfset Local.args.fh_fin = Arguments.fh_fin>
        </cfif>
        <cfif isDefined("Arguments.id_proveedor") AND Arguments.id_proveedor NEQ ''>
            <cfset Local.args.id_proveedor = Arguments.id_proveedor>
        </cfif>
        <cfif isDefined("Arguments.id_estatusAutorizacion") AND Arguments.id_estatusAutorizacion NEQ ''>
            <cfset Local.args.id_estatusAutorizacion = Arguments.id_estatusAutorizacion>
        </cfif>
        <cfif isDefined("Arguments.id_estatusSurtido") AND Arguments.id_estatusSurtido NEQ ''>
            <cfset Local.args.id_estatusSurtido = Arguments.id_estatusSurtido>
        </cfif>
        <cfif isDefined("Arguments.id_SolicitudCompra") AND Arguments.id_SolicitudCompra NEQ ''>
            <cfset Local.args.id_SolicitudCompra = Arguments.id_SolicitudCompra>
        </cfif>

        <cfif isDefined("Arguments.id_Requisicion") AND Arguments.id_Requisicion NEQ ''>
            <cfset Local.args.id_Requisicion = Arguments.id_Requisicion>
        </cfif>

        <cfif isDefined("Arguments.id_TipoDivision") AND Arguments.id_TipoDivision NEQ ''>
            <cfset Local.args.id_TipoDivision = Arguments.id_TipoDivision>
        </cfif>

        <cfset Local.args.sn_Reporte = 1>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="listadoControlExcel"
                  argumentcollection="#Local.args#"
                  returnvariable="Local.rs"/>

        <cfset LocalResult = Local.rs>
        <cfif #LocalResult.recordcount# EQ 0>
            <cfset variables.RBR.setError('No existen registros para mostrar.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset variables.RBR.setData(LocalResult)>
        <cfreturn variables.RBR>

        <!---
        <cfif Local.rs.recordCount EQ 0>
            <cfset Variables.RBR.setError('El rango de fechas seleccionado no cuenta con informacion disponible para generar el reporte.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="OrdenesCompras#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
        </cfif>

        <poi:document
            name="REQUEST.ExcelData"
            file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">


            <poi:classes>
                <poi:class
                    name="title"
                    style="font-family: Arial; color: black; font-size:14pt; text-align:center; font-weight: bold;"
                />
                <poi:class
                    name="titleEncabezado"
                    style="font-family: Arial; color: black; font-size:18pt; text-align:center; font-weight: bold;"
                />
                <poi:class
                    name="negrita"
                    style="font-family: Arial ; color:black; font-weight: bold;text-align:right; font-size:12pt;"
                />
                <poi:class
                    name="fondo"
                    style="background-color: GREY_25_PERCENT; "
                />

                <poi:class
                    name="Total"
                    style="color: red; text-align: right ;"
                />

                <poi:class
                    name="borders"
                    style="border-top:2px; border-bottom:2px; border-left:2px; border-rigth:2px;"
                />
                <poi:class
                    name="header"
                    style="font-family: Arial ; color: black ; font-size: 12pt; font-weight: bold; text-align: Right ;"
                />

                <poi:class
                    name="odd"
                    style="background-color: GREY_25_PERCENT; "
                />

                <poi:class
                    name="totalSC"
                    style="background-color: YELLOW; "
                />

                <poi:class
                    name="totalEC"
                    style="background-color: GREY_25_PERCENT; "
                />

                <poi:class
                    name="totalGC"
                    style="background-color: BLUE; "
                />

                <poi:class
                    name="totalCC"
                    style="background-color: GREEN; "
                />

                <!---GRID--->
                <poi:class
                    name="tituloGrid"
                    style="font-family: Arial ; color:black; font-weight: bold;text-align:center; font-size:11pt;"
                />
            </poi:classes>

                    <!--- Define Sheets. --->
                    <poi:sheets>

                        <poi:sheet
                            name="Reporte"
                            orientation="landscape"
                            zoom="80%"
                            freezerow="11"
                            >
                            <!---Columnas globales del Excel--->
                            <poi:columns>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 180px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 200px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 120px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 200px ;"/>
                                <poi:column style="width: 150px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 80px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 120px ;"/>
                            </poi:columns>

                            <!--- Title row. --->
                            <poi:row>
                                <poi:cell value="#session.NB_RAZONSOCIAL#" class="title" style="text-align: left;"/>
                                <poi:cell index="12" value="#dateFormat(now(),'dd/mm/yyyy')#" class="negrita" style="text-align: right;"/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value="Sucursal #session.NB_SUCURSAL#" style="text-align:left"/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value="#session.NB_DIRECCION#" style="text-align:left"/>
                            </poi:row>
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell colspan="12" value='Relacion De Ordenes de Compra' style="text-align:center; font-size: 12px;font-weight: bold"/>
                            </poi:row>
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Empresa' class='negrita'/>
                                <poi:cell value='#Arguments.empresa#'/>
                                <poi:cell value='Sucursal' class='negrita'/>
                                <poi:cell value='#Arguments.sucursal#'/>
                                <poi:cell value='Folio Requisicion' class='negrita'/>
                                <poi:cell value='#Arguments.folioR#'/>
                                <poi:cell value='Folio SC' class='negrita'/>
                                <poi:cell value='#Arguments.folioSC#'/>
                                <poi:cell value='Folio OC' class='negrita'/>
                                <poi:cell value='#Arguments.folioOC#'/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Fecha Inicio' class='negrita'/>
                                <poi:cell value="#Arguments.fechaInicio#"/>
                                <poi:cell value='Fecha Fin' class='negrita'/>
                                <poi:cell value='#Arguments.fechaFin#'/>
                                <poi:cell value='Estatus Autorizacion' class='negrita'/>
                                <poi:cell value='#Arguments.estatusA#'/>
                                <poi:cell value='Estatus Surtido' class='negrita'/>
                                <poi:cell value='#Arguments.estatusS#'/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Division' class='negrita'/>
                                <poi:cell value='#Arguments.division#'/>
                                <poi:cell value='Proveedor' class='negrita'/>
                                <poi:cell value='#Arguments.proveedor#'/>
                            </poi:row>

                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell value="Empresa"       class="tituloGrid fondo borders"/>
                                <poi:cell value="Sucursal"      class="tituloGrid fondo borders"/>
                                <poi:cell value="Tipo"          class="tituloGrid fondo borders"/>
                                <poi:cell value="Division"      class="tituloGrid fondo borders"/>
                                <poi:cell value="Folio RE"      class="tituloGrid fondo borders"/>
                                <poi:cell value="Folio SC"      class="tituloGrid fondo borders"/>
                                <poi:cell value="Folio OC"      class="tituloGrid fondo borders"/>
                                <poi:cell value="Proveedor"     class="tituloGrid fondo borders"/>
                                <poi:cell value="Estatus A."    class="tituloGrid fondo borders"/>
                                <poi:cell value="Fecha Entrega" class="tituloGrid fondo borders"/>
                                <poi:cell value="Insumo"        class="tituloGrid fondo borders"/>
                                <poi:cell value="Descripcion"   class="tituloGrid fondo borders"/>
                                <poi:cell value="UDM"           class="tituloGrid fondo borders"/>
                                <poi:cell value="Solicitado"    class="tituloGrid fondo borders"/>
                                <poi:cell value="Entregado"     class="tituloGrid fondo borders"/>
                                <poi:cell value="Pendiente"     class="tituloGrid fondo borders"/>
                                <poi:cell value="Precio"        class="tituloGrid fondo borders"/>
                                <poi:cell value="Importe"       class="tituloGrid fondo borders"/>
                            </poi:row>

                            <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                              method="queryToJSon"
                              query="#Local.rs#"
                              returnvariable="Local.rs"/>

                            <cfloop array="#Local.rs#" index="Local.opcion">
                                <poi:row class=''>
                                    <poi:cell value="#Local.opcion.nb_Empresa#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.nb_Sucursal#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.de_TipoRequisicion#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.de_TipoDivision#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.id_Requisicion#"  style="text-align: right;"/>
                                    <poi:cell value="#Local.opcion.id_SolicitudCompra#"  style="text-align: right;"/>
                                    <poi:cell value="#Local.opcion.id_OrdendeCompra#"  style="text-align: right;"/>
                                    <poi:cell value="#Local.opcion.nb_proveedor#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.de_EstatusAutorizacionOrdenCompra#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.fh_EntregaProbableFormat#"  style="text-align: left"/>

                                    <poi:cell value="#Local.opcion.id_Insumo#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.nb_NombreInsumo#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.nb_UnidadMedida#"  style="text-align: left"/>
                                    <poi:cell value="#Local.opcion.nu_Cantidad#"  style="text-align: right;" type="numeric" numberformat="##,####0.00"/>
                                    <poi:cell value="#Local.opcion.nu_CantidadSurtida#"  style="text-align: right" type="numeric" numberformat="##,####0.00"/>
                                    <poi:cell value="#Local.opcion.nu_Cantidad - Local.opcion.nu_CantidadSurtida# "  style="text-align: right" type="numeric" numberformat="##,####0.00"/>
                                    <poi:cell value="#Local.opcion.im_PrecioUnitario#"  style="text-align: right;" type="numeric" numberformat="##,####0.00"/>
                                    <poi:cell value="#Local.opcion.im_TotalInsumo#"  style="text-align: right" type="numeric" numberformat="##,####0.00"/>

                                </poi:row>
                            </cfloop>

                        </poi:sheet>
                    </poi:sheets>
                </poi:document>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>--->
    </cffunction>

    <cffunction name="getById_Surtir" access="remote" returntype="any">
      <cfargument name="id_Empresa"           type="string" required="false">
      <cfargument name="id_ordenDeCompra"     type="string" required="true">
      <cfargument name="id_Usuario"           type="string" required="false">
      <cfargument name="id_TipoRequisicion"   type="string" required="false">
      <cfargument name="sn_ParaEntrada"       type="boolean" required="false" default="false">

      <cfif not isDefined("Arguments.id_Empresa")>
          <cfset Arguments.id_Empresa = session.ID_EMPRESA>
      </cfif>

      <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="getById_Surtir"
              id_empresa="#Arguments.id_Empresa#"
              id_sucursal="#SESSION.ID_SUCURSAL#"
              id_ordenDeCompra="#Arguments.id_ordenDeCompra#"
              id_Usuario="#Arguments.id_Usuario#"
              id_TipoRequisicion="#Arguments.id_TipoRequisicion#"
              returnvariable="local.Master"/>

      <!--- <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getDetalle"
                id_empresa="#Arguments.ID_EMPRESA#"
                id_sucursal="#SESSION.ID_SUCURSAL#"
                id_almacen="#session.ID_ALMACEN#"
                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                sn_ParaEntrada="#Arguments.sn_ParaEntrada#"
                returnvariable="local.Detalle"/> --->
        
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
            method="getDetalleDesglosado"
            id_empresa="#Arguments.ID_EMPRESA#"
            id_sucursal="#SESSION.ID_SUCURSAL#"
            id_almacen="#session.ID_ALMACEN#"
            id_ordenDeCompra="#arguments.id_ordenDeCompra#"
            sn_ParaEntrada="#Arguments.sn_ParaEntrada#"
            returnvariable="local.Detalle"/>

        <!--- <cfcontent type="text/html">
        <cfdump var="#local.Detalle#" format="simple" label="arguments" abort="true"> --->

      <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
                method="getByOrdenDeCompra"
                id_empresa="#Arguments.ID_EMPRESA#"
                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                returnvariable="local.Impuestos"/>

      <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getDetalleinsumospordevolucion"
                id_empresa="#Arguments.ID_EMPRESA#"
                id_sucursal="#SESSION.ID_SUCURSAL#"
                id_almacen="#session.ID_ALMACEN#"
                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                returnvariable="local.Detalleinsumosdevolucion"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="upR_DetalleRequisicionByOCD"
                id_empresa="#Arguments.ID_EMPRESA#"
                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                returnvariable="local.rs"/>

                <cfset info = StructNew()>
                <cfset info.insumosdevolucion     = local.Detalleinsumosdevolucion>
                <cfset info.Master   = Local.Master>
                <cfset info.Detalle = local.Detalle>
                <cfset info.DetalleReq    = Local.rs.DetalleReq>
                <cfset info.DetalleReqDuplicados    = Local.rs.DetalleReqDuplicados>
                <cfset info.Impuestos    = local.Impuestos>

      <!--- <cfset local.Data.insumosdevolucion = local.Detalleinsumosdevolucion>
      <cfset local.Data.Master = local.Master>
      <cfset local.Data.Detalle = local.Detalle>
      <cfset local.Data.DetalleReq = local.rs.DetalleReq>
      <cfset local.Data.DetalleReqDuplicados = local.rs.DetalleReqDuplicados>
      <cfset Local.Data.Impuestos = Local.Impuestos> --->
      <!--- <cfcontent type="text/html">
    <cfdump var="#info#" format="simple" label="arguments" abort="true"> --->
      <cfset variables.RBR.setData(info)>

      <cfreturn variables.RBR>
  </cffunction>

  <cffunction name="imprimirOCConta"    access="public"     returntype="Any">
    <cfargument name="id_Empresa" type="string" required="false"/>
    <cfargument name="id_ordenDeCompra" type="string" required="true"/>

    <cfif not isDefined("Arguments.id_Empresa")>
        <cfset Arguments.id_Empresa = session.ID_EMPRESA>
    </cfif>

    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
            method="getOCImprimirConta"
            argumentcollection="#arguments#"
            returnvariable="Local.ordenDeCompra">

    <cfif Local.ordenDeCompra.recordCount EQ 0>
        <cfset variables.RBR.setError('No se encontro la Orden de Compra solicitada.')>
        <cfreturn Variables.RBR>
    </cfif>

    <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
              method="getByOrdenDeCompra"
              argumentcollection="#arguments#"
              returnvariable="local.Impuestos"/>

    <cfset var Local.infoReport={
        de_directorio="Reportes",
        nb_archivo="ordenDeCompra_#Local.ordenDeCompra.id_ordenDeCompra#",
        ar_archivoPDF=""
    }>

    <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
    <cfsavecontent variable="valuaciondeinventarios">
        <cfinclude template="../../templates/reportes/Compras/ordenDeCompraConta.html">
    </cfsavecontent>

    <!--- Se hace el invoke del metodo que genera el PDF --->
    <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
              method="generatePDFNoDownload"
              content="#valuaciondeinventarios#"
              pdf="#local.infoReport.nb_archivo#"
              debug="no"
              path="#expandPath('../#local.infoReport.de_directorio#/')#">

    <cfset  Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
    <cfset  Local.infoReport.ar_archivoPDF=#valuaciondeinventarios# >

    <cfset variables.RBR.setData(Local.infoReport)>

    <cfreturn Variables.RBR>
</cffunction>

<cffunction name="GuardarInfoSustitucion" access="public" returntype="any">
    <cfargument name="id_Empresa"                   type="numeric" required="true"/>
    <cfargument name="id_OrdenCompra"               type="numeric" required="true"/>
    <cfargument name="sn_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="id_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="de_ObservacionesSustitucion"  type="string" required="true"/>
    <cfargument name="ar_SoporteSustitucion"        type="string" required="true"/>

    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="GuardarInfoSustitucion"
              argumentcollection="#arguments#"/>

    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

    <cfreturn variables.RBR>
</cffunction>


    <cffunction name="SearchDocumentoSustitucion"    access="public"     returntype="Any">
        <cfargument name="id_Empresa" type="string" required="false"/>
        <cfargument name="id_OrdenCompra" type="string" required="true"/>

        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="SearchDocumentoSustitucion"
                argumentcollection="#arguments#"
                returnvariable="local.OrdenCompra">

        <cfset local.Data = structNew()>
        <cfset local.Data.OC = local.OrdenCompra>

        <cfset variables.RBR.setData(Local.Data)>

        <cfreturn Variables.RBR>
    </cffunction>
</cfcomponent>
