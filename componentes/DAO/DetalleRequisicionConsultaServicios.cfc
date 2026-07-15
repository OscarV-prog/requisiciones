<cfcomponent extends="wiz/requisicionesdetalle">

	<cffunction name="listar" access="public" returntype="query">
		<cfargument name="id_Empresa"       type="numeric" required="true"/>
		<cfargument name="id_Sucursal"      type="numeric" required="true"/>
		<cfargument name="id_Requisicion"   type="numeric" required="true"/>

		<cfstoredproc procedure="upL_RequisicionesDetalleConsultaServicios" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"              null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_Sucursal#"             null="#iif(isnumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"           value="#arguments.id_Requisicion#"          null="#iif(isnumeric(arguments.id_Requisicion),false,true)#">
            <cfprocresult name="RequisicionesDetalle" resultset="1">
        </cfstoredproc>

		<cfreturn Local.RequisicionesDetalle/>
	</cffunction>

	<cffunction name="listaDatosRequisicion" access="public" returntype="query">
		<cfargument name="id_Empresa"       type="numeric" required="true"/>
		<cfargument name="id_Requisicion"   type="numeric" required="true"/>    
				
				<cfquery name="Local.DatosRequisicion" datasource="#variables.cnx#" >
						exec upL_RequisicionparaRequisicionDetalleConsultaServicios
																														#arguments.id_Empresa#,
																														#arguments.id_Requisicion#
				</cfquery>
				<cfreturn Local.DatosRequisicion/>
	</cffunction>

</cfcomponent>