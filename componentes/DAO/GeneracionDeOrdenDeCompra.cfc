<cfcomponent extends="wiz/SolicitudesCompra">

    <cffunction name="listado" access="public" returntype="Query">
        <cfargument name='id_Empresa'           type='string' required='yes'>
        <cfargument name='fh_inicio'            type='string' required='yes'>
        <cfargument name='fh_fin'               type='string' required='yes'>
        <cfargument name='id_sucursal'          type='string' required='yes'>
        <cfargument name='opc_pantalla'         type='string' required='yes' default="1">
        <cfargument name='id_requisicion'       type='string' required='no'>
        <cfargument name='id_solicitudCompra'   type='string' required='no'>
        <cfargument name="id_UsuarioRegistro"   type="string" required="yes">
        <cfargument name="id_estatus"           type="string" required="yes">
        <cfargument name='page'                 type='string' required='no'>
        <cfargument name='pageSize'             type='string' required='no'>
        <cfargument name='sn_NoComprar'         type='string' required='no'>
        <cfargument name='id_TipoRequisicion'   type='string' required='no'>
        <cfargument name='id_cotizacion'        type='string' required='no'  default="">
        <cfargument name='id_grupoCentroCosto'  type='string' required='no'  default="">
        <cfargument name='id_CentroCosto'       type='string' required='no'  default="">
        <cfargument name='nb_Insumo'            type='string' required='no'  default="">
        <cfargument name='nu_Siniestro'             type='string' required='no'  default="">


        <cfstoredproc procedure="upL_SolicitudesCompraListado_paginado" datasource="#variables.cnx#">
            <cfprocparam type       = "IN" cfsqltype='CF_SQL_INTEGER'  dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_sucursal"         value="#arguments.id_sucursal#"         null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_grupoCentroCosto" value="#arguments.id_grupoCentroCosto#" null="#iif(isNumeric(arguments.id_grupoCentroCosto),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_CentroCosto"      value="#arguments.id_CentroCosto#"      null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_TipoRequisicion"  value="#arguments.id_TipoRequisicion#"  null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_estatus"          value="#arguments.id_estatus#"          null="#iif(isNumeric(arguments.id_estatus),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_VARCHAR"           dbvarname="@fh_inicio"           value="#arguments.fh_inicio#"              null="#iif(len(arguments.fh_inicio),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_VARCHAR"           dbvarname="@fh_fin"              value="#arguments.fh_fin#"                 null="#iif(len(arguments.fh_fin),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_requisicion"      value="#arguments.id_requisicion#"      null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_SolicitudCompra"  value="#arguments.id_SolicitudCompra#"  null="#iif(isNumeric(arguments.id_SolicitudCompra),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_cotizacion"       value="#arguments.id_cotizacion#"       null="#iif(isNumeric(arguments.id_cotizacion),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@sn_NoComprar"        value="#arguments.sn_NoComprar#"        null="#iif(isNumeric(arguments.sn_NoComprar),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@opc_pantalla"        value="#arguments.opc_pantalla#"        null="#iif(isNumeric(arguments.opc_pantalla),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_UsuarioRegistro"  value="#arguments.id_UsuarioRegistro#"  null="#iif(isNumeric(arguments.id_UsuarioRegistro),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@page"                value="#arguments.page#"                null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@pageSize"            value="#arguments.pageSize#"            null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_EmpresaEmpleado"  value="#session.ID_EMPRESAOPERADORA#"   null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_Empleado"         value="#SESSION.ID_EMPLEADO#"           null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_VARCHAR"         dbvarname="@nb_Insumo"              value="#arguments.nb_Insumo#"                 null="#iif(len(arguments.nb_Insumo),false,true)#">
            <cfprocparam type       = "IN" cfsqltype="CF_SQL_VARCHAR"         dbvarname="@nu_Siniestro"              value="#arguments.nu_Siniestro#"               null="#iif(len(arguments.nu_Siniestro),false,true)#">
            <cfprocresult name="Local.Requisicion" resultset="1">
        </cfstoredproc>
        <cfreturn Local.Requisicion/>
    </cffunction>

    <cffunction name="listadosolicitudesalmacenes" access="public" returntype="Query">
        <cfargument name='id_empresa'     type='string' required='yes'>
        <cfargument name='fh_inicio'      type='string' required='false'>
        <cfargument name='fh_fin'         type='string' required='false'>
        <cfargument name='id_sucursal'    type='string' required='false'>
        <cfargument name="id_UsuarioRegistro" type="string" required="yes">

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_SolicitudesCompraListadosolicitudesalmacen
                    #Arguments.id_empresa#,
                <cfif isDefined("Arguments.fh_Inicio")>'#arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.fh_fin")>'#Arguments.fh_fin#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_sucursal")>#Arguments.id_sucursal#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_UsuarioRegistro")>#Arguments.id_UsuarioRegistro#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Reposicion") AND #Arguments.sn_Reposicion# NEQ ''>#Arguments.sn_Reposicion#<cfelse>NULL</cfif>


        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que devuelve los insumos a los que se les puede cotizar restantes por el total de ordenes de compra correspondientes
          a una solicitud de compra --->
    <cffunction name="getinsumosrestantes" access="public" returntype="Query">
        <cfargument name='id_solicitudCompra'   type='numeric' required='yes'>
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_InsumosaComprar
                #Arguments.id_Empresa#,
                #arguments.id_SolicitudCompra#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que verifica si la solicitud de compra tiene ordenes de compras--->
    <cffunction name="getordenescomprabysolicitudcompra" access="public" returntype="Query">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name='id_solicitudCompra'   type='numeric' required='yes'>
        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_OrdenesComprasbysolicitudcompra
                #Arguments.id_Empresa#,
                #arguments.id_SolicitudCompra#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que va por la sucursal que genero la solicitud de compra a la cual se le esta haciendo cotización--->
    <cffunction name="getsucursalsolicitudcompra" access="public" returntype="Query">
        <cfargument name='id_empresa'           type='numeric' required='true'>
        <cfargument name='id_solicitudCompra'   type='numeric' required='true'>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_SolicitudesCompragetsucursal
                        #arguments.id_empresa#,
                        #arguments.id_solicitudCompra#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="SolicitudCompranextID" access="public" returntype="string">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_SolicitudCompraNextID
                        #arguments.id_Empresa#
        </cfquery>
        <cfreturn Local.rs.nextID />
    </cffunction>

    <cffunction name="SolicitudCompraDetallenextID" access="public" returntype="string">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true"/>
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_SolicitudCompraDetalleNextID
                            #arguments.id_Empresa#,
                            #arguments.id_SolicitudCompra#
        </cfquery>
        <cfreturn Local.rs.nextID />
    </cffunction>


    <cffunction name="eliminar_SolicitudCompraById_Requisicion" access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upD_SolicitudCompraById_Requisicion
                            #arguments.id_Empresa#,
                            #arguments.id_Requisicion#
        </cfquery>
    </cffunction>

    <cffunction name="obtenerId_SolicitudCompraById_Requisicion" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_SolicitudCompraById_Requisicion
                            #arguments.id_Empresa#,
                            #arguments.id_Requisicion#
        </cfquery>
        <cfreturn Local.rs />
    </cffunction>


    <cffunction name="eliminar_SolicitudCompraDetalle" access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true"/>
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upD_SolicitudCompraDetalle
                            #arguments.id_Empresa#,
                            #arguments.id_SolicitudCompra#
        </cfquery>
    </cffunction>



    <cffunction name="agregarSolicitudAlmacen" access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_Sucursal"          type="numeric" required="true"/>
        <cfargument name="id_Almacen"           type="numeric" required="false"/>
        <cfargument name="id_Usuario"           type="numeric" required="true"/>
        <cfargument name="fh_Registro"          type="string" required="true"/>
        <cfargument name="id_Requisicion"       type="string" required="false"/>
        <cfargument name='Comentario'           type='string' required='no'>

            <!--- <cfdump var="#arguments#" /><cfabort /> --->
            <cfquery name="Local.rs"datasource="#variables.cnx#">
                exec upC_SolicitudesCompra
                                      #arguments.id_Empresa#,
                                      #arguments.id_Sucursal#,
                <cfif isDefined("arguments.id_Almacen")>#arguments.id_Almacen#<cfelse>NULL</cfif>,
                                       #arguments.id_Usuario#,
                <cfif isDefined('arguments.fh_Registro') AND arguments.fh_Registro NEQ ''>'#arguments.fh_Registro#'<cfelse>NULL</cfif>,
                <cfif isDefined('arguments.id_Requisicion') AND arguments.id_Requisicion NEQ ''>#arguments.id_Requisicion#<cfelse>NULL</cfif>,
                <cfif isDefined('arguments.Comentario') AND #arguments.Comentario# NEQ ''>'#arguments.Comentario#'<cfelse>NULL</cfif>,
                <cfif isDefined('arguments.sn_reposicion') AND #arguments.sn_reposicion# NEQ ''>'#arguments.sn_reposicion#'<cfelse>NULL</cfif>
            </cfquery>
        <cfreturn Local.rs.id_SolicitudCompra/>

    </cffunction>

    <cffunction name="agregarSolicitudDetalleAlmacen" access="public" returntype="void">
        <cfargument name="id_Empresa"                   type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"           type="numeric" required="true"/>
        <cfargument name="id_Insumo"                    type="numeric" required="true"/>
        <cfargument name="nu_Cantidad"                  type="string"   required="true"/>
        <cfargument name="id_Requisicion"               type="numeric"  required="false"/>
        <cfargument name="id_RequisicionDetalle"        type="numeric"  required="false"/>
        <cfif not isDefined("Arguments.id_Requisicion")>
            <cfset Arguments.id_Requisicion = 'NULL'>
        </cfif>
        <cfif not isDefined("Arguments.id_RequisicionDetalle")>
            <cfset Arguments.id_RequisicionDetalle = 'NULL'>
        </cfif>

            <cfquery datasource="#variables.cnx#">
                exec upC_SolicitudesCompraDetalle
                                      #arguments.id_Empresa#,
                                       #arguments.id_SolicitudCompra#,
                                       #arguments.id_Insumo#,
                                       #arguments.nu_Cantidad#,
                                       #arguments.id_Requisicion#,
                                       #arguments.id_RequisicionDetalle#
            </cfquery>
    </cffunction>


    <cffunction name="getFechaRegistro" access="public" returntype="query">
        <cfargument name='id_Empresa'         type='string' required='true'>
        <cfargument name='id_solicitudCompra' type='string' required='true'>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_SolicitudesCompraFechaRegistro  #Arguments.id_Empresa#,#Arguments.id_solicitudCompra#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getByID" access="public" returntype="query">
        <cfargument name='id_Empresa'         type='string' required='true'>
        <cfargument name='id_solicitudCompra' type='string' required='true'>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_SolicitudesCompraByID  #Arguments.id_Empresa#,#Arguments.id_solicitudCompra#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- jcal devuelve los si la solicitud de compra ha sido comprada por completo 08/10/2015 --->
    <cffunction name="getinsumosfaltantesporcomprar" access="public" returntype="query">
        <cfargument name='id_Empresa'         type='string' required='true'>
        <cfargument name='id_solicitudCompra' type='string' required='true'>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_SolicitudesComprainsumosfaltantes
                                    #Arguments.id_Empresa#,
                                    #Arguments.id_solicitudCompra#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="Estatus" access="public" returntype="query">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upRL_SolicitudesdeCompraEstatus

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarMotivosCancelacion" access="public" returntype="Query">
        <cfargument name="sn_Activo"    type="numeric"  required="true"/>

        <cfstoredproc procedure="upL_MotivosCancelacionOrdenesDeCompraProducto" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"   dbvarname="@sn_Activo"  value="#arguments.sn_Activo#"   null="#iif(isBoolean(arguments.sn_Activo),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
