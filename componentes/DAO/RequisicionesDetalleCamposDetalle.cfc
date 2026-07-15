<cfcomponent extends="wiz/conexion_server">
    <cffunction name="agregar" access="public" returntype="void">
        <cfargument name="id_empresa"                   type="string" required="true"/>
        <cfargument name="id_requisicion"               type="string" required="true"/>
        <cfargument name="id_requisiciondetalle"        type="string" required="true"/>
        <cfargument name="id_campodetalle"      type="string" required="true"/>
        <cfargument name="nb_campodetalle"      type="string" required="true"/>
        <cfargument name="de_valorcampodetalle"         type="string" required="true"/>

            <cfquery datasource="#variables.cnx#">
                        exec upC_RequisicionesDetalleCamposDetalle       
                                        #id_empresa#,
                                        #id_requisicion#,
                                        #id_requisiciondetalle#,
                                        #id_campodetalle#,
                                        '#nb_campodetalle#',
                                        '#de_valorcampodetalle#'
            </cfquery>
    </cffunction>

    <cffunction name="deletebyrequisiciondetallecampo" access="public" returntype="void">
        <cfargument name="id_empresa"                   type="string" required="true"/>
        <cfargument name="id_requisicion"               type="string" required="true"/>

            <cfquery datasource="#variables.cnx#">
                        exec upD_RequisicionesDetalleCamposDetalle       
                                        #id_empresa#,
                                        #id_requisicion#
            </cfquery>
    </cffunction>


    <cffunction name="upR_requisicionesDetalleCamposDetalle" access="public" returntype="query">
        <cfargument name="id_empresa"               type="string" required="true" default="NULL"/>
        <cfargument name="id_requisicion"           type="string" required="true" default="NULL"/>
        <cfargument name="id_requisiciondetalle"    type="string" required="true" default="NULL"/>
        <cfargument name="id_campodetalle"          type="string" required="true" default="NULL"/>
            <!--- <cfquery name="local.rs" datasource="#variables.cnx#">
                exec upR_requisicionesDetalleCamposDetalle 
                    #arguments.id_empresa#, #id_requisicion#, #id_requisiciondetalle#, #id_campodetalle#
            </cfquery> --->

            <cfstoredproc procedure="upR_requisicionesDetalleCamposDetalle" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicion"        value="#arguments.id_requisicion#"        null="#iif(isNumeric(arguments.id_requisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_requisicionDetalle" value="#arguments.id_requisicionDetalle#" null="#iif(isNumeric(arguments.id_requisicionDetalle),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_campodetalle"       value="#arguments.id_campodetalle#"       null="#iif(isNumeric(arguments.id_campodetalle),false,true)#">
                <cfprocresult name="local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn local.rs/>
    </cffunction>
    

</cfcomponent>