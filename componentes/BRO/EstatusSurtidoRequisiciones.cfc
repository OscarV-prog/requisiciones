<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listarCombo" access="public" returntype="any">
        <cfinvoke component="#Application.RF.getPath('dao','EstatusSurtidoRequisiciones')#"
                  method="listarCombo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>
</cfcomponent>