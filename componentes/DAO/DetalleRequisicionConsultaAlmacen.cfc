<cfcomponent extends="wiz/requisicionesdetalle">

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

        <cfquery name="Local.RequisicionesDetalle" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleConsultaAlmacen
                                            #arguments.id_Empresa#,
                                            #arguments.id_Sucursal#,
                                            #arguments.id_Almacen#,
                                            #arguments.id_Requisicion#
        </cfquery>

        <cfreturn Local.RequisicionesDetalle/>
   </cffunction>

    <cffunction name="CountDetalleRequisicionesSurtidasParcialmente" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

        <cfquery name="Local.CountRequisicionSurtidaParcialmente" datasource="#variables.cnx#" >
            exec upL_RequisicionesDetalleCountSurtidoParcialmente
                                                                    #arguments.id_Empresa#,
                                                                    #arguments.id_Requisicion#
        </cfquery>
        <cfreturn Local.CountRequisicionSurtidaParcialmente/>
    </cffunction>

    <cffunction name="listaDatosRequisicion" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

            <cfquery name="Local.DatosRequisicion" datasource="#variables.cnx#" >
                exec upL_RequisicionparaRequisicionDetalleConsultaAlmacen
                                                                #arguments.id_Empresa#,
                                                                #arguments.id_Requisicion#
            </cfquery>
            <cfreturn Local.DatosRequisicion/>
    </cffunction>

    <cffunction name="NextIdSolicitudCompra" access="public" returntype="string">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>

        <cfquery name="Local.SolicitudCompra" datasource="#variables.cnx#" >

            exec upR_SolicitudCompraNextID
                                          #arguments.id_Empresa#
        </cfquery>

        <cfreturn Local.SolicitudCompra.nextID />
    </cffunction>

    <cffunction name="NextIdSolicitudCompraDetalle" access="public" returntype="string">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"        type="numeric" required="true"/>

            <cfquery name="Local.SolicitudCompraDetalle" datasource="#variables.cnx#" >

                exec upR_SolicitudCompraDetalleNextID
                                                      #arguments.id_Empresa#,
                                                      #arguments.id_SolicitudCompra#
            </cfquery>

            <cfreturn Local.SolicitudCompraDetalle.nextID />
    </cffunction>

    <cffunction name="Editar" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Requisicion"            type="numeric" required="true"/>
        <cfargument name="id_Insumo"                 type="numeric" required="true"/>
        <cfargument name="id_RequisicionDetalle"     type="numeric" required="true"/>
        <cfargument name="nu_Cantidad"               type="numeric" required="true"/>
        <cfargument name="nu_CantidadaSurtir"        type="numeric" required="true"/>
        <cfargument name="id_GrupoCentroCosto"       type="numeric" required="true"/>
        <cfargument name="id_CentroCosto"            type="numeric" required="true"/>

            <cfstoredproc procedure="upU_RequisicionesDetalle"  datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"        value="#arguments.id_Requisicion#"        null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle" value="#arguments.id_RequisicionDetalle#" null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"             value="#arguments.id_Insumo#"             null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@Nu_Cantidad"           value="#arguments.Nu_Cantidad#"           null="#iif(isNumeric(arguments.Nu_Cantidad),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@Nu_CantidadaSurtir"    value="#arguments.Nu_CantidadaSurtir#"    null="#iif(isNumeric(arguments.Nu_CantidadaSurtir),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"   value="#arguments.id_GrupoCentroCosto#"   null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"        value="#arguments.id_CentroCosto#"        null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ConceptoGasto"      value="#arguments.id_ConceptoGasto#"      null="#iif(isNumeric(arguments.id_ConceptoGasto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoGasto"         value="#arguments.id_GrupoGasto#"         null="#iif(isNumeric(arguments.id_GrupoGasto),false,true)#">
            </cfstoredproc>


            <!--- <cfquery datasource="#variables.cnx#">
                exec upU_RequisicionesDetalle #arguments.id_Empresa#,
                                              #arguments.id_Requisicion#,
                                              #arguments.id_RequisicionDetalle#,
                                              #arguments.id_Insumo#,
                                              #arguments.nu_Cantidad#,
                                              #arguments.nu_CantidadaSurtir#
            </cfquery> --->
    </cffunction>

    <cffunction name="validarEstatusSurtidoRequisicion" access="public" returntype="numeric">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="id_Requisicion" type="numeric" required="true">

        <cfquery name="Local.Conteo" datasource="#variables.cnx#">
            exec upR_RequisicionesDetalleCountEstatus
                                #arguments.id_Empresa#,
                                #arguments.id_Requisicion#
        </cfquery>

        <cfif Local.Conteo.surtidoCompleto EQ Local.Conteo.total>
            <cfset Local.estatus = 1>
            <cfreturn local.estatus>

            <cfelseif Local.Conteo.surtidoParcial GT 0 OR (Local.Conteo.surtidoCompleto GT 0 AND Local.Conteo.surtidoCompleto LT Local.Conteo.total)>
                <cfset Local.estatus = 2>
                <cfreturn local.estatus>

            <cfelseif Local.Conteo.surtidoCompleto EQ 0 AND Local.Conteo.surtidoParcial EQ 0>
                <cfset Local.estatus = 3>
                <cfreturn local.estatus>

        </cfif>

    </cffunction>

    <cffunction name="EditarEstatusSurtidoRequisicion" access="public" returntype="void">
        <cfargument name="id_Empresa"                type="numeric" required="true"/>
        <cfargument name="id_Requisicion"            type="numeric" required="true"/>
        <cfargument name="id_EstatusSurtido"         type="numeric" required="true"/>

        <cfquery datasource="#variables.cnx#">
            exec upU_RequisicionesEstatusSurtido    #arguments.id_Empresa#,
                                                    #arguments.id_Requisicion#,
                                                    #arguments.id_EstatusSurtido#
        </cfquery>
    </cffunction>

    <cffunction name="GuardarSolicitudCompra"    access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric"  required="true"/>
        <cfargument name="id_SucursalSolicita"  type="numeric"  required="false" defaul=""/>
        <cfargument name="is_Almacen"           type="numeric"  required="false" defaul=""/>
        <cfargument name="id_Usuario"           type="numeric"  required="true"/>
        <cfargument name="Fecha_Convertida"     type="string"   required="true"/>
        <cfargument name="id_Requisicion"       type="numeric"  required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#">
            exec upC_SolicitudesCompra  #arguments.id_Empresa#,
                                        <cfif ARGUMENTS.id_SucursalSolicita  EQ ''> NULL <cfelse> #arguments.id_SucursalSolicita# </cfif>,
                                        <cfif ARGUMENTS.id_Almacen  EQ ''> NULL <cfelse> #arguments.id_Almacen# </cfif>,
                                        #arguments.id_Usuario#,
                                        '#arguments.Fecha_Convertida#',
                                        #arguments.id_Requisicion#
        </cfquery>
        <cfreturn Local.rs.id_SolicitudCompra/>
    </cffunction>

    <cffunction name="GuardarSolicitudCompraDetalle" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_SolicitudCompra"       type="numeric" required="true"/>
        <cfargument name="id_Insumo"                type="numeric" required="true"/>
        <cfargument name="nu_Cantidad"              type="numeric" required="true"/>
        <cfargument name="id_Requisicion"           type="numeric"  required="true"/>
        <cfargument name="id_RequisicionDetalle"    type="numeric"  required="true"/>


            <cfquery datasource="#variables.cnx#">
                exec upC_SolicitudesCompraDetalle #arguments.id_Empresa#,
                                                  #arguments.id_SolicitudCompra#,
                                                  #arguments.id_Insumo#,
                                                  #arguments.nu_Cantidad#,
                                                  #arguments.id_Requisicion#,
                                                  #arguments.id_RequisicionDetalle#
            </cfquery>
    </cffunction>

    <cffunction name="editarGrupoCentroCosto" access="public" returntype="void">
        <cfargument name="id_Empresa"            type="numeric" required="true"/>
        <cfargument name="id_Requisicion"        type="numeric" required="true"/>
        <cfargument name="id_RequisicionDetalle" type="numeric" required="true"/>
        <cfargument name="id_GrupoCentroCosto"   type="numeric" required="true"/>
        <cfargument name="id_CentroCosto"        type="numeric" required="true"/>


            <!--- <cfquery datasource="#variables.cnx#">
                exec upU_SolicitudesCompraDetalle #arguments.id_Empresa#,
                                                  #arguments.id_SolicitudCompra#,
                                                  #arguments.id_Insumo#,
                                                  #arguments.nu_Cantidad#
            </cfquery> --->

            <cfstoredproc procedure="upU_requisicionesDetalleGrupoCentroCosto" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"        value="#arguments.id_Requisicion#"        null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle" value="#arguments.id_RequisicionDetalle#" null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto"   value="#arguments.id_GrupoCentroCosto#"   null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto"        value="#arguments.id_CentroCosto#"        null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
            </cfstoredproc>
    </cffunction>


    <cffunction name="GenerarMtoPrestamosInsumosSeriados" access="public" returntype="void">
        <cfargument name="id_Empresa"          type="numeric" required="no" default="">
        <cfargument name="id_Sucursal"         type="numeric" required="no" default="">
        <cfargument name="id_Almacen"          type="numeric" required="no" default="">
        <cfargument name="id_EmpresaSession"   type="numeric" required="no" default="">
        <cfargument name="id_SucursalSession"  type="numeric" required="no" default="">
        <cfargument name="id_AlmacenSession"   type="numeric" required="no" default="">
        <cfargument name="id_Requisicion"      type="numeric" required="no" default="">
        <cfargument name="id_Insumo"           type="numeric" required="no" default="">
        <cfargument name="de_SerieInsumo"      type="string"  required="no" default="">
        <cfargument name="de_Etiqueta"         type="string"  required="no" default="">
        <cfargument name="sn_ActivoFijo"       type="numeric" required="no" default="">
        <cfargument name="sn_CentroCosto"      type="numeric" required="no" default="">
        <cfargument name="id_GrupoCentroCosto" type="numeric" required="no" default="">
        <cfargument name="id_CentroCosto"      type="numeric" required="no" default="">
        <cfargument name="id_Usuario"          type="numeric" required="no" default="">

            <cfstoredproc procedure="upC_InventariosMovimientosPrestamosInsumosSeriados" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaSession" value="#arguments.id_EmpresaSession#" null="#iif(isNumeric(arguments.id_EmpresaSession),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalSession" value="#arguments.id_SucursalSession#" null="#iif(isNumeric(arguments.id_SucursalSession),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AlmacenSession" value="#arguments.id_AlmacenSession#" null="#iif(isNumeric(arguments.id_AlmacenSession),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo" value="#arguments.id_Insumo#" null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_SerieInsumo" value="#arguments.de_SerieInsumo#" null="#iif(len(arguments.de_SerieInsumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Etiqueta" value="#arguments.de_Etiqueta#" null="#iif(len(arguments.de_Etiqueta),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_BIT" dbvarname="@sn_ActivoFijo" value="#arguments.sn_ActivoFijo#" null="#iif(isBoolean(arguments.sn_ActivoFijo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_BIT" dbvarname="@sn_CentroCosto" value="#arguments.sn_CentroCosto#" null="#iif(isBoolean(arguments.sn_CentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto" value="#arguments.id_GrupoCentroCosto#" null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto" value="#arguments.id_CentroCosto#" null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario" value="#arguments.id_Usuario#" null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
            </cfstoredproc>
    </cffunction>

    <cffunction name="GenerarMtoPrestamosInsumos" access="public" returntype="void">
        <cfargument name="id_Empresa"            type="numeric" required="no" default="">
        <cfargument name="id_Sucursal"           type="numeric" required="no" default="">
        <cfargument name="id_Almacen"            type="numeric" required="no" default="">
        <cfargument name="id_Requisicion"        type="numeric" required="no" default="">
        <cfargument name="id_RequisicionDetalle" type="numeric" required="no" default="">
        <cfargument name="nu_CantidadSurtir"     type="string"  required="no" default="">
        <cfargument name="id_GrupoCentroCosto"   type="numeric" required="no" default="">
        <cfargument name="id_CentroCosto"        type="numeric" required="no" default="">
        <cfargument name="id_GrupoGasto"         type="string"  required="no" default="">
        <cfargument name="id_ConceptoGasto"      type="string"  required="no" default="">
        <cfargument name="id_Usuario"            type="numeric" required="no" default="">

            <cfstoredproc procedure="upC_InventariosMovimientosPrestamosInsumos" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#" null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#" null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen" value="#arguments.id_Almacen#" null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_RequisicionDetalle" value="#arguments.id_RequisicionDetalle#" null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
                <cfprocparam scale="4"  type="IN" cfsqltype="CF_SQL_DECIMAL" dbvarname="@nu_CantidadSurtir" value="#arguments.nu_CantidadSurtir#" null="#iif(isNumeric(arguments.nu_CantidadSurtir),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoCentroCosto" value="#arguments.id_GrupoCentroCosto#" null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CentroCosto" value="#arguments.id_CentroCosto#" null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_GrupoGasto" value="#arguments.id_GrupoGasto#" null="#iif(isNumeric(arguments.id_GrupoGasto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ConceptoGasto" value="#arguments.id_ConceptoGasto#" null="#iif(isNumeric(arguments.id_ConceptoGasto),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario" value="#arguments.id_Usuario#" null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
            </cfstoredproc>

    </cffunction>

    <cffunction name="getUsuarioPermisos" access="public" returntype="query">
        <cfargument name="id_Usuario"                   type="string" required="false" default=""/>

            <cfstoredproc procedure="upR_getPerfilPermisosFinalizarRequisicion" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"           value="#arguments.id_Usuario#"           null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getMovimientosEntrada" access="public" returntype="query">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>
        <cfargument name="id_Estatus"     type="string" required="false"/>

        <cfstoredproc procedure="upL_InventariosMoviminetos_GetEntradasByRequisicion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"     value="#arguments.id_Estatus#"     null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getCorreoAlmacenistaNotificacion" access="public" returntype="query">
    <cfstoredproc procedure="upL_getCorreoAlmacenistaNotificacion" datasource="#variables.cnx#">
        <cfprocresult name="Local.resultado">
    </cfstoredproc>
    <cfreturn Local.resultado>
</cffunction>

    <cffunction name="GuardarNotificacion" access="public" returntype="void">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Sucursal"    type="string" required="true"/>
        <cfargument name="id_Almacen"     type="string" required="false"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>
         <cfargument name="de_Correo"      type="string" required="false" default=""/>

        <cfstoredproc procedure="upC_RequisicionNotificacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"    null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"     null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_LONGVARCHAR" dbvarname="@de_Correo" value="#arguments.de_Correo#" null="#iif(len(trim(arguments.de_Correo)) GT 0, false, true)#">
        </cfstoredproc>

    </cffunction>

    <cffunction name="RequisicionesANotificar" access="public" returntype="struct">
        <cfstoredproc procedure="upL_RequisicionNotificacion_NotificarEntregaPorExpirar" datasource="#variables.cnx#">
            <cfprocresult name="Local.List" resultset="1">
            <cfprocresult name="Local.Summary" resultset="2">
        </cfstoredproc>

        <cfreturn Local/>
    </cffunction>

    <cffunction name="quitarRecordatorioSurtir" access="public" returntype="void">
        <cfstoredproc procedure="upD_RequisicionNotificacion_NotificacionesEnviadas" datasource="#variables.cnx#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="RequisicionesEliminarRecordatorio" access="public" returntype="void">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>

        <cfstoredproc procedure="upD_RequisicionNotificacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion" value="#arguments.id_Requisicion#" null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        </cfstoredproc>

    </cffunction>

    <cffunction name="DevolverRequisicionAutorizacion" access="public" returntype="query">
        <cfargument name="id_Empresa"                        type="string" required="true"/>
        <cfargument name="id_Requisicion"                    type="string" required="true"/>
        <cfargument name="id_UsuarioAutoriza"                type="string" required="true"/>
        <cfargument name="id_EstatusAutorizacionRequisicion" type="string" required="true"/>
        <cfargument name="de_Comentarios"                    type="string" required="true"/>
        <cfargument name="id_Nivel"                          type="string" required="false"/>
        <cfargument name="sn_Activo"                         type="string" required="false"/>
        <cfargument name="sn_Almacenista"                    type="string" required="true"/>

        <cfstoredproc procedure="upC_RequisicionesUsuariosAutorizan_Directo" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                        value="#arguments.id_Empresa#"                        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Requisicion"                    value="#arguments.id_Requisicion#"                    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_UsuarioAutoriza"                value="#arguments.id_UsuarioAutoriza#"                null="#iif(isNumeric(arguments.id_UsuarioAutoriza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacionRequisicion" value="#arguments.id_EstatusAutorizacionRequisicion#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Comentarios"                    value="#arguments.de_Comentarios#"                    null="#iif(len(arguments.de_Comentarios),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Nivel"                          value="#arguments.id_Nivel#"                          null="#iif(isNumeric(arguments.id_Nivel),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Activo"                         value="#arguments.sn_Activo#"                         null="#iif(isNumeric(arguments.sn_Activo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Almacenista"                    value="#arguments.sn_Almacenista#"                    null="#iif(isNumeric(arguments.sn_Almacenista),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>
</cfcomponent>
