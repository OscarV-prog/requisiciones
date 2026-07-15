<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">

    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    <cffunction name="obtener_requisicion" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='numeric' required='yes'>
        <cfargument name='id_Requisicion'   type='numeric' required='yes'>
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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
        <cfargument name="de_Requisicion"            type="string" required="no">
        <cfargument name="id_TipoInstalacion"        type="string" required="no">
        <cfargument name="id_GrupoCentroCosto"       type="string" required="no">
        <cfargument name="id_Cliente"                type="string" required="no">
        <cfargument name="id_CentroCosto"       type="string" required="no">



        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="agregar"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisición almacenada correctamente")>
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
        <cfargument name='id_Empresa'      type='string' required='true'>
        <cfargument name='id_requisicion'  type='string' required='false'>
        <cfargument name='fh_inicio'       type='string' required='false'>
        <cfargument name='fh_fin'          type='string' required='false'>
        <cfargument name='id_estatus'      type='string' required='false'>
        <cfargument name='id_Sucursal'     type='string' required='false'>
        <cfargument name='nb_NombreInsumo' type='string' required='false'>
        <cfargument name='id_centrocosto'  type='string' required='false'>
        <cfargument name='de_Requisicion'  type='string' required='false'>

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                method="listado"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Requisiciones listas")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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

    <!---   JULIO CESAR ACOSTA LOPEZ 17/03/2015
            listado de requisiciones para el registro de salidas por ajuste--->
    <cffunction name="listarSalidasAjuste" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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


<!--- Victor Sanchez
    17/11/2015
    Se utiliza una sola llamada para la pantalla de requisiciones Agregar
     --->
    <cffunction name="RequisicionesAgregarData" access="remote" returnformat="JSON">
        <cfargument name="id_TipoRequisicion" type="string" required="no">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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

<!--- Victor Sanchez
        17/11/2015
    Se utiliza una sola llamada para traer el los datos de requisicionesEditar
         --->
    <cffunction name="RequisicionesEditarData" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="enviar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición almacenada correctamente")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="enviar3"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición almacenada correctamente")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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
        <cfargument name="de_Requisicion"            type="string"  required="no">
        <cfargument name="id_TipoInstalacion"        type="string" required="no">

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="editar"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisición actualizada correctamente")>
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
        <cfargument name="id_requisicion"            type="string" required="true"/>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="eliminar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición eliminada correctamente")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="getFechaRegistro"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisiciones listas")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Victor Sanchez
            27/10/2015
            Lista el detalle de la requisicion para entrada por devolucion de salida --->
    <cffunction name="upL_RequisicionesDetalleEntradaDevolucionSalida" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'      type='numeric' required='true'>
        <cfargument name='id_Requisicion'     type='numeric' required='true'>


        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="upL_RequisicionesDetalleEntradaDevolucionSalida"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisiciones listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="updateEstatusAutorizacion" access="remote" returnformat="JSON">
        <cfargument name='id_Requisicion'         type='numeric' required='true'>
        <cfargument name='id_EstatusAutorizacion' type='numeric' required='true'>
        <cfargument name='id_Empresa'               type='numeric' required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="updateEstatusAutorizacion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición almacenada correctamente")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="seguimientoRequisicion"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisiciones listas")>
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
            <cfinvoke   component="#Application.RF.getPath('bro','Requisiciones')#"
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
        <cfargument name='id_requisicion'      type='string'  required='yes'>
        <cfargument name='estatus'             type='numeric' required='true'>
        <cfargument name='id_Empresa'          type='numeric' required='true'>
        <cfargument name='id_TipoRequisicion'  type='numeric' required='true'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="enviarRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición enviada correctamente")>
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
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
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
        <cfargument name='id_Requisicion'         type='numeric' required='true'>
        <cfargument name='id_EstatusAutorizacion' type='numeric' required='true'>
        <cfargument name='id_Empresa'           type='numeric' required='true'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                          method="FinalizarRequisicion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Requisición almacenada correctamente")>
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
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="listarInsumosAyuda"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Requisiciones listas")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="GuardarCMF" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string"  required="false">
        <cfargument name="id_Sucursal"          type="string"  required="false">
        <cfargument name="id_Proveedor"         type="string"  required="false">
        <cfargument name="id_Concepto"          type="string"  required="false">
        <cfargument name="im_SubTotal"          type="string"  required="false">
        <cfargument name="im_Descuento"         type="string"  required="false">
        <cfargument name="im_Iva"               type="string"  required="false">
        <cfargument name="im_Retencion"         type="string"  required="false">
        <cfargument name="im_Total"             type="string"  required="false">
        <cfargument name="id_Estatus"           type="string"  required="false">
        <cfargument name="fh_Entrega"           type="string"  required="false">
        <cfargument name="Conceptos"            type="array"   required="false">
        <cfargument name="dataXML"              type="struct"  required="false">
        <cfargument name="dataPDF"              type="struct"  required="false">
        <cfargument name="sn_Enviar"            type="boolean" required="false">
        <cfargument name="de_tipoFactor"        type="string"  required="false">
        <cfargument name="id_TipoComprobante"   type="string"  required="false">
        <cfargument name="Impuestos"            type="array"   required="false">
        <cfargument name="de_ComentariosOC"     type="string"  required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath("bro","Requisiciones")#"
                    method="GuardarCMF"
                    argumentcollection="#arguments#"
                    returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset Variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="GetRequisicionCMFById" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='string'  required='false'>
        <cfargument name='id_Requisicion'   type='numeric' required='false'>

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="GetRequisicionCMFById"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setJSON(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="EnviarRequisicionCMF" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='numeric' required='false'>
        <cfargument name='id_Requisicion'   type='numeric' required='false'>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="EnviarRequisicionCMF"
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

    <cffunction name="ModificarCMF" access="remote" returnformat="JSON">
        <cfargument name='id_Requisicion'       type='string'  required='true'>
        <cfargument name='id_Empresa'           type='string'  required='false'>
        <cfargument name='id_Sucursal'          type='string'  required='false'>
        <cfargument name='id_Proveedor'         type='string'  required='false'>
        <cfargument name='id_Concepto'          type='string'  required='false'>
        <cfargument name='im_SubTotal'          type='string'  required='false'>
        <cfargument name='im_Iva'               type='string'  required='false'>
        <cfargument name='im_Retencion'         type='string'  required='false'>
        <cfargument name='im_Total'             type='string'  required='false'>
        <cfargument name='id_Estatus'           type='string'  required='false'>
        <cfargument name='fh_Entrega'           type='string'  required='false'>
        <cfargument name='Conceptos'            type='array'   required='false'>
        <cfargument name='dataXML'              type='struct'  required='false'>
        <cfargument name='dataPDF'              type='struct'  required='false'>
        <cfargument name='sn_Enviar'            type='boolean' required='false'>
        <cfargument name='de_tipoFactor'        type='string'  required='false'>
        <cfargument name='id_TipoComprobante'   type='string'  required='false'>
        <cfargument name='Impuestos'            type='array'   required='false'>
        <cfargument name='de_ComentariosOC'     type='string'  required='false'>

        <cfset arguments.sn_Modificar = true>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="GuardarCMF"
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

    <cffunction name="EstatusCMF" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'           type='string' required='true'>
        <cfargument name='id_RequisicionCMF'    type='string' required='true'>
        <cfargument name='id_Estatus'           type='string' required='true'>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="EstatusCMF"
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

    <cffunction name="SucursalesAccesoEmpleadosCombo_Requisiciones" access="remote" returnformat="JSON">
      <cfargument name="id_Empresa"       type="string" required="false"/>

      <cfset var Local.result=structNew()>
      <cftransaction>
          <cftry>

              <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                        method="SucursalesAccesoEmpleadosCombo_Requisiciones"
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

    <cffunction name="getHistorialRequisicion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>
        <cfargument name="id_Empleado"    type="string" required="false"/>
        <cfargument name="id_Insumo"      type="string" required="false"/>
        <cfargument name="id_TipoMovimiento"     type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="getHistorialRequisicion"
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

    <cffunction name="getHistorialRequisicion_Filtros" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="getHistorialRequisicion_Filtros"
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

    <cffunction name="TiposRequisicionesDivisionesCombo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"         type="string" required="true"/>
        <cfargument name="id_TipoRequisicion" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="TiposRequisicionesDivisionesCombo"
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

    <cffunction name="listarRequisicionesToCopy" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Sucursal"        type="string" required="false"/>
        <cfargument name="id_TipoRequisicion" type="string" required="false"/>
        <cfargument name="id_Division"        type="string" required="false"/>
        <cfargument name="id_Requisicion"     type="string" required="false"/>
        <cfargument name="de_Requisicion"     type="string" required="false"/>
        <cfargument name="fn_Inicio"          type="string" required="false"/>
        <cfargument name="fn_Fin"             type="string" required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="listarRequisicionesToCopy"
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

    <cffunction name="GenerarCopiaRequisicion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                    method="GenerarCopiaRequisicion"
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

    <cffunction name="reporteRequisicionV2" access="remote" returnformat="JSON">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='estatus'        type='numeric' required='false'>
        <cfargument name='id_Empresa'         type='numeric' required='true'>
        
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                        method="reporteRequisicionV2"
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

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="listarDireccion" access="remote" returnformat="JSON">
        <cfargument name='id_Cliente'       type='string' required='yes'>
        <cfargument name='id_Domicilio'       type='string' required='no'>


        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','Requisiciones')#"
                      method="listarDireccion"
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
</cfcomponent>
