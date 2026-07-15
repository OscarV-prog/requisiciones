<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 22/01/2015
          Guarda la configuracion de autorizacion y notificaciones para la sucursal y departamento especificados --->
    <cffunction name="Configurar" access="remote" returnformat="JSON">
        <cfargument name="id_configuracionautorizacionrequisicion"   type="string" required="true"/>
        <cfargument name="id_tipodivision"   type="string" required="true"/>
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_puesto"         type="string" required="true"/>
        <cfargument name="id_empleado"       type="string" required="true"/>
        <cfargument name="id_Nivel"          type="string" required="false"/>
        <cfargument name="sn_JefeImediato"   type="string" required="false"/>
        <cfargument name="sn_Activo"         type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"   type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="Configurar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
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
          Fecha: 22/01/2015
          Obtiene la configuracion de autorizaciones para la sucursal y departamento especificados --->
    <cffunction name="getConfiguracionPorDepartamento" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"           type="numeric" required="true"/>
        <cfargument name="id_departamento"       type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="getConfiguracionPorDepartamento"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
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
          Fecha: 03/03/2015
          Obtiene la configuracion de autorizaciones para el empleado --->
    <cffunction name="getByEmpleado" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"  type="numeric" required="true"/>
        <cfargument name="id_empleado"  type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="getByEmpleado"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
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
          Fecha: 22/01/2015
          Obtiene la configuracion de autorizaciones para la sucursal y departamento especificados --->
    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"      type="string" required="false">
        <cfargument name="id_puesto"        type="string" required="false">
        <cfargument name="id_empleado"      type="string" required="false">
        <cfargument name="id_tipodivision"  type="string" required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="listar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
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
          Fecha: 04/03/2015
          Elimina un registro de la configuracion --->
    <cffunction name="eliminar" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal" type="string" required="true">
        <cfargument name="id_puesto"   type="string" required="true">
        <cfargument name="id_empleado" type="string" required="true">
        <cfargument name="id_departamento" type="string" required="true">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="eliminar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Registro eliminado con exito")>
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
          Fecha: 04/03/2015
          Actualiza la informacion del numero de orden --->
    <cffunction name="actualizar" access="remote" returnformat="JSON">
        <cfargument name="empleadosAutorizan"    type="array"   required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="actualizar"
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
          Fecha: 06/03/2015
          Obtiene los empleados configurados para autorizar en el departamento especificado --->
    <cffunction name="getEmpleadosByDepartamento" access="remote" returnformat="JSON">
        <cfargument name="id_departamento"  type="string"   required="true"/>
        <cfargument name="id_empleado"      type="string"   required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="getEmpleadosByDepartamento"
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

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 06/03/2015
          Reasigna las requisiciones pendientes por autorizar al nuevo empleado y
          Elimina el empleado de la configuracion de autorizacion de requisiciones --->
    <cffunction name="borrarEmpleado_reasignarRequisiciones" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"              type="string" required="true">
        <cfargument name="id_puesto"                type="string" required="true">
        <cfargument name="id_empresaEmpleado"       type="string" required="true">
        <cfargument name="id_empleado"              type="string" required="true">
        <cfargument name="id_departamento"          type="string" required="true">
        <cfargument name="id_empresaEmpleadoNuevo"  type="string" required="true">
        <cfargument name="id_empleadoNuevo"         type="string" required="true">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="borrarEmpleado_reasignarRequisiciones"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Registro eliminado con exito")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Omar Ibarra, 01/06/2017, Obtener nivel por empresa, sucursal y tipo de division--->
    <cffunction name="ObtenerNivelConfAutorizacionRequisicion" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"           type="string" required="false"/>
        <cfargument name="id_tipoDivision"       type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                          method="ObtenerNivelConfAutorizacionRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>
                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="Editar" access="remote" returntype="struct" returnformat="JSON" >
        <cfargument name="id_configuracionautorizacionrequisicion"  type="string" required="true"/>
        <cfargument name="id_tipodivision"                          type="string" required="true"/>
        <cfargument name="id_sucursal"                              type="string" required="false"/>
        <cfargument name="id_puesto"                                type="string" required="true"/>
        <cfargument name="id_empleado"                              type="string" required="true"/>
        <cfargument name="id_Nivel"                                 type="string" required="false"/>
        <cfargument name="sn_JefeImediato"                          type="string" required="false"/>
        <cfargument name="sn_Activo"                                type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"                           type="string" required="false"/>
    
          <cftransaction>
              <cftry>
                  <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionAutorizacionRequisiciones')#"
                              method="Editar"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO">
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

</cfcomponent>