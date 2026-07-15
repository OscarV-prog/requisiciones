<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="getByID" access="remote" returntype="any">
        <cfargument name="id_Empresa"       type="string" required="true">
        <cfargument name="id_Sucursal"      type="string" required="true">
        <cfargument name="id_Almacen"       type="string" required="true">
        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="id_Usuario"       type="string" required="false">
        <cfargument name="sn_ParaEntrada"   type="boolean" required="false" default="false">

        <cfinvoke component="#Application.RF.getPath('dao','AutorizacionOC')#"
                method="getById"
                id_Empresa="#arguments.id_Empresa#"
                id_ordenDeCompra="#Arguments.id_ordenDeCompra#"
                returnvariable="local.Master"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalle"
                  id_empresa="#arguments.ID_EMPRESA#"
                  id_sucursal="#arguments.ID_SUCURSAL#"
                  id_almacen="#arguments.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  sn_ParaEntrada="#Arguments.sn_ParaEntrada#"
                  returnvariable="local.Detalle"/>

        <cfinvoke component="#Application.RF.getPath('dao','Impuestos')#"
                  method="getByOrdenDeCompra"
                  id_empresa="#arguments.ID_EMPRESA#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Impuestos"/>

        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="getDetalleinsumospordevolucion"
                  id_empresa="#arguments.ID_EMPRESA#"
                  id_sucursal="#arguments.ID_SUCURSAL#"
                  id_almacen="#arguments.ID_ALMACEN#"
                  id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                  returnvariable="local.Detalleinsumosdevolucion"/>

          <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                  method="upR_DetalleRequisicionByOCD"
                  id_empresa="#arguments.ID_EMPRESA#"
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

    <cffunction name="listarCotizacionesparaAutorizarOrdenCompra" access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"   type="string" required="false"/>
        <cfargument name="id_Empresa"       type="string" required="true">

        <!--- se obtiene el id del usuario de la session para listar solo las requisiones que esten asignadas al usuario logueado --->
        <!--- <cfset  arguments.id_Empresa= session.ID_EMPRESA> --->

      <!---    <cfoutput>BRO</cfoutput>
       <cfdump var="#session.ID_EMPRESAOPERADORA#"><cfabort> --->

            <cfinvoke component="#Application.RF.getPath('dao','AutorizacionOC')#"
                      method="listarCotizacionesparaAutorizarOrdenCompra"
                      argumentcollection="#arguments#"
                      returnvariable="Local.Cotizaciones">

                      <cfset variables.RBR.setQuery(Local.Cotizaciones)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="cambiarEstatusOC"            access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Estatus"               type="string"  required="true"/>
        <cfargument name="nb_Usuario"               type="string"  required="true"/>
        <cfargument name="de_Password"              type="string"  required="true"/>
        <cfargument name="de_observaciones"         type="string"  required="true"/>
        <cfargument name="sn_CorreoProveedor"       type="string"  required="false" default="true"/>
        <cfargument name="sn_PreAutorizacion"       type="string"  required="false" default="false"/>
        <cfargument name="im_total"                 type="string"  required="false" default="1"/>

        <!--- Nos vamos por los datos del usuario --->
        <cfinvoke component="#Application.RF.getPath('dao','Usuarios')#"
                  method="getByName"
                  nb_usuario="#Arguments.nb_usuario#"
                  returnvariable="Local.user">

        <!--- Si el usuario existe --->
        <cfif #Local.user.RecordCount# EQ 0>
            <cfset variables.RBR.setError('Usuario incorrecto. Verifique su información.')>
            <cfreturn variables.RBR>
        </cfif>

        <!--- validamos cuando el usuario no cuenta con una contraseña --->
        <cfif Local.user.cl_Contrasena EQ ''>
            <cfset variables.RBR.setError('El usuario con el que intenta realizar la operación, no cuenta con una contraseña establecida.<br>Es necesario iniciar sesión en el sistema por lo menos una vez, para poder realizar la autorización desde esta pantalla.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfif "X#decrypt(Local.user.cl_Contrasena,'petroil')#" NEQ "X#Arguments.de_password#">
            <cfset variables.RBR.setError('Usuario y/o Contraseña incorrectos. Verifique su información.')>
            <cfreturn variables.RBR>
        </cfif>

        <!--- Obtener las Variables de Session --->
        <cfset session.LOGGEDIN       = true>
        <cfset session.ID_USUARIO     = Local.user.id_Usuario>
        <cfset session.ID_TIPOUSUARIO = Local.user.id_TipoUsuario>
        <cfset session.NB_USUARIO     = Local.user.nb_Usuario>

        <cfif local.user.id_Empleado EQ ''>
            <cfset SESSION.ID_EMPLEADO     = 0>
        <cfelse>
            <cfset SESSION.ID_EMPLEADO     = Local.user.id_Empleado>
        </cfif>

        <cfset session.NB_EMPLEADOCOMPLETO          = Local.user.nombre>
        <cfset session.NB_EMPLEADO                  = Local.user.nb_NombreEmpleado>
        <cfset session.NB_APELLIDOPATERNO           = Local.user.nb_apellidoPaterno>
        <cfset session.NB_APELLIDOMATERNO           = Local.user.nb_apellidoMaterno>
        <cfset session.ID_EMPRESAOPERADORA          = Local.user.id_EmpresaOperadora>
        <cfset Session.nb_EmpresaOperadora          = Local.user.nb_EmpresaOperadora>
        <cfset session.DE_EMAIL                     = Local.user.de_Email>
        <cfset session.ID_EMPRESA                   = #arguments.id_Empresa#>
        <cfset SESSION.ID_SUCURSAL                  = #arguments.id_Sucursal#>
        <cfset arguments.id_EmpresaEmpleadoRegistro = #session.ID_EMPRESAOPERADORA#>
        <cfset arguments.id_EmpleadoRegistro        = #SESSION.ID_EMPLEADO#>
        <cfset arguments.id_Usuario                 = session.ID_USUARIO>
        <cfset session.ID_ALMACEN                   = arguments.id_Almacen>
        <cfset local.Autorizada = 2>
        <cfset local.Rechazada  = 3>

        <cfif arguments.id_Estatus EQ 1>
            <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                    method="getNameAlmacen"
                    id_Empresa = "#arguments.id_Empresa#"
                    id_Sucursal = "#arguments.id_Sucursal#"
                    id_Almacen="#arguments.id_Almacen#"
                    returnvariable="nb_Almacen">
        </cfif>

        <!--- Inicio de la Pre-Autorizacion --->
        <cfif arguments.sn_PreAutorizacion EQ 1> <!---Es una Pre-Autorizacion --->
            <cfif arguments.id_Estatus EQ 1> <!---Se Autoriza --->

                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="getById_UsuariosAutorizan"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_OrdenDeCompra="#arguments.id_OrdenCompra#"
                    returnvariable="local.RSOrdenDeCompra">

                <cfset sn_UsuariosAutorizan = 0>
                <cfloop query="Local.RSOrdenDeCompra"> <!---Puede haber mas de un usuario para autorizar --->
                    <cfset id_UsuarioAutorizaOC = Local.RSOrdenDeCompra.id_UsuarioAutorizaOC>

                    <cfif id_UsuarioAutorizaOC EQ  arguments.id_Usuario >
                        <cfset sn_UsuariosAutorizan = 1>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif sn_UsuariosAutorizan EQ 0> <!---Si el usuario enviado no coincide, se bloquea la autorizacion --->
                    <cfset variables.RBR.setError('Usted no cuenta con permisos para AUTORIZAR la OC.<br>Verifique su información.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfset local.im_TipoCambioAutorizar = 1>
                <cfinvoke component="#Application.RF.getPath('dao','MonedasTipoCambio')#"
                        method="getUltimoim_TipoCambio"
                        id_Moneda="#local.RSOrdenDeCompra.id_Moneda#"
                        returnvariable="local.RSTipoCambio">

                <cfif isNumeric(local.RSTipoCambio.im_TipoCambio)>
                    <cfset local.im_TipoCambioAutorizar = local.RSTipoCambio.im_TipoCambio>
                </cfif>
                <cfset local.nb_Moneda = local.RSTipoCambio.nb_Moneda>
                <cfset local.im_TotalAutorizar = local.RSOrdenDeCompra.im_total * local.im_TipoCambioAutorizar>

                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                method="quienAutoriza"
                                id_Empresa="#session.ID_EMPRESA#"
                                Total="#local.im_TotalAutorizar#"
                                returnvariable="empleado">

                <cfif NOT empleado.id_Empleado GT 0>
                    <cfset variables.RBR.setError('No es posible registrar la orden de compra porque no hay alguien configurado para autorizarla.')>
                    <cfreturn Variables.RBR>
                </cfif>

                <cfset local.DatosOrdenes = structNew()>
                <cfset local.ConTotal = 0>
                <cfset local.ConAutorizadas = 0>

                <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                <cfset local.DatosOrdenes.id_Sucursal = SESSION.ID_SUCURSAL>
                <cfset local.DatosOrdenes.id_Almacen = #session.ID_ALMACEN#>

                <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesComprasPre')#"
                                method="Editar"
                                argumentcollection="#local.DatosOrdenes#">

                <!--- PREAUTORIZADOR --->
                <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionPreAutorizacionOrdenesCompra')#"
                    method="getConfiguracionPorEmpresa"
                    id_Empresa="#session.ID_EMPRESA#"
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
                    id_Sucursal="#SESSION.ID_SUCURSAL#"
                    im_Autorizado="#local.im_TotalAutorizar#"
                    id_OrdenDeCompra = "#local.DatosOrdenes.id_OrdenCompra#"
                    returnvariable="Local.usuariosAutorizan">

                    <!---/**
                * Se realiza la actualizacion de estatus de la requisicionCMF
                * (si es que es una, lo verifica dentro del SP)
                */--->
                <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                            method="ActualizarEstatusCMF"
                            id_Empresa = "#arguments.id_Empresa#"
                            id_OrdenCompra = "#local.DatosOrdenes.id_OrdenCompra#"
                            id_estatus = "#arguments.id_Estatus#">

                <!---
                ENVIAR LA ORDEN DE COMPRA A PRE-AUTORIZAR
                --->
                <cfif #Local.usuariosPreAutorizan.RecordCount# GT 0> <!---AND sn_PreAutorizacion EQ 1 --->
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
                    <cfset Local.usuarioAut=structNew()>
                    <cfset Local.usuarioAut_Insert=structNew()>
                    <cfset Local.destinatarios=arrayNew(1)>
                    <!--- <cfset Local.sn_EnvioCorreo = Local.usuariosAutorizan.SN_ENVIOCORREO> --->

                    <cfloop query="Local.usuariosAutorizan">
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
                    <cfif arrayLen(Local.destinatarios) GT 0>

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                            method="getById"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.id_OrdenCompra#"
                            returnvariable="local.Master"/>

                        <cfset Local.ordenCompra.id_Sucursal = SESSION.ID_SUCURSAL>
                        <cfset Local.ordenCompra.id_Almacen = session.ID_ALMACEN>

                        <cfset Local.DatosOrdenes.id_requisicion = local.Master.ID_REQUISICION>
                        <cfset Local.DatosOrdenes.nb_sucursal = local.Master.NB_SUCURSAL>
                        <cfset Local.DatosOrdenes.nb_proveedor = local.Master.NB_PROVEEDOR>
                        <cfset local.DatosOrdenes.fh_EntregaProbable = local.Master.FH_ENTREGAPROBABLE>
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
                            id_Sucursal    = SESSION.ID_SUCURSAL,
                            id_Almacen     = session.ID_ALMACEN,
                            nu_ordenCompra = arguments.id_OrdenCompra,
                            nb_sucursal    = session.NB_SUCURSAL,
                            nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                            nb_proveedor   = Local.Master.nb_proveedor,
                            fh_programada  = Local.Master.fh_EntregaProbable,
                            nu_requisicion = Local.Master.id_requisicion,
                            im_total       = Local.Master.im_Total,
                            nb_Moneda      = local.nb_Moneda,
                            webPath        = Local.webPath,
                            nb_Asunto      = 'Solicitud de autorizacion de orden de compra',
                            sn_PreAutorizacion = 0
                        }/>

                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            destinatarios="#Local.destinatarios#"
                            asunto="Solicitud de autorizacion de orden de compra"
                            imagenes="#Local.imagenes#"
                            parametros="#Local.parametros#"
                            sn_plantilla="YES"
                            dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                            returnvariable="Local.rbr"/>


                    </cfif>
                </cfif>

                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            <cfelseif arguments.id_Estatus EQ 0> <!---Se Rechaza --->

                <cfset local.DatosOrdenes = structNew()>
                <cfset local.ConRechazadas = 0>
                <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                <cfset local.DatosOrdenes.id_Empresa = session.ID_EMPRESA>
                <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                <cfset local.DatosOrdenes.id_Sucursal = SESSION.ID_SUCURSAL>
                <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones>
                <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="getById_UsuariosAutorizan"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_OrdenDeCompra="#arguments.id_OrdenCompra#"
                    returnvariable="local.RSOrdenDeCompra">

                <cfset sn_UsuariosAutorizan = 0>
                <cfloop query="Local.RSOrdenDeCompra"> <!---Puede haber mas de un usuario para autorizar --->
                    <cfset id_UsuarioAutorizaOC = Local.RSOrdenDeCompra.id_UsuarioAutorizaOC>

                    <cfif id_UsuarioAutorizaOC EQ  arguments.id_Usuario >
                        <cfset sn_UsuariosAutorizan = 1>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif sn_UsuariosAutorizan EQ 0> <!---Si el usuario enviado no coincide, se bloquea la autorizacion --->
                    <cfset variables.RBR.setError('Usted no cuenta con permisos para RECHAZAR la OC. Verifique su información.')>
                    <cfreturn variables.RBR>
                </cfif>

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

            </cfif>
            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfelse> <!---Es una Autorizacion --->
            <!--- Inicio de Autorizacion Orden de Compra--->
            <cfif arguments.id_Estatus EQ 1> <!---Se Autoriza --->
                <cfset local.DatosOrdenes = structNew()>
                <cfset local.ConTotal = 0>
                <cfset local.ConAutorizadas = 0>

                <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 2>
                <cfset local.DatosOrdenes.id_Empresa                        = session.ID_EMPRESA>
                <cfset local.DatosOrdenes.id_Sucursal                       = SESSION.ID_SUCURSAL>
                <!---  <cfset local.DatosOrdenes.id_Almacen                 = #arguments.id_Almacen#> --->
                <cfset local.DatosOrdenes.id_Almacen                        = #arguments.id_Almacen#>

                <cfset local.DatosOrdenes.id_Usuario            = session.ID_USUARIO>
                <cfset local.DatosOrdenes.de_Observaciones      = arguments.de_observaciones>
                <cfset local.DatosOrdenes.id_OrdenCompra        = arguments.id_OrdenCompra>
                <cfset local.DatosOrdenes.sn_PreAutorizacion    = arguments.sn_PreAutorizacion>
                    <!--- <cfdump var="#local.DatosOrdenes#"> --->

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="getById_UsuariosAutorizan"
                    id_empresa="#arguments.id_empresa#"
                    id_ordenDeCompra="#arguments.id_OrdenCompra#"
                    returnvariable="Local.ordenDeCompra">
                    <!--- <cfdump var="#Local.ordenDeCompra#"> --->

                <cfset sn_UsuariosAutorizan = 0>
                <cfloop query="Local.ordenDeCompra"> <!---Puede haber mas de un usuario para autorizar --->
                    <cfset id_UsuarioAutorizaOC = Local.ordenDeCompra.id_UsuarioAutorizaOC>

                    <cfif id_UsuarioAutorizaOC EQ  arguments.id_Usuario >
                        <cfset sn_UsuariosAutorizan = 1>
                        <cfset local.DatosOrdenes.im_Total = local.ordenDeCompra.im_Total>
                        <cfbreak>
                    </cfif>
                </cfloop>
                <cfif sn_UsuariosAutorizan EQ 0> <!---Si el usuario enviado no coincide, se bloquea la autorizacion --->
                    <cfset variables.RBR.setError('Usted no cuenta con permisos para AUTORIZAR la OC.<br>Verifique su información.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                            method="Editar"
                            argumentcollection="#local.DatosOrdenes#">

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                            method="listarOrdenesAsignadasaUsuarios"
                            argumentcollection="#local.DatosOrdenes#"
                            returnvariable="Local.Ordenes">

                <!--- <cfloop query="local.Ordenes">
                    <cfset local.ConTotal += 1>
                    <cfif local.Autorizada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                        <cfset local.ConAutorizadas += 1>
                    </cfif>
                </cfloop>

                <cfif local.ConTotal EQ local.ConAutorizadas>
                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="EditarOrdenCompraGeneral"
                                argumentcollection="#local.DatosOrdenes#">
                </cfif> --->

                <cfset Local.argAlmancen=structNew()>
                <cfif arguments.id_almacen NEQ ''>
                    <cfset Local.argAlmancen.id_almacen=arguments.id_almacen>
                </cfif>

                <!--- BUSCAR MAS AUTORIZADOR --->
                <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionOrdenesCompra')#"
                    method="getConfiguracionPorEmpresa"
                    id_empresa="#local.DatosOrdenes.id_Empresa#"
                    id_Sucursal="#local.DatosOrdenes.id_Sucursal#"
                    im_Autorizado ="#local.DatosOrdenes.im_Total#"
                    id_OrdenDeCompra ="#local.DatosOrdenes.id_OrdenCompra#"
                    returnvariable="Local.usuariosAutorizan">

                <cfif #Local.usuariosAutorizan.RecordCount# GT 0> <!---Hay mas Autorizadores --->
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

                    <cfif arrayLen(Local.destinatarios) GT 0>

                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                            method="getById"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.id_OrdenCompra#"
                            returnvariable="local.Master"/>

                            <cfset Local.DatosOrdenes.id_Sucursal = local.Master.ID_SUCURSAL>
                            <cfset Local.DatosOrdenes.id_Almacen = local.Master.ID_ALMACENENTREGA>

                            <cfset Local.DatosOrdenes.id_requisicion = local.Master.ID_REQUISICION>
                            <cfset Local.DatosOrdenes.nb_sucursal = local.Master.NB_SUCURSAL>
                            <cfset Local.DatosOrdenes.nb_proveedor = local.Master.NB_PROVEEDOR>
                            <cfset local.DatosOrdenes.fh_EntregaProbable = local.Master.FH_ENTREGAPROBABLE>
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
                            id_Sucursal    = SESSION.ID_SUCURSAL,
                            id_Almacen     = session.ID_ALMACEN,
                            nu_ordenCompra = Local.DatosOrdenes.id_OrdenCompra,
                            nb_sucursal    = session.NB_SUCURSAL,
                            nb_empleado    = session.NB_EMPLEADOCOMPLETO,
                            nb_proveedor   = Local.DatosOrdenes.nb_proveedor,
                            fh_programada  = Local.DatosOrdenes.fh_EntregaProbable,
                            nu_requisicion = Local.DatosOrdenes.id_requisicion,
                            im_total       = Local.DatosOrdenes.im_Total,
                            nb_Moneda      = Local.DatosOrdenes.nb_Moneda,
                            webPath        = Local.webPath,
                            nb_Asunto      = 'Solicitud de autorizacion de orden de compra',
                            sn_PreAutorizacion = 0
                        }/>

                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            destinatarios="#Local.destinatarios#"
                            asunto="Solicitud de autorizacion de orden de compra"
                            imagenes="#Local.imagenes#"
                            parametros="#Local.parametros#"
                            sn_plantilla="YES"
                            dir_plantilla="templates/correos/Compras/templateMailOrdenesCompra.html"
                            returnvariable="Local.rbr"/>


                    </cfif>
                <cfelse> <!---No hay mas Autorizadores  --->
                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="EditarOrdenCompraGeneral"
                                argumentcollection="#local.DatosOrdenes#">

                    <!--- Obtener el detalle de la orden de compra - --->
                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                                method="getDetalle"
                                id_empresa="#session.ID_EMPRESA#"
                                id_ordenDeCompra="#arguments.id_OrdenCompra#"
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
                    <cfset local.DatosOrdenes.id_Empresa = arguments.id_Empresa>
                    <cfset local.DatosOrdenes.id_sucursal = arguments.id_Sucursal>
                    <cfset local.DatosOrdenes.id_Almacen = arguments.id_almacen>
                    <cfset local.DatosOrdenes.id_Cotizacion = Local.ordenDeCompra.id_Cotizacion>

                    <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                    <!--- <cfset local.DatosOrdenes.de_Observaciones = arguments.de_Observaciones> --->
                    <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>


                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                        method="listarOrdenesAsignadasaUsuarios"
                                        argumentcollection="#local.DatosOrdenes#"
                                        returnvariable="Local.Ordenes">

                    <!--- <cfloop query="local.Ordenes">
                        <cfset local.ConTotal += 1>
                        <cfif local.Autorizada EQ local.Ordenes.id_EstatusAutorizacionOrdenDeCompra>
                            <cfset local.ConAutorizadas += 1>
                        </cfif>
                    </cfloop>


                    <cfif local.ConTotal EQ local.ConAutorizadas>
                        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="EditarOrdenCompraGeneral"
                                    argumentcollection="#local.DatosOrdenes#">
                    </cfif> --->

                    <!--- Empieza el proceso de notificacion por correo al proveedor --->
                    <cfinvoke   component="#Application.RF.getPath('dao','ProveedoresContactos')#"
                                method="EmailContacto"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_OrdenCompra = "#local.DatosOrdenes.id_OrdenCompra#"
                                returnvariable="local.Email">

                    <cfset local.destinatariosPr = arrayNew(1)>
                    <cfloop query="local.Email">
                        <cfset arrayAppend(Local.destinatariosPr, local.Email.DE_EMAIL)>
                    </cfloop>

                    <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                        method="listarInsumosparaAutorizarOrdenCompra"
                        id_Empresa = "#session.ID_EMPRESA#"
                        id_Cotizacion= "#local.DatosOrdenes.id_Cotizacion#"
                        <!--- se agrego el parametro de id_ordencompra 23/10/2015 --->
                        id_ordencompra = "#local.DatosOrdenes.id_OrdenCompra#"
                        sn_Genero = "1"
                        returnvariable="local.Insumos">

                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                        method="listarInformacionOrdenCompra"
                        id_Empresa="#arguments.id_Empresa#"
                        id_Sucursal="#arguments.id_Sucursal#"
                        id_OrdenCompra ="#arguments.id_OrdenCompra#"
                        <!--- se agrego el parametro del usuario autorizador --->
                        id_usuario = "#session.ID_USUARIO#"
                        id_Cotizacion = "#local.DatosOrdenes.id_Cotizacion#"
                        returnvariable="local.InfoCompra">

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
                            id_OrdenCompra           = "#Arguments.id_OrdenCompra#"
                            id_EstatusAutorizacionOC = "#arguments.id_Estatus#"
                        >
                    </cfif>

                    <!---/**
                        * Si la OC fue generada por el proceso de carga masiva de facturas
                        * realiza en automatico la recepcion de servicios
                        */--->
                        <cfif local.InfoCompra.sn_ProcesoCMF EQ 1>
                        <cfinvoke component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                    method="RecepcionServiciosCMF"
                                    id_Empresa = "#arguments.id_Empresa#"
                                    id_OrdenCompra = "#local.DatosOrdenes.id_OrdenCompra#">
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
                            destinatarios="#Local.destinatariosPr#"
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
                </cfif>

                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            <cfelseif arguments.id_Estatus EQ 0> <!---Se Rechaza --->

                <!--- OC Rechazada --->
                    <cfset local.DatosOrdenes = structNew()>
                    <cfset local.ConRechazadas = 0>
                    <cfset local.DatosOrdenes.id_EstatusAutorizacionOrdenCompra = 3>
                    <cfset local.DatosOrdenes.id_Empresa = arguments.id_Empresa>
                    <cfset local.DatosOrdenes.id_Usuario = session.ID_USUARIO>
                    <cfset local.DatosOrdenes.id_Sucursal = arguments.id_Sucursal>
                    <cfset local.DatosOrdenes.de_Observaciones = arguments.de_observaciones>
                    <cfset local.DatosOrdenes.id_OrdenCompra = arguments.id_OrdenCompra>

                    <cfinvoke component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                        method="getById_UsuariosAutorizan"
                        id_Empresa="#arguments.id_Empresa#"
                        id_ordenDeCompra="#Arguments.id_OrdenCompra#"
                        returnvariable="local.Master"/>

                    <cfset sn_UsuariosAutorizan = 0>
                    <cfloop query="Local.Master"> <!---Puede haber mas de un usuario para autorizar --->
                        <cfset id_UsuarioAutorizaOC = Local.Master.id_UsuarioAutorizaOC>

                        <cfif id_UsuarioAutorizaOC EQ  arguments.id_Usuario >
                            <cfset sn_UsuariosAutorizan = 1>
                            <cfbreak>
                        </cfif>
                    </cfloop>
                    <cfif sn_UsuariosAutorizan EQ 0> <!---Si el usuario enviado no coincide, se bloquea la autorizacion --->
                        <cfset variables.RBR.setError('Usted no cuenta con permisos para RECHAZAR la OC.<br>Verifique su información.')>
                        <cfreturn variables.RBR>
                    </cfif>

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="Editar"
                                argumentcollection="#local.DatosOrdenes#">

                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesCompras')#"
                                method="listarOrdenesAsignadasaUsuarios"
                                    argumentcollection="#local.DatosOrdenes#"
                                    returnvariable="Local.Ordenes">

                    <!--- <cfset id_UsuarioAutorizaOC = Local.Master.id_UsuarioAutorizaOC>
                    <cfif id_UsuarioAutorizaOC NEQ  arguments.id_Usuario >
                        <cfset variables.RBR.setError('Usted no cuenta con permisos para RECHAZAR la OC. Verifique su información.')>
                        <cfreturn variables.RBR>
                    </cfif> --->
                    <!--- <cfdump var="#local.Ordenes#"> --->
                    <!--- <cfabort> --->
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

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            </cfif>
            <!--- Fin Autorizacion Orden De Compra --->
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="DatosCompra"        type="struct" required="true">
        <cfargument name="Insumos"            type="query"  required="true">
        <cfargument name="nb_Archivo"         type="string" required="false" default="">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Sucursal"        type="string" required="false"/>
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

</cfcomponent>
