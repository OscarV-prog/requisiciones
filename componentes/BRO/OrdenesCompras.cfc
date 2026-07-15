<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"                type="string" required="false"/>
        <cfargument name="id_SucursaListado"             type="string" required="false"/>
        <cfargument name="fh_InicioListado"              type="string" required="false"/>
        <cfargument name="fh_FinListado"                 type="string" required="false"/>
        <cfargument name="id_DepartamentoListado"        type="string" required="false"/>
        <cfargument name="id_EstatusAutorizacionListado" type="string" required="false"/>
        <cfargument name="id_EstatusSurtidoListado"      type="string" required="false"/>
        <cfargument name="nu_Siniestro"                  type="string" required="false"/>
        <cfargument name="id_TipoDocumento"              type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Usuario = session.ID_USUARIO>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
            method="listar"
            argumentcollection="#arguments#"
            returnvariable="Local.OrdenCompra">

        <cfset variables.RBR.setQuery(Local.OrdenCompra)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Modificacion: Rey David Dominguez
          Fecha: 13/03/2015
          Actualiza el ultimo precio compra de  cada insumo del detalle cuando la orden de compra
          se autoriza --->
    <cffunction name="Editar"            access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="numeric" required="false"/>
        <cfargument name="id_Sucursal"              type="numeric" required="false"/>
        <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
        <cfargument name="Estatus"                  type="string"  required="true"/>
        <cfargument name="de_Observaciones"         type="string"  required="true"/>
        <cfargument name="OrdenesCompras"           type="array"   required="true"/>
        <cfargument name="OrdenesServicio"          type="array"   required="false"/>
        <cfargument name="id_CotizacionReporte"     type="string"  required="false"/>
        <cfargument name="id_Almacen"               type="string"  required="false"/>
        <cfargument name="mRechazo"                 type="string"  required="false" default=""/>
        <cfargument name="sn_CorreoProveedor"       type="string"  required="false" default="false"/>

        <!---<cfdump var="#arguments.sn_CorreoProveedor#"/><cfabort />--->
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Usuario = session.ID_USUARIO>
        <cfset local.Autorizada = 2>
        <cfset local.Rechazada = 3>

        <cfset ff_Presupuestos = Application.RENV.getProperty('FF_PRESUPUESTOS')>

        <!--- Jose Miguel Tiznado --->
        <!--- Esta condicion se hace para quitar ordenes de compras repetidas --->
        <cfset Distinct_OrdenesCompras = arrayNew(1)>
        <cfloop index="local.i" from="#arrayLen(OrdenesCompras)#" to="1" step="-1">
            <cfif NOT ArrayContains(Distinct_OrdenesCompras, Arguments.OrdenesCompras[local.i].id_OrdenDeCompra)>
                <cfset ArrayAppend(Distinct_OrdenesCompras, Arguments.OrdenesCompras[local.i].id_OrdenDeCompra)>
            <cfelse>
                <cfset ArrayDeleteAt(Arguments.OrdenesCompras, local.i)>
            </cfif>
        </cfloop>



        <!--- Victor Sanchez
            13/08/2015
            se ejecuta para trael el nombre del almacen seleccionado--->
        <!--- Si el estatus es 1 'Autorizado'
        <cfif not isDefined("arguments.id_almacen") OR arguments.id_almacen EQ ''>
            <cfset nb_Almacen = structNew()>
            <cfset nb_Almacen.nb_Almacen = 'NA'>
            <cfset arguments.id_almacen = '3'>

        </cfif>--->
        <cfif #Estatus# EQ '1'>
            <cfinvoke   component="#Application.RF.getPath('dao','Almacenes')#"
                        method="getNameAlmacen"
                        id_Empresa = "#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen="#arguments.id_Almacen#"
                        returnvariable="nb_Almacen">
        <cfelse>
                <!--- Si la orden es rechazada 'Estatus=0' --->
            <!---
            <cfinvoke   component="#Application.RF.getPath('dao','Almacenes')#"
                        method="getNameAlmacen"
                        id_Empresa = "#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen="#session.ID_ALMACEN#"
                        returnvariable="nb_Almacen"> --->
        </cfif>


        <cfif NOT variables.RBR.hasError()>
            <cfif arrayLen(arguments.OrdenesCompras) GT 0 >
                <cfloop from="1" to="#arrayLen(arguments.OrdenesCompras)#" index="local.i">
                    <!--- Define si es la orden es autorizada o rechazada, 1 = Autorizada, 0 = Rechazada --->

                    <!---<cfdump var="#arguments.OrdenesCompras[local.i].sn_CorreoProveedor#"/><cfabort />--->

                    <cfif arguments.Estatus EQ 1>
                        <cfset local.DatosOrdenes = structNew()>
                        <cfset local.ConTotal = 0>
                        <cfset local.ConAutorizadas = 0>

                        <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                        <cfset local.DatosOrdenes.id_Empresa = arguments.id_Empresa>
                        <cfset local.DatosOrdenes.id_Sucursal = arguments.OrdenesCompras[local.i].id_sucursalAlmacenEntrega>
                        <!--- <cfset local.DatosOrdenes.id_Almacen = #arguments.id_Almacen#> --->
                        <cfset local.DatosOrdenes.id_Almacen = arguments.id_Almacen>

                        <cfset Local.DatosOrdenes.id_requisicion = arguments.OrdenesCompras[local.i].ID_REQUISICION>
                        <cfset Local.DatosOrdenes.nb_sucursal = arguments.OrdenesCompras[local.i].NB_SUCURSAL>
                        <cfset Local.DatosOrdenes.nb_proveedor = arguments.OrdenesCompras[local.i].NB_PROVEEDOR>
                        <cfset local.DatosOrdenes.fh_EntregaProbable = arguments.OrdenesCompras[local.i].FH_ENTREGAPROBABLE>

                        <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                        <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                        <cfset local.DatosOrdenes.id_OrdenCompra = arguments.OrdenesCompras[local.i].id_OrdenDeCompra>

                        <cfset local.DatosOrdenes.im_total = arguments.OrdenesCompras[local.i].IM_TOTAL>

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="Editar"
                                    argumentcollection="#local.DatosOrdenes#">

                        <!--- BUSCAR MAS AUTORIZADOR --->
                        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionOrdenesCompra')#"
                            method="getConfiguracionPorEmpresa"
                            id_empresa="#local.DatosOrdenes.id_Empresa#"
                            id_Sucursal="#local.DatosOrdenes.id_Sucursal#"
                            im_Autorizado ="#local.DatosOrdenes.im_total#"
                            id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                            returnvariable="Local.usuariosAutorizan">


                        <cfif #Local.usuariosAutorizan.RecordCount# GT 0>
                            <!--- <cfset local.sn_EnvioCorreo = Local.usuariosAutorizan.SN_ENVIOCORREO> --->
                            <cfset Local.usuarioAut=structNew()>
                            <cfset Local.usuarioAut_Insert=structNew()>
                            <cfset Local.destinatarios=arrayNew()>

                            <cfloop query="Local.usuariosAutorizan">
                                <cfif   local.DatosOrdenes.im_total GTE Local.usuariosAutorizan.nu_rangoInicioImporte
                                    AND local.DatosOrdenes.im_total LTE Local.usuariosAutorizan.nu_rangoFinalImporte>
                                    <cfset structClear(Local.usuarioAut)>

                                    <cfset Local.usuarioAut.id_Empresa                          = local.DatosOrdenes.id_Empresa>
                                    <cfset Local.usuarioAut.id_Sucursal                         = local.DatosOrdenes.id_Sucursal>
                                    <cfset Local.usuarioAut.id_OrdenDeCompra                    = local.DatosOrdenes.id_OrdenCompra>
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

                                        <cfset arrayAppend(Local.usuarioAut_Insert,Local.usuariosAutorizan)>
                                    </cfif>
                                </cfif>
                            </cfloop>

                             <!--- **********************************************************************************************
                            *************** Envio de Correo Para Autorizar por Movil solo si esta configurado ******************
                            ************************************************************************************************--->
                            <!--- <cfif local.sn_EnvioCorreo EQ 1> --->
                            <cfif arrayLen(Local.destinatarios) GT 0>

                                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                    method="getById"
                                    id_empresa="#session.ID_EMPRESA#"
                                    id_ordenDeCompra="#Local.DatosOrdenes.id_OrdenCompra#"
                                    returnvariable="local.Master"/>

                                <cfset Local.DatosOrdenes.id_Sucursal = local.Master.ID_SUCURSAL>
                                <cfset Local.DatosOrdenes.id_Almacen = local.Master.ID_ALMACENENTREGA>

                                <cfset Local.DatosOrdenes.nb_Moneda = local.Master.NB_MONEDA>

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

                                <cfset theURLBase = "http://">
                                <cfif CGI.HTTPS EQ "on">
                                    <cfset theURLBase = 'https://' />
                                </cfif>
                                <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

                                <cfset Local.parametros = {
                                    id_Empresa     = session.ID_EMPRESA,
                                    id_Sucursal    = Local.DatosOrdenes.id_Sucursal,
                                    id_Almacen     = Local.DatosOrdenes.id_Almacen,
                                    nu_ordenCompra = Local.DatosOrdenes.id_OrdenCompra,
                                    nb_sucursal    = Local.DatosOrdenes.nb_sucursal,
                                    nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                                    nb_proveedor   = Local.DatosOrdenes.nb_proveedor,
                                    fh_programada  = Local.DatosOrdenes.fh_EntregaProbable,
                                    nu_requisicion = Local.DatosOrdenes.id_requisicion,
                                    im_total       = Local.DatosOrdenes.im_total,
                                    nb_Moneda      = local.DatosOrdenes.nb_Moneda,
                                    webPath        = Local.webPath,
                                    nb_Asunto      = 'Solicitud de autorización de orden de compra',
                                    sn_Preautorizacion = 0
                                }/>

                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                    method="sendMail"
                                    destinatarios="#Local.destinatarios#"
                                    asunto="Solicitud de autorización de orden de compra"
                                    imagenes="#Local.imagenes#"
                                    parametros="#Local.parametros#"
                                    sn_plantilla="YES"
                                    dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                                    returnvariable="Local.rbr"/>


                            </cfif>
                            <!--- </cfif> --->
                        </cfif>
                        <cfif #Local.usuariosAutorizan.RecordCount# EQ 0> <!-- Si ya no hay mas autorizadores pendientes en prox niveles, continua el flujo -->
                            <!--- <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="listarOrdenesAsignadasaUsuarios"
                                        argumentcollection="#local.DatosOrdenes#"
                                        returnvariable="Local.Ordenes"> --->

                            <!--- <cfloop query="local.Ordenes">
                                <cfset local.ConTotal += 1>
                                <cfif local.Autorizada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                                    <cfset local.ConAutorizadas += 1>
                                </cfif>
                            </cfloop> --->


                            <!--- <cfif local.ConTotal EQ local.ConAutorizadas> --->
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="EditarOrdenCompraGeneral"
                                        argumentcollection="#local.DatosOrdenes#">
                            <!--- </cfif> --->

                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                        method="getById"
                                        id_empresa="#session.ID_EMPRESA#"
                                        id_ordenDeCompra="#arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                        returnvariable="Local.ordenDeCompra">

                            <cfset Local.argAlmancen=structNew()>
                            <cfif session.ID_ALMACEN NEQ ''>
                                <cfset Local.argAlmancen.id_almacen=session.ID_ALMACEN>
                            </cfif>

                            <!--- Obtener el detalle de la orden de compra --->
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                        method="getDetalle"
                                        id_empresa="#session.ID_EMPRESA#"
                                        id_ordenDeCompra="#arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                        argumentcollection="#Local.argAlmancen#"
                                        id_sucursal="#SESSION.ID_SUCURSAL#"
                                        returnvariable="Local.detalle">

                            <cfset Local.insumoUltimo=structNew()>

                            <cfloop query="Local.detalle">
                                <cfset structClear(Local.insumoUltimo) >
                                <cfinvoke   component="#Application.RF.getPath('dao','InsumosUltimoPrecioCompra')#"
                                            method="getNextID"
                                            id_empresa="#session.ID_EMPRESA#"
                                            id_insumo="#Local.detalle.id_insumo#"
                                            returnvariable="Local.insumoUltimo.id_insumoUltimoPrecioCompra">

                                <cfset Local.insumoUltimo.id_empresa = session.ID_EMPRESA>
                                <cfset Local.insumoUltimo.id_insumo = Local.detalle.id_insumo>
                                <cfset Local.insumoUltimo.im_PrecioCompra = Local.detalle.im_PrecioUnitario>
                                <cfset Local.insumoUltimo.id_moneda = Local.detalle.idMoneda>
                                <cfset Local.insumoUltimo.im_TipoCambio = Local.detalle.im_TipoCambio>
                                <cfset Local.insumoUltimo.id_Proveedor = Local.ordenDeCompra.id_Proveedor EQ ''?'NULL':Local.ordenDeCompra.id_Proveedor>
                                <cfset Local.insumoUltimo.fh_Compra="#dateFormat(Local.ordenDeCompra.fh_RegistroOrdenCompra,'yyyymmdd')# #timeFormat(now(),'HH:mm')#">


                                <cfinvoke   component="#Application.RF.getPath('dao','InsumosUltimoPrecioCompra')#"
                                            method="RSAgregar"
                                            argumentcollection="#Local.insumoUltimo#">
                            </cfloop>

                            <cfset local.DatosOrdenes = structNew()>
                            <cfset local.ConTotal = 0>
                            <cfset local.ConAutorizadas = 0>
                            <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                            <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                            <cfset local.DatosOrdenes.id_sucursal = SESSION.ID_SUCURSAL>
                            <cfset local.DatosOrdenes.id_Almacen = arguments.id_almacen>

                            <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                            <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                            <cfset local.DatosOrdenes.id_OrdenCompra = arguments.OrdenesCompras[local.i].id_OrdenDeCompra>



                            <!--- <cfinvoke     component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="Editar"
                                        argumentcollection="#local.DatosOrdenes#">   --->

                            <!--- <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                            method="listarOrdenesAsignadasaUsuarios"
                                            argumentcollection="#local.DatosOrdenes#"
                                            returnvariable="Local.Ordenes">

                            <cfloop query="local.Ordenes">
                                <cfset local.ConTotal += 1>
                                <cfif local.Autorizada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                                    <cfset local.ConAutorizadas += 1>
                                </cfif>
                            </cfloop> --->


                            <!--- <cfif local.ConTotal EQ local.ConAutorizadas> --->
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="EditarOrdenCompraGeneral"
                                        argumentcollection="#local.DatosOrdenes#">
                            <!--- </cfif> --->

                            <!--- JULIO CESAR ACOSTA LOPEZ
                                  19/05/2015
                                  HORA:13:40
                                  EMPIEZA LA CREACION DEL CORREO PARA NOTIFICAR QUE SE HA AUTORIZADO UNA ORDEN DE COMPRA AL PORVEEDOR Y QUE DEBE SU COTIZACION
                                  FUE ELEGIDA PARA SER SURTIDA DICHOS INSUMOS--->
                            <!--- julio cesar acosta lopez 19/05/2015 funcion que trae el email del contacto del proveedor
                                    al cual se le notificara de la autorizacion de la compra --->

                            <cfinvoke   component="#Application.RF.getPath('dao','ProveedoresContactos')#"
                                        method="EmailContacto"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_OrdenCompra = "#arguments.OrdenesCompras[local.i].id_OrdendeCompra#"
                                        returnvariable="local.Email">


                            <!--- julio cesar acosta lopez 19/05/2015 funcion para traer los insumos que se mandaran en el archivo adjunto
                                    al correo para ser mas especifico de que insumos se compraran --->

                            <!--- <cfif not isDefined("arguments.id_CotizacionReporte")>

                            </cfif>  --->

                            <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                        method="listarInsumosparaAutorizarOrdenCompra"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_Cotizacion= "#arguments.OrdenesCompras[local.i].id_Cotizacion#"
                                        id_ordencompra ="#arguments.OrdenesCompras[local.i].id_ordendecompra#"
                                        sn_Genero = "1"
                                        returnvariable="local.Insumos">


                            <!--- estructura para almacenar la informacion que se pondra en el pdf y correo asi como el arreglo de destinatarios --->
                            <cfset local.DatosCompra = structNew()>
                            <cfset local.destinatarios = arrayNew(1)>

                            <cfloop query="local.Email">
                                <cfset arrayAppend(Local.destinatarios, local.Email.DE_EMAIL)>
                            </cfloop>

                            <!--- NOS VAMOS POR EL REQUISITANTE CUANDO EL TIPO DE REQUISICION ES DE SERVICIOS --->
                            <!---
                                Se elimino el envio de notificacion por peticion via correo de Procesos (Magda) el dia 03/07/2018

                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="getRequisitanteTipoServicios"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_ordencompra ="#arguments.OrdenesCompras[local.i].id_ordendecompra#"
                                        returnvariable="local.requisitante">

                            <cfloop query="local.requisitante">
                                <cfset arrayAppend(Local.destinatarios, local.requisitante.DE_EMAIL)>
                            </cfloop>
                            --->
                            <!--- FIN ADD REQUISITANTE --->

                            <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="listarInformacionOrdenCompra"
                                        id_Empresa="#arguments.id_Empresa#"

                                        id_OrdenCompra ="#OrdenesCompras[local.i].id_OrdendeCompra#"
                                        <!--- cambios se mando el id_usuario 23/10/2015 --->
                                        id_usuario = "#session.ID_USUARIO#"
                                        id_Cotizacion = "#arguments.OrdenesCompras[local.i].id_Cotizacion#"
                                        returnvariable = "local.InfoCompra">

                            <!---
                            Si es una OC generada en automatico por flujo de Edenred se genera en automatico:
                                - Recepción de servicios
                                - Subir factura portal
                                - Recepción de factura
                            --->

                            <cfif local.InfoCompra.sn_ProcesoEdenred EQ 1>
                                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="AutorizarOCEdenred"
                                    id_Empresa               = "#Arguments.id_Empresa#"
                                    id_SolicitudPago         = "#local.InfoCompra.id_SolicitudPago#"
                                    id_OrdenCompra           ="#OrdenesCompras[local.i].id_OrdendeCompra#"
                                    id_EstatusAutorizacionOC = "#Arguments.Estatus#"
                                    returnvariable="local.validacionOC">

                                <!--- Recuperamos la bandera de presupuesto por la sucursal --->
                                <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                                    method         = "getBanderaPresupuestoSucursal"
                                    id_Empresa     = "#session.id_Empresa#"
                                    id_Sucursal    = "#arguments.id_Sucursal#"
                                    returnvariable = "local.sucursal_bandera">

                                <!--- Si se encuentra activado el consumo de presupuestos se hacen las validaciones --->
                                <!--- revisamos presupuesto para abastecedoras --->
                                <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
                                    <cfset local.jsonres = "">
                                    <cfloop query="local.validacionOC">
                                        <!--- Si no hay presupuesto disponible concatenamos el detalle del error --->
                                        <cfif isDefined("local.validacionOC.sn_Error") AND local.validacionOC.sn_Error EQ 1>
                                            <cfset local.jsonres = local.jsonres & '{
                                                "nb_GrupoGasto": "#local.validacionOC.nb_GrupoGasto#",
                                                "im_PresupuestoFaltante": "#local.validacionOC.im_PresupuestoFaltante#",
                                                "nb_CuentaConcepto": "#local.validacionOC.de_CuentaConcepto#",
                                                "nb_Solicitante": "#local.validacionOC.nb_Solicitante#",
                                                "de_Email": "#local.validacionOC.de_Email#",
                                                "nb_Empresa": "#local.validacionOC.nb_Empresa#",
                                                "nb_Jefe": "#local.validacionOC.nb_Jefe#",
                                                "de_Email_Jefe": "#local.validacionOC.de_Email_Jefe#",
                                                "id_SolicitudPago": "#local.InfoCompra.id_SolicitudPago#"
                                            },'>
                                        </cfif>
                                    </cfloop>

                                    <!--- Si jsonres no está vacío retornamos error --->
                                    <cfif len(local.jsonres) GT 0>
                                        <cfset local.jsonres = "sn_PresupuestoFaltante<>[" & left(local.jsonres, len(local.jsonres)-1) & "]">
                                        <cfset variables.RBR.setError(local.jsonres)>
                                        <cfreturn variables.RBR>
                                    </cfif>
                                </cfif>
                            </cfif>

                            <!---/**
                             * Si la OC fue generada por el proceso de carga masiva de facturas
                             * realiza en automatico la recepcion de servicios
                             */--->
                            <cfif local.InfoCompra.sn_ProcesoCMF EQ 1>
                                <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                          method="RecepcionServiciosCMF"
                                          id_Empresa = "#arguments.id_Empresa#"
                                          id_OrdenCompra = "#OrdenesCompras[local.i].id_OrdendeCompra#">
                            </cfif>

                            <!--- <cfdump var="#local.InfoCompra#"/><cfabort />

                            <cfdump var="#local.InfoCompra['de_Comentarios']#" /><cfabort /> --->
                            <cfset local.cont = 0>

                            <cfloop query="local.InfoCompra">
                                <cfif local.cont eq 0>
                                    <!--- <cfset local.DatosCompra.id_Cotizacion = local.InfoCompra.id_Cotizacion> --->
                                    <cfset local.DatosCompra.id_OrdenDeCompra = local.InfoCompra.id_OrdenDeCompra>
                                    <cfset local.DatosCompra.nb_Empleado = local.InfoCompra.nb_Empleado>
                                    <cfset local.DatosCompra.fh_Entrega = local.InfoCompra.fh_Entrega>
                                    <cfset local.DatosCompra.nb_Almacen = nb_Almacen.nb_Almacen>
                                    <cfset local.DatosCompra.de_ComentarioEleccion = local.InfoCompra.de_Comentarios>

                                    <cfset local.DatosCompra.im_subtotal = local.InfoCompra.im_subtotal>
                                    <cfset local.DatosCompra.im_Total = local.InfoCompra.im_Total>
                                    <cfset local.DatosCompra.nb_empleadoautorizo = session.NB_EMPLEADOCOMPLETO>
                                    <cfset local.DatosCompra.im_Descuento = local.InfoCompra.im_Descuento>
                                    <cfset local.DatosCompra.importes = local.InfoCompra>
                                    <cfset local.DatosCompra.totalletra = local.InfoCompra.im_totalletra>
                                    <cfset local.cont += 1>

                                <cfelse>
                                    <cfset local.cont = 0>
                                    <cfbreak>
                                </cfif>

                            </cfloop>

                            <cfset local.nb_Archivo = 'Ordendecompra_' & Replace(local.InfoCompra.nb_Empresa,' ', '_', 'all') & 'No' & local.InfoCompra.id_OrdenDeCompra>
                            <!--- <cfset crearReporte(local.DatosCompra,local.Insumos, local.nb_Archivo)> --->
                            <cfinvoke   component="#Application.RF.getPath('bro','OrdenesCompras')#"
                                        method="crearReporte"
                                        DatosCompra="#local.DatosCompra#"
                                        Insumos="#local.Insumos#"
                                        id_Empresa = "#arguments.id_Empresa#"
                                        id_Sucursal = "#arguments.id_Sucursal#"
                                        nb_Archivo="#local.nb_Archivo#">

                            <cfinvoke component="#Application.RF.getPath('dao','EmpresasEvaluadoras')#"
                                        method="getSucursalEvaluacion"
                                        id_Empresa = "#SESSION.id_Empresa#"
                                        id_Sucursal = "#SESSION.id_Sucursal#"
                                        returnvariable="local.rs"/>


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
                                    name="logo",
                                },
                                {
                                    dir="assets/img/greenLeaf.jpg",
                                    disposicion='inline',
                                    name="footer",
                                    isLocal="true"
                                }
                            ]>


                            <!---<cfdump var="#arguments.OrdenesCompras[local.i].sn_CorreoProveedor#"/><cfabort />--->

                            <cfif local.InfoCompra.sn_CorreoProveedor EQ 0>

                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                          method="sendMail"
                                          destinatarios="#Local.destinatarios#"
                                          asunto="Orden de Compra"
                                          imagenes="#Local.imagenes#"
                                          archivos="#Local.archivos#"
                                          parametros="#Local.DatosCompra#"
                                          sn_plantilla="YES"
                                          dir_plantilla="templates\correos\Compras\templateMailSurtirInsumos.html"
                                          returnvariable="Local.rbr"/>

                                <cfif Local.rbr.hasError()>
                                    <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                                </cfif>

                            </cfif>
                            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                        </cfif>


                    <cfelseif arguments.Estatus EQ 0>
                        <!--- OC Rechazada --->
                        <cfset local.DatosOrdenes = structNew()>
                        <cfset local.ConRechazadas = 0>
                        <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                        <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                        <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                        <cfset local.DatosOrdenes.id_Sucursal = SESSION.ID_SUCURSAL>
                        <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                        <cfset local.DatosOrdenes.id_OrdenCompra = arguments.OrdenesCompras[local.i].id_OrdenDeCompra>

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="Editar"
                                    argumentcollection="#local.DatosOrdenes#">

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="listarOrdenesAsignadasaUsuarios"
                                        argumentcollection="#local.DatosOrdenes#"
                                        returnvariable="Local.Ordenes">


                        <cfloop query="local.Ordenes">
                            <cfif local.Rechazada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                                <cfset local.ConRechazadas += 1>
                            </cfif>
                        </cfloop>

                        <cfif local.ConRechazadas GTE 1>
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="EditarOrdenCompraGeneral"
                                        argumentcollection="#local.DatosOrdenes#">
                        </cfif>

                        <cfset correo = structNew()>
                        <cfset correo.destinatarios = arrayNew(1)>
                        <!--- Enviar correo de notificacion al comprador --->
                        <!--- <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                method="leer_CorreoComprador"
                                id_Empresa="#session.ID_EMPRESA#"
                                id_OrdenDeCompra="#Arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                returnvariable="rs.Empleados"> --->

                        <!--- NOS VAMOS POR EL REQUISITANTE CUANDO EL TIPO DE REQUISICION ES DE SERVICIOS --->
                        <!--- con el metodo "getInfoResponsables" obtenemos el correo de requisitante, independientemente de si es servicio o no --->
                        <!--- <cfif Arguments.mRechazo  EQ 1 >
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="getRequisitanteTipoServicios"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_ordencompra ="#Arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                        returnvariable="local.requisitante">

                            <cfloop query="local.requisitante">
                                <cfset arrayAppend(correo.destinatarios, local.requisitante.DE_EMAIL)>
                            </cfloop>
                        </cfif> --->

                        <!--- Buscamos el Correo de los involucrados en la OC --->
                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                method="getInfoResponsables"
                                id_Empresa="#session.ID_EMPRESA#"
                                id_OrdenDeCompra="#Arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                returnvariable="rs.Empleados">

                        <cfset infoCorreo = structNew()>
                        <cfloop query="rs.Empleados">
                            <cfif rs.Empleados.de_Email NEQ '' && NOT arrayFind(correo.destinatarios, rs.Empleados.de_Email)>
                                <cfset arrayAppend(correo.destinatarios, rs.Empleados.de_Email)>
                            </cfif>

                            <cfif rs.Empleados.nd_Row EQ 1>
                                <cfset infoCorreo.Requisitante = rs.Empleados>
                            </cfif>
                            <cfif rs.Empleados.nd_Row EQ 2 AND NOT infoCorreo.keyExists('Requisitante')>
                                <cfset infoCorreo.Requisitante = rs.Empleados>
                            </cfif>
                        </cfloop>

                        <!--- FIN ADD REQUISITANTE --->
                        <!--- Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018 --->
                        <!--- Se volvio a activar el envio de notificaciones, pero ahora para los involucrados (requisictante, almacenista y comprador) 24/04/2024 --->
                        <cfset correo.parametros = structNew()>
                        <cfset correo.parametros.asunto = 'Rechazo de orden de compra.'>
                        <cfset correo.parametros.de_Mensaje = 'Estimado/a "' & infoCorreo.Requisitante.nb_NombreEmpleado & '"<br><br>
                            Te informamos que tu  requisición "' & Arguments.OrdenesCompras[local.i].ID_REQUISICION & '" ha sido rechazada,
                             en la orden de compra "' & Arguments.OrdenesCompras[local.i].id_OrdenDeCompra & '".<br>
                            Si tienes alguna duda o crees que este rechazo es equivocado, por favor comunícate con el departamento de compras.'>
                        <cfset correo.parametros.nb_Movimiento = 'Rechaz&oacute;'>
                        <cfset correo.parametros.nb_Empleado = UCase(session.NB_EMPLEADOCOMPLETO)>
                        <cfset correo.parametros.de_Fecha = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >
                        <cfset correo.parametros.de_Observaciones = arguments.de_Observaciones>

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
                        <cfif arrayLen(correo.destinatarios) GT 0>
                            <!--- <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                      method="sendMail"
                                      argumentcollection="#correo#"
                                      returnvariable="Local.rbr"/> --->

                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                      method="sendMail"
                                      destinatarios="#correo.destinatarios#"
                                      asunto="Notificacion de Rechazo de OC"
                                      imagenes="#correo.imagenes#"
                                      parametros="#correo.parametros#"
                                      estatus="1"
                                      id_UsuarioAutoriza="#arguments.id_Usuario#"
                                      sn_plantilla="YES"
                                      dir_plantilla="templates/correos/Compras/templateMailCancelarOC.html"
                                      returnvariable="Local.RBR"/>

                            <cfif Local.rbr.hasError()>
                                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                            <cfelse>
                                <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al comprador. Operaci&oacute;n exitosa. ")>
                            </cfif>
                        <cfelse>
                            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                        </cfif>

                        <!---/**
                        * Se realiza la actualizacion de estatus de la requisicionCMF
                        * (si es que es una, lo verifica dentro del SP)
                        */--->
                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                                  method="ActualizarEstatusCMF"
                                  id_Empresa = "#arguments.id_Empresa#"
                                  id_OrdenCompra = "#Arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                  id_estatus = "#arguments.Estatus#">


                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                    </cfif>
                </cfloop>
            <cfelse>

                <cfif arguments.Estatus EQ 1>

                    <cfset local.DatosOrdenes = structNew()>
                    <cfset local.ConTotal = 0>
                    <cfset local.ConAutorizadas = 0>
                    <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                    <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                    <cfset local.DatosOrdenes.id_sucursal = SESSION.ID_SUCURSAL>
                    <cfset local.DatosOrdenes.id_Almacen = arguments.id_almacen>

                    <cfset Local.DatosOrdenes.id_requisicion = arguments.OrdenesCompras[local.i].ID_REQUISICION>
                    <cfset Local.DatosOrdenes.nb_sucursal = arguments.OrdenesCompras[local.i].NB_SUCURSAL>
                    <cfset Local.DatosOrdenes.nb_proveedor = arguments.OrdenesCompras[local.i].NB_PROVEEDOR>
                    <cfset local.DatosOrdenes.fh_EntregaProbable = arguments.OrdenesCompras[local.i].FH_ENTREGAPROBABLE>

                    <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                    <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                    <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="Editar"
                                argumentcollection="#local.DatosOrdenes#">

                    <!--- BUSCAR MAS AUTORIZADOR --->
                    <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionOrdenesCompra')#"
                    method="getConfiguracionPorEmpresa"
                    id_empresa="#local.DatosOrdenes.id_Empresa#"
                    id_Sucursal="#local.DatosOrdenes.id_Sucursal#"
                    im_Autorizado ="#local.DatosOrdenes.im_total#"
                    id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                    returnvariable="Local.usuariosAutorizan">

                    <cfif Local.usuariosAutorizan GT 0>
                        <cfset local.sn_EnvioCorreo = Local.usuariosAutorizan.sn_EnvioCorreo>
                        <cfset Local.usuarioAut=structNew()>
                        <cfset Local.usuarioAut_Insert=structNew()>
                        <cfset Local.destinatarios=arrayNew()>

                        <cfloop query="Local.usuariosAutorizan">
                            <cfif local.DatosOrdenes.im_total GTE Local.usuariosAutorizan.nu_rangoInicioImporte
                            AND local.DatosOrdenes.im_total LTE Local.usuariosAutorizan.nu_rangoFinalImporte>
                                <cfset structClear(Local.usuarioAut)>

                                <cfset Local.usuarioAut.id_Empresa                          = local.DatosOrdenes.id_Empresa>
                                <cfset Local.usuarioAut.id_Sucursal                         = local.DatosOrdenes.id_Sucursal>
                                <cfset Local.usuarioAut.id_OrdenDeCompra                    = local.DatosOrdenes.id_OrdenCompra>
                                <cfset Local.usuarioAut.id_UsuarioAutoriza                  = Local.usuariosAutorizan.id_usuario>
                                <cfset Local.usuarioAut.id_EstatusAutorizacionOrdenDeCompra = 1>
                                <cfset Local.usuarioAut.fh_AsignacionEstatus                = dateFormat(now(),'yyyymmdd')>

                                <cfif Local.usuariosAutorizan.de_email NEQ '' && not arrayFind(Local.usuarioAut_Insert,Local.usuariosAutorizan.de_email)>
                                    <cfif Local.usuariosAutorizan.sn_EnvioCorreo>
                                        <cfset arrayAppend(Local.destinatarios,Local.usuariosAutorizan.de_email)>
                                    </cfif>

                                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraUsuariosAutorizan')#"
                                    method="AgregarOrdenCompraAutoriza"
                                    argumentcollection="#Local.usuarioAut#">

                                    <cfset arrayAppend(Local.usuarioAut_Insert,Local.usuariosAutorizan.de_email)>
                                </cfif>
                            </cfif>
                        </cfloop>

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

                            <cfset Local.ordenCompra.id_Sucursal = local.Master.ID_SUCURSAL>
                            <cfset Local.ordenCompra.id_Almacen = local.Master.ID_ALMACENENTREGA>

                            <cfset Local.DatosOrdenes.nb_Moneda = local.Master.NB_MONEDA>

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

                            <cfset theURLBase = "http://">
                            <cfif CGI.HTTPS EQ "on">
                                <cfset theURLBase = 'https://' />
                            </cfif>
                            <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

                            <cfset Local.parametros = {
                                id_Empresa     = session.ID_EMPRESA,
                                id_Sucursal    = Local.DatosOrdenes.id_Sucursal,
                                id_Almacen     = Local.DatosOrdenes.id_Almacen,
                                nu_ordenCompra = Local.DatosOrdenes.id_OrdenDeCompra,
                                nb_sucursal    = Local.DatosOrdenes.nb_sucursal,
                                nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                                nb_proveedor   = Local.DatosOrdenes.nb_proveedor,
                                fh_programada  = Local.DatosOrdenes.fh_EntregaProbable,
                                nu_requisicion = Local.DatosOrdenes.id_requisicion,
                                im_total       = Local.DatosOrdenes.im_Total,
                                nb_Moneda      = local.DatosOrdenes.nb_Moneda,
                                webPath        = Local.webPath,
                                nb_Asunto      = 'Solicitud de autorización de orden de compra',
                                sn_Preautorizacion = 0
                            }/>

                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#Local.destinatarios#"
                                asunto="Solicitud de autorización de orden de compra"
                                imagenes="#Local.imagenes#"
                                parametros="#Local.parametros#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                                returnvariable="Local.rbr"/>


                        </cfif>
                        <!--- </cfif> --->
                    <cfelse>
                        <!--- <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="listarOrdenesAsignadasaUsuarios"
                                    argumentcollection="#local.DatosOrdenes#"
                                    returnvariable="Local.Ordenes">

                        <cfloop query="local.Ordenes">
                            <cfset local.ConTotal += 1>
                            <cfif local.Autorizada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                                <cfset local.ConAutorizadas += 1>
                            </cfif>
                        </cfloop> --->

                        <!--- <cfif local.ConTotal EQ local.ConAutorizadas> --->
                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="EditarOrdenCompraGeneral"
                                    argumentcollection="#local.DatosOrdenes#">
                        <!--- </cfif> --->

                        <!--- JULIO CESAR ACOSTA LOPEZ
                            19/05/2015
                            HORA:13:40
                            EMPIEZA LA CREACION DEL CORREO PARA NOTIFICAR QUE SE HA AUTORIZADO UNA ORDEN DE COMPRA AL PORVEEDOR Y QUE DEBE SU COTIZACION
                            FUE ELEGIDA PARA SER SURTIDA DICHOS INSUMOS--->
                        <!--- julio cesar acosta lopez 19/05/2015 funcion que trae el email del contacto del proveedor
                                al cual se le notificara de la autorizacion de la compra --->
                        <cfinvoke   component="#Application.RF.getPath('dao','ProveedoresContactos')#"
                                    method="EmailContacto"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_OrdenCompra = "#arguments.id_OrdenCompra#"
                                    returnvariable="local.Email">

                        <!--- julio cesar acosta lopez 19/05/2015 funcion para traer los insumos que se mandaran en el archivo adjunto
                            al correo para ser mas especifico de que insumos se compraran --->
                        <!--- <cfif isDefined("arguments.id_CotizacionReporte") AND arguments.id_CotizacionReporte NEQ ''>
                            <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                        method="listarInsumosparaAutorizarOrdenCompra"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_Cotizacion= "#arguments.id_CotizacionReporte#"
                                        sn_Genero = "1"
                                        returnvariable="local.Insumos">
                        </cfif>  --->

                        <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                    method="listarInsumosparaAutorizarOrdenCompra"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_Cotizacion= "#arguments.id_CotizacionReporte#"
                                    <!--- se agrego el parametro de id_ordencompra 23/10/2015 --->
                                    id_ordencompra = "#arguments.id_ordencompra#"
                                    sn_Genero = "1"
                                    returnvariable="local.Insumos">

                        <!--- estructura para almacenar la informacion que se pondra en el psdf y correo asi como el arreglo de destinatarios --->
                        <cfset local.DatosCompra = structNew()>
                        <cfset local.destinatarios = arrayNew(1)>

                        <cfset arrayAppend(Local.destinatarios,local.Email.DE_EMAIL)>

                        <!--- NOS VAMOS POR EL REQUISITANTE CUANDO EL TIPO DE REQUISICION ES DE SERVICIOS --->
                        <!---
                            Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="getRequisitanteTipoServicios"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_ordencompra ="#arguments.OrdenesCompras[local.i].id_ordendecompra#"
                                    returnvariable="local.requisitante">

                        <cfloop query="#local.requisitante#">
                            <cfset arrayAppend(Local.destinatarios, local.requisitante.DE_EMAIL)>
                        </cfloop>
                        --->
                        <!--- FIN ADD REQUISITANTE --->

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="listarInformacionOrdenCompra"
                                id_Empresa="#arguments.id_Empresa#"
                        id_Sucursal="#arguments.id_Sucursal#"
                                id_OrdenCompra ="#arguments.id_OrdenCompra#"
                                <!--- se agrego el parametro del usuario autorizador --->
                                id_usuario = "#session.ID_USUARIO#"
                                id_Cotizacion = "#arguments.id_CotizacionReporte#"
                                returnvariable="local.InfoCompra">

                        <!---
                            Si es una OC generada en automatico por flujo de Edenred se genera en automatico:
                                - Recepción de servicios
                                - Subir factura portal
                                - Recepción de factura
                        --->

                        <!--- <cfcontent type="text/html">
                        <cfdump var="#local.InfoCompra.sn_ProcesoEdenred#" label="" format = "html"  abort="false">
                        <cfdump var="#Local.DatosOrdenes.id_requisicion#" label="" format = "html"  abort="true"> --->


                        <cfif local.InfoCompra.sn_ProcesoEdenred EQ 1>

                            <!---
                                Se retornan los datos necesarios para la validacion de consumo de presupuestos
                            --->
                            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="AutorizarOCEdenred"
                                id_Empresa               = "#Arguments.id_Empresa#"
                                id_SolicitudPago         = "#local.InfoCompra.id_SolicitudPago#"
                                id_OrdenCompra           = "#Arguments.id_OrdenCompra#"
                                id_EstatusAutorizacionOC = "#Arguments.Estatus#"
                            returnvariable="local.dataPresupuestos">

                            <!---
                                Revisamos el presupuesto disponible para los insumos de
                                    - Servicios de fondos para cuenta de ticket empresarial
                                    - Comisión por Servicios de Ticket Empresarial

                                En caso de que no cuente con disponible en alguna de las cuentas
                                Se retorna un error con el cuerpo del correo electronico
                            --->

                            <!--- Recuperamos la bandera de presupuesto por la sucursal --->
                            <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                                    method         = "getBanderaPresupuestoSucursal"
                                    id_Empresa     = "#session.id_Empresa#"
                                    id_Sucursal    = "#session.id_Sucursal#"
                                    returnvariable = "local.sucursal_bandera">

                            <!--- Si se encuentra activado el consumo de presupuestos se hacen las validaciones --->
                            <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
                                <cfset local.jsonres = "">
                                <cfloop query="local.dataPresupuestos">
                                    <!--- Si no hay presupuesto disponible concatenamos el detalle del error --->
                                    <cfif isDefined("local.dataPresupuestos.sn_Error") AND local.dataPresupuestos.sn_Error EQ 1>
                                        <cfset local.jsonres = local.jsonres & '{
                                            "nb_GrupoGasto": "#local.dataPresupuestos.nb_GrupoGasto#",
                                            "im_PresupuestoFaltante": "#local.dataPresupuestos.im_PresupuestoFaltante#",
                                            "nb_CuentaConcepto": "#local.dataPresupuestos.de_CuentaConcepto#",
                                            "nb_Solicitante": "#local.dataPresupuestos.nb_Solicitante#",
                                            "de_Email": "#local.dataPresupuestos.de_Email#",
                                            "nb_Empresa": "#local.dataPresupuestos.nb_Empresa#",
                                            "nb_Jefe": "#local.dataPresupuestos.nb_Jefe#",
                                            "de_Email_Jefe": "#local.dataPresupuestos.de_Email_Jefe#",
                                            "id_SolicitudPago": "#local.InfoCompra.id_SolicitudPago#"
                                        },'>
                                    </cfif>
                                </cfloop>

                                <!--- Si jsonres no está vacío retornamos error --->
                                <cfif len(local.jsonres) GT 0>
                                    <cfset local.jsonres = "sn_PresupuestoFaltante<>[" & left(local.jsonres, len(local.jsonres)-1) & "]">
                                    <cfset variables.RBR.setError(local.jsonres)>
                                    <cfreturn variables.RBR>
                                </cfif>
                            </cfif>

                        </cfif>

                        <!---/**
                        * Si la OC fue generada por el proceso de carga masiva de facturas
                        * realiza en automatico la recepcion de servicios
                        */--->
                        <cfif local.InfoCompra.sn_ProcesoCMF EQ 1>
                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="RecepcionServiciosCMF"
                                    id_Empresa = "#arguments.id_Empresa#"
                                    id_OrdenCompra = "#Arguments.id_OrdenCompra#">
                        </cfif>

                        <cfset local.cont = 0>

                        <cfloop query="local.InfoCompra">
                            <cfif local.cont eq 0>
                                <!--- <cfset local.DatosCompra.id_Cotizacion = local.InfoCompra.id_Cotizacion> --->
                                <cfset local.DatosCompra.id_OrdenDeCompra = local.InfoCompra.id_OrdenDeCompra>
                                <cfset local.DatosCompra.nb_Empleado = local.InfoCompra.nb_Empleado>
                                <cfset local.DatosCompra.fh_Entrega = local.InfoCompra.fh_Entrega>
                                <cfset local.DatosCompra.nb_Almacen = nb_Almacen.nb_Almacen>
                                <cfset local.DatosCompra.de_ComentarioEleccion = local.InfoCompra.de_Comentarios>
                                <cfset local.DatosCompra.im_subtotal = local.InfoCompra.im_subtotal>
                                <cfset local.DatosCompra.im_Total = local.InfoCompra.im_Total>
                                <cfset local.DatosCompra.im_Descuento = local.InfoCompra.im_Descuento>
                                <cfset local.DatosCompra.nb_empleadoautorizo = session.NB_EMPLEADOCOMPLETO>

                                <cfset local.DatosCompra.importes = local.InfoCompra>
                                <cfset local.DatosCompra.totalletra = local.InfoCompra.im_totalletra>
                                <cfset local.cont += 1>

                            <cfelse>
                                <cfset local.cont = 0>
                                <cfbreak>
                            </cfif>
                        </cfloop>

                        <cfset local.nb_Archivo = 'Ordendecompra_' & Replace(local.InfoCompra.nb_Empresa,' ', '_', 'all') & 'No' & local.InfoCompra.id_OrdenDeCompra >
                        <cfset crearReporte(local.DatosCompra,local.Insumos, local.nb_Archivo)>

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
                                isLocal="true"
                            }
                        ]>

                        <cfif local.InfoCompra.sn_CorreoProveedor EQ 0>
                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#Local.destinatarios#"
                                asunto="Orden de Compra"
                                imagenes="#Local.imagenes#"
                                archivos="#Local.archivos#"
                                parametros="#Local.DatosCompra#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailSurtirInsumos.html"
                                returnvariable="Local.rbr"/>

                            <cfif Local.rbr.hasError()>
                                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                            </cfif>
                        </cfif>


                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                    </cfif>
                <cfelseif arguments.Estatus EQ 0>
                    <!--- OC Rechazada --->
                    <cfset local.DatosOrdenes = structNew()>
                    <cfset local.ConRechazadas = 0>
                    <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                    <cfset local.DatosOrdenes.id_sucursal = SESSION.ID_SUCURSAL>
                    <cfset local.DatosOrdenes.id_Almacen = arguments.id_almacen>
                    <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                    <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                    <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                    <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="Editar"
                                argumentcollection="#local.DatosOrdenes#">

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="listarOrdenesAsignadasaUsuarios"
                                    argumentcollection="#local.DatosOrdenes#"
                                    returnvariable="Local.Ordenes">

                    <cfloop query="local.Ordenes">
                        <cfif arguments.Rechazada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                            <cfset local.ConRechazadas += 1>
                        </cfif>
                    </cfloop>

                    <cfif local.ConRechazadas GT 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="EditarOrdenCompraGeneral"
                                    argumentcollection="#local.DatosOrdenes#">
                    </cfif>

                    <!--- Enviar correo de notificacion al comprador --->
                    <!--- Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018 --->
                    <!--- Se volvio a activar el envio de notificaciones, pero ahora para los involucrados (requisictante, almacenista y comprador) 24/04/2024 --->
                    <cfset correo = structNew()>
                    <cfset correo.destinatarios = arrayNew(1)>

                    <!--- Buscamos el Correo de los involucrados en la OC --->
                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                            method="getInfoResponsables"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_OrdenDeCompra="#Arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                            returnvariable="rs.Empleados">

                    <cfset infoCorreo = structNew()>
                    <cfloop query="rs.Empleados">
                        <cfif rs.Empleados.de_Email NEQ '' && NOT arrayFind(correo.destinatarios, rs.Empleados.de_Email)>
                            <cfset arrayAppend(correo.destinatarios, rs.Empleados.de_Email)>
                        </cfif>

                        <cfif rs.Empleados.nd_Row EQ 1>
                            <cfset infoCorreo.Requisitante = rs.Empleados>
                        </cfif>
                        <cfif rs.Empleados.nd_Row EQ 2 AND NOT infoCorreo.keyExists('Requisitante')>
                            <cfset infoCorreo.Requisitante = rs.Empleados>
                        </cfif>
                    </cfloop>

                    <cfset correo.parametros = structNew()>
                    <cfset correo.parametros.asunto = 'Rechazo de orden de compra.'>
                    <cfset correo.parametros.de_Mensaje = 'Estimado/a "' & infoCorreo.Requisitante.nb_NombreEmpleado & '"<br><br>
                        Te informamos que tu  requisición "' & Arguments.OrdenesCompras[local.i].ID_REQUISICION & '" ha sido rechazada,
                         en la orden de compra "' & Arguments.OrdenesCompras[local.i].id_OrdenDeCompra & '".<br>
                        Si tienes alguna duda o crees que este rechazo es equivocado, por favor comunícate con el departamento de compras.'>
                    <cfset correo.parametros.nb_Movimiento = 'Rechaz&oacute;'>
                    <cfset correo.parametros.nb_Empleado = UCase(session.NB_EMPLEADOCOMPLETO)>
                    <cfset correo.parametros.de_Fecha = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >
                    <cfset correo.parametros.de_Observaciones = arguments.de_Observaciones >

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
                    <cfif arrayLen(correo.destinatarios) GT 0>

                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#correo.destinatarios#"
                                asunto="Notificacion de Rechazo de OC"
                                imagenes="#correo.imagenes#"
                                parametros="#correo.parametros#"
                                estatus="1"
                                id_UsuarioAutoriza="#arguments.id_Usuario#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailCancelarOC.html"
                                returnvariable="Local.RBR"/>

                        <cfif Local.rbr.hasError()>
                            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                        <cfelse>
                            <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al comprador. Operaci&oacute;n exitosa. ")>
                        </cfif>
                    <cfelse>
                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                    </cfif>

                    <!---/**
                    * Se realiza la actualizacion de estatus de la requisicionCMF
                    * (si es que es una, lo verifica dentro del SP)
                    */--->
                    <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                              method="ActualizarEstatusCMF"
                              id_Empresa = "#arguments.id_Empresa#"
                              id_OrdenCompra = "#arguments.id_OrdenCompra#"
                              id_estatus = "#arguments.Estatus#">

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                </cfif>
            </cfif>
        </cfif>

        <!--- Gruarda un registro a la tabla OrdenesDeCompraMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method = "agregarOrdenesDeCompraMovimientos"
                    id_empresa         = "#session.ID_EMPRESA#"
                    id_ordenDeCompra   = "#arguments.id_OrdenCompra#"
                    id_EmpresaEmpleado = "#session.ID_EMPRESAOPERADORA#"
                    id_Empleado        = "#SESSION.ID_EMPLEADO#">



        <cfloop array="#arguments.OrdenesServicio#" index="local.i">
                <cfif #local.i.ID_TIPOREQUISICION# EQ 1 AND #local.i.ID_TIPODIVISION# EQ 14>
                     <cfinvoke   component="#Application.RF.getPath('dao','OrdenesServicio')#"
                                 id_Empresa          ="#local.i.ID_EMPRESA#"
                                 id_Requisicion      ="#local.i.ID_REQUISICION#"
                                 id_UsuarioInicia    ="#local.i.ID_USUARIOSOLICITA#"
                                 sn_mov = 1
                                 sn_Finaliza = 0
                                 method  ="RequerimientoOrdenesServicioMov">
                </cfif>
        </cfloop>

        <!--- <cfset variables.RBR.setError("Operaci&oacute;n exitosa.")> --->
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EditarOC_SF" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false"/>
        <cfargument name="id_Sucursal"          type="numeric" required="false"/>
        <cfargument name="id_OrdenCompra"       type="numeric" required="true"/>
        <cfargument name="Estatus"              type="string"  required="true"/>
        <cfargument name="de_Observaciones"     type="string"  required="false"/>
        <cfargument name="OrdenesCompras"       type="array"   required="true"/>
        <cfargument name="OrdenesServicio"      type="array"   required="false"/>
        <cfargument name="id_CotizacionReporte" type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>
        <cfargument name="mRechazo"             type="string"  required="false" default=""/>
        <cfargument name="sn_CorreoProveedor"   type="string"  required="false" default="false"/>
        <cfargument name="SolicitudesFac"       type="array"   required="false"/>

        <!--- Si hay Ordenes de Compra, las mandamos a actualizar --->
        <cfif arrayLen(arguments.OrdenesCompras) GT 0>
            <!--- Es la funcion que se encarga de realizar todo los procesos de la OC --->
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                method="Editar"
                id_Empresa="#arguments.id_Empresa#"
                id_Sucursal="#arguments.id_Sucursal#"
                id_OrdenCompra="#arguments.id_OrdenCompra#"
                Estatus="#arguments.Estatus#"
                de_Observaciones="#arguments.de_Observaciones#"
                OrdenesCompras="#arguments.OrdenesCompras#"
                OrdenesServicio="#arguments.OrdenesServicio#"
                id_CotizacionReporte="#arguments.id_CotizacionReporte#"
                id_Almacen="#arguments.id_Almacen#"
                mRechazo="#arguments.mRechazo#"
                sn_CorreoProveedor="#arguments.sn_CorreoProveedor#"
                returnvariable="Local.OrdenCompra">

            <!--- En caso de que se encuentre una excepción setteamos el mensaje --->
            <cfif Local.OrdenCompra.hasError()>
                <!--- Recuperamos el mensaje de error y cancelamos la operación --->
                <cfset variables.RBR.setError(Local.OrdenCompra.getMessage())>
                <cfreturn variables.RBR>
            </cfif>

        </cfif>



        <!--- Si hay solicitudes de facturacion --->
        <cfif arrayLen(arguments.SolicitudesFac) GT 0>
            <cfloop array="#arguments.SolicitudesFac#" index="SF">
                <cfinvoke component="#Application.RF.getPath('bro','SolicitudConsignacion')#"
                    method="AutorizarSolicitudFacturacion"
                    id_Empresa="#SF.ID_EMPRESA#"
                    id_Sucursal="#SF.ID_SUCURSALALMACENENTREGA#"
                    id_SolicitudFacturacion="#SF.ID_ORDENDECOMPRA#"
                    id_Proveedor="#SF.ID_PROVEEDOR#"
                    id_Estatus="#arguments.Estatus EQ 1 ? 3 : 4#"
                    de_ComentariosRechazo="#arguments.de_Observaciones#"
                    returnvariable="local.rs">
            </cfloop>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="DatosCompra"        type="struct" required="true">
        <cfargument name="Insumos"            type="query"  required="true">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="Ordendecompra">
            <cfinclude template="../../templates/reportes/Compras/reporteSurtirInsumos.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#Ordendecompra#"
                  pdf="Ordendecompra"
                  debug="no"
                  path="#expandPath('../Reportes/')#">

        <cfreturn Variables.RBR>
    </cffunction> --->

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="DatosCompra"        type="struct" required="true">
        <cfargument name="Insumos"            type="query"  required="true">
        <cfargument name="nb_Archivo"         type="string" required="false" default="">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Sucursal"        type="string" required="false"/>
        <cfargument name="sn_Politica" type="string" required="false" default="0">
        <!--- ********************************************************************* --->
        <!--- ******* Se ignoran los datos recibidos y se cambia el formato ******* --->
        <!--- ********************************************************************* --->

        <cfset arguments.id_ordenDeCompra = #DatosCompra.id_OrdendeCompra#>
        <cfif NOT isDefined("DatosCompra.id_Empresa") OR DatosCompra.id_Empresa EQ '' OR DatosCompra.id_Empresa EQ nullValue()>
            <cfif NOT isDefined("arguments.id_Empresa") OR arguments.id_Empresa EQ '' OR arguments.id_Empresa EQ nullValue()>
                <cfset arguments.id_Empresa = session.ID_EMPRESA>
            </cfif>
        <cfelse>
            <cfset arguments.id_Empresa = #DatosCompra.id_Empresa#>
        </cfif>

        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                method="getOCImprimir"
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
            nb_archivo="ordenDeCompra"
        }>

        <cfif Len(Trim(Arguments.nb_Archivo)) GT 0>
            <cfset Local.infoReport.nb_archivo = Arguments.nb_Archivo>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','EmpresasEvaluadoras')#"
                method="getSucursalEvaluacion"
                id_Empresa = "#arguments.id_Empresa#"
                id_Sucursal = "#SESSION.id_Sucursal#"
                returnvariable="local.rs"/>

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
      path="#expandPath('/root/#local.infoReport.de_directorio#/')#"
      returnvariable="hasException">

    <cfif isStruct(hasException) AND structKeyExists(hasException, 'message')>
      <cfset variables.RBR.setError(hasException.Message)>

      <cfreturn variables.RBR>
    <cfelse>
      <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
      <cfset variables.RBR.setData(Local.infoReport)>

      <cfreturn Variables.RBR>
    </cfif>
    </cffunction>

    <!--- Victor Sanchez
        19/10/2015
        lista las ordenes de compra de tipo servicio --->
    <cffunction name="listar_OrdenesCompraServicios" access="public" returntype="Any">
            <cfargument name="id_proveedor"         type="string" required="false"/>
            <cfargument name="fh_inicio"            type="string" required="false"/>
            <cfargument name="fh_fin"               type="string" required="false"/>
            <cfargument name="id_Usuario"           type="string" required="false"/>
            <cfargument name="nu_Siniestro"         type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                  method="listar_OrdenesCompraServicios"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_Sucursal="#SESSION.ID_SUCURSAL#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.OrdenCompra">

        <cfset variables.RBR.setQuery(Local.OrdenCompra)>

        <cfreturn variables.RBR>
    </cffunction>

<cffunction name="agregarGastoMovimiento" access="public" returntype="Any">
    <cfargument name="fh_Movimiento"                  type="string"  required="true"/>
    <cfargument name="fl_FacturaRemision"              type="string"  required="false"/>
    <cfargument name="fh_FacturaRemision"              type="string"  required="true"/>
    <cfargument name="im_TotalMN"                      type="string"  required="true"/>
    <cfargument name="de_Entrego"                      type="string"  required="no"/>
    <cfargument name="id_OrdenCompra"                  type="string"  required="true"/>
    <cfargument name="de_Comentarios"                  type="string"  required="no"/>
    <cfargument name="id_UsuarioRegistroMovimiento"    type="string"  required="true"/>
    <cfargument name="fh_Registro"                     type="string"  required="true"/>
    <cfargument name="insumos"                         type="array"   required="true"/>
    <cfargument name="id_TipoDivision"                 type="string"  required="false"/>
    <cfargument name="id_EmpresaRequisicion"           type="string"  required="false"/>
    <cfargument name="id_UsuarioSolicita"              type="string"  required="false"/>
    <cfargument name="id_Requisicion"                  type="string"  required="false"/>
    <cfargument name="id_TipoRequisicion"              type="string"  required="false"/>
    <cfargument name="de_emailProveedor"                type="string" required="false"/>

    <cfset arguments.id_TipoMovimiento = 12>
    <cfset arguments.id_Poliza = ''>
    <cfset arguments.id_UsuarioRegistroMovimiento = session.ID_USUARIO>
    <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
    <cfset arguments.id_SucursalMovimiento = SESSION.ID_SUCURSAL>
    <cfset ff_Presupuestos = Application.RENV.getProperty('FF_PRESUPUESTOS')>

    <!--- Traer el tipo de cambio de la moneda del día anterior --->
    <cfinvoke component="#Application.RF.getPath('dao','Monedas')#"
              method="MonedaDiaAnteriorPorOC"
              id_Empresa="#session.ID_EMPRESA#"
              id_OrdenCompra="#arguments.id_OrdenCompra#"
              returnvariable="local.TipoCambio">

    <cfset im_Total = 0>
    <cfloop array="#arguments.insumos#" index="local.i">
        <cfset im_PrecioTotalEntrada   = local.i.NU_CANTIDADRECIBIDA * local.i.IM_PRECIOUNITARIODESCUENTO>
        <cfset im_PrecioTotalEntradaMN = local.i.NU_CANTIDADRECIBIDA * (local.i.IM_PRECIOUNITARIODESCUENTO * local.TipoCambio.IM_TIPOCAMBIO)>
        <cfset im_Total = im_Total + im_PrecioTotalEntradaMN>
    </cfloop>

    <cfset arguments.im_TotalMN = im_Total>

    <!--- Setear campos basura --->
    <cfloop from="1" to="#ArrayLen(arguments.insumos)#" index="i">
        <cfset arguments.insumos[i].centroscostos      = "">
        <cfset arguments.insumos[i].gruposcentroscostos = "">
    </cfloop>

    <!--- Se agrega en la tabla de Gastos Movimientos --->
    <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
              method="agregarGastoMovimiento"
              id_Empresa="#session.ID_EMPRESA#"
              argumentcollection="#arguments#"
              returnvariable="nextID">

    <!--- Se obtiene el impuesto que se le aplicará al movimiento --->
    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeComprasImpuestos')#"
              method="ObtenerImpuestos"
              id_Empresa="#session.ID_EMPRESA#"
              id_OrdenCompra="#arguments.id_OrdenCompra#"
              returnvariable="impuestos">

    <cfset descuentos = arrayNew(1)>
    <cfset vari = 0>

    <cfloop query="impuestos">
        <cfif vari EQ 0>
            <cfset porcentajeAplicar = impuestos.PJ_APLICAR>
            <cfset im_Aplicacion = (arguments.im_TotalMN * porcentajeAplicar) / 100>
            <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                      method="GuardarImpuestos"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Sucursal="#SESSION.ID_SUCURSAL#"
                      id_Movimiento="#nextID#"
                      id_Impuesto="#impuestos.ID_IMPUESTO#"
                      pj_Aplicar="#impuestos.PJ_APLICAR#"
                      im_AplicacionImpuesto="#im_Aplicacion#">
        </cfif>
        <cfif vari EQ 1>
            <cfset retencion = (im_Aplicacion * impuestos.PJ_APLICAR) / 100>
            <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                      method="GuardarImpuestos"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Sucursal="#SESSION.ID_SUCURSAL#"
                      id_Movimiento="#nextID#"
                      id_Impuesto="#impuestos.ID_IMPUESTO#"
                      pj_Aplicar="#impuestos.PJ_APLICAR#"
                      im_AplicacionImpuesto="#retencion#">
        </cfif>
        <cfif vari EQ 2>
            <cfset retencion = (im_Aplicacion * impuestos.PJ_APLICAR) / 100>
            <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                      method="GuardarImpuestos"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Sucursal="#SESSION.ID_SUCURSAL#"
                      id_Movimiento="#nextID#"
                      id_Impuesto="#impuestos.ID_IMPUESTO#"
                      pj_Aplicar="#impuestos.PJ_APLICAR#"
                      im_AplicacionImpuesto="#retencion#">
        </cfif>
        <cfset vari = vari + 1>
    </cfloop>

    <!--- Recuperamos la bandera de presupuesto por la sucursal --->
    <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
              method="getBanderaPresupuestoSucursal"
              id_Empresa="#arguments.id_EmpresaRequisicion#"
              id_Sucursal="#arguments.id_Sucursal#"
              returnvariable="local.sucursal_bandera">

    <cfset sn_ValidarPresupuesto = 0>
    <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
        <cfset sn_ValidarPresupuesto = 1>
    </cfif>

    <!--- Validación de presupuestos general --->
    <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
        <cfset local.JSON_Insumos = "[">
        <cfloop array="#arguments.insumos#" index="local.insumo_json">
            <cfset local.JSON_Insumos = local.JSON_Insumos & '{
                "id_Insumo": "#local.insumo_json.id_Insumo#",
                "id_CuentaPresupuesto": "#local.insumo_json.id_CuentaPresupuesto#",
                "im_TotalInsumo": "#local.insumo_json.im_TotalInsumo#"
            },'>
        </cfloop>
        <cfset local.JSON_Insumos = left(local.JSON_Insumos, len(local.JSON_Insumos)-1) & "]">

        <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                  method="getPresupuestoDisponible"
                  id_Empresa="#arguments.id_EmpresaRequisicion#"
                  id_CargaPresupuesto="#arguments.insumos[1].ID_CARGAPRESUPUESTO#"
                  id_Requisicion="#arguments.id_Requisicion#"
                  json_Insumos="#local.JSON_Insumos#"
                  returnVariable="local.ResInsumo">

        <cfset local.jsonres = "">
        <cfloop query="local.ResInsumo">
            <cfif isDefined("local.ResInsumo.sn_Error") AND local.ResInsumo.sn_Error EQ 1>
                <cfset local.jsonres = local.jsonres & '{
                    "nb_GrupoGasto": "#local.ResInsumo.nb_GrupoGasto#",
                    "im_PresupuestoFaltante": "#local.ResInsumo.im_PresupuestoFaltante#",
                    "nb_CuentaConcepto": "#local.ResInsumo.de_CuentaConcepto#",
                    "nb_Solicitante": "#local.ResInsumo.nb_Solicitante#",
                    "de_Email": "#local.ResInsumo.de_Email#",
                    "nb_Empresa": "#local.ResInsumo.nb_Empresa#",
                    "id_Requisicion": "#arguments.id_Requisicion#",
                    "nb_Jefe": "#local.ResInsumo.nb_Jefe#",
                    "de_Email_Jefe": "#local.ResInsumo.de_Email_Jefe#",
                    "sn_Autorizacion": 1
                },'>
            </cfif>
        </cfloop>

        <cfif len(local.jsonres) GT 0>
            <cfset local.jsonres = "sn_PresupuestoFaltante<>[" & left(local.jsonres, len(local.jsonres)-1) & "]">
            <cfset variables.RBR.setError(local.jsonres)>
            <cfreturn variables.RBR>
        </cfif>
    </cfif>

    <!--- Agregar en la tabla GastosMovimientosDetalle --->
    <cfloop array="#arguments.insumos#" index="local.i">

        <cfset im_PrecioTotalEntrada   = local.i.NU_CANTIDADRECIBIDA * local.i.IM_PRECIOUNITARIODESCUENTO>
        <cfset im_PrecioTotalEntradaMN = local.i.NU_CANTIDADRECIBIDA * (local.i.IM_PRECIOUNITARIODESCUENTO * local.TipoCambio.im_TipoCambio)>

        <cfset local.i.im_TipoCambio     = local.TipoCambio.im_TipoCambio>
        <cfset local.i.IM_PRECIOUNITARIO = local.i.IM_PRECIOUNITARIODESCUENTO>

        <cfinvoke component="#Application.RF.getPath('dao','ConceptosGastosInsumos')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  nb_InsumoListado="#local.i.NB_NOMBREINSUMO#"
                  page=1
                  pageSize=2
                  returnvariable="local.conceptosGI">

        <cfset local.i.contador = 0>
        <cfloop query="local.conceptosGI">
            <cfif local.conceptosGI.ID_GRUPOGASTO EQ 20>
                <cfset local.i.contador = local.i.contador + 1>
            </cfif>
        </cfloop>

        <cfset local.i.ID_GRUPOGASTO    = local.conceptosGI.id_GrupoGasto>
        <cfset local.i.ID_CONCEPTOGASTO = local.conceptosGI.id_ConceptoGasto>

        <cfif local.i.contador GT 1>
            <cfset local.i.ID_GRUPOGASTO = 20>
            <cfloop query="local.conceptosGI">
                <cfif local.conceptosGI.ID_GRUPOGASTO EQ 20>
                    <cfset local.i.ID_CONCEPTOGASTO = local.conceptosGI.id_ConceptoGasto>
                    <cfbreak>
                </cfif>
            </cfloop>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                  method="Editar"
                  id_empresa="#session.ID_EMPRESA#"
                  id_Requisicion="#arguments.ID_REQUISICION#"
                  id_Insumo="#local.i.ID_INSUMO#"
                  id_RequisicionDetalle="#local.i.ID_REQUISICIONDETALLE#"
                  nu_Cantidad="#local.i.NU_CANTIDAD#"
                  nu_CantidadaSurtir="#local.i.NU_CANTIDADRECIBIDA#"
                  id_GrupoCentroCosto="#local.i.ID_GRUPOCENTROCOSTO#"
                  id_CentroCosto="#local.i.ID_CENTROCOSTO#"
                  id_ConceptoGasto="#local.i.ID_CONCEPTOGASTO#"
                  id_GrupoGasto="#local.i.ID_GRUPOGASTO#">

        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                  method="getDetalleRequisicionByIdRD"
                  id_empresa="#session.ID_EMPRESA#"
                  id_Requisicion="#arguments.ID_REQUISICION#"
                  id_RequisicionDetalle="#local.i.ID_REQUISICIONDETALLE#"
                  returnvariable="local.detalleReq">

        <cfset estatusSurtidoRequisicionDetalle = 3>
        <cfif local.detalleReq.NU_CANTIDAD EQ local.detalleReq.NU_CANTIDADSURTIDA>
            <cfset estatusSurtidoRequisicionDetalle = 1>
        <cfelse>
            <cfset estatusSurtidoRequisicionDetalle = 2>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                  method="actualizarEstatusSurtidoRequisicionDetalles"
                  id_empresa="#session.ID_EMPRESA#"
                  id_Requisicion="#arguments.ID_REQUISICION#"
                  id_RequisicionDetalle="#local.i.ID_REQUISICIONDETALLE#"
                  id_estatusSurtido="#estatusSurtidoRequisicionDetalle#">

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                  method="agregarGastoMovimientoDetalle"
                  argumentcollection="#local.i#"
                  id_Movimiento="#nextID#"
                  id_Sucursal="#arguments.id_Sucursal#"
                  im_PrecioTotalEntrada="#im_PrecioTotalEntrada#"
                  im_TotalMN="#im_PrecioTotalEntradaMN#"
                  id_TipoCosteo="1"
                  id_TipoMovimiento="12"
                  ff_Presupuestos="#sn_ValidarPresupuesto#"
                  returnvariable="local.resDetalle">

        <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
            <cfif isDefined('local.resDetalle.sn_Error') AND local.resDetalle.sn_Error EQ 1>
                <cfset local.jsonres = 'sn_PresupuestoFaltante<>[{
                    "im_Disponible": "#local.resDetalle.im_PresupuestoDisponible#",
                    "nb_Solicitante": "#local.resDetalle.nb_Solicitante#",
                    "nb_Jefe": "#local.resDetalle.nb_Jefe#",
                    "de_Email_Solicitante": "#local.resDetalle.de_Email_Solicitante#",
                    "de_Email_Jefe": "#local.resDetalle.de_Email_Jefe#",
                    "fh_Requisicion": "#local.resDetalle.fh_RegistroFormato#",
                    "nb_EmpresaSucursal": "#local.resDetalle.nb_EmpresaSucursal#",
                    "fl_Requisicion": "#local.resDetalle.id_Requisicion#"
                }]'>
                <cfset variables.RBR.setError(local.jsonres)>
                <cfreturn variables.RBR>
            </cfif>
        </cfif>

    </cfloop>

    <!--- Obtener detalle de la OC desde BD --->
    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="getDetalle"
              id_empresa="#Arguments.ID_EMPRESA#"
              id_sucursal="#SESSION.ID_SUCURSAL#"
              id_almacen="#session.ID_ALMACEN#"
              id_ordenDeCompra="#arguments.id_OrdenCompra#"
              returnvariable="local.Detalle"/>

    <cfset insumosArray = queryToArray(local.Detalle)>

    <!--- Guardar copia del arreglo original con las cantidades recibidas ingresadas por el usuario --->
    <cfset originalInsumos = duplicate(arguments.insumos)>

    <!--- Reemplazar insumos con los datos de BD --->
    <cfset arguments.insumos = insumosArray>

    <!--- ============================================================
         NORMALIZAR CLAVES EN TODOS LOS INSUMOS DE BD
         Garantiza que NU_CANTIDADRECIBIDA, NU_CANTIDADSURTIDA y
         DE_ESTATUSSURTIDO existan antes de cualquier uso posterior
    ============================================================ --->
    <cfloop array="#arguments.insumos#" index="Local.insumo">
        <cfif NOT structKeyExists(Local.insumo, "NU_CANTIDADRECIBIDA")>
            <cfset Local.insumo.NU_CANTIDADRECIBIDA = 0>
        </cfif>
        <cfif NOT structKeyExists(Local.insumo, "NU_CANTIDADSURTIDA")>
            <cfset Local.insumo.NU_CANTIDADSURTIDA = 0>
        </cfif>
        <cfif NOT structKeyExists(Local.insumo, "DE_ESTATUSSURTIDO")>
            <cfif structKeyExists(Local.insumo, "de_estatusSurtido")>
                <cfset Local.insumo.DE_ESTATUSSURTIDO = Local.insumo.de_estatusSurtido>
            <cfelse>
                <cfset Local.insumo.DE_ESTATUSSURTIDO = "Sin Surtir">
            </cfif>
        </cfif>
    </cfloop>

    <!--- Loop principal sobre insumos de BD --->
    <cfloop array="#arguments.insumos#" index="Local.insumo">
        <cfif structKeyExists(Local.insumo, "ID_INSUMO")>

            <cfset totalCantidadRecibida = 0>
            <cfset cantidadOC = Local.insumo.NU_CANTIDAD>

            <!--- Buscar en originalInsumos y sumar NU_CANTIDADRECIBIDA --->
            <cfloop array="#originalInsumos#" index="origInsumo">
                <cfif structKeyExists(origInsumo, "ID_INSUMO")
                      AND origInsumo.ID_INSUMO EQ Local.insumo.ID_INSUMO
                      AND structKeyExists(origInsumo, "NU_CANTIDADRECIBIDA")>
                    <cfset totalCantidadRecibida = Val(totalCantidadRecibida) + Val(origInsumo.NU_CANTIDADRECIBIDA)>
                </cfif>
            </cfloop>

            <!--- Truncar decimales según referencia de BD --->
            <cfset var cantidadReferenciaStr = ToString(cantidadOC)>
            <cfset var posicionPunto = Find(".", cantidadReferenciaStr)>
            <cfset var decimalesReferencia = 0>
            <cfif posicionPunto GT 0>
                <cfset decimalesReferencia = Len(cantidadReferenciaStr) - posicionPunto>
            </cfif>

            <cfset var cantidadStr    = ToString(totalCantidadRecibida)>
            <cfset var regex          = "(\.\d{" & decimalesReferencia & "})">
            <cfset var truncadaInicial = REReplace(cantidadStr, regex & "\d*", "\1", "ALL")>

            <cfset var extraDecimales = Mid(cantidadStr, Len(truncadaInicial) + 1)>
            <cfset var cuatroIguales  = REFind("(\d)\1{3,}", extraDecimales)>
            <cfif cuatroIguales>
                <cfset totalCantidadRecibida = truncadaInicial>
            </cfif>

            <cfset totalCantidadRecibida = Val(totalCantidadRecibida)>
            <cfset cantidadOC = Val(cantidadOC)>

            <cfif totalCantidadRecibida GT cantidadOC>
                <cfset variables.RBR.setError('La cantidad total: #totalCantidadRecibida# del insumo: #local.insumo.NB_NOMBREINSUMO# sobrepasa la cantidad solicitada en la Orden de Compra: #cantidadOC#')>
                <cfreturn variables.RBR>
            </cfif>

            <cfif totalCantidadRecibida GT 0>

                <cfset Local.insumo.NU_CANTIDADRECIBIDA = totalCantidadRecibida>

                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                          method="add_Nu_CantidadSurtida"
                          id_empresa="#session.ID_EMPRESA#"
                          id_ordenDeCompra="#arguments.id_OrdenCompra#"
                          id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                          id_insumo="#Local.insumo.ID_INSUMO#"
                          nu_cantidadSurtida="#Local.insumo.NU_CANTIDADRECIBIDA#">

                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                          method="get_Nu_CantidadSurtida"
                          id_empresa="#session.ID_EMPRESA#"
                          id_ordenDeCompra="#arguments.id_OrdenCompra#"
                          id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                          id_insumo="#Local.insumo.ID_INSUMO#"
                          returnvariable="local.cantidadSurtidaObtenida">

                <cfif Local.Insumo.NU_CANTIDADRECIBIDA GT local.insumo.NU_CANTIDADPORSURTIR>
                    <cfset variables.RBR.setError('La cantidad recibida ingresada no debe ser mayor a la cantidad por surtir.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfif Local.Insumo.NU_CANTIDADRECIBIDA LT 0>
                    <cfset variables.RBR.setError('La cantidad recibida ingresada no puede tener un valor negativo.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfif local.cantidadSurtidaObtenida.nu_cantidadSurtida GTE Local.insumo.NU_CANTIDAD>
                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                              method="set_Id_estatusSurtido"
                              id_empresa="#session.ID_EMPRESA#"
                              id_ordenDeCompra="#arguments.id_OrdenCompra#"
                              id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                              id_insumo="#Local.insumo.ID_INSUMO#"
                              id_estatusSurtido="1">
                    <cfset Local.insumo.DE_ESTATUSSURTIDO = "Surtido Completo">

                <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida LT Local.insumo.NU_CANTIDAD
                          AND local.cantidadSurtidaObtenida.nu_cantidadSurtida GT 0>
                    <cfset arguments.estatusparcial = 2>
                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                              method="set_Id_estatusSurtido"
                              id_empresa="#session.ID_EMPRESA#"
                              id_ordenDeCompra="#arguments.id_OrdenCompra#"
                              id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                              id_insumo="#Local.insumo.ID_INSUMO#"
                              id_estatusSurtido="#arguments.estatusparcial#">
                    <cfset Local.insumo.DE_ESTATUSSURTIDO = "Surtido Parcialmente">

                <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida EQ 0>
                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                              method="set_Id_estatusSurtido"
                              id_empresa="#session.ID_EMPRESA#"
                              id_ordenDeCompra="#arguments.id_OrdenCompra#"
                              id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                              id_estatusSurtido="3">
                    <cfset Local.insumo.DE_ESTATUSSURTIDO = "Sin Surtir">
                </cfif>

            <cfelse>
                <!--- Sin cantidad recibida: mantener valores normalizados por defecto --->
                <cfset Local.insumo.NU_CANTIDADRECIBIDA = 0>
                <cfset Local.insumo.DE_ESTATUSSURTIDO   = "Sin Surtir">
            </cfif>

        </cfif>
    </cfloop>

    <!--- Validar estatus surtido de la Requisición --->
    <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
              method="validarEstatusSurtidoRequisicion"
              id_Empresa="#session.ID_EMPRESA#"
              id_Requisicion="#arguments.id_Requisicion#"
              returnvariable="Local.estatusRequisicion">

    <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
              method="EditarEstatusSurtidoRequisicion"
              id_Empresa="#session.ID_EMPRESA#"
              id_Requisicion="#arguments.id_Requisicion#"
              id_EstatusSurtido="#Local.estatusRequisicion#">

    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="validarEstatusSurtido"
              id_empresa="#session.ID_EMPRESA#"
              id_ordenDeCompra="#arguments.id_OrdenCompra#"
              returnvariable="Local.estatus">

    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="set_Id_estatusSurtido"
              id_empresa="#session.ID_EMPRESA#"
              id_ordenDeCompra="#arguments.id_OrdenCompra#"
              id_estatusSurtido="#local.estatus#">

    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="agregarOrdenesDeCompraMovimientos"
              id_empresa="#session.ID_EMPRESA#"
              id_ordenDeCompra="#arguments.id_OrdenCompra#"
              id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
              id_Empleado="#SESSION.ID_EMPLEADO#">

    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
              method="set_fh_ultimaEntrega"
              id_empresa="#session.ID_EMPRESA#"
              id_ordenDeCompra="#arguments.id_OrdenCompra#"
              fh_ultimaEntrega="#dateFormat(Now(),'yyyyMMdd')#">

    <cfinvoke component="#Application.RF.getPath('dao','EstatusSurtidoOrdenesDeCompra')#"
              method="getRSPorID"
              id_estatusSurtidoOrdenDeCompra="#Local.estatus#"
              returnvariable="Local.estatusSurtido">

    <cfset Local.ordenCompra = structNew()>
    <cfset Local.ordenCompra.id_ordenDeCompra       = arguments.id_OrdenCompra>
    <cfset Local.ordenCompra.nb_proveedor            = arguments.nb_proveedor>
    <cfset Local.ordenCompra.fh_registroOrdenCompra  = arguments.fh_registroOrdenCompra>
    <cfset Local.ordenCompra.fh_EntregaProbable      = arguments.fh_EntregaProbable>
    <cfset Local.ordenCompra.fh_recepcion            = arguments.fh_recepcion>
    <cfset Local.ordenCompra.nu_diasRetrazo          = arguments.nu_diasRetrazo>
    <cfset Local.ordenCompra.fl_facturaRemision      = arguments.fl_facturaRemision>
    <cfset Local.ordenCompra.fh_facturaRemision      = arguments.fh_facturaRemision>
    <cfset Local.ordenCompra.de_entrego              = arguments.de_entrego>
    <cfset Local.ordenCompra.insumos                 = arguments.insumos>
    <cfset Local.ordenCompra.de_estatusSurtido       = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra>
    <cfset Local.ordenCompra.im_TipoCambio           = Local.TipoCambio.im_TipoCambio>
    <cfset Local.ordenCompra.id_Movimiento           = "#nextID#">

    <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
              method="getMailEmpleado"
              id_usuario="#arguments.id_UsuarioRegistroMovimiento#"
              returnvariable="Local.mailEmpleado">

    <cfset Local.destinatarios = ArrayNew(1)>
    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>

    <cfif arrayLen(local.destinatarios) GT 0>
        <cfset Local.imagenes=[
            {
                dir="#session.AR_IMAGENREPORTE#",
                disposicion='inline',
                name="logo"
            }
        ]>

        <cfinvoke method="crearReporteEntradaServicio"
                  argumentcollection="#Local.ordenCompra#">

        <cfset Local.archivos=[{
            dir="reporteOrdenesCompra/reporteEntradaPorCompraServicio_Orden"&#arguments.id_OrdenCompra#&".pdf",
            name='reporte',
            sn_deleteFile="yes"
        }]>

        <cfset Local.parametros={
            id_ordenDeCompra       = arguments.id_OrdenCompra,
            nb_proveedor           = arguments.nb_proveedor,
            fh_registroOrdenCompra = arguments.fh_registroOrdenCompra,
            fh_EntregaProbable     = arguments.fh_EntregaProbable,
            fh_recepcion           = arguments.fh_recepcion,
            nu_diasRetrazo         = arguments.nu_diasRetrazo,
            fl_facturaRemision     = arguments.fl_facturaRemision,
            fh_facturaRemision     = arguments.fh_facturaRemision,
            de_entrego             = arguments.de_entrego,
            de_estatusSurtido      = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra,
            id_Movimiento          = "#nextID#"
        }/>
        <cfset Local.destinatarios = ArrayNew(1)>
        <cfset ArrayAppend(Local.destinatarios, "#arguments.de_emailProveedor#")>
        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                  method="sendMail"
                  destinatarios="#local.destinatarios#"
                  asunto="Notificacion de entrada por compra"
                  imagenes="#Local.imagenes#"
                  archivos="#Local.archivos#"
                  parametros="#Local.parametros#"
                  nu_requisision="N/A"
                  sn_plantilla="YES"
                  dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailEntradaPorCompraServicio.html"
                  returnvariable="Local.rbr"/>
    </cfif>

    <cfif arguments.id_TipoRequisicion EQ 1 AND arguments.id_TipoDivision EQ 14>
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesServicio')#"
                  id_Empresa="#arguments.id_Empresa#"
                  id_Requisicion="#arguments.id_Requisicion#"
                  id_UsuarioInicia="#arguments.id_UsuarioSolicita#"
                  sn_mov=3
                  sn_Finaliza=1
                  method="RequerimientoOrdenesServicioMov">
    </cfif>

    <cfset arguments.id_Movimiento = nextID>
    <cfset arguments.id_Empresa    = session.ID_EMPRESA>
    <cfset arguments.id_Sucursal   = SESSION.ID_SUCURSAL>
    <cfset arguments.id_Almacen    = session.ID_ALMACEN>

    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
              method="impresionDeMovimientosServicio"
              argumentcollection="#arguments#"
              returnvariable="detalle">

    <cfset datos.id_movimiento             = detalle.ID_MOVIMIENTO>
    <cfset datos.fh_movimiento             = detalle.FH_MOVIMIENTO>
    <cfset datos.nb_empresa                = detalle.NB_EMPRESA>
    <cfset datos.nb_Sucursal               = detalle.NB_SUCURSAL>
    <cfset datos.id_OrdenDeCompra          = detalle.ID_ORDENDECOMPRA>
    <cfset datos.fh_RegistroOrdenCompra    = detalle.FH_REGISTROORDENCOMPRA>
    <cfset datos.de_usuarioSolicitoOC      = detalle.DE_USUARIOSOLICITOOC>
    <cfset datos.de_usuarioRecibio         = detalle.DE_USUARIORECIBIO>
    <cfset datos.nb_Estatus                = detalle.NB_ESTATUS>
    <cfset datos.nu_Siniestro              = detalle.NU_SINIESTRO>
    <cfset datos.id_ClasificadoRequisicion = detalle.ID_CLASIFICADOREQUISICION>
    <cfset datos.de_Comentarios            = detalle.de_Comentarios>

    <cfset var Local.infoReport = {
        de_directorio = "Reportes",
        nb_archivo    = "repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
    }>

    <cfsavecontent variable="DocumentodeEntrega">
        <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientosInventarioServicio.html">
    </cfsavecontent>

    <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
              method="generatePDFNoDownload"
              content="#DocumentodeEntrega#"
              pdf="#local.infoReport.nb_archivo#"
              debug="no"
              path="#expandPath('../#local.infoReport.de_directorio#/')#">

    <cfset Local.infoReport.nb_archivo = Local.infoReport.nb_archivo & '.pdf'>
    <cfset variables.RBR.setData(Local.infoReport)>
    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

    <cfreturn variables.RBR>
</cffunction>

   <cffunction name="crearReporteEntradaServicio" access="public" returntype="any">

        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="nb_proveedor" type="string" required="true">
        <cfargument name="fh_registroOrdenCompra" type="string" required="true">
        <cfargument name="fh_EntregaProbable" type="string" required="true">
        <cfargument name="fh_recepcion" type="string" required="true">
        <cfargument name="nu_diasRetrazo" type="string" required="true">
        <cfargument name="fl_facturaRemision" type="string" required="true">
        <cfargument name="fh_facturaRemision" type="string" required="true">
        <cfargument name="de_entrego" type="string" required="true">
        <cfargument name="insumos" type="array" required="true">
        <cfargument name="id_Movimiento" type="string" required="true">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteEntradaPorCompra">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteEntradaPorCompraServicio.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteEntradaPorCompra#"
                  pdf="reporteEntradaPorCompraServicio_Orden#id_ordenDeCompra#"
                  debug="no"
                  path="#expandPath('../reporteOrdenesCompra/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <cffunction name="listarCentrosCostos" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="false" default=""/>
        <cfargument name="id_OrdenCompra" type="string" required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                  method="listarCentrosCostos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- <cffunction name="truncarDecimales" access="private" returntype="string">
        <cfargument name="cantidad" type="numeric" required="true">
        <cfargument name="cantidadReferencia" type="numeric" required="true">

        <!-- Determinar la cantidad de decimales en la referencia (BD) -->
        <cfset var cantidadReferenciaStr = ToString(arguments.cantidadReferencia)>
        <cfset var posicionPunto = Find(".", cantidadReferenciaStr)>
        <cfset var decimalesReferencia = 0>
        <cfif posicionPunto GT 0>
            <cfset decimalesReferencia = Len(cantidadReferenciaStr) - posicionPunto>
        </cfif>

        <!-- Convertir la cantidad a una cadena -->
        <cfset var cantidadStr = ToString(arguments.cantidad)>

        <!-- Crear la expresión regular basada en el número de decimales de la referencia -->
        <cfset var regex = "(\.\d{" & decimalesReferencia & "})\d*">

        <!-- Truncar los decimales excedentes -->
        <cfset var cantidadTruncada = REReplace(cantidadStr, regex, "\1", "ALL")>

        <!-- Retornar la cantidad truncada -->
        <cfreturn cantidadTruncada>
    </cffunction> --->

    <cfscript>
        private function queryToArray(q) {
            var s = [];
            var cols = q.columnList;
            var colsLen = listLen(cols);
            for(var i=1; i<=q.recordCount; i++) {
                row = {};
                for(var k=1; k<=colsLen; k++) {
                    row[lcase(listGetAt(cols, k))] = q[listGetAt(cols, k)][i];
                }
                arrayAppend(s, row);
            }
            return s;
        }

        // private function truncarDecimales(cantidad) {
        //     var cantidadStr = ToString(cantidad);
        //     var cantidadTruncada = REReplace(cantidadStr, "(00000).*", "\1", "ALL");
        //     return cantidadTruncada;
        // }
    </cfscript>
</cfcomponent>
