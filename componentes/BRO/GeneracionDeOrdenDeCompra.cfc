<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listado" access="public" returntype="Any">
        <cfargument name='fh_inicio'            type='string' required='yes'>
        <cfargument name='fh_fin'               type='string' required='yes'>
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name='id_sucursal'          type='string' required='yes'>
        <cfargument name='opc_pantalla'         type='string' required='yes' default="1">
        <cfargument name='id_requisicion'       type='string' required='no' default="">
        <cfargument name='id_solicitudCompra'   type='string' required='no' default="">
        <cfargument name='id_estatus'           type='string' required='no' default="">
        <cfargument name='page'                 type='string' required='no'>
        <cfargument name='pageSize'             type='string' required='no'>
        <cfargument name='sn_NoComprar'         type='string' required='no'>
        <cfargument name='id_TipoRequisicion'   type='string' required='no'>
        <cfargument name='id_cotizacion'        type='string' required='no'  default="">
        <cfargument name='id_grupoCentroCosto'  type='string' required='no'  default="">
        <cfargument name='id_CentroCosto'       type='string' required='no'  default="">
        <cfargument name='nb_Insumo'            type='string' required='no'  default="">
        <cfargument name='nu_Siniestro'             type='string' required='no'  default="">


        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="listado"
                  id_UsuarioRegistro="#session.ID_USUARIO#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listadosolicitudesalmacenes" access="public" returntype="Any">
        <cfargument name='fh_inicio'      type='string' required='yes'>
        <cfargument name='fh_fin'         type='string' required='yes'>
        <cfargument name='id_sucursal'    type='string' required='yes'>
        <cfargument name='sn_Reposicion'  type='string' required='yes'>

        <cfset Local.solicitud=structNew()>
        <cfset Local.solicitud.id_empresa=session.ID_EMPRESA>

        <cfif Arguments.fh_inicio NEQ ''>
            <cfset Local.solicitud.fh_inicio=Arguments.fh_inicio>
        </cfif>
        <cfif Arguments.fh_fin NEQ ''>
            <cfset Local.solicitud.fh_fin=Arguments.fh_fin>
        </cfif>

        <cfif Arguments.id_sucursal NEQ ''>
            <cfset Local.solicitud.id_sucursal=Arguments.id_sucursal>
        </cfif>

        <cfset Local.solicitud.id_UsuarioRegistro = session.ID_USUARIO >
        <cfset Local.solicitud.sn_Reposicion = arguments.sn_Reposicion >

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="listadosolicitudesalmacenes"
                  argumentcollection="#Local.solicitud#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- funcion que devuelve los insumos a los que se les puede contizar restantes por el total de ordenes de compra correspondientes
          a una solicitud de compra --->
    <cffunction name="getinsumosrestantes" access="public" returntype="Any">
        <cfargument name='id_Empresa'           type='numeric' required='false'>
        <cfargument name='id_solicitudCompra'   type='numeric' required='yes'>
        <cfargument name='id_cotizacion'        type='string' required='false'>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif not isDefined("id_solicitudCompra")>
            <cfset variables.RBR.setError('El id_solicitudCompra es requerido y no fue enviado.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getinsumosrestantes"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <!--- funcion que verifica si la solicitud de compra tiene ordenes de compras--->
        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getordenescomprabysolicitudcompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.ordenescompras">

        <!--- funcion que devuelve los insumos a los que ya estan dentro de una oc en esa cotizacion --->
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesdeCompra')#"
                  method="getinsumosexistentesenordenescomprabycotizacion"
                  id_Empresa ="#Arguments.id_empresa#"
                  id_cotizacion ="#arguments.id_cotizacion#"
                  returnvariable="Local.insumosexistenordenescompra">

        <!--- devuelve los insumos de una cotización en especifico--->
        <cfinvoke component="#Application.RF.getPath('dao','CotizacionesDetalle')#"
                  method="getinsumoscotizacion"
                  argumentcollection="#arguments#"
                  id_Empresa ="#Arguments.id_Empresa#"
                  returnvariable="Local.insumoscotizacion">

        <cfset  local.data = structNew()>

        <cfset local.data.infoinsumos = local.rs>
        <cfset local.data.infocompras = local.ordenescompras>
        <cfset local.data.insumoscoti = local.insumoscotizacion>
        <cfset local.data.insumosexisteoc = local.insumosexistenordenescompra>

        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->
        <cfset variables.RBR.setData(local.data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getFechaRegistro" access="public" returntype="Any">
        <cfargument name='id_solicitudCompra' type='string' required='yes'>

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getFechaRegistro"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_solicitudCompra="#Arguments.id_solicitudCompra#"
                  returnvariable="Local.rs">

        <cfset Local.data=structNew()>
        <cfset Local.data.fh_registro=Local.rs.fh_registroFormat>

        <cfset variables.RBR.setData(Local.data)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Modificacion: Rey David Dominguez
          Fecha: 15/05/2015
          Genera solicitudes de compra sin requisicion desde almacen(julius)
          envia correo a los empleados que tengan asignada la opcion de solicitud de compra
          en el modulo de compras. --->
    <cffunction name="agregarSolicitudAlmacen" access="public" returntype="Any">
        <cfargument name='Insumos'        type='array'  required='yes'>
        <cfargument name='InsumosComprar' type='array'  required='no'>
        <cfargument name='Comentario'     type='string' required='no'>
        <cfargument name='sn_reposicion'  type='string' required='no'   default="0">

        <!--- <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="SolicitudCompranextID"
                  id_Empresa = "#session.ID_EMPRESA#"
                  returnvariable="Local.id_SolicitudCompra">--->

                <cfif isDefined("Comentario")>
                     <cfset Local.Comentario = "#Arguments.Comentario#">
                <cfelse>
                    <cfset Local.Comentario = ''>
                </cfif>

        <!---
            VERIFICAR SI LOS INSUMOS SOLICITADOS ESTAN DENTRO DE LOS MINIMOS Y MAXIMOS
        --->

        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.i">

            <cfinvoke component="#Application.RF.getPath('dao','insumos')#"
                    method="upR_InsumosMM"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_Sucursal = "#SESSION.ID_SUCURSAL#"
                    id_Almacen ="#session.ID_ALMACEN#"
                    id_Insumo = "#arguments.Insumos[local.i].id_Insumo#"
                    nu_Cantidad = "#arguments.Insumos[local.i].nu_Cantidad#"
                    returnvariable="Local.sn_PasoRango">

                <cfif Local.sn_PasoRango EQ 1>
                    <cfset variables.RBR.setError("No se puede generar la solicitud de compra ya que la cantidad del insumo #arguments.Insumos[local.i].id_Insumo# - #arguments.Insumos[local.i].nb_NombreInsumo# esta fuera del rango configurado en Minimos y Maximos")>
                    <cfreturn variables.RBR>
                </cfif>


        </cfloop>


        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="agregarSolicitudAlmacen"
                  id_Empresa     = "#session.ID_EMPRESA#"
                  id_Sucursal    = "#SESSION.ID_SUCURSAL#"
                  id_Almacen     = "#session.ID_ALMACEN#"
                  id_Usuario     = "#session.ID_USUARIO#"
                  fh_Registro    = "#dateFormat(Now(),'yyyyMMdd')#"
                  Comentario     = "#Local.Comentario#"
                  id_Requisicion = ""
                  sn_reposicion  = "#arguments.sn_reposicion#"
                  returnvariable = "Local.id_SolicitudCompra">


        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.i">

            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                    method="agregarSolicitudDetalleAlmacen"
                    id_Empresa         = "#session.ID_EMPRESA#"
                    id_SolicitudCompra = "#local.id_SolicitudCompra#"
                    id_Insumo          = "#arguments.Insumos[local.i].id_Insumo#"
                    nu_Cantidad        = "#arguments.Insumos[local.i].nu_Cantidad#">

        </cfloop>


        <cfif isDefined('arguments.InsumosComprar')>
            <cfloop from="1" to="#arrayLen(arguments.InsumosComprar)#" index="local.i">
                <cfif arguments.sn_Reposicion EQ 1>
                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleOrigenPrestamos')#"
                        method="agregarDetalle"
                            id_Empresa            = "#arguments.InsumosComprar[Local.i].id_Empresa#"
                            id_Sucursal           = "#arguments.InsumosComprar[Local.i].id_Sucursal#"
                            id_Almacen            = "#arguments.InsumosComprar[Local.i].id_Almacen#"
                            id_Movimiento         = "#arguments.InsumosComprar[Local.i].id_Movimiento#"
                            nd_MovimientoDetalle  = "#arguments.InsumosComprar[Local.i].nd_MovimientoDetalle#"
                            id_SolicitudCompra    = "#Local.id_SolicitudCompra#"
                            nu_Cantidad           = "#arguments.InsumosComprar[Local.i].NU_CANTIDADCOMPRAR#"
                            id_SucursalDocumento  = ""
                            cl_TipoDocumento      = ""
                            id_Documento          = "">
                </cfif>
            </cfloop>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Sucursales')#"
                  method="getNameSucursal"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  returnvariable="Local.sucursal">

        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                  method="getNameAlmacen"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  returnvariable="Local.almacen">

        <cfset Local.parametros={
            id_SolicitudCompra=local.id_SolicitudCompra,
            nb_sucursal=Local.sucursal.nb_sucursal,
            nb_almacen=Local.almacen.nb_almacen,
            nb_empleado=session.NB_EMPLEADOCOMPLETO,
            nu_requisicion=''
        }>

        <!--- Obtiene los empleados que estan asignados a la opcion de solicitud de compra en el
            modulo de compras (id_opcion=28) --->
        <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                  method="getEmpleadosAsigSolicitudCompra"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  returnvariable="Local.empleadosSC">

        <cfset Local.correosEmpleados=arrayNew(1)>
        <cfloop query="Local.empleadosSC">
            <cfif Local.empleadosSC.de_email NEQ '' AND !arrayFind(Local.correosEmpleados,Local.empleadosSC.de_email)>
                <cfset arrayAppend(Local.correosEmpleados,Local.empleadosSC.de_email) >
            </cfif>
        </cfloop>

        <cfif arrayLen(Local.correosEmpleados) GT 0>
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

            <!---<cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                      method="sendMail"
                      destinatarios="#Local.correosEmpleados#"
                      asunto="Solicitud de compra"
                      imagenes="#Local.imagenes#"
                      parametros="#Local.parametros#"
                      sn_plantilla="YES"
                      dir_plantilla="templates/correos/Compras/templateMailSolicitudCompra.html"
                      returnvariable="Local.rbr"/>

            <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
            </cfif>--->
        </cfif>
        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Modificacion: Rey David Dominguez
          Fecha: 15/05/2015
          Genera solicitudes de compra sin requisicion desde almacen(julius)
          envia correo a los empleados que tengan asignada la opcion de solicitud de compra
          en el modulo de compras. --->
    <cffunction name="crearSolicitudCompraRequisicion" access="public" returntype="Any">
        <cfargument name='id_Empresa' type='numeric' required='yes'>
        <cfargument name='id_Requisicion' type='numeric' required='yes'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="getById"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.requisicion">


        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                  method="getByIdRequisicion"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.detalleRequisicion">

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="SolicitudCompranextID"
                  id_Empresa = "#Local.requisicion.id_Empresa#"
                  returnvariable="Local.id_SolicitudCompra">

                 <!--- Si es de tipo Servicios(1) --->
                 <cfif #Local.requisicion.ID_TIPOREQUISICION# EQ 1>

                    <!--- Validamos que exista el almacen de servicios --->
                    <cfinvoke component="#Application.RF.getPath('dao','almacenes')#"
                              method="existeAlmacenServicios"
                              id_Empresa="#Local.requisicion.id_empresa#"
                              id_Sucursal="#Local.requisicion.id_SucursalSolicita#"
                              returnvariable="Local.almacenServicios">

                    <cfif Local.almacenServicios.RecordCount EQ 0>
                        <cfset variables.RBR.setError("La sucursal no cuenta con un almacen de servicios registrado.")>
                        <cfreturn variables.RBR>
                    </cfif>


                    <!--- Se manda el usuario que creo la requisicion --->
                    <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                      method="agregarSolicitudAlmacen"
                      id_Empresa="#Local.requisicion.id_Empresa#"
                      id_Sucursal = "#Local.requisicion.id_SucursalSolicita#"
                      id_Almacen="#Local.almacenServicios.id_Almacen#"
                      id_SolicitudCompra="#local.id_SolicitudCompra#"
                      id_Usuario = "#Local.requisicion.ID_USUARIOSOLICITA#"
                      fh_Registro ="#dateFormat(Now(),'yyyyMMdd')#"
                      id_Requisicion = "#Arguments.id_requisicion#">
                 <!--- <cfelse>
                    <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                      method="agregarSolicitudAlmacen"
                      id_Empresa="#Local.requisicion.id_Empresa#"
                      id_Sucursal = "#Local.requisicion.id_SucursalSolicita#"
                      id_SolicitudCompra="#local.id_SolicitudCompra#"
                      id_Usuario = "#session.ID_USUARIO#"
                      fh_Registro ="#dateFormat(Now(),'yyyyMMdd')#"
                      id_Requisicion = "#Arguments.id_requisicion#">         --->
                 </cfif>


        <cfloop query="Local.detalleRequisicion">
            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                        method="SolicitudCompraDetallenextID"
                        id_Empresa = "#Local.requisicion.id_Empresa#"
                        id_SolicitudCompra = "#local.id_SolicitudCompra#"
                        returnvariable="Local.id_SolicitudCompraDetalle">

            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                    method="agregarSolicitudDetalleAlmacen"
                    id_Empresa="#Local.requisicion.id_empresa#"
                    id_SolicitudCompra="#local.id_SolicitudCompra#"
                    id_SolicitudCompraDetalle ="#local.id_SolicitudCompraDetalle#"
                    id_Insumo = "#Local.detalleRequisicion.id_Insumo#"
                    nu_Cantidad = "#Local.detalleRequisicion.nu_Cantidad#"
                    id_Requisicion = "#Local.detalleRequisicion.id_Requisicion#"
                    id_RequisicionDetalle = "#Local.detalleRequisicion.id_RequisicionDetalle#">
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','Sucursales')#"
                  method="getNameSucursal"
                  id_Empresa="#Local.requisicion.id_Empresa#"
                  id_sucursal="#Local.requisicion.id_SucursalSolicita#"
                  returnvariable="Local.sucursal">

        <cfset Local.parametros={
            id_SolicitudCompra=local.id_SolicitudCompra,
            nb_sucursal=Local.sucursal.nb_sucursal,
            nb_almacen='',
            nb_empleado=session.NB_EMPLEADOCOMPLETO,
            nu_requisicion=Local.requisicion.id_requisicion,
            id_tipoRequisicion=Local.requisicion.id_tipoRequisicion
        }>

        <!--- Obtiene los empleados que estan asignados a la opcion de solicitud de compra en el
            modulo de compras (id_opcion=28) --->
        <!---
        <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                  method="getEmpleadosAsigSolicitudCompra"
                  id_Empresa="#Local.requisicion.id_Empresa#"
                  id_sucursal="#Local.requisicion.id_sucursalSolicita#"
                  returnvariable="Local.empleadosSC">

        <cfset Local.correosEmpleados=arrayNew(1)>
        <cfloop query="Local.empleadosSC">
            <cfif Local.empleadosSC.de_email NEQ '' AND !arrayFind(Local.correosEmpleados,Local.empleadosSC.de_email)>
                <cfset arrayAppend(Local.correosEmpleados,Local.empleadosSC.de_email) >
            </cfif>
        </cfloop>

        <cfinvoke   component="#Application.RF.getPath('dao','empresas')#"
            method="InformacionEmpresa"
            id_empresa="#arguments.id_empresa#"
            returnvariable="Local.empresa">

        <cfif arrayLen(Local.correosEmpleados) GT 0>
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

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                      method="sendMail"
                      destinatarios="#Local.correosEmpleados#"
                      asunto="Solicitud de compra"
                      imagenes="#Local.imagenes#"
                      parametros="#Local.parametros#"
                      sn_plantilla="YES"
                      dir_plantilla="templates/correos/Compras/templateMailSolicitudCompra.html"
                      returnvariable="Local.rbr"/>

            <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
            </cfif>
        </cfif>
        --->
        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getByID" access="public" returntype="Any">
        <cfargument name='id_Empresa'           type='numeric' required='false'>
        <cfargument name='id_solicitudCompra'   type='numeric' required='yes'>
        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getByID"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_solicitudCompra="#Arguments.id_solicitudCompra#"
                  returnvariable="Local.rs">

        <!--- devuelve los si la solicitud de compra ha sido comprada por completo--->
        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="getinsumosfaltantesporcomprar"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_solicitudCompra="#Arguments.id_solicitudCompra#"
                  returnvariable="Local.solicitudcomprada">

        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->
        <cfset local.solicitudcompra = structNew()>
        <cfset local.solicitudcompra.info = local.rs>
        <cfset local.solicitudcompra.comprada = local.solicitudcomprada>
        <cfset variables.RBR.setData(Local.solicitudcompra)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Estatus" access="public" returntype="Any">

        <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                  method="Estatus"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarMotivosCancelacion" access="public" returntype="Any">
        <cfargument name="sn_Activo"    type="numeric"  required="true"/>

        <cfinvoke
            component="#Application.RF.getPath('dao','GeneracionDeOrdenDeCompra')#"
            method="listarMotivosCancelacion"
            id_UsuarioRegistro="#session.ID_USUARIO#"
            argumentcollection="#arguments#"
            returnvariable="Local.rs"
        >

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
