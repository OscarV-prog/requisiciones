<cfcomponent extends="wiz/sucursales">

    <cffunction name="getById" access="public" returntype="Query">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="id_TipoRequisicion"   type="string" required="false">
        <cfargument name="id_Usuario"           type="string" required="false">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraById 
                                #arguments.id_Empresa#, 
                                #arguments.id_ordenDeCompra#,
                                <cfif isDefined("id_TipoRequisicion") AND #arguments.id_TipoRequisicion# NEQ ''>2<cfelse>NULL</cfif>,
                                <cfif isDefined("id_Usuario") >#arguments.id_Usuario#<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarCotizacionesparaAutorizarOrdenCompra" access="public" returntype="query">
       <cfargument name="id_Empresa"        type="numeric"      required="true"/>
       <cfargument name="id_OrdenCompra"     type="string"       required="false"/>

          <cfquery  name="Local.Cotizaciones" datasource="#variables.cnx#">
            exec upL_CotizacionesparaAutorizarOrdenCompra

                            #arguments.id_Empresa#,
            <cfif isDefined("Arguments.id_OrdenCompra") AND arguments.id_OrdenCompra NEQ ''>#Arguments.id_OrdenCompra#<cfelse>NULL</cfif>
                                                                                                       
          </cfquery>
        <cfreturn Local.Cotizaciones/>
    </cffunction>
      
</cfcomponent>