<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8"> 
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="getRequisicionGerencia" access="public" returntype="Any">
        <cfargument name='id_Empresa'           type='numeric' required='yes'>
        <cfargument name='id_Sucursal'          type='numeric' required='yes'>
        <cfargument name='id_Remision'   type='numeric' required='yes'>
        <cfargument name='cl_token'             type='string' required='no'>
        
        <cfinvoke component="#Application.RF.getPath('dao','autReqGte')#"
                 argumentcollection="#arguments#"
                  method="getRequisicionGerencia"
                  returnvariable="Local.rs">

    
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

     <!--- Omar A. Ibarra --->
    <cffunction name="autorizaRemision" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_Remision"              type="string" required="false"/>
        <cfargument name="id_RemisionAutorizacion"  type="string" required="false"/>
        <cfargument name="id_Estatus"               type="string" required="false"/>
        <cfargument name="de_Comentarios"           type="string" required="false"/>
        <cfargument name='nb_usuario'            type='string' required='no'>
        <cfargument name='de_password'           type='string' required='yes'>

        <!--- Nos vamos por los datos del usuario --->
        <cfinvoke component="#Application.RF.getPath('dao','Usuarios')#"
                  method="getByName"
                  nb_usuario="#Arguments.nb_usuario#"
                  returnvariable="Local.user">
        
        <cfif #Local.user.RecordCount# EQ 0>
            <cfset variables.RBR.setError('Usuario Incorrecto, favor de verificar.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfif #Local.user.RecordCount# GT 0>
                <!--- validamos cuando el usuario no cuenta con una contraseña --->
                <cfif Local.user.cl_Contrasena EQ ''>
                    <cfset variables.RBR.setError('El usuario con el que intenta realizar la operación, no cuenta con una contraseña establecida.<br>Es necesario iniciar sesion en el sistema por lo menos una vez, para poder realizar la autorización desde esta pantalla.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfif "X#decrypt(Local.user.cl_Contrasena,'petroil')#" EQ "X#Arguments.de_password#">
                        <cfset session.LOGGEDIN            = true>
                        <cfset session.ID_USUARIO          = Local.user.id_Usuario>    
                        <cfset session.ID_TIPOUSUARIO      = Local.user.id_TipoUsuario>
                        <cfset session.NB_USUARIO          = Local.user.nb_Usuario>

                        <cfif local.user.id_Empleado EQ ''>
                            <cfset SESSION.ID_EMPLEADO     = 0>
                        <cfelse>
                            <cfset SESSION.ID_EMPLEADO     = Local.user.id_Empleado>
                        </cfif>
                        
                        <cfset session.NB_EMPLEADOCOMPLETO = Local.user.nombre>
                        <cfset session.NB_EMPLEADO         = Local.user.nb_NombreEmpleado>
                        <cfset session.NB_APELLIDOPATERNO  = Local.user.nb_ApellidoPaterno>
                        <cfset session.NB_APELLIDOMATERNO  = Local.user.nb_ApellidoMaterno>
                        <cfset session.ID_EMPRESAOPERADORA = Local.user.id_empresaOperadora>
                        <cfset Session.nb_EmpresaOperadora = Local.user.nb_empresaOperadora>
                        <cfset session.DE_EMAIL            = Local.user.de_Email>
                        
                        <!---validamos que exista en la configuracion de autorizacion--->
                        <cfinvoke component="#Application.RF.getPath('dao','autorizarOs')#"
                            method="getConfiguracionNE"
                            id_Empresa="#arguments.id_Empresa#"
                            id_Sucursal="#arguments.id_Sucursal#"
                            id_Empleado="#Local.user.ID_EMPLEADO#"
                            id_Notificacion = 21
                            returnvariable="local.existe">  
                        
                        <cfif #local.existe.SN_EMPLEADO_OS# EQ 0>
                            <cfset variables.RBR.setError('Usuario Incorrecto, favor de verificar.')>
                            <cfreturn variables.RBR>
                        </cfif>
                        <!---<cfset Variables.RBR.setError("error!!!")>--->
                        <!---Autoriza la Remision--->
                        <cfinvoke component="#Application.RF.getPath('dao','autReqGte')#"
                                    method="cambioEstatusAutorizacion"
                                    id_Empleado="#Local.user.ID_EMPLEADO#"
                                    id_EmpresaEmpleadoAutoriza ="#Arguments.id_Empresa#"
                                    argumentcollection="#arguments#">
                    <cfelse>
                        <cfset variables.RBR.setError('Usuario y/ó Contraseña incorrectos. Verifique su información.')>
                        <cfreturn variables.RBR>                        
                </cfif>
            <cfelse>
                <cfset variables.RBR.setError('Usuario y/ó Contraseña incorrectos. Verifique su información.')>
                <cfreturn variables.RBR>
        </cfif>
        
        <cfreturn variables.RBR>
    </cffunction>
 
    
     <!--- Omar A. Ibarra --->
    <cffunction name="rechazaRemision" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="id_Remision"              type="string" required="false"/>
        <cfargument name="id_RemisionAutorizacion"  type="string" required="false"/>
        <cfargument name="id_Estatus"               type="string" required="false"/>
        <cfargument name="de_Comentarios"           type="string" required="false"/>
        <cfargument name='nb_usuario'            type='string' required='no'>
        <cfargument name='de_password'           type='string' required='yes'>


         <!--- Nos vamos por los datos del usuario --->
        <cfinvoke component="#Application.RF.getPath('dao','Usuarios')#"
                  method="getByName"
                  nb_usuario="#Arguments.nb_usuario#"
                  returnvariable="Local.user">
        
        <cfif #Local.user.RecordCount# EQ 0>
            <cfset variables.RBR.setError('Usuario Incorrecto, favor de verificar.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfif #Local.user.RecordCount# GT 0>
                <!--- validamos cuando el usuario no cuenta con una contraseña --->
                <cfif Local.user.cl_Contrasena EQ ''>
                    <cfset variables.RBR.setError('El usuario con el que intenta realizar la operación, no cuenta con una contraseña establecida.<br>Es necesario iniciar sesion en el sistema por lo menos una vez, para poder realizar la autorización desde esta pantalla.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfif "X#decrypt(Local.user.cl_Contrasena,'petroil')#" EQ "X#Arguments.de_password#">
                        <cfset session.LOGGEDIN            = true>
                        <cfset session.ID_USUARIO          = Local.user.id_Usuario>    
                        <cfset session.ID_TIPOUSUARIO      = Local.user.id_TipoUsuario>
                        <cfset session.NB_USUARIO          = Local.user.nb_Usuario>

                        <cfif local.user.id_Empleado EQ ''>
                            <cfset SESSION.ID_EMPLEADO     = 0>
                        <cfelse>
                            <cfset SESSION.ID_EMPLEADO     = Local.user.id_Empleado>
                        </cfif>
                        
                        <cfset session.NB_EMPLEADOCOMPLETO = Local.user.nombre>
                        <cfset session.NB_EMPLEADO         = Local.user.nb_NombreEmpleado>
                        <cfset session.NB_APELLIDOPATERNO  = Local.user.nb_ApellidoPaterno>
                        <cfset session.NB_APELLIDOMATERNO  = Local.user.nb_ApellidoMaterno>
                        <cfset session.ID_EMPRESAOPERADORA = Local.user.id_empresaOperadora>
                        <cfset Session.nb_EmpresaOperadora = Local.user.nb_empresaOperadora>
                        <cfset session.DE_EMAIL            = Local.user.de_Email>
                        
                        <!---validamos que exista en la configuracion de autorizacion--->
                        <cfinvoke component="#Application.RF.getPath('dao','autorizarOs')#"
                            method="getConfiguracionNE"
                            id_Empresa="#arguments.id_Empresa#"
                            id_Sucursal="#arguments.id_Sucursal#"
                            id_Empleado="#Local.user.ID_EMPLEADO#"
                            id_Notificacion = 21
                            returnvariable="local.existe">  
                        
                        <cfif #local.existe.SN_EMPLEADO_OS# EQ 0>
                            <cfset variables.RBR.setError('No cuenta con permisos para autorizar, favor de ponerse en contacto con el Administrador.')>
                            <cfreturn variables.RBR>
                        </cfif>

                        <cfinvoke component="#Application.RF.getPath('dao','autReqGte')#"
                                    method="cambioEstatusAutorizacion"
                                    id_Empleado="#Local.user.ID_EMPLEADO#"
                                    id_EmpresaEmpleadoAutoriza ="#Arguments.id_Empresa#"
                                    argumentcollection="#arguments#">

                    <cfelse>
                        <cfset variables.RBR.setError('Usuario y/ó Contraseña incorrectos. Verifique su información.')>
                        <cfreturn variables.RBR>                        
                </cfif>
            <cfelse>
                <cfset variables.RBR.setError('Usuario y/ó Contraseña incorrectos. Verifique su información.')>
                <cfreturn variables.RBR>
        </cfif>
        
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>