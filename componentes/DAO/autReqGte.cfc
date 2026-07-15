<cfcomponent extends="wiz/Requisiciones">   

    <cffunction name="getRequisicionGerencia" access="public" returntype="query">
        <cfargument name='id_Empresa'           type='numeric' required='yes'>
        <cfargument name='id_Sucursal'          type='numeric' required='yes'>
        <cfargument name='id_Remision'   type='numeric' required='yes'>
        <cfargument name='cl_token'             type='string' required='no'>
        
        <cfstoredproc procedure="upR_RemisionesAutorizaciones" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#" null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"          value="#arguments.id_Sucursal#" null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Remision"          value="#arguments.id_Remision#" null="#iif(isNumeric(arguments.id_Remision),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_token"          value="#arguments.cl_Token#" null="#iif(len(arguments.cl_Token),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>


    <!--- Omar A. Ibarra
    Se utiliza para Aceptar o Rechazar una Remision --->
    <cffunction name="cambioEstatusAutorizacion" access="public" returntype="Any">  
        <cfargument name="id_Empresa"                   type="string" required="false"/>
        <cfargument name="id_Sucursal"                  type="string" required="false"/>
        <cfargument name="id_Remision"                  type="string" required="false"/>
        <cfargument name="id_RemisionAutorizacion"      type="string" required="false"/>
        <cfargument name="id_Estatus"                   type="string" required="false"/>
        <cfargument name="de_Comentarios"               type="string" required="false"/>
        <cfargument name="id_EmpresaEmpleadoAutoriza"   type="string" required="false"/>
        <cfargument name="id_Empleado"                  type="string" required="false"/>

        
        <cfstoredproc procedure="upU_RemisionesAutorizaciones" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_Empresa"                   value="#arguments.id_Empresa#"                  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_sucursal"                  value="#arguments.id_sucursal#"                 null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_Remision"                  value="#arguments.id_Remision#"                 null="#iif(isNumeric(arguments.id_Remision),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_RemisionAutorizacion"      value="#arguments.id_RemisionAutorizacion#"     null="#iif(isNumeric(arguments.id_RemisionAutorizacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_Estatus"                   value="#arguments.id_Estatus#"                  null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"     dbvarname="@de_Comentarios"               value="#arguments.de_Comentarios#"              null="#iif(len(arguments.de_Comentarios),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_EmpresaEmpleadoAutoriza"   value="#arguments.id_EmpresaEmpleadoAutoriza#"  null="#iif(isNumeric(arguments.id_EmpresaEmpleadoAutoriza),false,true)#"> 
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"     dbvarname="@id_Empleado"                  value="#arguments.id_Empleado#"                 null="#iif(isNumeric(arguments.id_Empleado),false,true)#">
        </cfstoredproc>
            
    </cffunction>
</cfcomponent>