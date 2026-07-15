<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8"> 
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="getByIdRequisicion" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='id_Empresa' type='string' required='yes'>
        
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','RequisicionesDetalle')#"
                      method="getByIdRequisicion"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>              

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Detalle requisicion listo")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>
</cfcomponent>