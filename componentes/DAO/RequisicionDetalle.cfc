<cfcomponent extends="wiz/RequisicionDetalle">
    
    <cffunction name="listado" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='true'>
            
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleByRequisicion  #Arguments.id_Empresa#,
                                                        #Arguments.id_requisicion#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>
</cfcomponent>