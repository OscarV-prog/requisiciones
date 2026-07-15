<cfcomponent extends="wiz/sucursales">

    <cffunction name="listar" access="public" returntype="query">
    <cfargument name="id_Empresa"               type="string"  required="false">
    <cfargument name="id_Requisicion"           type="string"  required="false"/>
    <cfargument name="fh_Inicio"                type="string"  required="false"/>
    <cfargument name="fh_Final"                 type="string"  required="false"/>
    <cfargument name="id_EstatusAutorizacion"   type="string"  required="false"/>
    <cfargument name="id_UsuarioAutoriza"       type="string"  required="true"/>
    <cfargument name="id_SucursalSolicita"      type="string"  required="false"/>
    <cfargument name="nu_Siniestro"             type="string"  required='false'/>
    <cfargument name="id_Empleado"              type="string"  required='false'/>
    <cfargument name="de_Requisicion"           type="string"  required="false"/>

    <cfstoredproc procedure="upL_RequisicionAutorizacion" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"          null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Inicio"              value="#arguments.fh_Inicio#"               null="#iif(Len(arguments.fh_Inicio),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Final"               value="#arguments.fh_Final#"                null="#iif(Len(arguments.fh_Final),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EstatusAutorizacion" value="#arguments.id_EstatusAutorizacion#"  null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioAutoriza"     value="#arguments.id_UsuarioAutoriza#"      null="#iif(isNumeric(arguments.id_UsuarioAutoriza),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_SucursalSolicita"    value="#arguments.id_SucursalSolicita#"     null="#iif(isNumeric(arguments.id_SucursalSolicita),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Siniestro"           value="#arguments.nu_Siniestro#"            null="#iif(len(arguments.nu_Siniestro),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empleado"            value="#arguments.id_Empleado#"             null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_Requisicion"         value="#arguments.de_Requisicion#"          null="#iif(Len(arguments.de_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="Editar" access="public" returntype="void">
        <cfargument name="id_Empresa"                            type="numeric" required="true"/>
        <cfargument name="id_Requisicion"                        type="numeric" required="true"/>
        <cfargument name="id_EstatusAutorizacion"                type="numeric" required="true"/>
        <cfargument name="de_Observaciones"                      type="string"  required="false"/>

        <!---<cfquery datasource="#variables.cnx#">
            exec upU_RequisicionesEstatus #arguments.id_Empresa#,
                                          #arguments.id_Requisicion#,
                                          #arguments.id_EstatusAutorizacion#,
                                          <cfif isDefined("arguments.de_Observaciones") AND arguments.de_Observaciones NEQ ''
                                          AND arguments.de_Observaciones NEQ 'null'>'#arguments.de_Observaciones#'<cfelse>NULL</cfif>
    </cfquery>--->

    <cfstoredproc procedure="upU_RequisicionesEstatus" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"          null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EstatusAutorizacion" value="#arguments.id_EstatusAutorizacion#"  null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_Observaciones"       value="#arguments.de_Observaciones#"        null="#iif(len(arguments.de_Observaciones),false,true)#">
    </cfstoredproc>

    </cffunction>

    <cffunction name="EditarStatus" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Requisicion"            type="numeric" required="true"/>
        <cfargument name="id_EstatusAutorizacion"    type="numeric" required="true"/>

        <!---<cfquery datasource="#variables.cnx#">
            exec upU_RequisicionEstatus #arguments.id_Empresa#,
                                          #arguments.id_Requisicion#,
                                          #arguments.id_EstatusAutorizacion#
    </cfquery>--->

    <cfstoredproc procedure="upU_RequisicionEstatus" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"          null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EstatusAutorizacion" value="#arguments.id_EstatusAutorizacion#"  null="#iif(isNumeric(arguments.id_EstatusAutorizacion),false,true)#">
    </cfstoredproc>

    </cffunction>

    <cffunction name="listarStatus" access="public" returntype="query">
        <!---<cfquery name="Local.Estatus" datasource="#variables.cnx#" >
            exec upLC_Estatus
    </cfquery>--->
    <cfstoredproc procedure="upLC_Estatus" datasource="#variables.cnx#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <!---
        Autor: Mario Mejia
        Fecha: 01/06/2015
        Comentario: Funcion que nos devuelve el detalle de una requisición junto con
                    las existencias en almacen de los insumos contenidos en el detalle
     --->
    <cffunction name="getRequisicionDetalleAlmacenExistencia">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="true">

        <!---<cfquery name="Local.RS" datasource="#variables.cnx#" >
            exec upL_requisicionDetalleAlmacenExistencias
                                    #arguments.id_empresa#,
                                    #arguments.id_Requisicion#
    </cfquery>--->

    <cfstoredproc procedure="upL_requisicionDetalleAlmacenExistencias" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"         value="#arguments.id_Requisicion#"          null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="get_ExistenciasAlmacen">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_sucursal" type="string" required="true">
        <cfargument name="id_insumo" type="string" required="true">
        <cfargument name="id_almacen" type="string" required="true">

        <!---<cfquery name="Local.RS" datasource="#variables.cnx#" >
            exec upL_nuExistencias #id_empresa#,
                                    #arguments.id_sucursal#,
                                    #arguments.id_insumo#,
                                    #arguments.id_almacen#
    </cfquery>--->

    <cfstoredproc procedure="upL_nuExistencias" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_sucursal"  value="#arguments.id_sucursal#" null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_insumo"    value="#arguments.id_insumo#"   null="#iif(isNumeric(arguments.id_insumo),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_almacen"   value="#arguments.id_almacen#"  null="#iif(isNumeric(arguments.id_almacen),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Autor: Julio Cesar Acosta Lopez
            Fecha: 26/08/2015
            Comentario: funcion que devuelve el detalle de insumos de una requisición de servicios --->
    <cffunction name="getRequisicionDetalleServicios">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="true">

        <!---*<cfquery name="Local.RS" datasource="#variables.cnx#" >
            exec upL_RequisicionDetalleServicios
                                    #arguments.id_empresa#,
                                    #arguments.id_Requisicion#
    </cfquery>--->.

    <cfstoredproc procedure="upL_RequisicionDetalleServicios" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"  value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="AutorizadaValidarRechazo">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="true">

        <!---<cfquery name="Local.RS" datasource="#variables.cnx#" >
            exec upR_requisicionesValidarRechazo
                                    #arguments.id_empresa#,
                                    #arguments.id_Requisicion#
    </cfquery>--->

    <cfstoredproc procedure="upR_requisicionesValidarRechazo" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"  value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="obtenerUsuarioAutorizaPorNivelRequisiciones" access="public" returntype="any">
        <cfargument name='id_Empresa'         type='string' required='yes'>
        <cfargument name='id_Sucursal'        type='string' required='yes'>
        <cfargument name='id_TipoDivision'    type='string' required='yes'>
        <cfargument name='id_Nivel'           type='string' required='yes'>
        <cfargument name='id_UsuarioAutoriza' type='string' required='no' default=''>

        <!---<cfquery name="Local.RS" datasource="#variables.cnx#" >
            exec upL_obtenerUsuarioAutorizaPorNivelRequisiciones #id_Empresa#,
                                                                 #arguments.id_Sucursal#,
                                                                 #arguments.id_TipoDivision#,
                                                                 #arguments.id_Nivel#,
                                                                 <cfif isDefined("arguments.id_UsuarioAutoriza") AND arguments.id_UsuarioAutoriza NEQ '' >
                                                                 #arguments.id_UsuarioAutoriza#<cfelse>NULL</cfif>
    </cfquery>--->

    <cfstoredproc procedure="upL_obtenerUsuarioAutorizaPorNivelRequisiciones" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoDivision"    value="#arguments.id_TipoDivision#"     null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Nivel"           value="#arguments.id_Nivel#"            null="#iif(isNumeric(arguments.id_Nivel),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioAutoriza" value="#arguments.id_UsuarioAutoriza#"  null="#iif(isNumeric(arguments.id_UsuarioAutoriza),false,true)#">

      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="AgregarRequisicionesUsuarioAutorizaPorNivel" access="public" returntype="query">
      <cfargument name="id_Empresa"                     type="string" required="true"/>
      <cfargument name="id_Sucursal"                    type="string" required="true"/>
      <cfargument name="id_TipoDivision"                type="string" required="true"/>
      <cfargument name="id_Nivel"                       type="string" required="true"/>
      <cfargument name="id_Requisicion"                 type="string" required="true"/>
      <cfargument name="id_RequisicionUsuarioAutoriza"  type="string" required="true"/>
      <cfargument name="id_UsuarioAutoriza"             type="string" required="true"/>
      <cfargument name="fh_AsignacionEstatus"           type="string" required="true"/>
      <cfargument name="id_UsuarioSession"              type="string" required="true"/>
      <cfargument name="id_EmpleadoProxAut"             type="string" required="true"/>

      <cfstoredproc procedure="upC_requisicionesUsuarioAutorizaPorNivel" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"                     value="#arguments.id_Empresa#"                    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"                    value="#arguments.id_Sucursal#"                   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoDivision"                value="#arguments.id_TipoDivision#"               null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Nivel"                       value="#arguments.id_Nivel#"                      null="#iif(isNumeric(arguments.id_Nivel),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Requisicion"                 value="#arguments.id_Requisicion#"                null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_RequisicionUsuarioAutoriza"  value="#arguments.id_RequisicionUsuarioAutoriza#" null="#iif(isNumeric(arguments.id_RequisicionUsuarioAutoriza),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioAutoriza"             value="#arguments.id_UsuarioAutoriza#"            null="#iif(isNumeric(arguments.id_UsuarioAutoriza),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_AsignacionEstatus"           value="#arguments.fh_AsignacionEstatus#"          null="#iif(Len(arguments.fh_AsignacionEstatus),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioSession"              value="#session.ID_USUARIO#"                      null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EmpleadoProxAut"             value="#arguments.id_EmpleadoProxAut#"            null="#iif(isNumeric(id_EmpleadoProxAut),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>
      <cfreturn Local.rs/>
  </cffunction>

</cfcomponent>
