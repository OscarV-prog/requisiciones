<cfcomponent extends="wiz/Requisiciones">   

    <cffunction name="getRequisicion" access="public" returntype="query">
        <cfargument name='id_requisicion' type='string' required='false'>
        <cfargument name='id_usuario' type='string' required='false'>
        <cfargument name='cl_token'       type='string' required='false'>
            
        <cfstoredproc procedure="upR_requisicionesAut" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion" value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_usuario" value="#arguments.id_usuario#" null="#iif(isNumeric(arguments.id_usuario),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_token" value="#arguments.cl_token#" null="#iif(len(arguments.cl_token),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>
</cfcomponent>