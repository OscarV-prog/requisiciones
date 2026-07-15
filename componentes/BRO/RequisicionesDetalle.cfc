<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>
    
    <!--- 
        Modificacion: 21/07/2015    Autor: Mario Mejia
        Al momento de ir por el detalle de la requisicion, es necesario traer los
        grupos y conceptos de gasto de cada insumo --->
    <cffunction name="getByIdRequisicion" access="public" returntype="Any">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='id_Empresa' type='string' required='yes'>
        
        <!--- Obtenemos el detalle de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalle')#"
                  method="getByIdRequisicion"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.rs">

        <!--- Convertimos el query a JSON --->
        <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                  method="queryToJSon"
                  query="#Local.rs#"
                  returnvariable="Local.requisicionesDetalle"/>
                  
            <!--- Iteramos sobre cada uno de los elementos del JSON --->
            <cfloop array="#local.requisicionesDetalle#" index="local.requisicion">
                <!--- Obtenemos los grupos y conceptos de gasto de cada insumo --->
                <cfinvoke component="#Application.RF.getPath('dao','ConceptosGastosInsumos')#"
                          method="getByIdInsumo"
                          id_empresa="#Arguments.id_empresa#"
                          id_insumo="#local.requisicion.ID_INSUMO#"
                          returnvariable="Local.rs">

                <!--- Convertimos a JSON la informacion obtenida --->
                <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                          method="queryToJSon"
                          query="#Local.rs#"
                          returnvariable="Local.grupos"/>

                <!--- Asignamos JSON obtenido al insumo --->
                <cfset local.requisicion.grupos = Local.grupos>


                <!--- Obtenemos los detalles del insumo --->
                <cfinvoke component="#Application.RF.getPath('dao','requisicionesDetalleCamposDetalle')#"
                          method="upR_requisicionesDetalleCamposDetalle"
                          argumentcollection="#local.requisicion#"
                          returnvariable="Local.rs">

                <!--- Convertimos a JSON la informacion obtenida --->
                <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                          method="queryToJSon"
                          query="#Local.rs#"
                          returnvariable="Local.detalleInsumo"/>

                <!--- Asignamos JSON obtenido al insumo --->
                <cfset local.requisicion.campos = Local.detalleInsumo>

                <!--- Obtenemos los detalles del insumo --->
                <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                          method="listar_CentrosCostoPorDestino"
                          id_Sucursal="#Local.requisicion.id_SucursalSolicita#"
                          argumentcollection="#local.requisicion#"
                          returnvariable="Local.rs">

                <!--- Convertimos a JSON la informacion obtenida --->
                <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                          method="queryToJSon"
                          query="#Local.rs#"
                          returnvariable="Local.centrosCostos"/>

                <!--- Asignamos JSON obtenido al insumo --->
                <cfset local.requisicion.centrosCostos = Local.centrosCostos>
            </cfloop>
            <cfset variables.RBR.setData(local.requisicionesDetalle) >
        <cfreturn variables.RBR>
    </cffunction>
</cfcomponent>