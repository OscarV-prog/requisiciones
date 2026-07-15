<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="listarCombo" access="public" returnformat="JSON">
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','EstatusSurtidoRequisiciones')#"
                      method="listarCombo"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>              

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>                    
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>
</cfcomponent>  