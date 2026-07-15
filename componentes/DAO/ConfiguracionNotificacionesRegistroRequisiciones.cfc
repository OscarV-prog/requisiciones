<cfcomponent extends="wiz/ConfiguracionNotificacionesRegistroRequisiciones">
    
    <cffunction name="getConfiguracionPorDepartamento" access="public" returntype="query">
       <cfargument name="id_empresa"         type="string"       required="true"/>
       <cfargument name="id_sucursal"        type="string"       required="true"/>
       <cfargument name="id_departamento"    type="string"       required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionNotificacionesRegistroRequisicionesPorDepartamento
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_departamento#
                                           
        </cfquery>

        <cfreturn Local.rs>
    </cffunction>

    <cffunction name="getByEmpleado" access="public" returntype="query">
       <cfargument name="id_empresa"         type="string"       required="true"/>
       <cfargument name="id_sucursal"        type="string"       required="true"/>
       <cfargument name="id_empleado"    type="string"       required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionNotificacionesRegistroRequisicionesByEmpleado
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_empleado#
                                           
        </cfquery>

        <cfreturn Local.rs>
    </cffunction>

    <cffunction name="listar" access="public" returntype="query">
       <cfargument name="id_empresa"      type="string"       required="true"/>
       <cfargument name="id_sucursal"     type="string"       required="false"/>
       <cfargument name="id_puesto"       type="string"       required="false"/>
       <cfargument name="id_empleado"     type="string"       required="false"/>
       <cfargument name="id_departamento" type="string"       required="false"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionNotificacionesRegistroRequisiciones
                #Arguments.id_empresa#,
                <cfif isDefined("Arguments.id_sucursal")>#Arguments.id_sucursal#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_puesto")>#Arguments.id_puesto#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_empleado")>#Arguments.id_empleado#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_departamento")>#Arguments.id_departamento#<cfelse>NULL</cfif>
                                           
        </cfquery>

        <cfreturn Local.rs>
    </cffunction>

    <cffunction name="empleadoTieneConfiguracion" access="public" returntype="boolean">
       <cfargument name="id_empresaEmpleado" type="string" required="true"/>
       <cfargument name="id_empleado" type="string" required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_ConfiguracionNotificacionesRegistroRequisicionesExistsByEmpleado
                #Arguments.id_empresaEmpleado#,
                #Arguments.id_empleado#                                        
        </cfquery>

        <cfreturn Local.rs.sn_confAut />
    </cffunction>
</cfcomponent>
