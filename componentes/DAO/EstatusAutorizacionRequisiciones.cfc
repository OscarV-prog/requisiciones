<cfcomponent extends="wiz/EstatusAutorizacionRequisiciones">
    <cffunction name="listar" access="public" returntype="Query">
        <cfargument name="id_EstatusAutorizacionRequisicion" type="string" required="false"/>
        <cfargument name="de_EstatusAutorizacionRequisicion" type="string" required="false"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_EstatusAutorizacionRequisiciones 
                    <cfif isDefined("Arguments.id_EstatusAutorizacionRequisicion")>#Arguments.id_EstatusAutorizacionRequisicion#<cfelse>NULL</cfif>,
                    <cfif isDefined("Arguments.de_EstatusAutorizacionRequisicion")>'#Arguments.de_EstatusAutorizacionRequisicion#'<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.rs/>
        
    </cffunction>

    <cffunction name="getIdByDescription" access="public" returntype="numeric">
        <cfargument name="de_EstatusAutorizacionRequisicion" type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_EstatusAutorizacionRequisicionesGetIdByDescription '#Arguments.de_EstatusAutorizacionRequisicion#'
        </cfquery>

        <cfreturn Local.rs.id_EstatusAutorizacionRequisicion/>
    </cffunction>
</cfcomponent>