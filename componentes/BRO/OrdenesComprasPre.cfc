<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"                  type="string"       required="false"/>
        <cfargument name="id_SucursaListado"               type="string"       required="false"/>
        <cfargument name="fh_InicioListado"                type="string"       required="false"/>
        <cfargument name="fh_FinListado"                   type="string"       required="false"/>
        <cfargument name="id_DepartamentoListado"          type="string"       required="false"/>
        <cfargument name="id_EstatusAutorizacionListado"   type="string"       required="false"/>
        <cfargument name="nu_Siniestro"                    type="string"       required="false" default=""/>

        <cfset  arguments.id_Empresa = session.ID_EMPRESA>
        <cfset  arguments.id_Usuario = session.ID_USUARIO>

        <!---  <cfset  arguments.id_SucursaListado = SESSION.ID_SUCURSAL> --->

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.OrdenCompra">

        <cfset variables.RBR.setQuery(Local.OrdenCompra)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Modificacion: Rey David Dominguez
          Fecha: 13/03/2015
          Actualiza el ultimo precio compra de  cada insumo del detalle cuando la orden de compra
          se autoriza
          --->

    <cffunction name="Editar"            access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
        <cfargument name="Estatus"                  type="string" required="true"/>
        <cfargument name="de_Observaciones"         type="string" required="true"/>
        <cfargument name="OrdenesCompras"           type="array"  required="true"/>
        <cfargument name="id_CotizacionReporte"     type="string"  required="false"/>
        <cfargument name="id_Almacen"               type="string"  required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Usuario = session.ID_USUARIO>
        <cfset local.Autorizada     = 2>
        <cfset local.Rechazada      = 3>

        <!--- Victor Sanchez
            13/08/2015
            se ejecuta para trael el nombre del almacen seleccionado--->
        <!--- Si el estatus es 1 'Autorizado' --->
        <cfif not isDefined("arguments.id_almacen") OR arguments.id_almacen EQ ''>
            <cfset nb_Almacen               = structNew()>
            <cfset nb_Almacen.nb_Almacen    = 'NA'>
            <cfset arguments.id_almacen     = '3'>
        </cfif>

        <cfif #Estatus# EQ '1'>
            <cfinvoke   component       = "#Application.RF.getPath('dao','Almacenes')#"
                        method          = "getNameAlmacen"
                        id_Empresa      = "#session.ID_EMPRESA#"
                        id_Sucursal     = "#SESSION.ID_SUCURSAL#"
                        id_Almacen      = "#arguments.id_Almacen#"
                        returnvariable  ="nb_Almacen">
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
                    <!---<cfset structClear(Local.OC)>
                     Define si es la orden es autorizada o rechazada, 1 = Autorizada, 0 = Rechazada --->
                    <cfif arguments.Estatus EQ 1>
                        <!---
                            Si la OC fue Pre-Autorizada,
                                - Se actualiza el estatus en la tabla OrdenesDeCompraUsuariosPreAutorizan,
                                - Se genera un registro para autorizarla
                                - Se envia un correo
                        --->
                        <!--- Tipo de cambio al dia para obtener el monto autorizacion --->
                        <cfset local.im_TipoCambioAutorizar = 1>
                        <cfinvoke component="#Application.RF.getPath('dao','MonedasTipoCambio')#"
                                method="getUltimoim_TipoCambio"
                                id_Moneda="#arguments.OrdenesCompras[local.i].id_Moneda#"
                                returnvariable="local.RSTipoCambio">

                        <cfif isNumeric(local.RSTipoCambio.im_TipoCambio)>
                            <cfset local.im_TipoCambioAutorizar = local.RSTipoCambio.im_TipoCambio>
                        </cfif>
                        <cfset local.nb_Moneda = local.RSTipoCambio.nb_Moneda>
                        <cfset local.im_TotalAutorizar = arguments.OrdenesCompras[local.i].im_total * local.im_TipoCambioAutorizar>

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                    method="quienAutoriza"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    Total="#local.im_TotalAutorizar#"
                                    returnvariable="empleado">

                        <cfif NOT empleado.id_Empleado GT 0>
                            <cfset variables.RBR.setError('No es posible registrar la orden de compra por que no hay alguien configurado para autorizarla.')>
                            <cfreturn Variables.RBR>
                        </cfif>

                        <cfset local.DatosOrdenes = structNew()>
                        <cfset local.ConTotal = 0>
                        <cfset local.ConAutorizadas = 0>

                        <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                        <cfset local.DatosOrdenes.id_Empresa         = session.ID_EMPRESA>
                        <cfset local.DatosOrdenes.id_Sucursal        = arguments.OrdenesCompras[local.i].id_Sucursal>
                        <cfset local.DatosOrdenes.id_Almacen         = #session.ID_ALMACEN#>
                        <cfset local.OrdenCompra                     = arguments.OrdenesCompras[local.i]>
                        <cfset local.DatosOrdenes.id_Usuario         = session.ID_USUARIO>
                        <cfset local.DatosOrdenes.de_Observaciones   = arguments.de_Observaciones>
                        <cfset local.DatosOrdenes.id_OrdenCompra     = arguments.OrdenesCompras[local.i].id_OrdenDeCompra>
                        <cfset local.DatosOrdenes.fh_EntregaProbable = arguments.OrdenesCompras[local.i].fh_EntregaProbable>

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                                    method="Editar"
                                    argumentcollection="#local.DatosOrdenes#">

                        <!--- PREAUTORIZADOR --->
                        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionPreAutorizacionOrdenesCompra')#"
                            method="getConfiguracionPorEmpresa"
                            id_Empresa="#Arguments.id_Empresa#"
                            id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                            id_Sucursal = "#local.DatosOrdenes.id_Sucursal#"
                            returnvariable="Local.usuariosPreAutorizan">

                        <!--- Si no hay alguien disponible en el siguiente nivel, lo salta y lo busca en el siguiente de ese --->
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
                                  id_empresa="#session.ID_EMPRESA#"
                                  id_Sucursal="#local.DatosOrdenes.id_Sucursal#"
                                  im_Autorizado ="#local.im_TotalAutorizar#"
                                  id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                                  returnvariable="Local.usuariosAutorizan">

                        <!---/**
                        * Se realiza la actualizacion de estatus de la requisicionCMF
                        * (si es que es una, lo verifica dentro del SP)
                        */--->
                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                                  method="ActualizarEstatusCMF"
                                  id_Empresa = "#arguments.id_Empresa#"
                                  id_OrdenCompra = "#arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                  id_estatus = "#arguments.Estatus#">

                                  <!--- <cfcontent type="text/html">
                                  <cfdump var="#Local.usuariosAutorizan#" format="simple" label="arguments" abort="true"> --->

                        <!---
                        ENVIAR LA ORDEN DE COMPRA A PRE-AUTORIZAR
                        --->
                        <cfif #Local.usuariosPreAutorizan.RecordCount# GT 0> <!-- AND sn_PreAutorizacion EQ 1 -->
                            <!--- <cfif local.sn_EnvioCorreo EQ 0>
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
                                    <cfset Local.usuarioPreAut.id_Sucursal                         = local.DatosOrdenes.id_Sucursal>
                                    <cfset Local.usuarioPreAut.id_OrdenDeCompra                    = local.DatosOrdenes.id_OrdenCompra>
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
                        <cfelse>
                            <!---
                                ENVIAR LA ORDEN DE COMPRA A AUTORIZAR
                            --->
                            <cfset Local.usuarioAut=structNew()>
                            <cfset Local.usuarioAut_Insert=structNew()>
                            <cfset Local.destinatarios=arrayNew()>

                            <cfloop query="Local.usuariosAutorizan">
                                <!--- <cfif local.sn_EnvioCorreo EQ 0>
                                    <cfset Local.sn_EnvioCorreo = Local.usuariosAutorizan.sn_EnvioCorreo>
                                </cfif> --->
                                <cfif local.im_TotalAutorizar GTE Local.usuariosAutorizan.nu_rangoInicioImporte
                                    AND local.im_TotalAutorizar LTE Local.usuariosAutorizan.nu_rangoFinalImporte>
                                    <cfset structClear(Local.usuarioAut)>

                                    <cfset Local.usuarioAut.id_Empresa                          = session.ID_EMPRESA>
                                    <cfset Local.usuarioAut.id_OrdenDeCompra                    = local.DatosOrdenes.id_OrdenCompra>
                                    <cfset Local.usuarioAut.id_UsuarioAutoriza                  = Local.usuariosAutorizan.id_usuario>
                                    <cfset Local.usuarioAut.id_EstatusAutorizacionOrdenDeCompra = 1>
                                    <cfset Local.usuarioAut.fh_AsignacionEstatus                = dateFormat(now(),'yyyymmdd')>
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

                            <cfset Local.ordenCompra.id_Sucursal = local.Master.ID_SUCURSAL>
                            <cfset Local.ordenCompra.id_Almacen = local.Master.ID_ALMACENENTREGA>

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
                                id_Sucursal    = Local.ordenCompra.id_Sucursal,
                                id_Almacen     = Local.ordenCompra.id_Almacen,
                                nu_ordenCompra = Local.ordenCompra.id_OrdenDeCompra,
                                nb_sucursal    = Local.ordenCompra.nb_sucursal,
                                nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                                nb_proveedor   = Local.ordenCompra.nb_proveedor,
                                fh_programada  = Local.ordenCompra.fh_EntregaProbable,
                                nu_requisicion = Local.ordenCompra.id_requisicion,
                                im_total       = Local.ordenCompra.im_Total,
                                nb_Moneda      = local.nb_Moneda,
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
                    <cfelseif arguments.Estatus EQ 0>

                        <cfset local.DatosOrdenes = structNew()>
                        <cfset local.ConRechazadas = 0>
                        <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                        <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                        <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                        <cfset local.DatosOrdenes.id_Sucursal = SESSION.ID_SUCURSAL>
                        <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                        <cfset local.DatosOrdenes.id_OrdenCompra = arguments.OrdenesCompras[local.i].id_OrdenDeCompra>

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                                    method="Editar"
                                    argumentcollection="#local.DatosOrdenes#">

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
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
                                  id_OrdenCompra = "#arguments.OrdenesCompras[local.i].id_OrdenDeCompra#"
                                  id_estatus = "#arguments.Estatus#">

                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                    </cfif>
                </cfloop>
            <cfelse>
                <cfif arguments.Estatus EQ 1>
                    <!---
                            Si la OC fue Pre-Autorizada,
                                - Se actualiza el estatus en la tabla OrdenesDeCompraUsuariosPreAutorizan,
                                - Se genera un registro para autorizarla
                                - Se envia un correo
                        --->

                    <!--- Para sacar la moneda de la OC --->
                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                            method="getById"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_OrdenDeCompra="#arguments.OrdenesCompras.id_OrdenDeCompra#"
                            returnvariable="local.RSOrdenDeCompra">

                    <!--- Tipo de cambio al dia para obtener el monto autorizacion --->
                    <cfset local.im_TipoCambioAutorizar = 1>
                    <cfinvoke component="#Application.RF.getPath('dao','MonedasTipoCambio')#"
                            method="getUltimoim_TipoCambio"
                            id_Moneda="#local.RSOrdenDeCompra.id_Moneda#"
                            returnvariable="local.RSTipoCambio">

                    <cfif isNumeric(local.RSTipoCambio.im_TipoCambio)>
                        <cfset local.im_TipoCambioAutorizar = local.RSTipoCambio.im_TipoCambio>
                    </cfif>
                    <cfset local.nb_Moneda = local.RSTipoCambio.nb_Moneda>
                    <cfset local.im_TotalAutorizar = arguments.OrdenesCompras.im_total * local.im_TipoCambioAutorizar>

                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                    method="quienAutoriza"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    Total="#local.im_TotalAutorizar#"
                                    returnvariable="empleado">

                        <cfif NOT empleado.id_Empleado GT 0>
                            <cfset variables.RBR.setError('No es posible registrar la orden de compra por que no hay alguien configurado para autorizarla.')>
                            <cfreturn Variables.RBR>
                        </cfif>

                        <cfset local.DatosOrdenes = structNew()>
                        <cfset local.ConTotal = 0>
                        <cfset local.ConAutorizadas = 0>

                        <cfset local.OrdenCompra = arguments.OrdenesCompras>
                        <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                        <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                        <cfset local.DatosOrdenes.id_Sucursal = SESSION.ID_SUCURSAL>
                        <cfset local.DatosOrdenes.id_Almacen = #session.ID_ALMACEN#>

                        <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                        <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                        <cfset local.DatosOrdenes.id_OrdenCompra = arguments.OrdenesCompras.id_OrdenDeCompra>

                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                                    method="Editar"
                                    argumentcollection="#local.DatosOrdenes#">

                        <!--- PREAUTORIZADOR --->
                        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionPreAutorizacionOrdenesCompra')#"
                            method="getConfiguracionPorEmpresa"
                            id_Empresa="#Arguments.id_Empresa#"
                            id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                            id_Sucursal = "#local.DatosOrdenes.id_Sucursal#"
                            returnvariable="Local.usuariosPreAutorizan">

                        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionOrdenesCompra')#"
                            method="getConfiguracionPorEmpresa"
                            id_empresa="#session.ID_EMPRESA#"
                            id_Sucursal="#arguments.OrdenesCompras.id_Sucursal#"
                            returnvariable="Local.usuariosAutorizan">

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

                        <!---/**
                        * Se realiza la actualizacion de estatus de la requisicionCMF
                        * (si es que es una, lo verifica dentro del SP)
                        */--->
                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                                  method="ActualizarEstatusCMF"
                                  id_Empresa = "#arguments.id_Empresa#"
                                  id_OrdenCompra = "#arguments.OrdenesCompras.id_OrdenDeCompra#"
                                  id_estatus = "#arguments.Estatus#">

                        <!---
                        ENVIAR LA ORDEN DE COMPRA A PRE-AUTORIZAR
                        --->
                        <cfif #Local.usuariosPreAutorizan.RecordCount# GT 0> <!-- AND sn_PreAutorizacion EQ 1 -->
                            <!--- <cfif local.sn_EnvioCorreo EQ 0>
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
                                    <cfset Local.usuarioPreAut.id_Sucursal                         = local.DatosOrdenes.id_Sucursal>
                                    <cfset Local.usuarioPreAut.id_OrdenDeCompra                    = local.DatosOrdenes.id_OrdenCompra>
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
                        <cfelse>
                            <!---
                                ENVIAR LA ORDEN DE COMPRA A AUTORIZAR
                            --->
                            <cfset Local.usuarioAut=structNew()>
                            <cfset Local.usuarioAut_Insert=structNew()>
                            <cfset Local.destinatarios=arrayNew(1)>

                            <cfloop query="Local.usuariosAutorizan">
                                <!--- <cfif local.sn_EnvioCorreo EQ 0>
                                    <cfset local.sn_EnvioCorreo = Local.usuariosAutorizan.sn_EnvioCorreo>
                                </cfif> --->
                                <cfif local.im_TotalAutorizar GTE Local.usuariosAutorizan.nu_rangoInicioImporte
                                    AND local.im_TotalAutorizar LTE Local.usuariosAutorizan.nu_rangoFinalImporte>
                                    <cfset structClear(Local.usuarioAut)>

                                    <cfset Local.usuarioAut.id_Empresa=session.ID_EMPRESA>
                                    <cfset Local.usuarioAut.id_OrdenDeCompra=local.DatosOrdenes.id_OrdenCompra>
                                    <cfset Local.usuarioAut.id_UsuarioAutoriza=Local.usuariosAutorizan.id_usuario>
                                    <cfset Local.usuarioAut.id_EstatusAutorizacionOrdenDeCompra=1>
                                    <cfset Local.usuarioAut.fh_AsignacionEstatus=dateFormat(now(),'yyyymmdd')>

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

                        <cfif arrayLen(Local.destinatarios) GT 0>

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

                            <!---
                                Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018

                            <cfset Local.parametros={
                                nu_ordenCompra= Local.ordenCompra.id_OrdenDeCompra,
                                nb_sucursal = Local.ordenCompra.nb_sucursal,
                                nb_empleado= session.NB_EMPLEADOCOMPLETO,
                                nb_proveedor= Local.ordenCompra.nb_proveedor,
                                fh_programada= Local.ordenCompra.fh_EntregaProbable,
                                nu_requisicion= Local.ordenCompra.id_requisicion,
                                im_total= Local.ordenCompra.im_Total,
                                nb_Moneda = local.nb_Moneda
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
                            --->

                        </cfif>

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                <cfelseif arguments.Estatus EQ 0>

                    <cfset local.DatosOrdenes = structNew()>
                    <cfset local.ConRechazadas = 0>
                    <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                    <cfset local.DatosOrdenes.id_sucursal = SESSION.ID_SUCURSAL>
                    <cfset local.DatosOrdenes.id_Almacen = arguments.id_almacen>
                    <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                    <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                    <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                    <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                                method="Editar"
                                argumentcollection="#local.DatosOrdenes#">

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
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
                              id_OrdenCompra = "#arguments.OrdenesCompras.id_OrdenDeCompra#"
                              id_estatus = "#arguments.Estatus#">

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                </cfif>
            </cfif>


        </cfif>
        <!---<cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>--->
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

</cfcomponent>
