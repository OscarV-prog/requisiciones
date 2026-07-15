<cfcomponent>
<cfprocessingdirective pageencoding="utf-8">
<cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

	<cffunction name="listar" access="public" returntype="Any">
		<cfargument name="id_Requisicion"   type="numeric" required="true"/>

		<cfset arguments.id_Empresa  = session.ID_EMPRESA>
		<cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
		<cfset arguments.id_Almacen  = session.ID_ALMACEN>

		<cfset local.DetalleRequisicion=structNew()>

		<cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
					method="listaDatosRequisicion"
					argumentcollection="#arguments#"
					returnvariable="Local.DatosRequisicion">

		<cfset local.DetalleRequisicion.Requisicion = local.DatosRequisicion>

		<cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaServicios')#"
					method="listar"
					argumentcollection="#arguments#"
					returnvariable="Local.DetalleReq">

		<cfset local.DetalleRequisicion.DetalleReq= local.DetalleReq>

		<cfset variables.RBR.setData(local.DetalleRequisicion)>

		<cfreturn variables.RBR>
	</cffunction>

</cfcomponent>
