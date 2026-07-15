<cfcomponent>
<cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    <cffunction name="get_Insumos_AyudaFacturacion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="numeric"  required="false"/>
        <cfargument name="nb_NombreInsumo"  type="string"   required="false"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="get_Insumos_AyudaFacturacion"
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


    <cffunction name="combo_impuestosTazas" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="combo_impuestosTazas"
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

    <cffunction name="EmpleadoInfo" access="remote" returnformat="JSON">
        <cfargument name="id_empresa"   type="string" required="true"/>
        <cfargument name="id_Empleado"  type="string" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke
                        component="#Application.RF.getPath('bro','Insumos')#"
                        method="EmpleadoInfo"
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

    <cffunction name="SubFamiliaInsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Familia"     type="numeric" required="false"/>
        <cfargument name="id_Subfamilia"  type="numeric" required="false"/>
        <cfargument name="nb_Subfamilia"  type="string" required="false"/>
        <cfargument name="id_Empresa"     type="numeric" required="false"/>
        <cftransaction>
            <cftry>
                <cfinvoke
                        component="#Application.RF.getPath('bro','Insumos')#"
                        method="SubFamiliaInsumo"
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

    <cffunction name="Marcas" access="remote" returnformat="JSON">
        <cfargument name="id_marca"     type="numeric" required="false"/>
        <cfargument name="nb_marca"     type="string" required="false"/>
        <cftransaction>
            <cftry>
                <cfinvoke
                        component="#Application.RF.getPath('bro','Insumos')#"
                        method="Marcas"
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

    <cffunction name="UnidadesMedida" access="remote" returnformat="JSON">
        <cfargument name="id_UnidadMedida"     type="numeric" required="false"/>
        <cfargument name="nb_UnidadMedida"     type="string" required="false"/>
        <cfargument name="id_Empresa"           type="numeric" required="false"/>
        <cftransaction>
            <cftry>

                <cfinvoke
                        component="#Application.RF.getPath('bro','Insumos')#"
                        method="UnidadesMedida"
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

    <cffunction name="listarTodos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="numeric" required="false"/>
        <cfargument name="id_Insumo"      type="numeric" required="false"/>
        <cfargument name="nb_Insumo"      type="string" required="false"/>
        <cfargument name="id_SubFamilia"  type="numeric" required="false"/>
        <cfargument name="id_FamiliaInsumo" type="numeric" required="false"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarTodos"
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

    <cffunction name="agregar" access="remote" returnformat="JSON">
            <cfargument name="id_Empresa"               type="string" required="false"/>
            <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
            <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
            <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
            <cfargument name="id_SubFamiliaInsumo"      type="string" required="no"/>
            <cfargument name="id_SubFamiliaDinamica"    type="string" required="no"/>
            <cfargument name="id_UnidadMedida"          type="string" required="true"/>
            <cfargument name="id_Marca"                 type="string" required="false"/>
            <cfargument name="sn_Requizitable"          type="string" required="false"/>
            <cfargument name="sn_Seriado"               type="string" required="false"/>
            <cfargument name="sn_Transporte"            type="string" required="false"/>
            <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
            <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
            <cfargument name="id_TipoDestino"           type="string" required="true"/>
            <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
            <cfargument name="id_Impuesto"              type="string" required="true"/>
            <cfargument name="id_Taza"                  type="string" required="true"/>
            <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
            <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
            <cfargument name="sn_Relevante"             type="string" required="false"/>


            <!---  sn_ActivoFijo y sn_CentroCosto
            tienen que tener el mismo estado que sn_Seriado --->
            <cfif isDefined("sn_Seriado")>
                <cfif #arguments.sn_Seriado# EQ 'YES'>
                    <cfset arguments.sn_ActivoFijo = 'YES'>
                    <cfset arguments.sn_CentroCosto = 'YES'>
                <cfelse>
                    <cfset arguments.sn_ActivoFijo = 'NO'>
                    <cfset arguments.sn_CentroCosto = 'NO'>
                </cfif>
            <cfelse>
                <cfset arguments.sn_Seriado = 'NO'>
                <cfset arguments.sn_ActivoFijo = 'NO'>
                <cfset arguments.sn_CentroCosto = 'NO'>
            </cfif>


            <cfset var Local.result=structNew()>

            <cftransaction>
                <cftry>
                   <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
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

    <cffunction name="AgregarMultiplesInsumos" access="remote" returnformat="JSON">

        <cfargument name="multiplesInsumos"     type="array" required="true"/>

        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>
                <cfinvoke
                    component="#Application.RF.getPath('bro','Insumos')#"
                    method="AgregarMultiplesInsumos"
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
                <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="editar" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="true"/>
        <cfargument name="id_Insumo"                type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="true"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="true"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="string" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true">
        <cfargument name="id_Taza"                  type="string" required="true">
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>
        <cfargument name="sn_AplicarTodasEmpresas"  type="string" required="false"/>


            <!---  sn_ActivoFijo y sn_CentroCosto
            tienen que tener el mismo estado que sn_Seriado --->
            <cfif isDefined("arguments.sn_Seriado")>
                <cfif #arguments.sn_Seriado# EQ 'YES'>
                    <cfset arguments.sn_ActivoFijo = 'YES'>
                    <cfset arguments.sn_CentroCosto = 'YES'>
                <cfelse>
                    <cfset arguments.sn_ActivoFijo = 'NO'>
                    <cfset arguments.sn_CentroCosto = 'NO'>
                </cfif>
            <cfelse>
                <cfset arguments.sn_Seriado = 'NO'>
                <cfset arguments.sn_ActivoFijo = 'NO'>
                <cfset arguments.sn_CentroCosto = 'NO'>
            </cfif>

         <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>

                    <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="editar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
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

    <cffunction name="buscarID" access="remote" returnformat="JSON">
        <cfargument name="id_Insumo"    type="string" required="false"/>
        <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>

                <cfinvoke
                    component="#Application.RF.getPath('bro','Insumos')#"
                    method="buscarID"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setJSON(Local.BRO.getData())>
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

    <!--- function para asignar los conceptos de gastos a los insumos
            julio cesar acosta lopez
            09/07/2015--->
    <cffunction name="AsignarConceptoGasto" access="remote" returnformat="JSON">
        <cfargument name="insumos"  type="array" required="true"/>
        <cftransaction>
            <cftry>

                    <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="AsignarConceptoGasto"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(local.BRO.getMessage())>
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

    <!--- function para eliminar sucursales con el id pasado como referencia --->
    <cffunction name="eliminar" access="remote" returnformat="JSON">
        <cfargument name="id_insumo"    type="string" required="true"/>
         <cfset var Local.result=structNew()>

        <cftransaction>
            <cftry>

              <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="eliminar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset variables.ctrl.setError(local.BRO.getMessage())>
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


    <!--- function para listar los insumos --->
    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"   required="false"/>
        <cfargument name="id_insumo"            type="string"   required="false"/>
        <cfargument name="nb_insumo"            type="string"   required="false"/>
        <cfargument name="id_subfamilia"        type="string"   required="false"/>
        <cfargument name="sn_activo"            type="string"   required="false"/>
        <cfargument name="id_TipoRequisicion"   type="string"   required="false"/>
        <cfargument name="page"                 type="string"   required="false"/>
        <cfargument name="pageSize"             type="string"   required="false"/>
        <cfargument name="id_familia"           type="string"   required="false"/>
        <cfargument name="sn_InsumoActivo"      type="string"   required="false"/>
        <cfargument name="sn_InsumoRelevante"   type="string"   required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
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

    <!--- Victor Sanchez
            30/12/2015
      --->
    <cffunction name="upL_InsumosProductosAyuda" access="remote" returnformat="JSON">
        <cfargument name="nb_insumo"      type="string" required="false"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="upL_InsumosProductosAyuda"
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

    <cffunction name="obtenerUnidadMedidadeInsumo" access="remote" returnformat="JSON">
        <cfargument name="id_insumo"      type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
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


<!--- Victor Sanchez
      Date: 23/07/2015
      Lista el combo de subfamiliasDinamicas Nivel 2 para los insumos --->
    <cffunction name="SubFamiliasDinamicasNivel2" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="yes"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="SubFamiliasDinamicasNivel2"
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
      Date: 23/07/2015
      Lista el combo de subfamiliasDinamicas Nivel 3 para los insumos --->
    <cffunction name="SubFamiliasDinamicasNivel3" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="SubFamiliasDinamicasNivel3"
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
      Date: 23/07/2015
      Lista el combo de subfamiliasDinamicas Nivel 4 para los insumos --->
    <cffunction name="SubFamiliasDinamicasNivel4" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="SubFamiliasDinamicasNivel4"
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
      Date: 23/07/2015
      saca el nivel de una subfamilia --->
    <cffunction name="sacarNivel" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="sacarNivel"
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
      Date: 23/07/2015
      saca el padre de una subfamilia --->
    <cffunction name="sacarPadre" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="sacarPadre"
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

    <!--- julio cesar acosta lopez
          listar los insumos para la asignacion de los conceptos de gastos a cada insumo
          08/07/2015 --->
    <cffunction name="listarinsumosasignacionconceptogasto" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"         type="string" required="false"/>
        <cfargument name="nb_InsumoListado"         type="string" required="false"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarinsumosasignacionconceptogasto"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <!--- <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
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


    <cffunction name="getNumeroInsumos" access="remote" returnformat="JSON">
        <cfargument name="id_Almacen"   type="string"   required="true">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="getNumeroInsumos"
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

    <cffunction name="DatosInsumo" access="remote" returnformat="JSON">
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                              method="DatosInsumo"
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

    <cffunction name="InsumosCombo" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="InsumosCombo"
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


    <cffunction name="listarInsumosCotizar" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor"    type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosCotizar"
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


    <cffunction name="listarInsumosparaAutorizarOrdenCompra" access="remote" returnformat="JSON">
        <cfargument name="id_Cotizacion"      type="string" required="false"/>
        <cfargument name="sn_Genero"        type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosparaAutorizarOrdenCompra"
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


    <cffunction name="listarInsumosAutoComplete" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_TipoRequisicion"   type="numeric" required="false">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosAutoComplete"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                          <!--- argumentcollection="#arguments#" --->
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


    <cffunction name="UltimoPrecioCompra" access="remote" returnformat="JSON">
      <cfargument name="id_Insumo"            type="string"       required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="UltimoPrecioCompra"
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

    <cffunction name="listarInsumos" access="remote" returnformat="JSON">
      <cfargument name="id_Empresa"           type="numeric"    required="false">
      <cfargument name="id_SolicitudCompra"   type="string"     required="false"/>
      <cfargument name="id_Insumo"            type="string"     required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumos"
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
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarInsumosporIdCotizacion" access="remote" returnformat="JSON">
        <cfargument name="id_Cotizacion"   type="numeric"     required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosporIdCotizacion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                        <!--- <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarInsumosporOrdenCompra" access="remote" returnformat="JSON">
        <cfargument name="id_OrdenCompra"   type="numeric"     required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosporOrdenCompra"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                        <!--- <cfset variables.ctrl.setJson(Local.BRO.getData())> --->
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarInsumosbyIDorNB" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"   type="numeric"  required="false">
        <cfargument name="id_insumo"    type="numeric"  required="false">
        <cfargument name="nb_insumo"    type="string"   required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosbyIDorNB"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO" />

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

    <cffunction name="listarInsumosByIDorName" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"  type="numeric" required="true"/>
        <cfargument name="id_Sucursal" type="numeric" required="true"/>
        <cfargument name="id_Almacen"  type="numeric" required="true"/>
        <cfargument name="id_insumo"   type="numeric" required="false"/>
        <cfargument name="nb_insumo"   type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosByIDorName"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO" />

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

    <cffunction name="AutocompleteInsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"   type="numeric"  required="false"/>
        <cfargument name="id_Sucursal"  type="numeric"  required="false"/>
        <cfargument name="id_Almacen"   type="numeric"  required="false"/>
        <cfargument name="id_insumo"    type="numeric"  required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="AutocompleteInsumo"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO" />

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

    <cffunction name="getInsumosPorSolicitudCompra" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="getInsumosPorSolicitudCompra"
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

    <cffunction name="getInsumosPorSolicitudCompraAlmacen" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_Sucursal"          type="numeric" required="false">
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="getInsumosPorSolicitudCompraAlmacen"
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

    <cffunction name="listarByCotizacion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="numeric" required="false"/>
        <cfargument name="id_Cotizacion"    type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarByCotizacion"
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

    <cffunction name="listarByCotizacion_SC" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="numeric" required="false"/>
        <cfargument name="id_Cotizacion"    type="numeric" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarByCotizacion_SC"
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
          Fecha: 08/05/2015
          OBTIENE LOS INSUMOS PARA AUTOCOMPLETE POR PROVEEDOR --->
    <cffunction name="listarInsumosAutoCompleteByProveedor" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="numeric" required="true">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                      method="listarInsumosAutoCompleteByProveedor"
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

    <!--- Jesus Reyes --->
    <cffunction name="tipoDestinoInsumos" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="tipoDestinoInsumos"
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

    <!--- Jesus Reyes --->
    <cffunction name="InsumosMaterialesCombo" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="InsumosMaterialesCombo"
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

    <cffunction name="obtenerinsumos" access="remote" returnformat="JSON">
        <cfargument name="page"                 type="string"   required="false">
        <cfargument name="pageSize"             type="string"   required="false">
        <cfargument name="id_familia"           type="string"   required="false">
        <cfargument name="id_subfamilia"        type="string"   required="false">
        <cfargument name="nb_insumo"            type="string"   required="false">


        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="obtenerinsumos"
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

    <cffunction name="getInsumosPorFamilia" access="remote" returnformat="JSON">
        <cfargument name="FamiliaInsumo"    type="string"   required="false">
        <cfargument name="SubFamiliaInsumo" type="string"   required="false">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="getInsumosPorFamilia"
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


    <cffunction name="getInsumosMultiEmpresa" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"          type="string"    required="true" default="">
        <cfargument name="id_FamiliaInsumo"    type="string"    required="false" default="">
        <cfargument name="id_SubFamiliaInsumo" type="string"    required="false" default="">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="getInsumosMultiEmpresa"
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

    <cffunction name="GenerarExcel" access="remote" returnformat="JSON">
        <cfargument name="id_Insumo"         type="string" required="no" default>
        <cfargument name="nb_Insumo"         type="string" required="no" default>
        <cfargument name="nb_ActivoFijo"     type="string" required="no" default>
        <cfargument name="nb_SubFamilia"     type="string" required="no" default>
        <cfargument name="sn_ActivoFijo"     type="string" required="no" default>
        <cfargument name="CatalogoInsumo"    type="array"  required="no" default>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfdump var="#arguments#">
        <cfabort>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                      method="GenerarExcel"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset Variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="catalogoInsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Insumo"         type="string" required="no" default>
        <cfargument name="nb_Insumo"         type="string" required="no" default>
        <cfargument name="nb_ActivoFijo"     type="string" required="no" default>
        <cfargument name="nb_SubFamilia"     type="string" required="no" default>
        <cfargument name="sn_ActivoFijo"     type="string" required="no" default>
        <cfargument name="sn_InsumoActivo"   type="string" required="no" default>
        <cfargument name="sn_Relevante"      type="string" required="no" default>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>


        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="catalogoInsumo"
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

    <!--- Jesus Reyes --->
    <cffunction name="listarInsumosAutoCompleteSolicitudCompraAlmacen" access="remote" returnformat="JSON">
                <cfargument name="id_insumo"            type="string"   required="false"/>
        <cfargument name="nb_insumo"            type="string"   required="false"/>
        <cfargument name="id_subfamilia"        type="string"   required="false"/>
        <cfargument name="page"                 type="string"   required="false"/>
        <cfargument name="pageSize"             type="string"   required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="listarInsumosAutoCompleteSolicitudCompraAlmacen"
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

    <cffunction name="ListarInsumosInactivos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>


        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="ListarInsumosInactivos"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarInsumosActivos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>


        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="ListarInsumosActivos"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarDatosInsumosInactivos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>
        <cfargument name="id_Insumo"            type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="ListarDatosInsumosInactivos"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarDatosInsumosActivos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>
        <cfargument name="id_Insumo"            type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="ListarDatosInsumosActivos"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="InsumosServicios" access="remote" returnformat="JSON">
        <cfargument name="id_Proveedor" type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="InsumosServicios"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarExistGral" access="remote" returnformat="JSON">
        <cfargument name="insumos"              type="array" required="false"/>
        <cfargument name="id_FamiliaInsumo"     type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Insumos')#"
                          method="ListarExistGral"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
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

    <!--- Obtener historial de movimientos de un insumo --->
    <cffunction name="obtenerHistorialMovimientos" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="string"  required="false"/>
        <cfargument name="id_Insumo"        type="string"  required="false"/>
        <cfargument name="nb_Insumo"        type="string"  required="false"/>
        <cfargument name="id_SubFamilia"    type="string"  required="false"/>
        <cfargument name="sn_InsumoActivo"  type="string"  required="false"/>
        <cfargument name="sn_Relevante"     type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke
                    component="#Application.RF.getPath('bro','Insumos')#"
                    method="obtenerHistorialMovimientos"
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

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

</cfcomponent>
