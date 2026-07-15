<cfcomponent extends="wiz/sucursales">
    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Requisicion"           type="string"  required="false"/>
        <cfargument name="fh_Inicio"                type="string"  required="false"/>
        <cfargument name="fh_Final"                 type="string"  required="false"/>
        <cfargument name="nu_tipoFecha"             type="numeric" required="true"/>
        <cfargument name="id_EstatusAutorizacion"   type="string"  required="false"/>
        <cfargument name="id_EstatusSurtido"        type="string"  required="false"/>
        <cfargument name="id_UsuarioAutoriza"       type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_SolicitadoCompras"     type="string"  required="false"/>
        <cfargument name="id_OrdenDeCompra"         type="string"  required="false"/>
        <cfargument name="id_SolicitudCompra"       type="string"  required="false"/>
        <cfargument name="id_Empleado"              type="string"  required="false"/>
        <cfargument name="id_EmpresaEmpleado"       type="string"  required="false"/>

        <cfstoredproc procedure="upL_RequisicionesConsultasAlmacen" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"              null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_Sucursal#"             null="#iif(isnumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"           value="#arguments.id_Requisicion#"          null="#iif(isnumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"                value="#arguments.fh_Inicio#"               null="#iif(len(arguments.fh_Inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Final"                 value="#arguments.fh_Final#"                null="#iif(len(arguments.fh_Final),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_tipoFecha"             value="#arguments.nu_tipoFecha#"            null="#iif(isNumeric(arguments.nu_tipoFecha),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion"   value="#arguments.id_EstatusAutorizacion#"  null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"        value="#arguments.id_EstatusSurtido#"       null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioAutoriza"       value="#arguments.id_UsuarioAutoriza#"      null="#iif(isNumeric(arguments.id_UsuarioAutoriza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen"               value="#arguments.id_almacen#"              null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitadoCompras"     value="#arguments.id_SolicitadoCompras#"    null="#iif(isNumeric(arguments.id_SolicitadoCompras),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra"         value="#arguments.id_OrdenDeCompra#"        null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitudCompra"       value="#arguments.id_SolicitudCompra#"      null="#iif(isNumeric(arguments.id_SolicitudCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"              value="#arguments.id_Empleado#"             null="#iif(isnumeric(arguments.id_Empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado"       value="#arguments.id_EmpresaEmpleado#"      null="#iif(isnumeric(arguments.id_EmpresaEmpleado),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>

        <!--- <cfquery  name="Local.Requisicion" datasource="#variables.cnx#">
            exec upL_RequisicionesConsultasAlmacen
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        <cfif isDefined("Arguments.id_Requisicion")          AND arguments.id_Requisicion NEQ ''>#Arguments.id_Requisicion#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Inicio")               AND arguments.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Final")                AND arguments.fh_Final NEQ ''>'#Arguments.fh_Final#'<cfelse>NULL</cfif>,
                        #arguments.nu_tipoFecha#,
                        <cfif isDefined("Arguments.id_EstatusAutorizacion")  AND arguments.id_EstatusAutorizacion NEQ ''>#Arguments.id_EstatusAutorizacion#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_EstatusSurtido")       AND arguments.id_EstatusSurtido NEQ ''>#Arguments.id_EstatusSurtido#<cfelse>NULL</cfif>,
                        #arguments.id_UsuarioAutoriza#,
                        #arguments.id_almacen#,
                        <cfif isDefined("Arguments.id_SolicitadoCompras")     AND arguments.id_SolicitadoCompras NEQ ''>#Arguments.id_SolicitadoCompras#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_OrdenDeCompra")         AND arguments.id_OrdenDeCompra NEQ ''>#Arguments.id_OrdenDeCompra#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_SolicitudCompra")      AND arguments.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_Empleado")             AND arguments.id_Empleado NEQ ''>#Arguments.id_Empleado#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_EmpresaEmpleado")      AND arguments.id_EmpresaEmpleado NEQ ''>#Arguments.id_EmpresaEmpleado#<cfelse>NULL</cfif>

        </cfquery>
        <cfreturn Local.Requisicion/> --->
    </cffunction>

    <cffunction name="Editar" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Requisicion"            type="numeric" required="true"/>
        <cfargument name="id_EstatusAutorizacion"    type="numeric" required="true"/>
        <cfargument name="de_Observaciones"          type="string" required="false"/>

        <cfquery datasource="#variables.cnx#">
            exec upU_RequisicionesEstatus #arguments.id_Empresa#,
                                          #arguments.id_Requisicion#,
                                          #arguments.id_EstatusAutorizacion#,
        <cfif isDefined("arguments.de_Observaciones") AND arguments.de_Observaciones NEQ ''>'#arguments.de_Observaciones#'<cfelse>NULL</cfif>

        </cfquery>
    </cffunction>

    <cffunction name="listarStatus" access="public" returntype="query">
        <cfquery name="Local.Estatus" datasource="#variables.cnx#" >
            exec upL_EstatusComboRequisicionesConsultasAlmacen
        </cfquery>
        <cfreturn Local.Estatus/>
    </cffunction>

    <cffunction name="generarExcel" access="public" returntype="any">
      <cfargument name="id_Empresa"                 type="string" required="false" default=""/>
      <cfargument name="id_Sucursal"                type="string" required="false" default=""/>
      <cfargument name="id_Almacen"                 type="string" required="false" default=""/>
      <cfargument name="id_Requisicion"             type="string" required="false" default=""/>
      <cfargument name="id_EstatusSurtido"          type="string" required="false" default=""/>
      <cfargument name="id_EstatusAutorizacion"     type="string" required="false" default=""/>
      <cfargument name="id_SolicitadoCompras"       type="string" required="false" default=""/>
      <cfargument name="fh_Inicio"                  type="string" required="false" default=""/>
      <cfargument name="fh_Fin"                     type="string" required="false" default=""/>
      <cfargument name="nu_tipoFecha"               type="string" required="false" default=""/>
      <cfargument name="id_EmpresaEmpleado"         type="string" required="false" default=""/>
      <cfargument name="id_Empleado"                type="string" required="false" default=""/>

        <cfstoredproc procedure="upL_RequisicionesDetalleConsultaAlmacenReporte" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"             null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_Sucursal#"            null="#iif(isnumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"               value="#arguments.id_Almacen#"             null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"           value="#arguments.id_Requisicion#"         null="#iif(isnumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"        value="#arguments.id_EstatusSurtido#"      null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion"   value="#arguments.id_EstatusAutorizacion#" null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitadoCompras"     value="#arguments.id_SolicitadoCompras#"   null="#iif(isNumeric(arguments.id_SolicitadoCompras),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"                value="#arguments.fh_Inicio#"              null="#iif(len(arguments.fh_Inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin"                   value="#arguments.fh_Fin#"                 null="#iif(len(arguments.fh_Fin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_tipoFecha"             value="#arguments.nu_tipoFecha#"           null="#iif(isNumeric(arguments.nu_tipoFecha),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado"       value="#arguments.id_EmpresaEmpleado#"     null="#iif(isnumeric(arguments.id_EmpresaEmpleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"              value="#arguments.id_Empleado#"            null="#iif(isnumeric(arguments.id_Empleado),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>
</cfcomponent>
