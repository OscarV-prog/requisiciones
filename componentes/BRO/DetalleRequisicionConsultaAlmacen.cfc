<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen  = session.ID_ALMACEN>

        <cfset local.DetalleRequisicion=structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                  method="listaDatosRequisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.DatosRequisicion">

        <cfset local.DetalleRequisicion.Requisicion = local.DatosRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.DetalleReq">

        <cfset local.DetalleRequisicion.DetalleReq= local.DetalleReq>

        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
            method="getInformacionAtencion"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#session.ID_ALMACEN#"
            returnvariable="Local.Almacen">

        <cfset local.DetalleRequisicion.Almacen = local.Almacen>

        <cfset variables.RBR.setData(local.DetalleRequisicion)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Editar"  access="public" returntype="Any">
        <cfargument name="RequisicionesConsultaAlmacen" type="array"    required="true"/>
        <cfargument name="InsumosSeriados"              type="array"    required="false"/>
        <cfargument name="Operacion"                    type="String"   required="true"/>
        <cfargument name="id_Requisicion"               type="Numeric"  required="false"/>
        <cfargument name="id_UsuarioRecibio"            type="Numeric"  required="false"/>
        <cfargument name="id_SucursalSolicita"          type="Numeric"  required="false"    default=""/>
        <cfargument name="configuracion_almacen"        type="Numeric"  required='false'    default="#0#">
        <cfargument name="Traspasos"                    type="Struct"    required="false"/>
        <cfargument name="sn_ValidarPresupuesto"        type="Numeric"  required="false" default="#0#"/>

        <cfset local.ff_Presupuestos = 0>
        <cftry>
            <cfset local.ff_Presupuestos = Application.RENV.getProperty('FF_PRESUPUESTOS')>
            <cfcatch type="any"></cfcatch>
        </cftry>
        <cfif NOT isDefined("local.ff_Presupuestos") OR len(trim(local.ff_Presupuestos)) EQ 0>
            <cfset local.ff_Presupuestos = 0>
        </cfif>

        <cfif NOT variables.RBR.hasError()>
            <!--- SANITIZACIÓN DE NOMBRES DE INSUMO PARA EVITAR CONCATENACIÓN CON SERIE --->
            <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.idxSanit">
                <cfif structKeyExists(arguments.RequisicionesConsultaAlmacen[local.idxSanit], "NB_NOMBREINSUMO") AND structKeyExists(arguments.RequisicionesConsultaAlmacen[local.idxSanit], "DE_SERIEINSUMO")>
                    <cfset local.nb_NombreSanitizado = trim(arguments.RequisicionesConsultaAlmacen[local.idxSanit].NB_NOMBREINSUMO)>
                    <cfset local.serieSanitizar = trim(arguments.RequisicionesConsultaAlmacen[local.idxSanit].DE_SERIEINSUMO)>
                    <cfif len(local.serieSanitizar)>
                        <cfif right(local.nb_NombreSanitizado, len(' - ' & local.serieSanitizar)) EQ ' - ' & local.serieSanitizar>
                            <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.serieSanitizar)))>
                        <cfelseif right(local.nb_NombreSanitizado, len('-' & local.serieSanitizar)) EQ '-' & local.serieSanitizar>
                            <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.serieSanitizar)))>
                        <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.serieSanitizar)) EQ ' ' & local.serieSanitizar>
                            <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.serieSanitizar)))>
                        </cfif>
                    </cfif>
                    <cfset arguments.RequisicionesConsultaAlmacen[local.idxSanit].NB_NOMBREINSUMO = local.nb_NombreSanitizado>
                </cfif>
            </cfloop>

            <cfif isDefined("arguments.InsumosSeriados")>
                <cfloop from="1" to="#arrayLen(arguments.InsumosSeriados)#" index="local.idxSanit">
                    <cfif structKeyExists(arguments.InsumosSeriados[local.idxSanit], "NB_NOMBREINSUMO") AND structKeyExists(arguments.InsumosSeriados[local.idxSanit], "DE_SERIEINSUMO")>
                        <cfset local.nb_NombreSanitizado = trim(arguments.InsumosSeriados[local.idxSanit].NB_NOMBREINSUMO)>
                        <cfset local.serieSanitizar = trim(arguments.InsumosSeriados[local.idxSanit].DE_SERIEINSUMO)>
                        <cfif len(local.serieSanitizar)>
                            <cfif right(local.nb_NombreSanitizado, len(' - ' & local.serieSanitizar)) EQ ' - ' & local.serieSanitizar>
                                <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.serieSanitizar)))>
                            <cfelseif right(local.nb_NombreSanitizado, len('-' & local.serieSanitizar)) EQ '-' & local.serieSanitizar>
                                <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.serieSanitizar)))>
                            <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.serieSanitizar)) EQ ' ' & local.serieSanitizar>
                                <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.serieSanitizar)))>
                            </cfif>
                        </cfif>
                        <cfset arguments.InsumosSeriados[local.idxSanit].NB_NOMBREINSUMO = local.nb_NombreSanitizado>
                    </cfif>
                </cfloop>
            </cfif>
            <cfif arguments.Operacion EQ 'Surtir'>

                <cfloop from="1" to="#arrayLen(arguments.InsumosSeriados)#" index="local.i">

                    <cfset local.MtoPrestamo = structNew()>

                    <cfset local.MtoPrestamo.id_Empresa            = arguments.InsumosSeriados[local.i].ID_EMPRESA>
                    <cfset local.MtoPrestamo.id_Sucursal           = arguments.InsumosSeriados[local.i].ID_SUCURSAL>
                    <cfset local.MtoPrestamo.id_Almacen            = arguments.InsumosSeriados[local.i].ID_ALMACEN>
                    <cfset local.MtoPrestamo.id_EmpresaSession     = session.ID_EMPRESA>
                    <cfset local.MtoPrestamo.id_SucursalSession    = SESSION.ID_SUCURSAL>
                    <cfset local.MtoPrestamo.id_AlmacenSession     = session.ID_ALMACEN>
                    <cfset local.MtoPrestamo.id_Requisicion        = arguments.ID_REQUISICION>
                    <cfset local.MtoPrestamo.id_Insumo             = arguments.InsumosSeriados[local.i].ID_INSUMO>
                    <cfset local.MtoPrestamo.de_SerieInsumo        = arguments.InsumosSeriados[local.i].DE_SERIEINSUMO>
                    <cfset local.MtoPrestamo.de_Etiqueta           = arguments.InsumosSeriados[local.i].DE_ETIQUETA>
                    <cfset local.MtoPrestamo.sn_ActivoFijo         = arguments.InsumosSeriados[local.i].SN_ACTIVOFIJO>
                    <cfset local.MtoPrestamo.sn_CentroCosto        = arguments.InsumosSeriados[local.i].SN_CENTROCOSTO>
                    <cfset local.MtoPrestamo.id_GrupoCentroCosto   = arguments.InsumosSeriados[local.i].ID_GRUPOCENTROCOSTO>
                    <cfset local.MtoPrestamo.id_CentroCosto        = arguments.InsumosSeriados[local.i].ID_CENTROCOSTO>
                    <cfset local.MtoPrestamo.id_Usuario            = session.ID_USUARIO>

                    <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                        method="GenerarMtoPrestamosInsumosSeriados"
                        argumentcollection="#local.MtoPrestamo#">

                </cfloop>


                <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.j">
                    <cfset local.Argumentos_Requisicion                       = structNew()>
                    <cfset local.Argumentos_Requisicion.id_Empresa            = session.ID_EMPRESA>
                    <cfset local.Argumentos_Requisicion.id_Sucursal           = SESSION.ID_SUCURSAL>
                    <cfset local.Argumentos_Requisicion.id_Almacen            = session.ID_ALMACEN>
                    <cfset local.Argumentos_Requisicion.id_Requisicion        = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                    <cfset local.Argumentos_Requisicion.id_Insumo             = arguments.RequisicionesConsultaAlmacen[local.j].id_Insumo>
                    <cfset local.Argumentos_Requisicion.id_RequisicionDetalle = arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle>
                    <cfset local.Argumentos_Requisicion.nu_Cantidad           = arguments.RequisicionesConsultaAlmacen[local.j].Nu_Cantidad>
                    <cfset local.Argumentos_Requisicion.nu_CantidadaSurtir    = arguments.RequisicionesConsultaAlmacen[local.j].CantidadaSurtir>
                    <cfset local.Argumentos_Requisicion.nu_CantidadSurtir     = arguments.RequisicionesConsultaAlmacen[local.j].CantidadaSurtir>
                    <cfset local.Argumentos_Requisicion.id_GrupoCentroCosto   = arguments.RequisicionesConsultaAlmacen[local.j].id_GrupoCentroCosto>
                    <cfset local.Argumentos_Requisicion.id_CentroCosto        = arguments.RequisicionesConsultaAlmacen[local.j].id_CentroCosto>
                    <cfset local.Argumentos_Requisicion.id_GrupoGasto         = arguments.RequisicionesConsultaAlmacen[local.j].id_GrupoGasto>

                    <!--- Configuración de Almacenes sin Inventario --->
                    <cfif arguments.configuracion_almacen EQ 1>
                        <cfset local.Argumentos_Requisicion.id_ConceptoGasto       = arguments.RequisicionesConsultaAlmacen[local.j].id_ConceptoGasto>

                        <cfelse>
                            <cfset local.Argumentos_Requisicion.id_ConceptoGasto   = arguments.RequisicionesConsultaAlmacen[local.j].id_ConceptoGasto.ID_CONCEPTOGASTO>

                    </cfif>

                    <cfset local.Argumentos_Requisicion.id_Usuario            = session.ID_USUARIO>

                    <!--- <cfdump var="#Argumentos_Requisicion#"> --->
                    <!--- <cfabort> --->

                    <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                        method="GenerarMtoPrestamosInsumos"
                        argumentcollection="#local.Argumentos_Requisicion#">


                    <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="Editar"
                                argumentcollection="#Argumentos_Requisicion#">

                    <cfinvoke   component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                method="getCantidades"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                id_RequisicionDetalle = "#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                returnvariable = "local.nu_Cantidades">

                    <cfif local.nu_Cantidades.nu_Cantidad GT local.nu_Cantidades.nu_CantidadSurtida>
                        <cfinvoke   component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                    method="setIdSurtido"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                    id_RequisicionDetalle="#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                    id_Estatus= "2">

                    <cfelseif local.nu_Cantidades.nu_Cantidad EQ local.nu_Cantidades.nu_CantidadSurtida>
                        <cfinvoke   component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                    method="setIdSurtido"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                    id_RequisicionDetalle="#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                    id_Estatus= "1">
                    </cfif>

                    <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="CountDetalleRequisicionesSurtidasParcialmente"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_Requisicion ="#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                returnvariable="local.NumSurtidasParcialmente">

                    <cfif local.NumSurtidasParcialmente.NumCantidad GT 0>
                        <cfset local.Argumentos_EditarEstatusRequisicion = structNew()>

                        <cfset local.Argumentos_EditarEstatusRequisicion.id_Empresa = session.ID_EMPRESA>
                        <cfset local.Argumentos_EditarEstatusRequisicion.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                        <cfset local.Argumentos_EditarEstatusRequisicion.id_EstatusSurtido = 2>

                        <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                    method="EditarEstatusSurtidoRequisicion"
                                    argumentcollection="#local.Argumentos_EditarEstatusRequisicion#">

                    <cfelseif local.NumSurtidasParcialmente.NumCantidad EQ 0 >
                        <cfset local.Argumentos_EditarEstatusRequisicion = structNew()>

                        <cfset local.Argumentos_EditarEstatusRequisicion.id_Empresa = session.ID_EMPRESA>
                        <cfset local.Argumentos_EditarEstatusRequisicion.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                        <cfset local.Argumentos_EditarEstatusRequisicion.id_EstatusSurtido = 1>

                        <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                    method="EditarEstatusSurtidoRequisicion"
                                    argumentcollection="#local.Argumentos_EditarEstatusRequisicion#">
                    </cfif>
                </cfloop>

                <!--- ANTES DE EMPEZAR CON EL SURTIDO DE LA REQUISICION --->
                <cfset insumosTraspasos = structNew()>
                <cfset local.EntrTraspaso = structNew()>
                <!--- REALIZAMOS UN LOOP DE LOS INSUMOS PARA SABER CUAL SERA NECESARIO REALIZARLE UN TRASPASO DE CONSIGNACION --->
                <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.k">
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="CantidadExistenciaInsumo"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal ="#SESSION.ID_SUCURSAL#"
                        id_Almacen ="#session.ID_ALMACEN#"
                        id_Insumo = "#arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo#"
                        returnvariable="local.Nu_Existencia">

                    <cfset arguments.RequisicionesConsultaAlmacen[local.k].sn_Consignacion = 0>

                    <!--- SI LA CANTIDAD A SURTIR ES MAYOR A LA CANTIDAD DISPONIBLE --->
                    <cfif arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir GT local.Nu_Existencia.nu_Existencia AND
                        arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo EQ local.Nu_Existencia.id_Insumo>

                        <!--- REVISAMOS SI ESTA EL INSUMO EN CONSIGNACION --->
                        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                            method="CantidadExistenciaInsumo_Consignacion"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_Sucursal="#SESSION.ID_SUCURSAL#"
                            id_Almacen="#session.ID_ALMACEN#"
                            id_Insumo="#arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo#"
                            returnvariable="localConsignacion.Nu_Existencia">

                        <cfif localConsignacion.Nu_Existencia.RecordCount EQ 0>
                            <cfset variables.RBR.setError("w&No se encontraron existencia en almacén.<br>Favor de Revisar")>
                            <cfreturn variables.RBR>
                        </cfif>

                        <!--- SI NO HAY CANTIDAD DISPONIBLE PARA SURTIR ENTRE CONSIGNACION Y EL ALMACEN, LEVANTAMOS UN ERROR --->
                        <cfif arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir GT (localConsignacion.Nu_Existencia.nu_Existencia + local.Nu_Existencia.nu_Existencia)>
                            <cfset variables.RBR.setError("w&Algunas de las cantidades a surtir exceden la cantidad que hay de existencia en almacén.")>
                            <cfreturn variables.RBR>
                        </cfif>

                        <!--- SI HAY CANTIDAD EN CONSIGNACION, GUARDAMOS LA CANTIDAD QUE SE NECESITA SACAR DE CONSIGNACION --->
                        <cfset arrayAppend(insumosTraspasos, {
                            id_Insumo="#arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo#",
                            nu_cantidad="#arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir - local.Nu_Existencia.nu_Existencia#",
                            nu_cantidadTraspasar="#arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir - local.Nu_Existencia.nu_Existencia#",
                            sn_Surtida="#0#",
                            id_ProveedorConsignacion="#arguments.RequisicionesConsultaAlmacen[local.k].id_Proveedor#"
                        })>
                    </cfif>
                </cfloop>

                <!--- Si tenemos insumos que se deben --->
                <cfif arrayLen(insumosTraspasos) GT 0>
                    <!--- Generamos el traspaso del almacen de consignación al de session --->
                    <cfinvoke component="#Application.RF.getPath('bro','AlmacenesExistencias')#"
                        method="GenerarTraspasoConsignacion"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_Sucursal="#SESSION.ID_SUCURSAL#"
                        id_Departamento="#arguments.Traspasos.id_Departamento#"
                        insumos="#insumosTraspasos#"
                        id_Requisicion="#arguments.id_Requisicion#"
                        returnvariable="local.Traspaso">

                    <cfif local.Traspaso.hasError()>
                        <cfset Variables.RBR.setError(local.Traspaso.getMessage())>
                        <cfreturn variables.RBR>
                    <cfelse>
                        <cfset local.EntrTraspaso = {
                            id_InventarioTraspaso="#local.Traspaso.getData().ID_INVENTARIOTRASPASO#",
                            id_Movimiento="#local.Traspaso.getData().id_Movimiento#"
                        }>
                    </cfif>
                </cfif>

                <!--- Verificar si existe en tabla de Obras en Proceso para guardar la fh de surtido materiales--->
                <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                        method="guardarFechaSalidaMateriales"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_Requisicion="#arguments.id_Requisicion#"
                        id_Usuario = "#session.ID_USUARIO#"
                        >
            </cfif>
            <cfset local.id_Movimiento = 0>
            <cfif arguments.Operacion EQ 'SolicitarCompra'>
                <cfset local.Argumentos_SolicitudCompra = structNew()>

                <cfset local.Argumentos_SolicitudCompra.id_Empresa = session.ID_EMPRESA>

              <!---  <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                            method="NextIdSolicitudCompra"
                            id_Empresa ="#session.ID_EMPRESA#"
                            returnvariable="local.id_SolicitudCompra">--->

                <!---<cfset local.Argumentos_SolicitudCompra.id_SolicitudCompra = local.id_SolicitudCompra>--->
                <cfset local.Argumentos_SolicitudCompra.id_Usuario = session.ID_USUARIO>
                <cfset local.Argumentos_SolicitudCompra.Fecha_Convertida = dateFormat(Now(),'yyyyMMdd')>
                <cfset local.Argumentos_SolicitudCompra.id_Requisicion= arguments.RequisicionesConsultaAlmacen[1].id_Requisicion>
                <cfset local.Argumentos_SolicitudCompra.id_SucursalSolicita= arguments.id_SucursalSolicita>
                <cfset local.Argumentos_SolicitudCompra.id_Almacen= "#session.ID_ALMACEN#">

                <cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                            method="GuardarSolicitudCompra"
                            argumentcollection="#Argumentos_SolicitudCompra#"
                             returnvariable="local.id_SolicitudCompra">
                <cfset local.Argumentos_SolicitudCompra.id_SolicitudCompra = local.id_SolicitudCompra>

                <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.j">
                    <cfset local.Argumentos_SolicitudCompraDetalle = structNew()>

                    <cfset local.Argumentos_SolicitudCompraDetalle.id_Empresa = session.ID_EMPRESA>
                    <cfset local.Argumentos_SolicitudCompraDetalle.id_SolicitudCompra = local.id_SolicitudCompra>

                    <!---<cfinvoke   component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="NextIdSolicitudCompraDetalle"
                                id_Empresa="#session.ID_EMPRESA#"
                                id_SolicitudCompra ="#local.id_SolicitudCompra#"
                                returnvariable="local.id_SolicitudCompraDetalle">

                    <cfset local.Argumentos_SolicitudCompraDetalle.id_SolicitudCompraDetalle = local.id_SolicitudCompraDetalle>--->
                    <cfset local.Argumentos_SolicitudCompraDetalle.id_Insumo = arguments.RequisicionesConsultaAlmacen[local.j].id_Insumo>
                    <cfset local.Argumentos_SolicitudCompraDetalle.nu_Cantidad = arguments.RequisicionesConsultaAlmacen[local.j].CANTIDADASOLICITAR>
                    <cfset local.Argumentos_SolicitudCompraDetalle.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].ID_REQUISICION>
                    <cfset local.Argumentos_SolicitudCompraDetalle.id_RequisicionDetalle = arguments.RequisicionesConsultaAlmacen[local.j].ID_REQUISICIONDETALLE>
                    <cfset local.Argumentos_SolicitudCompraDetalle.nu_Cantidad = arguments.RequisicionesConsultaAlmacen[local.j].CANTIDADASOLICITAR>

                    <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="GuardarSolicitudCompraDetalle"
                                argumentcollection="#Argumentos_SolicitudCompraDetalle#">
                </cfloop>

                <cfinvoke component="#Application.RF.getPath('dao','Sucursales')#"
                          method="getNameSucursal"
                          id_Empresa="#session.ID_EMPRESA#"
                          id_sucursal="#SESSION.ID_SUCURSAL#"
                          returnvariable="Local.sucursal">

                <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                          method="getNameAlmacen"
                          id_Empresa="#session.ID_EMPRESA#"
                          id_sucursal="#SESSION.ID_SUCURSAL#"
                          id_almacen="#session.ID_ALMACEN#"
                          returnvariable="Local.almacen">

              <cfset Local.parametros={
                    id_SolicitudCompra=Local.Argumentos_SolicitudCompra.id_SolicitudCompra,
                    nb_sucursal=Local.sucursal.nb_sucursal,
                    nb_almacen=Local.almacen.nb_almacen,
                    nb_empleado=session.NB_EMPLEADOCOMPLETO,
                    nu_requisicion=Local.Argumentos_SolicitudCompra.id_Requisicion,
                    id_TipoRequisicion = 2
                }>

                <!--- Obtiene los empleados que estan asignados a la opcion de solicitud de compra en el
                modulo de compras (id_opcion=28) --->
                <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                          method="getEmpleadosAsigSolicitudCompra"
                          id_Empresa="#session.ID_EMPRESA#"
                          id_sucursal="#SESSION.ID_SUCURSAL#"
                          returnvariable="Local.empleadosSC">

                <cfset Local.correosEmpleados=arrayNew(1)>

                <cfloop query="Local.empleadosSC">
                    <cfif Local.empleadosSC.de_email NEQ '' AND !arrayFind(Local.correosEmpleados,Local.empleadosSC.de_email)>
                        <cfset arrayAppend(Local.correosEmpleados,Local.empleadosSC.de_email) >
                    </cfif>
                </cfloop>

                <cfif arrayLen(Local.correosEmpleados) GT 0>
                    <cfset Local.imagenes=[
                        {
                            dir="#session.AR_IMAGENREPORTE#",
                            disposicion='inline',
              name="logo"
                        },
                        {
                            dir="assets/img/greenLeaf.jpg",
                            disposicion='inline',
              name="footer",
              isLocal:true
                        }
                    ]>

                    <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                              method="sendMail"
                              destinatarios="#Local.correosEmpleados#"
                              asunto="Solicitud de compra"
                imagenes="#Local.imagenes#"
                              parametros="#Local.parametros#"
                              sn_plantilla="YES"
                              dir_plantilla="templates/correos/Compras/templateMailSolicitudCompra.html"
                              returnvariable="Local.rbr"/>

                    <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
                        <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                    </cfif>
                </cfif>
            </cfif>

            <cfif arguments.Operacion EQ "Surtir">
                <cfset local.Error = "">
                <!--- AQUI EMPIEZA LA INSERCCION A INVENTARIOS MOVIMIENTOS --->
                <!---   <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                            method="NextIdInventarioMovimiento"
                            id_Empresa ="#session.ID_EMPRESA#"
                            id_Sucursal = "#SESSION.ID_SUCURSAL#"
                            id_Almacen = "#session.ID_ALMACEN#"
                            returnvariable="local.id_Movimiento">--->

                <cfset local.Argumentos_InventariosMovimientos = structNew()>

                <cfset local.Argumentos_InventariosMovimientos.id_Empresa                   = session.ID_EMPRESA>
                <cfset local.Argumentos_InventariosMovimientos.id_Sucursal                  = SESSION.ID_SUCURSAL>
                <cfset local.Argumentos_InventariosMovimientos.id_Almacen                   = session.ID_ALMACEN>
                <!---<cfset local.Argumentos_InventariosMovimientos.id_Movimiento  = local.id_Movimiento>--->
                <cfset local.Argumentos_InventariosMovimientos.id_TipoMovimiento            = 6>
                <cfset local.Argumentos_InventariosMovimientos.id_UsuarioEntrego            = session.ID_USUARIO>
                <cfset local.Argumentos_InventariosMovimientos.id_UsuarioRecibio            = arguments.RequisicionesConsultaAlmacen[1].id_UsuarioSolicita>
                <cfset local.Argumentos_InventariosMovimientos.id_Requisicion               = arguments.id_Requisicion>

                <cfif arguments.configuracion_almacen EQ 1>
                    <!--- SISTEMA SIPP --->
                    <cfset local.Argumentos_InventariosMovimientos.id_UsuarioRegistroMovimiento = 1>
                <cfelse>
                    <!--- Usuario de la sesión --->
                    <cfset local.Argumentos_InventariosMovimientos.id_UsuarioRegistroMovimiento = session.ID_USUARIO>
                </cfif>


                <!---<cfinvoke   component="#Application.RF.getPath('cfc','funciones')#"
                            method="getFolio"
                            id_Movimiento ="#local.id_Movimiento#"
                            id_TipoMovimiento = "#local.Argumentos_InventariosMovimientos.id_TipoMovimiento#"
                            returnvariable="local.Folio">--->

                <!---<cfset local.Argumentos_InventariosMovimientos.fl_Movimiento = local.Folio>--->
                <cfset local.Argumentos_InventariosMovimientos.fh_Registro = dateFormat(Now(),'yyyyMMdd')>

                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                            method="AgregarMovimiento"
                            argumentcollection="#local.Argumentos_InventariosMovimientos#"
                            returnvariable="local.id_Movimiento">

                <!--- AQUI TERMINA LA INSERCCION A INVENTARIOS MOVIMIENTOS --->

                <!--- AQUI EMPIEZA LA INSERCION DE LOS CENTROS COSTO, DE LOS INSUMOS QUE SEAN CENTROS COSTO --->
                <cfloop array="#arguments.InsumosSeriados#" index="local.insumo">
                    <!--- <cfif local.insumo.SN_CENTROCOSTO> --->
                        <!---<cfinvoke  component="#Application.RF.getPath('dao','CentrosCostos')#"
                                    method="nextID"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_sucursal = "#arguments.id_SucursalSolicita#"
                                    returnvariable="local.nextId_centroCosto">--->

                        <!--- Se trae el id_ActivoFijo para poder seterle su CentroCosto --->
                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                              method="upR_ActivoFijo"
                              id_empresa="#session.ID_EMPRESA#"
                              de_SerieActivo="#local.insumo.DE_SERIEINSUMO#"
                              returnvariable="Activo"
                              >


                    <!--- <cfset local.array = #local.insumo.CAMPOS# > --->
                        <!--- se inserta en la tabla ActivosFijosCamposDetalle --->
                        <!--- <cfloop from="1" to="#arrayLen(local.array)#" index="local.p"> --->


                    <!--- Verificamos si el id_ActivoFijo viene --->
                    <cfif structKeyExists(Activo, "ID_ACTIVOFIJO") AND NOT isNull(Activo.ID_ACTIVOFIJO) AND Activo.ID_ACTIVOFIJO NEQ "">

                        <cfinvoke   component="#Application.RF.getPath('dao','ActivosFijosCamposDetalle')#"
                                method="agregarARequisicion"
                                id_Empresa    ="#session.ID_EMPRESA#"
                                id_ActivoFijo ="#Activo.ID_ACTIVOFIJO#"
                                id_Insumo ="#local.insumo.ID_INSUMO#"
                                de_SerieInsumo = "#local.insumo.DE_SERIEINSUMO#" >

                        <!--- </cfloop> --->

                        <!--- Se pone el sn_Activo=1 en los ActivosFijos y se actualiza fecha --->
                        <!--- MODIFICACION: Victor Sanchez
                                26/01/2016
                                Se setea al activo fijo el usuario que pidio la requisicion
                         --->
                            <!--- obtenemos los datos de la requisicion --->
                        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                              method="obtener_requisicion"
                              id_empresa="#session.ID_EMPRESA#"
                              id_Requisicion="#arguments.id_Requisicion#"
                              returnvariable="Req"
                        >

                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                              method="validarEtiqueta"
                              id_empresa="#Activo.ID_EMPRESA#"
                              id_ActivoFijo="#Activo.ID_ACTIVOFIJO#"
                              de_etiqueta="#Local.insumo.DE_ETIQUETA#"
                              returnvariable="etiquetas"
                              >

                        <!--- Validamos que la etiqueta no exista --->
                        <cfif #etiquetas.recordcount# GT 0>
                            <cfset variables.RBR.setError('i&La etiqueta proporcionada ya existe.')>
                            <cfreturn Variables.RBR>
                        </cfif>

                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                              method="upU_ActivosFijosSet_sn_Activo"
                              id_empresa="#Activo.ID_EMPRESA#"
                              id_ActivoFijo="#Activo.ID_ACTIVOFIJO#"
                              id_empresaEmpleado = "#Req.id_empresaEmpleado#"
                              id_EmpleadoRecibe = "#Req.id_Empleado#"
                              id_insumo = "#local.insumo.ID_INSUMO#"
                              de_etiqueta="#Local.insumo.DE_ETIQUETA#"
                              sn_Activo = "1"
                              >


                        <!--- Se agrega el detalle de ActivosFijos --->
                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="upU_ActivosFijosDetalleEntradas"
                                  id_Empresa="#Activo.ID_EMPRESA#"
                                  id_ActivoFijo="#Activo.ID_ACTIVOFIJO#"
                                  id_Sucursal="#Activo.ID_SUCURSALASIGNADO#"
                                  id_Almacen="#Activo.ID_ALMACENENTRADA#"
                                  id_Movimiento="#Activo.ID_MOVIMIENTOENTRADA#"
                                  nd_MovimientoDetalle="#Activo.ND_MOVIMIENTODETALLEENTRADA#"
                                  />


                        <cfif local.insumo.SN_ACTIVOFIJO>
                                <!--- Se verifica si ya existe un centro de costo para setearle al activo --->
                                <!--- <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                            method="upR_CentroCostoExiste"
                                            id_Empresa = "#Activo.ID_EMPRESA#"
                                            id_Sucursal = "#Activo.ID_SUCURSALASIGNADO#"
                                            id_CentroCosto ="#Activo.ID_CENTROCOSTO#"
                                            returnvariable="sn_Existe"
                                            > --->

                            <!--- Si existe el centro de costo, solo se actualiza su sn_Activo = 1 --->
                            <!--- <cfif #sn_Existe# EQ '1'>

                                        <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                              method="upU_CentroCostoSet_sn_Activo"
                                              id_Empresa="#Activo.ID_EMPRESA#"
                                              id_Sucursal="#Activo.ID_SUCURSALASIGNADO#"
                                              id_CentroCosto="#Activo.ID_CENTROCOSTO#"
                                              sn_Activo="1"
                                              >
                            <cfelse> --->
                                <!--- Si no existe se agrega --->

                                    <cfinvoke   component="#Application.RF.getPath('dao','CentrosCostos')#"
                                            method="AgregarCentroCosto"
                                            id_Empresa = "#session.ID_EMPRESA#"
                                            id_sucursal = "#arguments.id_SucursalSolicita#"
                                            id_grupoCentroCosto = "#local.insumo.ID_GRUPOCENTROCOSTO#"
                                            <!---id_CentroCosto = "#local.nextId_centroCosto#"--->
                                            nb_centroCosto = "#local.insumo.NB_NOMBREINSUMO#"
                                            id_CentroCostoPadre="#local.insumo.ID_CENTROCOSTO#"
                                            returnvariable="CentroCosto">
                                            <!--- Regresa id_CentroCosto --->



                                            <!--- Al Activo se le setea el centro de costo que se genero al darle salida
                                            al insumo --->
                                    <cfinvoke   component="#Application.RF.getPath('dao','ActivosFijos')#"
                                                method="upU_ActivoFijoSetCentroCosto"
                                                id_Empresa = "#session.ID_EMPRESA#"
                                                id_ActivoFijo = "#Activo.ID_ACTIVOFIJO#"
                                                id_CentroCosto ="#CentroCosto.ID_CENTROCOSTO#"
                                                >
                                    <!--- Generamos de_SerieActivoEmpresa hacemos el registro en ActivosFijosMovimientos  --->
                                    <cfinvoke   component="#Application.RF.getPath('dao','ActivosFijos')#"
                                                method="upU_ActivoFijoSalida"
                                                id_Empresa = "#session.ID_EMPRESA#"
                                                id_ActivoFijo = "#Activo.ID_ACTIVOFIJO#"
                                                id_CentroCosto ="#CentroCosto.ID_CENTROCOSTO#">
                        </cfif>

                    </cfif>
                </cfloop>
                <!--- AQUI TERMINA LA INSERCION DE CENTRO COSTO --->

                <!--- AQUI EMPIEZA LA INSERCCION A INVENTARIOS MOVIMIENTOS DETALLES --->
                <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.k">

                    <cfset local.Argumentos_InventariosMovimientosDetalle = structNew()>

                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Empresa = session.ID_EMPRESA>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Sucursal = SESSION.ID_SUCURSAL>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Almacen = session.ID_ALMACEN>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Movimiento = local.id_Movimiento>
                    <!---<cfset local.Argumentos_InventariosMovimientosDetalle.nd_MovimientoDetalle = local.nd_MovimientoDetalle>--->
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_CentroCosto = arguments.RequisicionesConsultaAlmacen[local.k].id_CentroCosto>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_RequisicionDetalle = arguments.RequisicionesConsultaAlmacen[local.k].id_RequisicionDetalle>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.k].id_Requisicion>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.nu_Cantidad = arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Insumo = arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_grupoGasto = arguments.RequisicionesConsultaAlmacen[local.k].id_grupoGasto>

                    <!--- Configuración de Almacenes sin Inventario --->

                    <cfif arguments.configuracion_almacen EQ 1>

                        <cfset local.Argumentos_InventariosMovimientosDetalle.id_conceptoGasto = arguments.RequisicionesConsultaAlmacen[local.k].id_conceptoGasto>

                        <cfelse>
                            <cfset local.Argumentos_InventariosMovimientosDetalle.id_conceptoGasto = arguments.RequisicionesConsultaAlmacen[local.k].id_conceptoGasto.ID_CONCEPTOGASTO>

                    </cfif>

                    <cfif arguments.RequisicionesConsultaAlmacen[local.k].sn_activofijo EQ 'true'>
                        <cfset local.Argumentos_InventariosMovimientosDetalle.id_TipoMovimiento = 13>
                    </cfif>

                    <!--- Recuperamos la bandera de presupuesto por la sucursal --->
                    <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                            method         = "getBanderaPresupuestoSucursal"
                            id_Empresa     = "#local.Argumentos_InventariosMovimientosDetalle.id_Empresa#"
                            id_Sucursal    = "#local.Argumentos_InventariosMovimientosDetalle.id_Sucursal#"
                            returnvariable = "local.sucursal_bandera">

                    <!--- Si no se encuetra activada la bandera de presupuestos la validacion se pone en falso --->
                    <!--- revisamos presupuesto para abastecedoras --->
                    <cfif isDefined("local.ff_Presupuestos") AND local.ff_Presupuestos EQ 1 AND #local.sucursal_bandera.sn_Presupuestos# EQ 1>
                        <cfset arguments.sn_ValidarPresupuesto = 1>
                    <cfelse>
                        <cfset arguments.sn_ValidarPresupuesto = 0>
                    </cfif>

                    <!--- <cfdump var="#Argumentos_InventariosMovimientosDetalle#"> --->
                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="AgregarInventarioMovDetalle"
                                argumentcollection="#local.Argumentos_InventariosMovimientosDetalle#"
                                sn_ValidarPresupuesto = "#arguments.sn_ValidarPresupuesto#"
                                returnvariable="local.nd_MovimientoDetalle">

                    <cfif #arguments.sn_ValidarPresupuesto# EQ 1>

                        <!--- validamos disponiblidad de presupuesto --->
                        <cfinvoke component="#application.RF.getPath('dao', 'DashboardPresupuestos')#"
                        method="validarPresupuestoDisponible"
                        id_Empresa="#local.Argumentos_InventariosMovimientosDetalle.id_Empresa#"
                        id_CargaPresupuesto=""
                        id_CuentaPresupuesto=""
                        id_Requisicion="#local.Argumentos_InventariosMovimientosDetalle.id_Requisicion#"
                        id_Insumo="#local.Argumentos_InventariosMovimientosDetalle.id_Insumo#"
                        id_SolicitudDeViaje=""
                        id_SolicitudDeVuelo=""
                        id_ConceptoDeViaje=""
                        id_TipoImporteExtra=""
                        sn_Vuelo="0"
                        returnvariable="local.IMD">

                        <!--- <cfcontent type="text/html">
                        <cfdump var="#local.IMD#" label="" format = "html"  abort="true"> --->
                        <cfif isDefined("local.IMD.sn_Error") AND #local.IMD.sn_Error# EQ 1>
                            <cfset local.jsonres = 'sn_PresupuestoFaltante<>[{
                                    "de_Email_Solicitante": "#local.IMD.de_Email_Solicitante#",
                                    "nb_Solicitante": "#local.IMD.nb_Solicitante#",
                                    "fh_Requisicion": "#local.IMD.fh_RegistroFormato#",
                                    "nb_EmpresaSucursal": "#local.IMD.nb_EmpresaSucursal#",
                                    "fl_Requisicion": "#local.IMD.fl_FolioMovimiento#",
                                    "nb_Jefe": "#local.IMD.nb_Jefe#",
                                    "de_Email_Jefe": "#local.IMD.de_Email_Jefe#",
                                    "nb_GrupoGasto": "#local.IMD.nb_GrupoGasto#",
                                    "de_ConceptoCuenta": "#local.IMD.de_ConceptoCuenta#",
                                    "im_PresupuestoFaltante": "#local.IMD.im_PresupuestoFaltante#"
                            }]'>

                            <cfset variables.RBR.setError(local.jsonres)>
                            <cfreturn variables.RBR>

                        </cfif> <!--- isDefined("local.IMD.sn_Error") AND #local.IMD.sn_Error# EQ 1 --->
                    </cfif> <!-- ff -->
                    <!--- fin de la validamos disponiblidad de presupuesto --->

                    <!---
                    ESTO LO ARA UN TRIGGER
                    <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                method="EditarExistencia"
                                id_Empresa ="#session.ID_EMPRESA#"
                                id_Sucursal = "#SESSION.ID_SUCURSAL#"
                                id_Almacen = "#session.ID_ALMACEN#"
                                nu_Cantidad = "#arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir#"
                                id_Insumo = "#arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo#"> --->

                    <!--- se pregunta si el insumo es seriado --->
                    <cfif arguments.RequisicionesConsultaAlmacen[local.k].SN_INSUMOSERIADO EQ 'true'>
                        <!---si el insumo es seriado se hace el recorrido de la cantidad que se se surtio, ya que si era seriado es la misma cantidad de
                        series capturadas las cuales se eliminaran las existencias de las series, al igual sera el mismo numero de inventarios detalles de series
                        que se registraran--->
                        <!--- <cfdump var="#arguments.InsumosSeriados#"> --->
                        <cfloop from="1" to="#arrayLen(arguments.InsumosSeriados)#" index="local.x">
                            <!--- se pregunta si se ara referencia al mismo insumo --->
                            <cfif arguments.RequisicionesConsultaAlmacen[local.k].ID_INSUMO EQ arguments.InsumosSeriados[local.x].ID_INSUMO>
                                <!--- funcion que elimina las series de la existencia --->
                                <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                                            method="eliminar"
                                            id_empresa ="#session.ID_EMPRESA#"
                                            id_sucursal = "#SESSION.ID_SUCURSAL#"
                                            id_almacen = "#session.ID_ALMACEN#"
                                            id_insumo = "#arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo#"
                                            id_almacenexistenciaserieinsumo = "#arguments.InsumosSeriados[local.x].ID_ALMACENEXISTENCIASERIEINSUMO#">

                                <!--- se trae el nextid para el inventario movimiento detalle de series  --->
                                <!---<cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                            method="nextID"
                                            id_empresa ="#session.ID_EMPRESA#"
                                            id_sucursal = "#SESSION.ID_SUCURSAL#"
                                            id_almacen = "#session.ID_ALMACEN#"
                                            id_movimiento = "#local.id_Movimiento#"
                                            nd_movimientoDetalle = "#local.nd_MovimientoDetalle#"
                                            returnvariable="local.nd_inventariomovimientodetalleserie">--->


                                <!--- se trae el nextid para el inventario movimiento detalle de series  --->
                                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                            method="agregarinventariomovmientoseries"
                                            id_empresa ="#session.ID_EMPRESA#"
                                            id_sucursal = "#SESSION.ID_SUCURSAL#"
                                            id_almacen = "#session.ID_ALMACEN#"
                                            id_movimiento = "#local.id_Movimiento#"
                                            nd_movimientoDetalle = "#local.nd_MovimientoDetalle#"
                                            de_serieInsumo ="#arguments.InsumosSeriados[local.x].DE_SERIEINSUMO#"
                                            de_etiqueta="#Local.insumo.DE_ETIQUETA#">

                            </cfif>
                        </cfloop>
                    </cfif>
                    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                </cfloop>
                <!--- AQUI TERMINA LA INSERCCION A INVENTARIOS MOVIMEINTOS DETALLES --->

                <cfif local.EntrTraspaso.keyExists("id_Movimiento")>
                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                        method="ActualizarRelacionConsignacion"
                        id_empresa="#session.ID_EMPRESA#"
                        id_Sucursal="#session.ID_SUCURSAL#"
                        id_Almacen="#session.ID_ALMACEN#"
                        id_MovimientoSalida="#local.id_Movimiento#"
                        id_MovimientoEntrConsg="#local.EntrTraspaso.id_Movimiento#">
                </cfif>

                <!--- SE OBTENDRA EL REQUISICION PARA LA VALIDACION DE ORDENES DE SERVICIO  --->
                <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                              method="obtener_requisicion"
                              id_empresa="#session.ID_EMPRESA#"
                              id_Requisicion="#arguments.id_Requisicion#"
                              returnvariable="Reqs"
                              >
                <!--- TIPO DIVISION 14 DE ORDEN DE SERVICIO  --->
                <cfif Reqs.id_TipoDivision EQ 14>
                    <cfinvoke   component="#Application.RF.getPath('dao','OrdenesServicio')#"
                            id_Empresa      ="#Reqs.id_Empresa#"
                            id_Requisicion     ="#Reqs.id_Requisicion#"
                            id_UsuarioInicia      ="#Reqs.id_UsuarioSolicita#"
                            sn_mov = 3
                            sn_Finaliza = 1
                            method  ="RequerimientoOrdenesServicioMov">
                </cfif>

                <!--- LLAMADO AL FUNCION QUE EJECUTA EL METODO DE UP_INVENTARIOSMOVIMIENTOS_APLICAMETODOSSALIDA --->
                <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                            id_Empresa      ="#session.ID_EMPRESA#"
                            id_Sucursal     ="#SESSION.ID_SUCURSAL#"
                            id_Almacen      ="#session.ID_ALMACEN#"
                            id_Movimiento   ="#local.id_Movimiento#"
                            method  ="AplicaMetodoASalida">

                <!--- LLAMADO AL FUNCION QUE EJECUTA EL METODO DE UP_INVENTARIOSMOVIMIENTOS_APLICAMETODOSSALIDA --->
                <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                            id_Empresa      ="#session.ID_EMPRESA#"
                            id_Sucursal     ="#SESSION.ID_SUCURSAL#"
                            id_Almacen      ="#session.ID_ALMACEN#"
                            id_Movimiento   ="#local.id_Movimiento#"
                            method  ="ActualizarCostoPromedioAlmacen">
                <!--- < --- < --- < --- > --- > --- > --->

                <!--- Eliminamos los registros de recordatorio de la requisicion --->
                <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                    method="RequisicionesEliminarRecordatorio"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_Requisicion="#arguments.id_Requisicion#">

                <cfif isDefined("Activo")>

                    <!---Omar Ibarra, 09/07/2017, Envío de Correo al Surtir--->
                    <cfinvoke   component="#Application.RF.getPath('dao','ConsultaEntradaCompra')#"
                                method="ObtenerActivoFijoEntradaCompra"
                                id_Empresa     = #session.ID_EMPRESA#
                                id_Sucursal    = #SESSION.ID_SUCURSAL#
                                id_Almacen     = #session.ID_ALMACEN#
                                id_Movimiento  = #local.id_Movimiento#
                                returnvariable ="Local.RS">
                    <cfif Local.RS.Result EQ 1>
                        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                    method="impresionDeMovimientosEncabezado"
                                    id_Empresa     = #session.ID_EMPRESA#
                                    id_Sucursal    = #SESSION.ID_SUCURSAL#
                                    id_Almacen     = #session.ID_ALMACEN#
                                    id_Movimiento  = #local.id_Movimiento#
                                    returnvariable ="data">

                        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                    method="impresionDeMovimientosDetalle"
                                    id_Empresa     = #session.ID_EMPRESA#
                                    id_Sucursal    = #SESSION.ID_SUCURSAL#
                                    id_Almacen     = #session.ID_ALMACEN#
                                    id_Movimiento  = #local.id_Movimiento#
                                    returnvariable ="insumos">

                        <!---Enviar Notificación de Entrada Activo Fijo, Omar Ibarra 07/06/2017--->
                        <cfset fh_Salida = dateFormat(Now(),'dd/MM/yyyy')>
                        <cfset datos = structNew()>
                        <cfset local.datosSP = structNew()>
                        <cfset local.datosSP = {
                            nb_Empresa       = #data.nb_Empresa#,
                            nb_Sucursal      = #data.nb_Sucursal#,
                            nb_Almacen       = #data.nb_Almacen#,
                            nb_Almacenista   = #data.nb_Almacenista#,
                            fecha_Salida     = #fh_Salida#,
                            folio_Movimiento = #data.fl_movimiento#,
                            id_Requisicion   = #Req.id_Requisicion#,
                            insumos          = #insumos#
                        }>

                        <cfset datos ={
                            datosSP = local.datosSP
                        }>

                        <!--- Generamos las notificaciones --->
                        <cfinvoke component="#Application.RF.getPath('Bro','configuracionNotificaciones')#"
                                  method="NotificarEmpleados"
                                  argumentcollection="#arguments#"
                                  id_Sucursal       ="#SESSION.ID_SUCURSAL#"
                                  id_Notificacion   ="17"
                                  datos ="#datos#"
                                  dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailSalidaSurtidoPorActivoFijo.html"
                                  returnvariable="local.notificacion">
                    </cfif>
                </cfif>

            </cfif>
        <cfelse>
            <cfset variables.RBR.setError('w&Ocurrio un error.')>
        </cfif>
        <cfset var Local.infoMovto={
            id_Movimiento="#local.id_Movimiento#"
        }>

        <cfset variables.RBR.setData(Local.infoMovto)>
        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="validarSalidaConsumo" access="public" returntype="Any">
        <cfargument name="id_Requisicion" type="string" required="no" default="">
        <cfargument name="de_Password"    type="string" required="no" default="">

            <cfset arguments.id_Empresa = session.ID_EMPRESA>
            <!--- <cfset arguments.de_Password = encrypt(arguments.de_Password,'petroil')> --->


            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="obtener_requisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.usuario">


            <cfif Local.usuario.NB_USUARIO EQ arguments.de_UserName>

                <cfinvoke component="#Application.RF.getPath('dao','usuarios')#"
                      method="getByName"
                      nb_usuario="#arguments.de_UserName#"
                      returnvariable="Local.user">

                <cfif "X#decrypt(Local.user.cl_Contrasena,'petroil')#" NEQ "X#Arguments.de_Password#">
                    <cfset variables.RBR.setError('Usuario o contraseña no validos.')>
                </cfif>

            <cfelse>
                <cfset variables.RBR.setError('Usuario o contraseña no validos.')>
            </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getUsuarioPermisos" access="public" returntype="Any">
        <cfargument name="id_Usuario"   type="string" required="false" default=""/>
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="getUsuarioPermisos"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="NotificarRequisitante" access="public" returntype="Any">
        <cfargument name="id_Sucursal"     type="string" required="false" default=""/>
        <cfargument name="id_Requisicion"  type="string" required="false" default=""/>
        <cfargument name="nb_Requisitante" type="string" required="false" default=""/>
        <cfargument name="de_emailReq"     type="string" required="false" default=""/>
        <cfargument name="ar_email"        type="array"  required="false" default=""/>
        <cfargument name="de_Direccion"    type="string" required="false" default=""/>
        <cfargument name="ar_insumos"      type="array"  required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','usuarios')#"
            method="getByIDEmpleado"
            id_empleado="#session.ID_EMPLEADO#"
            returnvariable="Local.user">

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="getMovimientosEntrada"
            id_Empresa="#session.ID_EMPRESA#"
            id_Requisicion="#arguments.id_Requisicion#"
            id_Estatus="301"
            returnvariable="Local.Movimientos">

        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
            method="getInformacionAtencion"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#session.ID_ALMACEN#"
            returnvariable="Local.Almacen">

        <!--- 1. Definir destinatarios --->
        <cfset Local.correosEmpleados = arrayNew(1)>
        <cfset arrayAppend(Local.correosEmpleados, arguments.de_emailReq)>
        <cfloop array="#arguments.ar_email#" index="email">
            <cfset arrayAppend(Local.correosEmpleados, email)>
        </cfloop>

        <!--- 2. Definir parametros del template --->
        <cfset Local.parametros.Insumos         = arguments.ar_insumos>
        <cfset Local.parametros.id_Requisicion  = arguments.id_Requisicion>
        <cfset Local.parametros.nb_Requisitante = arguments.nb_Requisitante>
        <cfset Local.parametros.de_Direccion    = arguments.de_Direccion>
        <cfset Local.parametros.de_Horario      = Local.Almacen.de_Horario>
        <cfset Local.parametros.nb_Almacenista  = Local.Almacen.NB_EMPLEADO>
        <cfset Local.parametros.de_Puesto       = Local.user.nb_Puesto>
        <cfset Local.parametros.nb_Empresa      = session.NB_EMPRESA>
        <cfset Local.parametros.nb_Sucursal     = Local.Almacen.nb_Sucursal>
        <cfset Local.parametros.de_Contacto     = Local.Almacen.DE_EMAIL>
        <cfset local.de_template = "templates/correos/AlmacenesEInventarios/templateMailNotificarEntregaRequisicionStock.html">

        <cfset Local.imagenes=[
            {
                dir="#session.AR_IMAGENREPORTE#",
                disposicion='inline',
                name="logo"
            },
            {
                dir="assets/img/greenLeaf.jpg",
                disposicion='inline',
                name="footer",
                isLocal:true
            }
        ]>

        <cfset variables.parametros = Local.parametros>
        <!--- 3. Capturar el HTML del template con los parametros ya definidos --->
        <cfsavecontent variable="Local.de_CorreoHTML">
            <cfinclude template="/templates/correos/AlmacenesEInventarios/templateMailNotificarEntregaRequisicionStockCaptura.html">
        </cfsavecontent>

        <cfset structDelete(variables, "parametros")>

        <!--- 4. Guardar la notificacion en BD con el HTML generado --->
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="GuardarNotificacion"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#session.ID_ALMACEN#"
            id_Requisicion="#arguments.id_Requisicion#"
            de_Correo="#Local.de_CorreoHTML#">

            <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
              method="getCorreoAlmacenistaNotificacion"
              returnvariable="Local.correoAlmacenista">

        <!--- Agregar a BCC si existe el correo --->
        <cfset Local.de_EmailBcc = "">
        <cfif NOT Local.correoAlmacenista.recordCount EQ 0 AND Local.correoAlmacenista.de_valor NEQ "">
            <cfset Local.de_EmailBcc = Local.correoAlmacenista.de_valor>
        </cfif>

        <!--- 5. Enviar el correo --->
        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
            method="sendMail"
            destinatarios="#Local.correosEmpleados#"
            asunto="Insumos Disponibles para Entrega."
            imagenes="#Local.imagenes#"
            parametros="#Local.parametros#"
            sn_plantilla="YES"
            dir_plantilla="#local.de_template#"
            de_EmailBcc="#Local.de_EmailBcc#"
            returnvariable="Local.rbr"/>

        <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="RecordatorioEntregaRequisicion" access="public" returntype="Any">
        <!--- Devuelve un listado de las requisiciones las cuales es necesario volver a notificar --->
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="RequisicionesANotificar"
            returnvariable="Local.Requisiciones"/>

        <cfset agrupado = {}>
        <cfloop query="#Local.Requisiciones.List#">
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="getById"
                id_Empresa="#Local.Requisiciones.List.id_Empresa#"
                id_Requisicion="#Local.Requisiciones.List.id_Requisicion#"
                returnvariable="Local.infoReq">

            <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                method="getInformacionAtencion"
                id_Empresa="#Local.infoReq.id_Empresa#"
                id_Sucursal="#Local.infoReq.id_SucursalSolicita#"
                returnvariable="Local.Almacen">

            <cfset Local.correosEmpleados = arrayNew(1)>
            <cfset arrayAppend(Local.correosEmpleados, Local.infoReq.de_Email)>

            <cfset Local.parametros.nb_Empresa = Local.infoReq.nb_Empresa>
            <cfset Local.parametros.nb_Sucursal = Local.infoReq.nb_Sucursal>
            <cfset Local.parametros.id_Requisicion = Local.Requisiciones.List.id_Requisicion>
            <cfset Local.parametros.nb_Requisitante = Local.infoReq.nb_empleado>
            <cfset Local.parametros.de_Direccion = Local.Almacen.de_Direccion>
            <cfset Local.parametros.de_Horario = Local.Almacen.de_Horario>

            <cfset Local.imagenes=[
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
                    isLocal:true
                }
            ]>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#Local.correosEmpleados#"
                asunto="Insumos disponibles para entrega."
                imagenes="#Local.imagenes#"
                parametros="#Local.parametros#"
                sn_plantilla="YES"
                dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailNotificarEntregaRequisicionRecordatorio.html"
                returnvariable="Local.rbr"/>

            <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
                <cfbreak>
            </cfif>
        </cfloop>

        <!--- Empezamos a notificar al almacenista de las requisiciones --->
        <!--- Es un correo por cada Empresa/Sucursal/Almacen --->
        <cfloop query="#Local.Requisiciones.Summary#">
            <cfset Local.params.requisiciones = ListToArray(Local.Requisiciones.Summary.Requisiciones, ",")>
            <cfset Local.params.correosEmpleados = ListToArray(Local.Requisiciones.Summary.de_Email, ",")>

            <cfset Local.destinatarios = arrayNew(1)>
            <cfloop array="#Local.params.correosEmpleados#" index="email">
                <cfif email NEQ '' && not arrayFind(Local.destinatarios, email)>
                    <cfset arrayAppend(Local.destinatarios, email)>
                </cfif>
            </cfloop>

            <cfset Local.params.nb_Empresa = Local.Requisiciones.Summary.nb_Empresa>
            <cfset Local.params.nb_Sucursal = Local.Requisiciones.Summary.nb_Sucursal>
            <cfset Local.params.nb_Almacen = Local.Requisiciones.Summary.nb_Almacen>

            <cfset Local.imagenes=[
                {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
                    isLocal:true
                }
            ]>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#Local.destinatarios#"
                asunto="Resumen Requisiciones Proximas a Finalizar."
                imagenes="#Local.imagenes#"
                parametros="#Local.params#"
                sn_plantilla="YES"
                dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailNotificarRequisicionesPorExpirar.html"
                returnvariable="Local.rbr"/>

            <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
            </cfif>
        </cfloop>

        <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
            <cfset Variables.RBR.setError('Hubo un problema al enviar el correo')>
        <cfelse>
            <cfset Variables.RBR.setMessage('Se envio el correo correctamente.')>
        </cfif>

        <!--- Realizamos la eliminacion de los registros para notificar el recordatorio de surtir los insumos--->
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="quitarRecordatorioSurtir">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="DevolverRequisicion" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="true"/>
        <cfargument name="id_Requisicion"       type="string" required="true"/>
        <cfargument name="de_MotivosDevolucion" type="string" required="true"/>

        <!--- Cambiamos le estatus de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
            method="Editar"
            id_Empresa="#arguments.id_Empresa#"
            id_Requisicion="#arguments.id_Requisicion#"
            id_EstatusAutorizacion="#10#">
            <!--- de_Observaciones="#arguments.de_MotivosDevolucion#" --->

        <!--- Realizamos el insert del registro de autorizacion de una devolucion --->
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="DevolverRequisicionAutorizacion"
            id_Empresa="#arguments.id_Empresa#"
            id_Requisicion="#arguments.id_Requisicion#"
            id_UsuarioAutoriza="#session.ID_USUARIO#"
            id_EstatusAutorizacionRequisicion="#10#"
            de_Comentarios="#arguments.de_MotivosDevolucion#"
            sn_Almacenista="#1#"
            returnvariable="Local.rs">

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getById"
            id_Empresa="#arguments.id_Empresa#"
            id_Requisicion="#arguments.id_Requisicion#"
            returnvariable="Local.infoReq">

        <cfset Local.destinatarios = arrayNew(1)>
        <cfset arrayAppend(Local.destinatarios, Local.infoReq.de_Email)>

        <cfset Local.imagenes=[
            {
                dir="assets/img/greenLeaf.jpg",
                disposicion='inline',
                name="footer",
                isLocal:true
            }
        ]>

        <cfset local.parametros = structNew()>
        <cfset Local.parametros.id_Requisicion = arguments.id_Requisicion>
        <cfset Local.parametros.de_Comentarios = arguments.de_MotivosDevolucion>
        <cfset Local.parametros.nb_Requisitante = Local.infoReq.nb_empleado>

        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
            method="sendMail"
            destinatarios="#Local.destinatarios#"
            asunto="Devolución de requisición para corrección."
            imagenes="#Local.imagenes#"
            parametros="#Local.parametros#"
            sn_plantilla="YES"
            dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailNotificacionDevolucionRequisicion.html"
            returnvariable="Local.rbr"/>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
