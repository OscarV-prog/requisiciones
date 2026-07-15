<cfcomponent>
    
<cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

<cffunction name="agregar" access="remote" returnformat="JSON">
    <cfargument name="de_ClasificadoRequisicion"    type="string" required="true"/>
    <cfargument name="id_TipoRequisicion"           type="numeric" required="true"/>
    <cfargument name="sn_Activo"                    type="string" required="false"/>    
    

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','ClasificadosRequisicion')#"
                          method="agregar"
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
    



    <cffunction name="editar" access="remote" returnformat="JSON">
    <cfargument name="id_ClasificadoRequisicion"    type="numeric" required="true"/>    
    <cfargument name="de_ClasificadoRequisicion"    type="string" required="true"/>
    <cfargument name="id_TipoRequisicion"           type="numeric" required="true"/>
    <cfargument name="sn_Activo"                    type="string" required="false"/>    
    
      <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>

                    <cfinvoke component="#Application.RF.getPath('bro','ClasificadosRequisicion')#"
                              method="editar"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        <cfreturn  variables.ctrl.toStruct()/>

    </cffunction>


    

<cffunction name="eliminar" access="remote" returnformat="JSON">
    <cfargument name="id_ClasificadoRequisicion" type="numeric" required="true"/>
    
      <cfset var Local.result=structNew()>
        <cftransaction>
            <cftry>
              <cfinvoke component="#Application.RF.getPath('bro','ClasificadosRequisicion')#"
                          method="eliminar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>
                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>

        <cfreturn  variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listar" access="remote" returnformat="JSON">
    <cfargument name="id_ClasificadoRequisicion"   type="string" required="false"/>
    <cfargument name="de_ClasificadoRequisicion"   type="string" required="false"/>
    <cfargument name="id_TipoRequisicion"          type="string" required="false"/>
    <cfargument name="sn_Activo"                   type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ClasificadosRequisicion')#"
                          method="listar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listar_TiposRequisicion" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ClasificadosRequisicion')#"
                          method="listar_TiposRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

</cfcomponent>