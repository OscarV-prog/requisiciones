<cfcomponent extends="wiz/EstatusSurtidoRequisiciones">
    <cffunction name="getIdByDescription" access="public" returntype="numeric">
        <cfargument name="de_EstatusSurtidoRequisicion" type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_EstatusSurtidoRequisicionesGetIdByDescription '#Arguments.de_EstatusSurtidoRequisicion#'
        </cfquery>

        <cfreturn Local.rs.id_EstatusSurtidoRequisicion/>
    </cffunction>

    <cffunction name="listarCombo" access="public" returntype="Query">
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_EstatusSurtidoRequisicionesCombo           
        </cfquery>
        <cfreturn Local.rs/>    
    </cffunction>
</cfcomponent>