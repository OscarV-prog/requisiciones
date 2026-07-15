<cfcomponent extends="wiz/requisicionesdetalle">

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"     type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="true"/>

        <cfstoredproc procedure="upL_RequisicionesDetalle" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#">
            <cfprocresult name="Local.RequisicionesDetalle">
        </cfstoredproc>

        <cfreturn Local.RequisicionesDetalle/>
    </cffunction>

   <cffunction name="listaDatosRequisicion" access="public" returntype="query">
    <cfargument name="id_Empresa"                       type="numeric"required="true">
    <cfargument name="id_Requisicion"                   type="numeric" required="true"/>    
    <cfargument name="id_RequisicionUsuarioAutoriza"    type="numeric" required="false" />
        
        
        <cfquery name="Local.DatosRequisicion" datasource="#variables.cnx#" >
            exec upL_RequisicionparaRequisicionDetalle
                                                      #arguments.id_Empresa#,   
                                                      #arguments.id_Requisicion#,
                       <cfif isDefined("Arguments.id_RequisicionUsuarioAutoriza")       AND arguments.id_RequisicionUsuarioAutoriza NEQ ''>#Arguments.id_RequisicionUsuarioAutoriza#<cfelse>NULL</cfif>
        </cfquery>
        <cfreturn Local.DatosRequisicion/>
    </cffunction>

   <cffunction name="obtener_RequisicionesUsuariosAutorizan" access="public" returntype="query">
    <cfargument name="id_Empresa"                    type="string"  required="true">
    <cfargument name="id_Requisicion"                type="string"  required="true"/>   
    <cfargument name="id_RequisicionUsuarioAutoriza" type="numeric" required="true"/>

        
        <cfquery name="Local.DatosRequisicion" datasource="#variables.cnx#" >
            exec upR_RequisicionesUsuariosAutorizan #arguments.id_Empresa#, #arguments.id_Requisicion#, #arguments.id_RequisicionUsuarioAutoriza#
        </cfquery>
        <cfreturn Local.DatosRequisicion/>
    </cffunction>

    <cffunction name="actualizarCantidadSurtidaRequisicionDetalles" access="public" returntype="any">
        <cfargument name="id_Empresa"                    type="string"  required="false">
        <cfargument name="id_Requisicion"                type="string"  required="false"/>
        <cfargument name="id_RequisicionDetalle"         type="string"  required="false"/>
        <cfargument name="nu_Cantidad"                   type="string"  required="false"/>
        <cfargument name="id_Insumo"                     type="string"  required="false"/>
        <cfargument name="id_GrupoCentroCosto"           type="string"  required="false"/>
        <cfargument name="id_CentroCosto"                type="string"  required="false"/>

        <cfstoredproc procedure="upU_RequisicionesDetalleCantidadSurtida"  datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"             null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"         null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle"  value="#arguments.id_RequisicionDetalle#"  null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@nu_Cantidad"            value="#arguments.nu_Cantidad#"            null="#iif(isNumeric(arguments.nu_Cantidad),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"              value="#arguments.id_Insumo#"              null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"    value="#arguments.id_GrupoCentroCosto#"    null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"         value="#arguments.id_CentroCosto#"         null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="guardarCambiosHistorial" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="string" required="false">
        <cfargument name="id_SucursalCentroCosto"    type="string" required="false">
        <cfargument name="id_Requisicion"            type="string" required="false"/>
        <cfargument name="id_RequisicionDetalle"     type="string" required="false"/>
        <cfargument name="id_Insumo"                 type="string" required="false"/>
        <cfargument name="im_PrecioUnitario"         type="string" required="false"/>
        <cfargument name="id_Moneda"                 type="string" required="false"/>
        <cfargument name="im_TipoCambio"             type="string" required="false"/>
        <cfargument name="id_CentroCosto"            type="string" required="false"/>
        <cfargument name="id_GrupoCentroCosto"       type="string" required="false"/>
        <cfargument name="nu_Cantidad"               type="string" required="false"/>
        <cfargument name="nu_Kilometraje"            type="string" required="false"/>
        <cfargument name="de_Colaborador"            type="string" required="false"/>
        <cfargument name="sn_ShowComments"           type="string" required="false"/>
        <cfargument name="sn_NewItem"                type="string" required="false"/>
        <cfargument name="de_ComentariosMovimientos" type="string" required="false"/>

        <cfstoredproc procedure="upC_RequisicionesDetalle_HistorialCambiosAutorizador" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                value="#arguments.id_Empresa#"                null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalCentroCosto"    value="#arguments.id_SucursalCentroCosto#"    null="#iif(isNumeric(arguments.id_SucursalCentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"            value="#arguments.id_Requisicion#"            null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle"     value="#arguments.id_RequisicionDetalle#"     null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@id_Insumo"                 value="#arguments.id_Insumo#"                 null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_PrecioUnitario"         value="#arguments.im_PrecioUnitario#"         null="#iif(isNumeric(arguments.im_PrecioUnitario),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@id_Moneda"                 value="#arguments.id_Moneda#"                 null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_TipoCambio"             value="#arguments.im_TipoCambio#"             null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"            value="#arguments.id_CentroCosto#"            null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"       value="#arguments.id_GrupoCentroCosto#"       null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Cantidad"               value="#arguments.nu_Cantidad#"               null="#iif(isNumeric(arguments.nu_Cantidad),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Kilometraje"            value="#arguments.nu_Kilometraje#"            null="#iif(isNumeric(arguments.nu_Kilometraje),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@de_Colaborador"            value="#arguments.de_Colaborador#"            null="#iif(isNumeric(arguments.de_Colaborador),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_ShowComments"           value="#arguments.sn_ShowComments#"           null="#iif(isNumeric(arguments.sn_ShowComments),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_NewItem"                value="#arguments.sn_NewItem#"                null="#iif(isNumeric(arguments.sn_NewItem),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"                value="#session.ID_USUARIO#"                  null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ComentariosMovimientos" value="#arguments.de_ComentariosMovimientos#" null="#iif(len(arguments.de_ComentariosMovimientos),false,true)#">
        </cfstoredproc>
    </cffunction>

</cfcomponent>