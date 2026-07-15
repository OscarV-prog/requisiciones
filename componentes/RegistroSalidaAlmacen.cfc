<cfcomponent>
    
<cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="Editar" access="remote" returnformat="JSON">
        <cfargument name="RequisicionesConsultaAlmacen"     type="array" required="true"/>
        <cfargument name="InsumosSeriados"                  type="array" required="true"/>
        
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','RegistroSalidaAlmacen')#"
                          method="Editar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>

                <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','RegistroSalidaAlmacen')#"
                              method="listar"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO"/>              

                    <cfif Local.BRO.hasError()>
                            <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                            <cfset variables.ctrl.rollback()>
                        <cfelse>
                            <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                            <cfset variables.ctrl.setJson(Local.BRO.getData())>
                    </cfif>

                    <cfcatch type="any">
                        <cfset variables.ctrl.setCatch(cfcatch)>
                        <cfset variables.ctrl.rollback()>
                    </cfcatch>
                </cftry>            
            </cftransaction>
            <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- funcion para generacion del pdf julio cesar acosta lopez 17/08/2015 --->
    <cffunction name="generarPDF" access="remote" returnformat="JSON">
        <cfargument name='insumos'          type='array'  required='true'>
        <cfargument name='insumosseriados'  type='array'  required='true'>
        <cfargument name='id'               type='string'  required='true'>
            
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','RegistroSalidaAlmacen')#"
                          method="generarPDF"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>                            
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>

            <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

</cfcomponent>