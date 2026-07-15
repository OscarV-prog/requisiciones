<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="getConfiguracionPorDepartamento" access="public" returntype="Any">    
        <cfargument name="id_sucursal"           type="numeric" required="true"/>
        <cfargument name="id_departamento"       type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')#"
                      method="getConfiguracionPorDepartamento"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(local.rs)>
        
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
     </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 26/01/2015
          Borra la configuracion especificada por el id --->
    <cffunction name="deleteById" access="public" returntype="Any">
        <cfargument name="id_sucursal"     type="numeric" required="true"/>
        <cfargument name="id_departamento" type="numeric" required="true"/>
        <cfargument name="id_puesto"       type="numeric" required="true"/>
        <cfargument name="id_notificacion" type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')#"
                  method="RSEliminar"
                  id_Empresa="#session.ID_EMPRESA#"
                  id_sucursal="#Arguments.id_sucursal#"
                  id_departamento="#Arguments.id_departamento#"
                  id_puesto="#Arguments.id_puesto#"
                  id_ConfiguracionNotificacionRegistroRequisicion="#Arguments.id_notificacion#">

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 26/01/2015
          Obtiene la configuracion del empleado en especificado --->
    <cffunction name="getByEmpleado" access="public" returntype="Any">  
        <cfargument name="id_sucursal" type="numeric" required="true"/>
        <cfargument name="id_empleado" type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')#"
                      method="getByEmpleado"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(local.rs)>
        
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>

     <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 05/03/2015
          Obtiene la configuracion del empleado en especificado --->
    <cffunction name="Configurar" access="public" returntype="Any"> 
        <cfargument name="empleadosNotificar" type="array" required="true"/>

        <cfset var Local.dao=createObject("component","#Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')#")>
        <cfloop array="#Arguments.empleadosNotificar#" index="Local.notificacion">
            <cfinvoke component="#Local.dao#"
                      method="getNextID"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Sucursal="#Local.notificacion.id_sucursal#"
                      id_Departamento="#Local.notificacion.id_departamento#"
                      id_Puesto="#Local.notificacion.id_puesto#"
                      returnvariable="Local.id_ConfiguracionNotificacionRegistroRequisicion">

            <cfinvoke component="#Local.dao#"
                      method="RSAgregar"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Sucursal="#Local.notificacion.id_sucursal#"
                      id_Departamento="#Local.notificacion.id_departamento#"
                      id_Puesto="#Local.notificacion.id_puesto#"
                      id_ConfiguracionNotificacionRegistroRequisicion="#Local.id_ConfiguracionNotificacionRegistroRequisicion#"
                      id_EmpresaEmpleado="#Local.notificacion.id_EmpresaEmpleado#"
                      id_Empleado="#Local.notificacion.id_empleado#">
        </cfloop>
        
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
     </cffunction>

     <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 05/03/2015
          Obtiene el listado de configuraciones --->
    <cffunction name="listar" access="public" returntype="Any"> 
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_puesto" type="string" required="true"/>
        <cfargument name="id_empleado" type="string" required="true"/>
        <cfargument name="id_departamento" type="string" required="true"/>

        <cfset Local.argumentos={id_Empresa=session.ID_EMPRESA}>

        <cfif Arguments.id_sucursal NEQ ''>
            <cfset Local.argumentos.id_sucursal=Arguments.id_sucursal>
        </cfif>
        <cfif Arguments.id_puesto NEQ ''>
            <cfset Local.argumentos.id_puesto=Arguments.id_puesto>
        </cfif>
        <cfif Arguments.id_empleado NEQ '' AND Arguments.id_empleado NEQ '0'>
            <cfset Local.argumentos.id_empleado=Arguments.id_empleado>
        </cfif>
        <cfif Arguments.id_departamento NEQ ''>
            <cfset Local.argumentos.id_departamento=Arguments.id_departamento>
        </cfif>
        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')#"
                      method="listar"
                      argumentcollection="#Local.argumentos#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(local.rs)>
        
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>
</cfcomponent>