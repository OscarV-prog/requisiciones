<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8"> 
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="AutorizarRequisicion" access="public" returntype="Any">
        <cfargument name='id_requisicion'       type='string'   required='yes'>
        <cfargument name='cl_token'             type='string'   required='yes'>
        <cfargument name='de_action'            type='string'   required='yes'>
        <cfargument name='id_usuario'           type='string'   required='yes'>
        <cfargument name='de_password'          type='string'   required='yes'>
        <cfargument name='de_observaciones'          type='string'   required='yes'>
        
        <!--- Nos vamos por los datos del usuario --->
        <cfinvoke component="#Application.RF.getPath('dao','Usuarios')#"
                  method="getByID"
                  id_usuario="#arguments.id_usuario#"
                  returnvariable="Local.user">
        
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
                        <cfset session.NB_APELLIDOPATERNO  = Local.user.nb_apellidoPaterno>
                        <cfset session.NB_APELLIDOMATERNO  = Local.user.nb_apellidoMaterno>
                        <cfset session.ID_EMPRESAOPERADORA = Local.user.id_EmpresaOperadora>
                        <cfset Session.nb_EmpresaOperadora = Local.user.nb_EmpresaOperadora>
                        <cfset session.DE_EMAIL            = Local.user.de_Email>
                        

                        <!--- Nos vamos por los datos de la requisicion --->
                        <cfinvoke component="#Application.RF.getPath('dao','AutReq')#"
                                  method="getRequisicion"
                                  argumentcollection="#arguments#"
                                  returnvariable="Local.requisicion">

                        <!--- VALIDAMOS QUE EXISTA UNA REQUISICION CON ESTATUS:SOLICITADA --->
                        <cfif #Local.requisicion.RecordCount# EQ 0>
                            <cfset variables.RBR.setError('La requisición no cuenta con estatus SOLICITADA. Verifique su información.')>
                            <cfreturn variables.RBR>                        
                        </cfif>


                        <cfset session.ID_EMPRESA = Local.requisicion.id_Empresa>
                        <!--- Convertimos el query en una structura --->
                        <cfset StrReq = QueryToStruct( Local.requisicion,1) >

                        <!--- Preparamos la accion a ejecutar --->
                        <cfset Local.Identificador = 'Rechazar'>
                        <cfif #arguments.de_action# EQ 1>
                                <cfset Local.Identificador = 'Autorizar'>   
                            <cfelse>
                                <cfset StrReq.de_observaciones = #arguments.de_observaciones#>
                        </cfif>                                         
                        
                        <cfset StrReq.identificador = #Local.identificador#>
                        

                        <cfinvoke component="#Application.RF.getPath('bro','AutorizaciondeRequisicion')#"
                            method="EditardesdeDetalleRequisicion"
                            argumentcollection="#StrReq#">

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

    <cffunction name="getRequisicion" access="public" returntype="Any">
        <cfargument name='id_requisicion' type='string' required='yes'>
        <cfargument name='cl_token'       type='string' required='yes'>
        
        <cfinvoke component="#Application.RF.getPath('dao','AutReq')#"
                  method="getRequisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Converts an entire query or the given record to a struct. This might return a structure (single record) or an array of structures. --->
    <cffunction name="QueryToStruct" access="public" returntype="any">

        <!--- Define arguments. --->
        <cfargument name="Query" type="query" required="true" />
        <cfargument name="Row" type="numeric" required="false" default="0" />

        <cfscript>
            // Define the local scope.
            var LOCAL = StructNew();
            // Determine the indexes that we will need to loop over.
            // To do so, check to see if we are working with a given row,
            // or the whole record set.
            if (ARGUMENTS.Row){
                // We are only looping over one row.
                LOCAL.FromIndex = ARGUMENTS.Row;
                LOCAL.ToIndex = ARGUMENTS.Row;
            } else {
                // We are looping over the entire query.
                LOCAL.FromIndex = 1;
                LOCAL.ToIndex = ARGUMENTS.Query.RecordCount;
            }
            // Get the list of columns as an array and the column count.
            LOCAL.Columns = ListToArray( ARGUMENTS.Query.ColumnList );
            LOCAL.ColumnCount = ArrayLen( LOCAL.Columns );
            // Create an array to keep all the objects.
            LOCAL.DataArray = ArrayNew( 1 );
            // Loop over the rows to create a structure for each row.
            for (LOCAL.RowIndex = LOCAL.FromIndex ; LOCAL.RowIndex LTE LOCAL.ToIndex ; LOCAL.RowIndex = (LOCAL.RowIndex + 1)){
                // Create a new structure for this row.
                ArrayAppend( LOCAL.DataArray, StructNew() );
                // Get the index of the current data array object.
                LOCAL.DataArrayIndex = ArrayLen( LOCAL.DataArray );
                // Loop over the columns to set the structure values.
                for (LOCAL.ColumnIndex = 1 ; LOCAL.ColumnIndex LTE LOCAL.ColumnCount ; LOCAL.ColumnIndex = (LOCAL.ColumnIndex + 1)){
                    // Get the column value.
                    LOCAL.ColumnName = LOCAL.Columns[ LOCAL.ColumnIndex ];
                    // Set column value into the structure.
                    LOCAL.DataArray[ LOCAL.DataArrayIndex ][ LOCAL.ColumnName ] = ARGUMENTS.Query[ LOCAL.ColumnName ][ LOCAL.RowIndex ];
                }
            }
            // At this point, we have an array of structure objects that
            // represent the rows in the query over the indexes that we
            // wanted to convert. If we did not want to convert a specific
            // record, return the array. If we wanted to convert a single
            // row, then return the just that STRUCTURE, not the array.
            if (ARGUMENTS.Row){
                // Return the first array item.
                return( LOCAL.DataArray[ 1 ] );
            } else {
                // Return the entire array.
                return( LOCAL.DataArray );
            }
        </cfscript>
    </cffunction>
</cfcomponent>