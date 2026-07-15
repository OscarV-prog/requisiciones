<cfcomponent extends="wiz/OrdenesDeCompra">

    <cffunction name="getByEmpresa" returntype="Query">
        <cfargument name="id_empresa" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
        </cfquery>
    </cffunction>

    <cffunction name="leer_CorreoComprador" access="public" returntype="Query">
        <cfargument name="id_Empresa"       type="numeric" required="true">
        <cfargument name="id_OrdenDeCompra" type="numeric" required="true">
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            EXECUTE upR_OrdenesDeCompra_CorreoComprador
                            @id_Empresa         = #arguments.id_Empresa#,
                            @id_OrdenDeCompra   = #arguments.id_OrdenDeCompra#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="getById" access="public" returntype="Query">
        <cfargument name="id_empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="id_TipoRequisicion"   type="string" required="false">
        <cfargument name="id_Usuario"           type="string" required="false">


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraById
                                #arguments.id_empresa#,
                                #arguments.id_ordenDeCompra#,
                                <cfif isDefined("id_TipoRequisicion") AND #arguments.id_TipoRequisicion# NEQ ''>2<cfelse>NULL</cfif>,
                                <cfif isDefined("id_Usuario") >#arguments.id_Usuario#<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getById_UsuariosAutorizan" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="id_TipoRequisicion"   type="string" required="false">
        <cfargument name="id_Usuario"           type="string" required="false">

        <cfstoredproc procedure="upR_OrdenesDeCompraById_UsuariosAutoriacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"           value="#arguments.id_empresa#"          null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ordenDeCompra"     value="#arguments.id_ordenDeCompra#"    null="#iif(isNumeric(arguments.id_ordenDeCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoRequisicion"   value="#arguments.id_TipoRequisicion#"  null="#iif(len(arguments.id_TipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Usuario"           value="#arguments.id_Usuario#"          null="#iif(len(arguments.id_Usuario),false,true)#">
            <cfprocresult name="local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Victor Sanchez
            24/12/2015
        trae la cabezera de la SalidaPorDevolucion a proveedor por su Factura
        --->
    <cffunction name="getByFolio" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_sucursal" type="string" required="true">
        <cfargument name="folio" type="string" required="true">


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_SalidaPorDevolucionMaster
                                #arguments.id_empresa#,
                                #id_sucursal#,
                                '#folio#'
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

<!--- Victor Sanchez
        24/12/2015
        trae el detalle de la Salida Por devolucion a proveedor
 --->
    <cffunction name="getByFolioOCDetalle" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="folio" type="string" required="true"/>

        <!--- <cfdump var="#arguments#"><cfabort> --->
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_SalidaPorDevolucionDetalle
                #arguments.id_empresa#,
                #arguments.id_sucursal#,
                '#folio#'
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getinsumosexistentesenordenescomprabycotizacion" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_cotizacion" type="string" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompragetinsumosexistentesbycotizacion
                                #arguments.id_empresa#,
                                <cfif isDefined("arguments.id_cotizacion") AND #arguments.id_cotizacion# NEQ ''>#arguments.id_cotizacion#<cfelse>NULL</cfif>

        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getByIdProveedor" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true">
        <!--- En algunas pantallas id_proveedor no es requerido --->
        <cfargument name="id_Proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraByIdProveedor
                        '#arguments.id_empresa#',
                         #SESSION.ID_SUCURSAL#,
                         #session.ID_ALMACEN#,
                    <cfif isDefined("arguments.id_Proveedor") AND #arguments.id_Proveedor# NEQ ''>#arguments.id_Proveedor#<cfelse>NULL</cfif>,
                    <cfif Not IsDefined('arguments.fh_inicio')>NULL<cfelse>'#fh_inicio#'</cfif>,
                    <cfif Not IsDefined('arguments.fh_fin')>NULL<cfelse>'#fh_fin#'</cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="quienAutoriza" access="public" returntype="Query">
        <cfargument name="id_Empresa"   type="numeric" required="true">
        <cfargument name="Total"        type="numeric" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_AutorizacionOrdenCompra
                        #arguments.Total#,
                        #arguments.id_Empresa#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getDetalleDesglosado" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_almacen" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true"/>
        <cfargument name="sn_ParaEntrada" type="boolean" required="false" default="false">
        <!--- <cfdump var="#arguments#"><cfabort> --->
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraDetalleInsumosDetallado
                #arguments.id_empresa#,
                #arguments.id_sucursal#,
                <cfif isDefined("arguments.id_almacen") AND arguments.id_almacen NEQ ''>#arguments.id_almacen#<cfelse>NULL</cfif>,
                #arguments.id_ordenDeCompra#,
                <cfif Arguments.sn_ParaEntrada> 1 <cfelse> 0 </cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>
    
    <cffunction name="getDetalle" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_almacen" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true"/>
        <cfargument name="sn_ParaEntrada" type="boolean" required="false" default="false">
        <!--- <cfdump var="#arguments#"><cfabort> --->
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraDetalleInsumos
                #arguments.id_empresa#,
                #arguments.id_sucursal#,
                <cfif isDefined("arguments.id_almacen") AND arguments.id_almacen NEQ ''>#arguments.id_almacen#<cfelse>NULL</cfif>,
                #arguments.id_ordenDeCompra#,
                <cfif Arguments.sn_ParaEntrada> 1 <cfelse> 0 </cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="getDetalleExistencias" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_almacen" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true"/>

        <!--- <cfdump var="#arguments#"><cfabort> --->
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraDetalleInsumosExistencias
                #arguments.id_empresa#,
                #arguments.id_sucursal#,
                <cfif isDefined("arguments.id_almacen") AND arguments.id_almacen NEQ ''>#arguments.id_almacen#<cfelse>NULL</cfif>,
                #arguments.id_ordenDeCompra#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- 12/09/2015
        funcion que trae los insumos por surtir de devolucion al proveedor julius julius julius julius... etc. XD --->
    <cffunction name="getDetalleinsumospordevolucion" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true"/>
        <cfargument name="id_sucursal" type="string" required="true"/>
        <cfargument name="id_almacen" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true"/>

        <!--- <cfdump var="#arguments#"><cfabort> --->
        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraDetalleInsumosdevolucion
                #arguments.id_empresa#,
                #arguments.id_sucursal#,
                <cfif isDefined("arguments.id_almacen") AND arguments.id_almacen NEQ ''>#arguments.id_almacen#<cfelse>NULL</cfif>,
                #arguments.id_ordenDeCompra#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <!---
        Autor: Mario Mejia
        fecha: 19/03/2015
        Desc:  Funcion que verificara en la tabla OrdenesDeCompraDetalle si el estatus para OrdenDeCompra esta surtida, surtidaParcial o sin surtir
    --->
    <cffunction name="validarEstatusSurtido" access="public" returntype="numeric">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">

        <cfquery name="Local.Conteo" datasource="#variables.cnx#">
            exec upR_OrdenesDeCompraDetalleCountEstatus
                                #arguments.id_empresa#,
                                #arguments.id_ordenDeCompra#
        </cfquery>

        <cfif Local.Conteo.surtidoCompleto EQ Local.Conteo.total>
            <cfset Local.estatus = 1>
            <cfreturn local.estatus>

        <cfelseif Local.conteo.PendienteDevoluciones GT 0>
            <cfset local.estatus = 4>
            <cfreturn local.estatus>

        <cfelseif local.conteo.canceladoCompleto EQ local.conteo.total>
            <cfset local.estatus = 6>
            <cfreturn local.estatus>

        <cfelseif Local.conteo.canceladoParcial GT 0 OR (Local.Conteo.canceladoCompleto GT 0 AND Local.Conteo.canceladoCompleto LT Local.conteo.total)>
            <cfset local.estatus = 5>
            <cfreturn local.estatus>

        <cfelseif Local.Conteo.surtidoParcial GT 0 OR (Local.Conteo.surtidoCompleto GT 0 AND Local.Conteo.surtidoCompleto LT Local.Conteo.total)>
            <cfset Local.estatus = 2>
            <cfreturn local.estatus>

        <cfelseif Local.Conteo.surtidoCompleto EQ 0 AND Local.Conteo.surtidoParcial EQ 0>
            <cfset Local.estatus = 3>
            <cfreturn local.estatus>

        </cfif>
    </cffunction>

    <!---
        Autor: Mario Mejia
        fecha: 19/03/2015
        Desc:  Funcion que actualiza el valor del estatus surtido de la tabla ordenes de compra
    --->
    <!--- <cffunction name="set_Id_estatusSurtido" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="id_EstatusSurtido" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upU_OrdenesDeCompraSetEstatusSurtido
                                    #arguments.id_empresa#,
                                    #arguments.id_ordenDeCompra#,
                                    #arguments.id_EstatusSurtido#
        </cfquery>
    </cffunction> --->
    <cffunction name="set_Id_estatusSurtido" access="public" returntype="any">
        <cfargument name="id_empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="id_EstatusSurtido"    type="string" required="true">
        <cfargument name="de_Descripcion"       type="string" required="false">

        <cfstoredproc procedure="upU_OrdenesDeCompraSetEstatusSurtido" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"           value="#arguments.id_empresa#"          null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ordenDeCompra"     value="#arguments.id_ordenDeCompra#"    null="#iif(isNumeric(arguments.id_ordenDeCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"    value="#arguments.id_EstatusSurtido#"   null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Descripcion"       value="#arguments.de_Descripcion#"      null="#iif(len(arguments.de_Descripcion),false,true)#">
        </cfstoredproc>
    </cffunction>

    <!---
        Autor: Mario Mejia
        fecha: 25/03/2015
        Desc:  Funcion que devuelve las ordenes que no estan surtidas completamente
    --->
    <cffunction name="getOrdenesSinSurtir" access="public" returntype="query">
        <cfargument name="id_empresa" type="numeric" required="false">
        <cfargument name="id_sucursal" type="numeric" required="false">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraGetOrdenesSinSurtir
                    <cfif Not isDefined("id_empresa")> NULL<cfelse>#id_empresa#</cfif>,
                    <cfif Not isDefined("id_sucursal")> NULL<cfelse>#id_sucursal#</cfif>,
                    <cfif Not IsDefined('arguments.nb_proveedor') OR arguments.nb_proveedor EQ '' >NULL<cfelse>'#nb_proveedor#'</cfif>,
                    <cfif Not IsDefined('arguments.fh_inicio') OR arguments.fh_inicio EQ '' >NULL<cfelse>'#fh_inicio#'</cfif>,
                    <cfif Not IsDefined('arguments.fh_fin') OR arguments.fh_fin EQ '' >NULL<cfelse>'#fh_fin#'</cfif>
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <cffunction name="getOrdenesSinSurtirDevolucion" access="public" returntype="query">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_sucursal" type="numeric" required="true">
        <cfargument name="id_almacen" type="numeric" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_OrdenesDeCompraGetOrdenesSinSurtirDevolucion
                    #arguments.id_empresa#,
                    #arguments.id_sucursal#,
                    #arguments.id_almacen#,
                    <cfif Not IsDefined('arguments.nb_proveedor')>''<cfelse>'#nb_proveedor#'</cfif>,
                    <cfif Not IsDefined('arguments.fh_inicio')>NULL<cfelse>'#fh_inicio#'</cfif>,
                    <cfif Not IsDefined('arguments.fh_fin')>NULL<cfelse>'#fh_fin#'</cfif>
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <cffunction name="set_fh_ultimaEntrega" access="public" returntype="void">
        <cfargument name="id_empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">
        <cfargument name="fh_ultimaEntrega" type="string" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upU_OrdenesDeCompraSetFechaUltimaEntrega
                                    #arguments.id_empresa#,
                                    #arguments.id_ordenDeCompra#,
                                    '#arguments.fh_ultimaEntrega#'
        </cfquery>
    </cffunction>

    <cffunction name="getOrdenesIncumplidas" access="public" returntype="query">
        <cfargument name="id_empresa"                    type="string" required="false"/>
        <cfargument name="id_sucursal"                    type="string" required="false"/>
        <cfargument name="id_Proveedor"                   type="string" required="false"/>
        <cfargument name="id_Departamento"                type="string" required="false"/>
        <cfargument name="id_Almacen"                     type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="id_insumo"                      type="string" required="false"/>
        <cfargument name="id_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfargument name="fh_inicio"                      type="string" required="false"/>
        <cfargument name="fh_fin"                         type="string" required="false"/>

            <cfstoredproc procedure="upL_ordenesDeCompraIncumplimientoPorProveedor" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                     value="#arguments.id_Empresa#"                     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                    value="#arguments.id_Sucursal#"                    null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"                   value="#arguments.id_Proveedor#"                   null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"                value="#arguments.id_Departamento#"                null="#iif(isNumeric(arguments.id_Departamento),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"                     value="#arguments.id_Almacen#"                     null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"               value="#arguments.id_FamiliaInsumo#"               null="#iif(isNumeric(arguments.id_FamiliaInsumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo"            value="#arguments.id_SubFamiliaInsumo#"            null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_insumo"                      value="#arguments.id_insumo#"                      null="#iif(isNumeric(arguments.id_insumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_estatusSurtidoOrdenDeCompra" value="#arguments.id_estatusSurtidoOrdenDeCompra#" null="#iif(isNumeric(arguments.id_estatusSurtidoOrdenDeCompra),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"          dbvarname="@fh_inicio"                      value="#arguments.fh_inicio#"                      null="#iif(len(arguments.fh_inicio),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"          dbvarname="@fh_fin"                         value="#arguments.fh_fin#"                         null="#iif(len(arguments.fh_fin),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn local.RS>
    </cffunction>

    <cffunction name="listadoControl" access="public" returntype="query">
        <cfargument name="id_Empresa"             type="string" required="false">
        <cfargument name="id_Sucursal"            type="string" required="false">
        <cfargument name="id_usuario"             type="numeric" required="true">
        <cfargument name="id_ordenDeCompra"       type="string" required="false">
        <cfargument name="fh_inicio"              type="string" required="false">
        <cfargument name="fh_fin"                 type="string" required="false">
        <cfargument name="id_proveedor"           type="string" required="false">
        <cfargument name="id_estatusAutorizacion" type="string" required="false">
        <cfargument name="id_estatusSurtido"      type="string" required="false">
        <cfargument name="page"                   type="string" required="false" default=0>
        <cfargument name="pageSize"               type="string" required="false" default=0>
        <cfargument name="id_SolicitudCompra"     type="string" required="false">
        <cfargument name="id_Requisicion"         type="string" required="false">
        <cfargument name="id_TipoDivision"        type="string" required="false">
        <cfargument name="sn_Reporte"             type="string" required="false" default=0>
        <cfargument name="nu_Siniestro"             type="string" required="false">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_OrdenesDeCompraControlListado
                    <cfif isDefined('Arguments.id_Empresa')>#Arguments.id_Empresa#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_Sucursal')>#Arguments.id_Sucursal#<cfelse>NULL</cfif>,
                    #Arguments.id_usuario#,
                    <cfif isDefined('Arguments.id_ordenDeCompra')>#Arguments.id_ordenDeCompra#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.fh_inicio')>'#Arguments.fh_inicio#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.fh_fin')>'#Arguments.fh_fin#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_proveedor')>'#Arguments.id_proveedor#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_estatusAutorizacion')>#Arguments.id_estatusAutorizacion#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_estatusSurtido')>#Arguments.id_estatusSurtido#<cfelse>NULL</cfif>,
                    #page#,
                    #pageSize#,
                    <cfif isDefined('Arguments.id_SolicitudCompra')>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_Requisicion')>#Arguments.id_Requisicion#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_TipoDivision')>#Arguments.id_TipoDivision#<cfelse>NULL</cfif>,
                    #sn_Reporte#,
                    <cfif isDefined('Arguments.nu_Siniestro')>'#Arguments.nu_Siniestro#'<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn local.RS>
    </cffunction>

    <cffunction name="listadoControlExcel" access="public" returntype="any">
        <cfargument name="id_Empresa"             type="string" required="false">
        <cfargument name="id_Sucursal"            type="string" required="false">
        <cfargument name="id_usuario"             type="numeric" required="true">
        <cfargument name="id_ordenDeCompra"       type="string" required="false">
        <cfargument name="fh_inicio"              type="string" required="false">
        <cfargument name="fh_fin"                 type="string" required="false">
        <cfargument name="id_proveedor"           type="string" required="false">
        <cfargument name="id_estatusAutorizacion" type="string" required="false">
        <cfargument name="id_estatusSurtido"      type="string" required="false">
        <cfargument name="id_SolicitudCompra"     type="string" required="false">
        <cfargument name="id_Requisicion"         type="string" required="false">
        <cfargument name="id_TipoDivision"        type="string" required="false">
        <cfargument name="nu_Siniestro"           type="string" required="false">

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_OrdenesDeCompraControlListadoExcel
                    <cfif isDefined('Arguments.id_Empresa')>#Arguments.id_Empresa#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_Sucursal')>#Arguments.id_Sucursal#<cfelse>NULL</cfif>,
                    #Arguments.id_usuario#,
                    <cfif isDefined('Arguments.id_ordenDeCompra')>#Arguments.id_ordenDeCompra#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.fh_inicio')>'#Arguments.fh_inicio#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.fh_fin')>'#Arguments.fh_fin#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_proveedor')>'#Arguments.id_proveedor#'<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_estatusAutorizacion')>#Arguments.id_estatusAutorizacion#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_estatusSurtido')>#Arguments.id_estatusSurtido#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_SolicitudCompra')>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_Requisicion')>#Arguments.id_Requisicion#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.id_TipoDivision')>#Arguments.id_TipoDivision#<cfelse>NULL</cfif>,
                    <cfif isDefined('Arguments.nu_Siniestro')>'#Arguments.nu_Siniestro#'<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn local.RS>
    </cffunction>


    <cffunction name="AgregarOrdenCompra" access="public" returntype="any">
        <cfargument name="id_Empresa"                          type="numeric" required="yes">
        <cfargument name="id_Cotizacion"                       type="string"  required="no">
        <cfargument name="fh_RegistroOrdenCompra"              type="date"    required="yes">
        <cfargument name="fh_EntregaProbable"                  type="date"    required="no">
        <cfargument name="id_UsuarioRegistroOrdenCompra"       type="string"  required="yes">
        <cfargument name="id_EstatusSurtido"                   type="string"  required="yes">
        <cfargument name="id_Proveedor"                        type="string"  required="yes">
        <cfargument name="id_ProveedorContacto"                type="string"  required="yes">
        <cfargument name="id_moneda"                           type="string"  required="no">
        <cfargument name="im_SubTotal"                         type="string"  required="no">
        <cfargument name="im_Descuento"                        type="string"  required="no">
        <cfargument name="im_Total"                            type="string"  required="no">
        <cfargument name="id_EstatusAutorizacionOrdenDeCompra" type="string"  required="no">
        <cfargument name="im_Envio"                            type="numeric" required="no" default="0">
        <cfargument name="de_observaciones"                    type="string"  required="false"/>
        <cfargument name="sn_CorreoProveedor"                  type="string"  required="false"/>
        <cfargument name="sn_DescuentoNC"                      type="string"  required="false"/>

        <cfstoredproc procedure="upC_OrdenesDeCompra_Agregar" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                          value="#arguments.id_Empresa#"                          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Cotizacion"                       value="#arguments.id_Cotizacion#"                       null="#iif(len(arguments.id_Cotizacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_RegistroOrdenCompra"              value="#arguments.fh_RegistroOrdenCompra#"              null="#iif(len(arguments.fh_RegistroOrdenCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_EntregaProbable"                  value="#arguments.fh_EntregaProbable#"                  null="#iif(len(arguments.fh_EntregaProbable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioRegistroOrdenCompra"       value="#arguments.id_UsuarioRegistroOrdenCompra#"       null="#iif(isNumeric(arguments.id_UsuarioRegistroOrdenCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtido"                   value="#arguments.id_EstatusSurtido#"                   null="#iif(isNumeric(arguments.id_EstatusSurtido),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"                        value="#arguments.id_Proveedor#"                        null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorContacto"                value="#arguments.id_ProveedorContacto#"                null="#iif(isNumeric(arguments.id_ProveedorContacto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_SubTotal"                         value="#arguments.im_SubTotal#"                         null="#iif(len(arguments.im_SubTotal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_Descuento"                        value="#arguments.im_Descuento#"                        null="#iif(len(arguments.im_Descuento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_Total"                            value="#arguments.im_Total#"                            null="#iif(len(arguments.im_Total),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacionOrdenDeCompra" value="#arguments.id_EstatusAutorizacionOrdenDeCompra#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionOrdenDeCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_moneda"                           value="#arguments.id_moneda#"                           null="#iif(isNumeric(arguments.id_moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@im_Envio"                            value="#arguments.im_Envio#"                            null="#iif(isNumeric(arguments.im_Envio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_observaciones"                    value="#arguments.de_observaciones#"                    null="#iif(len(arguments.de_observaciones),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@sn_CorreoProveedor"                  value="#arguments.sn_CorreoProveedor#"                  null="#iif(len(arguments.sn_CorreoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_DescuentoNC"                      value="#arguments.sn_DescuentoNC#"                      null="#iif(isNumeric(arguments.sn_DescuentoNC),false,true)#">
            <cfprocresult name="local.RS" resultset="1">
        </cfstoredproc>

        <cfreturn local.RS.id_OrdenDeCompra>
    </cffunction>

    <cffunction name="SubirRutaArchivoAutorizacion" access="public" returntype="any">
        <cfargument name="id_Empresa"       type="numeric"  required="true"/>
        <cfargument name="id_OrdenCompra"   type="numeric"  required="true"/>
        <cfargument name="nombre"           type="string"   required="false"/>
        <cfargument name="ruta"             type="string"   required="true"/>

        <cfstoredproc procedure="upU_OrdenesDeCompraActualizarRuta" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"       value="#arguments.id_empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"   value="#arguments.id_OrdenCompra#"  null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_nombre"        value="#arguments.nombre#"          null="#iif(len(arguments.nombre),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_ruta"          value="#arguments.ruta#"          null="#iif(len(arguments.ruta),false,true)#">
            <cfprocresult name="local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn local.rs>
    </cffunction>
    

    <cffunction name="upR_DetalleRequisicionByOCD" access="public" returntype="struct">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_ordenDeCompra" type="string" required="true">

        <cfstoredproc procedure="upR_DetalleRequisicionByOCD" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"       value="#arguments.id_empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ordenCompra" value="#arguments.id_ordenDeCompra#"  null="#iif(isNumeric(arguments.id_ordenDeCompra),false,true)#">
            <cfprocresult name="Local.rs.DetalleReq" resultset="1">
            <cfprocresult name="local.rs.DetalleReqDuplicados" resultset="2">
        </cfstoredproc>

        <!--- <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upR_DetalleRequisicionByOCD
                                #arguments.id_empresa#,
                                #arguments.id_ordenDeCompra#
        </cfquery> --->

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getOCImprimir" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_ordenDeCompra" type="string" required="true">

        <cfstoredproc procedure="upR_OrdenesDeCompraImpresion" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"       null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra" value="#arguments.id_OrdenDeCompra#" null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="MarcarSolicitudCompra" access="public" returntype="void">
        <cfargument name="id_SolicitudCompra"           type="string" required="true">
        <cfargument name="id_Empresa"                   type="string" required="true">
        <cfargument name="sn_Comprar"                   type="string" required="true">


        <cfstoredproc procedure="upR_SolicitudCompraMarcarComprar" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                   value="#arguments.id_Empresa#"                  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitudCompra"           value="#arguments.id_SolicitudCompra#"          null="#iif(isNumeric(arguments.id_SolicitudCompra),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Comprar"                   value="#arguments.sn_Comprar#"                  null="#iif(isNumeric(arguments.sn_Comprar),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ObservacionesNoComprar"    value="#arguments.de_ObservacionesNoComprar#"   null="#iif(Len(arguments.de_ObservacionesNoComprar),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
    </cffunction>

    <!--- <cffunction name="agregarOrdenesDeCompraMovimientos" access="public" returntype="void">
        <cfargument name="id_Empresa"                   type="string" required="true">
        <cfargument name="id_OrdenDeComprar"            type="string" required="true">
        <cfargument name="id_EmpresaEmpleado"           type="string" required="true">
        <cfargument name="id_Empleado"                  type="string" required="true">

        <cfstoredproc procedure="upC_OrdenesDeCompraMovimientos" datasource="#variables.cnx#">
                <cfprocparam  type="IN"       cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#"                     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam  type="IN"       cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitudCompra"        value="#arguments.id_SolicitudCompra#"                    null="#iif(isNumeric(arguments.id_SolicitudCompra),false,true)#">
                <cfprocparam  type="IN"       cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado"        value="#arguments.sn_Comprar#"                                  null="#iif(isNumeric(arguments.sn_Comprar),false,true)#">
                <cfprocparam  type="IN"       cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Empleado"            value="#arguments.de_ObservacionesNoComprar#"      null="#iif(Len(arguments.de_ObservacionesNoComprar),false,true)#">
            </cfstoredproc>
    </cffunction> --->

    <cffunction name="agregarOrdenesDeCompraMovimientos" access="public" returntype="any">
        <cfargument name="id_Empresa"                   type="string" required="true">
        <cfargument name="id_OrdenDeCompra"         type="string" required="true">
        <cfargument name="id_EmpresaEmpleado"           type="string" required="true">
        <cfargument name="id_Empleado"                  type="string" required="true">

        <cfquery datasource="#variables.cnx#" name="Local.rs">

            exec upC_OrdenesDeCompraMovimientos
                                #arguments.id_empresa#,
                                #arguments.id_ordenDeCompra#,
                                #arguments.id_EmpresaEmpleado#,
                                #arguments.id_Empleado#
        </cfquery>
    </cffunction>

    <cffunction name="getById_Surtir" access="public" returntype="Query">
      <cfargument name="id_empresa"           type="string" required="true">
      <cfargument name="id_Sucursal"          type="string" required="false">
      <cfargument name="id_ordenDeCompra"     type="string" required="true">
      <cfargument name="id_Usuario"           type="string" required="false">
      <cfargument name="id_TipoRequisicion"   type="string" required="false">

      <cfquery datasource="#variables.cnx#" name="Local.rs">
          exec upR_OrdenesDeCompraById_Surtir
                              #arguments.id_empresa#,
                              #arguments.id_ordenDeCompra#,
                              #arguments.id_TipoRequisicion#,
                              <cfif isDefined("id_Usuario") >#arguments.id_Usuario#<cfelse>NULL</cfif>,
                              #arguments.id_Sucursal#
      </cfquery>

      <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="getOCImprimirConta" access="public" returntype="Query">
    <cfargument name="id_empresa" type="string" required="true">
    <cfargument name="id_ordenDeCompra" type="string" required="true">

    <!--- <cfcontent type="text/html">
            <cfdump var="#arguments#" format="simple" label="arguments" abort="true"> --->

    <cfstoredproc procedure="upR_OrdenesDeCompraImpresionConta" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"       null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra" value="#arguments.id_OrdenDeCompra#" null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <!--- <cfcontent type="text/html">
            <cfdump var="#Local.rs#" format="simple" label="arguments" abort="true"> --->

    <cfreturn Local.rs/>
</cffunction>

<cffunction name="GuardarInfoSustitucion" access="public" returntype="void">
    <cfargument name="id_Empresa"                   type="numeric" required="true"/>
    <cfargument name="id_OrdenCompra"               type="numeric" required="true"/>
    <cfargument name="sn_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="id_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="de_ObservacionesSustitucion"  type="string" required="true"/>
    <cfargument name="ar_SoporteSustitucion"        type="string" required="true"/>

    <cfstoredproc procedure="upU_OrdenesCompraSetInfoSustitucion" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                   value="#arguments.id_Empresa#"                      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"               value="#arguments.id_OrdenCompra#"                  null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Sustitucion"               value="#arguments.sn_Sustitucion#"                  null="#iif(isNumeric(arguments.sn_Sustitucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sustitucion"               value="#arguments.id_Sustitucion#"                  null="#iif(isNumeric(arguments.id_Sustitucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ObservacionesSustitucion"  value="#arguments.de_ObservacionesSustitucion#"     null="#iif(len(arguments.de_ObservacionesSustitucion),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_SoporteSustitucion"        value="#arguments.ar_SoporteSustitucion#"           null="#iif(len(arguments.ar_SoporteSustitucion),false,true)#">
    </cfstoredproc>
</cffunction>

    <cffunction name="SearchDocumentoSustitucion" access="public" returntype="Query">
        <cfargument name="id_empresa" type="string" required="true">
        <cfargument name="id_OrdenCompra" type="string" required="true">

        <cfstoredproc procedure="upL_OrdenesCompraSearchDocumentoSustitucion" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"       null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra" value="#arguments.id_OrdenCompra#" null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getInfoResponsables" access="public" returntype="Query">
        <cfargument name="id_empresa"       type="string" required="true">
        <cfargument name="id_OrdenDeCompra"   type="string" required="true">

        <cfstoredproc procedure="upR_OrdenesDeCompra_InfoResposables" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"       null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra" value="#arguments.id_OrdenDeCompra#" null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
