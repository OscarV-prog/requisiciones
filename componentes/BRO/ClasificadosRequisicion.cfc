<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>
    
    <cffunction name="agregar"              access="public" returntype="Any">
     <cfargument name="de_ClasificadoRequisicion"   type="string" required="true"/>
     <cfargument name="id_TipoRequisicion"          type="numeric" required="true"/>
     <cfargument name="sn_Activo"                   type="string" required="false"/>

            <cfif NOT variables.RBR.hasError()>             
              <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                        method="existeClasificadoRequisicion"
                        id_ClasificadoRequisicion="0"
                        de_ClasificadoRequisicion="#Arguments.de_ClasificadoRequisicion#"
                        returnvariable="Local.exist">
                      
                        <cfif NOT Local.exist>
                            <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                                      method="nextID"
                                      returnvariable="Local.id_ClasificadoRequisicion">

                            <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                                      method="agregar"
                                      id_ClasificadoRequisicion=#Local.id_ClasificadoRequisicion#
                                      argumentcollection="#arguments#">

                                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>  

                             <cfelse> 
                                <cfset variables.RBR.setError('El Clasificado de Requisici&oacute;n ya esta registrado.')>
                        </cfif> 
            </cfif>

            <cfreturn variables.RBR>
     </cffunction>



    <cffunction name="editar"               access="public" returntype="Any">
      <cfargument name="id_ClasificadoRequisicion"    type="numeric" required="true"/>  
      <cfargument name="de_ClasificadoRequisicion"    type="string" required="true"/>
      <cfargument name="id_TipoRequisicion"           type="numeric" required="true"/>
      <cfargument name="sn_Activo"                    type="string" required="false"/>
   
               <cfif NOT variables.RBR.hasError()>
                
                    <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                        method="existeClasificadoRequisicion"
                        id_ClasificadoRequisicion="#arguments.id_ClasificadoRequisicion#"
                        de_ClasificadoRequisicion="#Arguments.de_ClasificadoRequisicion#"
                        returnvariable="Local.exist">
                        
                        <cfif NOT Local.exist>
                                <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                                method="editar"
                                id_ClasificadoRequisicion="#arguments.id_ClasificadoRequisicion#"
                                argumentcollection="#arguments#">

                                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>              
                                                
                             <cfelse> 
                                <cfset variables.RBR.setError('El Clasificado de Requisici&oacute;n ya esta registrado.')>
                        </cfif>         
               </cfif> 
            <cfreturn variables.RBR>
     </cffunction>


     <cffunction name="listar" access="public" returntype="Any">
     <cfargument name="id_ClasificadoRequisicion"   type="string" required="false"/>
     <cfargument name="de_ClasificadoRequisicion"   type="string" required="false"/>
     <cfargument name="id_TipoRequisicion"          type="string" required="false"/>
     <cfargument name="sn_Activo"                   type="string" required="false"/>
         
        <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        
        <cfreturn variables.RBR>
    </cffunction>


     <cffunction name="listar_TiposRequisicion" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                  method="listar_TiposRequisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        
        <cfreturn variables.RBR>
    </cffunction>



    <cffunction name="eliminar" access="public" returntype="Any">
        <cfargument name="id_ClasificadoRequisicion" type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                  method="eliminar"
                  argumentcollection="#arguments#">
        
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>