<!--- Se agregaron dos columnas a la tabla InventariosMovimientosDetalle, checar cualquier funcion del wiz que use estos datos  --->
<cfcomponent extends="wiz/inventariosmovimientosdetalle">
    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>    
            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDetalleInsumos
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
   </cffunction>

   <!--- julio cesar acosta lopez 
           28/07/2015
           funcion que setea el id_poliza de iventarios movimientos detalle al momento de generar una poliza esto para generar
           un enlace entre polizas e inventarios movimientos detalle --->
    <cffunction name="editarpoliza"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string"  required="true"/>
        <cfargument name="fh_inicio"                type="string"  required="true"/>
        <cfargument name="fh_fin"                   type="string"  required="true"/>
        <cfargument name="id_Poliza"                type="string"  required="true"/>
        
            <cfquery datasource="#variables.cnx#">
                exec upU_InventariosMovimientosDetallesetidpoliza 
                                                #arguments.id_Empresa#,
                                                '#arguments.fh_inicio#',
                                                '#arguments.fh_fin#', 
                                                #arguments.id_Poliza#

            </cfquery>
    </cffunction>

<!--- Victor Sanchez
        24/12/2015
        actualiza el IMD para los insumos devueltos
        @id_Empresa int,
@id_Sucursal int,
@id_Almacen int,
@id_Movimiento int,
@id_Insumo int,
@nu_CantidadDevolucion int
 --->
    <cffunction name="upU_ActualizaMovimientoDevolucion"    access="public" returntype="void">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"                    type="numeric"   required="true"/>
        <cfargument name="id_Insumo"                        type="numeric"  required="true"/>
        <cfargument name="nu_CantidadDevolucion"            type="numeric"  required="false"/>

            <cfquery datasource="#variables.cnx#">
                exec upU_ActualizaMovimientoDevolucion 
                                        #arguments.id_Empresa#, 
                                        #arguments.id_Sucursal#,
                                        #arguments.id_Almacen#,
                                        #arguments.id_Movimiento#,
                                        #arguments.id_Insumo#,
                                        #arguments.nu_CantidadDevolucion#
            </cfquery>
    </cffunction>

   <cffunction name="listarSalidasAlmacenporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>    
            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDetalleInsumosSalidasporAjuste
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
   </cffunction>

   <!--- JULIO CESAR ACOSTA LOPEZ 19/03/2015 --->
   <cffunction name="listarEntradasAlmacenporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>    
            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDetalleInsumosEntradasporAjuste
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
   </cffunction>


    <cffunction name="NextIdInventarioMovimientoDetalle" access="public" returntype="string">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Sucursal"               type="numeric" required="true"/>
        <cfargument name="id_Almacen"                type="numeric" required="true"/>
        <cfargument name="id_Movimiento"             type="numeric" required="true"/>

                <cfquery name="Local.MovimientoDetalle" datasource="#variables.cnx#" >
                    exec upR_InventariosMovimientosDetalleNextID
                                                  #arguments.id_Empresa#,
                                                  #arguments.id_Sucursal#,
                                                  #arguments.id_Almacen#,
                                                  #arguments.id_Movimiento#
                </cfquery>
            <cfreturn Local.MovimientoDetalle.nextID />
    </cffunction>
    
    <!--- <cffunction name="Agregar"    access="public" returntype="void">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"                    type="numeric"   required="true"/>
        <cfargument name="nd_MovimientoDetalle"             type="numeric"  required="true"/>
        <cfargument name="id_Requisicion"                   type="numeric"  required="true"/>
        <cfargument name="id_RequisicionDetalle"            type="numeric"  required="true"/>
        <cfargument name="id_CentroCosto"                   type="string"  required="false"/>
        <cfargument name="CantidadaSurtir"                  type="numeric"  required="true"/>
        <cfargument name="nu_cantidadRecibidaTraspaso"      type="numeric"  required="false"/>
        <cfargument name="id_Insumo"                        type="numeric"  required="true"/>
        <cfargument name="id_grupoGasto"                    type="string"  required="false"/>
        <cfargument name="id_conceptoGasto"                 type="string"  required="false"/>
        <cfargument name="id_tipomovimiento"                type="numeric"  required="false"/>

            <cfquery datasource="#variables.cnx#">
                exec upC_InventariosMovimientosDetalle 
                                        #arguments.id_Empresa#, 
                                        #arguments.id_Sucursal#,
                                        #arguments.id_Almacen#,
                                        #arguments.id_Movimiento#,
                                        #arguments.nd_MovimientoDetalle#,
                                        #arguments.id_Requisicion#,
                                        #arguments.id_RequisicionDetalle#,
                                        <cfif isDefined("arguments.id_CentroCosto") AND #arguments.id_CentroCosto# NEQ ''>#arguments.id_CentroCosto#<cfelse>NULL</cfif>,
                                        #arguments.CantidadaSurtir#,
                                        <cfif isDefined("arguments.nu_cantidadRecibidaTraspaso")>#arguments.nu_cantidadRecibidaTraspaso#<cfelse>NULL</cfif>,
                                        #arguments.id_Insumo#,
                                        <cfif isDefined("arguments.id_grupoGasto") AND #arguments.id_grupoGasto# NEQ ''>#arguments.id_grupoGasto#<cfelse>NULL</cfif>,
                                        <cfif isDefined("arguments.id_conceptoGasto")>#arguments.id_conceptoGasto#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_tipomovimiento") AND Arguments.id_tipomovimiento NEQ ''>#Arguments.id_tipomovimiento#<cfelse>NULL</cfif>
            </cfquery>
    </cffunction> --->

    <cffunction name="Agregar"    access="public" returntype="query">
        <cfargument name="id_Empresa"                  type="numeric" required="true"/>
        <cfargument name="id_Sucursal"                 type="numeric" required="true"/>
        <cfargument name="id_Almacen"                  type="numeric" required="true"/>
        <cfargument name="id_Movimiento"               type="numeric" required="true"/>
        <cfargument name="id_Requisicion"              type="numeric" required="false"/>
        <cfargument name="id_RequisicionDetalle"       type="numeric" required="false"/>
        <cfargument name="id_CentroCosto"              type="string"  required="false"/>
        <cfargument name="nu_Cantidad"                 type="numeric" required="true"/>
        <cfargument name="nu_cantidadRecibidaTraspaso" type="numeric" required="false"/>
        <cfargument name="id_Insumo"                   type="numeric" required="true"/>
        <cfargument name="im_Total"                    type="numeric" required="true"/>
        <cfargument name="id_grupoGasto"               type="string"  required="false"/>
        <cfargument name="id_conceptoGasto"            type="string"  required="false"/>
        <cfargument name="id_tipomovimiento"           type="numeric" required="false"/>
        <cfargument name="id_TipoCosteo"               type="numeric" required="false"/>

        <cfstoredproc procedure="upC_InventariosMovimientosDetalle" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                  value="#arguments.id_Empresa#"                  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                 value="#arguments.id_Sucursal#"                 null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"                  value="#arguments.id_Almacen#"                  null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"               value="#arguments.id_Movimiento#"               null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"              value="#arguments.id_Requisicion#"              null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle"       value="#arguments.id_RequisicionDetalle#"       null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"              value="#arguments.id_CentroCosto#"              null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Cantidad"                 value="#arguments.nu_Cantidad#"                 null="#iif(isNumeric(arguments.nu_Cantidad),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_cantidadRecibidaTraspaso" value="#arguments.nu_cantidadRecibidaTraspaso#" null="#iif(isNumeric(arguments.nu_cantidadRecibidaTraspaso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"                   value="#arguments.id_Insumo#"                   null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Total"                    value="#arguments.im_Total#"                    null="#iif(isNumeric(arguments.im_Total),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_grupoGasto"               value="#arguments.id_grupoGasto#"               null="#iif(isNumeric(arguments.id_grupoGasto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_conceptoGasto"            value="#arguments.id_conceptoGasto#"            null="#iif(isNumeric(arguments.id_conceptoGasto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipomovimiento"           value="#arguments.id_tipomovimiento#"           null="#iif(isNumeric(arguments.id_tipomovimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoCosteo"               value="#arguments.id_TipoCosteo#"               null="#iif(isNumeric(arguments.id_TipoCosteo),false,true)#">
            <cfprocresult name="Local.InvMovDetData" resultset="1">
        </cfstoredproc>

            <!--- <cfquery name="Local.InvMovDetData" datasource="#variables.cnx#">
                exec upC_InventariosMovimientosDetalle
                            #arguments.id_Empresa#,
                            #arguments.id_Sucursal#,
                            #arguments.id_Almacen#,
                            #arguments.id_Movimiento#,
                            <cfif isDefined("arguments.id_Requisicion") AND #arguments.id_Requisicion# NEQ ''>#arguments.id_Requisicion#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.id_RequisicionDetalle") AND #arguments.id_RequisicionDetalle# NEQ ''>#arguments.id_RequisicionDetalle#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.id_CentroCosto") AND #arguments.id_CentroCosto# NEQ ''>#arguments.id_CentroCosto#<cfelse>NULL</cfif>,
                            #arguments.nu_Cantidad#,
                            <cfif isDefined("arguments.nu_cantidadRecibidaTraspaso") AND #arguments.nu_cantidadRecibidaTraspaso# NEQ ''>#arguments.nu_cantidadRecibidaTraspaso#<cfelse>NULL</cfif>,
                            #arguments.id_Insumo#,
                            #arguments.im_Total#,
                            <cfif isDefined("arguments.id_grupoGasto") AND #arguments.id_grupoGasto# NEQ ''>#arguments.id_grupoGasto#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.id_conceptoGasto") AND #arguments.id_conceptoGasto# NEQ ''>#arguments.id_conceptoGasto#<cfelse>NULL</cfif>,
                            <cfif isDefined("Arguments.id_tipomovimiento") AND Arguments.id_tipomovimiento NEQ ''>#Arguments.id_tipomovimiento#<cfelse>NULL</cfif>
                            <cfif isDefined("Arguments.id_tipomovimiento") AND Arguments.id_tipomovimiento NEQ ''>#Arguments.id_tipomovimiento#<cfelse>NULL</cfif>
            </cfquery> --->

        <cfreturn Local.InvMovDetData>
    </cffunction>

    <cffunction name="AgregarRegistroSalidaAjuste"    access="public" returntype="any">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"                    type="numeric"   required="true"/>    
        <cfargument name="CantidadaSurtir"                  type="numeric"  required="true"/>
        <cfargument name="id_Insumo"                        type="numeric"  required="true"/>

            <cfquery  name="Local.rs" datasource="#variables.cnx#">
                exec upC_InventariosMovimientosDetalleEntrSaliporAjuste 
                                        #arguments.id_Empresa#, 
                                        #arguments.id_Sucursal#,
                                        #arguments.id_Almacen#,
                                        #arguments.id_Movimiento#,                                  
                                        #arguments.CantidadaSurtir#,
                                        #arguments.id_Insumo#           
            </cfquery>
                <cfreturn Local.RS.nd_MovimientoDetalle>
    </cffunction>

    <cffunction name="AgregarRegistroEntradaAjuste"    access="public" returntype="any">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"                    type="numeric"   required="true"/>    
        <cfargument name="CantidadaSurtir"                  type="numeric"  required="true"/>
        <cfargument name="id_Insumo"                        type="numeric"  required="true"/>
        <cfargument name="im_PrecioUnitario"                type="string"  required="true"/>
        <cfargument name="id_Moneda"                        type="numeric"  required="true"/>
        <cfargument name="im_TipoCambio"                    type="numeric"  required="true"/>
        <cfargument name="im_precioTotalEntrada"            type="string"  required="true"/>
        <cfargument name="sumatoriaIm_totalMN"              type="string"  required="true"/>
        <cfargument name="nu_cantidadFacturada"             type="string"  required="true"/>

            <cfquery   name="Local.rs" datasource="#variables.cnx#">
                exec upC_InventariosMovimientosDetalleEntrSaliporAjuste 
                                        #arguments.id_Empresa#, 
                                        #arguments.id_Sucursal#,
                                        #arguments.id_Almacen#,
                                        #arguments.id_Movimiento#,                                  
                                        #arguments.CantidadaSurtir#,
                                        #arguments.id_Insumo#,
                                        #arguments.im_PrecioUnitario#,
                                        #arguments.id_Moneda#,
                                        #arguments.im_TipoCambio#,
                                        '#arguments.im_precioTotalEntrada#',
                                        '#arguments.sumatoriaIm_totalMN#',
                                        '#arguments.nu_cantidadFacturada#'          
            </cfquery>
                <cfreturn Local.RS.nd_MovimientoDetalle>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 30/04/2015
          Obtiene el detalle del movimiento especificado para dar entradas a inventario
          por solicitud de traspaso. --->
    <cffunction name="getByMovimientoEntradasTraspaso"    access="public" returntype="query">
        <cfargument name="id_Empresa"            type="numeric" required="true"/>
        <cfargument name="id_SucursalDestino"    type="numeric" required="true"/>
        <cfargument name="id_AlmacenDestino"     type="numeric" required="true"/>
        <cfargument name="id_sucursalOrigen"     type="numeric" required="true"/>
        <cfargument name="id_almacenOrigen"      type="numeric" required="true"/>
        <cfargument name="id_movimiento"         type="numeric" required="true"/>
        <cfargument name="id_inventarioTraspaso" type="numeric" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#">
            exec upL_InventariosMovimientosDetalleByMovimientoEntradasTraspasos 
                                    #arguments.id_Empresa#, 
                                    #arguments.id_SucursalDestino#,
                                    #arguments.id_AlmacenDestino#,
                                    #arguments.id_sucursalOrigen#,
                                    #arguments.id_almacenOrigen#,
                                    #arguments.id_inventarioTraspaso#,
                                    #arguments.id_movimiento#
        </cfquery>
        <cfreturn Local.rs>
    </cffunction>

    <!--- Autor: Mario Mejia
          Fecha: 27/08/2015
          Actualizamos el nu_CantidadRecibidaTraspaso de un movimiento dado --->
    <cffunction name="setCantidadRecibidaTraspaso"    access="public" returntype="void">
        <cfargument name="id_Empresa"            type="numeric" required="true"/>
        <cfargument name="id_Sucursal"           type="numeric" required="true"/> <!--- La sucursal origen --->
        <cfargument name="id_Almacen"            type="numeric" required="true"/> <!--- EL almacen origen --->
        <cfargument name="id_movimiento"         type="numeric" required="true"/>
        <cfargument name="nd_MovimientoDetalle"  type="numeric" required="true"/>
        <cfargument name="id_insumo"             type="numeric" required="true"/>
        <cfargument name="nu_CantidadRecibidaTraspaso"  type="numeric" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#">
            exec upU_InventariosMovimientosDetalleSetCantidadRecibidaTraspaso 
                                    #arguments.id_Empresa#, 
                                    #arguments.id_Sucursal#,
                                    #arguments.id_Almacen#,
                                    #arguments.id_movimiento#,
                                    #arguments.nd_MovimientoDetalle#,
                                    #arguments.id_insumo#,
                                    #arguments.nu_CantidadRecibidaTraspaso#
        </cfquery>
    </cffunction>
<cffunction name="AgregarInventarioMovDetalle" access="public" returntype="any">
    <cfargument name="id_Empresa"                      type="numeric" required="yes">
    <cfargument name="id_Sucursal"                     type="numeric" required="yes">
    <cfargument name="id_Almacen"                      type="numeric" required="yes">
    <cfargument name="id_Movimiento"                   type="numeric" required="yes">
    <cfargument name="id_Insumo"                       type="numeric" required="yes">
    <cfargument name="id_CentroCosto"                  type="string"  required="no">
    <cfargument name="nu_Cantidad"                     type="numeric" required="yes">
    <cfargument name="nu_CantidadRecibidaTraspaso"     type="numeric" required="no">
    <cfargument name="nu_CantidadDevolucion"           type="numeric" required="no">
    <cfargument name="nu_CantidadFacturada"            type="numeric" required="no">
    <cfargument name="im_PrecioUnitarioEntrada"        type="string"  required="no">
    <cfargument name="im_PrecioTotalEntrada"           type="numeric" required="no">
    <cfargument name="id_MonedaEntrada"                type="numeric" required="no">
    <cfargument name="im_TipoCambioEntrada"            type="numeric" required="no">
    <cfargument name="im_TotalMN"                      type="numeric" required="no">
    <cfargument name="nu_ExistenciaAnterior"           type="numeric" required="no">
    <cfargument name="id_TipoCosteo"                   type="numeric" required="no">
    <cfargument name="id_SucursalProveniente"          type="numeric" required="no">
    <cfargument name="id_AlmacenProveniente"           type="numeric" required="no">
    <cfargument name="id_MovimientoProveniente"        type="numeric" required="no">
    <cfargument name="nd_MovimientoDetalleProveniente" type="numeric" required="no">
    <cfargument name="id_OrdenDeCompra"                type="numeric" required="no">
    <cfargument name="id_OrdenDeCompraDetalle"         type="numeric" required="no">
    <cfargument name="id_Requisicion"                  type="string" required="no">
    <cfargument name="id_RequisicionDetalle"           type="string" required="no">
    <cfargument name="de_CausaDevolucion"              type="string"  required="no">
    <cfargument name="id_TipoDevolucion"               type="numeric" required="no">
    <cfargument name="id_GrupoGasto"                   type="string"  required="no">
    <cfargument name="id_ConceptoGasto"                type="string"  required="no">
    <cfargument name="id_Poliza"                       type="numeric" required="no">
    <cfargument name="id_TipoMovimiento"               type="numeric" required="no">
    <cfargument name="nu_CantidadConvertir"            type="numeric" required="no">
    <cfargument name="sn_ValidarPresupuesto"            type="numeric" required="no">

    <cfstoredproc procedure="upC_InventariosMovimientosDetalle_Agregar" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                      value="#arguments.id_Empresa#"                      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                     value="#arguments.id_Sucursal#"                     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"                      value="#arguments.id_Almacen#"                      null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"                   value="#arguments.id_Movimiento#"                   null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"                       value="#arguments.id_Insumo#"                       null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"                  value="#arguments.id_CentroCosto#"                  null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Cantidad"                     value="#arguments.nu_Cantidad#"                     null="#iif(isNumeric(arguments.nu_Cantidad),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_CantidadRecibidaTraspaso"     value="#arguments.nu_CantidadRecibidaTraspaso#"     null="#iif(isNumeric(arguments.nu_CantidadRecibidaTraspaso),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_CantidadDevolucion"           value="#arguments.nu_CantidadDevolucion#"           null="#iif(isNumeric(arguments.nu_CantidadDevolucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_CantidadFacturada"            value="#arguments.nu_CantidadFacturada#"            null="#iif(isNumeric(arguments.nu_CantidadFacturada),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_PrecioUnitarioEntrada"        value="#arguments.im_PrecioUnitarioEntrada#"        null="#iif(isNumeric(arguments.im_PrecioUnitarioEntrada),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_PrecioTotalEntrada"           value="#arguments.im_PrecioTotalEntrada#"           null="#iif(isNumeric(arguments.im_PrecioTotalEntrada),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_MonedaEntrada"                value="#arguments.id_MonedaEntrada#"                null="#iif(isNumeric(arguments.id_MonedaEntrada),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambioEntrada"            value="#arguments.im_TipoCambioEntrada#"            null="#iif(isNumeric(arguments.im_TipoCambioEntrada),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalMN"                      value="#arguments.im_TotalMN#"                      null="#iif(isNumeric(arguments.im_TotalMN),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_ExistenciaAnterior"           value="#arguments.nu_ExistenciaAnterior#"           null="#iif(isNumeric(arguments.nu_ExistenciaAnterior),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoCosteo"                   value="#arguments.id_TipoCosteo#"                   null="#iif(isNumeric(arguments.id_TipoCosteo),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalProveniente"          value="#arguments.id_SucursalProveniente#"          null="#iif(isNumeric(arguments.id_SucursalProveniente),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AlmacenProveniente"           value="#arguments.id_AlmacenProveniente#"           null="#iif(isNumeric(arguments.id_AlmacenProveniente),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_MovimientoProveniente"        value="#arguments.id_MovimientoProveniente#"        null="#iif(isNumeric(arguments.id_MovimientoProveniente),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_MovimientoDetalleProveniente" value="#arguments.nd_MovimientoDetalleProveniente#" null="#iif(isNumeric(arguments.nd_MovimientoDetalleProveniente),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra"                value="#arguments.id_OrdenDeCompra#"                null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompraDetalle"         value="#arguments.id_OrdenDeCompraDetalle#"         null="#iif(isNumeric(arguments.id_OrdenDeCompraDetalle),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"                  value="#arguments.id_Requisicion#"                  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle"           value="#arguments.id_RequisicionDetalle#"           null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_CausaDevolucion"              value="#arguments.de_CausaDevolucion#"              null="#iif(len(arguments.de_CausaDevolucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoDevolucion"               value="#arguments.id_TipoDevolucion#"               null="#iif(isNumeric(arguments.id_TipoDevolucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoGasto"                   value="#arguments.id_GrupoGasto#"                   null="#iif(isNumeric(arguments.id_GrupoGasto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ConceptoGasto"                value="#arguments.id_ConceptoGasto#"                null="#iif(isNumeric(arguments.id_ConceptoGasto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Poliza"                       value="#arguments.id_Poliza#"                       null="#iif(isNumeric(arguments.id_Poliza),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoMovimiento"               value="#arguments.id_TipoMovimiento#"               null="#iif(isNumeric(arguments.id_TipoMovimiento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_CantidadConvertir"            value="#arguments.nu_CantidadConvertir#"            null="#iif(isNumeric(arguments.nu_CantidadConvertir),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@sn_ValidarPresupuesto"           value="#arguments.sn_ValidarPresupuesto#"           null="#iif(isNumeric(arguments.sn_ValidarPresupuesto),false,true)#">
        <cfprocresult name="Local.RS" resultset="1">
    </cfstoredproc>

    <!--- <cfquery name ="Local.RS" datasource="#variables.cnx#" >
        EXECUTE upC_InventariosMovimientosDetalle_Agregar
                            #id_Empresa#,
                            #id_Sucursal#,
                            #id_Almacen#,
                            #id_Movimiento#,
                            #id_Insumo#,
                            <cfif Not IsDefined('arguments.id_CentroCosto') OR #id_CentroCosto# EQ ''>NULL<cfelse>#id_CentroCosto#</cfif>,
                            #nu_Cantidad#,
                            <cfif Not IsDefined('arguments.nu_CantidadRecibidaTraspaso')>NULL<cfelse>#nu_CantidadRecibidaTraspaso#</cfif>,
                            <cfif Not IsDefined('arguments.nu_CantidadDevolucion')>NULL<cfelse>#nu_CantidadDevolucion#</cfif>,
                            <cfif Not IsDefined('arguments.nu_CantidadFacturada')>NULL<cfelse>#nu_CantidadFacturada#</cfif>,
                            <cfif IsDefined('arguments.im_PrecioUnitarioEntrada') AND #arguments.im_PrecioUnitarioEntrada# NEQ ''>#im_PrecioUnitarioEntrada#<cfelse>NULL</cfif>,
                            <cfif Not IsDefined('arguments.im_PrecioTotalEntrada')>NULL<cfelse>#im_PrecioTotalEntrada#</cfif>,
                            <cfif Not IsDefined('arguments.id_MonedaEntrada')>NULL<cfelse>#id_MonedaEntrada#</cfif>,
                            <cfif Not IsDefined('arguments.im_TipoCambioEntrada')>NULL<cfelse>#im_TipoCambioEntrada#</cfif>,
                            <cfif Not IsDefined('arguments.im_TotalMN')>NULL<cfelse>#im_TotalMN#</cfif>,
                            <cfif Not IsDefined('arguments.nu_ExistenciaAnterior')>NULL<cfelse>#nu_ExistenciaAnterior#</cfif>,
                            <cfif Not IsDefined('arguments.id_TipoCosteo')>NULL<cfelse>#id_TipoCosteo#</cfif>,
                            <cfif Not IsDefined('arguments.id_SucursalProveniente')>NULL<cfelse>#id_SucursalProveniente#</cfif>,
                            <cfif Not IsDefined('arguments.id_AlmacenProveniente')>NULL<cfelse>#id_AlmacenProveniente#</cfif>,
                            <cfif Not IsDefined('arguments.id_MovimientoProveniente')>NULL<cfelse>#id_MovimientoProveniente#</cfif>,
                            <cfif Not IsDefined('arguments.nd_MovimientoDetalleProveniente')>NULL<cfelse>#nd_MovimientoDetalleProveniente#</cfif>,
                            <cfif Not IsDefined('arguments.id_OrdenDeCompra')>NULL<cfelse>#id_OrdenDeCompra#</cfif>,
                            <cfif Not IsDefined('arguments.id_OrdenDeCompraDetalle')>NULL<cfelse>#id_OrdenDeCompraDetalle#</cfif>,
                            <cfif Not IsDefined('arguments.id_Requisicion')>NULL<cfelse>#id_Requisicion#</cfif>,
                            <cfif Not IsDefined('arguments.id_RequisicionDetalle')>NULL<cfelse>#id_RequisicionDetalle#</cfif>,
                            <cfif Not IsDefined('arguments.de_CausaDevolucion')>NULL<cfelse>'#de_CausaDevolucion#'</cfif>,
                            <cfif Not IsDefined('arguments.id_TipoDevolucion')>NULL<cfelse>#id_TipoDevolucion#</cfif>,
                            <cfif Not IsDefined('arguments.id_GrupoGasto') OR #id_GrupoGasto# EQ ''>NULL<cfelse>#id_GrupoGasto#</cfif>,
                            <cfif Not IsDefined('arguments.id_ConceptoGasto') OR #id_ConceptoGasto# EQ ''>NULL<cfelse>#id_ConceptoGasto#</cfif>,
                            <cfif Not IsDefined('arguments.id_Poliza')>NULL<cfelse>#id_Poliza#</cfif>,
                            <cfif Not IsDefined('arguments.id_TipoMovimiento')>NULL<cfelse>#id_TipoMovimiento#</cfif>,
                            <cfif Not IsDefined('arguments.nu_CantidadConvertir') OR #nu_CantidadConvertir# EQ 0>NULL<cfelse>#nu_CantidadConvertir#</cfif>
    </cfquery> --->

    <cfreturn Local.RS.nd_MovimientoDetalle>
</cffunction>

    <cffunction name="listarGeneral" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>
        <cfargument name="nd_MovimientoDetalle"     type="numeric" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDetalleGeneral
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#,
                                                    <cfif isDefined("arguments.nd_MovimientoDetalle")>#arguments.nd_MovimientoDetalle#<cfelse>null</cfif>
            </cfquery>
        <cfreturn Local.rs/>
   </cffunction>

    <cffunction name="editarpolizaCancelacion"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_sucursal"              type="numeric"  required="true"/>
        <cfargument name="id_Almacen"               type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"            type="numeric"  required="true"/>
        <cfargument name="id_TipoMovimiento"    type="numeric"  required="true"/>
        <cfargument name="id_PolizaCancel"          type="numeric"  required="true"/>
        <cfargument name="fh_PolizaCancel"          type="string"  required="true"/>

            <cfquery datasource="#variables.cnx#">
                exec upU_InventariosMovimientosDetallePolizaCancelacion 
                                                #arguments.id_Empresa#,
                                                #arguments.id_sucursal#, 
                                                #arguments.id_Almacen#, 
                                                #arguments.id_Movimiento#,
                                                #arguments.id_TipoMovimiento#,
                                                #arguments.id_PolizaCancel#,
                                                '#arguments.fh_PolizaCancel#'

            </cfquery>
    </cffunction>

    <cffunction name="upR_InventariosMovimientosDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosDetalle
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
   </cffunction>

   <cffunction name="cancelarMovimientoDisminuirExistencia" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventariosMovimientosDetalleCancelarMovimientoActualizarExistencia
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn>
   </cffunction>

   <cffunction name="cancelarMovimientoEntradaDisminuirExistencia" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventariosMovimientosDetalleCancelarMovimientoEntradaActualizarExistencia
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn>
   </cffunction>

   

   <cffunction name="cancelarMovimientoInsertarSeriesInsumos" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upC_InventariosMovimientosDetalleInsertarSeriesInsumos
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn>
   </cffunction>   

   <cffunction name="cancelarMovimientoEliminarSeriesInsumos" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upC_InventariosMovimientosDetalleEliminarSeriesInsumos
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
            </cfquery>
        <cfreturn>
   </cffunction>

   <cffunction name="VerificarExistenciaPorSerie" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="true"/>
        <cfargument name="de_serieInsumo"           type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosDetalleVerificarExistenciaPorSerie
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_insumo#,
                                                    '#arguments.de_serieInsumo#'
            </cfquery>
        <cfreturn local.rs>
   </cffunction> 


  <cffunction name="validarCantidadRecibida" access="public" returntype="void">
        <cfargument name="id_Empresa"                       type="string" required="false" default=""/>
        <cfargument name="id_ordenDeCompra"                 type="string" required="false" default=""/>
        <cfargument name="id_ordenDeCompraDetalle"          type="string" required="false" default=""/>
        <cfargument name="id_Insumo"                        type="string" required="false" default=""/>
        <cfargument name="nu_cantidad"                      type="string" required="false" default=""/>
        

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosDetalleEntradaCompraValidarCantidadRecibida
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_ordenDeCompra#,
                                                    #arguments.id_ordenDeCompraDetalle#,
                                                    #arguments.id_Insumo#,
                                                    #arguments.nu_cantidad#
            </cfquery>
        <cfreturn>
   </cffunction>

</cfcomponent>

