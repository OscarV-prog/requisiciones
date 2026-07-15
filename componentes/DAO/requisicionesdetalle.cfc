<cfcomponent extends="wiz/requisicionesdetalle">
    <cffunction name="getByIdRequisicion" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_requisicion" type="string" required="true"/>

        <cfstoredproc procedure="upL_RequisicionesDetalleByRequisicion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"     value="#arguments.id_empresa#"     null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion" value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn  Local.rs />
    </cffunction>
    
    <cffunction name="getDetalleRequisicionByIdRD" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_requisicion" type="string" required="true"/>
        <cfargument name="id_requisicionDetalle" type="string" required="true"/>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            Exec bop_RequisicionesDetalle_ObtenerPorID #arguments.id_empresa#,#arguments.id_requisicion#,#arguments.id_requisicionDetalle#
        </cfquery>

        <cfreturn  Local.rs />
    </cffunction>

    <cffunction name="listado" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='true'>
            
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleByRequisicion  #Arguments.id_Empresa#,
                                                        #Arguments.id_requisicion#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarparaRegistroSalidaAlmacen" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
        <cfargument name='id_Requisicion' type='numeric' required='true'>
        <cfargument name='id_Sucursal'    type='numeric' required='true'>
        <cfargument name='id_Almacen'     type='numeric' required='true'>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleparaRegistroSalidaAlmacen  
                                            #Arguments.id_Empresa#,
                                            #arguments.id_Requisicion#,
                                            #arguments.id_Sucursal#,
                                            #arguments.id_Almacen#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="deleteByRequisicion" access="public" returntype="void">
        <cfargument name='id_Empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='true'>
            
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upD_RequisicionesDetalleByRequisicion  #Arguments.id_Empresa#,
                                                        #Arguments.id_requisicion#
        </cfquery>
    </cffunction>

    <cffunction name="setIdSurtido" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Requisicion"            type="numeric" required="true"/>
        <cfargument name="id_RequisicionDetalle"     type="numeric" required="true"/>
        <cfargument name="id_Estatus"                type="numeric" required="true"/>

        <cfquery datasource="#variables.cnx#">
            exec upU_RequisicionesDetalleEstatusSurtido
                                          #arguments.id_Empresa#, 
                                          #arguments.id_Requisicion#,
                                          #arguments.id_RequisicionDetalle#,
                                          #arguments.id_Estatus#                    
        </cfquery>
    </cffunction>

    <cffunction name="getCantidades" access="public" returntype="query">
        <cfargument name='id_Empresa'            type='string' required='true'>
        <cfargument name='id_Requisicion'        type='string' required='true'>
        <cfargument name='id_RequisicionDetalle' type='string' required='true'>
        
        <!--- <cfdump var="#arguments#"/><cfabort /> --->
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleCantidadesInsumos 
                                                    #Arguments.id_Empresa#,
                                                    #Arguments.id_Requisicion#,
                                                    #Arguments.id_RequisicionDetalle#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

<cffunction name='AgregarDetalle' access='public' returntype='query'>
    <cfargument name="id_Empresa"               type="string" required="yes">
    <cfargument name="id_Requisicion"           type="string" required="yes">
    <cfargument name="id_Insumo"                type="string" required="yes">
    <cfargument name="nu_Cantidad"              type="string" required="yes">
    <cfargument name="im_PrecioUnitario"        type="string" required="no">
    <cfargument name="nu_CantidadSurtida"       type="string" required="no">
    <cfargument name="id_EstatusSurtido"        type="string" required="yes">
    <cfargument name="id_SucursalCentroCosto"   type="string" required="no">
    <cfargument name="id_CentroCosto"           type="string" required="no">
    <cfargument name="id_Moneda"                type="string" required="no">
    <cfargument name="im_TipoCambio"            type="string" required="no">
    <cfargument name="id_grupoGasto"            type="string" required="no">
    <cfargument name="id_conceptoGasto"         type="string" required="no">
    <cfargument name="id_GrupoCentroCosto"      type="string" required="no">
    <cfargument name="nu_kilometraje"           type="string" required="no">
    <cfargument name="de_colaborador"           type="string" required="no">
    <cfargument name="id_Direccion"             type="string" required="no">
    <cfargument name="id_TipoInstalacion"       type="string" required="no">


    <cfstoredproc procedure="upC_RequisicionesDetalle_Agregar" datasource="#variables.cnx#" >
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"             null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"         null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"              value="#arguments.id_Insumo#"              null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Cantidad"            value="#arguments.nu_Cantidad#"            null="#iif(isNumeric(arguments.nu_Cantidad),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_PrecioUnitario"      value="#arguments.im_PrecioUnitario#"      null="#iif(isNumeric(arguments.im_PrecioUnitario),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_CantidadSurtida"     value="#arguments.nu_CantidadSurtida#"     null="#iif(isNumeric(arguments.nu_CantidadSurtida),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"      value="#arguments.id_EstatusSurtido#"      null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalCentroCosto" value="#arguments.id_SucursalCentroCosto#" null="#iif(isNumeric(arguments.id_SucursalCentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"         value="#arguments.id_CentroCosto#"         null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"              value="#arguments.id_Moneda#"              null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"          value="#arguments.im_TipoCambio#"          null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_grupoGasto"          value="#arguments.id_grupoGasto#"          null="#iif(isNumeric(arguments.id_grupoGasto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_conceptoGasto"       value="#arguments.id_conceptoGasto#"       null="#iif(isNumeric(arguments.id_conceptoGasto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"    value="#arguments.id_GrupoCentroCosto#"    null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_kilometraje"         value="#arguments.nu_kilometraje#"         null="#iif(isNumeric(arguments.nu_kilometraje),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_colaborador"         value="#arguments.de_colaborador#"         null="#iif(Len(arguments.de_colaborador),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Direccion"           value="#arguments.id_Direccion#"              null="#iif(isNumeric(arguments.id_Direccion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoInstalacion"     value="#arguments.id_TipoInstalacion#"    null="#iif(isNumeric(arguments.id_TipoInstalacion),false,true)#">

        <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn local.rs>
</cffunction>

<cffunction name="getByIdRequisicion_Reporte" access="public" returntype="Query">
        <cfargument name="id_requisicion"   type="string" required="no">
        <cfargument name="id_Empresa"       type="string" required="no">

        <cfstoredproc procedure="upL_RequisicionesDetalleByRequisicion_Reporte" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"     value="#arguments.id_empresa#"     null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion" value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn  Local.rs />
    </cffunction>
</cfcomponent>