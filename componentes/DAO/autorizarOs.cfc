<cfcomponent extends="wiz/Requisiciones">   

    <cffunction name="getOrdenSuministro" access="public" returntype="struct">
        <cfargument name='id_Empresa'           type='numeric' required='yes'>
        <cfargument name='id_ordenDeSuministro'   type='numeric' required='yes'>
        <cfargument name='cl_token'             type='string' required='yes'>
        
        <cfstoredproc procedure="upR_OrdenesdeSuministroAut" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#" null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ordenDeSuministro"   value="#arguments.id_ordenDeSuministro#" null="#iif(isNumeric(arguments.id_ordenDeSuministro),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_token"             value="#arguments.cl_token#" null="#iif(len(arguments.cl_token),false,true)#">
            <cfprocresult name="Local.datos.GRAL" resultset="1">
            <cfprocresult name="Local.datos.IC" resultset="2">
            <cfprocresult name="Local.datos.DESC" resultset="3">
        </cfstoredproc>
        <cfreturn Local.datos/>
    </cffunction>

    <cffunction name="getConfiguracionNE" access="public" returntype="query">
        <cfargument name='id_Empresa'       type='numeric'  required='yes'>
        <cfargument name='id_Sucursal'      type='numeric'  required='yes'>
        <cfargument name='id_Empleado'      type='string'   required='yes'>
        <cfargument name='id_Notificacion'  type='string'   required='yes'>
        
        <cfstoredproc procedure="upR_configuracionNotificacionesEmpleadosOS" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"      value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"      value="#arguments.id_Empleado#"     null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Notificacion"  value="#arguments.id_Notificacion#" null="#iif(isNumeric(arguments.id_Notificacion),false,true)#">
            <cfprocresult name="Local.existe" resultset="1">
        </cfstoredproc>
        <cfreturn Local.existe/>
    </cffunction>
</cfcomponent>