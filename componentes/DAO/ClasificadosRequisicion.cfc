<cfcomponent extends="wiz/sucursales">

    <cffunction name="nextID" access="public" returntype="string">
        <cfquery datasource="#variables.cnx#" name="Local.ClasificadoRequisicion">
            exec upR_ClasificadoRequisicionNextID
        </cfquery>

        <cfreturn Local.ClasificadoRequisicion.nextID />
    </cffunction>


    <cffunction name="existeClasificadoRequisicion" access="public" returntype="boolean">
        <cfargument name="id_ClasificadoRequisicion"        type="numeric" required="true"/>
        <cfargument name="de_ClasificadoRequisicion"        type="string" required="true"/>
    
        <cfquery name="Local.ClasificadoRequisicion" datasource="#variables.cnx#" >
            exec upR_ClasificadoRequisicionExist #Arguments.id_ClasificadoRequisicion#,'#Arguments.de_ClasificadoRequisicion#'
        </cfquery>

        <cfreturn Local.ClasificadoRequisicion.isExists/>
    </cffunction>


    <cffunction name="agregar" access="public" returntype="void">
      <cfargument name="id_ClasificadoRequisicion"    type="numeric" required="true"/>  
      <cfargument name="de_ClasificadoRequisicion"    type="string" required="true"/>
      <cfargument name="id_TipoRequisicion"           type="numeric" required="true"/>
      <cfargument name="sn_Activo"                    type="string" required="false"/>

        <cfquery datasource="#variables.cnx#">
            exec upC_ClasificadoRequisicion #Arguments.id_ClasificadoRequisicion#,
                            '#Arguments.de_ClasificadoRequisicion#',
                             #Arguments.id_TipoRequisicion#,
            <cfif isDefined("Arguments.sn_Activo")        AND ARGUMENTS.sn_Activo   NEQ ''>
                <cfif ARGUMENTS.sn_Activo EQ 'YES'>
                    1
                <cfelse>
                    0
                </cfif>
            <cfelse>
                NULL
            </cfif>
        </cfquery>
    </cffunction>
    

    <cffunction name="editar" access="public" returntype="void">
    <cfargument name="id_ClasificadoRequisicion"      type="numeric" required="true"/>  
    <cfargument name="de_ClasificadoRequisicion"      type="string" required="true"/>
    <cfargument name="id_TipoRequisicion"         type="numeric" required="true"/>
    <cfargument name="sn_Activo"                      type="string" required="false"/>
        
        <!--- <cfoutput>MODUOS - Editar - Dao</cfoutput>
        <cfdump var="#arguments#">
        <cfabort>  --->

        <cfquery datasource="#variables.cnx#">
            exec upU_ClasificadoRequisicion 
                              #Arguments.id_ClasificadoRequisicion#,
                              '#de_ClasificadoRequisicion#',
                              #Arguments.id_TipoRequisicion#,
            <cfif isDefined("Arguments.sn_Activo")        AND ARGUMENTS.sn_Activo   NEQ ''>  
                  <cfif #Arguments.sn_Activo# EQ 'YES'>
                        1
                     <cfelse>
                        0
                  </cfif>
              <cfelse>
                NULL
            </cfif>                           
        </cfquery>
    </cffunction>
 

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_ClasificadoRequisicion"   type="string" required="false"/>
        <cfargument name="de_ClasificadoRequisicion"   type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"          type="string" required="false"/>
        <cfargument name="sn_Activo"                   type="string" required="false"/>
        
        <cfquery  name="Local.ClasificadoRequisicion" datasource="#variables.cnx#">
            exec upL_ClasificadoRequisicion
            <cfif isDefined("Arguments.id_ClasificadoRequisicion") AND ARGUMENTS.id_ClasificadoRequisicion NEQ ''>#Arguments.id_ClasificadoRequisicion#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.de_ClasificadoRequisicion") AND ARGUMENTS.de_ClasificadoRequisicion NEQ ''>'#Arguments.de_ClasificadoRequisicion#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_TipoRequisicion") AND ARGUMENTS.id_TipoRequisicion NEQ ''>#Arguments.id_TipoRequisicion#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.sn_Activo")>#Arguments.sn_Activo#<cfelse>NULL</cfif>
        </cfquery>
        <cfreturn Local.ClasificadoRequisicion/>
    </cffunction>


    
    <cffunction name="listar_TiposRequisicion" access="public" returntype="query">
        <cfquery name="Local.TiposRequisicion" datasource="#variables.cnx#" >
            exec upLC_TiposRequisicion 
        </cfquery>
        <cfreturn Local.TiposRequisicion/>
    </cffunction>



    <cffunction name="eliminar" access="public" returntype="void">
        <cfargument name="id_ClasificadoRequisicion"        type="numeric" required="true"/>

        <cfquery name="Local.ClasificadoRequisicion" datasource="#variables.cnx#" >
            exec upD_ClasificadoRequisicion #Arguments.id_ClasificadoRequisicion#
        </cfquery>
    </cffunction>

    <cffunction name="getComboClasificadosOrdenesTrabajo" access="public" returntype="query">
            <cfstoredproc procedure="upL_Clasificados_OrdenesTrabajo" datasource="#variables.cnx#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
            <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>