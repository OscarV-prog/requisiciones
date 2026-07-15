<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">

    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    <cffunction name="obtener_requisicion" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='numeric' required='yes'>
        <cfargument name='id_Requisicion'   type='numeric' required='yes'>
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="obtener_requisicion"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="agregar" access="remote" returnformat="JSON">
        <cfargument name="id_TipoRequisicion"        type="string" required="yes">
        <cfargument name="id_tipoDivision"           type="string" required="yes">
        <cfargument name="id_Departamento"           type="string" required="yes">
        <cfargument name="id_SucursalSolicita"       type="string" required="yes">
        <cfargument name="id_ClasificadoRequisicion" type="string" required="yes">
        <cfargument name="fh_Expedicion"             type="string" required="yes">
        <cfargument name="id_Proveedor"              type="string" required="no">
        <cfargument name="de_Observaciones"          type="string" required="no">
        <cfargument name="detalleRequisicion"        type="array"  required="yes">
        <cfargument name="im_totalRequisicion"       type="string" required="no">
        <cfargument name="nu_Viaje"                  type="string" required="no">
        <cfargument name="id_Empresa"                type="string" required="yes">
        <cfargument name="nu_siniestro"              type="string" required="no">
        <cfargument name="ar_soporte"                type="string" required="no">
        <cfargument name="id_ReporteFalla"           type="string" required="no">
        <cfargument name="id_GrupoCentroCosto"       type="string" required="no">
        <cfargument name="id_CentroCosto"            type="string" required="no">
        <cfargument name="id_PersMantenimiento"      type="string" required="no">

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="agregar"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Orden de trabajo almacenada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listado" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"          type="string" required="false">
        <cfargument name="id_Sucursal"         type="string" required="false">
        <cfargument name="id_Requisicion"      type="string" required="false">
        <cfargument name="id_ReporteFalla"     type="string" required="false">
        <cfargument name="id_TipoOrdenTrabajo" type="string" required="false">
        <cfargument name="id_TipoDivision"     type="string" required="false">
        <cfargument name="id_Centrocosto"      type="string" required="false">
        <cfargument name="fh_Inicio"           type="string" required="true">
        <cfargument name="fh_Fin"              type="string" required="true">
        <cfargument name="id_Estatus"          type="string" required="false">
        <cfargument name="page"                type="string" required="false">
        <cfargument name="pageSize"            type="string" required="false">

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="listado"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Ordenes de trabajo listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="listadoRequisicionesFiltro" access="remote" returnformat="JSON">
        <cfargument name='nb_Empleado'     type='string' required='false'>
        <cfargument name='nb_Sucursal'     type='string' required='false'>
        <cfargument name='fecha'            type='string' required='false'>

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="listadoRequisicionesFiltro"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("operacion existosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarSalidasAjuste" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="listarSalidasAjuste"
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



    <cffunction name="RequisicionesAgregarData" access="remote" returnformat="JSON">
        <cfargument name="id_TipoRequisicion" type="string" required="no">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="RequisicionesAgregarData"
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


    <cffunction name="RequisicionesEditarData" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"         type="numeric" required="true"/>
        <cfargument name="id_Sucursal"        type="numeric" required="false"/>
        <cfargument name="id_Requisicion"     type="numeric" required="true"/>
        <cfargument name="id_TipoRequisicion" type="string" required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="RequisicionesEditarData"
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

    <cffunction name="enviar" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='estatus'        type='numeric' required='true'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="enviar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo almacenada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="enviar2" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string'  required='yes'>


        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="enviar2"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisicion lista")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
                    <!--- <cfset variables.ctrl.setQuery(Local.BRO.getQuery())> --->
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="enviar3" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion'         type='string'  required='yes'>
        <cfargument name='Empleado_Id_Usuario'    type='string'  required='yes'>
        <cfargument name='Empleado_Correo'        type='string'  required='yes'>
        <cfargument name='estatus'                type='numeric' required='true'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="enviar3"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo almacenada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

        <cffunction name="getById" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="getById"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisicion lista")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>




    <cffunction name="editar" access="remote" returnformat="JSON">
        <cfargument name="id_requisicion"            type="string"  required="true"/>
        <cfargument name="id_TipoRequisicion"        type="string"  required="true">
        <cfargument name="id_TipoDivision"           type="string"  required="true">
        <cfargument name="id_Departamento"           type="string"  required="true">
        <cfargument name="id_SucursalSolicita"       type="string"  required="true">
        <cfargument name="id_ClasificadoRequisicion" type="string"  required="true">
        <cfargument name="fh_Expedicion"             type="string"  required="true">
        <cfargument name="id_Proveedor"              type="string"  required="true">
        <cfargument name="de_Observaciones"          type="string"  required="true">
        <cfargument name="detalleRequisicion"        type="array"   required="true">
        <cfargument name="im_totalRequisicion"       type="string"  required="true">
        <cfargument name="estatus"                   type="numeric" required="true">
        <cfargument name="nu_Viaje"                  type="string"  required="no">
        <cfargument name="id_Empresa"                type="string"  required="true">
        <cfargument name="nu_siniestro"              type="string"  required="no" default="">
        <cfargument name="ar_soporte"                type="string"  required="no" default="">
        <cfargument name="id_ReporteFalla"           type="string"  required="no">
        <cfargument name="id_GrupoCentroCosto"       type="string" required="no">
        <cfargument name="id_CentroCosto"            type="string" required="no">
        <cfargument name="id_PersMantenimiento"      type="string" required="no">
        <cfargument name="nu_kilometraje"            type="string" required="no">

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="editar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo actualizada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="eliminar" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_requisicion" type="string" required="true"/>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="eliminar"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Orden de trabajo eliminada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="getFechaRegistro" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="numeric" required="false">
        <cfargument name='id_Requisicion' type='numeric' required='yes'>
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="getFechaRegistro"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Ordenes de trabajo listas")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="upL_RequisicionesDetalleEntradaDevolucionSalida" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'      type='numeric' required='true'>
        <cfargument name='id_Requisicion'     type='numeric' required='true'>


        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="upL_RequisicionesDetalleEntradaDevolucionSalida"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Ordenes de trabajo listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="updateEstatusAutorizacion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"             type="numeric" required="true">
        <cfargument name="id_Requisicion"         type="numeric" required="true">
        <cfargument name="id_EstatusAutorizacion" type="numeric" required="true">
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="updateEstatusAutorizacion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo almacenada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="seguimientoRequisicion" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='string' required='yes'>
        <cfargument name='tipoBusqueda'     type='string' required='false' default="1">
        <cfargument name='id_Requisicion'   type='string' required='yes' >

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="seguimientoRequisicion"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Ordenes de trabajo listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="SolicitudCompraPorStock" access="remote" returnformat="JSON">
        <cfargument name='id_empresa'           type='string' required='yes'>
        <cfargument name='id_solicitudcompra'   type='string' required='yes'>

        <cftry>
            <cfinvoke   component="#Application.RF.getPath('bro','OrdenesServicio')#"
                        method="SolicitudCompraPorStock"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO" />

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Solicitudes de Compra listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct() />
    </cffunction>


    <cffunction name="enviarRequisicion" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='id_TipoDivision' type='string' required='yes'>
        <cfargument name='estatus'        type='numeric' required='true'>
        <cfargument name='id_Empresa'         type='numeric' required='true'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="enviarRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo enviada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="reporteRequisicion" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='estatus'        type='numeric' required='false'>
        <cfargument name='id_Empresa'         type='numeric' required='true'>


        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="reporteRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>


    <cffunction name="FinalizarRequisicion" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"         type="numeric" required="true">
        <cfargument name="id_EstatusAutorizacion" type="numeric" required="true">
        <cfargument name="id_Empresa"             type="numeric" required="true">
        <cfargument name="sn_mov"                 type="numeric" required="true">
        <cfargument name="de_motivoFin"           type="string"  required="true">

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="FinalizarRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de trabajo almacenada correctamente")>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarInsumosAyuda" access="remote" returnformat="JSON">
        <cfargument name='id_Insumo' type='string' required='false'>
        <cfargument name='nb_Nombre' type='string' required='false'>
        <cfargument name='id_FamiliaInsumo' type='string' required='false'>
        <cfargument name='id_SubFamiliaInsumo' type='string' required='false'>
        <cfargument name='id_Empresa' type='string' required='false'>
        <cfargument name='id_Sucursal' type='string' required='false'>
        <cfargument name='id_tipoSolicitud' type='string' required='false'>

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="listarInsumosAyuda"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Ordenes de trabajo listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="GrupoCentroCostoCombo" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa' type='string' required='true'>
        <cfargument name='id_Sucursal' type='string' required='true'>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="GrupoCentroCostoCombo"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="CentroCostoCombo" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa' type='string' required='true'>
        <cfargument name='id_Sucursal' type='string' required='true'>
        <cfargument name='id_GrupoCentroCosto' type='string' required='true'>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                      method="CentroCostoCombo"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="getPerfil" access="remote" returnformat="JSON">
        <cfargument name="id_usuario"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                          method="getPerfil"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="NextID_ReporteDeFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Sucursal"    type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="NextID_ReporteDeFalla"
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

    <cffunction name="GuardarReporteDeFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Sucursal"    type="string" required="true"/>
        <cfargument name="id_Unidad"      type="string" required="true"/>
        <cfargument name="id_Operador"    type="string" required="true"/>
        <cfargument name="de_Descripcion" type="string" required="true"/>
        <cfargument name="sn_Enviar"      type="string" required="true"/>
        <cfargument name="fh_Reporte"     type="string" required="true"/>
        <cfargument name="ar_Documentos"  type="array"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="GuardarReporteDeFalla"
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

    <cffunction name="editarReporteDeFalla" access="remote" returnformat="JSON">
        <cfargument name="id_ReporteFalla" type="string" required="true"/>
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_Unidad"       type="string" required="true"/>
        <cfargument name="id_Operador"     type="string" required="true"/>
        <cfargument name="de_Descripcion"  type="string" required="true"/>
        <cfargument name="sn_Enviar"       type="string" required="true"/>
        <cfargument name="fh_Reporte"      type="string" required="true"/>
        <cfargument name="ar_Documentos"   type="array" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="editarReporteDeFalla"
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

    <cffunction name="EnviarReporteFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="true"/>
        <cfargument name="sn_Enviar"       type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="EnviarReporteFalla"
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

    <cffunction name="CancelarReporteFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="true"/>
        <cfargument name="id_Estatus"      type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="CancelarReporteFalla"
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

    <cffunction name="ListarReportesDeFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="false"/>
        <cfargument name="id_ReporteFalla" type="string" required="false"/>
        <cfargument name="id_Unidad"       type="string" required="false"/>
        <cfargument name="fh_Inicio"       type="string" required="false"/>
        <cfargument name="fh_Fin"          type="string" required="false"/>
        <cfargument name="id_Estatus"      type="string" required="false"/>
        <cfargument name="sn_Seguimiento"  type="string" required="false" default="0"/>
        <cfargument name="page"            type="string" required="false"/>
        <cfargument name="pageSize"        type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="ListarReportesDeFalla"
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

    <cffunction name="ListarEstatusReporteFalla" access="remote" returnformat="JSON">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="ListarEstatusReporteFalla"
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

    <cffunction name="getEvidenciasByIdFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="getEvidenciasByIdFalla"
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

    <cffunction name="EliminarDocumentoRFEvidencia" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="true"/>
        <cfargument name="id_Documento"    type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="EliminarDocumentoRFEvidencia"
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

    <cffunction name="FinalizarReporteDeFalla" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="true"/>
        <cfargument name="de_Motivo"       type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="FinalizarReporteDeFalla"
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

    <cffunction name="listarReportesFallaCombo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>
        <cfargument name="id_ReporteFalla" type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="listarReportesFallaCombo"
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

    <cffunction name="GetTiposDivisiones" access="remote" returnformat="JSON">
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                method="GetTiposDivisiones"
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

    <cffunction name="listarPersonalMantenimientoCombo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"      type="string" required="true"/>
        <cfargument name="id_Sucursal"     type="string" required="true"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                method="listarPersonalMantenimientoCombo"
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

    <cffunction name="agregarPersonalMantenimiento" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Sucursal"        type="string" required="false"/>
        <cfargument name="id_Empleado"        type="string" required="false"/>
        <cfargument name="nb_NombrePersonal"  type="string" required="false"/>
        <cfargument name="nb_ApellidoPaterno" type="string" required="false"/>
        <cfargument name="nb_ApellidoMaterno" type="string" required="false"/>
        <cfargument name="id_Puesto"          type="string" required="false"/>
        <cfargument name="id_Departamento"    type="string" required="false"/>
        <cfargument name="de_Domicilio"       type="string" required="false"/>
        <cfargument name="de_Email"           type="string" required="false"/>
        <cfargument name="nu_Telefono"        type="string" required="false"/>

        <transaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="agregarPersonalMantenimiento"
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
        </transaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="actualizarPersonalMantenimiento" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_PersonalMantenimiento" type="string" required="false"/>
        <cfargument name="id_Empleado"              type="string" required="false"/>
        <cfargument name="nb_NombrePersonal"        type="string" required="false"/>
        <cfargument name="nb_ApellidoPaterno"       type="string" required="false"/>
        <cfargument name="nb_ApellidoMaterno"       type="string" required="false"/>
        <cfargument name="id_Puesto"                type="string" required="false"/>
        <cfargument name="id_Departamento"          type="string" required="false"/>
        <cfargument name="de_Domicilio"             type="string" required="false"/>
        <cfargument name="de_Email"                 type="string" required="false"/>
        <cfargument name="nu_Telefono"              type="string" required="false"/>

        <transaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="actualizarPersonalMantenimiento"
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
        </transaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="ListarPersonalMantenimientoPaginado" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_PersonalMantenimiento" type="string" required="false"/>
        <cfargument name="id_Empleado"              type="string" required="false"/>
        <cfargument name="nb_NombreCompleto"        type="string" required="false"/>
        <cfargument name="sn_Activo"                type="string" required="false"/>
        <cfargument name="page"                     type="string" required="false"/>
        <cfargument name="pageSize"                 type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                method="ListarPersonalMantenimientoPaginado"
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

    <cffunction name="ListarPersonalMantenimientoPaginado" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_PersonalMantenimiento" type="string" required="false"/>
        <cfargument name="id_Empleado"              type="string" required="false"/>
        <cfargument name="nb_NombreCompleto"        type="string" required="false"/>
        <cfargument name="sn_Activo"                type="string" required="false"/>
        <cfargument name="page"                     type="string" required="false"/>
        <cfargument name="pageSize"                 type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                method="ListarPersonalMantenimientoPaginado"
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

    <cffunction name="activarDesPersonalMantenimiento" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_PersonalMantenimiento" type="string" required="false"/>
        <cfargument name="sn_Activo"                type="string" required="false"/>

        <transaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                    method="activarDesPersonalMantenimiento"
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
        </transaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="validarPersonalMantenimiento" access="remote" returnformat="JSON">
        <cfargument name="id_PersonalMantenimiento" type="string" required="false"/>
        <cfargument name="id_Empleado"              type="string" required="false"/>
        <cfargument name="nb_NombrePersonal"        type="string" required="false"/>
        <cfargument name="nb_ApellidoPaterno"       type="string" required="false"/>
        <cfargument name="nb_ApellidoMaterno"       type="string" required="false"/>
        <cfargument name="de_Email"                 type="string" required="false"/>
        <cfargument name="nu_Telefono"              type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesServicio')#"
                method="validarPersonalMantenimiento"
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
