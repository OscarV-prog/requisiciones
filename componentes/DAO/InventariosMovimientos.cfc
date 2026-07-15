<cfcomponent extends="wiz/InventariosMovimientos">
    <cffunction name="MovimientosDevolucionParaNotaCredito" access="public" returntype="any">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Sucursal"  type="numeric" required="true"/>
        <cfargument name="id_Almacen"   type="numeric" required="true"/>
        <cfargument name="id_Proveedor" type="numeric" required="true"/>
        <cfargument name="fh_Inicio"    type="string" required="true"/>
        <cfargument name="fh_Fin"       type="string" required="true"/>

    <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                EXECUTE upL_InventariosMovimientos_DevolucionNotaCredito
                            @id_Empresa     = #Arguments.id_Empresa#,
                            @id_Sucursal    = #Arguments.id_Sucursal#,
                            @id_Almacen     = #Arguments.id_Almacen#,
                            @id_Proveedor   = #Arguments.id_Proveedor#,
                            @fh_Inicio      = '#Arguments.fh_Inicio#',
                            @fh_Fin         = '#Arguments.fh_Fin#'
    </cfquery>--->

    <cfstoredproc procedure="upL_InventariosMovimientos_DevolucionNotaCredito" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#!isNumeric(arguments.id_Almacen)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#!isNumeric(arguments.id_Proveedor)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Inicio" value="#arguments.fh_Inicio#" null="#!Len(arguments.fh_Inicio)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Fin" value="#arguments.fh_Fin#" null="#!Len(arguments.fh_Fin)#">
      <cfprocresult name="QUERYNAME1" resultset="1">
     </cfstoredproc>


        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Sucursal"  type="numeric" required="true"/>
        <cfargument name="id_Almacen"   type="numeric" required="true"/>
        <cfargument name="fh_Inicio"    type="string"  required="false"/>
        <cfargument name="fh_Fin"       type="string"  required="false"/>
        <cfargument name="folio"        type="string"  required="false"/>
        <cfargument name="requisicion"  type="string"  required="false"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientos
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        <cfif isDefined("Arguments.fh_Inicio") AND ARGUMENTS.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Fin") AND ARGUMENTS.fh_Fin NEQ ''>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.folio") AND ARGUMENTS.folio NEQ ''>'#Arguments.folio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.requisicion") AND ARGUMENTS.requisicion NEQ ''>'#Arguments.requisicion#'<cfelse>NULL</cfif>

            </cfquery>--->


        <cfstoredproc procedure="upL_InventariosMovimientos" datasource="#variables.cnx#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#!isNumeric(arguments.id_Almacen)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Inicio" value="#arguments.fh_Inicio#" null="#!Len(arguments.fh_Inicio)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Fin" value="#arguments.fh_Fin#" null="#!Len(arguments.fh_Fin)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@folio" value="#arguments.folio#" null="#!Len(arguments.folio)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@requisicion" value="#arguments.requisicion#" null="#!isNumeric(arguments.requisicion)#">
          <cfprocresult name=" Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>

    </cffunction>

    <!--- funcion que va por los movimientos de salida y entrada por devolucion a proveedor 24/09/2015 --->
    <cffunction name="getmovements" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
      <cfargument name="id_sucursal"            type="numeric" required="true"/>
      <cfargument name="id_almacen"             type="numeric" required="true"/>
      <cfargument name="fh_inicioMovimiento"        type="string" required="false"/>
      <cfargument name="fh_finMovimiento"           type="string" required="false"/>
      <cfargument name="id_proveedor"               type="string" required="false"/>
      <cfargument name="id_movimiento"              type="numeric" required="true"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosSalidaEntradaDevolucion
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        <cfif isDefined("Arguments.fh_inicioMovimiento") AND ARGUMENTS.fh_inicioMovimiento NEQ ''>'#Arguments.fh_inicioMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_finMovimiento") AND ARGUMENTS.fh_finMovimiento NEQ ''>'#Arguments.fh_finMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_proveedor") AND ARGUMENTS.id_proveedor NEQ ''>#Arguments.id_proveedor#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_movimiento") AND ARGUMENTS.id_movimiento NEQ ''>#Arguments.id_movimiento#<cfelse>NULL</cfif>
      </cfquery>--->

      <cfstoredproc procedure="upL_InventariosMovimientosSalidaEntradaDevolucion" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#!isNumeric(arguments.id_empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#!isNumeric(arguments.id_Almacen)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicioMovimiento#" null="#!Len(arguments.fh_inicioMovimiento)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_finMovimiento#" null="#!Len(arguments.fh_finMovimiento)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#arguments.id_proveedor#" null="#!isNumeric(arguments.id_proveedor)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#!isNumeric(arguments.id_movimiento)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>

      <cfreturn Local.rs/>
  </cffunction>

<!--- Victor Sanchez
    05/11/2015 --->
  <cffunction name="upL_ConsultaDevolucionSalida" access="public" returntype="query">
    <cfargument name="folio"    type="string" required="false"/>
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="nombre"    type="string" required="false"/>
    <cfargument name="fh_fin"    type="string" required="false"/>
        <cfargument name="id_Empresa"    type="string" required="false"/>


            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_ConsultaDevolucionSalida #session.ID_EMPRESA#,
                <cfif isDefined("folio") AND #folio# NEQ ''>'#folio#'<cfelse>NULL</cfif>,
                <cfif isDefined("nombre") AND #nombre# NEQ ''>'#nombre#'<cfelse>NULL</cfif>,
                '#fh_inicio#',
                '#fh_fin#'
      </cfquery>--->

      <cfstoredproc procedure="upL_ConsultaDevolucionSalida" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@folio" value="#arguments.folio#" null="#!isNumeric(arguments.folio)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nombre" value="#arguments.nombre#" null="#!isNumeric(arguments.nombre)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicio#" null="#!len(arguments.fh_inicio)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_fin#" null="#!len(arguments.fh_fin)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>


        <cfreturn Local.rs/>
  </cffunction>

<!--- Victor Sanchez
    28/12/2015
    Entrada Por surtido devolucion
--->
   <cffunction name="upR_EntradaPorDevolucion" access="public" returntype="query">
            <cfargument name="id_proveedor"    type="string" required="false"/>
            <cfargument name="fh_inicio"    type="string" required="false"/>
            <cfargument name="fh_fin"    type="string" required="false"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_EntradaPorDevolucion
                #session.ID_EMPRESA#,
                <cfif isDefined("id_proveedor") AND #id_proveedor# NEQ ''>#id_proveedor#<cfelse>NULL</cfif>,
                '#fh_inicio#',
                '#fh_fin#'
      </cfquery>--->

      <cfstoredproc procedure="upR_EntradaPorDevolucion" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#!isNumeric(arguments.id_Proveedor)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicio#" null="#!len(arguments.fh_inicio)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_fin#" null="#!len(arguments.fh_fin)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>


        <cfreturn Local.rs/>
    </cffunction>

<!--- Victor Sanchez
    28/12/2015
    Entrada Por surtido faltante
--->
   <cffunction name="upR_EntradaPorFaltante" access="public" returntype="query">
            <cfargument name="id_proveedor"    type="string" required="false"/>
            <cfargument name="fh_inicio"    type="string" required="false"/>
            <cfargument name="fh_fin"    type="string" required="false"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_EntradaPorFaltante
                #session.ID_EMPRESA#,
                <cfif isDefined("id_proveedor") AND #id_proveedor# NEQ ''>#id_proveedor#<cfelse>NULL</cfif>,
                '#fh_inicio#',
                '#fh_fin#'
      </cfquery>--->

      <cfstoredproc procedure="upR_EntradaPorFaltante" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#!isNumeric(arguments.id_Proveedor)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicio#" null="#!isNumeric(arguments.fh_inicio)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_fin#" null="#!isNumeric(arguments.fh_fin)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


<!--- Victor Sanchez
    28/12/2015
    Trae el detalle de EntradaPorSurtidoDevolucion/Faltante
--->
   <cffunction name="upL_EntradaPorSurtidoDevolucionFaltante" access="public" returntype="query">
      <cfargument name="folio"    type="string" required="false"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_EntradaPorSurtidoDevolucionFaltante '#folio#'
      </cfquery>--->

      <cfstoredproc procedure="upL_EntradaPorSurtidoDevolucionFaltante" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_Folio" value="#arguments.nu_Folio#" null="#!isNumeric(arguments.nu_Folio)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>


        <cfreturn Local.rs/>
    </cffunction>

    <!--- Victor Sanchez
    29/12/2015
    Actualiza el inventarioMovimientoDetalle para cuando hay entradas por devolucion
    --->
   <cffunction name="upU_EntradaPorDevolucion" access="public" returntype="void">
        <cfargument name="id_empresa"    type="string" required="true"/>
        <cfargument name="id_sucursal"    type="string" required="true"/>
        <cfargument name="id_almacen"    type="string" required="true"/>
        <cfargument name="id_movimiento"    type="string" required="true"/>
        <cfargument name="nd_movimientodetalle"    type="string" required="true"/>
        <cfargument name="nu_cantidadrecibida"    type="string" required="true"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_EntradaPorDevolucion
                        #id_empresa#,
                        #id_sucursal#,
                        #id_almacen#,
                        #id_movimiento#,
                        #nd_movimientodetalle#,
                        #nu_cantidadrecibida#
      </cfquery>--->

      <cfstoredproc procedure="upU_EntradaPorDevolucion" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#!isNumeric(arguments.id_empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#!isNumeric(arguments.id_sucursal)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#!isNumeric(arguments.id_almacen)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#!isNumeric(arguments.id_movimiento)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_movimientodetalle" value="#arguments.nd_movimientodetalle#" null="#!isNumeric(arguments.nd_movimientodetalle)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nu_cantidadRecibida" value="#arguments.nu_cantidadRecibida#" null="#!isNumeric(arguments.nu_cantidadRecibida)#">
       </cfstoredproc>

    </cffunction>

    <!--- Victor Sanchez
    29/12/2015
    Actualiza el inventarioMovimientoDetalle para cuando hay entradas por faltante
    --->
   <cffunction name="upU_EntradaPorFaltante" access="public" returntype="void">
        <cfargument name="id_empresa"    type="string" required="true"/>
        <cfargument name="id_sucursal"    type="string" required="true"/>
        <cfargument name="id_almacen"    type="string" required="true"/>
        <cfargument name="id_movimiento"    type="string" required="true"/>
        <cfargument name="nd_movimientodetalle"    type="string" required="true"/>
        <cfargument name="nu_cantidadrecibida"    type="string" required="true"/>

      <cfstoredproc procedure="upU_EntradaPorFaltante" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#!isNumeric(arguments.id_empresa)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#!isNumeric(arguments.id_sucursal)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#!isNumeric(arguments.id_almacen)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#!isNumeric(arguments.id_movimiento)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_movimientodetalle" value="#arguments.nd_movimientodetalle#" null="#!isNumeric(arguments.nd_movimientodetalle)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nu_cantidadRecibida" value="#arguments.nu_cantidadRecibida#" null="#!isNumeric(arguments.nu_cantidadRecibida)#">
       </cfstoredproc>

    </cffunction>


<!--- Victor Sanchez
    05/11/2015
    Trae el detalle de una entrada por devolucion de salida
--->
  <cffunction name="upR_EntradaDevolucionSalidaDetalle" access="public" returntype="query">
    <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_EntradaDevolucionSalidaDetalle
                    #id_empresa#,
                    #id_sucursal#,
                    #id_almacen#,
                    #id_movimiento#
            </cfquery>
        <cfreturn Local.rs/>
  </cffunction>

    <!--- Victor Sanchez
        trae query de inventarios movimientos detalle para generar el reporte de existencias y movimientos
              --->
  <cffunction name="upR_InventariosMovimimientos" access="public" returntype="query">
    <cfargument name="id_Empresa"    type="string" required="false"/>
    <cfargument name="id_Sucursal"    type="string" required="false"/>
    <cfargument name="id_Almacen"    type="string" required="false"/>
    <cfargument name="id_Insumo"    type="string" required="false"/>
    <cfargument name="fh_Inicio"    type="string" required="false"/>
    <cfargument name="fh_Fin"    type="string" required="false"/>
    <cfargument name="id_FamiliaInsumo"    type="string" required="false" default="False"/>
    <cfargument name="id_SubFamiliaInsumo"    type="string" required="false" default="False"/>
    <cfargument name="id_AlmacenFisico"    type="string" required="false"/>

            <!--- upR_InventariosMovimimientos  --->
            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimimientos2
                            #id_Empresa#,
                            #id_Sucursal#,
                            #id_Almacen#,
                            #id_Insumo#,
                            '#fh_Inicio#',
                            '#fh_Fin#',
                            #id_FamiliaInsumo#,
                            #id_SubFamiliaInsumo#,
                            #id_AlmacenFisico#''
            </cfquery>
        <cfreturn Local.rs/>
  </cffunction>

    <!--- funcion que devuelve los movimentos de servicio 22/10/2015 --->
  <cffunction name="getmovementsofentrada" access="public" returntype="query">
    <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_OrdenCompra"           type="string" required="false"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>
        <cfargument name="SubioFactura"             type="numeric" required="false"/>
        <cfargument name="nu_Siniestro"             type="string" required="false"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosentradasservicios
                        <cfif isDefined("Arguments.id_Empresa") AND ARGUMENTS.id_Empresa NEQ ''>'#Arguments.id_Empresa#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_Sucursal") AND ARGUMENTS.id_Sucursal NEQ ''>'#Arguments.id_Sucursal#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_inicioMovimiento") AND ARGUMENTS.fh_inicioMovimiento NEQ ''>'#Arguments.fh_inicioMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_finMovimiento") AND ARGUMENTS.fh_finMovimiento NEQ ''>'#Arguments.fh_finMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_proveedor") AND ARGUMENTS.id_proveedor NEQ ''>#Arguments.id_proveedor#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_movimiento") AND ARGUMENTS.id_movimiento NEQ ''>#Arguments.id_movimiento#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_OrdenCompra") AND ARGUMENTS.id_OrdenCompra NEQ ''>#Arguments.id_OrdenCompra#<cfelse>NULL</cfif>,
                        #arguments.page#,
                        #arguments.pageSize#,
                        #arguments.SubioFactura#,
                        <cfif isDefined("Arguments.nu_Siniestro") AND ARGUMENTS.nu_Siniestro NEQ ''>'#Arguments.nu_Siniestro#'<cfelse>NULL</cfif>

            </cfquery>
        <cfreturn Local.rs/>
  </cffunction>

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
  <cffunction name="getmovementsdetailofservice" access="public" returntype="query">
    <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosentradasserviciosdetail
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_movimiento#

            </cfquery>
        <cfreturn Local.rs/>
  </cffunction>
        <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <cffunction name="impresionDeMovimientosServicio" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosentradasserviciosimpresion
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Movimiento#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name='upU_AlmacenesExistencias_Agregar' access='public' returntype='void'>
        <cfargument name='id_Empresa' type='numeric' required='yes'>
        <cfargument name='id_Sucursal' type='numeric' required='yes'>
        <cfargument name='id_Almacen' type='numeric' required='yes'>
        <cfargument name='id_Insumo' type='numeric' required='yes'>
        <cfargument name='nu_Existencia' type='numeric' required='yes'>
        <cfargument name='nu_CantidadReOrden' type='numeric' required='no'>
        <cfargument name='nu_StockMinimo' type='numeric' required='no'>
        <cfargument name='nu_ExistenciaCalculoPromedio' type='numeric' required='no'>
        <cfargument name='im_SumaPreciosParaPromedio' type='numeric' required='no'>
        <cfargument name='im_PrecioPromedio' type='numeric' required='no'>
        <cfargument name='im_PrecioUltimo' type='numeric' required='no'>
        <cfargument name='sn_Activo' type='boolean' required='no'>
        <cfquery name="Local.rs" datasource="#variables.cnx#">
            EXECUTE upU_AlmacenesExistencias_Agregar #id_Empresa#, #id_Sucursal#, #id_Almacen#, #id_Insumo#, #nu_Existencia#, <cfif Not IsDefined('arguments.nu_CantidadReOrden')>NULL<cfelse>#nu_CantidadReOrden#</cfif>, <cfif Not IsDefined('arguments.nu_StockMinimo')>NULL<cfelse>#nu_StockMinimo#</cfif>, <cfif Not IsDefined('arguments.nu_ExistenciaCalculoPromedio')>NULL<cfelse>#nu_ExistenciaCalculoPromedio#</cfif>, <cfif Not IsDefined('arguments.im_SumaPreciosParaPromedio')>NULL<cfelse>#im_SumaPreciosParaPromedio#</cfif>, <cfif Not IsDefined('arguments.im_PrecioPromedio')>NULL<cfelse>#im_PrecioPromedio#</cfif>, <cfif Not IsDefined('arguments.im_PrecioUltimo')>NULL<cfelse>#im_PrecioUltimo#</cfif>, <cfif Not IsDefined('arguments.sn_Activo')>NULL<cfelse>#sn_Activo#</cfif>
        </cfquery>
        <cfreturn>
    </cffunction>



<!--- Victor Sanchez
      21/10/2015
      Actualiza Activos Fijos --->
<cffunction name='upU_ActivosFijos' access='public' returntype='void'>
    <cfargument name='id_EmpresaAnt' type='string' required='yes'>
    <cfargument name='id_SucursalAnt' type='string' required='yes'>
    <cfargument name='id_AlmacenAnt' type='string' required='yes'>
    <cfargument name='Serie' type='string' required='yes'>
    <cfargument name='id_Sucursal' type='string' required='yes'>
    <cfargument name='id_Almacen' type='string' required='no'>
    <cfargument name='id_MovimientoEntrada' type='string' required='no'>
    <cfargument name='nd_MovimientoDetalleEntrada' type='string' required='no'>
    <cfargument name='id_CentroCosto' type='string' required='no'>



    <cfquery name="Local.rs" datasource="#variables.cnx#">
        EXECUTE upU_ActivosFijos
        #id_EmpresaAnt#,
        #id_SucursalAnt#,
        #id_AlmacenAnt#,
        "#Serie#",
        #id_Sucursal#,
        #id_Almacen#,
        #id_MovimientoEntrada#,
        #nd_MovimientoDetalleEntrada#,
        <cfif isDefined("id_CentroCosto") and #id_CentroCosto# NEQ ''>#id_CentroCosto#<cfelse>NULL</cfif>
    </cfquery>
    <cfreturn>
</cffunction>


    <!--- funcion que va por el detalle de insumos y la informacion de  un movimiento en especifico 24/09/2015 --->
    <cffunction name="getmovementsdetail" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosSalidaEntradaDevolucionDetail
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_movimiento#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <!--- Victor Sanchez
         22/10/2015
         funcion que devuelve las requisiciones que tengan movimientos de salida por consumo --->
    <cffunction name="upR_RequisicionesSalidaConsumo" access="public" returntype="query">
        <cfargument name="id_Requisicion"               type="string" required="false"/>
        <cfargument name="id_sucursal"              type="string" required="false"/>
        <cfargument name="nb_Empleado"                  type="string" required="false"/>
        <cfargument name="fh_inicial"                   type="string" required="false"/>
        <cfargument name="fh_final"                 type="string" required="false"/>

            <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_RequisicionesSalidaConsumo
                        <cfif isDefined("id_Requisicion") AND #id_Requisicion# NEQ ''>#id_Requisicion#<cfelse>NULL</cfif>,
                        <cfif isDefined("id_sucursal") AND #id_Sucursal# NEQ ''>#id_Sucursal#<cfelse>NULL</cfif>,
                        <cfif isDefined("nb_Empleado") AND #nb_Empleado# NEQ ''>"#nb_Empleado#"<cfelse>NULL</cfif>,
                        <cfif isDefined("fh_inicial") AND #fh_inicial# NEQ ''>"#fh_inicial#"<cfelse>NULL</cfif>,
                        <cfif isDefined("fh_final") AND #fh_final# NEQ ''>"#fh_final#"<cfelse>NULL</cfif>
      </cfquery>--->

      <cfstoredproc procedure="upR_RequisicionesSalidaConsumo" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#!isNumeric(arguments.id_Requisicion)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Empleado" value="#arguments.nb_Empleado#" null="#!isNumeric(arguments.nb_Empleado)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicial" value="#arguments.fh_inicial#" null="#!isNumeric(arguments.fh_inicial)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_final" value="#arguments.fh_final#" null="#!isNumeric(arguments.fh_final)#">
        <cfprocresult name="Local.rs" resultset="1">
       </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <!--- Victor Sanchez
         22/10/2015
        Obtener Detalle de inventarios Movimientos --->
    <cffunction name="Obtener_InventariosMovimientosDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"                   type="string" required="false"/>
        <cfargument name="id_Sucursal"                  type="string" required="false"/>
        <cfargument name="id_Almacen"                   type="string" required="false"/>
        <cfargument name="id_Movimiento"                type="string" required="false"/>
        <cfargument name="nd_MovimientoDetalle"         type="string" required="false"/>

        <cfstoredproc procedure="upL_InventariosMovimientosDetalle" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_Sucursal#"             null="#iif(isNumeric(arguments.id_Sucursal), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"               value="#arguments.id_Almacen#"              null="#iif(isNumeric(arguments.id_Almacen), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"            value="#arguments.id_Movimiento#"           null="#iif(isNumeric(arguments.id_Movimiento), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_MovimientoDetalle"     value="#arguments.nd_MovimientoDetalle#"    null="#iif(isNumeric(arguments.nd_MovimientoDetalle), false, true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!---
        JCAL
        funcion que devulve la cantida salida por ajuste de un insumo 08/10/2015
   --->
    <cffunction name="getcantidadsalidaporajuste" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientoscantidadsalidaxajuste
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#,
                        #arguments.id_insumo#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


<!--- Victor Sanchez
        28/09/2015
        Query que regresa cuantos insumos se le dieron salida --->
    <cffunction name="upR_nuInsumosSalidaById_InventarioTraspaso" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_inventarioTraspaso"            type="numeric" required="true"/>
        <cfargument name="id_insumo"            type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_nuInsumosSalidaById_InventarioTraspaso
                        #arguments.id_empresa#,
                        #arguments.id_inventarioTraspaso#,
                        <cfif isDefined("arguments.id_insumo") AND #arguments.id_insumo# NEQ ''>#arguments.id_insumo#<cfelse>NULL</cfif>

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>



<!--- Victor Sanchez
        28/09/2015
        Query que regresa cuantos insumos se solicitaron en un traspaso --->
    <cffunction name="upR_InsumosSolicitadosById_InventarioTraspaso" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_inventarioTraspaso"            type="numeric" required="true"/>
        <cfargument name="id_insumo"            type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InsumosSolicitadosById_InventarioTraspaso
                        #arguments.id_empresa#,
                        #arguments.id_inventarioTraspaso#,
                        <cfif isDefined("arguments.id_insumo") AND #arguments.id_insumo# NEQ ''>#arguments.id_insumo#<cfelse>NULL</cfif>

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>



    <!--- funcion que va por los movimientos de que se van ajustar correspondientes a un insumo --->
    <cffunction name="movimientosajustes" access="public" returntype="query">
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="false"/>
        <!--- <cfargument name="id_insumo"              type="string" required="false"/> --->
        <!--- <cfargument name="id_movimiento"          type="numeric" required="true"/>     --->
        <cfargument name="id_empresa"               type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosgetajustes
                        #arguments.id_Empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#,
                        #arguments.id_insumo#

            </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que va por los movimientos correspondientes a un insumo e inventario fisico 01/10/2015--->
    <cffunction name="getmovimientosinventariofisico" access="public" returntype="query">
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="true"/>
        <!--- <cfargument name="id_insumo"              type="string" required="false"/> --->
        <!--- <cfargument name="id_movimiento"          type="numeric" required="true"/>     --->
        <cfargument name="id_empresa"               type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosgetmovimientos
                        #arguments.id_Empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#,
                        #arguments.id_insumo#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


        <!--- funcion que va por los insumos correspondientes a un movimientos  01/10/2015--->
    <cffunction name="getinsumosmovimientos" access="public" returntype="query">
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>
        <cfargument name="id_empresa"               type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosgetajustes
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#,
                        #arguments.id_movimiento#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que edita todos los ajustes de inventarios movimientos correspondientes a un inventario fisico --->
    <cffunction name="updateallsalidasajuste" access="public" returntype="void">
        <cfargument name="id_empresa"               type="string" required="false"/>
        <cfargument name="id_sucursal"              type="string" required="false"/>
        <cfargument name="id_almacen"               type="string" required="false"/>
        <cfargument name="id_inventariofisico"      type="string" required="false"/>
        <cfargument name="estatusautorizar"         type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventariosMovimientosallsalidasajuste
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#,
                        #arguments.estatusautorizar#
            </cfquery>
    </cffunction>

    <!--- funcion que setea el estatus de autorizacion del inventario movimiento --->
    <cffunction name="AutorizarAjuste"    access="public" returntype="void">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="de_comentarios"                   type="string"  required="true"/>
        <cfargument name="de_comentarioscobro"              type="string"  required="true"/>
        <cfargument name="id_tiposugerenciacargo"           type="string"  required="false"/>
        <cfargument name="id_movimiento"                    type="numeric"  required="true"/>
        <cfargument name="estatusautorizar"                 type="numeric"  required="true"/>

            <cfquery datasource="#variables.cnx#">
                exec upU_InventariosMovimientosestatus
                                                #arguments.id_Empresa#,
                                                #arguments.id_Sucursal#,
                                                #arguments.id_Almacen#,
                                                <cfif isDefined("arguments.de_comentarios") AND arguments.de_comentarios NEQ '' AND arguments.de_comentarios NEQ 'null'>
                                                '#arguments.de_comentarios#'
                                                <cfelse>
                                                NULL
                                                </cfif>,
                                                <cfif isDefined("arguments.de_comentarioscobro") AND arguments.de_comentarioscobro NEQ '' AND arguments.de_comentarioscobro NEQ 'null'>
                                                '#arguments.de_comentarioscobro#'
                                                <cfelse>
                                                NULL
                                                </cfif>,
                                                <cfif isDefined("arguments.id_tiposugerenciacargo") AND arguments.id_tiposugerenciacargo NEQ ''>
                                                '#arguments.id_tiposugerenciacargo#'
                                                <cfelse>
                                                NULL
                                                </cfif>,
                                                #arguments.id_movimiento#,
                                                #arguments.estatusautorizar#
            </cfquery>
    </cffunction>

    <!--- funcion que seta el id_tiposugerenciacargo de inventarios movimientos --->
    <cffunction name="setcargo" access="remote"     returnformat="JSON">
        <cfargument name="id_empresa"               type="numeric"      required="true"/>
        <cfargument name="id_sucursal"              type="numeric"      required="true"/>
        <cfargument name="id_almacen"               type="numeric"      required="true"/>
        <cfargument name="id_movimiento"            type="numeric"      required="true"/>
        <cfargument name="id_tiposugerenciacargo"   type="string"      required="false"/>
        <cfargument name="de_comentarioscobro"      type="string"       required="false"/>
        <cfargument name="de_comentarios"           type="string"       required="false"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventariosMovimientosidtiposugerenciacargo
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_movimiento#,
                        <cfif isDefined("Arguments.id_tiposugerenciacargo") && ARGUMENTS.id_tiposugerenciacargo NEQ '' >'#Arguments.id_tiposugerenciacargo#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.de_comentarioscobro") && ARGUMENTS.de_comentarioscobro NEQ '' AND arguments.de_comentarioscobro NEQ 'null'>'#Arguments.de_comentarioscobro#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.de_comentarios") && ARGUMENTS.de_comentarios NEQ '' AND arguments.de_comentarios NEQ 'null'>'#Arguments.de_comentarios#'<cfelse>NULL</cfif>
            </cfquery>
    </cffunction>

    <!--- julio cesar acosta lopez
        20/08/2015
        funcion que duvuelve los inventarios movimientos a los que se les puede generar polizas  --->
    <cffunction name="getexistemovimientos" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string" required="true"/>
        <cfargument name="id_sucursal"          type="string" required="true"/>
        <cfargument name="id_TipoMovimiento"    type="string" required="true"/>
        <cfargument name="fh_inicio"            type="string" required="true"/>
        <cfargument name="fh_fin"               type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosexiste
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_TipoMovimiento#,
                        '#arguments.fh_inicio#',
                        '#arguments.fh_fin#'

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- julio cesar acosta lopez
        22/09/2015
        funcion que duvuelve los inventarios movimientos con ajustes  --->
    <cffunction name="getMovesWithAjustes" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosconajustes
                        #arguments.id_Empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_almacen#,
                        #arguments.id_inventariofisico#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- julio cesar acosta lopez
        29/07/2015
        funcion que trae el detalle de la poliza --->
    <cffunction name="getdetallepoliza" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="fh_inicio"            type="string" required="true"/>
        <cfargument name="fh_fin"               type="string" required="true"/>
        <cfargument name="id_tipomovimiento"    type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosdetallepoliza
                        #arguments.id_empresa#,
                        '#arguments.fh_inicio#',
                        '#arguments.fh_fin#',
                        #arguments.id_tipomovimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- julio cesar acosta lopez
        30/07/2015
        funcion que trae el detalle de la poliza del total de cargo de cada movimiento --->
    <cffunction name="getdetallepolizacargos" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="fh_inicio"            type="string" required="true"/>
        <cfargument name="fh_fin"               type="string" required="true"/>
        <cfargument name="id_tipomovimiento"    type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_PolizaMovimientosCargos
                        #arguments.id_empresa#,
                        '#arguments.fh_inicio#',
                        '#arguments.fh_fin#',
                        #arguments.id_tipomovimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

        <!---  Victor Sanchez
                26/10/2015
                actualiza el nu_cantidad de un movimiento detalle --->
        <cffunction name="upU_InventarioMovimientoDetalleNuCantidad" access="public" returntype="any">
        <cfargument name="id_empresa"               type="string" required="true"/>
        <cfargument name="id_sucursal"              type="string" required="true"/>
        <cfargument name="id_almacen"               type="string" required="true"/>
        <cfargument name="id_Movimiento"            type="string" required="true"/>
        <cfargument name="nd_MovimientoDetalle"     type="string" required="true"/>
        <cfargument name="nu_Cantidad"              type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventarioMovimientoDetalleNuCantidad
                        #id_Empresa#,
                        #id_sucursal#,
                        #id_almacen#,
                        #id_Movimiento#,
                        #nd_MovimientoDetalle#,
                        #nu_Cantidad#
            </cfquery>
    </cffunction>

<!---
    upU_InventarioMovimientoDetalleNuCantidad
@id_Empresa int,
@id_Sucursal int,
@id_Almacen int,
@id_Movimiento int,
@nd_MovimientoDetalle int,
@nu_Cantidad int --->

    <!--- julio cesar acosta lopez
        30/07/2015
        funcion que trae el detalle de la poliza de todos los abonos de cada movimintento --->
    <cffunction name="getdetallepolizaabonos" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="fh_inicio"            type="string" required="true"/>
        <cfargument name="fh_fin"               type="string" required="true"/>
        <cfargument name="id_tipomovimiento"    type="string" required="true"/>
            <!--- <cfdump var="#arguments#" /><cfabort /> --->
            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_PolizaMovimientosAbonos
                        #arguments.id_empresa#,
                        '#arguments.fh_inicio#',
                        '#arguments.fh_fin#',
                        #arguments.id_tipomovimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getInventariosMovimientosByAlmacenBloqueo" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="fh_Inicio"    type="string" required="true"/>
        <cfargument name="fh_Fin"       type="string" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosByFechasBloqueoInventario
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        '#arguments.fh_Inicio#',
                        '#arguments.fh_Fin#'

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="listarSalidasporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosSalidasporAjuste
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        <cfif isDefined("Arguments.fh_Inicio") AND ARGUMENTS.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Fin") AND ARGUMENTS.fh_Fin NEQ ''>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fl_Movimiento") AND ARGUMENTS.fl_Movimiento NEQ ''>'#Arguments.fl_Movimiento#'<cfelse>NULL</cfif>

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- JULIO CESAR ACOSTA LOPEZ 19/03/2015 --->
    <cffunction name="listarEntradasporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosEntradasporAjuste
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        <cfif isDefined("Arguments.fh_Inicio") AND ARGUMENTS.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Fin") AND ARGUMENTS.fh_Fin NEQ ''>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fl_Movimiento") AND ARGUMENTS.fl_Movimiento NEQ ''>'#Arguments.fl_Movimiento#'<cfelse>NULL</cfif>

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarDatosparaDetalleConsultasSalidasporConsumo" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>

            <cfquery name="Local.DatosInventariosMovimientos" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDatosparaDetalleConsultasSalidasporConsumo
                                #arguments.id_Empresa#,
                                #arguments.id_Sucursal#,
                                #arguments.id_Almacen#,
                                #arguments.id_Movimiento#

            </cfquery>
        <cfreturn Local.DatosInventariosMovimientos/>
    </cffunction>

    <!--- JULIO CESAR ACOSTA LOPEZ 19/03/2015 --->
    <cffunction name="listarDatosparaDetalleConsultasEntradasporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>

            <cfquery name="Local.DatosInventariosMovimientos" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDatosparaDetalleConsultasEntradasporConsumo
                                #arguments.id_Empresa#,
                                #arguments.id_Sucursal#,
                                #arguments.id_Almacen#,
                                #arguments.id_Movimiento#

            </cfquery>
        <cfreturn Local.DatosInventariosMovimientos/>
    </cffunction>

    <cffunction name="listarDatosparaDetalleConsultasSalidasporAjuste" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"    type="numeric" required="true"/>

            <cfquery name="Local.DatosInventariosMovimientos" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosDatosparaDetalleConsultasSalidasporAjuste
                                #arguments.id_Empresa#,
                                #arguments.id_Sucursal#,
                                #arguments.id_Almacen#,
                                #arguments.id_Movimiento#

            </cfquery>
        <cfreturn Local.DatosInventariosMovimientos/>
    </cffunction>

    <cffunction name="NextIdInventarioMovimiento" access="public" returntype="string">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Sucursal"               type="numeric" required="true"/>
        <cfargument name="id_Almacen"                type="numeric" required="true"/>

            <cfquery name="Local.Movimiento" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientosNextID
                                                      #arguments.id_Empresa#,
                                                      #arguments.id_Sucursal#,
                                                      #arguments.id_Almacen#
            </cfquery>
            <cfreturn Local.Movimiento.nextID />
    </cffunction>

    <!--- <cffunction name="Agregar"    access="public" returntype="void">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"                    type="numeric"  required="true"/>
        <cfargument name="id_TipoMovimiento"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioEntrego"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioRecibio"                type="numeric"  required="true"/>
        <cfargument name="id_Requisicion"                   type="numeric"  required="true"/>
        <cfargument name="id_UsuarioRegistroMovimiento"     type="numeric"  required="true"/>
        <cfargument name="fl_Movimiento"                    type="string"   required="true"/>
        <cfargument name="fh_Registro"                      type="string"   required="true"/>


            <cfquery datasource="#variables.cnx#">
                exec upC_InventariosMovimientos
                                                #arguments.id_Empresa#,
                                                #arguments.id_Sucursal#,
                                                #arguments.id_Almacen#,
                                                #arguments.id_Movimiento#,
                                                #arguments.id_TipoMovimiento#,
                                                #arguments.id_UsuarioEntrego#,
                                                #arguments.id_UsuarioRecibio#,
                                                #arguments.id_Requisicion#,
                                                #arguments.id_UsuarioRegistroMovimiento#,
                                                '#arguments.fl_Movimiento#',
                                                '#arguments.fh_Registro#'
            </cfquery>
    </cffunction> --->

    <cffunction name="Agregar"    access="public" returntype="query">
        <cfargument name="id_Empresa"                   type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                  type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                   type="numeric"  required="true"/>
        <cfargument name="id_TipoMovimiento"            type="numeric"  required="true"/>
        <cfargument name="id_UsuarioEntrego"            type="numeric"  required="false"/>
        <cfargument name="id_UsuarioRecibio"            type="numeric"  required="false"/>
        <cfargument name="id_Requisicion"               type="numeric"  required="false"/>
        <cfargument name="id_UsuarioRegistroMovimiento" type="numeric"  required="false"/>
        <cfargument name="im_Total"                     type="string"   required="true"/>
        <cfargument name="id_ProveedorConsignacion"     type="string"   required="false"/>

        <cfstoredproc procedure="upC_InventariosMovimientos">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                   value="#arguments.id_Empresa#"                   null="#!isNumeric(arguments.id_Empresa)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                  value="#arguments.id_Sucursal#"                  null="#!isNumeric(arguments.id_Sucursal)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"                   value="#arguments.id_Almacen#"                   null="#!isNumeric(arguments.id_Almacen)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_TipoMovimiento"            value="#arguments.id_TipoMovimiento#"            null="#!isNumeric(arguments.id_TipoMovimiento)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioEntrego"            value="#arguments.id_UsuarioEntrego#"            null="#!len(arguments.id_UsuarioEntrego)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioRecibio"            value="#arguments.id_UsuarioRecibio#"            null="#!len(arguments.id_UsuarioRecibio)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"               value="#arguments.id_Requisicion#"               null="#!isNumeric(arguments.id_Requisicion)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioRegistroMovimiento" value="#session.ID_USUARIO#"                     null="#!len(session.ID_USUARIO)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@im_Total"                     value="#arguments.im_Total#"                     null="#!isNumeric(arguments.im_Total)#">
            <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorConsignacion"     value="#arguments.id_ProveedorConsignacion#"     null="#!isNumeric(arguments.id_ProveedorConsignacion)#">
            <cfprocresult name="Local.InvMovData" resultset="1">
        </cfstoredproc>

            <!--- <cfquery name="Local.InvMovData" datasource="#variables.cnx#">
                exec upC_InventariosMovimientos
                    #arguments.id_Empresa#,
                    #arguments.id_Sucursal#,
                    #arguments.id_Almacen#,
                    #arguments.id_TipoMovimiento#,
                    <cfif isDefined("#arguments.id_UsuarioEntrego#")    AND #arguments.id_UsuarioEntrego# NEQ ''>'#arguments.id_UsuarioEntrego#'    <cfelse>NULL</cfif>,
                    <cfif isDefined("#arguments.id_UsuarioRecibio#")    AND #arguments.id_UsuarioRecibio# NEQ ''>'#arguments.id_UsuarioRecibio#'    <cfelse>NULL</cfif>,
                    <cfif isDefined("#arguments.id_Requisicion#")       AND #arguments.id_Requisicion# NEQ ''>'#arguments.id_Requisicion#'          <cfelse>NULL</cfif>,
                    #session.ID_USUARIO#,
                    #arguments.im_Total#
            </cfquery> --->

        <cfreturn Local.InvMovData>
    </cffunction>

    <!--- julio cesar acosta lopez
           28/07/2015
           funcion que setea el id_poliza de inventarios movimientos o gastos movimientos segun sea el caso al momento de generar una poliza esto para generar
           un enlace entre polizas e inventarios movimientos --->
    <cffunction name="editarpoliza"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string"  required="true"/>
        <cfargument name="id_sucursal"              type="string"  required="true"/>
        <cfargument name="id_Movimiento"            type="string"  required="true"/>
        <cfargument name="fh_inicio"                type="string"  required="true"/>
        <cfargument name="fh_fin"                   type="string"  required="true"/>
        <cfargument name="id_Poliza"                type="string"  required="true"/>
        <cfargument name="estatus"                  type="string"  required="true"/>

            <cfquery datasource="#variables.cnx#">
                exec upU_InventariosMovimientospoliza
                                                #arguments.id_Empresa#,
                                                #arguments.id_sucursal#,
                                                #arguments.id_Movimiento#,
                                                '#arguments.fh_inicio#',
                                                '#arguments.fh_fin#',
                                                #arguments.id_Poliza#,
                                                #estatus#

            </cfquery>
    </cffunction>

    <cffunction name="AgregarRegistroEntradaAjuste"    access="public" returntype="any">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_TipoMovimiento"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioEntrego"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioRegistroMovimiento"     type="numeric"  required="true"/>
        <cfargument name="id_OrigenMovimientoAjuste"        type="numeric"  required="true"/>
        <cfargument name="de_Comentarios"                   type="string"   required="false"/>
        <cfargument name="id_EstatusAutorizacionAjuste"     type="string"   required="true"/>
        <cfargument name="id_inventariofisico"              type="string"   required="false"/>
         <cfargument name="Im_totalMN"                      type="string"  required="true"/>

        <!--- <cfdump var="#arguments#" /><cfabort /> --->
            <cfquery   name="Local.RS" datasource="#variables.cnx#">
                exec upC_InventariosMovimientosEntrSaliporAjuste
                                                #arguments.id_Empresa#,
                                                #arguments.id_Sucursal#,
                                                #arguments.id_Almacen#,
                                                #arguments.id_TipoMovimiento#,
                                                #arguments.id_UsuarioEntrego#,
                                                #arguments.id_UsuarioRegistroMovimiento#,
                                                #arguments.id_OrigenMovimientoAjuste#,
                    <cfif isDefined("arguments.de_Comentarios") AND arguments.de_Comentarios NEQ ''>'#arguments.de_Comentarios#'<cfelse>NULL</cfif>,
                                                NULL,
                                                NULL,
                                                #arguments.id_EstatusAutorizacionAjuste#,
                                                <cfif isDefined("arguments.id_inventariofisico") AND arguments.id_inventariofisico NEQ ''>'#arguments.id_inventariofisico#'<cfelse>NULL</cfif>,

                                                #arguments.Im_totalMN#
            </cfquery>
            <cfreturn Local.RS.id_Movimiento>
    </cffunction>

    <!--- funcion para insertar en inventariosmovimientos --->
    <cffunction name="AgregarRegistroSalidaAjuste"    access="public" returntype="any">
        <cfargument name="id_Empresa"                       type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"                      type="numeric"  required="true"/>
        <cfargument name="id_Almacen"                       type="numeric"  required="true"/>
        <cfargument name="id_TipoMovimiento"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioEntrego"                type="numeric"  required="true"/>
        <cfargument name="id_UsuarioRegistroMovimiento"     type="numeric"  required="true"/>
        <cfargument name="id_OrigenMovimientoAjuste"        type="numeric"  required="true"/>
        <cfargument name="de_Comentarios"                   type="string"   required="false"/>
        <cfargument name="id_TipoCausaFaltante"             type="string"   required="true"/>
        <cfargument name="id_TipoSugerenciaCargo"           type="string"   required="false"/>
        <cfargument name="id_EstatusAutorizacionAjuste"     type="string"   required="true"/>
        <cfargument name="id_inventariofisico"              type="string"   required="false"/>

        <!--- <cfdump var="#arguments#" /><cfabort /> --->
            <cfquery  name="Local.RS" datasource="#variables.cnx#">
                exec upC_InventariosMovimientosEntrSaliporAjuste
                                                #arguments.id_Empresa#,
                                                #arguments.id_Sucursal#,
                                                #arguments.id_Almacen#,
                                                #arguments.id_TipoMovimiento#,
                                                #arguments.id_UsuarioEntrego#,
                                                #arguments.id_UsuarioRegistroMovimiento#,
                                                #arguments.id_OrigenMovimientoAjuste#,
                    <cfif isDefined("arguments.de_Comentarios") AND arguments.de_Comentarios NEQ ''>'#arguments.de_Comentarios#'<cfelse>NULL</cfif>,
                                                #arguments.id_TipoCausaFaltante#,
                                                NULL,
                                                #arguments.id_EstatusAutorizacionAjuste#,
                                                '#arguments.id_inventariofisico#'
            </cfquery>
            <cfreturn Local.RS.id_Movimiento>
    </cffunction>

    <cffunction name="setIm_totalMN" access="public" returntype="void">
        <cfargument name="id_Empresa" type="numeric"  required="true"/>
        <cfargument name="id_Sucursal" type="numeric"  required="true"/>
        <cfargument name="id_Almacen" type="numeric"  required="true"/>
        <cfargument name="id_Movimiento" type="numeric"  required="true"/>
        <cfargument name="Im_totalMN" type="numeric"  required="true"/>

        <cfquery datasource="#variables.cnx#">
            exec upU_InventariosMovimientosSetTotal_MN
                                    #arguments.id_Empresa#,
                                    #arguments.id_Sucursal#,
                                    #arguments.id_Almacen#,
                                    #arguments.id_Movimiento#,
                                    #arguments.Im_totalMN#
        </cfquery>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Obtiene los empleados con usuario y/o las personas que ya han sido registradas en
          movimientos anteriores.    --->
    <cffunction name="getPersonasReciben" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosHistorialPersonasReciben #Arguments.id_Empresa#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Obtiene los empleados con usuario y/o las personas que ya han sido registradas en
          movimientos anteriores.    --->
    <cffunction name="getByTraspaso" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_inventarioTraspaso" type="numeric" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_InventariosMovimientosByTraspaso #Arguments.id_Empresa#,#Arguments.id_inventarioTraspaso#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Autor: Mario Mejia
          Fecha: 27/08/2015
          Actualiza el id_EstatusSurtidoTraspaso de un movimiento dado   --->
    <cffunction name="setEstatusSurtidoTraspaso" access="public" returntype="void">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Movimiento"        type="numeric" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upU_InventariosMovimientosSetEstatusSurtidoTraspaso
                                #Arguments.id_Empresa#,
                                #Arguments.id_Sucursal#,
                                #Arguments.id_Almacen#,
                                #Arguments.id_Movimiento#
        </cfquery>
    </cffunction>
    <!---- Creo Efreen el 10-10-2015 para crear aqui mismo el nex id y el folio,
     ademas que la fecha de mov y de registro se guarde un getdate--->
    <cffunction name='AgregarMovimiento' access='public' returntype='any'>
    <cfargument name='id_Empresa' type='numeric' required='yes'>
    <cfargument name='id_Sucursal' type='numeric' required='yes'>
    <cfargument name='id_Almacen' type='numeric' required='yes'>
    <cfargument name='id_TipoMovimiento' type='numeric' required='yes'>
    <cfargument name='fl_FacturaRemision' type='string' required='no'>
    <cfargument name='fh_FacturaRemision' type='string' required='no'>
    <cfargument name='im_TotalMN' type='string' required='no'>
    <cfargument name='de_Entrego' type='string' required='no'>
    <cfargument name='id_UsuarioEntrego' type='numeric' required='no'>
    <cfargument name='de_Recibio' type='string' required='no'>
    <cfargument name='id_UsuarioRecibio' type='numeric' required='no'>
    <cfargument name='id_Requisicion' type='numeric' required='no'>
    <cfargument name='de_Comentarios' type='string' required='no'>
    <cfargument name='id_InventarioTraspaso' type='numeric' required='no'>
    <cfargument name='id_InventarioFisico' type='numeric' required='no'>
    <cfargument name='id_MovimientoDevolucion' type='numeric' required='no'>
    <cfargument name='id_UsuarioRegistroMovimiento' type='numeric' required='yes'>
    <cfargument name='id_OrigenMovimientoAjuste' type='numeric' required='no'>
    <cfargument name='id_Poliza' type='numeric' required='no'>
    <cfargument name='id_EstatusSurtidoTraspaso' type='numeric' required='no'>
    <cfargument name='id_TipoCausaFaltante' type='string' required='no'>
    <cfargument name='id_ordenDeCompra' type='numeric' required='no'>

    <!--- <cfquery name="Local.RS" datasource="#variables.cnx#" >
        EXECUTE upC_InventariosMovimientos_Agregar
                #id_Empresa#,
                #id_Sucursal#,
                #id_Almacen#,
                #id_TipoMovimiento#,
                <cfif Not IsDefined('arguments.fl_FacturaRemision')>NULL<cfelse>'#fl_FacturaRemision#'</cfif>,
                <cfif Not IsDefined('arguments.fh_FacturaRemision')  OR arguments.fh_FacturaRemision EQ ''>NULL<cfelse>'#fh_FacturaRemision#'</cfif>,
                <cfif IsDefined('arguments.im_TotalMN') and #arguments.im_TotalMN# NEQ ''>#im_TotalMN#<cfelse>NULL</cfif>,
                <cfif Not IsDefined('arguments.de_Entrego')>NULL<cfelse>'#de_Entrego#'</cfif>,
                <cfif Not IsDefined('arguments.id_UsuarioEntrego')>NULL<cfelse>#id_UsuarioEntrego#</cfif>,
                <cfif Not IsDefined('arguments.de_Recibio')>NULL<cfelse>'#de_Recibio#'</cfif>,
                <cfif Not IsDefined('arguments.id_UsuarioRecibio')>NULL<cfelse>#id_UsuarioRecibio#</cfif>,
                <cfif Not IsDefined('arguments.id_ordenDeCompra')>NULL<cfelse>#arguments.id_ordenDeCompra#</cfif>,
                <cfif Not IsDefined('arguments.id_Requisicion')>NULL<cfelse>#id_Requisicion#</cfif>,
                <cfif IsDefined('arguments.de_Comentarios') AND #arguments.de_Comentarios# NEQ ''>'#de_Comentarios#'<cfelse>NULL</cfif>,
                <cfif Not IsDefined('arguments.id_InventarioTraspaso')>NULL<cfelse>#id_InventarioTraspaso#</cfif>,
                <cfif Not IsDefined('arguments.id_InventarioFisico')>NULL<cfelse>#id_InventarioFisico#</cfif>,
                <cfif Not IsDefined('arguments.id_MovimientoDevolucion')>NULL<cfelse>#id_MovimientoDevolucion#</cfif>,
                #id_UsuarioRegistroMovimiento#,
                <cfif Not IsDefined('arguments.id_OrigenMovimientoAjuste')>NULL<cfelse>#id_OrigenMovimientoAjuste#</cfif>,
                <cfif Not IsDefined('arguments.id_Poliza')>NULL<cfelse>#id_Poliza#</cfif>,
                <cfif Not IsDefined('arguments.id_EstatusSurtidoTraspaso')>NULL<cfelse>#id_EstatusSurtidoTraspaso#</cfif>,
                <cfif Not IsDefined('arguments.id_TipoCausaFaltante')>NULL<cfelse>#id_TipoCausaFaltante#</cfif>
    </cfquery> --->
    <cfstoredproc procedure="upC_InventariosMovimientos_Agregar">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#!isNumeric(arguments.id_Almacen)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_TipoMovimiento" value="#arguments.id_TipoMovimiento#" null="#!isNumeric(arguments.id_TipoMovimiento)#">
        <cfprocparam sqltype="CF_SQL_VARCHAR" dbvarname="@fl_FacturaRemision" value="#arguments.fl_FacturaRemision#" null="#!len(arguments.fl_FacturaRemision)#">
        <cfprocparam sqltype="CF_SQL_VARCHAR"   dbvarname="@fh_FacturaRemision" value="#arguments.fh_FacturaRemision#" null="#!len(arguments.fh_FacturaRemision)#">
        <cfprocparam sqltype="CF_SQL_DECIMAL" scale="2" dbvarname="@im_TotalMN" value="#arguments.im_TotalMN#" null="#!isNumeric(arguments.im_TotalMN)#">
        <cfprocparam sqltype="CF_SQL_VARCHAR" dbvarname="@de_Entrego" value="#arguments.de_Entrego#" null="#!len(arguments.de_Entrego)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioEntrego" value="#arguments.id_UsuarioEntrego#" null="#!isNumeric(arguments.id_UsuarioEntrego)#">
        <cfprocparam sqltype="CF_SQL_VARCHAR" dbvarname="@de_Recibio" value="#arguments.de_Recibio#" null="#!len(arguments.de_Recibio)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioRecibio" value="#arguments.id_UsuarioRecibio#" null="#!isNumeric(arguments.id_UsuarioRecibio)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_ordenDeCompra" value="#arguments.id_ordenDeCompra#" null="#!isNumeric(arguments.id_ordenDeCompra)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#!isNumeric(arguments.id_Requisicion)#">
        <cfprocparam sqltype="CF_SQL_VARCHAR" dbvarname="@de_Comentarios" value="#arguments.de_Comentarios#" null="#!len(arguments.de_Comentarios)#">
        <cfprocparam sqltype="CF_SQL_BIGINT" dbvarname="@id_InventarioTraspaso" value="#arguments.id_InventarioTraspaso#" null="#!isNumeric(arguments.id_InventarioTraspaso)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_InventarioFisico" value="#arguments.id_InventarioFisico#" null="#!isNumeric(arguments.id_InventarioFisico)#">
        <cfprocparam sqltype="CF_SQL_BIGINT" dbvarname="@id_MovimientoDevolucion" value="#arguments.id_MovimientoDevolucion#" null="#!isNumeric(arguments.id_MovimientoDevolucion)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioRegistroMovimiento" value="#arguments.id_UsuarioRegistroMovimiento#" null="#!isNumeric(arguments.id_UsuarioRegistroMovimiento)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_OrigenMovimientoAjuste" value="#arguments.id_OrigenMovimientoAjuste#" null="#!isNumeric(arguments.id_OrigenMovimientoAjuste)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_Poliza" value="#arguments.id_Poliza#" null="#!isNumeric(arguments.id_Poliza)#">
        <cfprocparam sqltype="CF_SQL_SMALLINT" dbvarname="@id_EstatusSurtidoTraspaso" value="#arguments.id_EstatusSurtidoTraspaso#" null="#!isNumeric(arguments.id_EstatusSurtidoTraspaso)#">
        <cfprocparam sqltype="CF_SQL_INTEGER" dbvarname="@id_TipoCausaFaltante" value="#arguments.id_TipoCausaFaltante#" null="#!isNumeric(arguments.id_TipoCausaFaltante)#">
        <cfprocresult name="LOCAL.rs" resultset="1">
    </cfstoredproc>
    <cfreturn Local.RS.id_Movimiento>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="repSalidasPorAlmacen" access="public" returntype="query">
        <cfargument name='id_empresa'           type='string'  required='false'>
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>

        <cfstoredproc procedure="upL_salidasPorAlmacen" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_insumo" value="#arguments.id_insumo#" null="#iif(isNumeric(arguments.id_insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoMovimiento" value="#arguments.id_tipoMovimiento#" null="#iif(isNumeric(arguments.id_tipoMovimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicio#" null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_fin#" null="false">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="repSalidasPorAlmacenPaginado" access="public" returntype="query">
        <cfargument name='id_empresa'           type='string'  required='false'>
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <cfargument name='page'             type='string'  required='false'>
        <cfargument name='pageSize'             type='string'  required='false'>

        <cfstoredproc procedure="upL_salidasPorAlmacenPaginado" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_insumo" value="#arguments.id_insumo#" null="#iif(isNumeric(arguments.id_insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoMovimiento" value="#arguments.id_tipoMovimiento#" null="#iif(isNumeric(arguments.id_tipoMovimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_inicio" value="#arguments.fh_inicio#" null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_fin" value="#arguments.fh_fin#" null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page" value="#arguments.page#" null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize" value="#arguments.pageSize#" null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="impresionDeMovimientosEncabezado" access="public" returntype="query">
        <cfargument name='id_empresa'           type='string'  required='false'>
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_Movimiento'        type='string'  required='false'>

            <cfstoredproc procedure="upR_ConsultaMovimientos" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#iif(isNumeric(arguments.id_empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#iif(isNumeric(arguments.id_almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#iif(isNumeric(arguments.id_movimiento),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="impresionDeMovimientosDetalle" access="public" returntype="query">
        <cfargument name='id_empresa'           type='string'  required='false'>
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_Movimiento'        type='string'  required='false'>

            <cfstoredproc procedure="upR_ConsultaMovimientosDetalle" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#iif(isNumeric(arguments.id_empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#iif(isNumeric(arguments.id_almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#iif(isNumeric(arguments.id_movimiento),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

        <cffunction name="impresionDeMovimientosDivision" access="public" returntype="query">
        <cfargument name='id_empresa'           type='string'  required='false'>
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_Movimiento'        type='string'  required='false'>

            <cfstoredproc procedure="upL_ConsultaDivisionPorMovimiento" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa" value="#arguments.id_empresa#" null="#iif(isNumeric(arguments.id_empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_sucursal" value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@id_almacen" value="#arguments.id_almacen#" null="#iif(isNumeric(arguments.id_almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_movimiento" value="#arguments.id_movimiento#" null="#iif(isNumeric(arguments.id_movimiento),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que devuelve los movimentos de servicio 22/10/2015 --->
    <cffunction name="GastosMovimientosContable" access="public" returntype="query">
        <cfargument name="id_empresa"               type="string" required="true"/>
        <cfargument name="id_sucursal"              type="string" required="true"/>
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_movimiento"            type="string" required="true"/>
        <cfargument name="page"                     type="string" required="true"/>
        <cfargument name="pageSize"                 type="string" required="true"/>
        <cfargument name = "id_FolioMov"            type="string"  required="false">
        <cfargument name = "id_FolioFac"            type="string"  required="false">
        <cfargument name = "id_FolioOC"             type="string"  required="false">
        <cfargument name = "id_Moneda"              type="string"  required="false">

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosAyudaFacturas
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        <cfif isDefined("Arguments.fh_inicioMovimiento") AND ARGUMENTS.fh_inicioMovimiento NEQ ''>'#Arguments.fh_inicioMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_finMovimiento") AND ARGUMENTS.fh_finMovimiento NEQ ''>'#Arguments.fh_finMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_proveedor") AND ARGUMENTS.id_proveedor NEQ ''>#Arguments.id_proveedor#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_movimiento") AND ARGUMENTS.id_movimiento NEQ ''>#Arguments.id_movimiento#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_FolioMov") AND ARGUMENTS.id_FolioMov NEQ ''>#Arguments.id_FolioMov#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_FolioFac") AND ARGUMENTS.id_FolioFac NEQ ''>'#Arguments.id_FolioFac#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_FolioOC") AND ARGUMENTS.id_FolioOC NEQ ''>#Arguments.id_FolioOC#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_Moneda") AND ARGUMENTS.id_Moneda NEQ ''>#Arguments.id_Moneda#<cfelse>NULL</cfif>,
                        #arguments.page#,
                        #arguments.pageSize#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <!--- Jesus Reyes --->
    <cffunction name="GastosMovimientosdetalleContable" access="public" returntype="query">
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosdetalleContable
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        #arguments.id_movimiento#

            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!---
        AUTOR: FLORENTINO
        FECHA: 2016/04/14
    --->

    <cffunction name="listarGeneral" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="numeric"  required="true"/>
        <cfargument name="id_Sucursal"          type="numeric"  required="true"/>
        <cfargument name="id_Almacen"           type="numeric"  required="true"/>
        <cfargument name="fh_Inicio"            type="string"   required="false"/>
        <cfargument name="fh_Fin"               type="string"   required="false"/>
        <cfargument name="fl_Movimiento"        type="string"   required="false"/>
        <cfargument name="id_TipoMovimiento"    type="numeric"  required="false"/>
        <cfargument name="nb_Insumo"            type="string"   required="false"/>
        <cfargument name="id_Estatus"           type="numeric"  required="false"/>
        <cfargument name="nu_FolioMovimiento"   type="string"   required="false"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_InventariosMovimientosGeneral
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        <cfif isDefined("Arguments.fh_Inicio")>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_Fin")>'#Arguments.fh_Fin#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fl_Movimiento")>'#Arguments.fl_Movimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_TipoMovimiento")>#Arguments.id_TipoMovimiento#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.nb_Insumo")>'#Arguments.nb_Insumo#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_Estatus")>#Arguments.id_Estatus#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.nu_FolioMovimiento")>'#Arguments.nu_FolioMovimiento#'<cfelse>NULL</cfif>
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="editarpolizaCancelacion"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_sucursal"              type="numeric"  required="true"/>
        <cfargument name="id_Almacen"               type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"            type="numeric"  required="true"/>
        <cfargument name="id_PolizaCancel"          type="numeric"  required="true"/>
        <cfargument name="fh_PolizaCancel"          type="string"  required="true"/>

            <cfquery datasource="#variables.cnx#">
                exec upU_InventariosMovimientosPolizaCancelacion
                                                #arguments.id_Empresa#,
                                                #arguments.id_sucursal#,
                                                #arguments.id_Almacen#,
                                                #arguments.id_Movimiento#,
                                                #arguments.id_PolizaCancel#,
                                                '#arguments.fh_PolizaCancel#'

            </cfquery>
    </cffunction>

    <cffunction name="ActualizarColEstatus"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="numeric" required="true"/>
        <cfargument name="id_Movimiento"            type="numeric" required="true"/>
        <cfargument name="id_Estatus"               type="numeric" required="true"/>
        <cfargument name="id_usuarioCan"            type="numeric" required="false"/>
        <cfargument name="de_observacionesCan"      type="string"  required="false"/>

        <cfstoredproc procedure="upU_InventariosMovimientosActualizarEstatus" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"         value="#arguments.id_sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"          value="#arguments.id_Almacen#"          null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"       value="#arguments.id_Movimiento#"       null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"          value="#arguments.id_Estatus#"          null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_usuarioCan"       value="#arguments.id_usuarioCan#"       null="#iif(isNumeric(arguments.id_usuarioCan),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_observacionesCan" value="#arguments.de_observacionesCan#" null="#iif(isNumeric(arguments.de_observacionesCan),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="ActualizarFechaCancelacion"    access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_sucursal"              type="numeric"  required="true"/>
        <cfargument name="id_Almacen"               type="numeric"  required="true"/>
        <cfargument name="id_Movimiento"            type="numeric"  required="true"/>
        <cfargument name="fh_Cancelacion"           type="numeric"  required="true"/>
        <cfargument name="de_Observaciones"         type="string"  required="false"/>
        <cfargument name="id_Usuario"               type="numeric"  required="false"/>
            <cfstoredproc procedure="upU_InventariosMovimientosFechaCancelacion" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"       null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_Sucursal#"      null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"               value="#arguments.id_Almacen#"       null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"            value="#arguments.id_Movimiento#"    null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"          dbvarname="@fh_Cancelacion"           value="#arguments.fh_Cancelacion#"   null="#iif(len(arguments.fh_Cancelacion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ComentarioCancelacion" value="#arguments.de_Observaciones#" null="#iif(len(arguments.de_Observaciones),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioCancelacion"    value="#arguments.id_Usuario#"       null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
            </cfstoredproc>
    </cffunction>

    <cffunction name="leerMovimiento" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_Almacen"           type="string"   required="true"/>
        <cfargument name="id_Movimiento"        type="string"   required="true"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_InventariosMovimientos
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="upR_sn_DentroDeUnCierre" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_Almacen"           type="string"   required="true"/>
        <cfargument name="id_Movimiento"        type="string"   required="true"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_sn_DentroDeUnCierre
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="IMExisteDetalleImportes" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_Almacen"           type="string"   required="true"/>
        <cfargument name="id_Movimiento"        type="string"   required="true"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_inventariosMovimientosExisteDetalleImportes
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        #arguments.id_Movimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="IMExisteMovimientosTraspasos" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_Almacen"           type="string"   required="true"/>
        <cfargument name="id_Movimiento"        type="string"   required="true"/>
        <cfargument name="id_tipoMovimiento"    type="string"   required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upR_inventariosMovimientosExisteMovimientosTraspasos
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        #arguments.id_Movimiento#,
                        #arguments.id_tipoMovimiento#
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="InventariosTraspasosDetalleSetEstatusEnvioDesdeMovimiento" access="public" returntype="void">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_Almacen"           type="string"   required="true"/>
        <cfargument name="id_Movimiento"        type="string"   required="true"/>
        <cfargument name="id_EstatusTraspaso"       type="string"   required="true"/>

            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upU_InventariosTraspasosDetalleSetEstatusEnvioDesdeMovimiento
                        #arguments.id_Empresa#,
                        #arguments.id_Sucursal#,
                        #arguments.id_Almacen#,
                        #arguments.id_Movimiento#,
                        #arguments.id_EstatusTraspaso#
            </cfquery>
        <cfreturn/>
    </cffunction>

    <!--- funcion que devuelve los movimentos de servicio 22/10/2015 --->
    <cffunction name="getGenerarExcel" access="public" returntype="query">
        <cfargument name="id_empresa"               type="string" required="true"/>
        <cfargument name="id_sucursal"              type="string" required="true"/>
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_movimiento"            type="string" required="true"/>
        <cfargument name="id_OrdenCompra"           type="string" required="false"/>
        <cfargument name="SubioFactura"             type="numeric" required="false"/>


            <cfquery name="Local.rs" datasource="#variables.cnx#" >
                exec upL_GastosMovimientosentradasserviciosExcel
                        #arguments.id_empresa#,
                        #arguments.id_sucursal#,
                        <cfif isDefined("Arguments.fh_inicioMovimiento") AND ARGUMENTS.fh_inicioMovimiento NEQ ''>'#Arguments.fh_inicioMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.fh_finMovimiento")    AND ARGUMENTS.fh_finMovimiento    NEQ ''>'#Arguments.fh_finMovimiento#'<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_proveedor")        AND ARGUMENTS.id_proveedor        NEQ ''>#Arguments.id_proveedor#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_movimiento")       AND ARGUMENTS.id_movimiento       NEQ ''>#Arguments.id_movimiento#<cfelse>NULL</cfif>,
                        <cfif isDefined("Arguments.id_OrdenCompra")      AND ARGUMENTS.id_OrdenCompra      NEQ ''>#Arguments.id_OrdenCompra#<cfelse>NULL</cfif>,
                        #arguments.SubioFactura#


            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="existeFactura" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string"   required="true"/>
        <cfargument name="id_Sucursal"              type="string"   required="true"/>
        <cfargument name="id_Almacen"               type="string"   required="true"/>
        <cfargument name="id_Movimiento"            type="string"   required="true"/>
        <cfargument name="id_TipoDocumentoSoporte"  type="string"   required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_inventariosMovimientosExisteFactura
                    #arguments.id_Empresa#,
                    #arguments.id_Sucursal#,
                    <cfif isDefined("Arguments.id_Almacen") AND Arguments.id_Almacen NEQ ''>#Arguments.id_Almacen#<cfelse>NULL</cfif>,
                    #arguments.id_Movimiento#,
                    #arguments.id_TipoDocumentoSoporte#
        </cfquery>
    </cffunction>


    <cffunction name="ObtenerTarjetaAlmacen" access="public" returntype="struct">
        <cfargument name="id_Empresa" type="string" required="true"/>
        <cfargument name="id_Sucursal" type="string" required="true"/>
        <cfargument name="id_Almacen" type="string" required="true"/>
        <cfargument name="id_FamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="fh_Inicio" type="string" required="false" default=""/>
        <cfargument name="fh_Fin" type="string" required="false" default=""/>
        <cfargument name="nb_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_AlmacenFisico" type="string" required="false" default=""/>

        <cfstoredproc procedure="upR_InventariosMovimientos_TarjetaAlmacen" datasource="#variables.cnx#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#!isNumeric(arguments.id_Empresa)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#!isNumeric(arguments.id_Sucursal)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#!isNumeric(arguments.id_Almacen)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo" value="#arguments.id_FamiliaInsumo#" null="#!isNumeric(arguments.id_FamiliaInsumo)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#!isNumeric(arguments.id_SubFamiliaInsumo)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio" value="#arguments.fh_Inicio#" null="#!Len(arguments.fh_Inicio)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin" value="#arguments.fh_Fin#" null="#!Len(arguments.fh_Fin)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Insumo" value="#arguments.nb_Insumo#" null="#!Len(arguments.nb_Insumo)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo" value="#arguments.id_Insumo#" null="#!isNumeric(arguments.id_Insumo)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AlmacenFisico" value="#arguments.id_AlmacenFisico#" null="#!isNumeric(arguments.id_AlmacenFisico)#">
          <cfprocresult name=" Local.Detallado"   resultset="1">
          <cfprocresult name=" Local.Concentrado" resultset="2">
        </cfstoredproc>

        <cfreturn Local/>

    </cffunction>

    <cffunction name="Kardex" access="public" returntype="Struct">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="id_sucursal"          type="string" required="false"/>
        <cfargument name="id_almacen"           type="string" required="false"/>
        <cfargument name="id_Naturaleza"        type="string" required="false" default=""/>
        <cfargument name="id_TipoMovimiento"    type="string" required="false" default=""/>
        <cfargument name="fh_movimientoIni"     type="string" required="true"/>
        <cfargument name="fh_movimientoFin"     type="string" required="true"/>
        <cfargument name="id_insumo"            type="string" required="false" default=""/>
        <cfargument name="id_TipoNegocio"       type="string" required="false" default=""/>

        <cfstoredproc procedure="upL_ReporteKardex" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"        value="#arguments.id_empresa#"        null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal"       value="#arguments.id_sucursal#"       null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen"        value="#arguments.id_almacen#"        null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Naturaleza"     value="#arguments.id_Naturaleza#"     null="#iif(isNumeric(arguments.id_Naturaleza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoMovimiento" value="#arguments.id_TipoMovimiento#" null="#iif(isNumeric(arguments.id_TipoMovimiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"         value="#arguments.id_insumo#"         null="#iif(isNumeric(arguments.id_insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_movimientoIni"  value="#arguments.fh_movimientoIni#"  null="#iif(len(arguments.fh_movimientoIni),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_movimientoFin"  value="#arguments.fh_movimientoFin#"  null="#iif(len(arguments.fh_movimientoFin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoNegocio"    value="#arguments.id_TipoNegocio#"    null="#iif(isNumeric(arguments.id_TipoNegocio),false,true)#">
            <cfprocresult name="Local.rs.movNormales" resultset="1">
            <cfprocresult name="Local.rs.movActivosFijos" resultset="2">
            <cfprocresult name="Local.rs.kardexSinMovimientos" resultset="3">
            <cfprocresult name="Local.rs.valuacionInventario" resultset="4">
            <cfprocresult name="Local.rs.otrosMovimientos" resultset="5">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="InventariosMovimientos_SalidaAjusteConsg" access="public" returntype="Query">
        <cfargument name="id_Empresa"        type="string" required="true"/>
        <cfargument name="id_Sucursal"       type="string" required="true"/>
        <cfargument name="id_Almacen"        type="string" required="true"/>
        <cfargument name="id_TipoMovimiento" type="string" required="false"/>

        <cfstoredproc procedure="upC_InventariosMovimientos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"        value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"       value="#arguments.id_Sucursal#"       null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"        value="#arguments.id_Almacen#"        null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoMovimiento" value="#arguments.id_TipoMovimiento#" null="#iif(isNumeric(arguments.id_TipoMovimiento),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ActualizarRelacionConsignacion" access="public" returntype="void">
        <cfargument name="id_Empresa"        type="string" required="true"/>
        <cfargument name="id_Sucursal"       type="string" required="true"/>
        <cfargument name="id_Almacen"        type="string" required="true"/>
        <cfargument name="id_MovimientoSalida" type="string" required="false"/>
        <cfargument name="id_MovimientoEntrConsg" type="string" required="false"/>

        <cfstoredproc procedure="upU_InventariosMovimientos_RelacionSalidaConsignacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"             null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"            value="#arguments.id_Sucursal#"            null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"             value="#arguments.id_Almacen#"             null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_MovimientoSalida"    value="#arguments.id_MovimientoSalida#"    null="#iif(isNumeric(arguments.id_MovimientoSalida),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_MovimientoEntrConsg" value="#arguments.id_MovimientoEntrConsg#" null="#iif(isNumeric(arguments.id_MovimientoEntrConsg),false,true)#">
        </cfstoredproc>

    </cffunction>

    <cffunction name="MovimientoConConsignacion" access="public" returntype="query">
        <cfargument name="id_Empresa"    type="string" required="true"/>
        <cfargument name="id_Sucursal"   type="string" required="true"/>
        <cfargument name="id_Almacen"    type="string" required="true"/>
        <cfargument name="id_Movimiento" type="string" required="false"/>

        <cfstoredproc procedure="upR_InventariosMovimientos_MovimientosConsignacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"    value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"   value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"    value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento" value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getSalidasConsumo" access="public" returntype="Query">
        <cfargument name="id_Empresa"           type="string" required="false"/>
        <cfargument name="id_Requisicion"          type="string" required="false"/>

        <cfstoredproc procedure="upL_getMovimientosSalidaConsumo" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"        value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"       value="#arguments.id_Requisicion#"       null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="impresionSalidasTraspasoInformacion" access="public" returntype="struct">
        <cfargument name="id_Empresa"              type="string" required="false">
        <cfargument name="id_InventarioTraspaso"   type="string" required="false">
        <cfargument name="id_InventarioMovimiento" type="string" required="false">

        <cfstoredproc procedure="upL_InventariosMovimientosTraspasos_InfoDocumentoSalida" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"              value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_InventarioTraspaso"   value="#arguments.id_InventarioTraspaso#"   null="#iif(isNumeric(arguments.id_InventarioTraspaso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_InventarioMovimiento" value="#arguments.id_InventarioMovimiento#" null="#iif(isNumeric(arguments.id_InventarioMovimiento),false,true)#">
            <cfprocresult name="Local.rs.Encabezado" resultset="1">
            <cfprocresult name="Local.rs.Detalle" resultset="2">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
