<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen  = session.ID_ALMACEN>

        <cfset local.DetalleRequisicion=structNew()>

        <cfinvoke   component="#Application.RF.getPath('dao','Requisiciones')#"
                    method="listarparaRegistroSalidaAlmacen"
                    argumentcollection="#arguments#"
                    returnvariable="Local.DatosRequisicion">

        <cfset local.DetalleRequisicion.DatosRequisicion = local.DatosRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','Requisicionesdetalle')#"
                  method="listarparaRegistroSalidaAlmacen"
                  argumentcollection="#arguments#"
                  returnvariable="Local.Requisicionesdetalle">

        <cfset local.DetalleRequisicion.Requisicionesdetalle= local.Requisicionesdetalle>

        <!--- <cfdump var="#local.DetalleRequisicion#"> <cfabort> --->
        <cfset variables.RBR.setData(local.DetalleRequisicion)>
        
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Editar"  access="public" returntype="Any">
        <cfargument name="RequisicionesConsultaAlmacen" type="array"    required="true"/>
        <cfargument name="InsumosSeriados"              type="array"    required="true"/>
        <cfset local.Error = ''>
        <cfset local.insumo = ''>

        <!--- se verifican la cantidades que vengan de la interfaz con las cantidades que realmente hay en almacen esto es por seguridad --->
        
        <!--- SANITIZACIÓN DE NOMBRES DE INSUMO PARA EVITAR CONCATENACIÓN CON SERIE --->
        <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.idxSanit">
            <cfset local.itemSanit = arguments.RequisicionesConsultaAlmacen[local.idxSanit]>
            <cfif structKeyExists(local.itemSanit, "NB_NOMBREINSUMO")>
                <cfset local.nb_NombreSanitizado = trim(local.itemSanit.NB_NOMBREINSUMO)>
                <cfset local.serieSanitizar = structKeyExists(local.itemSanit, "DE_SERIEINSUMO") ? trim(local.itemSanit.DE_SERIEINSUMO) : "">
                <cfset local.etiquetaSanitizar = structKeyExists(local.itemSanit, "DE_ETIQUETA") ? trim(local.itemSanit.DE_ETIQUETA) : "">

                <!--- Sanitizar contra serie --->
                <cfif len(local.serieSanitizar)>
                    <cfif right(local.nb_NombreSanitizado, len(' - ' & local.serieSanitizar)) EQ ' - ' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.serieSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len('-' & local.serieSanitizar)) EQ '-' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.serieSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.serieSanitizar)) EQ ' ' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.serieSanitizar)))>
                    </cfif>
                </cfif>
                <!--- Sanitizar contra etiqueta --->
                <cfif len(local.etiquetaSanitizar)>
                    <cfif right(local.nb_NombreSanitizado, len(' - ' & local.etiquetaSanitizar)) EQ ' - ' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.etiquetaSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len('-' & local.etiquetaSanitizar)) EQ '-' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.etiquetaSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.etiquetaSanitizar)) EQ ' ' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.etiquetaSanitizar)))>
                    </cfif>
                </cfif>
                <cfset arguments.RequisicionesConsultaAlmacen[local.idxSanit].NB_NOMBREINSUMO = local.nb_NombreSanitizado>
            </cfif>
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.InsumosSeriados)#" index="local.idxSanitS">
            <cfset local.itemSerSanit = arguments.InsumosSeriados[local.idxSanitS]>
            <cfif structKeyExists(local.itemSerSanit, "NB_NOMBREINSUMO")>
                <cfset local.nb_NombreSanitizado = trim(local.itemSerSanit.NB_NOMBREINSUMO)>
                <cfset local.serieSanitizar = structKeyExists(local.itemSerSanit, "DE_SERIEINSUMO") ? trim(local.itemSerSanit.DE_SERIEINSUMO) : "">
                <cfset local.etiquetaSanitizar = structKeyExists(local.itemSerSanit, "DE_ETIQUETA") ? trim(local.itemSerSanit.DE_ETIQUETA) : "">

                <!--- Sanitizar contra serie --->
                <cfif len(local.serieSanitizar)>
                    <cfif right(local.nb_NombreSanitizado, len(' - ' & local.serieSanitizar)) EQ ' - ' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.serieSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len('-' & local.serieSanitizar)) EQ '-' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.serieSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.serieSanitizar)) EQ ' ' & local.serieSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.serieSanitizar)))>
                    </cfif>
                </cfif>
                <!--- Sanitizar contra etiqueta --->
                <cfif len(local.etiquetaSanitizar)>
                    <cfif right(local.nb_NombreSanitizado, len(' - ' & local.etiquetaSanitizar)) EQ ' - ' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' - ' & local.etiquetaSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len('-' & local.etiquetaSanitizar)) EQ '-' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len('-' & local.etiquetaSanitizar)))>
                    <cfelseif right(local.nb_NombreSanitizado, len(' ' & local.etiquetaSanitizar)) EQ ' ' & local.etiquetaSanitizar>
                        <cfset local.nb_NombreSanitizado = trim(left(local.nb_NombreSanitizado, len(local.nb_NombreSanitizado) - len(' ' & local.etiquetaSanitizar)))>
                    </cfif>
                </cfif>
                <cfset arguments.InsumosSeriados[local.idxSanitS].NB_NOMBREINSUMO = local.nb_NombreSanitizado>
            </cfif>
        </cfloop>

        <cfloop from="1" to="#arrayLen(RequisicionesConsultaAlmacen)#" index="local.z">
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="CantidadExistenciaInsumo"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal ="#SESSION.ID_SUCURSAL#"
                        id_Almacen ="#session.ID_ALMACEN#"
                        id_Insumo = "#arguments.RequisicionesConsultaAlmacen[local.z].id_Insumo#"
                        returnvariable="local.Nu_Existencia">

            <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.m">
                <cfif arguments.RequisicionesConsultaAlmacen[local.m].CantidadaSurtir GT local.Nu_Existencia.nu_Existencia
                      AND arguments.RequisicionesConsultaAlmacen[local.m].ID_INSUMO EQ local.Nu_Existencia.ID_INSUMO>
                    <cfset local.Error = 1>
                    <cfset local.insumo = local.Nu_Existencia.NB_NOMBREINSUMO>
                    <cfbreak>                           
                </cfif>
            </cfloop>
        </cfloop>

        <cfif local.Error EQ 1>
            <cfset variables.RBR.setError('La cantidad del insumos '& local.insumo&' supera la existencia en almacén.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfif NOT variables.RBR.hasError()>
            <cfset local.Vacios = 0>

            <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.j">
                <cfif arguments.RequisicionesConsultaAlmacen[local.j].CANTIDADASURTIR NEQ ''>
                    <cfset local.Argumentos_Requisicion= structNew()> 

                    <cfset local.Argumentos_Requisicion.id_Empresa = session.ID_EMPRESA>
                    <cfset local.Argumentos_Requisicion.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                    <cfset local.Argumentos_Requisicion.id_Insumo = arguments.RequisicionesConsultaAlmacen[local.j].id_Insumo>
                    <cfset local.Argumentos_Requisicion.id_RequisicionDetalle =  arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle>
                    <cfset local.Argumentos_Requisicion.nu_Cantidad = arguments.RequisicionesConsultaAlmacen[local.j].Nu_Cantidad>
                    <cfset local.Argumentos_Requisicion.nu_CantidadaSurtir = arguments.RequisicionesConsultaAlmacen[local.j].CantidadaSurtir>

                    <cfinvoke  component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="Editar"
                                argumentcollection="#Argumentos_Requisicion#">

                    <cfinvoke  component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                method="getCantidades"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                id_RequisicionDetalle="#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                returnvariable="local.nu_Cantidades">

                    <cfif local.nu_Cantidades.nu_Cantidad GT local.nu_Cantidades.nu_CantidadSurtida>
                            <cfinvoke  component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                        method="setIdSurtido"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                        id_RequisicionDetalle="#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                        id_Estatus= "2">
                    <cfelseif local.nu_Cantidades.nu_Cantidad EQ local.nu_Cantidades.nu_CantidadSurtida>
                            <cfinvoke  component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                                        method="setIdSurtido"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_Requisicion = "#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                        id_RequisicionDetalle="#arguments.RequisicionesConsultaAlmacen[local.j].id_RequisicionDetalle#"
                                        id_Estatus= "1">     
                    </cfif>

                    <cfinvoke  component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                method="CountDetalleRequisicionesSurtidasParcialmente"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_Requisicion ="#arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion#"
                                returnvariable="local.NumSurtidasParcialmente">

                    <cfif local.NumSurtidasParcialmente.NumCantidad GT 0>
                            <cfset local.Argumentos_EditarEstatusRequisicion= structNew()>

                            <cfset local.Argumentos_EditarEstatusRequisicion.id_Empresa = session.ID_EMPRESA>
                            <cfset local.Argumentos_EditarEstatusRequisicion.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                            <cfset local.Argumentos_EditarEstatusRequisicion.id_EstatusSurtido = 2>

                            <cfinvoke  component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                        method="EditarEstatusSurtidoRequisicion"
                                        argumentcollection="#local.Argumentos_EditarEstatusRequisicion#">
                    <cfelseif local.NumSurtidasParcialmente.NumCantidad EQ 0 >
                            <cfset local.Argumentos_EditarEstatusRequisicion = structNew()>

                            <cfset local.Argumentos_EditarEstatusRequisicion.id_Empresa = session.ID_EMPRESA>
                            <cfset local.Argumentos_EditarEstatusRequisicion.id_Requisicion = arguments.RequisicionesConsultaAlmacen[local.j].id_Requisicion>
                            <cfset local.Argumentos_EditarEstatusRequisicion.id_EstatusSurtido = 1>

                            <cfinvoke  component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                                        method="EditarEstatusSurtidoRequisicion"
                                        argumentcollection="#local.Argumentos_EditarEstatusRequisicion#">
                    </cfif> 
                <cfelse>
                    <cfset local.Vacios ++>
                </cfif>
            </cfloop>

            <cfset local.Insumos = "#arrayLen(arguments.RequisicionesConsultaAlmacen)#">

            <cfif local.Vacios NEQ local.Insumos>
                <!--- AQUI EMPIEZA LA INSERCCION A INVENTARIOS MOVIMIENTOS --->
                        <!--- AQUI EMPIEZA LA INSERCCION A INVENTARIOS MOVIMIENTOS --->
                <!---<cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                            method="NextIdInventarioMovimiento"
                            id_Empresa ="#session.ID_EMPRESA#"
                            id_Sucursal = "#SESSION.ID_SUCURSAL#"
                            id_Almacen = "#session.ID_ALMACEN#"
                            returnvariable="local.id_Movimiento">--->

                <cfset local.Argumentos_InventariosMovimientos = structNew()>               
                <cfset local.Argumentos_InventariosMovimientos.id_Empresa  = session.ID_EMPRESA>
                <cfset local.Argumentos_InventariosMovimientos.id_Sucursal = SESSION.ID_SUCURSAL>
                <cfset local.Argumentos_InventariosMovimientos.id_Almacen  = session.ID_ALMACEN>
                <!---<cfset local.Argumentos_InventariosMovimientos.id_Movimiento  = local.id_Movimiento>--->
                <cfset local.Argumentos_InventariosMovimientos.id_TipoMovimiento  = 6>
                <cfset local.Argumentos_InventariosMovimientos.id_UsuarioEntrego  = session.ID_USUARIO>
                <cfset local.Argumentos_InventariosMovimientos.id_UsuarioRecibio  = arguments.RequisicionesConsultaAlmacen[1].id_UsuarioSolicita>
                <cfset local.Argumentos_InventariosMovimientos.id_Requisicion  = arguments.RequisicionesConsultaAlmacen[1].id_Requisicion>
                <cfset local.Argumentos_InventariosMovimientos.id_UsuarioRegistroMovimiento  = session.ID_USUARIO>
                <!---<cfset local.Argumentos_InventariosMovimientos.fh_Registro  = dateFormat(Now(),'yyyyMMdd')>--->
            
                <!---<cfinvoke   component="#Application.RF.getPath('cfc','funciones')#"
                            method="getFolio"
                            id_Movimiento ="#local.id_Movimiento#"
                            id_TipoMovimiento = "6"
                            returnvariable="local.Folio">--->

                <!---<cfset local.Argumentos_InventariosMovimientos.fl_Movimiento = local.Folio>--->
                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                            method="AgregarMovimiento"
                            argumentcollection="#local.Argumentos_InventariosMovimientos#"
                           returnvariable="local.id_Movimiento">
                <!--- AQUI TERMINA LA INSERCCION A INVENTARIOS MOVIMIENTOS --->
            </cfif>

            <!--- AQUI EMPIEZA LA INSERCCION A INVENTARIOS MOVIMIENTOS DETALLES --->
            <cfloop from="1" to="#arrayLen(arguments.RequisicionesConsultaAlmacen)#" index="local.k">
                <cfif arguments.RequisicionesConsultaAlmacen[local.K].CANTIDADASURTIR NEQ ''>
                    <!---<cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="NextIdInventarioMovimientoDetalle"
                                id_Empresa ="#session.ID_EMPRESA#"
                                id_Sucursal = "#SESSION.ID_SUCURSAL#"
                                id_Almacen = "#session.ID_ALMACEN#"
                                id_Movimiento = "#local.id_Movimiento#"
                                returnvariable="local.nd_MovimientoDetalle">--->

                    <cfset local.Argumentos_InventariosMovimientosDetalle = structNew()>

                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Empresa  = session.ID_EMPRESA>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Sucursal = SESSION.ID_SUCURSAL>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Almacen  = session.ID_ALMACEN>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Movimiento  = local.id_Movimiento>
                    <!---<cfset local.Argumentos_InventariosMovimientosDetalle.nd_MovimientoDetalle  = local.nd_MovimientoDetalle>--->
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_CentroCosto  = arguments.RequisicionesConsultaAlmacen[local.k].id_CentroCosto>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_RequisicionDetalle  = arguments.RequisicionesConsultaAlmacen[local.k].id_RequisicionDetalle>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Requisicion  = arguments.RequisicionesConsultaAlmacen[local.k].id_Requisicion>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.nu_Cantidad  = arguments.RequisicionesConsultaAlmacen[local.k].CantidadaSurtir>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_Insumo = arguments.RequisicionesConsultaAlmacen[local.k].id_Insumo>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_grupoGasto = arguments.RequisicionesConsultaAlmacen[local.k].id_grupoGasto>
                    <cfset local.Argumentos_InventariosMovimientosDetalle.id_conceptoGasto = arguments.RequisicionesConsultaAlmacen[local.k].id_conceptoGasto>

                    <cfif arguments.RequisicionesConsultaAlmacen[local.k].sn_activofijo EQ 'true'>
                        <cfset local.Argumentos_InventariosMovimientosDetalle.id_TipoMovimiento = 13>
                    <cfelse>
                        <cfset local.Argumentos_InventariosMovimientosDetalle.id_TipoMovimiento = javaCast("NULL", 0)>
                    </cfif>

                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="AgregarInventarioMovDetalle"
                                argumentcollection="#local.Argumentos_InventariosMovimientosDetalle#"
                                 returnvariable="local.nd_MovimientoDetalle">

                        <!---   
                            ESTA PARTE LO EDITA EL TRIGGER              
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
                        series capturadas las cuales se eliminaran las existenicias de las series, al igual sera el mismo numero de inventarios detalles de series
                        que se registraran--->
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


                                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                        method="agregarinventariomovmientoseries"
                                        id_empresa ="#session.ID_EMPRESA#"
                                        id_sucursal = "#SESSION.ID_SUCURSAL#"
                                        id_almacen = "#session.ID_ALMACEN#"
                                        id_movimiento = "#local.id_Movimiento#"
                                        nd_movimientoDetalle = "#local.nd_MovimientoDetalle#"
                                        <!---nd_inventarioMovimientoDetalleSerie = "#local.nd_inventariomovimientodetalleserie#"--->
                                        de_serieInsumo="#arguments.InsumosSeriados[local.x].DE_SERIEINSUMO#"
                                        de_Etiqueta="#arguments.InsumosSeriados[local.x].DE_ETIQUETA#"> 

                                            

                                <!--- Se trae el id_ActivoFijo para poder seterle su CentroCosto --->
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                        method="upR_ActivoFijo"
                                        id_empresa="#session.ID_EMPRESA#"
                                        de_SerieActivo="#arguments.InsumosSeriados[local.x].DE_SERIEINSUMO#"
                                        returnvariable="Activo">

                                <!--- se inserta en la tabla ActivosFijosCamposDetalle --->
                                <cfloop from="1" to="#arrayLen(arguments.InsumosSeriados[local.x].CAMPOS)#" index="local.p">

                                    <cfinvoke   component="#Application.RF.getPath('dao','ActivosFijosCamposDetalle')#"
                                                method="agregar"
                                                id_Empresa    ="#session.ID_EMPRESA#"
                                                id_ActivoFijo ="#Activo.ID_ACTIVOFIJO#"
                                                id_campodetalle = "#arguments.InsumosSeriados[local.x].CAMPOS[local.p].ID_CAMPODETALLE#"
                                                nb_campodetalle = "#arguments.InsumosSeriados[local.x].CAMPOS[local.p].NB_CAMPODETALLE#"
                                                de_valorcampodetalle = "#arguments.InsumosSeriados[local.x].CAMPOS[local.p].DE_VALORCAMPODETALLE#">
                                </cfloop>
            
                                <!--- Se pone el sn_Activo=1 en los ActivosFijos y se actualiza fecha --->
                                <!---
                                MODIFICACION: Victor Sanchez
                                26/01/2016
                                 Se setea el usuario que solicito la requisicion --->
                                 <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                                          method="obtener_requisicion"
                                          id_empresa="#session.ID_EMPRESA#"
                                          id_Requisicion="#arguments.REQUISICIONESCONSULTAALMACEN[1].ID_REQUISICION#"
                                          returnvariable="Req">


                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                          method="upU_ActivosFijosSet_sn_Activo"
                                          id_empresa            ="#Activo.ID_EMPRESA#"
                                          id_ActivoFijo         ="#Activo.ID_ACTIVOFIJO#"
                                          id_EmpleadoRecibe     ="#Req.ID_EMPLEADO#"
                                          id_empresaempleado    ="#Req.id_empresaempleado#"
                                          id_insumo             ="#arguments.InsumosSeriados[local.x].ID_INSUMO#"
                                          sn_Activo ="1">

                                <!--- Se agrega el detalle de ActivosFijos --->
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                          method="upU_ActivosFijosDetalleEntradas"
                                          id_Empresa            ="#Activo.ID_EMPRESA#"
                                          id_ActivoFijo         ="#Activo.ID_ACTIVOFIJO#"
                                          id_Sucursal           ="#Activo.ID_SUCURSALASIGNADO#"
                                          id_Almacen            ="#Activo.ID_ALMACENENTRADA#"
                                          id_Movimiento         ="#Activo.ID_MOVIMIENTOENTRADA#"
                                          nd_MovimientoDetalle  ="#Activo.ND_MOVIMIENTODETALLEENTRADA#"/>

                                <!--- Se verifica si ya existe un centro de costo para setearle al activo --->
                                <!--- <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                            method="upR_CentroCostoExiste"
                                            id_Empresa="#Activo.ID_EMPRESA#"
                                            id_Sucursal="#Activo.ID_SUCURSALASIGNADO#"
                                            id_CentroCosto="#Activo.ID_CENTROCOSTO#"
                                            returnvariable="sn_Existe"> --->

                                <!--- <cfif #sn_Existe# EQ '1'>
                                    <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                                method="upU_CentroCostoSet_sn_Activo"
                                                id_Empresa="#Activo.ID_EMPRESA#"
                                                id_Sucursal="#Activo.ID_SUCURSALASIGNADO#"
                                                id_CentroCosto="#Activo.ID_CENTROCOSTO#"
                                                sn_Activo="1">
                                <cfelse>
                                    <!--- Si no existe se agrega --->
                                    <cfinvoke   component="#Application.RF.getPath('dao','CentrosCostos')#"
                                                method="AgregarCentroCosto"
                                                id_Empresa = "#session.ID_EMPRESA#"
                                                id_sucursal = "#SESSION.ID_SUCURSAL#"
                                                id_grupoCentroCosto = "#arguments.InsumosSeriados[local.x].ID_GRUPOCENTROCOSTO#"
                                                <!---id_CentroCosto = "#local.nextId_centroCosto#"--->
                                                nb_centroCosto = "#arguments.InsumosSeriados[local.x].NB_NOMBREINSUMO#"
                                                returnvariable="CentroCosto">
                                        <!--- Regresa id_CentroCosto --->
                                </cfif>  --->

                                <!--- Al Activo se le setea el centro de costo que se genero al darle salida
                                al insumo --->
                                <cfinvoke   component="#Application.RF.getPath('dao','ActivosFijos')#"
                                        method="upU_ActivoFijoSetCentroCosto"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_ActivoFijo = "#Activo.ID_ACTIVOFIJO#"
                                        id_CentroCosto ="#arguments.RequisicionesConsultaAlmacen[local.k].ID_CENTROCOSTO#">
                            </cfif>
                        </cfloop>
                    </cfif>                                             
                </cfif>
            </cfloop>

            <!--- AQUI EMPIEZA LA INSERCION DE LOS CENTROS COSTO, DE LOS INSUMOS QUE SEAN CENTROS COSTO --->
<!---           <cfloop array="#arguments.InsumosSeriados#" index="local.insumo">
                <cfif local.insumo.SN_CENTROCOSTO>
                    <!---<cfinvoke  component="#Application.RF.getPath('dao','CentrosCostos')#"
                                method="nextID"
                                id_Empresa = "#session.ID_EMPRESA#"
                                id_sucursal = "#SESSION.ID_SUCURSAL#"
                                returnvariable="local.nextId_centroCosto">--->

                    <cfif local.insumo.SN_ACTIVOFIJO>
                        <cfinvoke   component="#Application.RF.getPath('dao','CentrosCostos')#"
                                    method="AgregarCentroCosto"
                                    id_Empresa = "#session.ID_EMPRESA#"
                                    id_sucursal = "#SESSION.ID_SUCURSAL#"
                                    id_grupoCentroCosto = "#local.insumo.ID_GRUPOCENTROCOSTO#"
                                    <!---id_CentroCosto = "#local.nextId_centroCosto#"--->
                                    nb_centroCosto = "#local.insumo.NB_NOMBREINSUMO#">  
                        <cfelse>
                            <cfinvoke   component="#Application.RF.getPath('dao','CentrosCostos')#"
                                        method="AgregarCentroCosto"
                                        id_Empresa = "#session.ID_EMPRESA#"
                                        id_sucursal = "#SESSION.ID_SUCURSAL#"
                                        <!---id_CentroCosto = "#local.nextId_centroCosto#"--->
                                        nb_centroCosto = "#local.insumo.NB_NOMBREINSUMO#">  
                    </cfif>
                </cfif>
            </cfloop> --->
            <!--- AQUI TERMINA LA INSERCION DE CENTRO COSTO --->

            <!--- LLAMADO AL FUNCION QUE EJECUTA EL METODO DE UP_INVENTARIOSMOVIMIENTOS_APLICAMETODOSSALIDA --->
            <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen ="#session.ID_ALMACEN#"
                        id_Movimiento ="#local.id_Movimiento#"
                        method="AplicaMetodoASalida">

            <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen ="#session.ID_ALMACEN#"
                        id_Movimiento ="#local.id_Movimiento#"
                        method="ActualizarCostoPromedioAlmacen">


            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>               
            <cfelse> 
                 <cfset variables.RBR.setError('Ocurrio un error.')>    
        </cfif>
        
        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion para generar el pdf, julio ceser acosta lopez 17/08/2015 --->
    <cffunction name="GenerarPDF"    access="public"     returntype="Any">
        <cfargument name='insumos'          type='array'  required='true'>
        <cfargument name='insumosseriados'  type='array'  required='true'>
        <cfargument name='id'               type='string'  required='true'>
        
        <!--- <cfdump var="#arguments#" /><cfabort /> --->

        <cfset local.DatosReporte = structNew()>
        <cfset local.arrayinsumos = arrayNew(1)>
        <cfset arregloinsumos = arrayNew(1)>
        <cfset arregloinsumosseriados = arrayNew(1)>

        <cfloop  array="#arguments.insumos#" index="local.i">
            <cfif local.i.SN_INSUMOSERIADO EQ 'false'>
                <!--- <cfset arregloinsumos[local.i] = structNew()> --->
                <!--- <cfset arregloinsumos[local.i].NB_NOMBREINSUMO = arguments.insumos[local.i].NB_NOMBREINSUMO> --->
                <!--- <cfset arregloinsumos[local.i].NU_CANTIDADASURTIR = arguments.insumos[local.i].NU_CANTIDADASURTIR> --->
                <!--- <cfset arregloinsumos[local.i].DE_SERIEINSUMO = ''> --->
                <cfset  datos = {
                    NB_NOMBREINSUMO = local.i.NB_NOMBREINSUMO,
                    NU_CANTIDADASURTIR = local.i.CANTIDADASURTIR,
                    DE_SERIEINSUMO = '' ,
                    NB_UNIDADMEDIDA  = local.i.NB_UNIDADMEDIDA
                }>

                <cfset arrayAppend(local.arrayinsumos, datos)>

                <!--- <cfset arrayAppend(local.arrayinsumos, arguments.insumos[local.i].NB_NOMBREINSUMO,arguments.insumos[local.i].NU_CANTIDADASURTIR,'')>   --->
            </cfif>
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.insumosseriados)#" index="local.j">
            <!--- <cfset arregloinsumosseriados[local.j] = structNew()> --->
            <!--- <cfset arregloinsumosseriados[local.j].NB_NOMBREINSUMO = arguments.insumosseriados[local.j].NB_NOMBREINSUMO> --->
            <!--- <cfset arregloinsumosseriados[local.j].NU_CANTIDADASURTIR = '1'> --->
            <!--- <cfset arregloinsumosseriados[local.j].DE_SERIEINSUMO = arguments.insumosseriados[local.j].DE_SERIEINSUMO> --->
            <!--- <cfset arrayAppend(local.arrayinsumos, arguments.insumosseriados[local.j].NB_NOMBREINSUMO,'1',arguments.insumosseriados[local.j].DE_SERIEINSUMO)> --->
            <!--- <cfset arrayAppend(local.arrayinsumos, arguments.insumosseriados[local.j].NU_CANTIDAD)> --->
            <cfset  datos = {
                    NB_NOMBREINSUMO = insumosseriados[local.j].NB_NOMBREINSUMO,
                    NU_CANTIDADASURTIR = '1',
                    DE_SERIEINSUMO = arguments.insumosseriados[local.j].DE_SERIEINSUMO,
                    NB_UNIDADMEDIDA  = local.i.NB_UNIDADMEDIDA  
                }>

            <cfset arrayAppend(local.arrayinsumos, datos)>
        </cfloop>

        <!--- <cfloop from="1" to="#arrayLen(arregloinsumos)#" index="local.m">
            <cfset arrayAppend(local.arrayinsumos, arregloinsumos[local.m])>
        </cfloop>

        <cfloop from="1" to="#arrayLen(arregloinsumosseriados)#" index="local.l">
            <cfset arrayAppend(local.arrayinsumos, arregloinsumosseriados[local.l])>
        </cfloop> --->

        <!--- <cfdump var="#local.arrayinsumos#" /><cfabort /> --->

        <cfinvoke   component="#Application.RF.getPath('dao','Requisiciones')#"
                    method="getdatarequisicion"
                    id_Requisicion ="#arguments.id#"
                    id_Empresa ="#session.ID_EMPRESA#"
                    id_Sucursal = "#SESSION.ID_SUCURSAL#"
                    returnvariable="Local.DatosRequisicion">

                
        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="DocuentodeEntrega#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfset local.DatosReporte.nb_Almacen = #SESSION.nb_Almacen#>
        <cfset local.DatosReporte.nb_EmpleadoSolicita = #local.DatosRequisicion.nb_NombreEmpleado#>
        <cfset local.DatosReporte.nb_EmpleadoEntrega = #session.NB_EMPLEADOCOMPLETO#>
        <cfset local.DatosReporte.nb_sucursal = Local.DatosRequisicion.nb_sucursal>
        <cfset local.DatosReporte.fh_fechaentrega = #dateFormat(now(),'dd/MM/yyyy')#>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/DocumentodeEntregaTemplate.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#DocumentodeEntrega#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>                         
    </cffunction>
</cfcomponent>