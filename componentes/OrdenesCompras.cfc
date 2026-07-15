<cfcomponent>

<cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_OrdenCompra"                type="string" required="false" default=""/>
        <cfargument name="id_SucursaListado"             type="string" required="false" default=""/>
        <cfargument name="fh_InicioListado"              type="string" required="false" default=""/>
        <cfargument name="fh_FinListado"                 type="string" required="false" default=""/>
        <cfargument name="id_DepartamentoListado"        type="string" required="false" default=""/>
        <cfargument name="id_EstatusAutorizacionListado" type="string" required="false" default=""/>
        <cfargument name="id_EstatusSurtidoListado"      type="string" required="false" default=""/>
        <cfargument name="nu_Siniestro"                  type="string" required="false" default=""/>
        <cfargument name="id_TipoDocumento"              type="string" required="false" default=""/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
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


    <cffunction name="Editar" access="remote" returnformat="JSON">
        <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="false"/>
        <cfargument name="Estatus"                  type="string"  required="true"/>
        <cfargument name="de_Observaciones"         type="string"  required="true"/>
        <cfargument name="OrdenesCompras"           type="array"   required="false"/>
        <cfargument name="OrdenesServicio"          type="array"   required="false"/>
        <cfargument name="id_CotizacionReporte"     type="string"  required="false"/>
        <cfargument name="id_almacen"               type="string"  required="false"/>
        <cfargument name="id_almacenActual"         type="string"  required="false"/>
        <cfargument name="mRechazo"                 type="string"  required="false" default=""/>
        <cfargument name="sn_CorreoProveedor"       type="string"  required="false" default="true"/>

            <cfset var Local.result=structNew()>

            <cftransaction>
                <cftry>
                   <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
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

    <cffunction name="EditarOC_SF" access="remote" returnformat="JSON">
        <cfargument name="id_OrdenCompra"     type="numeric" required="true"/>
        <cfargument name="Estatus"            type="string"  required="true"/>
        <cfargument name="OrdenesCompras"     type="array"   required="false"/>
        <cfargument name="OrdenesServicio"    type="array"   required="false"/>
        <cfargument name="id_almacen"         type="string"  required="false"/>
        <cfargument name="SolicitudesFac"     type="array"   required="false"/>
        <cfargument name="sn_CorreoProveedor" type="string"  required="false" default="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                    method="EditarOC_SF"
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

    <cffunction name="DescargarDocumento" access="public" output="true">
        <cfargument name='direccion'    type='string'  required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                          method="DescargarDocumento"
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

    <cffunction name="listar_OrdenesCompraServicios" access="remote" returnformat="JSON">
            <cfargument name="id_proveedor"         type="string" required="false"/>
            <cfargument name="fh_inicio"            type="string" required="false"/>
            <cfargument name="fh_fin"               type="string" required="false"/>
            <cfargument name="id_Usuario"           type="string" required="false"/>
            <cfargument name="nu_Siniestro"         type="string" required="false"/>
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                              method="listar_OrdenesCompraServicios"
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

    <!--- Victor Sanchez
            16/10/2015 --->
    <cffunction name="agregarGastoMovimiento" access="remote" returnformat="JSON">
        <!--- <cfargument name="id_Empresa"                         type="numeric" required="true"/> --->
        <cfargument name="fh_Movimiento"                    type="string" required="true"/>
        <cfargument name="fl_FacturaRemision"               type="string" required="false"/>
        <cfargument name="fh_FacturaRemision"               type="string" required="true"/>
        <cfargument name="im_TotalMN"                       type="string" required="true"/>
        <cfargument name="de_Entrego"                       type="string" required="no"/>
        <cfargument name="id_OrdenCompra"                   type="string" required="true"/>
        <cfargument name="de_Comentarios"                   type="string" required="no"/>
        <cfargument name="id_UsuarioRegistroMovimiento"     type="string" required="true"/>
        <cfargument name="fh_Registro"                      type="string" required="true"/>
        <cfargument name="insumos"                          type="array" required="true"/>
        <cfargument name="id_TipoDivision"                  type="string" required="false"/>
        <cfargument name="id_EmpresaRequisicion"            type="string" required="false"/>
        <cfargument name="id_UsuarioSolicita"               type="string" required="false"/>
        <cfargument name="id_Requisicion"                   type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"               type="string" required="false"/>
        <cfargument name="de_emailProveedor"                type="string" required="false"/>

            <cfset var Local.result=structNew()>

            <cftransaction>
                <cftry>
                   <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                              method="agregarGastoMovimiento"
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


    <cffunction name="listarCentrosCostos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="false" default=""/>
        <cfargument name="id_OrdenCompra" type="string" required="false" default=""/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesCompras')#"
                          method="listarCentrosCostos"
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
