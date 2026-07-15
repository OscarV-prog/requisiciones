<cfcomponent extends="wiz/ConfiguracionAutorizacionRequisiciones">

    <cffunction name="Configurar" access="public" returntype="query">
        <cfargument name="id_configuracionautorizacionrequisicion"   type="numeric" required="true"/>
        <cfargument name="id_tipodivision"   type="string" required="true"/>
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_puesto"         type="string" required="true"/>        
        <cfargument name="id_empleado"       type="string" required="true"/>
        <cfargument name="id_Nivel"          type="string" required="false"/>
        <cfargument name="sn_JefeImediato"   type="string" required="false"/>
        <cfargument name="sn_Activo"         type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"    type="string" required="false"/>

        <cfstoredproc procedure="upC_ConfiguracionAutorizacionRequisiciones" datasource="#variables.cnx#">
			<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empresa"          						value="#session.ID_EMPRESA#"	        					null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_configuracionautorizacionrequisicion"     value="#arguments.id_configuracionautorizacionrequisicion#" null="#iif(isNumeric(arguments.id_configuracionautorizacionrequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_sucursal"                                 value="#arguments.id_sucursal#"                             null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_tipodivision"                             value="#arguments.id_tipodivision#"                         null="#iif(isNumeric(arguments.id_tipodivision),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_puesto"                                   value="#arguments.id_puesto#"                               null="#iif(isNumeric(arguments.id_puesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_empleado"                                 value="#arguments.id_empleado#"                             null="#iif(isNumeric(arguments.id_empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Nivel"                                    value="#arguments.id_Nivel#"                                null="#iif(isNumeric(arguments.id_Nivel),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_JefeImediato"                             value="#arguments.sn_JefeImediato#"                         null="#iif(isBoolean(arguments.sn_JefeImediato),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_Activo"                                   value="#arguments.sn_Activo#"                               null="#iif(isBoolean(arguments.sn_Activo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_UsuarioSession"                           value="#SESSION.id_Usuario#"                                null="#iif(isNumeric(SESSION.id_Usuario),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_EnvioCorreo"                              value="#arguments.sn_EnvioCorreo#"                          null="#iif(isBoolean(arguments.sn_EnvioCorreo),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="existsConfiguracion" access="public" returntype="boolean">
       <cfargument name="id_empresa"         type="string"       required="true"/>
       <cfargument name="id_sucursal"        type="string"       required="true"/>
       <cfargument name="id_departamento"    type="string"       required="true"/>
       <cfargument name="id_puesto"          type="string"       required="true"/>
       <cfargument name="id_empresaEmpleado" type="string"       required="true"/>
       <cfargument name="id_Empleado"        type="string"       required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_ConfiguracionAutorizacionRequisicionesExisteRegistro
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_departamento#,
                #Arguments.id_puesto#,
                #Arguments.id_empresaEmpleado#,
                #Arguments.id_Empleado#
                                           
        </cfquery>
        <cfreturn Local.rs.sn_exists/>
    </cffunction>

    <cffunction name="getConfiguracionPorDepartamento" access="public" returntype="query">
       <cfargument name="id_empresa"         type="string"       required="true"/>
       <cfargument name="id_sucursal"        type="string"       required="true"/>
       <cfargument name="id_departamento"    type="string"       required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionAutorizacionRequisicionesPorDepartamento
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_departamento#
                                           
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="EliminarPorDepartamento" access="public" returntype="void">
       <cfargument name="id_empresa"         type="string"       required="true"/>
       <cfargument name="id_sucursal"        type="string"       required="true"/>
       <cfargument name="id_departamento"    type="string"       required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upD_ConfiguracionAutorizacionRequisicionesPorDepartamento
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_departamento#
                                           
        </cfquery>
    </cffunction>

    <cffunction name="getByEmpleado" access="public" returntype="query">
       <cfargument name="id_empresa"    type="string"       required="true"/>
        <cfargument name="id_sucursal"  type="numeric" required="true"/>
        <cfargument name="id_empleado"  type="numeric" required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionAutorizacionRequisicionesPorEmpleado
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_empleado#
                                           
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_empresa"    type="string"       required="true"/>
        <cfargument name="id_sucursal"      type="string" required="false">
        <cfargument name="id_puesto"        type="string" required="false">
        <cfargument name="id_empleado"      type="string" required="false">
        <cfargument name="id_tipodivision"  type="string" required="false">


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionAutorizacionRequisiciones
                #Arguments.id_empresa#,
                <cfif isDefined("Arguments.id_sucursal")>#Arguments.id_sucursal#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_puesto")>#Arguments.id_puesto#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_empleado")>#Arguments.id_empleado#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_tipodivision")>#Arguments.id_tipodivision#<cfelse>NULL</cfif>
                                           
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="void">
        <cfargument name="id_empresa"       type="string" required="true"/>
        <cfargument name="id_sucursal"      type="string" required="true"/>
        <cfargument name="id_puesto"        type="string" required="true"/>
        <cfargument name="id_empleado"      type="string" required="true"/>
        <cfargument name="id_departamento"  type="string" required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upD_ConfiguracionAutorizacionRequisiciones
                #Arguments.id_empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_puesto#,
                #Arguments.id_empleado#,
                #Arguments.id_departamento#
                                           
        </cfquery>

    </cffunction>

    <cffunction name="empleadoTieneConfiguracion" access="public" returntype="boolean">
       <cfargument name="id_empresaEmpleado" type="string" required="true"/>
       <cfargument name="id_empleado" type="string" required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_ConfiguracionAutorizacionRequisicionesExistsByEmpleado
                #Arguments.id_empresaEmpleado#,
                #Arguments.id_empleado#                                        
        </cfquery>

        <cfreturn Local.rs.sn_confAut />
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 06/03/2015
          Obtiene los empleados configurados para autorizar en el departamento especificado --->
    <cffunction name="getEmpleadosByDepartamento" access="public" returntype="query">
        <cfargument name="id_empresa"       type="string" required="true"/>
        <cfargument name="id_empleado"      type="string"   required="true"/>
        <cfargument name="id_departamento"  type="string"   required="true"/>


        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ConfiguracionAutorizacionEmpleadosByDepartamento
                #Arguments.id_empresa#,
                #Arguments.id_empleado#,
                #Arguments.id_departamento#
                                           
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>
    
    <!--- Omar Ibarra, 01/06/2017, Obtener nivel por empresa, sucursal y tipo de division--->
        <cffunction name="ObtenerNivelConfAutorizacionRequisicion" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="string" required="true"/>
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_tipoDivision"   type="string" required="false"/>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upL_ObtenerNivelConfAutorizacionRequisicion
                #Arguments.id_Empresa#,
                #Arguments.id_sucursal#,
                #Arguments.id_tipoDivision#
                                           
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="Editar" access="public" returntype="void">
        <cfargument name="id_configuracionautorizacionrequisicion"   type="numeric" required="true"/>
        <cfargument name="id_tipodivision"                           type="string" required="true"/>
        <cfargument name="id_sucursal"                               type="string" required="false"/>
        <cfargument name="id_puesto"                                 type="string" required="true"/>        
        <cfargument name="id_empleado"                               type="string" required="true"/>
        <cfargument name="id_Nivel"                                  type="string" required="false"/>
        <cfargument name="sn_JefeImediato"                           type="string" required="false"/>
        <cfargument name="sn_Activo"                                 type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"                            type="string" required="false"/>

        <cfstoredproc procedure="upU_ConfiguracionAutorizacionRequisiciones" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_configuracionautorizacionrequisicion"     value="#arguments.id_configuracionautorizacionrequisicion#" null="#iif(isNumeric(arguments.id_configuracionautorizacionrequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_tipodivision"                             value="#arguments.id_tipodivision#"                         null="#iif(isNumeric(arguments.id_tipodivision),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_sucursal"                                 value="#arguments.id_sucursal#"                             null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_puesto"                                   value="#arguments.id_puesto#"                               null="#iif(isNumeric(arguments.id_puesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_empleado"                                 value="#arguments.id_empleado#"                             null="#iif(isNumeric(arguments.id_empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Nivel"                                    value="#arguments.id_Nivel#"                                null="#iif(isNumeric(arguments.id_Nivel),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_JefeImediato"                             value="#arguments.sn_JefeImediato#"                         null="#iif(isBoolean(arguments.sn_JefeImediato),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_Activo"                                   value="#arguments.sn_Activo#"                               null="#iif(isBoolean(arguments.sn_Activo),false,true)#">
			<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empresa"          						value="#session.ID_EMPRESA#"	        					null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_EnvioCorreo"                              value="#arguments.sn_EnvioCorreo#"                          null="#iif(isBoolean(arguments.sn_EnvioCorreo),false,true)#">
			<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_UsuarioSession"          				    value="#session.id_Usuario#"	        					null="#iif(isNumeric(session.id_Usuario),false,true)#">

        </cfstoredproc>
    </cffunction>

    <cffunction name="CheckRepetidos" access="public" returntype="any">
        <cfargument name="id_Empresa"        type="string" required="false"/>
        <cfargument name="id_Sucursal"       type="string" required="false"/>
        <cfargument name="id_TipoDivision"   type="string" required="true"/>
        <cfargument name="id_Empleado"       type="string" required="true"/>
        <cfargument name="sn_JefeImediato"   type="string" required="false"/>

        <cfstoredproc procedure="upR_ConfiguracionAutorizacionRequisiciones_CheckPermiso" datasource="#variables.cnx#">
			<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empresa"      value="#session.ID_EMPRESA#"        null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Sucursal"     value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_TipoDivision" value="#arguments.id_TipoDivision#" null="#iif(isNumeric(arguments.id_TipoDivision),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Empleado"     value="#arguments.id_Empleado#"     null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"      dbvarname="@sn_JefeImediato" value="#arguments.sn_JefeImediato#" null="#iif(isBoolean(arguments.sn_JefeImediato),false,true)#">
            <cfprocresult name="check" resultset="1">
        </cfstoredproc>

        <cfreturn check/>
    </cffunction>
</cfcomponent>