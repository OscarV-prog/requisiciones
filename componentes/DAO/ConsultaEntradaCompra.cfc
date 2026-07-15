<cfcomponent extends="wiz/OrdenesDeCompra">
    <cffunction name="buscarMovimientos" access="public" returntype="query">
        <cfargument name="id_empresa"          type="string"  required="true">
        <cfargument name="id_sucursal"         type="string"  required="false">
        <!--- <cfargument name="id_sucursales"       type="array"   required="true"> --->
        <cfargument name="id_almacen"          type="numeric" required="false">
        <cfargument name="id_ordenDeCompra"    type="string"  required="false">
        <cfargument name="id_proveedor"        type="numeric" required="false">
        <cfargument name="nb_insumo"           type="string"  required="false">
        <cfargument name="fh_inicioMovimiento" type="string"  required="false">
        <cfargument name="fh_finMovimiento"    type="string"  required="false">
        <cfargument name="SubioFactura"        type="string"  required="false">
        <cfargument name="id_Requisicion"      type="string"  required="false">
        <cfargument name="fl_Movimiento"       type="string"  required="false">
        <cfargument name="page"                type="string"  required="false" default="1"/>
        <cfargument name="pageSize"            type="string"  required="false" default="10"/>

        <!-- Convertir el array de sucursales a JSON -->
        <!--- <cfset jsonSucursales = serializeJSON(arguments.id_sucursales)> --->

        <!--- <cfdump var="#arguments#" /><cfabort /> --->
        <cfstoredproc procedure="upR_ConsultaEntradasCompraMovimientos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_empresa"             value="#arguments.id_empresa#"              null="#iif(isNumeric(arguments.id_empresa), false, true)#">
            <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_NVARCHAR"  dbvarname="@id_sucursales"          value="#jsonSucursales#"                    null="#iif(arrayLen(arguments.id_sucursales) EQ 0, true, false)#"> --->
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_sucursal"            value="#arguments.id_Sucursal#"             null="#iif(isNumeric(arguments.id_Sucursal), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_almacen"             value="#arguments.id_almacen#"              null="#iif(isNumeric(arguments.id_almacen), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_ordenDeCompra"       value="#arguments.id_ordenDeCompra#"        null="#iif(isNumeric(arguments.id_ordenDeCompra), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_proveedor"           value="#arguments.id_proveedor#"            null="#iif(isNumeric(arguments.id_proveedor), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NVARCHAR"  dbvarname="@nb_insumo"              value="#arguments.nb_insumo#"               null="#iif(len(arguments.nb_insumo), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NVARCHAR"  dbvarname="@fh_inicioMovimiento"    value="#arguments.fh_inicioMovimiento#"     null="#iif(len(arguments.fh_inicioMovimiento), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NVARCHAR"  dbvarname="@fh_finMovimiento"       value="#arguments.fh_finMovimiento#"        null="#iif(len(arguments.fh_finMovimiento), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@SubioFactura"           value="#arguments.SubioFactura#"            null="#iif(isNumeric(arguments.SubioFactura), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"          null="#iif(isNumeric(arguments.id_Requisicion), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NVARCHAR"  dbvarname="@fl_Movimiento"          value="#arguments.fl_Movimiento#"           null="#iif(len(arguments.fl_Movimiento), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@page"                   value="#arguments.page#"                    null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@pageSize"               value="#arguments.pageSize#"                null="#iif(isNumeric(arguments.pageSize),false,true)#">

            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="buscarMovimientosAyudaFacturas" access="public" returntype="query">
        <cfargument name="id_empresa"          type="string" required="true">
        <cfargument name="id_sucursal"         type="string" required="true">
        <cfargument name="id_almacen"          type="string" required="true">
        <cfargument name="id_ordenDeCompra"    type="string" required="false">
        <cfargument name="id_proveedor"        type="string" required="false">
        <cfargument name="nb_insumo"           type="string"  required="false">
        <cfargument name="fh_inicioMovimiento" type="string"  required="false">
        <cfargument name="fh_finMovimiento"    type="string"  required="false">
        <cfargument name="id_FolioMov"         type="string"  required="false">
        <cfargument name="id_FolioFac"         type="string"  required="false">
        <cfargument name="id_Moneda"           type="string"  required="false">

            <cfquery datasource="#variables.cnx#" name="Local.rs">
                exec upR_ConsultaEntradasFacturasAlmacen
                                #arguments.id_empresa#,
                                <cfif isDefined("arguments.id_sucursal") AND arguments.id_sucursal NEQ '' >#arguments.id_sucursal#<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_almacen") AND arguments.id_almacen NEQ '' >#arguments.id_almacen#<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_ordenDeCompra") AND arguments.id_ordenDeCompra NEQ '' >#arguments.id_ordenDeCompra#<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_proveedor") AND arguments.id_proveedor NEQ ''>#arguments.id_proveedor#<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.nb_insumo") AND arguments.nb_insumo NEQ '' >'#arguments.nb_insumo#'<cfelse>''</cfif>,
                                <cfif isDefined("arguments.fh_inicioMovimiento") AND arguments.fh_inicioMovimiento NEQ ''>'#arguments.fh_inicioMovimiento#'<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.fh_finMovimiento") AND arguments.fh_finMovimiento NEQ ''>'#arguments.fh_finMovimiento#'<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_FolioMov") AND arguments.id_FolioMov NEQ ''>#arguments.id_FolioMov#<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_FolioFac") AND arguments.id_FolioFac NEQ ''>'#arguments.id_FolioFac#'<cfelse>NULL</cfif>,
                                <cfif isDefined("arguments.id_Moneda") AND arguments.id_Moneda NEQ ''>'#arguments.id_Moneda#'<cfelse>NULL</cfif>
            </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getDetalleMovimiento" access="public" returntype="query">
        <cfargument name="id_empresa"    type="string" required="true">
        <cfargument name="id_sucursal"   type="string" required="true">
        <cfargument name="id_almacen"    type="string" required="true">
        <cfargument name="id_movimiento" type="string" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_ConsultaEntradasCompraMovimientosDetalle
                                    #arguments.id_empresa#,
                                    #arguments.id_sucursal#,
                                    #arguments.id_almacen#,
                                    #arguments.id_movimiento#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getDetalleMovimientoAyudaFacturas" access="public" returntype="query">
        <cfargument name="id_empresa"    type="string" required="true">
        <cfargument name="id_sucursal"   type="string" required="true">
        <cfargument name="id_almacen"    type="string" required="true">
        <cfargument name="id_movimiento" type="string" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_ConsultaEntradasFacturasAlmacenDetalle
                                    #arguments.id_empresa#,
                                    #arguments.id_sucursal#,
                                    #arguments.id_almacen#,
                                    #arguments.id_movimiento#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="ObtenerActivoFijoEntradaCompra" access="public" returntype="any">
        <cfargument name='id_Empresa' type='string' required='yes'>
        <cfargument name='id_Sucursal' type='string' required='yes'>
        <cfargument name='id_Almacen' type='string' required='yes'>
        <cfargument name='id_Movimiento' type='string' required='yes'>

        <cfquery name="Local.RS" datasource="#variables.cnx#">
            exec upL_ObtenerActivoFijoEntradaCompra #id_Empresa#,
                                                    #arguments.id_Sucursal#,
                                                    #arguments.id_Almacen#,
                                                    #arguments.id_Movimiento#
        </cfquery>
        <cfreturn Local.RS/>
    </cffunction>


    <!--- Jesus Reyes --->
    <cffunction name="ListadoCompraActivosFijos" access="public" returntype="query">
        <cfargument name="id_Empresa"          type="string" required="no" default="">
        <cfargument name="id_Sucursal"         type="string" required="no" default="">
        <cfargument name="id_Almacen"          type="string" required="no" default="">
        <cfargument name="de_SerieInsumo"      type="string" required="no" default="">
        <cfargument name="fl_Movimiento"       type="string" required="no" default="">
        <cfargument name="nb_Proveedor"        type="string" required="no" default="">
        <cfargument name="id_OrdenDeCompra"    type="string" required="no" default="">
        <cfargument name="id_Requisicion"      type="string" required="no" default="">
        <cfargument name="id_FamiliaInsumo"    type="string" required="no" default="">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="no" default="">
        <cfargument name="nb_NombreInsumo"     type="string" required="no" default="">
        <cfargument name="fh_Inicio"           type="string" required="no" default="">
        <cfargument name="fh_Fin"              type="string" required="no" default="">

        <cfstoredproc procedure="upR_InventariosMovimientos_CompraDeActivos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#!isNumeric(arguments.id_Empresa)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Sucursal"         value="#arguments.id_Sucursal#"         null="#!isNumeric(arguments.id_Sucursal)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Almacen"          value="#arguments.id_Almacen#"          null="#!isNumeric(arguments.id_Almacen)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"  dbvarname="@de_SerieInsumo"      value="#arguments.de_SerieInsumo#"      null="#!len(arguments.de_SerieInsumo)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"  dbvarname="@fl_Movimiento"       value="#arguments.fl_Movimiento#"       null="#!len(arguments.fl_Movimiento)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"  dbvarname="@nb_Proveedor"        value="#arguments.nb_Proveedor#"        null="#!len(arguments.nb_Proveedor)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_OrdenDeCompra"    value="#arguments.id_OrdenDeCompra#"    null="#!isNumeric(arguments.id_OrdenDeCompra)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Requisicion"      value="#arguments.id_Requisicion#"      null="#!isNumeric(arguments.id_Requisicion)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_FamiliaInsumo"    value="#arguments.id_FamiliaInsumo#"    null="#!isNumeric(arguments.id_FamiliaInsumo)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#!isNumeric(arguments.id_SubFamiliaInsumo)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"  dbvarname="@nb_NombreInsumo"     value="#arguments.nb_NombreInsumo#"     null="#!len(arguments.nb_NombreInsumo)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"           value="#arguments.fh_Inicio#"           null="#!len(arguments.fh_Inicio)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin"              value="#arguments.fh_Fin#"              null="#!len(arguments.fh_Fin)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_EmpresaEmpleado"  value="#session.ID_EMPRESAOPERADORA#" null="#!isNumeric(session.ID_EMPRESAOPERADORA)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empleado"         value="#SESSION.ID_EMPLEADO#"         null="#!isNumeric(SESSION.ID_EMPLEADO)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@sn_ActivoFijo"       value="#arguments.sn_ActivoFijo#"       null="#!isNumeric(arguments.sn_ActivoFijo)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@sn_InsumoRelevante"  value="#arguments.sn_InsumoRelevante#"  null="#!isNumeric(arguments.sn_InsumoRelevante)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@sn_EntradaPendienteFactura" value="#arguments.sn_EntradaPendienteFactura#" null="#!isNumeric(arguments.sn_EntradaPendienteFactura)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>
    
    <cffunction name="ListadoCompraActivosFijos_Excel" access="public" returntype="query">
        <cfargument name="id_Empresa"          type="string" required="no" default="">
        <cfargument name="id_Sucursal"         type="string" required="no" default="">
        <cfargument name="id_Almacen"          type="string" required="no" default="">
        <cfargument name="fh_Inicio"           type="string" required="no" default="">
        <cfargument name="fh_Fin"              type="string" required="no" default="">

        <cfstoredproc procedure="upR_InventariosMovimientos_CompraDeActivos_Excel" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#!isNumeric(arguments.id_Empresa)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"         value="#arguments.id_Sucursal#"         null="#!isNumeric(arguments.id_Sucursal)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Almacen"          value="#arguments.id_Almacen#"          null="#!isNumeric(arguments.id_Almacen)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Inicio"           value="#arguments.fh_Inicio#"           null="#!len(arguments.fh_Inicio)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Fin"              value="#arguments.fh_Fin#"              null="#!len(arguments.fh_Fin)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>
</cfcomponent>
