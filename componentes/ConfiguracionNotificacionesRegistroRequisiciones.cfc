<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 22/01/2015
          Obtiene la configuracion de notificaciones para la sucursal y departamento especificados --->
    <cffunction name="getConfiguracionPorDepartamento" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"           type="numeric" required="true"/>
        <cfargument name="id_departamento"       type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionNotificacionesRegistroRequisiciones')#"
                          method="getConfiguracionPorDepartamento"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery()) >
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 26/01/2015
          Borra la configuracion especificada por el id --->
    <cffunction name="deleteById" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"     type="numeric" required="true"/>
        <cfargument name="id_puesto"       type="numeric" required="true"/>
        <cfargument name="id_departamento" type="numeric" required="true"/>
        <cfargument name="id_notificacion" type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionNotificacionesRegistroRequisiciones')#"
                          method="deleteById"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 05/03/2015
          Obtiene la configuracion de notificaciones para el empleado especificado --->
    <cffunction name="getByEmpleado" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal" type="numeric" required="true"/>
        <cfargument name="id_empleado" type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionNotificacionesRegistroRequisiciones')#"
                          method="getByEmpleado"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery()) >
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 05/03/2015
          Obtiene la configuracion de notificaciones para el empleado especificado --->
    <cffunction name="Configurar" access="remote" returnformat="JSON">
        <cfargument name="empleadosNotificar" type="array" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionNotificacionesRegistroRequisiciones')#"
                          method="Configurar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 05/03/2015
          Obtiene el listado de configuraciones --->
    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_puesto" type="string" required="true"/>
        <cfargument name="id_empleado" type="string" required="true"/>
        <cfargument name="id_departamento" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionNotificacionesRegistroRequisiciones')#"
                          method="listar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery()) >
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