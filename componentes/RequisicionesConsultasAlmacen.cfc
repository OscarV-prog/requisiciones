RequisicionesConsultasAlmacen<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    
    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"          type="string" required="false"/>
        <cfargument name="fh_Inicio"               type="string" required="false"/>
        <cfargument name="fh_Final"                type="string" required="false"/>
        <cfargument name="nu_tipoFecha"            type="string" required="false"/>
        <cfargument name="id_EstatusAutorizacion"  type="string" required="false"/>
        <cfargument name="id_EstatusSurtido"       type="string" required="false"/>
        <cfargument name="id_SolicitadoCompras"    type="string" required="false"/>
        <cfargument name="id_OrdenDeCompra"        type="string" required="false"/>
        <cfargument name="id_SolicitudCompra"      type="string" required="false"/>
        <cfargument name="id_Empleado"             type="string" required="false"/>
        <cfargument name="id_EmpresaEmpleado"      type="string" required="false"/>
        
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','RequisicionesConsultasAlmacen')#"
                          method="listar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>  

                        <!---  <cfdump var="#local.BRO#"><cfabort> --->

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

    <cffunction name="Editar" access="remote" returnformat="JSON">
        <cfargument name="Requisiciones"     type="array"    required="true"/>
        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','RequisicionesConsultasAlmacen')#"
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

    <cffunction name="EditardesdeDetalleRequisicion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"          type="numeric"    required="true"/>
        <cfargument name="id_Requisicion"      type="numeric"    required="true"/>
        <cfargument name="Identificador"       type="string"    required="true"/>
        <cfargument name="de_Observaciones"    type="string"    required="true"/>
        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','RequisicionesConsultasAlmacen')#"
                          method="EditardesdeDetalleRequisicion"
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

    <cffunction name="listarStatus" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','RequisicionesConsultasAlmacen')#"
                          method="listarStatus"
                         <!---  argumentcollection="#arguments#" --->
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

    <cffunction name="generarExcel" access="remote" returnformat="JSON">
      <cfargument name="id_Requisicion"             type="string" required="false" default=""/>
      <cfargument name="id_EstatusSurtido"          type="string" required="false" default=""/>
      <cfargument name="id_EstatusAutorizacion"     type="string" required="false" default=""/>
      <cfargument name="sn_SolicitadoCompras"       type="string" required="false" default=""/>
      <cfargument name="fh_Inicio"                  type="string" required="false" default=""/>
      <cfargument name="fh_Fin"                     type="string" required="false" default=""/>
      <cfargument name="nu_tipoFecha"               type="string" required="false" default=""/>
      <cfargument name="id_EmpresaEmpleado"         type="string" required="false" default=""/>
      <cfargument name="id_Empleado"                type="string" required="false" default=""/>
        
        
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>
        
        <cfif #arguments.sn_SolicitadoCompras# NEQ 0>
            <cfif #arguments.sn_SolicitadoCompras# EQ 1>
                <cfset arguments.sn_SolicitadoCompras = 404>
            </cfif>
            <cfif #arguments.sn_SolicitadoCompras# EQ 2>
                <cfset arguments.sn_SolicitadoCompras = 403>
            </cfif>
        </cfif>
        <!--- <cfdump var="#arguments#">
        <cfabort> --->
        <!--- <cftransaction> --->
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','RequisicionesConsultasAlmacen')#"
                      method="generarExcel"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>                            
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>            
        <!--- </cftransaction>         --->
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>
</cfcomponent>