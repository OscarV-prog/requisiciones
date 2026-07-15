<cfcomponent extends="wiz/OrdenesDeCompraDetalle">
    
    <cffunction name="get_OrdenesDeCompraDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true">
        <cfargument name="id_OrdenDeCompra"         type="numeric" required="true">
        <cfargument name="id_OrdenDeCompraDetalle"  type="numeric" required="true">
        <cfquery name="Local.RS" datasource="#variables.cnx#">
            EXECUTE upR_OrdenesDeCompraDetalle
                        @id_Empresa                 = #id_Empresa#,
                        @id_OrdenDeCompra           = #id_OrdenDeCompra#,
                        @id_OrdenDeCompraDetalle    = #id_OrdenDeCompraDetalle#
        </cfquery>
        <cfreturn local.RS>
    </cffunction>

    <cffunction name="get_Id_estatusSurtido" access="public" returntype="query">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_ordenDeCompraDetalle" type="numeric" required="true">
        <cfargument name="id_insumo" type="numeric" required="true">
        

        <cfquery name="Local.RS" datasource="#variables.cnx#">
            SELECT
                id_estatusSurtido
            FROM
                OrdenesDeCompraDetalle
            WHERE
                id_empresa = #arguments.id_empresa#
            AND id_ordenDeCompra = #arguments.id_ordenDeCompra#
            AND id_ordenDeCompraDetalle = #arguments.id_ordenDeCompraDetalle#
            AND id_insumo = #arguments.id_insumo#
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <cffunction name="set_Id_estatusSurtido" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_ordenDeCompraDetalle" type="numeric" required="true">
        <cfargument name="id_insumo" type="numeric" required="true">
        <cfargument name="id_estatusSurtido" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#">
            exec upU_OrdenesDeCompraDetalleSetEstatusSurtido
                                        #id_empresa#,
                                        #id_ordenDeCompra#,
                                        #id_ordenDeCompraDetalle#,
                                        #id_insumo#,
                                        #id_estatusSurtido#
        </cfquery>

    </cffunction>
    
    <cffunction name="actualizarEstatusSurtidoRequisicionDetalles" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="false">
        <cfargument name="id_RequisicionDetalle" type="numeric" required="false">
        <cfargument name="id_estatusSurtido" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#">
            exec upU_RequisicionesDetalleEstatusSurtido
                                        #id_empresa#,
                                        #id_Requisicion#,
                                        #id_RequisicionDetalle#,
                                        #id_estatusSurtido#
        </cfquery>

    </cffunction>

    <!--- Funcion que suma a nu_cantidadSurtida el valor enviado --->
    <cffunction name="add_Nu_CantidadSurtida" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_ordenDeCompraDetalle" type="numeric" required="true">
        <cfargument name="id_insumo" type="numeric" required="true">
        <cfargument name="nu_cantidadSurtida" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#">
            exec upU_OrdenesDeCompraDetalleAddCantidadSurtida
                                        #id_empresa#,
                                        #id_ordenDeCompra#,
                                        #id_ordenDeCompraDetalle#,
                                        #id_insumo#,
                                        #nu_cantidadSurtida#
        </cfquery>

    </cffunction>

    <!--- Funcion que nos devuelve el valor de nu_cantidadSurtida --->
    <cffunction name="get_Nu_CantidadSurtida" access="public" returntype="query">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_ordenDeCompraDetalle" type="numeric" required="true">
        <cfargument name="id_insumo" type="numeric" required="true">

        <cfquery name="local.RS" datasource="#variables.cnx#">
            exec upR_OrdenesDeCompraDetallegetCantidadSurtida
                                        #id_empresa#,
                                        #id_ordenDeCompra#,
                                        #id_ordenDeCompraDetalle#,
                                        #id_insumo#
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 18/05/2015
          Cambia el estatus del detalle a cancelado (aplican restricciones) de la orden de compra --->
    <cffunction name="cancelarDetalleByOrdenDeCompra" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">

        <cfquery name="local.RS" datasource="#variables.cnx#">
            exec upU_OrdenesDeCompraDetalleCancelarByOrdenDeCompra
                                        #Arguments.id_empresa#,
                                        #Arguments.id_ordenDeCompra#
        </cfquery>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 18/05/2015
          Obtiene los estatus del detalle de la orden de compra --->
    <cffunction name="getEstatusSurtidoByOrdenDeCompra" access="public" returntype="query">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">

        <cfquery name="local.RS" datasource="#variables.cnx#">
            exec upL_OrdenesDeCompraDetalleEstatusSurtidoByOrdenDeCompra
                                        #Arguments.id_empresa#,
                                        #Arguments.id_ordenDeCompra#
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 21/05/2015 1:13 am
          Cambia el estatus del detalle a cancelado (aplican restricciones) por id --->
    <cffunction name="cancelarDetalleByID" access="public" returntype="any">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_ordenDeCompraDetalle" type="numeric" required="true">

        <cfquery name="local.RS" datasource="#variables.cnx#">
            exec upU_OrdenesDeCompraDetalleCancelarByID
                                        #Arguments.id_empresa#,
                                        #Arguments.id_ordenDeCompra#,
                                        #Arguments.id_ordenDeCompraDetalle#
        </cfquery>
    </cffunction>

    <cffunction name='AgregarOrdenCompraDetalle' access='public' returntype='any'>
    <cfargument name='id_Empresa' type='numeric' required='yes'>
    <cfargument name='id_OrdenDeCompra' type='numeric' required='yes'>
    <cfargument name='id_Cotizacion' type='numeric' required='no'>
    <cfargument name='id_CotizacionDetalle' type='numeric' required='no'>
    <cfargument name='id_Insumo' type='numeric' required='yes'>
    <cfargument name='nu_Cantidad' type='numeric' required='yes'>
    <cfargument name='im_PrecioUnitario' type='numeric' required='yes'>
    <cfargument name='nu_CantidadSurtida' type='numeric' required='yes'>
    <cfargument name='id_EstatusSurtido' type='numeric' required='yes'>
    <cfargument name='im_TotalInsumo' type='numeric' required='no'>
    <cfargument name='id_Moneda' type='numeric' required='no'>
    <cfargument name='im_TipoCambio' type='numeric' required='no'>
    <cfargument name='pj_Descuento' type='numeric' required='no'>
    <cfargument name='im_Descuento' type='numeric' required='no'>

    <cfquery name='Local.rs' datasource="#variables.cnx#" >
        EXECUTE upC_OrdenesDeCompraDetalle_Agregar
                 #id_Empresa#, 
                 #id_OrdenDeCompra#, 
                 #id_Insumo#,
                 #nu_Cantidad#, 
                 #im_PrecioUnitario#,
                 #nu_CantidadSurtida#, 
                 #id_EstatusSurtido#, 
                 <cfif Not IsDefined('arguments.im_TotalInsumo')>NULL<cfelse>#im_TotalInsumo#</cfif>, 
                 <cfif Not IsDefined('arguments.id_Moneda')>NULL<cfelse>#id_Moneda#</cfif>, 
                 <cfif Not IsDefined('arguments.im_TipoCambio')>NULL<cfelse>#im_TipoCambio#</cfif>,
                 #pj_Descuento#,
                 #im_Descuento#,
                 <cfif Not IsDefined('arguments.id_Cotizacion')>NULL<cfelse>#id_Cotizacion#</cfif>, 
                 <cfif Not IsDefined('arguments.id_CotizacionDetalle')>NULL<cfelse>#id_CotizacionDetalle#</cfif>
    </cfquery>
    <cfreturn local.RS.id_OrdenDeCompraDetalle>
    
</cffunction>
</cfcomponent>
