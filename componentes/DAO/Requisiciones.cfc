<cfcomponent extends="wiz/Requisiciones">

    <cffunction name="Agregar" access="public" returntype="any">
      <cfargument name="id_Empresa"                type="numeric" required="true">
      <cfargument name="id_TipoRequisicion"        type="numeric" required="true">
      <cfargument name="id_tipoDivision"           type="string"  required="true">
      <cfargument name="id_UsuarioSolicita"        type="numeric" required="true">
      <cfargument name="id_Departamento"           type="numeric" required="true">
      <cfargument name="id_SucursalSolicita"       type="numeric" required="true">
      <cfargument name="id_ClasificadoRequisicion" type="numeric" required="true">
      <cfargument name="fh_Expedicion"             type="string"  required="false">
      <cfargument name="im_PrecioTotal"            type="string"  required="false">
      <cfargument name="id_Proveedor"              type="numeric" required="false">
      <cfargument name="de_Observaciones"          type="string"  required="false">
      <cfargument name="id_EstatusAutorizacion"    type="numeric" required="true">
      <cfargument name="id_EstatusSurtido"         type="numeric" required="true">
      <cfargument name="nu_Viaje"                  type="string"  required="false">
      <cfargument name="nu_siniestro"              type="string"  required="false">
      <cfargument name="ar_soporte"                type="string"  required="false">
      <cfargument name="de_Requisicion"            type="string"  required="false">
      <cfargument name="id_ReporteFalla"           type="string"  required="false">
      <cfargument name="sn_OrdenTrabajo"           type="string"  required="false">
      <cfargument name="id_TipoInstalacion"        type="string"  required="false">
      <cfargument name="id_GrupoCentroCosto"       type="string" required="no">
      <cfargument name="id_CentroCosto"            type="string" required="no">
      <cfargument name="id_PersMantenimiento"      type="string" required="no">
      <cfargument name="nu_kilometraje"            type="string" required="no">

      <cfstoredproc procedure="upC_requisiciones" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                value="#arguments.id_Empresa#"                null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoRequisicion"        value="#arguments.id_TipoRequisicion#"        null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioSolicita"        value="#arguments.id_UsuarioSolicita#"        null="#iif(isNumeric(arguments.id_UsuarioSolicita),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"           value="#arguments.id_Departamento#"           null="#iif(isNumeric(arguments.id_Departamento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalSolicita"       value="#arguments.id_SucursalSolicita#"       null="#iif(isNumeric(arguments.id_SucursalSolicita),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ClasificadoRequisicion" value="#arguments.id_ClasificadoRequisicion#" null="#iif(isNumeric(arguments.id_ClasificadoRequisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Expedicion"             value="#arguments.fh_Expedicion#"             null="#iif(len(arguments.fh_Expedicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_PrecioTotal"            value="#arguments.im_PrecioTotal#"            null="#iif(isNumeric(arguments.im_PrecioTotal),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"              value="#arguments.id_Proveedor#"              null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Observaciones"          value="#arguments.de_Observaciones#"          null="#iif(len(arguments.de_Observaciones),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion"    value="#arguments.id_EstatusAutorizacion#"    null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"         value="#arguments.id_EstatusSurtido#"         null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoDivision"           value="#arguments.id_tipoDivision#"           null="#iif(isNumeric(arguments.id_tipoDivision),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_Viaje"                  value="#arguments.nu_Viaje#"                  null="#iif(len(arguments.nu_Viaje),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_Siniestro"              value="#arguments.nu_Siniestro#"              null="#iif(len(arguments.nu_Siniestro),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_Soporte"                value="#arguments.ar_Soporte#"                null="#iif(len(arguments.ar_soporte),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Requisicion"            value="#arguments.de_Requisicion#"            null="#iif(len(arguments.de_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ReporteFalla"           value="#arguments.id_ReporteFalla#"           null="#iif(isNumeric(arguments.id_ReporteFalla),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_OrdenTrabajo"           value="#arguments.sn_OrdenTrabajo#"           null="#iif(isNumeric(arguments.sn_OrdenTrabajo),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoInstalacion"        value="#arguments.id_TipoInstalacion#"        null="#iif(isNumeric(arguments.id_TipoInstalacion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"       value="#arguments.id_GrupoCentroCosto#"       null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"            value="#arguments.id_CentroCosto#"            null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PersMantenimiento"      value="#arguments.id_PersMantenimiento#"      null="#iif(isNumeric(arguments.id_PersMantenimiento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nu_kilometraje"            value="#arguments.nu_kilometraje#"            null="#iif(isNumeric(arguments.nu_kilometraje),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

      <cfreturn local.rs.id_requisicion>
    </cffunction>

    <cffunction name="listado" access="public" returntype="query">
        <cfargument name="id_Empresa"      type="string" required="true">
        <cfargument name="id_requisicion"  type="string" required="false">
        <cfargument name="fh_inicio"       type="string" required="false">
        <cfargument name="fh_fin"          type="string" required="false">
        <cfargument name="id_estatus"      type="string" required="false">
        <cfargument name="id_usuario"      type="string" required="false">
        <cfargument name="id_Sucursal"     type="string" required="false">
        <cfargument name="id_insumo"       type="string" required="false">
        <cfargument name="id_centrocosto"  type="string" required="false">
        <cfargument name="nu_Siniestro"    type="string" required="false">
        <cfargument name="nb_NombreInsumo" type="string" required="false">
        <cfargument name="de_Requisicion"  type="string" required="false">

    <cfstoredproc procedure="upL_RequisicionesListado" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"      value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion"  value="#arguments.id_requisicion#"  null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"       value="#arguments.fh_inicio#"       null="#iif(len(arguments.fh_inicio),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"          value="#arguments.fh_fin#"          null="#iif(len(arguments.fh_fin),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_estatus"      value="#arguments.id_estatus#"      null="#iif(isNumeric(arguments.id_estatus),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_usuario"      value="#arguments.id_usuario#"      null="#iif(isNumeric(arguments.id_usuario),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"     value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_NombreInsumo" value="#arguments.nb_NombreInsumo#" null="#iif(len(arguments.nb_NombreInsumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_centrocosto"  value="#arguments.id_centrocosto#"  null="#iif(isNumeric(arguments.id_centrocosto),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_Siniestro"    value="#arguments.nu_Siniestro#"    null="#iif(len(arguments.nu_Siniestro),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Requisicion"  value="#arguments.de_Requisicion#"  null="#iif(len(arguments.de_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>


        <cfreturn Local.rs/>
    </cffunction>

    <!--- Victor Sanchez
        Date:22/09/2015
        Te devuelte si una requisicion tiene insumos de tipo transporte --->
    <cffunction name="upR_RequisicionTipoTransporte" access="public" returntype="query">
        <cfargument name='id_empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='false'>

    <cfstoredproc procedure="upR_RequisicionTipoTransporte" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_requisicion"    value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="obtener_requisicion" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
    <cfargument name='id_Requisicion' type='numeric' required='true'>

    <cfstoredproc procedure="upR_Requisiciones" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_requisicion"    value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="obtener_requisicion2" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
    <cfargument name='id_Requisicion' type='numeric' required='true'>

    <cfstoredproc procedure="upR_Requisiciones2" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_requisicion"    value="#arguments.id_requisicion#" null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listadoRequisicionesFiltro" access="public" returntype="query">
        <cfargument name='id_Empresa'      type='numeric' required='true'>
        <cfargument name='id_Sucursal'     type='numeric' required='true'>
        <cfargument name='nb_Empleado'     type='string' required='false'>
        <cfargument name='nb_Sucursal'     type='string' required='false'>
        <cfargument name='fecha'           type='string' required='false'>

      <!---<cfquery name="Local.rs" datasource="#variables.cnx#" >
        exec upL_RequisicionesDatosFiltrado
            #arguments.id_Empresa#,
            #arguments.id_Sucursal#,
        <cfif isDefined("Arguments.nb_Empleado") and arguments.nb_Empleado NEQ ''>'#Arguments.nb_Empleado#'<cfelse>NULL</cfif>,
        <cfif isDefined("Arguments.nb_Sucursal") and arguments.nb_Sucursal NEQ ''>'#Arguments.nb_Sucursal#'<cfelse>NULL</cfif>,
        <cfif isDefined("Arguments.fecha") and arguments.fecha NEQ ''>'#Arguments.fecha#'<cfelse>NULL</cfif>
      </cfquery>--->

      <cfstoredproc procedure="upL_RequisicionesDatosFiltrado" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#" null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Empleado"    value="#arguments.nb_Empleado#" null="#iif(len(arguments.nb_Empleado),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Sucursal"    value="#arguments.nb_Sucursal#" null="#iif(len(arguments.nb_Empleado),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fecha"          value="#arguments.fecha#"       null="#iif(len(arguments.fecha),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="listarparaRegistroSalidaAlmacen" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
        <cfargument name='id_Requisicion' type='numeric' required='true'>
        <cfargument name='id_Sucursal'     type='numeric' required='true'>

    <cfstoredproc procedure="upL_RequisicionesparaRegistroSalidaAlmacen" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que solo devulve la informacion de la sucursal y del empledo que solicito la reuquisicion
            12/10/2015--->
    <cffunction name="getdatarequisicion" access="public" returntype="query">
        <cfargument name='id_Requisicion' type='numeric' required='true'>
        <cfargument name='id_Sucursal'     type='numeric' required='true'>
        <cfargument name='id_Empresa'     type='numeric' required='true'>

    <cfstoredproc procedure="upR_Requisicionesgetdatadocumentoimprimir" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="updateEstatusAutorizacion" access="public" returntype="void">
        <cfargument name="id_Empresa"             type="numeric" required="true">
        <cfargument name="id_Requisicion"         type="numeric" required="true">
        <cfargument name="id_EstatusAutorizacion" type="numeric" required="true">

      <cfstoredproc procedure="upU_requisicionesAutorizacion" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion" value="#arguments.id_EstatusAutorizacion#"  null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
      </cfstoredproc>

    </cffunction>

    <cffunction name="getById" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='true'>

      <cfstoredproc procedure="upR_RequisicionesById" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion" value="#arguments.id_requisicion#"  null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="Editar" access="public" returntype="void">
      <cfargument name="id_Empresa"                type="numeric" required="true">
      <cfargument name="id_Requisicion"            type="numeric" required="true">
      <cfargument name="id_TipoRequisicion"        type="numeric" required="true">
      <cfargument name="id_TipoDivision"           type="numeric" required="true">
      <cfargument name="id_UsuarioSolicita"        type="numeric" required="true">
      <cfargument name="id_Departamento"           type="numeric" required="true">
      <cfargument name="id_SucursalSolicita"       type="numeric" required="true">
      <cfargument name="id_ClasificadoRequisicion" type="numeric" required="true">
      <cfargument name="fh_Expedicion"             type="string"  required="false">
      <cfargument name="im_PrecioTotal"            type="string"  required="false">
      <cfargument name="id_Proveedor"              type="numeric" required="false">
      <cfargument name="de_Observaciones"          type="string"  required="false">
      <cfargument name="id_EstatusAutorizacion"    type="numeric" required="true">
      <cfargument name="id_EstatusSurtido"         type="numeric" required="true">
      <cfargument name="nu_Viaje"                  type="string"  required="false">
      <cfargument name="nu_siniestro"              type="string"  required="false" default="">
      <cfargument name="ar_soporte"                type="string"  required="false" default="">
      <cfargument name="de_Requisicion"            type="string"  required="false">
      <cfargument name="id_ReporteFalla"           type="string"  required="false">
      <cfargument name="id_TipoInstalacion"        type="string" required="no">
      <cfargument name="id_GrupoCentroCosto"       type="string" required="no">
      <cfargument name="id_CentroCosto"            type="string" required="no">
      <cfargument name="id_PersMantenimiento"      type="string" required="no">
      <cfargument name="nu_kilometraje"            type="string" required="no">

      <cfstoredproc procedure="upU_requisiciones" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                value="#arguments.id_Empresa#"                null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"            value="#arguments.id_Requisicion#"            null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoRequisicion"        value="#arguments.id_TipoRequisicion#"        null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioSolicita"        value="#arguments.id_UsuarioSolicita#"        null="#iif(isNumeric(arguments.id_UsuarioSolicita),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"           value="#arguments.id_Departamento#"           null="#iif(isNumeric(arguments.id_Departamento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalSolicita"       value="#arguments.id_SucursalSolicita#"       null="#iif(isNumeric(arguments.id_SucursalSolicita),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ClasificadoRequisicion" value="#arguments.id_ClasificadoRequisicion#" null="#iif(isNumeric(arguments.id_ClasificadoRequisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Expedicion"             value="#arguments.fh_Expedicion#"             null="#iif(isNumeric(arguments.fh_Expedicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_PrecioTotal"            value="#arguments.im_PrecioTotal#"            null="#iif(isNumeric(arguments.im_PrecioTotal),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"              value="#arguments.id_Proveedor#"              null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Observaciones"          value="#arguments.de_Observaciones#"          null="#iif(len(arguments.de_Observaciones),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion"    value="#arguments.id_EstatusAutorizacion#"    null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"         value="#arguments.id_EstatusSurtido#"         null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoDivision"           value="#arguments.id_TipoDivision#"           null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nu_Viaje"                  value="#arguments.nu_Viaje#"                  null="#iif(isNumeric(arguments.nu_Viaje),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_siniestro"              value="#arguments.nu_siniestro#"              null="#iif(len(arguments.nu_siniestro),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_soporte"                value="#arguments.ar_soporte#"                null="#iif(len(arguments.ar_soporte),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Requisicion"            value="#arguments.de_Requisicion#"            null="#iif(len(arguments.de_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ReporteFalla"           value="#arguments.id_ReporteFalla#"           null="#iif(isNumeric(arguments.id_ReporteFalla),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoInstalacion"        value="#arguments.id_TipoInstalacion#"        null="#iif(isNumeric(arguments.id_TipoInstalacion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"       value="#arguments.id_GrupoCentroCosto#"       null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"            value="#arguments.id_CentroCosto#"            null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PersMantenimiento"      value="#arguments.id_PersMantenimiento#"      null="#iif(isNumeric(arguments.id_PersMantenimiento),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nu_kilometraje"            value="#arguments.nu_kilometraje#"            null="#iif(isNumeric(arguments.nu_kilometraje),false,true)#">
      </cfstoredproc>

    </cffunction>

    <cffunction name="getFechaRegistro" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='string' required='true'>
        <cfargument name='id_requisicion' type='string' required='true'>

    <cfstoredproc procedure="upR_RequisicionesFechaRegistro" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion" value="#arguments.id_requisicion#"  null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="snEmpleadoRequisicionesAutorizar" access="public" returntype="boolean">
        <cfargument name='id_Empresa'  type='string' required='true'>
        <cfargument name='id_Empleado' type='string' required='true'>
        <cfargument name='id_Departamento' type='string' required='true'>

    <cfstoredproc procedure="upR_RequisicionesAutorizarByEmpleado" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"      value="#arguments.id_Empleado#"  null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"  value="#arguments.id_Departamento#"  null="#iif(isNumeric(arguments.id_Departamento),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs.sn_tieneAutorizar/>
    </cffunction>

    <cffunction name="getRequisicionAutorizarByEmpleado" access="public" returntype="query">
        <cfargument name='id_Empresa'  type='string' required='true'>
        <cfargument name='id_Empleado' type='string' required='true'>
        <cfargument name='id_Departamento' type='string' required='true'>

    <cfstoredproc procedure="upL_RequisicionesAutorizarByEmpleado" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"      value="#arguments.id_Empleado#"  null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"  value="#arguments.id_Departamento#"  null="#iif(isNumeric(arguments.id_Departamento),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Victor Sanchez
        27/10/2015
        lista el detalle de una requisicion para Entrada por devolucion de salida --->
    <cffunction name="upL_RequisicionesDetalleEntradaDevolucionSalida" access="public" returntype="query">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
        <cfargument name='id_Requisicion' type='numeric' required='true'>

      <cfstoredproc procedure="upL_RequisicionesDetalleEntradaDevolucionSalida" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="seguimientoRequisicion" access="public" returntype="query">
        <cfargument name='id_Empresa'       type='string' required='yes'>
        <cfargument name='id_Requisicion'   type='string' required='yes'>

    <cfstoredproc procedure="upR_RequisicionesSeguimiento" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="seguimientoSolicitudCompra" access="public" returntype="query">
        <cfargument name='id_Empresa'       type='string' required='yes'>
    <cfargument name='id_Requisicion'   type='string' required='yes'>

      <cfstoredproc procedure="upR_RSolicitudCompraSeguimiento" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Adrian Garcia --->
    <cffunction name="SolicitudCompraPorStock" access="public" returntype="query">
      <cfargument name='id_empresa'           type='string'   required='yes'>
      <cfargument name='id_solicitudcompra'   type='string'   required='yes'>

      <cfstoredproc procedure="upR_RSolicitudCompraSeguimiento" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_solicitudcompra" value="#arguments.id_solicitudcompra#"  null="#iif(isNumeric(arguments.id_solicitudcompra),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

      <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="seguimientoRequisicionCMF" access="public" returntype="query">
      <cfargument name='id_Empresa'       type='string' required='yes'>
      <cfargument name='id_Requisicion'   type='string' required='yes'>

      <cfstoredproc procedure="upR_RequisicionesCMFSeguimiento" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionCMF"  value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">

        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>

      <cfreturn Local.rs/>
    </cffunction>


    <!--- Jesus Reyes --->
    <cffunction name="TiposRequisicionesDivisionesCombo" access="public" returntype="query">
        <cfargument name='id_TipoRequisicion' type='string' required='false' default="">
        <cfargument name='id_TipoDivision'    type='string' required='false' default="">
        <cfargument name='sn_activo'          type='string' required='false' default="">
        <cfargument name='id_Empresa'         type='string' required='false' default="">

            <cfstoredproc procedure="upL_TiposRequisicionesDivisionesDetalle" datasource="#variables.cnx#" >
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoRequisicion" value="#arguments.id_TipoRequisicion#" null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoDivision"    value="#arguments.id_TipoDivision#"    null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_activo"          value="#arguments.sn_activo#"          null="#iif(isBoolean(arguments.sn_activo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>


    <!--- Jesus Reyes --->
    <cffunction name="RequisicionesUsuarioAutoriza" access="public" returntype="query">
        <cfargument name='id_Empresa'         type='string' required='false' default="">
        <cfargument name='id_Sucursal'        type='string' required='false' default="">
        <cfargument name='id_TipoDivision'    type='string' required='false' default="">
        <cfargument name='id_EmpresaEmpleado' type='string' required='false' default="">
        <cfargument name='id_Empleado'        type='string' required='false' default="">

            <cfstoredproc procedure="upR_RequisicionesUsuarioAutoriza" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"        null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoDivision"    value="#arguments.id_TipoDivision#"    null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado" value="#arguments.id_EmpresaEmpleado#" null="#iif(isNumeric(arguments.id_EmpresaEmpleado),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"        value="#arguments.id_Empleado#"        null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Jose Ibarra --->
    <cffunction name="RequisicionesEviarCorreo" access="public" returntype="query">

        <cfargument name='id_Empresa'         type='string' required='false' default="">
        <cfargument name='id_Sucursal'        type='string' required='false' default="">
        <cfargument name='id_tipoDivision'    type='string' required='false' default="">
        <cfargument name='id_Empleado'        type='string' required='false' default="">

            <cfstoredproc procedure="upR_RequisicionesEviarCorreo" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"        null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoDivision"    value="#arguments.id_tipoDivision#"    null="#iif(isNumeric(arguments.id_tipoDivision),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"        value="#arguments.id_Empleado#"        null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="FinalizarRequisicion" access="public" returntype="struct">
        <cfargument name="id_Empresa"             type="numeric" required="true">
        <cfargument name="id_Requisicion"         type="numeric" required="true">
        <cfargument name="id_EstatusAutorizacion" type="numeric" required="true">
        <cfargument name="de_ComentariosFinaliza" type="string"  required="false" default="">
        <cfargument name="sn_OrdenDeTrabajo"      type="string"  required="false" default="">

      <cfstoredproc procedure="upU_requisicionesAutorizacionFinaliza" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"             null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"         null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion" value="#arguments.id_EstatusAutorizacion#" null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"             value="#session.ID_USUARIO#"               null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ComentariosFinaliza" value="#arguments.de_ComentariosFinaliza#" null="#iif(len(arguments.de_ComentariosFinaliza),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_OrdenDeTrabajo"      value="#arguments.sn_OrdenDeTrabajo#"      null="#iif(isNumeric(arguments.sn_OrdenDeTrabajo),false,true)#">
        <cfprocresult name="Local.rs.OrdenesCompra" resultset="1">
        <cfprocresult name="Local.rs.Autorizadores" resultset="2">
      </cfstoredproc>

      <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarInsumosAyuda" access="public" returntype="query">
      <cfargument name="id_Insumo"           type="string"  required="false">
      <cfargument name="nb_Nombre"           type="string"  required="false">
      <cfargument name="id_FamiliaInsumo"    type="string"  required="false">
      <cfargument name="id_SubFamiliaInsumo" type="string"  required="false">
      <cfargument name="id_Empresa"          type="numeric" required="false">
      <cfargument name="id_Sucursal"         type="numeric" required="false">
      <cfargument name="id_tipoSolicitud"    type="numeric" required="false">
      <cfargument name="id_Usuario"          type="string"  required="false">
      <cfargument name="id_Puesto"           type="string"  required="false">

    <cfstoredproc procedure="upL_insumoslistadosayudarequisicion" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"           value="#arguments.id_Insumo#"           null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Nombre"           value="#arguments.nb_Nombre#"           null="#iif(len(arguments.nb_Nombre),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"    value="#arguments.id_FamiliaInsumo#"    null="#iif(isNumeric(arguments.id_FamiliaInsumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"         value="#arguments.id_Sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoSolicitud"    value="#arguments.id_tipoSolicitud#"    null="#iif(isNumeric(arguments.id_tipoSolicitud),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"          value="#arguments.id_Usuario#"          null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Puesto"           value="#arguments.id_Puesto#"           null="#iif(isNumeric(arguments.id_Puesto),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="GuardarCMF" access="public" returntype="query">
    <cfargument name="id_Empresa"         type="numeric" required="false">
    <cfargument name="id_Sucursal"        type="numeric" required="false">
    <cfargument name="id_Proveedor"       type="numeric" required="false">
    <cfargument name="id_Concepto"        type="numeric" required="false">
    <cfargument name="im_SubTotal"        type="numeric" required="false">
    <cfargument name="im_Descuento"       type="string"  required="false">
    <cfargument name="im_Total"           type="numeric" required="false">
    <cfargument name="id_Estatus"         type="numeric" required="false">
    <cfargument name="fh_Entrega"         type="string"  required="false">
    <cfargument name="id_Usuario"         type="numeric" required="false">
    <cfargument name="de_RutaXml"         type="string"  required="false">
    <cfargument name="nb_ArchivoXml"      type="string"  required="false">
    <cfargument name="de_Xml"             type="string"  required="false">
    <cfargument name="de_Folio"           type="string"  required="false">
    <cfargument name="de_RutaPdf"         type="string"  required="false">
    <cfargument name="nb_ArchivoPdf"      type="string"  required="false">
    <cfargument name="de_Serie"           type="string"  required="false">
    <cfargument name="de_FormaPago"       type="string"  required="false">
    <cfargument name="de_TipoComprobante" type="string"  required="false">
    <cfargument name="de_MetodoPago"      type="string"  required="false">
    <cfargument name="de_LugarExpedicion" type="string"  required="false">
    <cfargument name="de_tipoFactor"      type="string"  required="false">
    <cfargument name="id_TipoComprobante" type="string"  required="false">
    <cfargument name="de_ComentariosOC"   type="string"  required="false">

    <cfstoredproc procedure="upC_Requisiciones_CargaMasivaAgregar" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"           null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"       value="#arguments.id_Proveedor#"          null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Concepto"        value="#arguments.id_Concepto#"           null="#iif(isNumeric(arguments.id_Concepto),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_SubTotal"        value="#arguments.im_SubTotal#"           null="#iif(isNumeric(arguments.im_SubTotal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Descuento"       value="#arguments.im_Descuento#"          null="#iif(isNumeric(arguments.im_Descuento),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Total"           value="#arguments.im_Total#"              null="#iif(isNumeric(arguments.im_Total),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"         value="#arguments.id_Estatus#"            null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Entrega"         value="#arguments.fh_Entrega#"            null="#iif(len(arguments.fh_Entrega),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"         value="#arguments.id_Usuario#"            null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RutaXml"         value="#arguments.de_RutaXml#"            null="#iif(Len(arguments.de_RutaXml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ArchivoXml"      value="#arguments.nb_ArchivoXml#"         null="#iif(Len(arguments.nb_ArchivoXml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Xml"             value="#arguments.de_Xml#"                null="#iif(Len(arguments.de_Xml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Folio"           value="#arguments.de_Folio#"              null="#iif(Len(arguments.de_Folio),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RutaPdf"         value="#arguments.de_RutaPdf#"            null="#iif(Len(arguments.de_RutaPdf),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ArchivoPdf"      value="#arguments.nb_ArchivoPdf#"         null="#iif(Len(arguments.nb_ArchivoPdf),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Serie"           value="#arguments.de_Serie#"              null="#iif(Len(arguments.de_Serie),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_FormaPago"       value="#arguments.de_FormaPago#"          null="#iif(Len(arguments.de_FormaPago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_TipoComprobante" value="#arguments.de_TipoComprobante#"    null="#iif(Len(arguments.de_TipoComprobante),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_MetodoPago"      value="#arguments.de_MetodoPago#"         null="#iif(Len(arguments.de_MetodoPago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_LugarExpedicion" value="#arguments.de_LugarExpedicion#"    null="#iif(Len(arguments.de_LugarExpedicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_tipoFactor"      value="#arguments.de_tipoFactor#"         null="#iif(Len(arguments.de_tipoFactor),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoComprobante" value="#arguments.id_TipoComprobante#"    null="#iif(Len(arguments.id_TipoComprobante),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ComentariosOC"   value="#arguments.de_ComentariosOC#"      null="#iif(Len(arguments.de_ComentariosOC),false,true)#">

      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="GuardarDetalleCMF" access="public" returntype="void">
    <cfargument name="id_Empresa"         type="numeric" required="false">
    <cfargument name="id_Requisicion"     type="numeric" required="false">
    <cfargument name="id_Insumo"          type="numeric" required="false">
    <cfargument name="de_descripcion"     type="string"  required="false">
    <cfargument name="nu_cantidad"        type="numeric" required="false">
    <cfargument name="im_preciounitario"  type="numeric" required="false">
    <cfargument name="im_Subtotal"        type="numeric" required="false">
    <cfargument name="im_Descuento"       type="string"  required="false">
    <cfargument name="nb_moneda"          type="string"  required="false">
    <cfargument name="im_Retencion"       type="numeric" required="false">
    <cfargument name="id_centrocosto"     type="string"  required="false">
    <cfargument name="nd_Detalle"         type="string"  required="false">

    <cfstoredproc procedure="upC_RequisicionesDetalle_CargaMasivaAgregar" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"     value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"          value="#arguments.id_Insumo#"         null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_descripcion"     value="#arguments.de_descripcion#"    null="#iif(len(arguments.de_descripcion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_cantidad"        value="#arguments.nu_cantidad#"       null="#iif(isNumeric(arguments.nu_cantidad),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_preciounitario"  value="#arguments.im_preciounitario#" null="#iif(isNumeric(arguments.im_preciounitario),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Subtotal"        value="#arguments.im_Subtotal#"       null="#iif(isNumeric(arguments.im_Subtotal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Descuento"       value="#arguments.im_Descuento#"      null="#iif(isNumeric(arguments.im_Descuento),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_moneda"          value="#arguments.nb_moneda#"         null="#iif(len(arguments.nb_moneda),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Retencion"       value="#arguments.im_Retencion#"      null="#iif(isNumeric(arguments.im_Retencion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_centrocosto"     value="#arguments.id_centrocosto#"    null="#iif(isNumeric(arguments.id_centrocosto),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_Detalle"         value="#arguments.nd_Detalle#"        null="#iif(isNumeric(arguments.nd_Detalle),false,true)#">
    </cfstoredproc>

  </cffunction>

  <cffunction name="updateRoutes" access="public" returntype="void">
    <cfargument name='id_Empresa'      type='string'  required='false'>
    <cfargument name='id_Requisicion'  type='string'  required='false'>
    <cfargument name='nb_archivoXml'   type='string'  required='false'>
    <cfargument name='de_rutaXml'      type='string'  required='false'>
    <cfargument name='nb_archivoPdf'   type='string'  required='false'>
    <cfargument name='de_rutaPdf'      type='string'  required='false'>

        <cfstoredproc procedure="upU_Requisiciones_CargaMasivaXML" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"   value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_archivoXml"    value="#arguments.nb_archivoXml#"   null="#iif(len(arguments.nb_archivoXml),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_rutaXml"       value="#arguments.de_rutaXml#"      null="#iif(len(arguments.de_rutaXml),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_archivoPdf"    value="#arguments.nb_archivoPdf#"   null="#iif(len(arguments.nb_archivoPdf),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_rutaPdf"       value="#arguments.de_rutaPdf#"      null="#iif(len(arguments.de_rutaPdf),false,true)#">
          </cfstoredproc>
  </cffunction>

  <cffunction name="GetRequisicionCMFById" access="public" returntype="struct">
    <cfargument name='id_Empresa'      type='numeric' required='false'>
    <cfargument name='id_Requisicion'  type='numeric' required='false'>

    <cfstoredproc procedure="upL_RequisicionCMFById" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"  value="#arguments.id_Requisicion#"   null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs.gral" resultset="1">
      <cfprocresult name="Local.rs.dtls" resultset="2">
      <cfprocresult name="Local.rs.impt" resultset="3">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="EnviarRequisicionCMF" access="public" returntype="void">
    <cfargument name='id_Empresa'      type='numeric' required='false'>
    <cfargument name='id_Requisicion'  type='numeric' required='false'>

    <cfstoredproc procedure="spC_AutorizarSP_GPS" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionCMF"  value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioModifica" value="#session.ID_USUARIO#"          null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
    </cfstoredproc>

  </cffunction>

  <cffunction name="ModificarCMF" access="public" returntype="query">
    <cfargument name='id_Requisicion'       type='numeric' required='true'>
    <cfargument name='id_Empresa'           type='numeric' required='false'>
    <cfargument name='id_Sucursal'          type='numeric' required='false'>
    <cfargument name='id_Proveedor'         type='numeric' required='false'>
    <cfargument name='id_Concepto'          type='numeric' required='false'>
    <cfargument name='im_SubTotal'          type='numeric' required='false'>
    <!--- <cfargument name='im_Iva'             type='numeric' required='false'> --->
    <!--- <cfargument name='im_Retencion'       type='numeric' required='false'> --->
    <cfargument name='im_Total'             type='numeric' required='false'>
    <cfargument name='id_Estatus'           type='numeric' required='false'>
    <cfargument name='fh_Entrega'           type='string'  required='false'>
    <cfargument name='id_Usuario'           type='numeric' required='false'>
    <cfargument name='de_RutaXml'           type='string'  required='false'>
    <cfargument name='nb_ArchivoXml'        type='string'  required='false'>
    <cfargument name='de_Xml'               type='string'  required='false'>
    <cfargument name='de_Folio'             type='string'  required='false'>
    <cfargument name='de_RutaPdf'           type='string'  required='false'>
    <cfargument name='nb_ArchivoPdf'        type='string'  required='false'>
    <cfargument name='de_Serie'             type='string'  required='false'>
    <cfargument name='de_FormaPago'         type='string'  required='false'>
    <cfargument name='de_TipoComprobante'   type='string'  required='false'>
    <cfargument name='de_MetodoPago'        type='string'  required='false'>
    <cfargument name='de_LugarExpedicion'   type='string'  required='false'>
    <cfargument name='de_tipoFactor'        type='string'  required='false'>
    <cfargument name='id_TipoComprobante'   type='string'  required='false'>
    <cfargument name='de_ComentariosOC'     type='string'  required='false'>

    <cfstoredproc procedure="upU_Requisiciones_CargaMasivaModificar" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"       value="#arguments.id_Requisicion#"        null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"          value="#arguments.id_Sucursal#"           null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"         value="#arguments.id_Proveedor#"          null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Concepto"          value="#arguments.id_Concepto#"           null="#iif(isNumeric(arguments.id_Concepto),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC"   dbvarname="@im_SubTotal"          value="#arguments.im_SubTotal#"           null="#iif(isNumeric(arguments.im_SubTotal),false,true)#">
      <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@im_Iva"             value="#arguments.im_Iva#"                null="#iif(isNumeric(arguments.im_Iva),false,true)#"> --->
      <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@im_Retencion"       value="#arguments.im_Retencion#"          null="#iif(isNumeric(arguments.im_Retencion),false,true)#"> --->
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC"   dbvarname="@im_Total"             value="#arguments.im_Total#"              null="#iif(isNumeric(arguments.im_Total),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"           value="#arguments.id_Estatus#"            null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Entrega"           value="#arguments.fh_Entrega#"            null="#iif(len(arguments.fh_Entrega),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"           value="#arguments.id_Usuario#"            null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RutaXml"           value="#arguments.de_RutaXml#"            null="#iif(Len(arguments.de_RutaXml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ArchivoXml"        value="#arguments.nb_ArchivoXml#"         null="#iif(Len(arguments.nb_ArchivoXml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Xml"               value="#arguments.de_Xml#"                null="#iif(Len(arguments.de_Xml),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Folio"             value="#arguments.de_Folio#"              null="#iif(Len(arguments.de_Folio),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RutaPdf"           value="#arguments.de_RutaPdf#"            null="#iif(Len(arguments.de_RutaPdf),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ArchivoPdf"        value="#arguments.nb_ArchivoPdf#"         null="#iif(Len(arguments.nb_ArchivoPdf),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Serie"             value="#arguments.de_Serie#"              null="#iif(Len(arguments.de_Serie),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_FormaPago"         value="#arguments.de_FormaPago#"          null="#iif(Len(arguments.de_FormaPago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_TipoComprobante"   value="#arguments.de_TipoComprobante#"    null="#iif(Len(arguments.de_TipoComprobante),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_MetodoPago"        value="#arguments.de_MetodoPago#"         null="#iif(Len(arguments.de_MetodoPago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_LugarExpedicion"   value="#arguments.de_LugarExpedicion#"    null="#iif(Len(arguments.de_LugarExpedicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_tipoFactor"        value="#arguments.de_tipoFactor#"         null="#iif(Len(arguments.de_tipoFactor),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoComprobante"   value="#arguments.id_TipoComprobante#"    null="#iif(Len(arguments.id_TipoComprobante),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ComentariosOC"     value="#arguments.de_ComentariosOC#"      null="#iif(Len(arguments.de_ComentariosOC),false,true)#">

      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="EliminarDetallesCMF" access="public" returntype="void">
    <cfargument name='id_Empresa'         type='numeric' required='false'>
    <cfargument name='id_Requisicion'     type='numeric' required='false'>

    <cfstoredproc procedure="upD_RequisicionesDetalle_CargaMasivaEliminar" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"     value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
    </cfstoredproc>

  </cffunction>

  <cffunction name="ActualizarEstatusCMF" access="public" returntype="void">
    <cfargument name="id_Empresa"             type="numeric" required="false">
    <cfargument name="id_OrdenCompra"         type="numeric" required="false">
    <cfargument name="id_Factura"             type="numeric" required="false">
    <cfargument name="id_documento"           type="numeric" required="false">
    <cfargument name="id_programacionpago"    type="numeric" required="false">
    <cfargument name="id_programacionpagoDet" type="numeric" required="false">
    <cfargument name="id_Pago"                type="numeric" required="false">
    <cfargument name="id_estatus"             type="numeric" required="false">
    <cfargument name="sn_Provisionada"        type="numeric" required="false">
    <cfargument name="id_Sucursal"            type="numeric" required="false">
    <cfargument name="id_Proveedor"           type="numeric" required="false">
    <cfargument name="cl_tipodocumento"       type="string"  required="false">

    <cfstoredproc procedure="upU_ActualizarEstatusRequisicionCMF" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"             null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"         value="#arguments.id_OrdenCompra#"         null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Factura"             value="#arguments.id_Factura#"             null="#iif(isNumeric(arguments.id_Factura),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_documento"           value="#arguments.id_documento#"           null="#iif(isNumeric(arguments.id_documento),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Programacion"        value="#arguments.id_programacionpago#"    null="#iif(isNumeric(arguments.id_programacionpago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_programacionpagoDet" value="#arguments.id_programacionpagoDet#" null="#iif(isNumeric(arguments.id_programacionpagoDet),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Pago"                value="#arguments.id_Pago#"                null="#iif(isNumeric(arguments.id_Pago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_estatus"             value="#arguments.id_estatus#"             null="#iif(isNumeric(arguments.id_estatus),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Provisionada"        value="#arguments.sn_Provisionada#"        null="#iif(isNumeric(arguments.sn_Provisionada),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"            value="#arguments.id_Sucursal#"            null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"           value="#arguments.id_Proveedor#"           null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_tipodocumento"       value="#arguments.cl_tipodocumento#"       null="#iif(len(arguments.cl_tipodocumento),false,true)#">
    </cfstoredproc>

  </cffunction>

  <cffunction name="EstatusCMF" access="public" returntype="void">
    <cfargument name='id_Empresa'         type='numeric' required='false'>
    <cfargument name='id_RequisicionCMF'  type='numeric' required='false'>
    <cfargument name='id_Estatus'         type='numeric' required='false'>

    <cfstoredproc procedure="upU_Requisiciones_CargaMasiva_Estatus" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionCMF"  value="#arguments.id_RequisicionCMF#"   null="#iif(isNumeric(arguments.id_RequisicionCMF),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"         value="#arguments.id_Estatus#"          null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
    </cfstoredproc>

  </cffunction>

  <cffunction name="SucursalesAccesoEmpleadosCombo_Requisiciones" access="public" returntype="query">
    <cfargument name="id_Empresa"           type="string" required="false" />
    <cfargument name="id_EmpresaEmpleado"   type="string" required="true"/>
    <cfargument name="id_Empleado"          type="string" required="true"/>

    <cfquery datasource="#variables.cnx#" name="Local.tipo">
        exec upL_SucursalesEmpleadosCombo_Requisiciones
                    #arguments.id_EmpresaEmpleado#,
                    #arguments.id_Empleado#,
                    #arguments.id_Empresa#
    </cfquery>
    <cfreturn Local.tipo/>

</cffunction>

  <cffunction name="getHistorialRequisicion" access="public" returntype="query">
    <cfargument name="id_Empresa"     type="string" required="true"/>
    <cfargument name="id_Requisicion" type="string" required="true"/>
    <cfargument name="id_Empleado"    type="string" required="false"/>
    <cfargument name="id_Insumo"      type="string" required="false"/>
    <cfargument name="id_TipoMovimiento"     type="string" required="false"/>

    <cfstoredproc procedure="upL_RequisicionesDetalleHistorialCambios" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"        value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"    value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Empleado"       value="#arguments.id_Empleado#"       null="#iif(len(arguments.id_Empleado),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Insumo"         value="#arguments.id_Insumo#"         null="#iif(len(arguments.id_Insumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoMovimiento" value="#arguments.id_TipoMovimiento#" null="#iif(len(arguments.id_TipoMovimiento),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="getHistorialRequisicion_Filtros" access="public" returntype="struct">
    <cfargument name="id_Empresa"     type="string" required="true"/>
    <cfargument name="id_Requisicion" type="string" required="true"/>

    <cfstoredproc procedure="upL_RequisicionesDetalleHistorialCambios_InformacionFiltros" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs.Empleados" resultset="1">
      <cfprocresult name="Local.rs.Insumos" resultset="2">
      <cfprocresult name="Local.rs.TiposMovimientos" resultset="3">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="listarRequisicionesToCopy" access="public" returntype="query">
    <cfargument name="id_Empresa"         type="string" required="false"/>
    <cfargument name="id_Sucursal"        type="string" required="false"/>
    <cfargument name="id_TipoRequisicion" type="string" required="false"/>
    <cfargument name="id_Division"        type="string" required="false"/>
    <cfargument name="id_Requisicion"     type="string" required="false"/>
    <cfargument name="de_Requisicion"     type="string" required="false"/>
    <cfargument name="fn_Inicio"          type="string" required="false"/>
    <cfargument name="fn_Fin"             type="string" required="false"/>

    <cfstoredproc procedure="upL_RequisicionesParaCopiar" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"        null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoRequisicion" value="#arguments.id_TipoRequisicion#" null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Division"        value="#arguments.id_Division#"        null="#iif(isNumeric(arguments.id_Division),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"     value="#arguments.id_Requisicion#"     null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Requisicion"     value="#arguments.de_Requisicion#"     null="#iif(len(arguments.de_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fn_Inicio"          value="#arguments.fn_Inicio#"          null="#iif(len(arguments.fn_Inicio),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fn_Fin"             value="#arguments.fn_Fin#"             null="#iif(len(arguments.fn_Fin),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"         value="#session.id_Usuario#"           null="#iif(isNumeric(session.id_Usuario),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="GenerarCopiaRequisicion" access="public" returntype="query">
    <cfargument name="id_Empresa"     type="string" required="true"/>
    <cfargument name="id_Requisicion" type="string" required="true"/>

    <cfstoredproc procedure="upC_RequisicionesGenerarCopia" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"     value="#session.id_Usuario#"       null="#iif(isNumeric(session.id_Usuario),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>


  <cffunction name="listarDireccion" access="public" returntype="query">
    <cfargument name="id_Cliente"     type="string" required="true"/>
    <cfargument name='id_Domicilio'       type='string' required='no'>


    <cfstoredproc procedure="upL_DireccionesCombo_Requisiciones" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Cliente"        value="#arguments.id_Cliente#"        null="#iif(isNumeric(arguments.id_Cliente),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Domicilio"        value="#arguments.id_Domicilio#"        null="#iif(isNumeric(arguments.id_Domicilio),false,true)#">

      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

    <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="listarTipoInstalacion" access="public" returntype="query">
            <cfstoredproc procedure="upL_TipoInstalacionCombo_Requisiciones" datasource="#variables.cnx#" >
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn Local.rs/>
  </cffunction>


    <cffunction name="updatePrecioRequisicion" access="public" returntype="void">
        <cfargument name="id_Empresa"             type="numeric" required="true">
        <cfargument name="id_Requisicion"         type="numeric" required="true">
        <cfargument name="im_Total" type="numeric" required="true">

      <cfstoredproc procedure="upU_requisicionPrecio" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"  null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT" dbvarname="@im_Total" value="#arguments.im_Total#"  null="#iif(isNumeric(arguments.im_Total),false,true)#">
      </cfstoredproc>

    </cffunction>


</cfcomponent>
