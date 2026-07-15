<cfcomponent>

    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>
    <cffunction name="MovimientosDevolucionParaNotaCredito" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"   type="numeric" required="false"/>
        <cfargument name="id_Sucursal"  type="numeric" required="true"/>
        <cfargument name="id_Almacen"   type="numeric" required="true"/>
        <cfargument name="id_Proveedor" type="numeric" required="true"/>
        <cfargument name="fh_Inicio"    type="string" required="true"/>
        <cfargument name="fh_Fin"       type="string" required="true"/>
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="MovimientosDevolucionParaNotaCredito"
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


    <cffunction name="listar" access="remote" returnformat="JSON">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="folio"            type="string" required="false"/>
        <cfargument name="requisicion"      type="string" required="false"/>
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
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

<!--- Victor Sanchez
        26/10/2015
        guarda la entrada por devolucion --->
    <cffunction name="GuardarEntradaPorDevolucion" access="remote" returnformat="JSON">
        <cfargument name="Insumos"    type="array" required="false"/>
        <cfargument name="Series"       type="array" required="false"/>
        <cfargument name="Movimientos"      type="array" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="GuardarEntradaPorDevolucion"
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
        28/12/2015
        lista los documentos por faltante o devolucion
     --->
    <cffunction name="upR_EntradaPorDevolucion_O_Faltante" access="remote" returnformat="JSON">
            <cfargument name="id_proveedor"    type="string" required="false"/>
            <cfargument name="fh_inicio"    type="string" required="false"/>
            <cfargument name="fh_fin"    type="string" required="false"/>
            <cfargument name="porFaltante"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upR_EntradaPorDevolucion_O_Faltante"
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
        28/12/2015
        lista los documentos por faltante o devolucion
     --->
    <cffunction name="upL_EntradaPorSurtidoDevolucionFaltante" access="remote" returnformat="JSON">
            <cfargument name="folio"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upL_EntradaPorSurtidoDevolucionFaltante"
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
        29/12/2015
        Registra las entradas de surtido por devolucion/faltante
     --->
    <cffunction name="RegistrarEntradaPorSurtidoDevolucionFaltante" access="remote" returnformat="JSON">
            <cfargument name="porFaltante"    type="string" required="false"/>
            <cfargument name="insumosSeriados"    type="array" required="false"/>
            <cfargument name="seleccionados"    type="array" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="RegistrarEntradaPorSurtidoDevolucionFaltante"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO"/>

                    <cfif Local.BRO.hasError()>
                            <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                            <cfset variables.ctrl.setJson(Local.BRO.getData())>
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
        05/11/2015
        lista los movimientos que fueron por entrada de devolucion por salida --->
    <cffunction name="upL_ConsultaDevolucionSalida" access="remote" returnformat="JSON">
<!---       <cfargument name="Insumos"    type="array" required="false"/>
        <cfargument name="Series"       type="array" required="false"/>
        <cfargument name="Movimientos"      type="array" required="false"/> --->
        <cfargument name="folio"    type="string" required="false"/>
        <cfargument name="nombre"    type="string" required="false"/>
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upL_ConsultaDevolucionSalida"
                              folio="#folio#"
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
        06/11/2015
        Trae el detalle de una entrada por devolucion de salida  --->
    <cffunction name="upR_EntradaDevolucionSalidaDetalle" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"              type="string" required="true"/>
        <cfargument name="id_almacen"               type="string" required="true"/>
        <cfargument name="id_movimiento"            type="string" required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upR_EntradaDevolucionSalidaDetalle"
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
        trae query de inventarios movimientos detalle para generar el reporte de existencias y movimientos
              --->
    <cffunction name="upR_InventariosMovimimientos" access="remote" returnformat="JSON">
            <cfargument name="id_Sucursal"    type="string" required="false"/>
            <cfargument name="id_Almacen"    type="string" required="false"/>
            <cfargument name="id_Insumo"    type="string" required="false"/>
            <cfargument name="fh_Inicio"    type="string" required="false"/>
            <cfargument name="fh_Fin"    type="string" required="false"/>
            <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
            <cfargument name="id_SubFamiliaInsumo"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upR_InventariosMovimimientos"
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
    22/10/2015
     funcion que devuelve las requisiciones que tengan movimientos de salida por consumo --->
    <cffunction name="upR_RequisicionesSalidaConsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Requisicion"               type="string" required="false"/>
        <cfargument name="nb_Empleado"                  type="string" required="false"/>
        <cfargument name="fh_inicial"                   type="string" required="false"/>
        <cfargument name="fh_final"                 type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="upR_RequisicionesSalidaConsumo"
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
    22/10/2015
     funcion que devuelve las requisiciones que tengan movimientos de salida por consumo --->
    <cffunction name="Obtener_InventariosMovimientosDetalle" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"                   type="string" required="false"/>
        <cfargument name="id_Sucursal"                  type="string" required="false"/>
        <cfargument name="id_Almacen"                   type="string" required="false"/>
        <cfargument name="id_Movimiento"                type="string" required="false"/>
        <cfargument name="nd_MovimientoDetalle"         type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="Obtener_InventariosMovimientosDetalle"
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

    <!--- funcion que va por los movimientos de salida y entrada por devolucion a proveedor --->
    <cffunction name="getmovements" access="remote" returnformat="JSON">
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="getmovements"
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

    <!--- funcion que va el detalle de insumos y datos de un movimiento en especifico de salida y entrada por devolucion a proveedor  24/09/2015--->
    <cffunction name="getmovementsdetail" access="remote" returnformat="JSON">
        <cfargument name="id_movimiento"            type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="getmovementsdetail"
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

    <!--- funcion que va por los movimientos de que se van ajustar correspondientes a un insumo --->
    <cffunction name="movimientosajustes" access="remote" returnformat="JSON">
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="false"/>
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <!--- <cfargument name="id_movimiento"          type="numeric" required="true"/> --->


            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="movimientosajustes"
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

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <cffunction name="getmovementsdetailofservice" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="getmovementsdetailofservice"
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

    <!--- funcion que devuelve los movimientos de entrada de servicios --->
    <cffunction name="getmovementsofentrada" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_OrdenCompra"           type="string" required="false"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>
        <cfargument name="SubioFactura"             type="numeric" required="false"/>
        <cfargument name="nu_Siniestro"             type="string" required="false"/>



            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="getmovementsofentrada"
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

    <!--- funcion que seta el id_tiposugerenciacargo de inventarios movimientos --->
    <cffunction name="setcargo" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"              type="numeric"      required="true"/>
        <cfargument name="id_almacen"               type="numeric"      required="true"/>
        <cfargument name="insumosajuste"            type="array"        required="true"/>
        <cfargument name="id_empresa"               type="numeric"      required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="setcargo"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO"/>

                    <cfif Local.BRO.hasError()>
                            <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                            <cfset variables.ctrl.rollback()>
                        <cfelse>
                            <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
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


    <cffunction name="listarSalidasporAjuste" access="remote" returnformat="JSON">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="listarSalidasporAjuste"
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

    <!--- JULIO CESAR ACOSTA LOPEZ 19/03/2015 --->
    <cffunction name="listarEntradasporAjuste" access="remote" returnformat="JSON">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="listarEntradasporAjuste"
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

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Registra los movimientos de salida de inventario por una solicitud de traspaso --->
    <cffunction name="creaMovimientoSalidaPorTraspaso" access="remote" returnformat="JSON">
        <cfargument name="id_inventarioTraspaso"  type="numeric" required="true"/>
        <cfargument name="id_UsuarioRecibio"      type="string" required="false"/>
        <cfargument name="de_Recibio"             type="string" required="false"/>
        <cfargument name="id_sucursalOrigen"      type="numeric" required="false"/>
        <cfargument name="id_almacenOrigen"       type="numeric" required="false"/>
        <cfargument name="detalles"               type="array"   required="true"/>
        <cfargument name="de_Comentarios"         type="string"  required="false"/>
        <cfargument name="id_Flete"         type="string"  required="false"/>
        <cfargument name="im_Flete"         type="string"  required="false"/>
        <cfargument name="de_Ruta"         type="string"  required="false"/>
        <cfargument name="de_NombrePDF"         type="string"  required="false"/>
        <cfargument name="de_Paqueteria"         type="string"  required="false"/>
        <cfargument name="de_Guia"         type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="creaMovimientoSalidaPorTraspaso"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Movimientos registrados correctamente.")>
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

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Obtiene los empleados con usuario y/o las personas que ya han sido registradas en
          movimientos anteriores.    --->
    <cffunction name="getPersonasReciben" access="remote" returnformat="JSON">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                      method="getPersonasReciben"
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
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 30/04/2015
          Obtiene los movimientos de inventario que se generaron para la solicitud de traspaso   --->
    <cffunction name="getByTraspaso" access="remote" returnformat="JSON">
        <cfargument name="id_inventarioTraspaso" type="numeric" required="true">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                      method="getByTraspaso"
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
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Registra los movimientos de salida de inventario por una solicitud de traspaso     --->
    <cffunction name="creaMovimientoEntradaPorTraspaso" access="remote" returnformat="JSON">
        <cfargument name="id_inventarioTraspaso"  type="numeric" required="true"/>
        <cfargument name="id_movimiento"          type="string" required="false"/> <!--- Movimiento de salida --->
        <cfargument name="id_sucursalOrigen"      type="string" required="false"/>
        <cfargument name="id_almacenOrigen"       type="string" required="false"/>
        <cfargument name="id_TipoMovimiento"      type="string"   required="false"/>
        <cfargument name="detalles"               type="array"   required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="creaMovimientoEntradaPorTraspaso"
                          argumentcollection="#Arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Movimientos registrados correctamente.")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>



    <cffunction name="generarRegresoPDF" access="remote" returnformat="JSON">
        <cfargument name='Movimientos'          type='array'  required='true'>
        <cfargument name='Insumos'  type='array'  required='true'>
        <cfargument name='Series'               type='array'  required='true'>


        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="generarRegresoPDF"
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



    <!--- Victor Sanchez --->
    <cffunction name="generaPDF_MovimientoYExistencia" access="remote" returnformat="JSON">
        <cfargument name='sucursal' type='string'  required='true'>
        <cfargument name='almacen'  type='string'  required='true'>
        <cfargument name='insumo'   type='struct'  required='false'>
        <cfargument name='fh_inicio'    type='string'  required='true'>
        <cfargument name='fh_fin'   type='string'  required='true'>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="true"/>
        <cfargument name="nb_SubFamiliaInsumo"    type="string" required="true"/>
        <cfargument name='datos'    type='array'  required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="generaPDF_MovimientoYExistencia"
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


    <cffunction name="generaExcel_MovimientoYExistencia" access="remote" returnformat="JSON">
        <cfargument name='sucursal' type='string'  required='true'>
        <cfargument name='almacen'  type='string'  required='true'>
        <cfargument name='insumo'   type='struct'  required='false'>
        <cfargument name='fh_inicio'    type='string'  required='true'>
        <cfargument name='fh_fin'   type='string'  required='true'>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="true"/>
        <cfargument name="nb_SubFamiliaInsumo"    type="string" required="true"/>
        <cfargument name='datos'    type='array'  required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="generaExcel_MovimientoYExistencia"
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

    <!--- Jesus Reyes --->
    <cffunction name="repSalidasPorAlmacen" access="remote" returnformat="JSON">
        <cfargument name='id_sucursal'          type='string'  required='false' default="">
        <cfargument name='id_almacen'           type='string'  required='false' default="">
        <cfargument name='id_insumo'            type='string'  required='false' default="">
        <cfargument name='id_tipoMovimiento'    type='string'  required='false' default="">
        <cfargument name='fh_inicio'            type='string'  required='false' default="">
        <cfargument name='fh_fin'               type='string'  required='false' default="">
        <cfargument name='page'                 type='string'  required='false' default="1">
        <cfargument name='pageSize'             type='string'  required='false' default="10">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                      method="repSalidasPorAlmacen"
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
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="repSalidasPorAlmacenPDF" access="remote" returnformat="JSON">
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='nb_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='nb_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='nb_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='nb_tipoMovimiento'    type='string'  required='false'>
        <!--- Fecha formato YYYY/mm/dd --->
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <!--- Fecha formato dd/mm/YYYY --->
        <cfargument name='fh_inicio2'           type='string'  required='true'>
        <cfargument name='fh_fin2'              type='string'  required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="repSalidasPorAlmacenPDF"
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

    <cffunction name="repSalidasPorAlmacenExcel" access="remote" returnformat="JSON">
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='nb_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='nb_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='nb_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='nb_tipoMovimiento'    type='string'  required='false'>
        <!--- Fecha formato YYYY/mm/dd --->
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <!--- Fecha formato dd/mm/YYYY --->
        <cfargument name='fh_inicio2'           type='string'  required='true'>
        <cfargument name='fh_fin2'              type='string'  required='true'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="repSalidasPorAlmacenExcel"
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


    <!--- Jesus Reyes --->
    <cffunction name="impresionDeMovimientos" access="remote" returnformat="JSON">
        <cfargument name='id_Movimiento'        type='string'  required='false'>
        <cfargument name='id_Empresa'        type='string'  required='false'>
        <cfargument name='id_Sucursal'        type='string'  required='false'>
        <cfargument name='id_Almacen'        type='string'  required='false'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="impresionDeMovimientos"
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

    <!--- Jesus Reyes --->
    <cffunction name="impresionSalidasConsumo" access="remote" returnformat="JSON">
        <cfargument name='id_Movimiento'        type='string'  required='false'>
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="impresionSalidasConsumo"
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

    <!--- Jesus Reyes --->
    <cffunction name="impresionDeMovimientosServicio" access="remote" returnformat="JSON">
        <cfargument name='id_Empresa'       type='string'  required='false'>
        <cfargument name='id_Sucursal'      type='string'  required='false'>
        <cfargument name='id_Movimiento'    type='string'  required='false'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="impresionDeMovimientosServicio"
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

    <!--- funcion que devuelve los movimientos de entrada de servicios --->
    <cffunction name="GastosMovimientosContable" access="remote" returnformat="JSON">
        <cfargument name = "fh_inicioMovimiento"           type="string"  required="false"  default=""/>
        <cfargument name = "fh_finMovimiento"              type="string"  required="false"  default=""/>
        <cfargument name = "id_proveedor"                  type="string"  required="false"  default=""/>
        <cfargument name = "id_sucursal"                   type="string"  required="false"  default=""/>
        <cfargument name = "page"                          type="numeric" required="true"   default=""/>
        <cfargument name = "pageSize"                      type="numeric" required="true"   default=""/>
        <cfargument name = "id_FolioMov"                   type="string"  required="false">
        <cfargument name = "id_FolioFac"                   type="string"  required="false">
        <cfargument name = "id_FolioOC"                    type="string"  required="false">
        <cfargument name = "id_Moneda"                     type="string" required="false">

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="GastosMovimientosContable"
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

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <cffunction name="GastosMovimientosdetalleContable" access="remote" returnformat="JSON">
        <cfargument name="id_movimiento"            type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="GastosMovimientosdetalleContable"
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


    <cffunction name="listarGeneral" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="numeric" required="false"/>
        <cfargument name="id_Sucursal"          type="numeric" required="false"/>
        <cfargument name="id_Almacen"           type="numeric" required="false"/>

        <cfargument name="fh_Inicio"            type="string"   required="false"/>
        <cfargument name="fh_Fin"               type="string"   required="false"/>
        <cfargument name="fl_Movimiento"        type="string"   required="false"/>
        <cfargument name="id_TipoMovimiento"    type="numeric"  required="false"/>
        <cfargument name="nb_Insumo"            type="string"   required="false"/>
        <cfargument name="id_Estatus"           type="numeric"  required="false"/>
        <cfargument name="nu_FolioMovimiento"   type="string"   required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="listarGeneral"
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


    <cffunction name="CancelarMovimiento" access="remote" returnformat="JSON">
        <cfargument name="id_movimiento"        type="numeric" required="true"/>
        <cfargument name="de_observaciones"     type="string" required="true"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="CancelarMovimiento"
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


    <cffunction name="ObtenerTarjetaAlmacen" access="remote" returnformat="JSON">
        <cfargument name="id_Sucursal" type="string" required="true"/>
        <cfargument name="id_Almacen" type="string" required="true"/>
        <cfargument name="id_FamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="fh_Inicio" type="string" required="false" default=""/>
        <cfargument name="fh_Fin" type="string" required="false" default=""/>
        <cfargument name="nb_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_AlmacenFisico" type="string" required="false" default=""/>
            <!--- <cftransaction> --->
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="ObtenerTarjetaAlmacen"
                              argumentcollection="#arguments#"
                              returnvariable="Local.BRO"/>

                    <cfif Local.BRO.hasError()>
                            <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                            <!--- <cfset variables.ctrl.rollback()> --->
                        <cfelse>
                            <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                            <cfset variables.ctrl.setJson(Local.BRO.getData())>
                    </cfif>

                    <cfcatch type="any">
                        <cfset variables.ctrl.setCatch(cfcatch)>
                        <!--- <cfset variables.ctrl.rollback()> --->
                    </cfcatch>
                </cftry>
            <!--- </cftransaction> --->
        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="Kardex" access="remote" returnformat="JSON">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="id_sucursal"          type="string" required="false"/>
        <cfargument name="id_almacen"           type="string" required="false"/>
        <cfargument name="id_Naturaleza"        type="string" required="false" default=""/>
        <cfargument name="id_TipoMovimiento"    type="string" required="false" default=""/>
        <cfargument name="fh_movimientoIni"     type="string" required="true"/>
        <cfargument name="fh_movimientoFin"     type="string" required="true"/>
        <cfargument name="id_insumo"            type="string" required="false" default=""/>
        <cfargument name="id_TipoNegocio"       type="string" required="false" default=""/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                method="Kardex"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>

            <cfelse>
                <cfset Variables.ctrl.setMessage("Reporte Listo")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    
    <cffunction name="getSalidasConsumo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string" required="false"/>
        <cfargument name="id_Requisicion"          type="string" required="false"/>

            <cftransaction>
                <cftry>
                    <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                              method="getSalidasConsumo"
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

    <cffunction name="impresionSalidasConsumoBandejaEntrada" access="remote" returnformat="JSON">
        <cfargument name='id_Movimiento'        type='string'  required='false'>
        <cfargument name='id_Empresa'        type='string'  required='false'>
        <cfargument name='id_Sucursal'        type='string'  required='false'>
        <cfargument name='id_Almacen'        type='string'  required='false'>

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="impresionSalidasConsumoBandejaEntrada"
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

    <cffunction name="guardarFletes" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"  type="string" required="true"/>
        <cfargument name="id_inventarioTraspaso"  type="string" required="true"/>
        <cfargument name="id_Flete"         type="string"  required="false"/>
        <cfargument name="im_Flete"         type="string"  required="false"/>
        <cfargument name="de_Ruta"         type="string"  required="false"/>
        <cfargument name="de_NombrePDF"         type="string"  required="false"/>
        <cfargument name="de_Paqueteria"         type="string"  required="false"/>
        <cfargument name="de_Guia"         type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="guardarFletes"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Movimientos registrados correctamente.")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="impresionSalidasTraspaso" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"              type="string" required="false">
        <cfargument name="id_InventarioTraspaso"   type="string" required="false">
        <cfargument name="id_InventarioMovimiento" type="string" required="false">

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
                          method="impresionSalidasTraspaso"
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
