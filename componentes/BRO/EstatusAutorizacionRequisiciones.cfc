<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="any">
        <cfargument name="id_EstatusAutorizacionRequisicion" type="string" required="true"/>
        <cfargument name="de_EstatusAutorizacionRequisicion" type="string" required="true"/>

        <cfset Local.argumentos=structNew()>
        <cfif Arguments.id_EstatusAutorizacionRequisicion NEQ '' AND Arguments.id_EstatusAutorizacionRequisicion NEQ '0' AND Arguments.id_EstatusAutorizacionRequisicion NEQ 'NULL'>
            <cfset Local.argumentos.id_EstatusAutorizacionRequisicion=Arguments.id_EstatusAutorizacionRequisicion>
        </cfif>
        <cfif Arguments.de_EstatusAutorizacionRequisicion NEQ '' AND Arguments.de_EstatusAutorizacionRequisicion NEQ '0' AND Arguments.de_EstatusAutorizacionRequisicion NEQ 'NULL'>
            <cfset Local.argumentos.de_EstatusAutorizacionRequisicion=Arguments.de_EstatusAutorizacionRequisicion>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','EstatusAutorizacionRequisiciones')#"
                  method="listar"
                  argumentcollection="#Local.argumentos#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>
</cfcomponent>