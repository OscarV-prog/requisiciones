<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>


    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Empresa"             type="string"  required="false"/>
        <cfargument name="id_Requisicion"         type="string"  required="false"/>
        <cfargument name="fh_Inicio"              type="string"  required="false"/>
        <cfargument name="fh_Final"               type="string"  required="false"/>
        <cfargument name="id_EstatusAutorizacion" type="string"  required="false"/>
        <cfargument name="id_SucursalSolicita"    type="string"  required="false"/>
        <cfargument name="nu_Siniestro"           type="string"  required="false"/>
        <cfargument name="id_Empleado"            type="string"  required="false"/>
        <cfargument name="de_Requisicion"         type="string"  required="false"/>


    <!--- se obtiene el id del usuario de la session para listar solo las requisiones que esten asignadas al usuario logueado --->
        <cfset  arguments.id_UsuarioAutoriza = session.ID_USUARIO>

        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
            method="listar"
            argumentcollection="#arguments#"
            returnvariable="Local.Requisicion">

        <cfset variables.RBR.setQuery(Local.Requisicion)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="Editar"  access="public" returntype="Any">
        <cfargument name="Requisiciones" type="array" required="true"/>

        <cfif NOT variables.RBR.hasError()>

            <cfloop from="1" to="#arrayLen(arguments.Requisiciones)#" index="local.j">
        <cfif arguments.Requisiciones[local.j].Identificador EQ 'Autorizar'>
              <!--- <cfset local.Solicitadas = 0>
                    <cfset local.Rechazadas = 0>
                    <cfset local.Autorizadas = 0>
                    <cfset local.Total = 0> --->

                    <!--- PREGUNTAMOS SI EXISTE UN USUARIO DE UN NIVEL SUPERIOR--->
                    <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method             = "obtenerUsuarioAutorizaPorNivelRequisiciones"
                                id_Empresa         = '#arguments.Requisiciones[local.j].id_Empresa#'
                                id_Sucursal        = '#arguments.Requisiciones[local.j].id_SucursalSolicita#'
                                id_TipoDivision    = '#arguments.Requisiciones[local.j].id_TipoDivision#'
                                id_Nivel           = '#arguments.Requisiciones[local.j].id_Nivel#'
                                id_UsuarioAutoriza = '#arguments.Requisiciones[local.j].id_UsuarioAutoriza#'
                                returnvariable     = "Local.rs">

                    <!--- Si el resultado es igual a 1, el camino será preautorizar la Requisicion y e insertar un nuevo registro,
                     así como avisar por correo electronico al nuevo autorizador, Si el resultado es 0, seguirá el camino normal --->
                    <cfif Local.rs.Result EQ 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                    method="AgregarRequisicionesUsuarioAutorizaPorNivel"
                                    id_Empresa                    = '#arguments.Requisiciones[local.j].id_Empresa#'
                                    id_Sucursal                   = '#arguments.Requisiciones[local.j].id_SucursalSolicita#'
                                    id_TipoDivision               = '#arguments.Requisiciones[local.j].id_TipoDivision#'
                                    id_Nivel                      = '#arguments.Requisiciones[local.j].id_Nivel#'
                                    id_Requisicion                = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                    id_RequisicionUsuarioAutoriza = '#arguments.Requisiciones[local.j].id_RequisicionUsuarioAutoriza#'
                                    id_UsuarioAutoriza            = '#arguments.Requisiciones[local.j].id_UsuarioAutoriza#'
                                    fh_AsignacionEstatus          = '#arguments.Requisiciones[local.j].fh_RegistroRequisicion#'
                                    returnvariable="Local.rs">

                            <cfset Local.destinatarios = ArrayNew(1)>
                            <cfif #LEN(Local.rs.emailEmpleado)# GT 0>
                                <cfset ArrayAppend(Local.destinatarios, "#Local.rs.emailEmpleado#")>
                            </cfif>

                            <cfif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 1>
                            <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                        method="getRequisicionDetalleServicios"
                                        id_empresa="#arguments.Requisiciones[local.j].id_Empresa#"
                                        id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                        returnvariable="Local.insumos">

                            <cfelseif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 2>
                                <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                            method="getRequisicionDetalleAlmacenExistencia"
                                            id_empresa="#arguments.Requisiciones[local.j].id_Empresa#"
                                            id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                            returnvariable="Local.insumos">
                            </cfif>

                            <cfset local.ax = structNew()>
                            <cfset local.InsumosCompletos = ArrayNew(1)>
                            <cfloop query="Local.insumos">
                                <cfset local.ax.ID_INSUMO = #Local.insumos.ID_INSUMO#>
                                <cfset local.ax.ID_REQUISICION = #Local.insumos.ID_REQUISICION#>
                                <cfset local.ax.ID_EMPRESA = #Local.insumos.ID_EMPRESA#>
                                <cfset local.ax.NB_ALMACEN = '#Local.insumos.NB_ALMACEN#'>
                                <cfset local.ax.NB_NOMBREINSUMO = '#Local.insumos.NB_NOMBREINSUMO#'>
                                <cfset local.ax.NB_UNIDADMEDIDA = '#Local.insumos.NB_UNIDADMEDIDA#'>
                                <cfset local.ax.NU_CANTIDAD = #Local.insumos.NU_CANTIDAD#>
                                <cfset local.ax.NU_CANTIDADSURTIDA = #Local.insumos.NU_CANTIDADSURTIDA#>
                                <cfset local.ax.VALORESDETALLE = #Local.insumos.VALORESDETALLE#>

                <cfif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 2>
                  <cfset local.ax.ID_ALMACEN = #Local.insumos.ID_ALMACEN#>
                  <cfset local.ax.ID_SUCURSALSOLICITA = #Local.insumos.ID_SUCURSALSOLICITA#>
                  <cfinvoke     component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                      method="get_ExistenciasAlmacen"
                      id_empresa="#Local.insumos.ID_EMPRESA#"
                      id_sucursal="#Local.insumos.ID_SUCURSALSOLICITA#"
                      id_insumo="#Local.insumos.ID_INSUMO#"
                      id_almacen="#Local.insumos.ID_ALMACEN#"
                      returnvariable="nu_Existencias">
                      <cfset local.ax.NU_EXISTENCIA = #nu_Existencias.NU_EXISTENCIA#>

                  <cfset local.ax.NB_CENTROCOSTOFORMAT = #Local.insumos.NB_CENTROCOSTOFORMAT#>
                </cfif>

                                <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                                <cfset local.ax = structNew()>
                            </cfloop>

                            <!--- Nos vamos por los datos de la requisicion --->

                        <!---
                            Se elimino el envio de notificacion por peticion via correo de Procesos (Magda) el dia 03/07/2018

                        <cfinvoke component="#Application.RF.getPath('dao','AutReq')#"
                                  method="getRequisicion"
                                  argumentcollection="#arguments#"
                                  returnvariable="Local.requisicion">


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


                            <cfset Local.parametros={
                                de_mensaje = "Se autoriz&oacute; la siguiente requisici&oacute;n:",
                                nb_Empresa = arguments.Requisiciones[Local.j].NB_RAZONSOCIAL,
                                id_requisicion = arguments.Requisiciones[Local.j].ID_REQUISICION,
                                nb_sucursal = arguments.Requisiciones[Local.j].NB_SUCURSAL,
                                nb_departamento = arguments.Requisiciones[Local.j].NB_DEPARTAMENTO,
                                id_tipoRequisicion = arguments.Requisiciones[Local.j].ID_TIPOREQUISICION,
                                de_tipoRequisicion = arguments.Requisiciones[Local.j].DE_TIPOREQUISICION,
                                fh_registroRequisicion = arguments.Requisiciones[Local.j].FH_REGISTROREQUISICION,
                                sn_autorizado = "yes",
                                insumos = Local.InsumosCompletos
                            }/>

                            <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                        method="sendMail"
                                        destinatarios="#local.destinatarios#"
                                        asunto="Autorización de requisición"
                                        imagenes="#Local.imagenes#"
                                        parametros="#Local.parametros#"
                                        sn_plantilla="YES"
                                        dir_plantilla="templates/correos/Compras/templateMailAutorizacionRequisicion.html"
                                        returnvariable="Local.rbr"/>
                            </cfif>
                        --->
                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                    <!--- SI EL RESULTADO ES 0, SEGUIMOS CAMINO NORMAL--->
                    <cfelse>
                        <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                    method="EditarEstatusRequisicion"
                                    id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                    id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                    id_Usuario = '#session.ID_USUARIO#'
                                    id_Estatus = '3'>

                        <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                    method="getRequisicionesUsuario"
                                    id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                    id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                    returnvariable="local.Requisiciones">

                        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                        method="Editar"
                                        id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                        id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                        id_EstatusAutorizacion = '3'
                                        de_Observaciones = '#arguments.Requisiciones[local.j].de_Observaciones#'
                                        >

                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                                        method="getById"
                                        id_Empresa = "#arguments.Requisiciones[local.j].id_Empresa#"
                                        id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                        returnvariable="Tipo">

                        <!--- Al autorizar una orden de compra del tipo de servicio se crea la solicitud de compra de dicha requisicion --->
                            <cfif Tipo.id_TipoRequisicion EQ 1>
                                <cfinvoke component="#Application.RF.getPath('bro','SolicitudesCompra')#"
                                    method="crearSolicitudCompraRequisicion"
                                    id_Empresa="#arguments.Requisiciones[local.j].id_Empresa#"
                                    id_requisicion="#arguments.Requisiciones[local.j].id_Requisicion#">
                            </cfif>


                        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                                    method="getAlmacenistas"
                                    id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                    id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                    returnvariable="local.Almacenistas">

                        <cfset local.destinatarios = arrayNew(1)>
                        <cfset local.DatosCorreo = structNew()>

                        <cfloop query="local.Almacenistas">
                            <cfset local.destinatarios = arrayNew(1)>
                            <cfset local.DatosCorreo.nb_Almacen     = local.Almacenistas.nb_Almacen>
                            <cfset local.DatosCorreo.nb_Sucursal    = local.Almacenistas.nb_Sucursal>
                            <cfset local.DatosCorreo.nb_Empleado    = local.Almacenistas.nb_Empleado>
                            <cfset local.DatosCorreo.nb_Usuario     = session.NB_USUARIO>
                            <cfset local.DatosCorreo.fh_Fecha       = dateFormat(now(),'dd-mm-yyyy')>
                            <cfset local.DatosCorreo.id_Requisicion = arguments.Requisiciones[local.j].id_Requisicion>
                            <cfset local.DatosCorreo.nb_Empresa     = arguments.Requisiciones[Local.j].NB_RAZONSOCIAL>

                            <cfset arrayAppend(local.destinatarios, local.Almacenistas.de_Email)>

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
                        <cfif #ArrayLen(Local.destinatarios)# GT 0 >

                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                    method="sendMail"
                                    destinatarios="#Local.destinatarios#"
                                    asunto="Notificación Autorización de Requisición"
                                    imagenes="#Local.imagenes#"
                                    <!--- archivos="#Local.archivos#" --->
                                    parametros="#Local.DatosCorreo#"
                                    sn_plantilla="YES"
                                    dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailNotificacionAutorizacionRequisicion.html"
                                    returnvariable="Local.rbr"/>

                            <cfif Local.rbr.hasError()>
                                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                            </cfif>
                        </cfif>
                        </cfloop>

                        <!---
                            Modificación: Mario Mejia
                            Fecha:  01/06/2015
                            Comentario: Se agrego el envio de correo a la persona que realiza la Requisición, dicho
                                        correo le informa si la requisición fue autorizada o rechazada
                        --->
                        <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                                    method="getMailEmpleado"
                                    id_usuario="#arguments.Requisiciones[Local.j].ID_USUARIOSOLICITA#"
                                    returnvariable="Local.mailEmpleado">

                        <cfset Local.destinatarios = ArrayNew(1)>
                        <cfif #LEN(Local.mailEmpleado.DE_EMAIL)# GT 0>
                            <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>
                        </cfif>
                        <!--- <cfset ArrayAppend(Local.destinatarios, "vsanchez@redrabbit.mx")> --->

                        <!--- julio cesar acosta lopez 26/08/2015
                            e verifica de que tipo se la requisicion para saber que storeporcedure se mandara llamar --->
                            <!--- <cfdump var="#arguments.Requisiciones[Local.j].ID_REQUISICION#" /> --->

                            <!--- <cfabort /> --->

                        <cfif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 1>
                            <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                        method="getRequisicionDetalleServicios"
                                        id_empresa="#arguments.Requisiciones[local.j].id_Empresa#"
                                        id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                        returnvariable="Local.insumos">

                            <cfelseif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 2>
                                <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                            method="getRequisicionDetalleAlmacenExistencia"
                                            id_empresa="#arguments.Requisiciones[local.j].id_Empresa#"
                                            id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                            returnvariable="Local.insumos">
                            </cfif>

                            <cfset local.ax = structNew()>
                            <cfset local.InsumosCompletos = ArrayNew(1)>
                        <!---    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")> --->
                            <cfloop query="Local.insumos">
                                <cfset local.ax.ID_INSUMO = #Local.insumos.ID_INSUMO#>
                                <cfset local.ax.ID_REQUISICION = #Local.insumos.ID_REQUISICION#>
                                <cfset local.ax.ID_EMPRESA = #Local.insumos.ID_EMPRESA#>
                                <cfset local.ax.NB_ALMACEN = '#Local.insumos.NB_ALMACEN#'>
                                <cfset local.ax.NB_NOMBREINSUMO = '#Local.insumos.NB_NOMBREINSUMO#'>
                                <cfset local.ax.NB_UNIDADMEDIDA = '#Local.insumos.NB_UNIDADMEDIDA#'>
                                <cfset local.ax.NU_CANTIDAD = #Local.insumos.NU_CANTIDAD#>
                                <cfset local.ax.NU_CANTIDADSURTIDA = #Local.insumos.NU_CANTIDADSURTIDA#>
                                <cfset local.ax.VALORESDETALLE = #Local.insumos.VALORESDETALLE#>



                                    <cfif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 2>
                                        <cfset local.ax.ID_ALMACEN = #Local.insumos.ID_ALMACEN#>
                                        <cfset local.ax.ID_SUCURSALSOLICITA = #Local.insumos.ID_SUCURSALSOLICITA#>
                                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                                method="get_ExistenciasAlmacen"
                                                id_empresa="#Local.insumos.ID_EMPRESA#"
                                                id_sucursal="#Local.insumos.ID_SUCURSALSOLICITA#"
                                                id_insumo="#Local.insumos.ID_INSUMO#"
                                                id_almacen="#Local.insumos.ID_ALMACEN#"
                                                returnvariable="nu_Existencias">
                                                <cfset local.ax.NU_EXISTENCIA = #nu_Existencias.NU_EXISTENCIA#>

                                        <cfset local.ax.NB_CENTROCOSTOFORMAT = #Local.insumos.NB_CENTROCOSTOFORMAT#>
                                    </cfif>

                                <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                                <cfset local.ax = structNew()>
                            </cfloop>

                            <!---

                            Se elimino el envio de notificacion por peticion via correo de Procesos (Magda) el dia 03/07/2018

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


                            <cfset Local.parametros={
                                de_mensaje = "Se autoriz&oacute; la siguiente requisici&oacute;n:",
                                nb_Empresa  = arguments.Requisiciones[Local.j].NB_RAZONSOCIAL,
                                id_requisicion = arguments.Requisiciones[Local.j].ID_REQUISICION,
                                nb_sucursal = arguments.Requisiciones[Local.j].NB_SUCURSAL,
                                nb_departamento = arguments.Requisiciones[Local.j].NB_DEPARTAMENTO,
                                id_tipoRequisicion = arguments.Requisiciones[Local.j].ID_TIPOREQUISICION,
                                de_tipoRequisicion = arguments.Requisiciones[Local.j].DE_TIPOREQUISICION,
                                fh_registroRequisicion = arguments.Requisiciones[Local.j].FH_REGISTROREQUISICION,
                                sn_autorizado = "yes",
                                insumos = Local.InsumosCompletos
                            }/>

                            <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                        method="sendMail"
                                        destinatarios="#local.destinatarios#"
                                        asunto="Autorización de requisición"
                                        imagenes="#Local.imagenes#"
                                        parametros="#Local.parametros#"
                                        sn_plantilla="YES"
                                        dir_plantilla="templates/correos/Compras/templateMailAutorizacionRequisicion.html"
                                        returnvariable="Local.rbr"/>
                            </cfif>
                            --->
                            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                    </cfif>

                <cfelseif arguments.Requisiciones[local.j].Identificador EQ 'Rechazar'>

                    <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                method="EditarEstatusRequisicion"
                                id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                id_Usuario = '#session.ID_USUARIO#'
                                id_Estatus = '4'>

                    <!--- Modificacion Victor, se guarda el comentario de rechazado en RequisicionesUsuariosAutorizan --->
                    <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                method="EditarComentario"
                                id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                id_Usuario = '#session.ID_USUARIO#'
                                de_Comentario = '#arguments.Requisiciones[local.j].de_Observaciones#'>


                    <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                method="getRequisicionesUsuario"
                                id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                returnvariable="local.Requisiciones">

                    <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method="EditarStatus"
                                id_Empresa = '#arguments.Requisiciones[local.j].id_Empresa#'
                                id_Requisicion = '#arguments.Requisiciones[local.j].id_Requisicion#'
                                id_EstatusAutorizacion = '4'
                                >

                    <!---

                        Se elimino el envio de notificacion por peticion via correo de Procesos (Magda) el dia 03/07/2018

                    <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                                method="getMailEmpleado"
                                id_usuario="#arguments.Requisiciones[Local.j].ID_USUARIOSOLICITA#"
                                returnvariable="Local.mailEmpleado">


                    <cfset Local.destinatarios = ArrayNew(1)>
                    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>


                    <cfif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                    method="getRequisicionDetalleServicios"
                                    id_empresa="#session.ID_EMPRESA#"
                                    id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                    returnvariable="Local.insumos">

                    <cfelseif arguments.Requisiciones[local.j].ID_TIPOREQUISICION EQ 2>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                    method="getRequisicionDetalleAlmacenExistencia"
                                    id_empresa="#session.ID_EMPRESA#"
                                    id_requisicion="#arguments.Requisiciones[Local.j].ID_REQUISICION#"
                                    returnvariable="Local.insumos">
                    </cfif>


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

                    <cfset Local.parametros={
                        de_mensaje             = "Se rechaz&oacute; la siguiente requisici&oacute;n:",
                        nb_Empresa             = arguments.Requisiciones[Local.j].NB_RAZONSOCIAL,
                        id_requisicion         = arguments.Requisiciones[Local.j].ID_REQUISICION,
                        nb_sucursal            = arguments.Requisiciones[Local.j].NB_SUCURSAL,
                        nb_departamento        = arguments.Requisiciones[Local.j].NB_DEPARTAMENTO,
                        id_tipoRequisicion     = arguments.Requisiciones[Local.j].ID_TIPOREQUISICION,
                        de_tipoRequisicion     = arguments.Requisiciones[Local.j].DE_TIPOREQUISICION,
                        fh_registroRequisicion = arguments.Requisiciones[Local.j].FH_REGISTROREQUISICION,
                        de_Observaciones       = arguments.Requisiciones[Local.j].DE_OBSERVACIONES,
                        sn_autorizado = "no",
                        insumos = Local.insumos
                    }/>

                    <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                  method="sendMail"
                                  destinatarios="#local.destinatarios#"
                                  asunto="Rechazo de requisición"
                                  imagenes="#Local.imagenes#"
                                  parametros="#Local.parametros#"
                                  sn_plantilla="YES"
                                  dir_plantilla="templates/correos/Compras/templateMailRechazarRequisicion.html"
                                  returnvariable="Local.rbr"/>
                     </cfif>

                    --->

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                </cfif>
            </cfloop>
          <cfelse>
                 <cfset variables.RBR.setError('Ocurrio un error.')>
        </cfif>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EditardesdeDetalleRequisicion"  access="public" returntype="Any">
        <cfargument name="id_Empresa"                    type="numeric" required="true"/>
        <cfargument name="id_Requisicion"                type="numeric" required="true"/>
        <cfargument name="Identificador"                 type="string"  required="true"/>
        <cfargument name="de_Observaciones"              type="string"  required="false"/>
        <cfargument name="id_usuarioSolicita"            type="numeric" required="false"/>
        <cfargument name="id_tipoRequisicion"            type="numeric" required="false"/>
        <cfargument name="fh_registroRequisicion"        type="string"  required="false"/>
        <cfargument name="nb_empleado"                   type="string"  required="false"/>
        <cfargument name="nb_sucursal"                   type="string"  required="false"/>
        <cfargument name="nb_departamento"               type="string"  required="false"/>
        <cfargument name="fh_fechaRequerida"             type="string"  required="false"/>
        <cfargument name="de_tipoRequisicion"            type="string"  required="false"/>
        <cfargument name="id_RequisicionUsuarioAutoriza" type="string"  required="false"/>
        <cfargument name="id_SucursalSolicita"           type="string"  required="false"/>
        <cfargument name="id_TipoDivision"               type="string"  required="false"/>
        <cfargument name="id_Nivel"                      type="string"  required="false"/>
        <cfargument name="nb_RazonSocial"                type="string"  required="false"/>
        <cfargument name="DetalleRequisicion"            type="array"   required="false"/>
        <cfargument name="sn_OrdenDeTrabajo"             type="string"  required="false"/>
        <cfargument name="im_Total"                      type="string"  required="false"/>
        <cfargument name="id_GrupoCentroCosto"           type="string"  required="false"/>
        <cfargument name="id_CentroCosto"                type="string"  required="false"/>
        <cfargument name="nu_kilometraje"                type="string"  required="false"/>

        <cfset Local.fh_AsignacionEstatus= ""><!--- no se utiliza --->

         <cfset ff_Presupuestos = Application.RENV.getProperty('FF_PRESUPUESTOS')> <!--- si se utiliza --->
        <cfif NOT variables.RBR.hasError()>
            <cfif arguments.Identificador EQ 'Rechazar'>
                <cfset local.Borrador = 0>
                <cfset local.Rechazadas = 0>
                <cfset local.Autorizadas = 0>
                <cfset local.Total = 0>


                <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                    method                        = "EditarEstatusRequisicion"
                    id_Empresa                    = '#arguments.id_Empresa#'
                    id_Requisicion                = '#arguments.id_Requisicion#'
                    id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'
                    id_Usuario                    = '#session.ID_USUARIO#'
                    id_Estatus                    = '4'>

                <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                    method                        = "getRequisicionesUsuario"
                    id_Empresa                    = '#arguments.id_Empresa#'
                    id_Requisicion                = '#arguments.id_Requisicion#'
                    id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'
                    returnvariable                = "local.Requisiciones">

                <cfloop query="local.Requisiciones">
                        <cfset local.Total += 1>
                    <cfif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 1>
                        <cfset local.Borrador += 1>
                    <cfelseif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 4>
                        <cfset local.Rechazadas += 1>
                    <cfelseif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 3>
                        <cfset local.Autorizadas += 1>
                    </cfif>
                </cfloop>

                <cfif local.Borrador GT 0>
                    <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                        method                 = "Editar"
                        id_Empresa                    = '#arguments.id_Empresa#'
                        id_Requisicion                = '#arguments.id_Requisicion#'
                        id_EstatusAutorizacion        = '1'
                        de_Observaciones       = '#arguments.de_Observaciones#'>

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method="crearRequisicionesUsuariosAutorizanMovimientos"
                        id_Empresa                          = "#Arguments.id_Empresa#"
                        id_Requisicion                      = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                        id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                        id_EstatusAutorizacionRequisicion   = '1'
                        fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                        id_Usuario                          = "#session.ID_USUARIO#"
                        de_Comentarios                      = "#arguments.de_Observaciones#"
                        id_Nivel="#arguments.id_Nivel#"
                        fh_Autorizacion="">

                <cfelseif local.Rechazadas GT 0>
                    <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                        method                 = "EditarStatus"
                        id_Empresa             = '#arguments.id_Empresa#'
                        id_Requisicion         = '#arguments.id_Requisicion#'
                        id_EstatusAutorizacion = '4'
                        <!--- de_Observaciones = '#arguments.de_Observaciones#' --->
                        >

                    <!--- Modificacion Victor, se guarda el comentario de rechazado en RequisicionesUsuariosAutorizan --->
                    <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method                        = "EditarComentario"
                        id_Empresa                    = '#arguments.id_Empresa#'
                        id_Requisicion                = '#arguments.id_Requisicion#'
                        id_Usuario                    = '#session.ID_USUARIO#'
                        de_Comentario                 = '#arguments.de_Observaciones#'
                        id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'>

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method="crearRequisicionesUsuariosAutorizanMovimientos"
                        id_Empresa                          = "#Arguments.id_Empresa#"
                        id_Requisicion                      = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                        id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                        id_EstatusAutorizacionRequisicion   = '4'
                        fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                        id_Usuario                          = "#session.ID_USUARIO#"
                        de_Comentarios                      = "#arguments.de_Observaciones#"
                        id_Nivel="#arguments.id_Nivel#"
                        fh_Autorizacion="">

                <cfelse>
                    <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                        method="Editar"
                        id_Empresa                    = '#arguments.id_Empresa#'
                        id_Requisicion                = '#arguments.id_Requisicion#'
                        id_EstatusAutorizacion        = '3'
                        de_Observaciones              = '#arguments.de_Observaciones#'>


                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method="crearRequisicionesUsuariosAutorizanMovimientos"
                        id_Empresa                          = "#Arguments.id_Empresa#"
                        id_Requisicion                      = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                        id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                        id_EstatusAutorizacionRequisicion   = '3'
                        fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                        id_Usuario                          = "#session.ID_USUARIO#"
                        de_Comentarios                      = "#arguments.de_Observaciones#"
                        id_Nivel="#arguments.id_Nivel#"
                        fh_Autorizacion="">
                </cfif>

                    <!---
                            Modificación: Mario Mejia
                            Fecha: 01/06/2015
                            Comentario: Se agrego el envio de correo a la persona que realiza la Requisición, dicho
                                        correo le informa si la requisición fue autorizada o rechazada
                    --->
                    <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                                method="getMailEmpleado"
                                id_usuario="#arguments.ID_USUARIOSOLICITA#"
                                returnvariable="Local.mailEmpleado">

                    <cfset Local.destinatarios = ArrayNew(1)>
                    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>

                    <!--- julio cesar acosta lopez 26/08/2015
                        e verifica de que tipo se la requisicion para saber que storeporcedure se mandara llamar --->
                    <cfif arguments.ID_TIPOREQUISICION EQ 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                    method="getRequisicionDetalleServicios"
                                    id_empresa="#arguments.id_empresa#"
                                    id_requisicion="#arguments.ID_REQUISICION#"
                                    returnvariable="Local.insumos">

                    <cfelseif arguments.ID_TIPOREQUISICION EQ 2>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                    method="getRequisicionDetalleAlmacenExistencia"
                                    id_empresa="#arguments.id_empresa#"
                                    id_requisicion="#arguments.ID_REQUISICION#"
                                    returnvariable="Local.insumos">
                    </cfif>

                <cfset local.ax = structNew()>
                <cfset local.InsumosCompletos = ArrayNew(1)>
                    <!---    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")> --->
                <cfif arguments.ID_TIPOREQUISICION NEQ 3>
                    <cfloop query="Local.insumos">
                        <cfset local.ax.ID_INSUMO = #Local.insumos.ID_INSUMO#>
                        <cfset local.ax.ID_REQUISICION = #Local.insumos.ID_REQUISICION#>
                        <cfset local.ax.ID_EMPRESA = #Local.insumos.ID_EMPRESA#>
                        <cfset local.ax.NB_ALMACEN = '#Local.insumos.NB_ALMACEN#'>
                        <cfset local.ax.NB_NOMBREINSUMO = '#Local.insumos.NB_NOMBREINSUMO#'>
                        <cfset local.ax.NB_UNIDADMEDIDA = '#Local.insumos.NB_UNIDADMEDIDA#'>
                        <cfset local.ax.NU_CANTIDAD = #Local.insumos.NU_CANTIDAD#>
                        <cfset local.ax.NU_CANTIDADSURTIDA = #Local.insumos.NU_CANTIDADSURTIDA#>
                        <cfset local.ax.VALORESDETALLE = '#Local.insumos.VALORESDETALLE#'>

                            <cfif arguments.ID_TIPOREQUISICION EQ 2>
                                <cfset local.ax.ID_ALMACEN = #Local.insumos.ID_ALMACEN#>
                                <cfset local.ax.ID_SUCURSALSOLICITA = #Local.insumos.ID_SUCURSALSOLICITA#>
                                <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                        method         = "get_ExistenciasAlmacen"
                                        id_empresa     = "#Local.insumos.ID_EMPRESA#"
                                        id_sucursal    = "#Local.insumos.ID_SUCURSALSOLICITA#"
                                        id_insumo      = "#Local.insumos.ID_INSUMO#"
                                        id_almacen     = "#Local.insumos.ID_ALMACEN#"
                                        returnvariable = "nu_Existencias">
                                        <cfset local.ax.NU_EXISTENCIA = #nu_Existencias.NU_EXISTENCIA#>

                                <cfset local.ax.NB_CENTROCOSTOFORMAT = #Local.insumos.NB_CENTROCOSTOFORMAT#>
                            </cfif>

                        <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                        <cfset local.ax = structNew()>
                    </cfloop>
                </cfif>
                <!---
                    Se elimino el envio de notificacion por peticion via correo de Procesos (Magda) el dia 03/07/2018

                <cfinvoke   component="#Application.RF.getPath('dao','empresas')#"
                    method="InformacionEmpresa"
                    id_empresa="#arguments.id_empresa#"
                    returnvariable="Local.empresa">

                <cfset Local.imagenes=[
                    {
                        dir="#Local.empresa.ar_ImagenReporte#",
                        disposicion='inline',
                        name="logo"
                    },
                    {
                        dir="assets/img/greenLeaf.jpg",
                        disposicion='inline',
                        name="footer"
                    }
                ]>



                <cfset Local.parametros={
                    de_mensaje = "Se rechaz&oacute; la siguiente requisici&oacute;n:",
                    id_requisicion = arguments.ID_REQUISICION,
                    nb_Empresa = Local.empresa.nb_Empresa,
                    nb_sucursal = arguments.NB_SUCURSAL,
                    nb_departamento = arguments.NB_DEPARTAMENTO,
                    id_tipoRequisicion = arguments.ID_TIPOREQUISICION,
                    de_tipoRequisicion = arguments.DE_TIPOREQUISICION,
                    fh_registroRequisicion = arguments.FH_REGISTROREQUISICION,
                    sn_autorizado = "no",
                    insumos = Local.InsumosCompletos
                }/>


                <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                    <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#local.destinatarios#"
                                asunto="Rechazo de requisición"
                                imagenes="#Local.imagenes#"
                                parametros="#Local.parametros#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailAutorizacionRequisicion.html"
                                returnvariable="Local.rbr"/>
                </cfif>
                --->
                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

            <cfelseif arguments.Identificador EQ 'Autorizar'>

                <cfif arguments.DetalleRequisicion.len() GT 0>
                    <!--- Si se autoriza, actualizamos la informacion de la requisicion por los posibles cambios realizados --->
                    <cfinvoke component="#Application.RF.getPath('bro','DetalleRequisicion')#"
                        method="guardarCambios"
                        id_Empresa="#arguments.id_Empresa#"
                        id_Requisicion="#arguments.id_Requisicion#"
                        im_Total="#arguments.im_Total#"
                        Insumos="#arguments.DetalleRequisicion#"
                        returnvariable="Local.insumos">
                </cfif>

                <!--- Verificar si existe en tabla de Obras en Proceso para guardar la fh de autorizacion--->
                <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                        method="guardarFechaAutorizacion"
                        id_Empresa="#arguments.id_Empresa#"
                        id_Requisicion="#arguments.id_Requisicion#"
                        id_Usuario = "#arguments.id_usuarioSolicita#">

                <cfset local.Solicitadas = 0>
                <cfset local.Rechazadas  = 0>
                <cfset local.Autorizadas = 0>
                <cfset local.Total       = 0>
                <cfset local.id_Empleado = 0>

                <cfset  arguments.id_UsuarioAutoriza = session.ID_USUARIO>

                <!--- PREGUNTAMOS SI EXISTE UN USUARIO DE UN NIVEL SUPERIOR--->
                <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                    method             = "obtenerUsuarioAutorizaPorNivelRequisiciones"
                    id_Empresa         = '#arguments.id_Empresa#'
                    id_Sucursal        = '#arguments.id_SucursalSolicita#'
                    id_TipoDivision    = '#arguments.id_TipoDivision#'
                    id_Nivel           = '#arguments.id_Nivel#'
                    id_UsuarioAutoriza = '#arguments.id_UsuarioAutoriza#'
                    returnvariable     = "Local.UserAut">

                <!--- Si el resultado es igual o mayor a 1, el camino será preautorizar la Requisicion y se insertar un nuevo registro,
                    así como avisar por correo electronico al nuevo autorizador, Si el resultado es 0, seguirá el camino normal --->
                <cfif Local.UserAut.recordCount GT 0>

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method="crearRequisicionesUsuariosAutorizanMovimientos"
                        id_Empresa                          = "#Arguments.id_Empresa#"
                        id_Requisicion                      = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                        id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                        id_EstatusAutorizacionRequisicion   = '3'
                        fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                        id_Usuario                          = "#session.ID_USUARIO#"
                        de_Comentarios                      = "#arguments.de_Observaciones#"
                        id_Nivel                            = "#arguments.id_Nivel#"
                        fh_Autorizacion                     = "">

                    <cfset Local.destinatarios = ArrayNew(1)>
                    <cfloop query="#Local.UserAut#">
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                            method                        = "AgregarRequisicionesUsuarioAutorizaPorNivel"
                            id_Empresa                    = '#arguments.id_Empresa#'
                            id_Sucursal                   = '#arguments.id_SucursalSolicita#'
                            id_TipoDivision               = '#arguments.id_TipoDivision#'
                            id_Nivel                      = '#arguments.id_Nivel#'
                            id_Requisicion                = '#arguments.id_Requisicion#'
                            id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'
                            id_UsuarioAutoriza            = '#arguments.id_UsuarioAutoriza#'
                            fh_AsignacionEstatus          = '#arguments.fh_RegistroRequisicion#'
                            id_UsuarioSession             = "#session.ID_USUARIO#"
                            id_EmpleadoProxAut            = "#Local.UserAut.id_Empleado#"
                            returnvariable                = "Local.rs">

                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                            method="RequisicionesEviarCorreo"
                            id_Empresa      = '#arguments.id_Empresa#'
                            id_Sucursal     = '#arguments.id_SucursalSolicita#'
                            id_tipoDivision = '#arguments.id_TipoDivision#'
                            id_Empleado     = '#Local.UserAut.id_Empleado#'
                            returnvariable="Local.rss">

                        <cfif Local.rss.sn_EviarCorreo EQ 1>
                            <cfset ArrayAppend(Local.destinatarios, "#Local.rs.emailEmpleado#")>
                        </cfif>
                        <!--- <cfset Local.destinatarios = ArrayNew(1)>
                        <cfif #LEN(Local.rs.emailEmpleado)# GT 0>
                            <cfset ArrayAppend(Local.destinatarios, "#Local.rs.emailEmpleado#")>
                        </cfif> --->
                    </cfloop>

                    <cfif arguments.ID_TIPOREQUISICION EQ 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                            method         = "getRequisicionDetalleServicios"
                            id_empresa     = "#arguments.id_Empresa#"
                            id_requisicion = "#arguments.ID_REQUISICION#"
                            returnvariable = "Local.insumos">

                    <cfelseif arguments.ID_TIPOREQUISICION EQ 2>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                            method         = "getRequisicionDetalleAlmacenExistencia"
                            id_empresa     = "#arguments.id_Empresa#"
                            id_requisicion = "#arguments.ID_REQUISICION#"
                            returnvariable = "Local.insumos">
                    </cfif>

                    <!--- Recuperamos la bandera de presupuesto por la sucursal --->
                    <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method         = "getBanderaPresupuestoSucursal"
                            id_Empresa     = "#arguments.id_Empresa#"
                            id_Sucursal    = "#arguments.id_SucursalSolicita#"
                            returnvariable = "local.sucursal_bandera">

                    <!--- Validacion de disponibilidad de presupuesto --->
                    <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>

                        <!--- Formateamos un json para validar todos los insumos a la vez --->
                        <cfset local.JSON_Insumos = "[">
                        <cfloop query="Local.insumos">
                            <cfset local.JSON_Insumos = local.JSON_Insumos & '{
                                "id_Insumo": "#Local.insumos.id_Insumo#",
                                "id_CuentaPresupuesto": "#Local.insumos.id_CuentaPresupuesto#",
                                "im_TotalInsumo": "#Local.insumos.im_TotalInsumo#"
                            },'>
                        </cfloop>
                        <cfset local.JSON_Insumos = left(local.JSON_Insumos, len(local.JSON_Insumos)-1) & "]">

                        <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method="getPresupuestoDisponible"
                            id_Empresa="#arguments.id_empresa#"
                            id_CargaPresupuesto="#local.insumos.ID_CARGAPRESUPUESTO#"
                            id_Requisicion="#arguments.id_Requisicion#"
                            json_Insumos="#local.JSON_Insumos#"
                            returnVariable="local.ResInsumo">


                        <cfset local.jsonres = "">
                        <!--- Validamos el presupuesto disponible --->
                        <cfloop query="local.ResInsumo">
                            <!--- Si no hay presupuesto disponible concatenamos el detalle del error --->
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
                                    "sn_Autorizacion": 0
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
                    
                    <cfset local.ax = structNew()>
                    <cfset local.InsumosCompletos = ArrayNew(1)>
                    <cfloop query="Local.insumos">
                        <cfset local.ax.ID_INSUMO          = #Local.insumos.ID_INSUMO#>
                        <cfset local.ax.ID_REQUISICION     = #Local.insumos.ID_REQUISICION#>
                        <cfset local.ax.ID_EMPRESA         = #Local.insumos.ID_EMPRESA#>
                        <cfset local.ax.NB_ALMACEN         = '#Local.insumos.NB_ALMACEN#'>
                        <cfset local.ax.NB_NOMBREINSUMO    = '#Local.insumos.NB_NOMBREINSUMO#'>
                        <cfset local.ax.NB_UNIDADMEDIDA    = '#Local.insumos.NB_UNIDADMEDIDA#'>
                        <cfset local.ax.NU_CANTIDAD        = #Local.insumos.NU_CANTIDAD#>
                        <cfset local.ax.NU_CANTIDADSURTIDA = #Local.insumos.NU_CANTIDADSURTIDA#>
                        <cfset local.ax.VALORESDETALLE     = #Local.insumos.VALORESDETALLE#>

                        <cfif arguments.ID_TIPOREQUISICION EQ 2>
                            <cfset local.ax.ID_ALMACEN = #Local.insumos.ID_ALMACEN#>
                            <cfset local.ax.ID_SUCURSALSOLICITA = #Local.insumos.ID_SUCURSALSOLICITA#>
                            <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method         = "get_ExistenciasAlmacen"
                                id_empresa     = "#Local.insumos.ID_EMPRESA#"
                                id_sucursal    = "#Local.insumos.ID_SUCURSALSOLICITA#"
                                id_insumo      = "#Local.insumos.ID_INSUMO#"
                                id_almacen     = "#Local.insumos.ID_ALMACEN#"
                                returnvariable = "nu_Existencias">

                            <cfset local.ax.NU_EXISTENCIA = #nu_Existencias.NU_EXISTENCIA#>
                            <cfset local.ax.NB_CENTROCOSTOFORMAT = #Local.insumos.NB_CENTROCOSTOFORMAT#>
                        </cfif>
                        <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                        <cfset local.ax = structNew()>
                    </cfloop>

                    <cfinvoke   component="#Application.RF.getPath('dao','empresas')#"
                        method="InformacionEmpresa"
                        id_empresa="#arguments.id_empresa#"
                        returnvariable="Local.empresa">

                    <cfset Local.imagenes=[
                        {
                            dir="#Local.empresa.ar_ImagenReporte#",
                            disposicion='inline',
                            name="logo"
                        },
                        {
                            dir="assets/img/greenLeaf.jpg",
                            disposicion='inline',
                            name="footer"
                        }
                    ]>


                    <cfset Local.parametros={
                        de_mensaje             = "Se autoriz&oacute; la siguiente requisici&oacute;n:",
                        nb_Empresa             = arguments.NB_RAZONSOCIAL,
                        id_requisicion         = arguments.ID_REQUISICION,
                        nb_sucursal            = arguments.NB_SUCURSAL,
                        nb_departamento        = arguments.NB_DEPARTAMENTO,
                        id_tipoRequisicion     = arguments.ID_TIPOREQUISICION,
                        de_tipoRequisicion     = arguments.DE_TIPOREQUISICION,
                        fh_registroRequisicion = arguments.FH_REGISTROREQUISICION,
                        sn_autorizado          = "yes",
                        insumos                = Local.InsumosCompletos
                    }/>

                    <!--- <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method         = "sendMail"
                                destinatarios  = "#local.destinatarios#"
                                asunto         = "Autorización de requisición"
                                imagenes       = "#Local.imagenes#"
                                parametros     = "#Local.parametros#"
                                sn_plantilla   = "YES"
                                dir_plantilla  = "templates/correos/Compras/templateMailAutorizacionRequisicion.html"
                                returnvariable = "Local.rbr"/>
                    </cfif>
                    --->

                    <!--- ENVIAR CORREO PARA SOLICITAR LA AUTORIZACION
                        Nos traemos los datos de la requisicion --->
                    <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                        method="getById"
                        id_empresa="#session.ID_EMPRESA#"
                        id_requisicion="#Arguments.id_requisicion#"
                        returnvariable="Local.requisicion">

                    <cfif Local.requisicion.im_PrecioTotal EQ ''>
                        <cfset Local.im_totalRequisicion=0>
                    <cfelse>
                        <cfset Local.im_totalRequisicion=Local.requisicion.im_PrecioTotal>
                    </cfif>

                    <!--- Nos traemos el detalle de la requisicion --->
                    <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                        method="getByIdRequisicion"
                        id_empresa="#session.ID_EMPRESA#"
                        id_requisicion="#Arguments.id_requisicion#"
                        returnvariable="Local.detalleRequisicion">

                    <!--- <cfset crearReporte(Local.requisicion,Local.detalleRequisicion,1,Local.empresa.ar_ImagenReporte)> --->

                    <cfloop query="#Local.UserAut#">
                        <!--- <cfset Local.archivos=[{
                            dir="reportes/requisicion#Local.requisicion.id_requisicion#.pdf",
                            name='reporte',
                            sn_deleteFile= "yes"
                        }]>

                        <cfset var Local.tipo=Local.requisicion.id_TipoRequisicion EQ 1?'Servicios':'Materiales'>

                        <cfset theURLBase = "http://">
                        <cfif CGI.HTTPS EQ "on">
                            <cfset theURLBase = 'https://' />
                        </cfif> --->

                        <!---
                            Se mandaran los datos del autorizador para saber si se enviara correo o no
                            <cfdump var="#Local.rss.sn_EviarCorreo#"> <cfabort>
                        --->
                        <!--- <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                            method="RequisicionesEviarCorreo"
                            id_Empresa      = '#arguments.id_Empresa#'
                            id_Sucursal     = '#arguments.id_SucursalSolicita#'
                            id_tipoDivision = '#arguments.id_TipoDivision#'
                            id_Empleado     = '#Local.UserAut.id_Empleado#'
                            returnvariable="Local.rss"> --->
                    </cfloop>

                    <cfif arrayLen(Local.destinatarios) GT 0>
                        <cfinvoke
                            method="crearReporte"
                            requisicion="#Local.requisicion#"
                            requisicionDetalle="#Local.detalleRequisicion#"
                            estatus="#Local.requisicion.id_EstatusAutorizacion#"
                            returnvariable="rbrREPORTE">

                        <cfif rbrREPORTE.hasError()>
                            <cfset errorMessage = "Error al generar el reporte " & rbrReporte.getMessage() />
                            <cfthrow type="warning" message="#errorMessage#">
                        </cfif>

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

                        <cfset Local.archivos=[{
                            dir="Reportes/requisicion#Local.requisicion.id_requisicion#.pdf",
                            name='reporte',
                            sn_deleteFile= "yes"
                        }]>

                        <cfset var Local.tipo=Local.requisicion.id_TipoRequisicion EQ 1?'Servicios':'Materiales'>

                        <cfset theURLBase = "http://">
                        <cfif CGI.HTTPS EQ "on">
                            <cfset theURLBase = 'https://' />
                        </cfif>


                        <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            destinatarios="#Local.destinatarios#"
                            asunto="Solicitud de Requisicion de #Local.tipo#"
                            imagenes="#Local.imagenes#"
                            archivos="#Local.archivos#"
                            parametros="#Local.requisicion#"
                            estatus="1"
                            webPath="#Local.webPath#"
                            id_UsuarioAutoriza="#Local.rs.id_usuario#"
                            sn_plantilla="YES"
                            dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailRequisicion.html"
                            returnvariable="Local.RBR"/>
                    </cfif>

                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                <cfelse>
                    <!--- SI EL RESULTADO ES 0, SEGUIMOS CAMINO NORMAL--->
                    <!--- Si la solicitud es de servicios, automaticamente al autorizar se crea la solicitud
                        de compra  --->

                    <!--- Si es una orden de trabajo, actualizamos el kilometrajo de la unidad --->
                    <cfif arguments.sn_OrdenDeTrabajo EQ 1>
                        <cfif arguments.id_tipoRequisicion NEQ 3>
                            <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                method="ActualizarKilometrajeCentrosCostos"
                                id_Empresa="#arguments.id_Empresa#"
                                id_grupoCentroCosto="#arguments.DetalleRequisicion[1].ID_GRUPOCENTROCOSTO#"
                                id_centroCosto="#arguments.DetalleRequisicion[1].ID_CENTROCOSTO#"
                                nu_Kilometraje="#arguments.DetalleRequisicion[1].NU_KILOMETRAJE#">
                        <cfelse>
                            <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                method="ActualizarKilometrajeCentrosCostos"
                                id_Empresa="#arguments.id_Empresa#"
                                id_grupoCentroCosto="#arguments.id_GrupoCentroCosto#"
                                id_centroCosto="#arguments.id_CentroCosto#"
                                nu_Kilometraje="#arguments.nu_Kilometraje#">

                        </cfif>
                    </cfif>

                    <cfinvoke 
                        component="#Application.RF.getPath('dao','ConfiguracionAlmacenesSinInventario')#"
                        method             = "existeConfiguracion"
                        id_Empresa         = "#arguments.id_Empresa#"
                        id_Sucursal        = "#arguments.id_SucursalSolicita#"
                        id_TipoDivision    = "#arguments.id_TipoDivision#"
                        sn_Activo          = "#1#"
                        returnvariable     = "Local.Configuracion">

                    <!--- Servicios --->
                    <cfif arguments.id_tipoRequisicion EQ 1>
                        <cfinvoke component="#Application.RF.getPath('bro','SolicitudesCompra')#"
                            method         = "crearSolicitudCompraRequisicion"
                            id_Empresa     = "#arguments.id_Empresa#"
                            id_requisicion = "#arguments.id_Requisicion#"
                            returnvariable="local.sc">

                            <cfif local.sc.hasError()>
                                <cfthrow type="warning" message="#local.sc.getMessage()#">
                            </cfif>
                        <!--- Configuracion Almacen sin inventario --->
                        <cfelseif Local.Configuracion.SN_ESTATUS EQ 1>
                            <cfinvoke component="#Application.RF.getPath('bro','SolicitudesCompra')#"
                            method         = "crearSolicitudCompraRequisicion"
                            id_Empresa     = "#arguments.id_Empresa#"
                            id_requisicion = "#arguments.id_Requisicion#"
                            configuracion_almacen = "#1#"
                            returnvariable="local.sc">

                        <cfif local.sc.hasError()>
                            <cfthrow type="warning" message="#local.sc.getMessage()#">
                        </cfif>
                    </cfif>


                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method                        = "EditarEstatusRequisicion"
                        id_Empresa                    = '#arguments.id_Empresa#'
                        id_Requisicion                = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'
                        id_Usuario                    = '#session.ID_USUARIO#'
                        id_Estatus                    = '3'>

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                        method                        = "getRequisicionesUsuario"
                        id_Empresa                    = '#arguments.id_Empresa#'
                        id_Requisicion                = '#arguments.id_Requisicion#'
                        id_RequisicionUsuarioAutoriza = '#arguments.id_RequisicionUsuarioAutoriza#'
                        returnvariable                = "local.Requisiciones">

                    <cfloop query="local.Requisiciones">
                        <cfset local.Total += 1>
                        <cfif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 2>
                            <cfset local.Solicitadas += 1>
                        <cfelseif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 4>
                            <cfset local.Rechazadas += 1>
                        <cfelseif local.Requisiciones.ID_ESTATUSAUTORIZACIONREQUISICION EQ 3>
                            <cfset local.Autorizadas += 1>
                        </cfif>
                    </cfloop>

                    <cfif local.Solicitadas GT 0>
                        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                            method="Editar"
                            id_Empresa                    = '#arguments.id_Empresa#'
                            id_Requisicion                = '#arguments.id_Requisicion#'
                            id_EstatusAutorizacion        = '2'
                            de_Observaciones              = '#arguments.de_Observaciones#'>

                        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="crearRequisicionesUsuariosAutorizanMovimientos"
                            id_Empresa                          = "#Arguments.id_Empresa#"
                            id_Requisicion                      = '#arguments.id_Requisicion#'
                            id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                            id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                            id_EstatusAutorizacionRequisicion   = '2'
                            fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                            id_Usuario                          = "#session.ID_USUARIO#"
                            de_Comentarios                      = "#arguments.de_Observaciones#"
                            id_Nivel="#arguments.id_Nivel#"
                            fh_Autorizacion="">

                        <cfelseif local.Rechazadas GT 0>
                            <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method                 = "EditarStatus"
                                id_Empresa             = '#arguments.id_Empresa#'
                                id_Requisicion         = '#arguments.id_Requisicion#'
                                id_EstatusAutorizacion = '4'
                                >

                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                method="crearRequisicionesUsuariosAutorizanMovimientos"
                                id_Empresa                          = "#Arguments.id_Empresa#"
                                id_Requisicion                      = '#arguments.id_Requisicion#'
                                id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                                id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                                id_EstatusAutorizacionRequisicion   = '4'
                                fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                                id_Usuario                          = "#session.ID_USUARIO#"
                                de_Comentarios                      = "#arguments.de_Observaciones#"
                                id_Nivel="#arguments.id_Nivel#"
                                fh_Autorizacion="">
                        <cfelse>
                            <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method="Editar"
                                id_Empresa                    = '#arguments.id_Empresa#'
                                id_Requisicion                = '#arguments.id_Requisicion#'
                                id_EstatusAutorizacion        = '3'
                                de_Observaciones              = '#arguments.de_Observaciones#'>


                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                                method="crearRequisicionesUsuariosAutorizanMovimientos"
                                id_Empresa                          = "#Arguments.id_Empresa#"
                                id_Requisicion                      = '#arguments.id_Requisicion#'
                                id_RequisicionUsuarioAutoriza       = "#arguments.id_RequisicionUsuarioAutoriza#"
                                id_UsuarioAutoriza                  = "#session.ID_USUARIO#"
                                id_EstatusAutorizacionRequisicion   = '3'
                                fh_AsignacionEstatus                = "#Local.fh_AsignacionEstatus#"
                                id_Usuario                          = "#session.ID_USUARIO#"
                                de_Comentarios                      = "#arguments.de_Observaciones#"
                                id_Nivel="#arguments.id_Nivel#"
                                fh_Autorizacion="">
                    </cfif>

                    <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                        method="getAlmacenistas"
                        id_Empresa = '#arguments.id_Empresa#'
                        id_Requisicion = '#arguments.id_Requisicion#'
                        returnvariable="local.Almacenistas">

                    <cfset local.destinatarios = arrayNew(1)>
                    <cfset local.DatosCorreo = structNew()>

                    <cfloop query="local.Almacenistas">
                        <cfinvoke   component="#Application.RF.getPath('dao','empresas')#"
                            method="InformacionEmpresa"
                            id_empresa="#arguments.id_empresa#"
                            returnvariable="Local.empresa">

                        <cfset local.DatosCorreo.nb_Almacen     = local.Almacenistas.nb_Almacen>
                        <cfset local.DatosCorreo.nb_Sucursal    = local.Almacenistas.nb_Sucursal>
                        <cfset local.DatosCorreo.nb_Empleado    = local.Almacenistas.nb_Empleado>
                        <cfset local.DatosCorreo.nb_Usuario     = session.NB_USUARIO>
                        <cfset local.DatosCorreo.fh_Fecha       = dateFormat(now(),'dd-mm-yyyy')>
                        <cfset local.DatosCorreo.id_Requisicion = arguments.id_Requisicion>
                        <cfset local.DatosCorreo.nb_Empresa     = Local.empresa.nb_Empresa>

                        <cfset arrayAppend(local.destinatarios, local.Almacenistas.de_Email)>

                        <!--- <cfset Local.archivos=[{
                            dir="Reportes/NotificacionInventarioFisico.pdf",
                            name='reporte',
                            sn_deleteFile= "yes"
                        }]> --->

                        <!---
                        <cfset Local.imagenes=[
                            {
                                dir="#Local.empresa.ar_ImagenReporte#",
                                disposicion='inline',
                                name="logo"
                            },
                            {
                                dir="assets/img/greenLeaf.jpg",
                                disposicion='inline',
                                name="footer"
                            }
                                        ]>


                            Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018
                        <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                        method         = "sendMail"
                                        destinatarios  = "#Local.destinatarios#"
                                        asunto         = "Notificación Autorización de Requisición"
                                        imagenes       = "#Local.imagenes#"
                                        parametros     = "#Local.DatosCorreo#"
                                        sn_plantilla   = "YES"
                                        dir_plantilla  = "templates/correos/AlmacenesEInventarios/templateMailNotificacionAutorizacionRequisicion.html"
                                        returnvariable = "Local.rbr"/>

                            <cfif Local.rbr.hasError()>
                                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                            </cfif>
                        </cfif>
                        --->
                    </cfloop>

                     <!---ENVIO DE CORREO A CONTADORES --->

                     
                    <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                            method="getListado"
                            id_Empresa = "#arguments.id_Empresa#"
                            id_Requisicion = "#arguments.id_Requisicion#"
                            id_Usuario="#arguments.id_usuarioSolicita#"
                            returnvariable="RsDetalle">


                    <cfif RsDetalle.RecordCount GT 0>
                        <cfif RsDetalle.id_TipoInstalacion EQ 1>
                            <cfset correo = structNew()>
                            <cfset correo.destinatarios = arrayNew(1)>

                            <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                                method="getContadores"
                                returnvariable="RScorreo">

                            <cfset arrayAppend(correo.destinatarios, RScorreo.Emails)>

                            <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                                    method="getDetallesInsumos"
                                        id_Empresa = "#arguments.id_Empresa#"
                                        id_Requisicion = "#arguments.id_Requisicion#"
                                    returnvariable="Local.Detalle">

                            <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                                method="upR_EmpresaById"
                                id_Empresa="#arguments.id_Empresa#"
                                returnvariable="Local.Empresa">


                            <cfset correo.asunto = 'Notificación de Seguimiento de Obras en Proceso.'>
                            <cfset correo.sn_plantilla = "true">
                            <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailAutorizacionObrasProceso.html">
                            <cfset correo.parametros = structNew()>
                            <cfset correo.parametros.asunto = 'Notificación de Seguimiento de Obras en Proceso.'>
                            <cfset correo.parametros.Folio = '#RsDetalle.id_Requisicion#'>
                            <cfset correo.parametros.Empleado = '#RsDetalle.nb_Empleado#'>
                            <cfset correo.parametros.fhCreacion = '#RsDetalle.fh_RegistroFormat#'>
                            <cfset correo.parametros.EmpleadoAutoriza = '#RsDetalle.nb_EmpleadoAutoriza#'>
                            <cfset correo.parametros.fhAutorizacion = '#RsDetalle.fh_AutorizacionFormat#'>
                            <cfset correo.parametros.Empresa = '#RsDetalle.nb_Empresa#'>
                            <cfset correo.parametros.Sucursal = '#RsDetalle.nb_Sucursal#'>
                            <cfset correo.parametros.Importe = '#RsDetalle.im_CostoTotal#'>
                            <cfset correo.parametros.Comentarios = '#RsDetalle.de_ComentariosFinaliza#'>
                            <cfset correo.parametros.GCC = '#RsDetalle.nb_GrupoCentroCosto#'>
                            <cfset correo.parametros.dataObra = "#Local.Detalle#">

                            <cfset storageUrl = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/">

                                
                            <cfset correo.imagenes = [
                                    {
                                        dir="#storageUrl##Local.Empresa.ar_ImagenReporte#",
                                        disposicion='inline',
                                        name="logo"
                                    },
                                    {
                                        dir="assets/img/greenLeaf.jpg",
                                        disposicion='inline',
                                        name="footer",
                                        isLocal=true
                                    }
                                ]>



                                <cfif LEN(RScorreo.Emails) GT 0>
                                    <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                                method="sendMail"
                                                argumentcollection="#correo#"
                                                returnvariable="Local.rbr"/>
                                <cfelse>
                                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                                </cfif>
                        </cfif>
                    </cfif>

                    <!---
                        Modificación: Mario Mejia
                        Fecha: 01/06/2015
                        Comentario: Se agrego el envio de correo a la persona que realiza la Requisición, dicho
                                    correo le informa si la requisición fue autorizada o rechazada
                    --->
                    <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                        method         = "getMailEmpleado"
                        id_usuario     = "#arguments.ID_USUARIOSOLICITA#"
                        returnvariable = "Local.mailEmpleado">

                    <cfset Local.destinatarios = ArrayNew(1)>
                    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>

                    <!--- julio cesar acosta lopez 26/08/2015
                        e verifica de que tipo se la requisicion para saber que storeporcedure se mandara llamar --->
                    <cfif arguments.ID_TIPOREQUISICION EQ 1>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                            method         = "getRequisicionDetalleServicios"
                            id_empresa     = "#arguments.id_empresa#"
                            id_requisicion = "#arguments.ID_REQUISICION#"
                            returnvariable = "Local.insumos">

                    <cfelseif arguments.ID_TIPOREQUISICION EQ 2>
                        <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                method         = "getRequisicionDetalleAlmacenExistencia"
                                id_empresa     = "#arguments.id_empresa#"
                                id_requisicion = "#arguments.ID_REQUISICION#"
                                returnvariable = "Local.insumos">
                    </cfif>
                    
                    <!--- Application.RENV.getProperty('FF_PRESUPUESTOS') --->
                    <!--- Si se encuentra activado presupuestos se registra la cabecera --->
                    <!--- revisamos presupuesto para abastecedoras --->

                    <!--- Recuperamos la bandera de presupuesto por la sucursal --->
                    <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method         = "getBanderaPresupuestoSucursal"
                            id_Empresa     = "#arguments.id_Empresa#"
                            id_Sucursal    = "#arguments.id_SucursalSolicita#"
                            returnvariable = "local.sucursal_bandera">
                    
                    <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
                        <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method="agregarConsumoPresupuestoEncabezado"
                            id_Empresa="#arguments.id_Empresa#"
                            id_Sucursal="#arguments.id_SucursalSolicita#"
                            id_CargaPresupuesto="#Local.insumos.ID_CARGAPRESUPUESTO#"
                            im_TotalProvisionado="#Local.insumos.IM_PRECIOTOTAL#"
                            im_TotalEjercido="0"
                            id_Requisicion="#arguments.id_Requisicion#"
                            id_SolicitudDeViaje=""
                            id_ComprobacionDeGasto=""
                            id_Estatus="2909" 
                            id_UsuarioProvision="#arguments.id_UsuarioSolicita#"
                            id_UsuarioEjercido=""
                            returnvariable="Local.ConsumoCabecera">

                        <!--- Formateamos un json para validar todos los insumos a la vez --->
                        <cfset local.JSON_Insumos = "[">
                        <cfloop query="Local.insumos">
                            <cfset local.JSON_Insumos = local.JSON_Insumos & '{
                                "id_Insumo": "#Local.insumos.id_Insumo#",
                                "id_CuentaPresupuesto": "#Local.insumos.id_CuentaPresupuesto#",
                                "im_TotalInsumo": "#Local.insumos.im_TotalInsumo#"
                            },'>
                        </cfloop>
                        <cfset local.JSON_Insumos = left(local.JSON_Insumos, len(local.JSON_Insumos)-1) & "]">

                        <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method="getPresupuestoDisponible"
                            id_Empresa="#arguments.id_empresa#"
                            id_CargaPresupuesto="#local.insumos.ID_CARGAPRESUPUESTO#"
                            id_Requisicion="#arguments.id_Requisicion#"
                            json_Insumos="#local.JSON_Insumos#"
                            returnVariable="local.ResInsumo">

                        <cfset local.jsonres = "">
                        <!--- Validamos el presupuesto disponible --->
                        <cfloop query="local.ResInsumo">
                            <!--- Si no hay presupuesto disponible concatenamos el detalle del error --->
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

                        <!--- Si jsonres no está vacío retornamos error --->
                        <cfif len(local.jsonres) GT 0>
                            <cfset local.jsonres = "sn_PresupuestoFaltante<>[" & left(local.jsonres, len(local.jsonres)-1) & "]">
                            <cfset variables.RBR.setError(local.jsonres)>
                            <cfreturn variables.RBR>
                        </cfif>

                    </cfif>
                        

                    <cfif arguments.id_tipoRequisicion NEQ 3>
                        <cfset local.ax = structNew()>
                        <cfset local.InsumosCompletos = ArrayNew(1)>
                        <!---    <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")> --->
                        <cfloop query="Local.insumos">

                        <!--- Si se encuentra activado presupuestos se registran los detalles --->
                            <!--- revisamos presupuesto para abastecedoras --->
                            <cfif ff_Presupuestos EQ 1 AND local.sucursal_bandera.sn_Presupuestos EQ 1>
                                <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                                    method="agregarConsumoPresupuestoDetalle"
                                    id_Empresa="#Local.insumos.ID_EMPRESA#"
                                    id_ConsumoPresupuesto="#Local.ConsumoCabecera.ID_CONSUMOPRESUPUESTO#"
                                    id_CargaPresupuesto="#Local.insumos.ID_CARGAPRESUPUESTO#"
                                    id_CuentaPresupuesto="#Local.insumos.ID_CUENTAPRESUPUESTO#"
                                    id_Insumo="#Local.insumos.ID_INSUMO#"
                                    id_ConceptoDeViaje=""
                                    id_TipoImporteExtra=""
                                    im_TotalProvisionado="#Local.insumos.IM_TOTALINSUMO#"
                                    im_TotalEjercido="0"
                                    id_Estatus="2909" 
                                    returnvariable="local.ResDetalles">
    
                                <cfset variables.RBR.setQuery(local.ResDetalles)>
                            </cfif>
    
                            <cfset local.ax.ID_INSUMO          = #Local.insumos.ID_INSUMO#>
                            <cfset local.ax.ID_REQUISICION     = #Local.insumos.ID_REQUISICION#>
                            <cfset local.ax.ID_EMPRESA         = #Local.insumos.ID_EMPRESA#>
                            <cfset local.ax.NB_ALMACEN         = '#Local.insumos.NB_ALMACEN#'>
                            <cfset local.ax.NB_NOMBREINSUMO    = '#Local.insumos.NB_NOMBREINSUMO#'>
                            <cfset local.ax.NB_UNIDADMEDIDA    = '#Local.insumos.NB_UNIDADMEDIDA#'>
                            <cfset local.ax.NU_CANTIDAD        = #Local.insumos.NU_CANTIDAD#>
                            <cfset local.ax.NU_CANTIDADSURTIDA = #Local.insumos.NU_CANTIDADSURTIDA#>
                            <cfset local.ax.VALORESDETALLE     = '#Local.insumos.VALORESDETALLE#'>
    
                                <cfif arguments.ID_TIPOREQUISICION EQ 2>
                                    <cfset local.ax.ID_ALMACEN = #Local.insumos.ID_ALMACEN#>
                                    <cfset local.ax.ID_SUCURSALSOLICITA = #Local.insumos.ID_SUCURSALSOLICITA#>
                                    <cfinvoke   component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                                        method="get_ExistenciasAlmacen"
                                        id_empresa="#Local.insumos.ID_EMPRESA#"
                                        id_sucursal="#Local.insumos.ID_SUCURSALSOLICITA#"
                                        id_insumo="#Local.insumos.ID_INSUMO#"
                                        id_almacen="#Local.insumos.ID_ALMACEN#"
                                        returnvariable="nu_Existencias">
    
                                    <cfset local.ax.NU_EXISTENCIA = #nu_Existencias.NU_EXISTENCIA#>
                                    <cfset local.ax.NB_CENTROCOSTOFORMAT = #Local.insumos.NB_CENTROCOSTOFORMAT#>
                                </cfif>
    
                            <cfset ArrayAppend(Local.InsumosCompletos, #Local.ax#)>
                            <cfset local.ax = structNew()>
                        </cfloop>
                    </cfif>
                    <!---
                        Se elimino el envio de notificacion al jefe inmediato por peticion via correo de Procesos (Magda) el dia 03/07/2018

                    <cfinvoke   component="#Application.RF.getPath('dao','empresas')#"
                        method="InformacionEmpresa"
                        id_empresa="#arguments.id_empresa#"
                        returnvariable="Local.empresa">

                    <cfset Local.imagenes=[
                        {
                            dir="#Local.empresa.ar_ImagenReporte#",
                            disposicion='inline',
                            name="logo"
                        },
                        {
                            dir="assets/img/greenLeaf.jpg",
                            disposicion='inline',
                            name="footer"
                        }
                    ]>

                    <cfset Local.parametros={
                        de_mensaje = "Se autoriz&oacute; la siguiente requisici&oacute;n:",
                        id_requisicion = arguments.ID_REQUISICION,
                        nb_Empresa = Local.empresa.nb_Empresa,
                        nb_sucursal = arguments.NB_SUCURSAL,
                        nb_departamento = arguments.NB_DEPARTAMENTO,
                        id_tipoRequisicion = arguments.ID_TIPOREQUISICION,
                        de_tipoRequisicion = arguments.DE_TIPOREQUISICION,
                        fh_registroRequisicion = arguments.FH_REGISTROREQUISICION,
                        sn_autorizado = "yes",
                        insumos = Local.InsumosCompletos
                    }/>


                    <cfif #ArrayLen(Local.destinatarios)# GT 0 >
                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                    method="sendMail"
                                    destinatarios="#local.destinatarios#"
                                    asunto="Autorización de requisición"
                                    imagenes="#Local.imagenes#"
                                    parametros="#Local.parametros#"
                                    sn_plantilla="YES"
                                    dir_plantilla="templates/correos/Compras/templateMailAutorizacionRequisicion.html"
                                    returnvariable="Local.rbr"/>
                    </cfif>
                    --->
                </cfif>
                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            </cfif>
        <cfelse>
            <cfset variables.RBR.setError('Ocurrio un error.')>
        </cfif>
        <!--- <cfset variables.RBR.setError('Fail.')> --->
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getRequisicionesUsuario" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_Requisicion"       type="string" required="true">
        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                  method="getRequisicionesUsuario"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarStatus" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                  method="listarStatus"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="AutorizadaValidarRechazo" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_Requisicion"       type="string" required="true">

            <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                  method="AutorizadaValidarRechazo"
                  argumentcollection="#arguments#"
                  id_Empresa="#session.ID_EMPRESA#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerUsuarioAutorizaPorNivelRequisiciones" access="public" returntype="Any">
        <cfargument name = 'id_Empresa' type='string' required='yes'>
        <cfargument name = 'id_Sucursal' type='string' required='yes'>
        <cfargument name = 'id_TipoDivision' type='string' required='yes'>
        <cfargument name = 'id_Nivel' type='string' required='yes'>

            <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                  method="obtenerUsuarioAutorizaPorNivelRequisiciones"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AgregarRequisicionesUsuarioAutorizaPorNivel" access="public" returntype="Any">
        <cfargument name="id_Empresa"                     type="string" required="true"/>
    <cfargument name="id_Sucursal"                    type="string" required="true"/>
    <cfargument name="id_TipoDivision"                type="string" required="true"/>
    <cfargument name="id_Nivel"                       type="string" required="true"/>
        <cfargument name="id_Requisicion"                         type="string" required="true"/>
        <cfargument name="id_RequisicionUsuarioAutoriza"    type="string"   required="true"/>
        <cfargument name="id_UsuarioAutoriza"                   type="string"   required="true"/>
        <cfargument name="fh_AsignacionEstatus"                 type="string"   required="true"/>

        <cfset  arguments.id_UsuarioAutoriza = session.ID_USUARIO>

        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                  method="AgregarRequisicionesUsuarioAutorizaPorNivel"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Se agregaron dos nuevos campos en requisionesDetalle id_grupoGasto e id_conceptoGasto, aun no estan incluidos en el reporte --->
    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="requisicion"        type="query" required="true">
        <cfargument name="requisicionDetalle" type="query"  required="true">
        <cfargument name="estatus"            type="numeric"  required="true">
        <cfargument name="ar_ImagenReporte"   type="string"  required="false">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteAutorizacionRequisicion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicion.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteAutorizacionRequisicion#"
                  pdf="requisicion#Arguments.requisicion.id_requisicion#"
                  debug="no"
              path="#expandPath('/root/Reportes/')#">


        <cfreturn Variables.RBR>
    </cffunction>
</cfcomponent>
