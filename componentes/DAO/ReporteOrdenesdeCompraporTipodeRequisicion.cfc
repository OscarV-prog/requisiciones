<cfcomponent extends="wiz/sucursales">

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"         type="numeric" required="true"/>
        <cfargument name="id_TipoRequisicion" type="string" required="false"/>
        <cfargument name="fh_Inicio"          type="string" required="true"/>
        <cfargument name="fh_Fin"             type="string" required="true"/>       
            
            <cfquery  name="Local.rs" datasource="#variables.cnx#">
                exec upR_ReportedeComprasporTipoRequisicion
                    #arguments.id_Empresa#,
                <cfif isDefined("Arguments.id_TipoRequisicion") AND ARGUMENTS.id_TipoRequisicion NEQ ''>'#Arguments.id_TipoRequisicion#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.fh_Inicio") AND ARGUMENTS.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.fh_Fin") AND ARGUMENTS.fh_Fin NEQ ''>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>
            </cfquery>

            <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"         type="numeric" required="true"/>
        <cfargument name="id_TipoRequisicion" type="string" required="false"/>
        <cfargument name="fh_Inicio"          type="string" required="true"/>
        <cfargument name="fh_Fin"             type="string" required="true"/>       
            
            <cfquery  name="Local.rs" datasource="#variables.cnx#">
                exec upR_ReportedeComprasporTipoRequisicionDetallado
                    #arguments.id_Empresa#,
                <cfif isDefined("Arguments.id_TipoRequisicion") AND ARGUMENTS.id_TipoRequisicion NEQ ''>'#Arguments.id_TipoRequisicion#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.fh_Inicio") AND ARGUMENTS.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.fh_Fin") AND ARGUMENTS.fh_Fin NEQ ''>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>
            </cfquery>

            <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>