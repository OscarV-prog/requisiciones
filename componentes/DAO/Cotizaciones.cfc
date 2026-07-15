<cfcomponent extends="wiz/cotizaciones">

    <cffunction name="CotizacionnextID" access="public" returntype="string">
      <cfargument name="id_Empresa"      type="numeric"       required="true"/>

        <cfquery name="Local.Cotizacion" datasource="#variables.cnx#" >
            exec upR_CotizacionNextID
                                     #arguments.id_Empresa#
        </cfquery>

        <cfreturn Local.Cotizacion.nextID />
    </cffunction>

    <!--- funcion que devuelve los insumos a los que se les puede hacer orden de compra correspodiente a una  cotizacion, esto es pata la pantalla de cotizaciones
        05-11-2015--->
    <cffunction name="getinsumosrestantes" access="public" returntype="Query">
        <cfargument name='id_empresa'             type='numeric' required='yes'>
        <cfargument name='id_Cotizacion'      type='numeric' required='yes'>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_CotizacionesInsumosrestatantesacomprar
                #arguments.id_empresa#,
                #arguments.id_Cotizacion#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- funcion que verifica si la cotizacion tiene ordenes de compras--->
    <cffunction name="getordenescomprabycotizacion" access="public" returntype="Query">
        <cfargument name='id_empresa'       type='numeric' required='yes'>
        <cfargument name='id_cotizacion'    type='numeric' required='yes'>

        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            exec upR_OrdenesComprasbycotizacion
                #arguments.id_empresa#,
                #arguments.id_cotizacion#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="CotizacionDetallenextID" access="public" returntype="string">
        <cfargument name="id_Empresa"        type="numeric"       required="true"/>
        <cfargument name="id_Cotizacion"     type="numeric"       required="true"/>

        <cfquery name="Local.CotizacionDetalle" datasource="#variables.cnx#" >
            exec upR_CotizacionDetalleNextID
                                            #arguments.id_Empresa#,
                                            #arguments.id_Cotizacion#
        </cfquery>

        <cfreturn Local.CotizacionDetalle.nextID />
    </cffunction>

    <cffunction name="ObtenerImpuestos" access="public" returntype="query">
        <cfargument name="id_Empresa"                     type="numeric"       required="true"/>
        <cfargument name="id_Cotizacion"                  type="numeric"       required="true"/>

            <cfquery name="Local.CotizacionImpuestos" datasource="#variables.cnx#" >
                exec upL_CotizacionesImpuestos
                            #arguments.id_Empresa#,
                            #arguments.id_Cotizacion#
            </cfquery>
            <cfreturn Local.CotizacionImpuestos/>
    </cffunction>

    <cffunction name="listar" access="public" returntype="query">
       <cfargument name="id_SolicitudCompra"      type="string"       required="false"/>
       <cfargument name="fh_Inicio"               type="string"       required="false"/>
       <cfargument name="fh_Final"                type="string"       required="false"/>
       <cfargument name="id_Proveedor"            type="string"       required="false"/>
       <cfargument name="id_Empresa"              type="numeric"       required="true"/>

       <cfquery  name="Local.Cotizacion" datasource="#variables.cnx#">
          exec upL_Cotizaciones
            <cfif isDefined("Arguments.id_SolicitudCompra") AND arguments.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.fh_Inicio")         AND arguments.fh_Inicio NEQ ''>'#Arguments.fh_Inicio#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.fh_Final")          AND arguments.fh_Final NEQ ''>'#Arguments.fh_Final#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Proveedor")      AND arguments.id_Proveedor NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Empresa")        AND arguments.id_Empresa NEQ ''>#Arguments.id_Empresa#<cfelse>NULL</cfif>
      </cfquery>
        <cfreturn Local.Cotizacion/>
    </cffunction>

    <cffunction name="listarInformacionUsuario" access="public" returntype="query">
       <cfargument name="id_Empresa"      type="string"       required="false"/>
       <cfargument name="id_Cotizacion"      type="string"       required="false"/>

       <cfquery  name="Local.infoCoti" datasource="#variables.cnx#">
          exec upL_CotizacionesDatosCotizacion
                            #arguments.id_Empresa#,
                            #arguments.id_Cotizacion#

      </cfquery>
        <cfreturn Local.infoCoti/>
    </cffunction>

    <cffunction name="listarCotizacionesparaAutorizarOrdenCompra" access="public" returntype="query">
       <cfargument name="id_Empresa"        type="numeric"      required="true"/>
       <cfargument name="id_OrdenCompra"     type="string"       required="false"/>


        <!--- <cfoutput>dao</cfoutput>
       <cfdump var="#arguments#"><cfabort> --->
          <cfquery  name="Local.Cotizaciones" datasource="#variables.cnx#">
            exec upL_CotizacionesparaAutorizarOrdenCompra

                            #arguments.id_Empresa#,
            <cfif isDefined("Arguments.id_OrdenCompra") AND arguments.id_OrdenCompra NEQ ''>#Arguments.id_OrdenCompra#<cfelse>NULL</cfif>

          </cfquery>
        <cfreturn Local.Cotizaciones/>
    </cffunction>

    <!--- Autor: Julio Acosta --->
    <!--- Modificacion: Rey David Dominguez
          Fecha: 13/03/2015
          Se removio el nu_telefono de los argumentos --->
    <cffunction name="agregarCotizacion" access="public" returntype="any">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_ProveedorContacto"     type="numeric" required="true"/>
        <cfargument name="id_Usuario"               type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"       type="numeric" required="false"/>
        <cfargument name="id_Proveedor"             type="numeric" required="true"/>
        <cfargument name="fh_Requerida"             type="string"  required="false"/>
        <cfargument name="de_Comentarios"           type="string"  required="false"/>
        <cfargument name="id_sucursalSolicita"      type="string"  required="false"/>
        <cfargument name="id_departamentoSolicita"  type="string"  required="false"/>
        <cfargument name="tiporequisicion"          type="string"  required="false"/>


        <cfquery name="Local.RS" datasource="#variables.cnx#">
            exec upC_Cotizaciones
                                   #arguments.id_Empresa#,
                                    #arguments.id_Usuario#,
        <cfif isDefined("Arguments.id_SolicitudCompra") AND ARGUMENTS.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                                   #arguments.id_Proveedor#,
                                   #arguments.id_ProveedorContacto#,
                                   '#arguments.fh_Requerida#',
        <cfif isDefined("Arguments.de_Comentarios") AND Arguments.de_Comentarios NEQ ''>'#Arguments.de_Comentarios#'<cfelse>NULL</cfif>,
        <cfif isDefined("Arguments.id_sucursalSolicita") AND Arguments.id_sucursalSolicita NEQ ''>#Arguments.id_sucursalSolicita#<cfelse>NULL</cfif>,
        <cfif isDefined("Arguments.id_departamentoSolicita") AND Arguments.id_departamentoSolicita NEQ ''>#Arguments.id_departamentoSolicita#<cfelse>NULL</cfif>,
        <cfif isDefined("Arguments.tiporequisicion") AND Arguments.tiporequisicion NEQ ''>#Arguments.tiporequisicion#<cfelse>NULL</cfif>

        </cfquery>
        <cfreturn Local.RS.id_Cotizacion >
    </cffunction>

    <cffunction name="Editarsn_Elegida" access="public" returntype="void">
        <cfargument name="id_Cotizacion"            type="numeric" required="true"/>
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="de_Observaciones"         type="String" required="false"/>
        <cfargument name="sn_CotizacionElegida"     type="numeric" required="false"/>


            <cfquery datasource="#variables.cnx#">
                exec upU_Cotizacionessn_Elegida
                                       #arguments.id_Cotizacion#,
                                       #arguments.id_Empresa#,
                <cfif isDefined("Arguments.de_Observaciones") AND ARGUMENTS.de_Observaciones NEQ ''>"#Arguments.de_Observaciones#"<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_CotizacionElegida") AND ARGUMENTS.sn_CotizacionElegida NEQ ''>"#Arguments.sn_CotizacionElegida#"<cfelse>NULL</cfif>

            </cfquery>
    </cffunction>

    <!--- Autor: Julio Acosta --->
    <!--- Modificacion: Rey David Dominguez
          Fecha: 13/03/2015
          Se removio el nu_telefono de los argumentos, id_moneda e im_tipoCambio, se agregaron como nullables --->
    <cffunction name="agregarCotizacionDetalle" access="public" returntype="void">
        <cfargument name="id_Cotizacion"            type="numeric" required="true"/>
        <cfargument name="id_CotizacionDetalle"     type="numeric" required="true"/>
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"       type="numeric" required="false"/>
        <!--- <cfargument name="id_Proveedor"           type="numeric" required="true"/> --->
        <!--- <cfargument name="fh_Requerida"           type="string"  required="false"/> --->
        <!--- <cfargument name="de_Comentarios"             type="string"  required="false"/> --->
        <cfargument name="id_Insumo"                type="numeric" required="true"/>
        <cfargument name="nu_Cantidad"              type="numeric" required="true"/>
        <cfargument name="id_Moneda"                type="string" required="false"/>
        <cfargument name="im_TipoCambio"            type="string" required="false"/>


            <cfquery datasource="#variables.cnx#">
                exec upC_CotizacionesDetalle
                                       #arguments.id_Empresa#,
                                       #arguments.id_Cotizacion#,
                                       #arguments.id_CotizacionDetalle#,
                                       #arguments.id_Insumo#,
                                       #arguments.nu_Cantidad#,
                <cfif isDefined("arguments.id_Moneda")>#arguments.id_Moneda#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.im_TipoCambio")>#arguments.im_TipoCambio#<cfelse>NULL</cfif>

            </cfquery>
    </cffunction>

    <cffunction name="listarSolicitudesCompras" access="public" returntype="query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cfquery name="Local.SolicitudesCompras" datasource="#variables.cnx#" >
            exec upL_SolicitudesCompraPendientesDeComprar
                            #Arguments.id_Empresa#,
                            <cfif isDefined("fh_inicio") AND fh_inicio NEQ ''>'#fh_inicio#'<cfelse>NULL</cfif>,
                            <cfif isDefined("fh_fin") AND fh_fin NEQ ''>'#fh_fin#'<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.SolicitudesCompras/>
    </cffunction>

    <cffunction name="listarBySolicitudCompra" access="public" returntype="query">
        <cfargument name="id_empresa"         type="string" required="true"/>
        <cfargument name="id_SolicitudCompra" type="string" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_CotizacionesBySolicitudCompra #Arguments.id_empresa#,#Arguments.id_SolicitudCompra#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="updateNameFile" access="public" returntype="void">
        <cfargument name="id_empresa"      type="numeric" required="true"/>
        <cfargument name="id_Cotizacion"   type="numeric" required="true"/>
        <cfargument name="nb_archivo"      type="string"  required="false"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upU_CotizacionesArchivo #Arguments.id_empresa#,
                                         #Arguments.id_Cotizacion#,
                <cfif isDefined("Arguments.nb_archivo")>'#Arguments.nb_archivo#'<cfelse>NULL</cfif>
        </cfquery>
    </cffunction>

    <cffunction name="updateFechaEImporte" access="public" returntype="void">
        <cfargument name="id_empresa"           type="string"  required="true"/>
        <cfargument name="id_Cotizacion"        type="numeric" required="true"/>
        <cfargument name="fh_posibleEntrega"    type="string"  required="false"/>
        <cfargument name="id_moneda"            type="string" required="false"/>
        <cfargument name="im_subTotal"          type="string" required="false"/>
        <cfargument name="im_descuento"         type="string" required="false"/>
        <cfargument name="im_total"             type="string" required="false"/>
        <cfargument name="sn_cotizacionElegida" type="string" required="true"/>
        <cfargument name="de_comentarios"       type="string" required="false"/>
        <cfargument name="im_Envio"             type="numeric"  required="false"/>
        <cfargument name="id_TipoComprobante"   type="string"  required="false" default=""/>

        <cfif not isDefined('Arguments.im_Envio')>
            <cfset Arguments.im_Envio = 0>
        </cfif>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upU_CotizacionesFechaEImporte #Arguments.id_empresa#,
                                               #Arguments.id_Cotizacion#,
                <cfif isDefined("Arguments.fh_posibleEntrega")>'#Arguments.fh_posibleEntrega#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.im_subTotal")>#Arguments.im_subTotal#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.im_descuento")>#Arguments.im_descuento#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.im_total")>#Arguments.im_total#<cfelse>NULL</cfif>,
                                              #Arguments.sn_cotizacionElegida#,
                <cfif isDefined("Arguments.de_comentarios")>'#Arguments.de_comentarios#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_moneda")>#Arguments.id_moneda#<cfelse>NULL</cfif>,
                <cfif isNumeric(Arguments.im_Envio)>#Arguments.im_Envio#<cfelse>NULL</cfif>,
                <cfif isNumeric(Arguments.id_TipoComprobante)>#Arguments.id_TipoComprobante#<cfelse>NULL</cfif>

        </cfquery>
    </cffunction>

    <!--- julio cesar acosta lopez 19/08/2015 funcion para editar los comentarios,si es elegida la cotizacion--->
    <cffunction name="updateComentarioElegida" access="public" returntype="void">
        <cfargument name="id_empresa"           type="string"  required="true"/>
        <cfargument name="id_Cotizacion"        type="numeric" required="true"/>
        <cfargument name="sn_cotizacionElegida" type="string" required="true"/>
        <cfargument name="de_comentarios"       type="string" required="false"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upU_CotizacionesComentariosElegida
                                    #Arguments.id_empresa#,
                                    #Arguments.id_Cotizacion#,
                                    #Arguments.sn_cotizacionElegida#,
                <cfif isDefined("Arguments.de_comentarios")>'#Arguments.de_comentarios#'<cfelse>NULL</cfif>
        </cfquery>
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="void">
        <cfargument name="id_empresa"      type="string"  required="true"/>
        <cfargument name="id_Cotizacion"   type="numeric" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upD_Cotizaciones   #Arguments.id_empresa#,
                                    #Arguments.id_Cotizacion#
        </cfquery>
    </cffunction>


    <cffunction name="EditarDetalleInsumos" access="public" returntype="void">
        <cfargument name="id_Empresa"           type="numeric" required="true">
        <cfargument name='id_Cotizacion'        type='numeric' required='true'>
        <cfargument name='id_CotizacionDetalle' type='numeric' required='true'>


        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upU_CotizacionesDetalleInsumos
                                    #Arguments.id_empresa#,
                                    #Arguments.id_Cotizacion#,
                                    #Arguments.id_CotizacionDetalle#,
                                    #Arguments.id_CampoDetalle#,
                                    '#Arguments.nb_CampoDetalle#',
                                    '#Arguments.de_ValorCampoDetalle#'


        </cfquery>
    </cffunction>

    <cffunction name="getComparativaCotizaciones" access="public" returntype="query">
        <cfargument name='id_Empresa'          type='numeric' required='true'>
        <cfargument name='id_SolicitudCompra'  type='numeric' required='true'>

        <cfstoredproc procedure="upL_CotizacionesComparativa" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#" > 
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_SolicitudCompra"    value="#arguments.id_SolicitudCompra#" >
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
