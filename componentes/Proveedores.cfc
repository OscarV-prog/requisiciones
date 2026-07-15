<cfcomponent>

<cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    <cffunction name="GetProveedorPemex" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="GetProveedorPemex"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listar_ProveedoresTiposComprobantes" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="true">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listar_ProveedoresTiposComprobantes"
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

    <cffunction name="listarProveedoresSn_Transorte" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="string" required="false" default=""/>
        <cfargument name="sn_Transporte" type="string" required="false" default=""/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                              method="listarProveedoresSn_Transorte"
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

    <cffunction name="listarProveedoresSn_TallerMecanico" access="remote" returnformat="JSON">
        <cfargument name="sn_TallerMecanico" type="string" required="false" default=""/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                            method="listarProveedoresSn_TallerMecanico"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listar_TiposComprobantes" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listar_TiposComprobantes"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="agregar" access="remote" returnformat="JSON">
        <cfargument name="nb_Proveedor"                      type="string" required="true"/>
        <!--- <cfargument name="de_Email"                    type="string" required="false"/> --->
        <cfargument name="de_RazonSocial"                    type="string" required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric"required="false"/>
        <cfargument name="de_RFC"                            type="string" required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric"required="false"/>
<!---       <cfargument name="de_Direccion"                  type="string" required="false"/> --->
        <cfargument name="id_TipoProveedor"                  type="numeric"required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string" required="false"/>
        <!--- <cfargument name="nb_Contacto"                 type="string" required="false"/> --->
        <cfargument name="nu_CuentaBancaria"                 type="string"required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string"required="false"/>
        <cfargument name="sn_Borrado"                        type="string"required="false"/>
        <cfargument name="Contactos"                         type="array" required="true"/>
        <cfargument name="referencia"                        type="string"required="false"/>
        <cfargument name="sn_Extranjero"                     type="string"required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string"required="false"/>
        <!--- Direccion --->
        <cfargument name="sn_Transporte"                     type="string"required="false"/>
        <cfargument name="sn_Grupo"                          type="string"required="false"/>
        <cfargument name="sn_Suministro"                     type="string"required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string"required="false"/>
        <cfargument name="id_Pais"                           type="string"required="false"/>
        <cfargument name="id_estado"                         type="string"required="false"/>
        <cfargument name="id_municipio"                      type="string"required="false"/>
        <cfargument name="localidad"                         type="string"required="false"/>
        <cfargument name="colonia"                           type="string"required="false"/>
        <cfargument name="calle"                             type="string"required="false"/>

        <cfargument name="numero"                            type="string"required="false"/>
        <cfargument name="nu_Telefono"                       type="string"required="false"/>
        <cfargument name="nu_CodigoPostal"                   type="string"required="false"/>
        <cfargument name="nu_Fax"                            type="string"required="false"/>
        <cfargument name="imgLogo"                           type="string"required="false"/>
        <cfargument name="Cuentas"                           type="array" required="false"/>
        <cfargument name="TiposComprobantes"                 type="array" required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string"required="false"/>
        <cfargument name="nu_PermisoCRETransporte"           type="string"required="false"/>
        <cfargument name="nu_PermisoCRECombustible"          type="string"required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string"required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string"required="false"/>
        <cfargument name="sn_ProveedorCompra"                type="string"required="false"/>
        <!--- <cfargument name="adjuntarArchivo"                   type="file"required="false"/> --->
        <cfargument name="sn_RegimenConfianza"               type="string"required="false"/>
        <cfargument name="nb_Empleado"                       type="string"required="false"/>
        <cfargument name="fh_Registro"                       type="string"required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string"required="false"/>
        <cfargument name="sn_ProveedorGasLP"                 type="string"required="false"/>
        <cfargument name="ConceptosServicios"                type="array" required="false"/>
        <cfargument name="sn_rdioCMF"                        type="string" required="false"/>
        <cfargument name="sn_NoGenerarPruebaCalidad"         type="string" required="false"/>
        <cfargument name="nu_PermisoCRE"                     type="string" required="false"/>
        <cfargument name="id_TipoPermisoCRE"                 type="numeric" required="false"/>
        <cfargument name="id_DireccionRetiro"                type="numeric" required="false"/>
        <cfargument name="id_Plaza"                          type="numeric" required="false"/>
        <cfargument name="sn_Default"                        type="numeric" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Prorrateable"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>
        <cfset arguments.id_Empresa= session.ID_EMPRESA>

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="agregar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>

                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
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
        <cfargument name="id_Proveedor"                      type="numeric"required="false"/>
        <cfargument name="nb_Proveedor"                      type="string" required="true"/>
        <!--- <cfargument name="de_Email"               type="string" required="false"/> --->
        <cfargument name="de_RazonSocial"                    type="string" required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric"required="false"/>
        <cfargument name="de_RFC"                            type="string" required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric"required="false"/>
<!---       <cfargument name="de_Direccion"             type="string" required="false"/> --->
        <cfargument name="id_TipoProveedor"                  type="numeric"required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string" required="false"/>
        <!--- <cfargument name="nb_Contacto"                type="string" required="false"/> --->
        <cfargument name="nu_CuentaBancaria"                 type="string" required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string" required="false"/>
        <cfargument name="sn_Borrado"                        type="string" required="false"/>
        <cfargument name="Contactos"                         type="array"  required="true"/>
        <cfargument name="ContactosEliminar"                 type="array"  required="false"/>
        <cfargument name="referencia"                        type="string" required="false"/>
        <cfargument name="sn_Extranjero"                     type="string" required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string" required="false"/>
        <!--- Direccion --->
        <cfargument name="sn_Transporte"                     type="string" required="false"/>
        <cfargument name="sn_Grupo"                          type="string" required="false"/>
        <cfargument name="sn_Suministro"                     type="string" required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string" required="false"/>
        <cfargument name="id_Pais"                           type="string" required="false"/>
        <cfargument name="id_estado"                         type="string" required="false"/>
        <cfargument name="id_municipio"                      type="string" required="false"/>
        <cfargument name="localidad"                         type="string" required="false"/>
        <cfargument name="colonia"                           type="string" required="false"/>
        <cfargument name="calle"                             type="string" required="false"/>
        <cfargument name="numero"                            type="string" required="false"/>
        <cfargument name="nu_Telefono"                       type="string" required="false"/>
        <cfargument name="nu_CodigoPostal"                   type="string" required="false"/>
        <cfargument name="nu_Fax"                            type="string" required="false"/>
        <cfargument name="imgLogo"                           type="string" required="false"/>
        <cfargument name="TiposComprobantes"                 type="array"  required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string" required="false"/>
        <cfargument name="nu_PermisoCRETransporte"           type="string" required="false"/>
        <cfargument name="nu_PermisoCRECombustible"          type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string" required="false"/>
        <cfargument name="sn_ProveedorCompra"                type="string" required="false"/>
        <!--- <cfargument name="Cuentas"                           type="array"  required="false"/> --->
        <cfargument name="sn_RegimenConfianza"               type="string"required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string"required="false"/>
        <cfargument name="sn_ConsultaPortalCRE"              type="string"required="false"/>
        <cfargument name="sn_ProveedorGasLP"                 type="string" required="false"/>
        <cfargument name="ConceptosServicios"                type="array" required="false"/>
        <cfargument name="sn_rdioCMF"                        type="string" required="false"/>
        <cfargument name="sn_NoGenerarPruebaCalidad"         type="string" required="false"/>
        <cfargument name="nu_PermisoCRE"                     type="string" required="false"/>
        <cfargument name="id_ProveedorPermiso"               type="numeric" required="false"/>
        <cfargument name="id_TipoPermisoCRE"                 type="numeric" required="false"/>
        <cfargument name="id_DireccionRetiro"                type="numeric" required="false"/>
        <cfargument name="id_Plaza"                          type="numeric" required="false"/>
        <cfargument name="sn_Default"                        type="numeric" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Prorrateable"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>
        <cfargument name="de_EmailProveedor"                 type="string" required="false"/>
        <cfargument name="id_EmpresaSILT"                    type="numeric" required="false"/>
        <cfargument name="sn_suspendido"                     type="string" required="false"/>
        <cfargument name="de_MotivoSuspension"                   type="string" required="false"/>
        <cfargument name="id_UsuarioSupendio"                 type="string" required="false"/>
        <cfargument name="fh_suspension"                     type="string" required="false"/>
        <cfset arguments.id_Empresa= session.ID_EMPRESA>

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="editar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                          <!--- <cfdump var="#Local.BRO.hasError()#"> --->
                          <!--- <cfabort> --->

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

    <!---   <cfdump var="#variables.ctrl.toStruct()#"> --->

        <cfreturn  variables.ctrl.toStruct()/>

    </cffunction>


    <cffunction name="eliminar" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="true"/>

          <cfset var Local.result=structNew()>
            <cftransaction>
                <cftry>
                  <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
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


    <!--- function para listar los empleados --->
    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"            type="string" required="false"/>
        <cfargument name="nb_Proveedor"            type="string" required="false"/>
        <cfargument name="id_TipoProveedor"        type="string" required="false"/>
        <cfargument name="page"                    type="string" required="false" default=""/>
        <cfargument name="pageSize"                type="string" required="false" default=""/>
        <cfargument name="sn_ProveedorCombustible" type="string" required="false" />
        <cfargument name="sn_ProveedoresPago"      type="string" required="false" />

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listar2" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="nb_Proveedor"     type="string" required="false"/>
        <cfargument name="id_TipoProveedor" type="string" required="false"/>
        <cfargument name="page"             type="string" required="false" default=""/>
        <cfargument name="pageSize"         type="string" required="false" default=""/>
        <cfargument name="sn_ProveedorCombustible"         type="string" required="false" />

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listar2"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- function para listar los empleados --->
    <cffunction name="listarCatalogo" access="public" returntype="Any">
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="nb_Proveedor"     type="string" required="false"/>
        <cfargument name="id_TipoProveedor" type="string" required="false"/>
        <cfargument name="page"             type="string" required="false" default=""/>
        <cfargument name="pageSize"         type="string" required="false" default=""/>
        <cfargument name="de_RFC"           type="string" required="false"/>
        <cfargument name="sn_Transporte"    type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible" type="string" required="false"/>
        <cfargument name="sn_Reporte"       type="boolean"required="no" default="0"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarCatalogo"
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

    <!---
        Victor Sanchez
        04/01/2015
        Lista los proveedores transportistas
      --->
    <cffunction name="upR_ProveedoresTransportistas" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="upR_ProveedoresTransportistas"
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

    <cffunction name="listarContactosProveedores" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"       type="string" required="true"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarContactosProveedores"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!--- function para listar los empleados --->
    <cffunction name="Cmb_TiposProveedores" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="Cmb_TiposProveedores"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listarProveedoresCombo" access="remote" returnformat="JSON">
        <cfargument name="sn_ProveedorCombustible"  type="string"  required="false"/>
        <cfargument name="sn_Extranjero"            type="string"  required="false"/>
        <cfargument name="sn_CargaMasiva"           type="numeric" required="false"/>
        <cfargument name="sn_Pemex"                 type="numeric" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarProveedoresCombo"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarProveedoresComboTranspCombustible" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarProveedoresComboTranspCombustible"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarTelefonoProveedor" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"    type="numeric"     required="true"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarTelefonoProveedor"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <!--- <cfset variables.ctrl.setQuery(Local.BRO.getQuery())> --->
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
                <cfset variables.ctrl.rollback()>
            </cfcatch>
        </cftry>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listarProveedoresAutoComplete" access="remote" returnformat="JSON">
      <cfargument name="id_Proveedor"            type="string"       required="false"/>
      <cfargument name="nb_Proveedor"            type="string"       required="false"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarProveedoresAutoComplete"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listarProveedoresTransporteAutoComplete" access="remote" returnformat="JSON">
      <cfargument name="id_Proveedor"            type="string"       required="false"/>
      <cfargument name="nb_Proveedor"            type="string"       required="false"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="listarProveedoresTransporteAutoComplete"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!--- Autor: Rey David Dominguez
          Fecha: 19/02/2015
          Listado para el reporte de proveedores ordenes de compras --->
    <cffunction name="reporteProveedoresOrdenesCompra" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"         type="string" required="false"/>
        <cfargument name="id_Proveedor"        type="string" required="false"/>
        <cfargument name="id_Departamento"     type="string" required="false"/>
        <cfargument name="id_Almacen"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_NombreInsumo"     type="string" required="false"/>
        <cfargument name="id_tipoRequisicion"  type="string" required="false"/>
        <cfargument name="fh_inicio"           type="string" required="false"/>
        <cfargument name="fh_fin"              type="string" required="false"/>
        <cfargument name="cl_tipoReporte"      type="string" required="false"/>
        <cfargument name="nb_sucursal"         type="string" required="false"/>
        <cfargument name="nb_proveedor"        type="string" required="false"/>
        <cfargument name="nb_Departamento"     type="string" required="false"/>
        <cfargument name="nb_Almacen"          type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_Insumo"           type="string" required="false"/>
        <cfargument name="de_tipoRequisicion"  type="string" required="false"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="reporteProveedoresOrdenesCompra"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!--- Autor: GCP
          Fecha: 02/10/2015
          Listado para el reporte de proveedores ordenes de compras con detalle --->
    <cffunction name="reporteProveedoresOrdenesCompraDetalle" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"         type="string" required="false"/>
        <cfargument name="id_Proveedor"        type="string" required="false"/>
        <cfargument name="id_Departamento"     type="string" required="false"/>
        <cfargument name="id_Almacen"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_NombreInsumo"     type="string" required="false"/>
        <cfargument name="id_tipoRequisicion"  type="string" required="false"/>
        <cfargument name="fh_inicio"           type="string" required="false"/>
        <cfargument name="fh_fin"              type="string" required="false"/>
        <cfargument name="cl_tipoReporte"      type="string" required="false"/>
        <cfargument name="nb_sucursal"         type="string" required="false"/>
        <cfargument name="nb_proveedor"        type="string" required="false"/>
        <cfargument name="nb_Departamento"     type="string" required="false"/>
        <cfargument name="nb_Almacen"          type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_Insumo"           type="string" required="false"/>
        <cfargument name="de_tipoRequisicion"  type="string" required="false"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="reporteProveedoresOrdenesCompraDetalle"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="agregarDispersion" access="remote" returnformat="JSON">
        <cfargument name="id_CuentaBancaria"    type="string"   required="true"/>
        <cfargument name="im_TotalDispersion"   type="string"   required="true"/>
        <cfargument name="fh_DiaPago"           type="string"   required="true"/>
        <cfargument name="fh_DiaOperacion"      type="string"   required="true"/>
        <cfargument name="id_Moneda"            type="string"   required="true"/>
        <cfargument name="im_TipoCambio"        type="string"   required="true"/>
        <cfargument name="Detalle"              type="array"   required="true"/>
        <cfargument name="Dispersion"           type="array"   required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="agregarDispersion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <!---   <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!---
        Victor Sanchez
        12/02/2016
        Edita una dispersion
     --->
    <cffunction name="editarDispersion" access="remote" returnformat="JSON">
        <cfargument name="id_CuentaBancaria"    type="string" required="true"/>
        <cfargument name="im_TotalDispersion"   type="string" required="true"/>
        <cfargument name="fh_DiaPago"           type="string" required="true"/>
        <cfargument name="fh_DiaOperacion"      type="string" required="true"/>
        <cfargument name="id_Moneda"            type="string" required="true"/>
        <cfargument name="im_TipoCambio"        type="string" required="true"/>
        <cfargument name="id_Dispersion"        type="string" required="true"/>
        <cfargument name="Detalle"              type="array"  required="true"/>
        <cfargument name="Dispersion"           type="array"  required="true"/>
        <cfargument name="DocumentosPERechazar" type="array"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="editarDispersion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <!---   <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!---
        Victor Sanchez
        12/02/2016
     --->
    <cffunction name="listar_DispersionesProveedores" access="remote" returnformat="JSON">
        <cfargument name="id_Dispersion"       type="string" required="no">
        <cfargument name="fh_Operacion"        type="string" required="no">
        <cfargument name="id_CuentaBancaria"   type="string" required="no">
        <cfargument name="id_Moneda"           type="string" required="no">
        <cfargument name="id_TipoBeneficiario" type="string" required="no">
        <cfargument name="id_Proveedor"        type="string" required="no">
        <cfargument name="id_DeudorDiverso"    type="string" required="no">
        <cfargument name="id_AcreedorDiverso"  type="string" required="no">
        <cfargument name="fh_Pago"             type="string" required="no">

        <cftry>
            <cfinvoke component="#Application.RF.getPath("bro","Proveedores")#"
                method="listar_DispersionesProveedores"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="upR_DispersionBanProveedor" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'           type='string'   required='false' default=''>
        <cfargument name='id_Sucursal'          type='string'   required='false' default=''>
        <cfargument name='id_Dispersion'        type='string'   required='false' default=''>
        <cfargument name='id_Proveedor'         type='string'   required='false' default=''>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="upR_DispersionBanProveedor"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!---
        Victor Sanchez
        12/02/2016
     --->
    <cffunction name="listar_DispersionesDetalle" access="remote" returnformat="JSON">
        <cfargument name='id_Dispersion'        type='string'   required='yes'>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listar_DispersionesDetalle"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="generarTXT" access="remote" returnformat="JSON">
        <cfargument name="id_Dispersion"        type="string"   required="true"/>
        <cfargument name="CL_CODIGOABM"         type="string"   required="true"/>
        <cfargument  name="id_CuentaBancaria" type="numeric" required="false">
        <cfargument  name="ID_MONEDA" type="numeric" required="false">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="generarTXT"
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
                    <cfset variables.ctrl.rollback()>
                    <cfset variables.ctrl.setCatch(cfcatch)>

                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 13-02-2016  --->
    <cffunction name="guardaremisiondepago" access="remote" returnformat="JSON">
        <cfargument name="prov"                type="struct"  required="false">
        <cfargument name="id_DeudorDiverso"    type="string"  required="false">
        <cfargument name="de_DeudorDiverso"    type="string"  required="false">
        <cfargument name="id_AcreedorDiverso"  type="string"  required="false">
        <cfargument name="de_AcreedorDiverso"  type="string"  required="false">
        <cfargument name="cb"                  type="struct"  required="yes">
        <cfargument name="pago"                type="struct"  required="yes">
        <cfargument name="fh_pago"             type="string"  required="yes">
        <cfargument name="nu_cheque"           type="string"  required="false">
        <cfargument name="facturas"            type="array"   required="yes">
        <cfargument name="notas"               type="array"   required="yes">
        <cfargument name="anticipos"           type="array"   required="no">
        <cfargument name="im_TotalMovBancario" type="numeric" required="yes">
        <cfargument name="im_Totalpago"        type="numeric" required="yes">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath("bro","Proveedores")#"
                    method="guardaremisiondepago"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
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

    <!--- jc funcion que genera el excel de la pantalla de emision de pagos --->
    <cffunction name="generarexcelemisiondepagos" access="remote" returnformat="JSON">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="false"/>

        <!--- <cftransaction> --->
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="generarexcelemisiondepagos"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <!--- <cfset variables.ctrl.rollback()> --->
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <!--- <cfset Variables.ctrl.setJson(Local.BRO.getData())> --->
                        <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <!--- <cfset variables.ctrl.rollback()> --->
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <!--- </cftransaction> --->
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc funcion que genera el pdf de la pantalla de emision de pagos --->
    <cffunction name="generarpdfemisiondepagos" access="remote" returnformat="JSON">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="false"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="generarpdfemisiondepagos"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 17-02-2016 devuelve la informacion de un pago en especifico de un proveedor --->
    <cffunction name="getinformacionemisionpago" access="remote" returnformat="JSON">
        <cfargument name="data"     type="struct" required="true"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="getinformacionemisionpago"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 18-02-2016  --->
    <cffunction name="guardaremisiondepagosincheque" access="remote" returnformat="JSON">
        <cfargument name='prov'             type='struct'   required='yes'>
        <cfargument name='moneda'               type='struct'   required='yes'>
        <cfargument name='fh_pago'          type='string'   required='yes'>
        <cfargument name='facturas'         type='array'    required='yes'>
        <cfargument name='notas'            type='array'    required='yes'>
        <cfargument name='anticipos'        type='array'    required='no'>
        <cfargument name='im_TotalMovBancario'  type='numeric'  required='yes'>
        <cfargument name='im_Totalpago'     type='numeric'  required='yes'>
        <cfargument name='id_cuenta'            type='numeric'  required='yes'>
        <cfargument name='id_scuenta'           type='numeric'  required='yes'>
        <cfargument name='id_sscuenta'          type='numeric'  required='yes'>
        <cfargument name='id_ssscuenta'         type='numeric'  required='yes'>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="guardaremisiondepagosincheque"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJSON(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc funcion que genera el excel de la pantalla de emision de pagos sin cheque --->
    <cffunction name="generarexcelemisiondepagossincheque" access="remote" returnformat="JSON">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="true"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="generarexcelemisiondepagossincheque"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc funcion que genera el pdf de la pantalla de emision de pagos sin cheque --->
    <cffunction name="generarpdfemisiondepagossincheque" access="remote" returnformat="JSON">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="true"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="generarpdfemisiondepagossincheque"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 19-02-2016 devuelve la información para el modal del detalle de la pantalla de emision detalle visualizar --->
    <cffunction name="getinfodetalle" access="remote" returnformat="JSON">
        <cfargument name="data"     type="struct" required="true"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="getinfodetalle"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 19-02-2016 cancela la emision de un pago --->
    <cffunction name="cancelaremisionpago" access="remote" returnformat="JSON">
        <cfargument name="data"     type="struct" required="true"/>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="cancelaremisionpago"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc  20-02-2016 imprime el cheque de la emision de pago --->
    <cffunction name="imprimircheque" access="remote" returnformat="JSON">
        <cfargument name="id_pc"    type="string" required="true"/>
        <cfargument name="formato"  type="numeric" required="true"/>
        <cfargument name="leyenda"  type="string" required="false"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="imprimircheque"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc  20-02-2016 imprime el cheque de la cancelacion de un pago --->
    <cffunction name="imprimirchequecancelacion" access="remote" returnformat="JSON">
        <cfargument name="id_polizacancel"  type="numeric"  required="true"/>
        <cfargument name="leyenda"          type="string" required="false"/>
        <cfargument name="id_formato"       type="numeric" required="true"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="imprimirchequecancelacion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarProveedoresCuentasContables" access="remote" returnformat="JSON">
        <cfargument name="id_Moneda"    type="string" required="false">
        <cfargument name="id_proveedor" type="string" required="false">
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listarProveedoresCuentasContables"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!--- jc 2016.02.24 imprimir póliza de generacion de pago sin cheque--->
    <cffunction name="imprimirpolizachequesinpago" access="remote" returnformat="JSON">
        <cfargument name="id_pago"          type="string"       required="false"/>
        <cfargument name="id_poliza"        type="string"       required="false"/>
        <cfargument name="opc"              type="numeric"      required="true"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="imprimirpolizachequesinpago"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJSON(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- jc 2016.04.27 listado de las programaciones de pago--->
    <cffunction name="listarprogramacionpagos" access="remote" returnformat="JSON">
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>
        <cfargument name="id_Proveedor"     type="string"       required="false"/>
        
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listarprogramacionpagos"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa.")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarprogramacionpagosEmpresas" access="remote" returnformat="JSON">
        <cfargument name="Empresas"         type="string"       required="false"/>
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listarprogramacionpagosEmpresas"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa.")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="AyudaProveedores" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Proveedor"       type="string" required="false"/>
        <cfargument name="nb_Proveedor"       type="string" required="false"/>
        <cfargument name="id_TipoProveedor"   type="string" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="AyudaProveedores"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="obtenerproveedor" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"       type="string" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="obtenerproveedor"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="obtenerProveedorRFC" access="remote" returnformat="JSON">
        <cfargument name="de_rfc"       type="string" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="obtenerProveedorRFC"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="validarGenerarOC" access="remote" returnformat="JSON">
        <cfargument name="id_proveedor"       type="string" required="false"/>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="validarGenerarOC"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
                <cfset variables.ctrl.rollback()>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="obtenerCuentasBancarias" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"     type="numeric" required="false"/>
        <cfargument name="id_Moneda"        type="numeric" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="obtenerCuentasBancarias"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>
    <cffunction name="obtenerCuentasBancariasReporte" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="id_CuentaBancaria"     type="string" required="false"/>
        <cfargument name="id_DeudorDiverso"     type="string" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="obtenerCuentasBancariasReporte"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>
                          <cfif Local.BRO.hasError()>
                            <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                            <cfset variables.ctrl.rollback()>
                        <cfelse>
                            <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                            <cfset variables.ctrl.setJSON(Local.BRO.getDATA())>
                    </cfif>

                    <cfcatch type="any">
                        <cfset variables.ctrl.setCatch(cfcatch)>
                        <cfset variables.ctrl.rollback()>
                    </cfcatch>
                </cftry>
            <cfreturn variables.ctrl.toStruct()/>
    </cffunction>
    <cffunction name="obtenerCuentasBancariasCombo" access="remote" returnformat="JSON">
            <cfargument name="id_Proveedor"     type="string" required="true"/>
            <cfargument name="id_Moneda"     type="string" required="false"/>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                              method="obtenerCuentasBancariasCombo"
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

            <cfreturn variables.ctrl.toStruct()/>
        </cffunction>

        <cffunction name="aplicarClasificacion" access="remote" returnformat="JSON">
            <cfargument name="id_Proveedor"     type="string" required="true"/>
            <cfargument name="id_Clasificacion"     type="string" required="false"/>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                              method="aplicarClasificacion"
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

            <cfreturn variables.ctrl.toStruct()/>
        </cffunction>

    <cffunction name="listarTransferenciasCombo" access="remote" returnformat="JSON">
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="listarTransferenciasCombo"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>
    <cffunction name="listaridentificadorCom" access="remote" returnformat="JSON">
      <cfset var Local = {} />
      <cftry>

        <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                  method="listaridentificadorCom"
                  argumentcollection="#arguments#"
                  returnvariable="Local.BRO" />

        <cfreturn {
          ISOK = true,
          MSG  = "Operación exitosa",
          identificadores = Local.BRO.identificadores,
          permiso = Local.BRO.permiso
        } />

        <cfcatch type="any">
          <cfreturn {
            ISOK = false,
            MSG = cfcatch.message,
            CFCATCH = cfcatch
          } />
        </cfcatch>

      </cftry>
    </cffunction>


    <cffunction name="editarCuentaBancaria" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"         type="numeric" required="true"/>
        <cfargument name="Cuentas"              type="array" required="true"/>
        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="editarCuentaBancaria"
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


    <cffunction name="editarCuentaBancariaReporteProveedores" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"          type="numeric" required="false"/>
        <cfargument name="ID_BANCO"             type="numeric" required="false"/>
        <cfargument name="NB_CUENTABANCARIA"    type="string" required="false"/>
        <cfargument name="NU_CLABEINTERBANCARIA"type="string" required="false"/>
        <cfargument name="ID_TIPOTRANSFERENCIA" type="string" required="false"/>
        <cfargument name="ID_MONEDA"            type="string" required="false"/>
        <cfargument name="ID_CUENTABANCARIA"    type="string" required="false"/>
        <cfargument name="NU_CUENTABANCARIA"    type="string" required="false"/>
        <!--- <cfargument name="ADJUNTARARCHIVO"      type="array" required="false"/> --->
        <cfargument name="NB_CLAVEPROVEEDOR"    type="string" required="false"/>


        <!--- <cfargument name="Cuentas"         type="array" required="false"/> --->
        <!--- <cfset var Local.result=structNew()> --->

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                method="editarCuentaBancariaReporteProveedores"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>
                <!--- <cfcontent type="text/html">
                <cfdump var="#Local.BRO#" label="cfc" abort="true"> --->

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>

                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn  variables.ctrl.toStruct()/>

    </cffunction>

    <cffunction name="resetCuentasContables" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"          type="numeric" required="false"/>
        <cfargument name="id_CuentaBancaria"     type="numeric" required="false"/>
        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#" label="arguments" abort="true"> --->
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                method="resetCuentasContables"
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
    <cffunction name="editarCuentaBancariaReporte" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"         type="numeric" required="true"/>
        <cfargument name="Cuentas"              type="array" required="true"/>
        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#" label="arguments" abort="true"> --->
        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="editarCuentaBancariaReporte"
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

    <!--- Jesus Reyes --->
    <cffunction name="ExcelDocumentosEmisionPago" access="remote" returnformat="JSON">
        <cfargument name="data" type="struct" required="false"/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="ExcelDocumentosEmisionPago"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.rollback()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.rollback()>
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiro" access="remote" returnformat="JSON">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="false"/>
        <cfargument name="ID_PAIS"              type="string" required="true"/>
        <cfargument name="ID_ESTADO"            type="string" required="true"/>
        <cfargument name="ID_MUNICIPIO"         type="string" required="true"/>
        <cfargument name="ID_LOCALIDAD"         type="string" required="true"/>
        <cfargument name="NB_COLONIA"           type="string" required="true"/>
        <cfargument name="NB_CALLE"             type="string" required="true"/>
        <cfargument name="DE_REFERENCIA"        type="string" required="false"/>
        <cfargument name="NU_EXTERIOR"          type="string" required="false"/>
        <cfargument name="NU_INTERIOR"          type="string" required="false"/>
        <cfargument name="NU_CP"                type="string" required="false"/>
        <cfargument name="NU_TELEFONO"          type="string" required="false"/>
        <cfargument name="EDITAR"               type="string" required="false"/>
        <cfargument name="ID_TAR"               type="string" required="false"/>

        <cfset var Local.result=structNew()>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="domiciliosRetiro"
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

        <cfreturn  variables.ctrl.toStruct()/>

    </cffunction>


    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroListar" access="remote" returnformat="JSON">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="cf_SimuladorCostos"   type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="domiciliosRetiroListar"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroEliminar" access="remote" returnformat="JSON">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="true"/>

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="domiciliosRetiroEliminar"
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

    <!---
        JOSE IBARRA
        04/05/2018
    --->
    <cffunction name="ProveedoresTransportistas" access="remote" returnformat="JSON">
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="ProveedoresTransportistas"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>



        <cffunction name="ReporteProveedoresPasivos" access="remote" returnformat="JSON">
         <cfargument name="id_Empresa"      type="string"   required="false"/>
        <cfargument name="fh_inicio"        type="string"   required="false"/>
        <cfargument name="fh_fin"           type="string"   required="false"/>
        <cfargument name="id_Sucursal"      type="string"   required="false"/>
        <cfargument name="id_Proveedor"     type="string"   required="false"/>
        <cfargument name="nb_Empresa"       type="string"   required="false"/>
        <cfargument name="nb_Sucursal"      type="string"   required="false"/>
        <cfargument name="nb_Proveedores"   type="string"   required="false"/>
        <cfargument name="id_Moneda"        type="string"   required="false"   default=""/>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="ReporteProveedoresPasivos"
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

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

  <cffunction name="ProveedorProductoListar" access="remote" returnformat="JSON">
      <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
      <cfargument name="sn_Activo"            type="string"   required="false"/>
          <cftry>
              <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="ProveedorProductoListar"
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

      <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <cffunction name="guardarProveedorProducto" access="remote" returnformat="JSON">
    <cfargument name="id_Proveedor"   type="string" required="true"/>
    <cfargument name="nb_Producto"    type="string" required="false"/>
    <cfargument name="sn_Activo"      type="string" required="true"/>

    <cfset var Local.result=structNew()>

    <cftransaction>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                  method="guardarProveedorProducto"
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

  <cffunction name="activarDesactivarProveedorProducto" access="remote" returnformat="JSON">
    <cfargument name="id_Proveedor"             type="string" required="true"/>
    <cfargument name="id_ProductoProveedor"     type="string" required="true"/>
    <cfargument name="sn_Activo"                type="string" required="true"/>

    <cfset var Local.result=structNew()>

    <cftransaction>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                  method="activarDesactivarProveedorProducto"
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

  <cffunction name="almc_TipoDeAditivoCompra" access="remote" returnformat="JSON">

    <cftry>
        <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                  method="almc_TipoDeAditivoCompra"
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

    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <!--- function para listar Proveedores Con Solicitud Pendientes de surtir en suerta fecha --->
  <cffunction name="listadoProveedoresConSolicitud" access="remote" returnformat="JSON">
    <cfargument name="id_Plaza"       type="string" required="false"/>
    <cfargument name="fh_Margen"      type="string" required="false"/>
    <cfargument name="tiposProductos" type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="listadoProveedoresConSolicitud"
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

    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

    <!---
        JPFarber    -   04/06/2021  -   Actualizar los campos de Proveedor Transporte y/o Combustible
    --->
    <cffunction name="guardarOpcionesProveedor" access="remote" returnformat="JSON">

        <cfargument name="id_Proveedor"             type="string" required="false"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible"  type="string" required="false"/>
		<cfargument name="nu_PermisoCRETransporte"  type="string" required="false"/>
		<cfargument name="nu_PermisoCRECombustible" type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string" required="false"/>
        <cfargument name="id_TipoDeAditivo"             type="string" required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string"required="false"/>

        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#">
        <cfabort> --->

        <cfset var Local.result=structNew()>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="guardarOpcionesProveedor"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarCuentasBancariasPaginados" access="remote" returnformat="JSON">
        <cfargument name="id_TipoReporte"        type="string"  required="false"/>
        <cfargument name="fh_Incio"              type="string"  required="false"/>
        <cfargument name="fh_Fin"                type="string"  required="false"/>
        <cfargument name="page"                  type="string"  required="false" default=""/>
        <cfargument name="pageSize"              type="string"  required="false" default=""/>
        <cfargument name="sn_PagoExtraOrdinario" type="string"  required="false" default="0"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                method="listarCuentasBancariasPaginados"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="obtenerCuentasBancariasDeudores" access="remote" returnformat="JSON">
        <cfargument name="id_DeudorDiverso"     type="string" required="false"/>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="obtenerCuentasBancariasDeudores"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="editarCuentaBancariaDeudores" access="remote" returnformat="JSON">
        <cfargument name="id_DeudorDiverso"     type="numeric" required="true"/>
        <cfargument name="Cuentas"              type="array" required="true"/>

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                      method="editarCuentaBancariaDeudores"
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

    <cffunction name="CuentasBancariasReporte" access="remote" returnformat="JSON">

        <cfargument name="id_TipoReporte"  type="string"  required="false"/>
        <cfargument name="fh_Inicio"       type="string"   required="false"/>
        <cfargument name="fh_Fin"          type="string"   required="false"/>
            <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                    method="CuentasBancariasReporte"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

              <cfif Local.BRO.hasError()>
                  <cfset variables.ctrl.rollback()>
                  <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                  <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                  <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
              </cfif>

              <cfcatch type="any">
                <cfset variables.ctrl.rollback()>
                <cfset variables.ctrl.setCatch(cfcatch)>
              </cfcatch>
            </cftry>
        <cfreturn variables.ctrl.toStruct()/>
      </cffunction>

      <cffunction name="actualizarLogo" access="remote" returnformat="JSON">

        <cfargument name="id_Proveedor"                      type="numeric"required="false"/>
        <cfargument name="imgLogo"                           type="string" required="false"/>

        <cfset var Local.result=structNew()>
            <cftransaction>
                <cftry>
                        <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                            method="actualizarLogo"
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

    <cffunction name="VerificarEmpleadoCompra" access="remote" returnformat="JSON">
        <cfargument name="Empleado" type="numeric" required="true">

            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                          method="VerificarEmpleadoCompra"
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
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


 <cffunction name="eliminarCuentasBancarias" access="remote" returnformat="JSON">
    <cfargument name="id_Proveedor" type="string" required="false">
    <cfargument name="id_CuentaBancaria" type="string" required="false">
    <cfargument name="nb_CuentaBancaria" type="string" required="false">
    <cfargument name="id_TipoTransferencia"  type="string" required="false">
    <cfargument name="nb_ClaveProveedor"     type="string" required="false">
    <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
    <cfargument name="id_Banco"              type="string" required="false">
    <cfargument name="id_Moneda"             type="string" required="false">
    <cfargument name="de_Concepto"           type="string" required="false">


    <cftransaction>
      <cftry>
        <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
          method="eliminarCuentasBancarias"
          argumentcollection="#arguments#"
          returnvariable="Local.BRO"/>

        <cfif Local.BRO.hasError()>
          <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
          <cfset variables.ctrl.rollback()>
        <cfelse>
          <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
          <!---   <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
        </cfif>

        <cfcatch type="any">
          <cfset variables.ctrl.setCatch(cfcatch)>
          <cfset variables.ctrl.rollback()>
        </cfcatch>
      </cftry>
    </cftransaction>
    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>



        <cffunction name="ReporteAuxiliarPagos" access="remote" returnformat="JSON">
            <cfargument name="arr_Empresas"         type="string"   required="false"/>
            <cfargument name="arr_Sucursarles"      type="string"   required="false"/>
            <cfargument name="arr_Proveedores"      type="string"   required="false"/>
            <cfargument name="fh_Inicio"            type="string"   required="false"/>
            <cfargument name="fh_Fin"               type="string"   required="false"/>
            <cfargument name="id_TipoNegocio"       type="string"   required="false"/>


            <cftry>
                <cfinvoke
                    component="#Application.RF.getPath('bro','Proveedores')#"
                    method="ReporteAuxiliarPagos"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"
                />

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

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ProveedoresServicios_listar" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="true">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                            method="ProveedoresServicios_listar"
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

    <cffunction name="ListarCMF" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="string" required="false"/>
        <cfargument name="id_Sucursal"      type="string" required="false"/>
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="id_Estatus"       type="string" required="false"/>
        <cfargument name="fh_inicio"        type="string" required="false"/>
        <cfargument name="fh_fin"           type="string" required="false"/>
        <cfargument name="page"             type="string" required="false"/>
        <cfargument name="pageSize"         type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="ListarCMF"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setJSON(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
                <cfset variables.ctrl.rollback()>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarProveedorPermisosCRE" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"       type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="ListarProveedorPermisosCRE"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="eliminarpermisocre" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"          type="numeric" required="true"/>
        <cfargument name="id_proveedorPermiso"          type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                method="EliminarPermisoCRE"
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

    <cffunction name="ListarProveedoresConsignacion" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                    method="ListarProveedoresConsignacion"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn  variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarProveedoresConsignacionByInsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                    method="ListarProveedoresConsignacionByInsumo"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn  variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarProveedoresSn_PerteneceGrupo" access="remote" returnformat="JSON">
        <cfargument name="sn_PerteneceGrupo" type="string" required="false" default=""/>
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                              method="listarProveedoresSn_PerteneceGrupo"
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

    <cffunction name="AccesosPuestoEmpleado" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                        method="AccesosPuestoEmpleado"
                        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="PermisosPorUsuarioProv" access="remote" returnformat="JSON">
        <cfargument name="id_Usuario" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                    method="PermisosPorUsuarioProv"
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

    <cffunction name="InfoIndicadoresPago" access="remote" returnformat="JSON">
        <cfargument name="id_Indicador" type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                method="InfoIndicadoresPago"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

</cfcomponent>
