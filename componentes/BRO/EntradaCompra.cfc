<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <!--- VERSION ANTERIOR DEL REGISTRO DE ENTRADO POR COMPRA
        Autor: Mario Mejia
        Fecha: 13/03/2015
        Descr:  Funcion que realiza el registro de entrada en las tablas: AlmacenesExistencia, InventarioMovimiento,
                InventarioMovimientoDetalle, OrdenesDeCompra y OrdenesDeCompraDetalle el array insumos contiene el detalle de
                cada insumo para esa orden de compra se realizaran los invokes "Insumos.Length" veces para registrar cada insumo --->

    <cffunction name="registrarEntradaVIEJA" access="remote" returntype="any">
        <cfargument name="id_ordenDeCompra"                 type="string" required="true">
        <cfargument name="nb_proveedor"                     type="string" required="true">
        <cfargument name="fh_registroOrdenCompra"           type="string" required="true">
        <cfargument name="fh_EntregaProbable"               type="string" required="true">
        <cfargument name="fh_recepcion"                     type="string" required="true">
        <cfargument name="nu_diasRetrazo"                   type="string" required="true">
        <cfargument name="fl_facturaRemision"               type="string" required="false">
        <cfargument name="fh_facturaRemision"               type="string" required="false">
        <cfargument name="de_entrego"                       type="string" required="true">
        <cfargument name="insumos"                          type="array" required="true">
        <cfargument name="id_UsuarioRegistroOrdenCompra"    type="numeric" required="false">
        <cfargument name="id_almacenEntrega"                type="numeric" required="false">
        <cfargument name="nb_almacenEntrega"                type="string" required="false">
        <cfargument name="de_movimiento"                    type="numeric" required="true">
        <cfargument name="de_EmailProveedor"                type="string" required="false" default="">
        <cfargument name="id_TipoDivision"                  type="string" required="false" default="">
        <cfargument name="id_Requisicion"                   type="string" required="false" default="">
        <cfargument name="insumosConSeries"                 type="array" required="no">
        <cfargument name="insumosSinSeries"                 type="array" required="no">
        <cfargument name="arr_insumosActivoFijo"            type="array" required="no">
        <cfargument name="arr_insumosRelevantes"            type="array" required="no">
        <cfargument name="arr_insumosAmbos"                 type="array" required="no">



        <cfif not isDefined("arguments.fl_facturaRemision")>
            <cfset arguments.fl_facturaRemision = ''>
        </cfif>

        <cfif not isDefined("arguments.fh_facturaRemision")>
            <cfset arguments.fh_facturaRemision = ''>
        </cfif>

        <cfif arguments.id_almacenEntrega NEQ session.ID_ALMACEN>
            <cfset variables.RBR.setError("La orden de compra tiene un almacén de entrega diferente al almacén en el que te encuentras trabajando,<br> no es posible hacer el movimiento de entrada.")>
            <cfreturn variables.RBR>
        </cfif>

        <cfif arguments.de_movimiento EQ 1>
            <cfset arguments.de_tipomovimento = 1>
        <cfelseif arguments.de_movimiento EQ 0>
            <cfset arguments.de_tipomovimento = 11>
        </cfif>

        <!--- VARIABLE PARA SABER SI HAY INSUMOS PARA CONVERSION --->
        <cfset local.snConversion = 0>

        <!--- vamos a traer la el tipo de cambio de la moneda del dia anterior --->
        <cfinvoke component="#Application.RF.getPath('dao','Monedas')#"
          method="MonedaDiaAnteriorPorOC"
          id_Empresa="#session.ID_EMPRESA#"
          id_OrdenCompra="#arguments.id_ordenDeCompra#"
          returnvariable="local.TipoCambio">

        <!--- Realizamos la insercion de los datos a inventariosMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="AgregarMovimiento"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_tipoMovimiento="#arguments.de_tipomovimento#"
                    fl_facturaRemision="#arguments.fl_facturaRemision#"
                    fh_facturaRemision="#arguments.fh_facturaRemision#"
                    de_entrego="#arguments.de_entrego#"
                    id_usuarioRecibio="#session.ID_USUARIO#"
                    id_ordenCompra="#arguments.id_ordenDeCompra#"
                    id_usuarioRegistroMovimiento="#session.ID_USUARIO#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    returnvariable = "local.nextId_Movimiento">

        <!--- Variable para guardar la sumatoria del im_total de todos los insumos --->
        <cfset local.sumatoriaIm_totalMN = 0 >

        <!--- Modificacion a la tabla inventariosMovimientosDetalle, en esta hay que registrar cada insumo de la orden de compra --->
        <cfloop array="#arguments.insumos#" index="Local.insumo">


            <!--- Validamos la cantidad pendiente de surtir --->
            <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                        method="validarCantidadRecibida"
                        id_empresa              = "#session.ID_EMPRESA#"
                        id_ordenDeCompra        = "#arguments.ID_ORDENDECOMPRA#"
                        id_ordenDeCompraDetalle = "#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                        nu_cantidad             = "#Local.insumo.NU_CANTIDADRECIBIDA#"
                        id_insumo               = "#Local.insumo.ID_INSUMO#">



            <!--- Calculamos el im_precioTotalEntrada para este insumo y lo agregamos a la sumatoria --->
            <cfset local.im_precioTotalEntrada2 = (#local.insumo.IM_PRECIOUNITARIODESCUENTO# * #local.TipoCambio.im_TipoCambio#) * Local.insumo.NU_CANTIDADRECIBIDA>
            <cfset local.im_precioTotalEntrada = (#local.insumo.IM_PRECIOUNITARIODESCUENTO# ) * Local.insumo.NU_CANTIDADRECIBIDA>
            <cfset local.sumatoriaIm_totalMN = local.sumatoriaIm_totalMN + local.im_precioTotalEntrada2>

            <cfif Local.insumo.SN_CONVERSION EQ 1>
                <cfset local.snConversion = 1>
            </cfif>
            <cfif not isDefined("local.insumo.NU_CANTIDADCONVERTIR")>
                 <cfset local.insumo.NU_CANTIDADCONVERTIR = 0>
             </cfif>
            <!--- Realizamos la insercion de cada insumo en inventariosMovimientosDetalle --->
            <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                        method="AgregarInventarioMovDetalle"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_movimiento="#local.nextId_Movimiento#"
                        id_insumo="#Local.insumo.ID_INSUMO#"
                        nu_cantidad="#Local.insumo.NU_CANTIDADRECIBIDA#"
                        im_precioTotalEntrada="#local.im_precioTotalEntrada#"
                        im_precioUnitarioEntrada="#Local.insumo.IM_PRECIOUNITARIODESCUENTO#"
                        id_MonedaEntrada="#Local.insumo.IDMONEDA#"
                        im_tipoCambioEntrada="#local.TipoCambio.im_TipoCambio#"
                        nu_existenciaAnterior="#Local.insumo.NU_EXISTENCIA#"
                        id_tipoCosteo="1" <!--- El valor de este campo siempre es 1 para esta pantalla --->
                        id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                        nu_CantidadConvertir="#local.insumo.NU_CANTIDADCONVERTIR#"
                        returnvariable="local.nextNd_MovimientoDetalle">

            <!--- Obtenemos el nu de existencia para el registro --->
            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="getNu_existencia"
                      id_empresa="#session.ID_EMPRESA#"
                      id_sucursal="#SESSION.ID_SUCURSAL#"
                      id_almacen="#session.ID_ALMACEN#"
                      id_insumo="#Local.insumo.ID_INSUMO#"
                      returnvariable="Local.en_Existencia"/>

            <!---
                modificacion: 11/06/2015
                Autor: Mario Mejia
                actualizacion:  Los insumos pueden ser o no seriados, en caso de serlo, debemos de registrar
                                todas las series capturadas por cada insumo en las tablas
                                AlmacenesExistenciasSeriesInsumos e InventariosMovimientosDetalleSeries--->
            <cfif isDefined("Local.insumo.series")>
                <!--- Mandamos a insertar todas las series de insumos --->
                <cfset seriesarguments = Local.insumo.series>
                <cfinvoke   component="#Application.RF.getPath('bro','AlmacenesExistenciasSeriesInsumos')#"
                            method="agregarInsumos"
                            insumos="#seriesarguments#"
                            returnvariable="Local.resultadoRegistro"/>

                <cfif Local.resultadoRegistro.hasError()>
                    <cfset variables.RBR.setError(Local.resultadoRegistro.getMessage())>
                    <cfreturn variables.RBR>
                </cfif>
                <!--- iteramos sobre las series para registrar cada una en la tabla InventariosMovimientosDetalleSeries --->
                <cfloop array="#Local.insumo.series#" index="local.serie">

                    <!--- Insertamos en la tabla --->
                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                method="agregarinventariomovmientoseries"
                                id_empresa = "#session.ID_EMPRESA#"
                                id_sucursal = "#SESSION.ID_SUCURSAL#"
                                id_almacen = "#session.ID_ALMACEN#"
                                id_movimiento = "#Local.nextId_Movimiento#"
                                nd_movimientoDetalle ="#Local.nextNd_MovimientoDetalle#"
                                <!---nd_inventarioMovimientoDetalleSerie = "#Local.nextNd_inventarioMovimientoDetalleSerie#"--->
                                de_serieInsumo = "#local.serie.de_serieInsumo#"
                                de_etiqueta = "#local.serie.de_Etiqueta#"/>


                        <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                    method="listarTodos"
                                    id_insumo="#Local.insumo.ID_INSUMO#"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    returnvariable="sn_Activo"/>

                        <cfif Local.serie.SN_EQUIPOCOMPUTO>
                                <cfset Local.serie.SN_EQUIPOCOMPUTO = 1>
                        <cfelse>
                                <cfset Local.serie.SN_EQUIPOCOMPUTO = 0>
                        </cfif>

                        <cfif Local.serie.SN_EQUIPOCELULAR>
                                <cfset Local.serie.SN_EQUIPOCELULAR = 1>
                        <cfelse>
                                <cfset Local.serie.SN_EQUIPOCELULAR = 0>
                        </cfif>

                        <!--- Si el activo va al almacen, su sn_Activo será 0 --->

                        <!--- FIX: Sanitizar nb_ActivoFijo para asegurar que el numero de serie
                             no quede concatenado al nombre del insumo, sin importar el origen del dato. --->
                        <cfset local.nb_NombreSanitizado = trim(Local.insumo.NB_NOMBREINSUMO)>
                        <cfset local.serieSanitizar = trim(local.serie.de_serieInsumo)>
                        <cfset local.etiquetaSanitizar = trim(local.serie.de_Etiqueta)>

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

                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="AgregarActivosFijos"
                                  nb_ActivoFijo="#local.nb_NombreSanitizado#"
                                  de_SerieActivo="#Local.serie.de_serieInsumo#"
                                  id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                  id_AlmacenEntrada="#session.ID_ALMACEN#"
                                  id_MovimientoEntrada="#local.nextId_Movimiento#"
                                  nd_MovimientoDetalleEntrada="#Local.nextNd_MovimientoDetalle#"
                                  id_insumo="#Local.insumo.ID_INSUMO#"
                                  id_Empresa="#session.ID_EMPRESA#"
                                  id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
                                  id_Empleado="#SESSION.ID_EMPLEADO#"
                                  sn_Activo='0'
                                  id_TipoActivoFijo = "#Local.serie.ID_TIPOACTIVOFIJO#"
                                  de_etiqueta = "#Local.serie.de_Etiqueta#"
                                  fl_FacturaCompra = "#Local.serie.FL_FACTURACOMPRA#"
                                  ar_FacturaCompra = "#Local.serie.AR_FACTURACOMPRA#"
                                  sn_EquipoComputo = "#Local.serie.SN_EQUIPOCOMPUTO#"
                                  sn_EquipoCelular = "#Local.serie.SN_EQUIPOCELULAR#"
                                  returnvariable="id_ActivoFijo"
                                  />

                        <!--- Se agrega el movimiento en ActivosFijosDetalleEntradas --->
                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="upC_ActivosFijosDetalleEntradas"
                                  id_Empresa="#session.ID_EMPRESA#"
                                  id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                  id_Sucursal="#SESSION.ID_SUCURSAL#"
                                  id_Almacen="#session.ID_ALMACEN#"
                                  id_Movimiento="#local.nextId_Movimiento#"
                                  nd_MovimientoDetalle="#Local.nextNd_MovimientoDetalle#"
                                />

                        <!--- Se agregan los detalles --->
                        <cfloop array="#local.serie.CAMPOS#" index="campoDetalle">
                            <cfif #isDefined('campoDetalle.de_ValorCampoDetalle')# AND #campoDetalle.de_ValorCampoDetalle# NEQ ''>
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                method="agregarCampoDetalle"
                                id_Empresa="#session.ID_EMPRESA#"
                                id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                argumentcollection="#campoDetalle#">
                            </cfif>
                        </cfloop>

                        <!--- Se agregan las fotografias --->
                        <cfloop array="#local.serie.AR_ARCHIVOSFOTOGRAFIAS#" index="fotografia">
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                    method="agregarFotografia"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    id_Sucursal="#SESSION.ID_SUCURSAL#"
                                    id_Empleado="#SESSION.ID_EMPLEADO#"
                                    id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                    sn_Update="#0#"
                                    argumentcollection="#fotografia#">
                        </cfloop>


                        <cfif Local.insumo.ID_TIPODESTINO EQ 2 AND Local.insumo.SN_CONVERSIONACTIVO EQ 1 AND Local.insumo.IM_PRECIOUNITARIO GTE Local.insumo.IM_VALORACTIVOFIJO>  <!--- IF: Si el tipoDestino es igual a 2  y imdi.im_PrecioUnitarioMN >= fi.im_ValorActivoFijo (SE APLICA POLITICA) --->
                                            <!--- Actualizar sn_Contable en 1 (Activo Fijo) --->
                                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                            method="actualizarContable"
                                                            id_Empresa="#session.ID_EMPRESA#"
                                                            id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                            id_Insumo="#Local.insumo.ID_INSUMO#"
                                                            de_Etiqueta = "#Local.serie.de_Etiqueta#"                                                
                                                            sn_Contable = "1">

                        <cfelseif Local.insumo.ID_TIPODESTINO EQ 3 AND Local.insumo.SN_CONVERSIONACTIVO EQ 1 AND Local.insumo.IM_PRECIOUNITARIO GTE Local.insumo.IM_VALORACTIVOFIJO> <!--- Si el tipoDestino es igual a 3 y imdi.im_PrecioUnitarioMN >= fi.im_ValorActivoFijo (SE APLICA POLITICA) --->
                                            <!--- Actualizar sn_Contable en 1 (Activo Fijo) --->
                                            <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                            method="actualizarContable"
                                                            id_Empresa="#session.ID_EMPRESA#"
                                                            id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                            id_Insumo="#Local.insumo.ID_INSUMO#"
                                                            de_Etiqueta = "#Local.serie.de_Etiqueta#"
                                                            sn_Contable = "1">
                        <cfelse>
                                            <!--- En todos los otros casos = sn_Contable en 0 (resguardo)--->
                                            <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                            method="actualizarContable"
                                                            id_Empresa="#session.ID_EMPRESA#"
                                                            id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                            id_Insumo="#Local.insumo.ID_INSUMO#"
                                                            de_Etiqueta = "#Local.serie.de_Etiqueta#"
                                                            sn_Contable = "0">
                        </cfif>

                        <!--- Fin modificacion --->
                </cfloop>
            </cfif>
        </cfloop>


        <!--- INSUMOS QUE NO SON SERIADOS --->
        <!--- PARA LOS INSUMOS QUE NO TIENEN SERIE: Se verifica si son tipo 2 o 3 para guardar en la tabla de ActivosFijos y crear una etiqueta  --->
        <cfif structKeyExists(arguments, "insumosSinSeries") AND isArray(arguments.insumosSinSeries) AND arrayLen(arguments.insumosSinSeries) GT 0>
            <cfloop array="#arguments.insumosSinSeries#" index="Local.insumoSinSerie">
                <cfif isDefined("Local.insumoSinSerie.series")>
                    <!--- Validamos la cantidad pendiente de surtir --->
                    <cfinvoke
                        component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                        method="validarCantidadRecibida"
                        id_empresa              = "#session.ID_EMPRESA#"
                        id_ordenDeCompra        = "#arguments.ID_ORDENDECOMPRA#"
                        id_ordenDeCompraDetalle = "#Local.insumoSinSerie.ID_ORDENDECOMPRADETALLE#"
                        nu_cantidad             = "#Local.insumoSinSerie.NU_CANTIDADRECIBIDA#"
                        id_insumo               = "#Local.insumoSinSerie.ID_INSUMO#"
                    >

                    <!--- Calculamos el im_precioTotalEntrada para este insumo y lo agregamos a la sumatoria --->
                    <cfset local.im_precioTotalEntrada2 = (#local.insumoSinSerie.IM_PRECIOUNITARIODESCUENTO# * #local.TipoCambio.im_TipoCambio#) * Local.insumoSinSerie.NU_CANTIDADRECIBIDA>
                    <cfset local.im_precioTotalEntrada = (#local.insumoSinSerie.IM_PRECIOUNITARIODESCUENTO# ) * Local.insumoSinSerie.NU_CANTIDADRECIBIDA>
                    <cfset local.sumatoriaIm_totalMN = local.sumatoriaIm_totalMN + local.im_precioTotalEntrada2>

                    <cfif Local.insumoSinSerie.SN_CONVERSION EQ 1>
                        <cfset local.snConversion = 1>
                    </cfif>
                    <cfif not isDefined("local.insumoSinSerie.NU_CANTIDADCONVERTIR")>
                        <cfset local.insumoSinSerie.NU_CANTIDADCONVERTIR = 0>
                    </cfif>
                    <!--- Realizamos la insercion de cada insumo en inventariosMovimientosDetalle --->
                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="AgregarInventarioMovDetalle"
                                id_empresa="#session.ID_EMPRESA#"
                                id_sucursal="#SESSION.ID_SUCURSAL#"
                                id_almacen="#session.ID_ALMACEN#"
                                id_movimiento="#local.nextId_Movimiento#"
                                id_insumo="#Local.insumoSinSerie.ID_INSUMO#"
                                nu_cantidad="#Local.insumoSinSerie.NU_CANTIDADRECIBIDA#"
                                im_precioTotalEntrada="#local.im_precioTotalEntrada#"
                                im_precioUnitarioEntrada="#Local.insumoSinSerie.IM_PRECIOUNITARIODESCUENTO#"
                                id_MonedaEntrada="#Local.insumoSinSerie.IDMONEDA#"
                                im_tipoCambioEntrada="#local.TipoCambio.im_TipoCambio#"
                                nu_existenciaAnterior="#Local.insumoSinSerie.NU_EXISTENCIA#"
                                id_tipoCosteo="1" <!--- El valor de este campo siempre es 1 para esta pantalla --->
                                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                                id_ordenDeCompraDetalle="#Local.insumoSinSerie.ID_ORDENDECOMPRADETALLE#"
                                nu_CantidadConvertir="#local.insumoSinSerie.NU_CANTIDADCONVERTIR#"
                                returnvariable="local.nextNd_MovimientoDetalleNuevo">


                    <!--- Se Comenta, no se debe aplicar politica de activos fijos --->
                    <!--- <cfloop array="#Local.insumoSinSerie.series#" index="local.serie">
                        <cfif local.serie.ID_TIPODESTINO EQ 2 or local.serie.ID_TIPODESTINO EQ 3>
                             <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                        method="getEtiqueta"
                                        returnvariable="NuevaEtiqueta">

                                <cfset local.serie.DE_ETIQUETA = NuevaEtiqueta.Etiqueta>

                            
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                        method="AgregarActivosFijos"
                                        nb_ActivoFijo="#local.serie.NB_NOMBREINSUMO#"
                                        de_SerieActivo=""
                                        id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                        id_AlmacenEntrada="#session.ID_ALMACEN#"
                                        id_MovimientoEntrada="#local.nextId_Movimiento#"
                                        nd_MovimientoDetalleEntrada="#Local.nextNd_MovimientoDetalleNuevo#"
                                        id_insumo="#local.serie.ID_INSUMO#"
                                        id_Empresa="#session.ID_EMPRESA#"
                                        id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
                                        id_Empleado="#SESSION.ID_EMPLEADO#"
                                        sn_Activo='0'
                                        id_TipoActivoFijo = "" 
                                        de_etiqueta = "#NuevaEtiqueta.Etiqueta#"
                                        fl_FacturaCompra = ""
                                        ar_FacturaCompra = ""
                                        sn_EquipoComputo = ""
                                        sn_EquipoCelular = ""
                                        returnvariable="id_ActivoFijo"
                                        />

                                <!--- Se agrega el movimiento en ActivosFijosDetalleEntradas --->
                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                        method="upC_ActivosFijosDetalleEntradas"
                                        id_Empresa="#session.ID_EMPRESA#"
                                        id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                        id_Sucursal="#SESSION.ID_SUCURSAL#"
                                        id_Almacen="#session.ID_ALMACEN#"
                                        id_Movimiento="#local.nextId_Movimiento#"
                                        nd_MovimientoDetalle="#Local.nextNd_MovimientoDetalleNuevo#"
                                        />


                                <!--- Se agregan las fotografias --->
                                <cfloop from="1" to="3" index="i">
                                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                            method="agregarFotografia"
                                            id_Empresa="#session.ID_EMPRESA#"
                                            id_Sucursal="#SESSION.ID_SUCURSAL#"
                                            id_Empleado="#SESSION.ID_EMPLEADO#"
                                            id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                            sn_Update="#0#"
                                            nombre=""
                                            ruta="">
                                </cfloop>


                        </cfif>
                    </cfloop> --->
                </cfif>
            </cfloop>
        </cfif>

        <!--- Se Comenta, no se debe aplicar politica de activos fijos --->
        <!--- PARA LOS INSUMOS QUE NO TIENEN SERIE: SE DETERMINA SI SN_CONTABLE SERA 1 O 0 EN TABLA DE ACTIVOS FIJOS  --->
        <!--- <cfif structKeyExists(arguments, "insumosSinSeries") AND isArray(arguments.insumosSinSeries) AND arrayLen(arguments.insumosSinSeries) GT 0>
            <cfloop array="#arguments.insumosSinSeries#" index="Local.insumoSinSerie">
                <cfif isDefined("Local.insumoSinSerie.series")>
                    <cfloop array="#Local.insumoSinSerie.series#" index="local.serieSS">

                        <cfif Local.insumoSinSerie.ID_TIPODESTINO EQ 2 or Local.insumoSinSerie.ID_TIPODESTINO EQ 3>

                                        <cfif Local.insumoSinSerie.ID_TIPODESTINO EQ 2 AND Local.insumoSinSerie.SN_CONVERSIONACTIVO EQ 1 AND Local.insumoSinSerie.IM_PRECIOUNITARIO GTE Local.insumoSinSerie.IM_VALORACTIVOFIJO>  <!--- IF: Si el tipoDestino es igual a 2  y imdi.im_PrecioUnitarioMN >= fi.im_ValorActivoFijo (SE APLICA POLITICA) --->
                                                    <!--- Actualizar sn_Contable en 1 (Activo Fijo) --->
                                                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                        method="actualizarContable"
                                                        id_Empresa="#session.ID_EMPRESA#"
                                                        id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                        id_Insumo="#local.serieSS.ID_INSUMO#"
                                                        de_Etiqueta = "#local.serieSS.DE_ETIQUETA#"
                                                        sn_Contable = "1">

                                        <cfelseif Local.insumoSinSerie.ID_TIPODESTINO EQ 3 AND Local.insumoSinSerie.SN_CONVERSIONACTIVO EQ 1 AND Local.insumoSinSerie.IM_PRECIOUNITARIO GTE Local.insumoSinSerie.IM_VALORACTIVOFIJO> <!--- Si el tipoDestino es igual a 3 y imdi.im_PrecioUnitarioMN >= fi.im_ValorActivoFijo (SE APLICA POLITICA)--->
                                                    <!--- Actualizar sn_Contable en 1 (Activo Fijo) --->
                                                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                        method="actualizarContable"
                                                        id_Empresa="#session.ID_EMPRESA#"
                                                        id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                        id_Insumo="#local.serieSS.ID_INSUMO#"
                                                        de_Etiqueta = "#local.serieSS.DE_ETIQUETA#"
                                                        sn_Contable = "1">
                                        <cfelse>
                                                    <!--- En todos los otros casos = sn_Contable en 0 (resguardo)--->
                                                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijosNuevo')#"
                                                        method="actualizarContable"
                                                        id_Empresa="#session.ID_EMPRESA#"
                                                        id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                                        id_Insumo="#local.serieSS.ID_INSUMO#"
                                                        de_Etiqueta = "#local.serieSS.DE_ETIQUETA#"
                                                        sn_Contable = "0">
                                        </cfif>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfloop>
        </cfif> --->

        <!--- una vez obtenida la sumatoria de los im_totalMN de cada insumo actualizamos la tabla InventariosMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="setIm_totalMN"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_movimiento="#local.nextId_Movimiento#"
                    im_TotalMN="#local.sumatoriaIm_totalMN#">

        <!---
            SI SE ENCONTRO UN INSUMO DE CONVERSION SE REALIZA LO SIGUIENTE
                1-> SALIDA DEL INSUMO
                2-> REGISTRAR NUEVA ENTRADA
                2-> REGISTRAR DETALLE CON LA CONVERSION
        --->

        <cfif local.snConversion EQ 1>


            <!--- REGISTRAR SALIDA DE LA ENTRADA --->

            <!--- REGISTRAMOS NUEVA ENTRADA cON LA CANTIDAD DE CONVERSION --->
            <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="AgregarMovimiento"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_tipoMovimiento="4"
                    fl_facturaRemision="#arguments.fl_facturaRemision#"
                    fh_facturaRemision="#arguments.fh_facturaRemision#"
                    de_entrego="#arguments.de_entrego#"
                    id_usuarioRecibio="#session.ID_USUARIO#"
                    id_ordenCompra="#arguments.id_ordenDeCompra#"
                    id_usuarioRegistroMovimiento="#session.ID_USUARIO#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    returnvariable = "local.nextId_Movimiento2">

            <cfloop array="#arguments.insumos#" index="Local.insumo">

                <cfif Local.insumo.SN_CONVERSION EQ 1>

                    <!--- Calculamos el im_precioTotalEntrada para este insumo y lo agregamos a la sumatoria --->
                    <cfset local.im_precioTotalEntrada2 = (#local.insumo.IM_PRECIOUNITARIODESCUENTO# * #local.TipoCambio.im_TipoCambio#) * Local.insumo.NU_CANTIDADRECIBIDA>
                    <cfset local.im_precioTotalEntrada = (#local.insumo.IM_PRECIOUNITARIODESCUENTO# ) * Local.insumo.NU_CANTIDADRECIBIDA>
                    <cfset local.sumatoriaIm_totalMN = local.sumatoriaIm_totalMN + local.im_precioTotalEntrada2>

                    <!--- REALIZAMOS EL REGISTRO DEL DETALLE CON LA CANTIDAD A CONVERTIR --->
                    <!--- Obtenemos el nu de existencia para el registro --->
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                              method="getNu_existencia"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#SESSION.ID_SUCURSAL#"
                              id_almacen="#session.ID_ALMACEN#"
                              id_insumo="#Local.insumo.ID_INSUMO#"
                              returnvariable="Local.existencia"/>

                    <!--- <cfdump var="#Local.existencia.NU_EXISTENCIA#"><cfabort> --->

                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="AgregarInventarioMovDetalle"
                                id_empresa="#session.ID_EMPRESA#"
                                id_sucursal="#SESSION.ID_SUCURSAL#"
                                id_almacen="#session.ID_ALMACEN#"
                                id_movimiento="#local.nextId_Movimiento2#"
                                id_insumo="#Local.insumo.ID_INSUMOCONVERSION#"
                                nu_cantidad="#Local.insumo.NU_CANTIDADCONVERTIR#"
                                im_precioTotalEntrada="#local.im_precioTotalEntrada#"
                                im_precioUnitarioEntrada="#Local.insumo.IM_PRECIOUNITARIODESCUENTO/Local.insumo.NU_CANTIDADCONVERTIR#"
                                id_MonedaEntrada="#Local.insumo.IDMONEDA#"
                                im_tipoCambioEntrada="#local.TipoCambio.im_TipoCambio#"
                                nu_existenciaAnterior="#Local.existencia.NU_EXISTENCIA#"
                                id_tipoCosteo=1 <!--- El valor de este campo siempre es 1 para esta pantalla --->
                                id_sucursalProveniente="#SESSION.ID_SUCURSAL#"
                                id_almacenProveniente="#session.ID_ALMACEN#"
                                id_movimientoProveniente="#local.nextId_Movimiento#"
                                id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                                id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                                nu_CantidadConvertir="#local.insumo.NU_CANTIDADCONVERTIR#"

                                returnvariable="local.nextNd_MovimientoDetalle">

                </cfif>
            </cfloop>

            <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="setIm_totalMN"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_movimiento="#local.nextId_Movimiento2#"
                    im_TotalMN="#local.sumatoriaIm_totalMN#">

            <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                      method="AplicaMetodoAEntrada"
                      id_empresa="#session.ID_EMPRESA#"
                      id_sucursal="#SESSION.ID_SUCURSAL#"
                      id_almacen="#session.ID_ALMACEN#"
                      id_movimiento="#local.nextId_Movimiento2#"/>

            <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                  method="ActualizarPorEntradaAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_movimiento="#local.nextId_Movimiento2#"
                  id_tipoMovimiento="#arguments.de_tipomovimento#"/>

        </cfif>

        <cfloop array="#arguments.insumos#" index="Local.insumo">
            <!--- Sumar en ordenes de compra detalle la cantidad ingresada por cada insumo --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                        method="add_Nu_CantidadSurtida"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                        id_insumo="#Local.insumo.ID_INSUMO#"
                        nu_cantidadSurtida="#Local.insumo.NU_CANTIDADRECIBIDA#">

            <!--- obtener la cantidad surtida actualizada de cada insumo --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                        method="get_Nu_CantidadSurtida"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                        id_insumo="#Local.insumo.ID_INSUMO#"
                        returnvariable="local.cantidadSurtidaObtenida">

            <!--- <cfset Local.insumo.de_estatusSurtido = "#local.cantidadSurtidaObtenida.de_Estatus#"> --->

            <cfif Local.Insumo.NU_CANTIDADRECIBIDA GT local.insumo.NU_CANTIDADPORSURTIR>
                <cfset variables.RBR.setError('La cantidad recibida ingresada  no debe ser mayor a la cantidad por surtir.')>
                <cfreturn variables.RBR>
            </cfif>

            <cfif Local.Insumo.NU_CANTIDADRECIBIDA LT 0>
                <cfset variables.RBR.setError('La cantidad recibida ingresada no puede tener un valor negativo.')>
                <cfreturn variables.RBR>
            </cfif>

            <!--- Se modificá la informacion con lo que retorna el query --->
            <cfset Local.insumo.NU_CANTIDADSURTIDA = #local.cantidadSurtidaObtenida.NU_CANTIDADSURTIDA#>

            <!--- Si la cantidad surtida es mayor o igual que la cantidad solicitada, ponemos el estatus como surtido --->
            <cfif local.cantidadSurtidaObtenida.nu_cantidadSurtida GTE Local.insumo.NU_CANTIDAD>
                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                            id_insumo="#Local.insumo.ID_INSUMO#"
                            id_estatusSurtido="1">

                <cfset Local.insumo.de_estatusSurtido = "Surtido Completo">

            <!--- Si cantidad surtida es menor a la solicitada, pero mayor a 0, el estatus es surtido parcialmente --->
            <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida GT 0>

                <!--- se verifica de que pantalla viene(Entrada surtido por devolcion = 0 o entrada por compra = 1), para saber que surtido parcial poner,
                      si parcial por devolucion o simplemente parcial 24/09/2015--->
                <cfif arguments.de_movimiento EQ 0>
                    <cfset arguments.estatusparcial = 4>
                <cfelseif arguments.de_movimiento EQ 1>
                    <cfset arguments.estatusparcial = 2>
                </cfif>

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                            id_insumo="#Local.insumo.ID_INSUMO#"
                            id_estatusSurtido="#arguments.estatusparcial#">

                <cfset Local.insumo.de_estatusSurtido = "Surtido Parcialmente">

            <!--- Si cantidad surtida es 0, el estatus es sin surtir --->
            <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida EQ 0>
                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                            id_estatusSurtido="3">

                <cfset Local.insumo.de_estatusSurtido = "Sin Surtir">
            </cfif>
        </cfloop>


        <!--- Metodo que nos dice cual es el estatusSurtido de una orden de compra analizando la tabla OrdenesDeCompraDetalle --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="validarEstatusSurtido"
                    id_empresa="#session.ID_EMPRESA#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    returnvariable ="Local.estatus">

        <!--- Acutalizamos el estatus de surtido para la tabla ordenes de compra --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="set_Id_estatusSurtido"
                    id_empresa="#session.ID_EMPRESA#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    id_estatusSurtido="#local.estatus#">

            <!--- Gruarda un registro a la tabla OrdenesDeCompraMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method = "agregarOrdenesDeCompraMovimientos"
                    id_empresa         = "#session.ID_EMPRESA#"
                    id_ordenDeCompra   = "#arguments.id_ordenDeCompra#"
                    id_EmpresaEmpleado = "#session.ID_EMPRESAOPERADORA#"
                    id_Empleado        = "#session.ID_USUARIO#">

        <!--- ADICIONAL mandamos a llamar la funcion hecha por Flavio para aplicar un metodo de costeo a un inventario movimiento de entrada --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                      method="AplicaMetodoAEntrada"
                      id_empresa="#session.ID_EMPRESA#"
                      id_sucursal="#SESSION.ID_SUCURSAL#"
                      id_almacen="#session.ID_ALMACEN#"
                      id_movimiento="#local.nextId_Movimiento#"/>

        <!--- ADICIONAL actualizamos el campo fh_ultimaEntrega a la fecha en la que se realiza la entrada (fecha de hoy) --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method="set_fh_ultimaEntrega"
                    id_empresa="#session.ID_EMPRESA#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    fh_ultimaEntrega="#dateFormat(Now(),'yyyyMMdd')#">

        <!---
            Autor: Mario Mejia
            Fecha: 11/05/2015
                Se agrego a la funcion registrarEntrada la posibilidad de mandar
                un correo electronico al usuario que registro la compra
                con un reporte adjunto de cuales insumos se les dio entrada
         --->
        <cfinvoke   component="#Application.RF.getPath('dao','EstatusSurtidoOrdenesDeCompra')#"
                    method="getRSPorID"
                    id_estatusSurtidoOrdenDeCompra="#Local.estatus#"
                    returnvariable="Local.estatusSurtido">

        <cfset Local.ordenCompra = structNew()>
        <cfset Local.ordenCompra.id_ordenDeCompra = arguments.id_ordenDeCompra>
        <cfset Local.ordenCompra.nb_proveedor = arguments.nb_proveedor>
        <cfset Local.ordenCompra.fh_registroOrdenCompra = arguments.fh_registroOrdenCompra>
        <cfset Local.ordenCompra.fh_EntregaProbable = arguments.fh_EntregaProbable>
        <cfset Local.ordenCompra.fh_recepcion = arguments.fh_recepcion>
        <cfset Local.ordenCompra.nu_diasRetrazo = arguments.nu_diasRetrazo>
        <cfset Local.ordenCompra.fl_facturaRemision = arguments.fl_facturaRemision>
        <cfset Local.ordenCompra.fh_facturaRemision = arguments.fh_facturaRemision>
        <cfset Local.ordenCompra.de_entrego = arguments.de_entrego>
        <cfset Local.ordenCompra.insumos = arguments.insumos>
        <cfset Local.ordenCompra.insumosConSeries = arguments.insumosConSeries>
        <cfset Local.ordenCompra.de_estatusSurtido = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra>
        <cfset Local.ordenCompra.im_TotalMN=local.sumatoriaIm_totalMN>
        <cfset Local.ordenCompra.im_TipoCambio= local.TipoCambio.im_TipoCambio>

        <!---
        SE ELIMINO EL ENVIO DE CORREO A LAS DE OCMPRAS A PETICION DE MAGDA EL 13/10/2017
        <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                    method="getMailEmpleado"
                    id_usuario="#arguments.id_UsuarioRegistroOrdenCompra#"
                    returnvariable="Local.mailEmpleado">


        <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>
         <cfset ArrayAppend(Local.destinatarios, "ing.virosalu@gmail.com")> --->

        <cfset Local.destinatarios = ArrayNew(1)>
        <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                    method="getMailEmpleadoRequisicion"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_ordenDeCompra="#arguments.id_ordenDeCompra#"
                    returnvariable="Local.mail">

        <cfif Local.mail.recordCount GT 0>
            <cfset ArrayAppend(Local.destinatarios, "#Local.mail.DE_EMAIL#")>
        </cfif>

        <cfif arrayLen(local.destinatarios) GT 0>
            <cfset Local.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                }
            ]>

            <cfinvoke method="crearReporte"
                argumentcollection="#Local.ordenCompra#"
                returnvariable="rbrREPORTE">

            <cfif rbrREPORTE.hasError()>
                <cfset errorMessage = "Error al generar el reporte " & rbrReporte.getMessage() />
                <cfthrow type="Application" message="#errorMessage#">
            </cfif>

            <cfset Local.archivos=[{
                dir="reporteOrdenesCompra/reporteEntradaPorCompra_Orden"&#arguments.id_ordenDeCompra#&".pdf",
                name='reporte',
                sn_deleteFile= "no"
            }]>

            <!--- <cfset Local.parametros={
                id_ordenDeCompra = arguments.id_ordenDeCompra,
                nb_proveedor = arguments.nb_proveedor,
                fh_registroOrdenCompra = arguments.fh_registroOrdenCompra,
                fh_EntregaProbable = arguments.fh_EntregaProbable,
                fh_recepcion = arguments.fh_recepcion,
                nu_diasRetrazo = arguments.nu_diasRetrazo,
                fl_facturaRemision = arguments.fl_facturaRemision,
                fh_facturaRemision = arguments.fh_facturaRemision,
                de_entrego = arguments.de_entrego,
                de_estatusSurtido = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra,
                nb_almacenEntrega= arguments.nb_almacenEntrega
            }/> --->

            <cfif arguments.id_Requisicion NEQ '-' AND arguments.id_Requisicion NEQ ''>
                <!--- Guardamos el registro de la notificación --->
                <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
                method="GuardarNotificacion"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#session.ID_SUCURSAL#"
                id_Almacen="#session.ID_ALMACEN#"
                id_Requisicion="#arguments.id_Requisicion#">
            </cfif>

            <cfinvoke component="#Application.RF.getPath('dao','usuarios')#"
                method="getByIDEmpleado"
                id_empleado="#session.ID_EMPLEADO#"
                returnvariable="Local.user">

            <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                method="getInformacionAtencion"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#session.ID_SUCURSAL#"
                id_Almacen="#session.ID_ALMACEN#"
                returnvariable="Local.Almacen">

            <cfset Local.parametros = structNew()>
            <cfset Local.parametros.id_ordenDeCompra       = arguments.id_ordenDeCompra>
            <cfset Local.parametros.nb_proveedor           = arguments.nb_proveedor>
            <cfset Local.parametros.fh_registroOrdenCompra = arguments.fh_registroOrdenCompra>
            <cfset Local.parametros.fh_EntregaProbable     = arguments.fh_EntregaProbable>
            <cfset Local.parametros.fh_recepcion           = arguments.fh_recepcion>
            <cfset Local.parametros.nu_diasRetrazo         = arguments.nu_diasRetrazo>
            <cfset Local.parametros.fl_facturaRemision     = arguments.fl_facturaRemision>
            <cfset Local.parametros.fh_facturaRemision     = arguments.fh_facturaRemision>
            <cfset Local.parametros.de_entrego             = arguments.de_entrego>
            <cfset Local.parametros.nb_almacenEntrega      = arguments.nb_almacenEntrega>
            <cfset Local.parametros.Insumos                = arguments.insumos>
            <cfset Local.parametros.id_Requisicion         = arguments.id_Requisicion>
            <cfset Local.parametros.Insumos = arguments.insumos>
            <cfset Local.parametros.id_Requisicion = arguments.id_Requisicion>
            <cfset Local.parametros.nb_Requisitante = Local.mail.nb_NombreCompleto>
            <cfset Local.parametros.de_Direccion = Local.Almacen.de_Direccion>
            <cfset Local.parametros.de_Horario = Local.Almacen.de_Horario>
            <cfset Local.parametros.nb_Almacenista = Local.user.NOMBRE>
            <cfset Local.parametros.de_Puesto = Local.user.nb_Puesto>
            <cfset Local.parametros.nb_Empresa = session.NB_EMPRESA>
            <cfset Local.parametros.nb_Sucursal = session.NB_SUCURSAL>
            <cfset Local.parametros.de_Contacto = Local.user.DE_EMAIL>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#local.destinatarios#"
                asunto="Notificación de entrada a almacén"
                imagenes="#Local.imagenes#"
                <!--- archivos="#Local.archivos#" --->
                parametros="#Local.parametros#"
                nu_requisision = "N/A"
                sn_plantilla="YES"
                dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailEntradaPorCompra.html"
                returnvariable="Local.rbr"/>

            <!--- Se informa igualmente al proveedor de la entrada por compra a almacen --->
            <cfif #de_EmailProveedor# NEQ ''>

                <cfset Local.correoProveedor = ArrayNew(1)>
                <cfset ArrayAppend(Local.correoProveedor, "#Arguments.de_EmailProveedor#")>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                      method="sendMail"
                      destinatarios="#local.correoProveedor#"
                      asunto="Notificación de entrada a almacén de su compra"
                      imagenes="#Local.imagenes#"
                      archivos="#Local.archivos#"
                      parametros="#Local.parametros#"
                      nu_requisision = "N/A"
                      sn_plantilla="YES"
                      dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailEntradaPorCompraAvisoProveedor.html"
                      returnvariable="Local.rbr"/>
            </cfif>

        </cfif>

        <cfset Local.Data = structNew()>

        <cfset variables.RBR.setData(local.nextId_Movimiento)>

        <!--- Finalmente hacemos los calculos correspondientes para esta tabla usando la funcion de Flavio --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                  method="ActualizarPorEntradaAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_movimiento="#local.nextId_Movimiento#"
                  id_tipoMovimiento="#arguments.de_tipomovimento#"/>

        <cfif #isDefined('arguments.sn_Reposicion')# AND #arguments.sn_Reposicion# EQ 1>
            <cfloop array="#arguments.insumos#" index="Local.insumo">
                <cfif isDefined("Local.insumo.series")>
                    <cfloop array="#Local.insumo.series#" index="local.serie">
                        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleOrigenPrestamos')#"
                                method="EntradaCompraReposicion"
                                id_Empresa              = "#Local.insumo.id_Empresa#"
                                id_OrdenDeCompra        = "#Local.insumo.id_OrdenDeCompra#"
                                id_OrdenDeCompraDetalle = "#Local.insumo.id_OrdenDeCompraDetalle#"
                                de_SerieInsumo          = "#Local.serie.de_SerieInsumo#"
                                de_Etiqueta             = "#local.serie.de_Etiqueta#"
                                id_Usuario              = "#session.ID_USUARIO#"
                                returnvariable="Local.prestamo">
                    </cfloop>
                <cfelse>
                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleOrigenPrestamos')#"
                                method="EntradaCompraReposicion"
                                id_Empresa              = "#Local.insumo.id_Empresa#"
                                id_OrdenDeCompra        = "#Local.insumo.id_OrdenDeCompra#"
                                id_OrdenDeCompraDetalle = "#Local.insumo.id_OrdenDeCompraDetalle#"
                                id_Usuario              = "#session.ID_USUARIO#"
                                de_SerieInsumo          = ""
                                de_Etiqueta             = ""
                                returnvariable="Local.prestamo">
                </cfif>
            </cfloop>
        </cfif>

        <!---
            Autor: Victor Martinez
            Fecha: 02/03/2026
                Se agrego envio de correo para insumos que son Activos Fijos y/o Insumos Relevantes
         --->

<!---================================================
    CLASIFICAR INSUMOS EN AF, RELEVANTES Y AMBOS
==================================================--->
<cfset arguments.arr_insumosActivoFijo = arrayNew(1)>
<cfset arguments.arr_insumosRelevantes = arrayNew(1)>
<cfset arguments.arr_insumosAmbos      = arrayNew(1)>

<cfloop array="#arguments.insumos#" index="local.insumoClasif">
    <cfset local.valAF = "0">
    <cfif structKeyExists(local.insumoClasif, "SN_ACTIVOFIJO")>
        <cfset local.valAF = trim(toString(local.insumoClasif.SN_ACTIVOFIJO))>
    </cfif>
    <cfset local.esAF = (local.valAF EQ "1" OR local.valAF EQ "true" OR local.valAF EQ "yes")>

    <cfset local.valRel = "0">
    <cfif structKeyExists(local.insumoClasif, "SN_RELEVANTE")>
        <cfset local.valRel = trim(toString(local.insumoClasif.SN_RELEVANTE))>
    </cfif>
    <cfset local.esRel = (local.valRel EQ "1" OR local.valRel EQ "true" OR local.valRel EQ "yes")>

    <cfif local.esAF AND local.esRel>
        <cfset arrayAppend(arguments.arr_insumosAmbos,      local.insumoClasif)>
    <cfelseif local.esAF>
        <cfset arrayAppend(arguments.arr_insumosActivoFijo, local.insumoClasif)>
    <cfelseif local.esRel>
        <cfset arrayAppend(arguments.arr_insumosRelevantes, local.insumoClasif)>
    </cfif>
</cfloop>

<cffile action="append"
        file="#ExpandPath('/error_correo_entrada.txt')#"
        output="#now()# - [ENTRADA] Clasificacion: AF=#arrayLen(arguments.arr_insumosActivoFijo)# | Relevantes=#arrayLen(arguments.arr_insumosRelevantes)# | Ambos=#arrayLen(arguments.arr_insumosAmbos)#"
        addnewline="true">

<!--- Envio Correo: AF, Relevantes y Ambos (Entrada) --->
<cftry>
    <cffile action="append"
            file="#ExpandPath('/error_correo_entrada.txt')#"
            output="#now()# - [ENTRADA] Inicio bloque notificacion correo."
            addnewline="true">

    <cfset local.hayInsumosParaNotificar =
        (arrayLen(arguments.arr_insumosActivoFijo) GT 0) OR
        (arrayLen(arguments.arr_insumosRelevantes) GT 0) OR
        (arrayLen(arguments.arr_insumosAmbos)      GT 0)>

    <cffile action="append"
            file="#ExpandPath('/error_correo_entrada.txt')#"
            output="#now()# - [ENTRADA] hayInsumosParaNotificar=#local.hayInsumosParaNotificar#"
            addnewline="true">

    <cfif local.hayInsumosParaNotificar>

        <cfset local.destinatariosSet = structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','NotificacionesActivosFijos')#"
                  method="getUsuariosAF"
                  returnvariable="local.RScorreoAF">
        <cffile action="append"
                file="#ExpandPath('/error_correo_entrada.txt')#"
                output="#now()# - [ENTRADA] getUsuariosAF recordCount=#local.RScorreoAF.recordCount#"
                addnewline="true">
        <cfloop query="#local.RScorreoAF#">
            <cfset local.tempEmails = listToArray(local.RScorreoAF.Emails, ";")>
            <cfloop array="#local.tempEmails#" index="local.e">
                <cfif len(trim(local.e)) GT 0>
                    <cfset local.destinatariosSet[trim(local.e)] = 1>
                </cfif>
            </cfloop>
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','NotificacionesActivosFijos')#"
                  method="getUsuariosRelevantes"
                  returnvariable="local.RScorreoRel">
        <cffile action="append"
                file="#ExpandPath('/error_correo_entrada.txt')#"
                output="#now()# - [ENTRADA] getUsuariosRelevantes recordCount=#local.RScorreoRel.recordCount#"
                addnewline="true">
        <cfloop query="#local.RScorreoRel#">
            <cfset local.tempEmails = listToArray(local.RScorreoRel.Emails, ";")>
            <cfloop array="#local.tempEmails#" index="local.e">
                <cfif len(trim(local.e)) GT 0>
                    <cfset local.destinatariosSet[trim(local.e)] = 1>
                </cfif>
            </cfloop>
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','NotificacionesActivosFijos')#"
                  method="getUsuariosAmbos"
                  returnvariable="local.RScorreoAmbos">
        <cffile action="append"
                file="#ExpandPath('/error_correo_entrada.txt')#"
                output="#now()# - [ENTRADA] getUsuariosAmbos recordCount=#local.RScorreoAmbos.recordCount#"
                addnewline="true">
        <cfloop query="#local.RScorreoAmbos#">
            <cfset local.tempEmails = listToArray(local.RScorreoAmbos.Emails, ";")>
            <cfloop array="#local.tempEmails#" index="local.e">
                <cfif len(trim(local.e)) GT 0>
                    <cfset local.destinatariosSet[trim(local.e)] = 1>
                </cfif>
            </cfloop>
        </cfloop>

        <cfset local.listaFinalDestinatarios = structKeyArray(local.destinatariosSet)>
        <cffile action="append"
                file="#ExpandPath('/error_correo_entrada.txt')#"
                output="#now()# - [ENTRADA] Total destinatarios unicos=#arrayLen(local.listaFinalDestinatarios)# | Lista=#arrayToList(local.listaFinalDestinatarios)#"
                addnewline="true">

        <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                  method="upR_EmpresaById"
                  id_Empresa="#session.ID_EMPRESA#"
                  returnvariable="local.empresaData">

        <cfset local.storageUrl = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/">
        <cfset local.imagenesCorreo = [
            { dir="#local.storageUrl##local.empresaData.ar_ImagenReporte#", disposicion="inline", name="logo" },
            { dir="assets/img/greenLeaf.jpg", disposicion="inline", name="footer", isLocal=true }
        ]>

        <cfset local.todosLosInsumos = arrayNew(1)>
        <cfloop array="#arguments.arr_insumosActivoFijo#" index="local.idx">
            <cfset arrayAppend(local.todosLosInsumos, local.idx)>
        </cfloop>
        <cfloop array="#arguments.arr_insumosRelevantes#" index="local.idx">
            <cfset arrayAppend(local.todosLosInsumos, local.idx)>
        </cfloop>
        <cfloop array="#arguments.arr_insumosAmbos#" index="local.idx">
            <cfset arrayAppend(local.todosLosInsumos, local.idx)>
        </cfloop>

        <cfset local.primerInsumo = local.todosLosInsumos[1]>

        <!--- LOG TEMPORAL: ver keys reales del insumo --->
        <cffile action="append"
        file="#ExpandPath('/error_correo_entrada.txt')#"
        output="#now()# - [ENTRADA] primerInsumo keys=#structKeyList(local.primerInsumo)# | NB_EMPRESA=#structKeyExists(local.primerInsumo,'NB_EMPRESA') ? local.primerInsumo.NB_EMPRESA : 'KEY NO EXISTE'# | NB_SUCURSAL=#structKeyExists(local.primerInsumo,'NB_SUCURSAL') ? local.primerInsumo.NB_SUCURSAL : 'KEY NO EXISTE'# | NB_PROVEEDOR=#structKeyExists(local.primerInsumo,'NB_PROVEEDOR') ? local.primerInsumo.NB_PROVEEDOR : 'KEY NO EXISTE'# | SERIE=#structKeyExists(local.primerInsumo,'SERIE') ? local.primerInsumo.SERIE : 'KEY NO EXISTE'#"
        addnewline="true">
        <cfset local.parametrosCorreoEntrada = structNew()>
        <cfset local.parametrosCorreoEntrada.asunto          = "Notificación de compra de insumos relevantes y/o activos fijos.">
        <cfset local.parametrosCorreoEntrada.Empresa         = structKeyExists(session, "NB_EMPRESA")   ? session.NB_EMPRESA   : "No especificado">
        <cfset local.parametrosCorreoEntrada.Sucursal        = structKeyExists(session, "NB_SUCURSAL")  ? session.NB_SUCURSAL  : "No especificado">
        <cfset local.parametrosCorreoEntrada.FechaHoraCompra = dateFormat(Now(),"dd/MM/yyyy") & " " & timeFormat(Now(),"hh:mm:ss tt")>
        <cfset local.parametrosCorreoEntrada.Proveedor       = len(trim(arguments.nb_proveedor)) GT 0   ? trim(arguments.nb_proveedor) : "No especificado">
        <cfset local.parametrosCorreoEntrada.nb_Usuario      = "Personal Administrativo / Interesados">
        <cfset local.parametrosCorreoEntrada.Usuario         = "Personal Administrativo / Interesados">
        <cfset local.parametrosCorreoEntrada.insumos         = local.todosLosInsumos>

        <cfif arrayLen(local.listaFinalDestinatarios) GT 0>

            <cffile action="append"
                    file="#ExpandPath('/error_correo_entrada.txt')#"
                    output="#now()# - [ENTRADA] Intentando sendMail a: #arrayToList(local.listaFinalDestinatarios)#"
                    addnewline="true">

            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                          method="sendMail"
                          destinatarios  = "#local.listaFinalDestinatarios#"
                          asunto         = "#local.parametrosCorreoEntrada.asunto#"
                          imagenes       = "#local.imagenesCorreo#"
                          parametros     = "#local.parametrosCorreoEntrada#"
                          sn_plantilla   = "YES"
                          dir_plantilla  = "templates/correos/AlmacenesEInventarios/templateMailNotificacionesActivosFijosRelevantes.html"/>

                <cffile action="append"
                        file="#ExpandPath('/error_correo_entrada.txt')#"
                        output="#now()# - [ENTRADA] sendMail ejecutado sin error capturado."
                        addnewline="true">

                <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n colectiva de entrada. Operaci&oacute;n exitosa.")>

            <cfcatch type="any">
                <cffile action="append"
                        file="#ExpandPath('/error_correo_entrada.txt')#"
                        output="#now()# - [ENTRADA] ERROR en sendMail: #cfcatch.message# | Detail: #cfcatch.detail#"
                        addnewline="true">
            </cfcatch>
            </cftry>

        <cfelse>
            <cffile action="append"
                    file="#ExpandPath('/error_correo_entrada.txt')#"
                    output="#now()# - [ENTRADA] ADVERTENCIA: listaFinalDestinatarios vacia, no se envia correo."
                    addnewline="true">
            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        </cfif>

    <cfelse>
        <cffile action="append"
                file="#ExpandPath('/error_correo_entrada.txt')#"
                output="#now()# - [ENTRADA] hayInsumosParaNotificar=false, no aplica notificacion."
                addnewline="true">
    </cfif>

    <cffile action="append"
            file="#ExpandPath('/error_correo_entrada.txt')#"
            output="#now()# - [ENTRADA] Fin bloque notificacion correo."
            addnewline="true">

<cfcatch type="any">
    <cffile action="append"
            file="#ExpandPath('/error_correo_entrada.txt')#"
            output="#now()# - [ENTRADA] ERROR GENERAL: #cfcatch.message# | Detail: #cfcatch.detail# | Type: #cfcatch.type#"
            addnewline="true">
</cfcatch>
</cftry>


        <!--- MODIFICACION CONFIGURACION ALMACENES SIN INVENTARIO --->
        <cfinvoke
            component="#Application.RF.getPath('dao','ConfiguracionAlmacenesSinInventario')#"
            method             = "existeConfiguracion"
            id_Empresa         = "#session.ID_EMPRESA#"
            id_Sucursal        = "#SESSION.ID_SUCURSAL#"
            id_TipoDivision    = "#arguments.id_TipoDivision#"
            sn_Activo          = "#1#"
            returnvariable     = "Local.Configuracion">

            <!--- Si cuenta con una configuración activa, realizar la salida por consumo en automatico --->

            <cfif Local.Configuracion.SN_ESTATUS EQ 1>

                <!--- Manda a llamar el listado de la pantalla DetalleRequisicionConsultaAlmacen, la cual es donde se realiza la salida por consumo --->
                <cfinvoke
                    component="#Application.RF.getPath('bro','DetalleRequisicionConsultaAlmacen')#"
                    method              = "listar"
                    id_Requisicion      = "#arguments.id_Requisicion#"
                    returnvariable      = "Local.ListadoREQAlmacen">

                <!--- Convertimos la Query en un array --->
                <cfset insumosDataAlmacen = queryToArray( Local.ListadoREQAlmacen.getData().DETALLEREQ) >

                <cfset insumosDataAlmacen = ordenarPorIdInsumo(insumosDataAlmacen) >
                <cfset arguments.insumos  = ordenarPorIdInsumo(arguments.insumos) >

                <cfset resultado = []>
                <cfset mensajesNoEncontrados = []>
                <cfset mensajesNoEncontradosString = "">

                <cfloop index="i" from="1" to="#arrayLen(insumosDataAlmacen)#">
                    <cfset encontrado = false>

                    <cfloop index="j" from="1" to="#arrayLen(arguments.insumos)#">
                        <!--- Compara el id_CentroCosto e id_Insumo de ambos arreglos --->
                        <cfif insumosDataAlmacen[i].ID_CENTROCOSTO EQ arguments.insumos[j].ID_CENTROCOSTO.ID_CENTROCOSTO AND
                            insumosDataAlmacen[i].ID_INSUMO EQ arguments.insumos[j].ID_INSUMO AND (insumosDataAlmacen[i].ID_ESTATUSSURTIDO EQ 3 OR insumosDataAlmacen[i].ID_ESTATUSSURTIDO EQ 2)>

                            <!--- Verificar si ya existe en el resultado --->
                            <cfset yaExiste = false>
                            <cfloop array="#resultado#" index="item">
                                <cfif   item.ID_CENTROCOSTO EQ insumosDataAlmacen[i].ID_CENTROCOSTO AND item.ID_INSUMO EQ insumosDataAlmacen[i].ID_INSUMO>
                                    <cfset yaExiste = true>
                                    <cfbreak>
                                </cfif>
                            </cfloop>

                            <!--- Si no existe, se agrega --->
                            <cfif NOT yaExiste>
                                <cfset arrayAppend(resultado, insumosDataAlmacen[i])>
                            </cfif>
                            <cfset encontrado = true>
                            <cfbreak>
                        </cfif>
                    </cfloop>

                    <!--- Si no se encontró coincidencia, agregar el nombre del insumo y centro de costo al arreglo de mensajes --->
                    <cfif NOT encontrado>
                        <cfset arrayAppend(mensajesNoEncontrados, insumosDataAlmacen[i].NB_NOMBREINSUMO & ": " & insumosDataAlmacen[i].NB_GRUPOCENTROCOSTO & " - " & insumosDataAlmacen[i].NB_CENTROCOSTO)>
                    </cfif>
                </cfloop>

                <!--- Verificar si no se encontraron coincidencias --->
                <cfif arrayLen(resultado) EQ 0>
                    <!--- Convertir el arreglo de mensajes formateados a una cadena --->
                    <cfset mensajesNoEncontradosString = arrayToList(mensajesNoEncontrados, ", ")>
                    <cfset variables.RBR.setError("El centro costo seleccionado no corresponde al de la requisición. #mensajesNoEncontradosString#")>
                    <cfreturn variables.RBR>
                </cfif>

                <cfloop index="i" from="1" to="#arrayLen(resultado)#">

                    <cfif resultado[i].ID_ESTATUSSURTIDO EQ 1 >
                        <cfset variables.RBR.setError("El Insumo ya ha sido surtido completamente para su centro costo seleccionado. #arrayToList(mensajesNoEncontrados, ", ")#")>
                        <cfreturn variables.RBR>
                    </cfif>

                    <cfset resultado[i].CantidadaSurtir = arguments.insumos[i].NU_CANTIDADRECIBIDA>

                </cfloop>

                <!--- Se realiza la salida por consumo  --->
                <cfinvoke
                    component="#Application.RF.getPath('bro','DetalleRequisicionConsultaAlmacen')#"
                    method                          = "editar"
                    RequisicionesConsultaAlmacen    = "#resultado#"
                    InsumosSeriados                 = "#[]#"
                    Operacion                       = "Surtir"
                    id_Requisicion                  = "#arguments.id_Requisicion#"
                    id_UsuarioRecibio               = "#arguments.id_UsuarioRegistroOrdenCompra#"
                    id_SucursalSolicita             = "#SESSION.ID_SUCURSAL#"
                    configuracion_almacen           = "#1#">
            </cfif>

        <!--- <cfset variables.RBR.setError("Función ejecutada correctamente")> --->
        <cfreturn variables.RBR>
    </cffunction>

    <!---
        Autor: Mario Mejia
        Fecha: 13/03/2015
        Descr:  Funcion que realiza el registro de entrada en las tablas: AlmacenesExistencia, InventarioMovimiento,
                InventarioMovimientoDetalle, OrdenesDeCompra y OrdenesDeCompraDetalle el array insumos contiene el detalle de
                cada insumo para esa orden de compra se realizaran los invokes "Insumos.Length" veces para registrar cada insumo --->
    <cffunction name="registrarEntrada" access="remote" returntype="any">
        <cfargument name="id_ordenDeCompra"                 type="string" required="true">
        <cfargument name="nb_proveedor"                     type="string" required="true">
        <cfargument name="fh_registroOrdenCompra"           type="string" required="true">
        <cfargument name="fh_EntregaProbable"               type="string" required="true">
        <cfargument name="fh_Revision"                      type="string" required="false" default="NULL">
        <cfargument name="fh_Vencimiento"                   type="string" required="false" default="NULL">
        <cfargument name="fh_recepcion"                     type="string" required="true">
        <!--- <cfargument name="nu_diasRetrazo" type="string" required="true"> --->
        <cfargument name="fl_facturaRemision"               type="string" required="true">
        <cfargument name="fh_facturaRemision"               type="string" required="true">
        <cfargument name="de_entrego"                       type="string" required="true">
        <cfargument name="insumos"                          type="array" required="true">
        <cfargument name="id_UsuarioRegistroOrdenCompra"    type="numeric" required="false">
        <!--- <cfargument name="id_almacenEntrega" type="numeric" required="false"> --->
        <!--- <cfargument name="nb_almacenEntrega" type="string" required="false"> --->
        <cfargument name="de_movimiento"                    type="numeric" required="true">
        <cfargument name="ocseleccionadas"                  type="array"    required="true">
        <cfargument name="id_proveedor"                     type="numeric"  required="true">

        <cfif not isDefined("arguments.fl_facturaRemision")>
            <cfset arguments.fl_facturaRemision = ''>
        </cfif>

        <cfif not isDefined("arguments.fh_facturaRemision")>
            <cfset arguments.fh_facturaRemision = ''>
        </cfif>

        <cfif arguments.id_almacenEntrega NEQ session.ID_ALMACEN>
            <cfset variables.RBR.setError("La orden de compra tiene un almacén de entrega diferente al almacén en el que te encuentras trabajando,<br> no es posible hacer el movimiento de entrada.")>
            <cfreturn variables.RBR>
        </cfif>

        <cfif arguments.de_movimiento EQ 1>
            <cfset arguments.de_tipomovimento = 1>
        <cfelseif arguments.de_movimiento EQ 0>
            <cfset arguments.de_tipomovimento = 11>
        </cfif>

        <!--- vamos a traer la el tipo de cambio de la moneda del dia anterior --->
        <cfinvoke component="#Application.RF.getPath('dao','Monedas')#"
          method="MonedaDiaAnteriorPorOC"
          id_Empresa="#session.ID_EMPRESA#"
          id_OrdenCompra="#arguments.id_ordenDeCompra#"
          returnvariable="local.TipoCambio"
          >

        <!--- Modificacion a la tabla inventariosMovimientos, esta solo se necesita realizar una sola vez --->

        <!--- Realizamos la insercion de los datos a inventariosMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="AgregarMovimiento"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    <!---id_movimiento="#local.nextId_Movimiento#"--->
                    id_tipoMovimiento="#arguments.de_tipomovimento#"
                    <!---fl_movimiento="#local.fl_movimiento#"
                    fh_Movimiento="#arguments.fh_recepcion#"--->
                    fl_facturaRemision="#arguments.fl_facturaRemision#"
                    fh_facturaRemision="#arguments.fh_facturaRemision#"
                    de_entrego="#arguments.de_entrego#"
                    id_usuarioRecibio="#session.ID_USUARIO#"
                    <!--- id_ordenCompra="#arguments.id_ordenDeCompra#" --->
                    id_usuarioRegistroMovimiento="#session.ID_USUARIO#"
                    <!---fh_registro="#dateFormat(Now(),'yyyyMMdd')#">--->
                    returnvariable = "local.nextId_Movimiento">

        <!--- Variable para guardar la sumatoria del im_total de todos los insumos --->
        <cfset local.sumatoriaIm_totalMN = 0 >

        <!--- variables para el total de cada orden de compra que se insertara en la tabla de documentos prospectos --->
        <cfset local.im_subtotoc = 0>
        <cfset local.im_totoc = 0>
        <cfset local.subtotalaux = 0>

        <!--- variable para controlar la suma de los insumos de cada oc --->
        <cfset local.im_suminsumosoc = 0>
        <!--- se hace un recorrido de la oc seleccionadas en la pantalla de entradas por compra --->
        <cfloop from="1" to="#arrayLen(arguments.ocseleccionadas)#" index="local.i">
            <!--- se hace un recorrido de los insumos seleccionados en la pantalla de entrada por compra de n oc seleccionadas en la misma pantalla --->
            <cfloop from="1" to="#arrayLen(arguments.insumos)#" index="local.j">
                <cfif arguments.ocseleccionadas[local.i].ID_ORDENDECOMPRA EQ arguments.insumos[local.j].ID_ORDENDECOMPRA>
                    <cfset local.im_suminsumosoc += arguments.insumos[local.j].IM_PRECIOUNITARIO * arguments.insumos[local.j].NU_CANTIDADRECIBIDA>
                </cfif>
            </cfloop>
            <!--- se setea la suma de los insumos de cada una de las oc --->
            <cfset local.im_subtotoc += local.im_suminsumosoc>

            <!--- se va por los ímpuestos aplicables a la oc a la tabla de OrdenesDeCompraImpuestos --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeComprasImpuestos')#"
                        method="ObtenerImpuestos"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordencompra = "#arguments.ocseleccionadas[local.i].ID_ORDENDECOMPRA#"
                        returnvariable="local.impuesto">

            <!--- se hace un recorrido a los impuestos de la oc --->
            <cfloop query="local.impuesto">
                <!--- si el impuesto no tiene impuesto referencia se suma el importe de impuesto --->
                <cfif local.impuesto.ID_IMPUESTOREFERENCIA EQ ''>
                    <cfset local.im_totoc += local.im_subtotoc + (local.im_subtotoc * (local.impuesto.pj_aplicar / 100))>
                <!--- si el impuesto no tienen impuesto referencia se resta el importe total de impuesto --->
                <cfelseif local.impuesto.ID_IMPUESTOREFERENCIA NEQ ''>
                    <cfset local.im_totoc += local.im_subtotoc - (local.im_subtotoc * (local.impuesto.pj_aplicar / 100))>
                </cfif>
            </cfloop>

            <cfset local.subtotalaux += local.im_subtotoc>

            <!--- se setea en cero la variable que se usa para almacenar el total de insumos de cada oc --->
            <cfset local.im_suminsumosoc = 0>
            <cfset local.im_subtotoc = 0>
        </cfloop>

        <!--- se hace la inserccion en la tabla de DocumentosProspectos --->
        <cfinvoke   component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                    method="AgregarDocumentoProveedor"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    cl_tipodocumento ="NF"
                    id_proveedor ="#arguments.id_proveedor#"
                    fl_facturaRemision ="#arguments.fl_facturaRemision#"
                    fh_revision ="#arguments.fh_Revision#"
                    fh_facturaRemision ="#arguments.fh_facturaRemision#"
                    fh_vencimiento ="#arguments.fh_Revision#"
                    im_subtotal = "#local.subtotalaux#"
                    im_total ="#local.im_totoc#"
                    id_usuario ="#session.ID_USUARIO#"
                    returnvariable="local.documento">

        <!--- Modificacion a la tabla inventariosMovimientosDetalle, en esta hay que registrar cada insumo de la orden de compra --->
        <cfloop array="#arguments.insumos#" index="Local.insumo">
            <!--- Calculamos el im_precioTotalEntrada para este insumo y lo agregamos a la sumatoria --->
            <cfset local.im_precioTotalEntrada = (#Local.insumo.IM_PRECIOUNITARIO# * #local.TipoCambio.im_TipoCambio#) * Local.insumo.NU_CANTIDADRECIBIDA>
            <cfset local.sumatoriaIm_totalMN = local.sumatoriaIm_totalMN + local.im_precioTotalEntrada>

            <!--- Realizamos la insercion de cada insumo en inventariosMovimientosDetalle --->
            <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                        method="AgregarInventarioMovDetalle"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_movimiento="#local.nextId_Movimiento#"
                        id_insumo="#Local.insumo.ID_INSUMO#"
                        nu_cantidad="#Local.insumo.NU_CANTIDADRECIBIDA#"
                        nu_cantidadFacturada="#Local.insumo.NU_CANTIDADFACTURADA#"
                        im_precioTotalEntrada="#local.im_precioTotalEntrada#"
                        im_precioUnitarioEntrada="#Local.insumo.IM_PRECIOUNITARIO#"
                        id_MonedaEntrada="#Local.insumo.IDMONEDA#"
                        im_tipoCambioEntrada="#local.TipoCambio.im_TipoCambio#"
                        nu_existenciaAnterior="#Local.insumo.NU_EXISTENCIA#"
                        id_tipoCosteo="1" <!--- El valor de este campo siempre es 1 para esta pantalla --->
                        <!--- id_ordenDeCompra="#arguments.id_ordenDeCompra#" --->
                        id_ordenDeCompra="#Local.insumo.id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#Local.insumo.ID_ORDENDECOMPRADETALLE#"
                        returnvariable="local.nextNd_MovimientoDetalle">

            <!--- se realiza la inserccion en la tabla de DocumentosProveedoresdetalle --->
            <cfinvoke   component="#Application.RF.getPath('dao','DocumentosProveedoresdetalle')#"
                        method="AgregarDocumentoProveedorDetalle"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        cl_tipodocumento ="NF"
                        id_documento ="#local.documento.ID_DOCUMENTO#"
                        id_insumo="#Local.insumo.ID_INSUMO#"
                        nu_cantidad="#Local.insumo.NU_CANTIDADRECIBIDA#"
                        im_preciounitario ="#local.insumo.IM_PRECIOUNITARIO#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_movimiento="#local.nextId_Movimiento#"
                        nd_movimiento ="#local.nextNd_MovimientoDetalle#">

            <!--- Obtenemos el nu de existencia para el registro --->
            <!---           <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="getNu_existencia"
                      id_empresa="#session.ID_EMPRESA#"
                      id_sucursal="#SESSION.ID_SUCURSAL#"
                      id_almacen="#session.ID_ALMACEN#"
                      id_insumo="#Local.insumo.ID_INSUMO#"
                      returnvariable="Local.en_Existencia"/> --->


            <!---
            ESTE MOVIMIENTO SE COMENTA, SERÁ ACTUALIZADO POR TRIGGER
             Verificamos si hay algun registro para este insumo
            <cfif #Local.en_Existencia.recordCount# EQ 0>
                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                          method="RSAgregar"
                          id_empresa="#session.ID_EMPRESA#"
                          id_sucursal="#SESSION.ID_SUCURSAL#"
                          id_almacen="#session.ID_ALMACEN#"
                          id_insumo="#Local.insumo.ID_INSUMO#"
                          nu_existencia="#Local.insumo.NU_CANTIDADRECIBIDA#"
                          sn_activo="1"/>

                <cfelse>
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                              method="AgregarExistencia"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#SESSION.ID_SUCURSAL#"
                              id_almacen="#session.ID_ALMACEN#"
                              id_insumo="#Local.insumo.ID_INSUMO#"
                              nu_cantidad="#Local.insumo.NU_CANTIDADRECIBIDA#"/>
            </cfif>
            --->

            <!---
                modificacion: 11/06/2015
                Autor: Mario Mejia
                actualizacion:  Los insumos pueden ser o no seriados, en caso de serlo, debemos de registrar
                                todas las series capturadas por cada insumo en las tablas
                                AlmacenesExistenciasSeriesInsumos e InventariosMovimientosDetalleSeries --->
            <cfif isDefined("Local.insumo.series")>
                <!--- Mandamos a insertar todas las series de insumos --->
                <cfinvoke   component="#Application.RF.getPath('bro','AlmacenesExistenciasSeriesInsumos')#"
                            method="agregarInsumos"
                            insumos="#Local.insumo.series#"
                            returnvariable="Local.resultadoRegistro"/>

                <cfif Local.resultadoRegistro.hasError()>
                    <cfset variables.RBR.setError(Local.resultadoRegistro.getMessage())>
                    <cfreturn variables.RBR>
                </cfif>

                <!--- iteramos sobre las series para registrar cada una en la tabla InventariosMovimientosDetalleSeries --->
                <cfloop array="#Local.insumo.series#" index="local.serie">
                    <!--- Obtenemos el next ID para la tabla --->

                    <!--- Insertamos en la tabla --->
                    <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                method="agregarinventariomovmientoseries"
                                id_empresa = "#session.ID_EMPRESA#"
                                id_sucursal = "#SESSION.ID_SUCURSAL#"
                                id_almacen = "#session.ID_ALMACEN#"
                                id_movimiento = "#Local.nextId_Movimiento#"
                                nd_movimientoDetalle ="#Local.nextNd_MovimientoDetalle#"
                                <!---nd_inventarioMovimientoDetalleSerie = "#Local.nextNd_inventarioMovimientoDetalleSerie#"--->
                                de_serieInsumo = "#Local.serie.de_serieInsumo#">

                        <!--- MODIFICACION: Victor Sanchez
                        date: 03/08/2015 --->
                        <!---<cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="nextID"
                                  id_Empresa="#session.ID_EMPRESA#"
                                  returnvariable="nextID"/>--->

                        <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                                    method="listarTodos"
                                    id_insumo="#Local.insumo.ID_INSUMO#"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    returnvariable="sn_Activo"/>


                                    <!--- Si el activo va al almacen, su sn_Activo será 0 --->
                        <!--- FIX: Sanitizar nb_ActivoFijo para asegurar que el numero de serie
                             no quede concatenado al nombre del insumo, sin importar el origen del dato. --->
                        <cfset local.nb_NombreSanitizado = trim(Local.insumo.NB_NOMBREINSUMO)>
                        <cfset local.serieSanitizar = trim(local.serie.de_serieInsumo)>
                        <cfset local.etiquetaSanitizar = trim(local.serie.de_Etiqueta)>

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

                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="AgregarActivosFijos"
                                 <!--- id_ActivoFijo="#nextID#"--->
                                  nb_ActivoFijo="#local.nb_NombreSanitizado#"
                                  de_SerieActivo="#Local.serie.de_serieInsumo#"
                                  id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                  id_AlmacenEntrada="#session.ID_ALMACEN#"
                                  id_MovimientoEntrada="#local.nextId_Movimiento#"
                                  nd_MovimientoDetalleEntrada="#Local.nextNd_MovimientoDetalle#"
                                  <!---fh_EntradaAlmacen="#dateFormat(Now(),'yyyyMMdd')#"
                                  fh_ComienzoDevaluacion="#dateFormat(Now(),'yyyyMMdd')#"--->
                                  sn_Activo='0'
                                  de_etiqueta="#Local.serie.de_Etiqueta#"
                                  returnvariable="id_ActivoFijo"
                                  />

                                  <!--- Se agrega el movimiento en ActivosFijosDetalleEntradas --->
                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                  method="upC_ActivosFijosDetalleEntradas"
                                  id_Empresa="#session.ID_EMPRESA#"
                                  id_ActivoFijo="#id_ActivoFijo.id_ActivoFijo#"
                                  id_Sucursal="#SESSION.ID_SUCURSAL#"
                                  id_Almacen="#session.ID_ALMACEN#"
                                  id_Movimiento="#local.nextId_Movimiento#"
                                  nd_MovimientoDetalle="#Local.nextNd_MovimientoDetalle#"
                                  />

                        <!--- Fin modificacion --->
                </cfloop>
            </cfif>
        </cfloop>

        <!--- una vez obtenida la sumatoria de los im_totalMN de cada insumo actualizamos la tabla InventariosMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="setIm_totalMN"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_movimiento="#local.nextId_Movimiento#"
                    im_TotalMN="#local.sumatoriaIm_totalMN#">

        <cfloop from="1" to="#arrayLen(arguments.insumos)#" index="local.i">
            <!--- Sumar en ordenes de compra detalle la cantidad ingresada por cada insumo --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                        method="add_Nu_CantidadSurtida"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.insumos[local.i].id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#arguments.insumos[local.i].ID_ORDENDECOMPRADETALLE#"
                        id_insumo="#arguments.insumos[local.i].ID_INSUMO#"
                        nu_cantidadSurtida="#arguments.insumos[local.i].NU_CANTIDADRECIBIDA#"/>

            <!--- obtener la cantidad surtida actualizada de cada insumo --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                        method="get_Nu_CantidadSurtida"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.insumos[local.i].id_ordenDeCompra#"
                        id_ordenDeCompraDetalle="#arguments.insumos[local.i].ID_ORDENDECOMPRADETALLE#"
                        id_insumo="#arguments.insumos[local.i].ID_INSUMO#"
                        returnvariable="local.cantidadSurtidaObtenida"/>

            <cfif arguments.insumos[local.i].NU_CANTIDADRECIBIDA GT arguments.insumos[local.i].NU_CANTIDADPORSURTIR>
                <cfset variables.RBR.setError('La cantidad recibida ingresada  no debe ser mayor a la cantidad por surtir.')>
                <cfreturn variables.RBR>
            </cfif>

            <cfif arguments.insumos[local.i].NU_CANTIDADRECIBIDA LT 0>
                <cfset variables.RBR.setError('La cantidad recibida ingresada no puede tener un valor negativo.')>
                <cfreturn variables.RBR>
            </cfif>

            <!--- Si la cantidad surtida es mayor o igual que la cantidad solicitada, ponemos el estatus como surtido --->
            <cfif local.cantidadSurtidaObtenida.nu_cantidadSurtida GTE arguments.insumos[local.i].NU_CANTIDAD>
                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.insumos[local.i].id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#arguments.insumos[local.i].ID_ORDENDECOMPRADETALLE#"
                            id_insumo="#arguments.insumos[local.i].ID_INSUMO#"
                            id_estatusSurtido="1">

                <cfset arguments.insumos[local.i].de_estatusSurtido = "Surtido Completo">

            <!--- Si cantidad surtida es menor a la solicitada, pero mayor a 0, el estatus es surtido parcialmente --->
            <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida LT arguments.insumos[local.i].NU_CANTIDAD AND local.cantidadSurtidaObtenida.nu_cantidadSurtida GT 0>

                <!--- se verifica de que pantalla viene(Entrada surtido por devolcion = 0 o entrada por compra = 1), para saber que surtido parcial poner,
                      si parcial por devolucion o simplemente parcial 24/09/2015--->
                <cfif arguments.de_movimiento EQ 0>
                    <cfset arguments.estatusparcial = 4>
                <cfelseif arguments.de_movimiento EQ 1>
                    <cfset arguments.estatusparcial = 2>
                </cfif>

                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.insumos[local.i].id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#arguments.insumos[local.i].ID_ORDENDECOMPRADETALLE#"
                            id_insumo="#arguments.insumos[local.i].ID_INSUMO#"
                            id_estatusSurtido="#arguments.estatusparcial#">

                <cfset arguments.insumos[local.i].de_estatusSurtido = "Surtido Parcialmente">

            <!--- Si cantidad surtida es 0, el estatus es sin surtir --->
            <cfelseif local.cantidadSurtidaObtenida.nu_cantidadSurtida EQ 0>
                <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompraDetalle')#"
                            method="set_Id_estatusSurtido"
                            id_empresa="#session.ID_EMPRESA#"
                            id_ordenDeCompra="#arguments.insumos[local.i].id_ordenDeCompra#"
                            id_ordenDeCompraDetalle="#arguments.insumos[local.i].ID_ORDENDECOMPRADETALLE#"
                            id_estatusSurtido="3">

                <cfset arguments.insumos[local.i].de_estatusSurtido = "Sin Surtir">
            </cfif>
        </cfloop>

        <!--- se hace un recorrido para actualizar los estatus de cada orden de compra --->
        <cfloop from="1" to="#arrayLen(arguments.ocseleccionadas)#" index="local.i">
            <!--- Metodo que nos dice cual es el estatusSurtido de una orden de compra analizando la tabla OrdenesDeCompraDetalle --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                        method="validarEstatusSurtido"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.ocseleccionadas[local.i].id_ordenDeCompra#"
                        returnvariable ="Local.estatus">

            <!--- Acutalizamos el estatus de surtido para la tabla ordenes de compra --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                        method="set_Id_estatusSurtido"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.ocseleccionadas[local.i].id_ordenDeCompra#"
                        id_estatusSurtido="#local.estatus#">

            <!--- ADICIONAL actualizamos el campo fh_ultimaEntrega a la fecha en la que se realiza la entrada (fecha de hoy) --->
            <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                        method="set_fh_ultimaEntrega"
                        id_empresa="#session.ID_EMPRESA#"
                        id_ordenDeCompra="#arguments.ocseleccionadas[local.i].id_ordenDeCompra#"
                        fh_ultimaEntrega="#dateFormat(Now(),'yyyyMMdd')#">

        </cfloop>

        <!--- ADICIONAL mandamos a llamar la funcion hecha por Flavio para aplicar un metodo de costeo a un inventario movimiento de entrada --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                      method="AplicaMetodoAEntrada"
                      id_empresa="#session.ID_EMPRESA#"
                      id_sucursal="#SESSION.ID_SUCURSAL#"
                      id_almacen="#session.ID_ALMACEN#"
                      id_movimiento="#local.nextId_Movimiento#"/>


            <!--- Gruarda un registro a la tabla OrdenesDeCompraMovimientos --->
        <cfinvoke   component="#Application.RF.getPath('dao','OrdenesDeCompra')#"
                    method = "agregarOrdenesDeCompraMovimientos"
                    id_empresa         = "#session.ID_EMPRESA#"
                    id_ordenDeCompra   = "#arguments.id_ordenDeCompra#"
                    id_EmpresaEmpleado = "#session.ID_EMPRESAOPERADORA#"
                    id_Empleado        = "#session.ID_USUARIO#">

        <!---
            Autor: Mario Mejia
            Fecha: 11/05/2015
                Se agrego a la funcion registrarEntrada la posibilidad de mandar
                un correo electronico al usuario que registro la compra
                con un reporte adjunto de cuales insumos se les dio entrada
         --->
        <cfinvoke   component="#Application.RF.getPath('dao','EstatusSurtidoOrdenesDeCompra')#"
                    method="getRSPorID"
                    id_estatusSurtidoOrdenDeCompra="#Local.estatus#"
                    returnvariable="Local.estatusSurtido">

        <cfset Local.ordenCompra = structNew()>
        <cfset Local.ordenCompra.id_ordenDeCompra = arguments.id_ordenDeCompra>
        <cfset Local.ordenCompra.nb_proveedor = arguments.nb_proveedor>
        <cfset Local.ordenCompra.fh_registroOrdenCompra = arguments.fh_registroOrdenCompra>
        <cfset Local.ordenCompra.fh_EntregaProbable = arguments.fh_EntregaProbable>
        <cfset Local.ordenCompra.fh_recepcion = arguments.fh_recepcion>
        <cfset Local.ordenCompra.nu_diasRetrazo = arguments.nu_diasRetrazo>
        <cfset Local.ordenCompra.fl_facturaRemision = arguments.fl_facturaRemision>
        <cfset Local.ordenCompra.fh_facturaRemision = arguments.fh_facturaRemision>
        <cfset Local.ordenCompra.de_entrego = arguments.de_entrego>
        <cfset Local.ordenCompra.insumos = arguments.insumos>
        <cfset Local.ordenCompra.insumosConSeries = arguments.insumosConSeries>
        <cfset Local.ordenCompra.de_estatusSurtido = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra>

        <cfinvoke   component="#Application.RF.getPath('dao','Empleados')#"
                    method="getMailEmpleado"
                    id_usuario="#arguments.id_UsuarioRegistroOrdenCompra#"
                    returnvariable="Local.mailEmpleado">

        <cfset Local.destinatarios = ArrayNew(1)>
        <cfset ArrayAppend(Local.destinatarios, "#Local.mailEmpleado.DE_EMAIL#")>
        <!--- <cfset ArrayAppend(Local.destinatarios, "vsanchez@redrabbit.mx")> --->

        <cfif arrayLen(local.destinatarios) GT 0>
            <cfset Local.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                }
            ]>

            <cfinvoke   method="crearReporte"
                        argumentcollection="#Local.ordenCompra#"
                        returnvariable="rbrREPORTE">

            <cfif rbrREPORTE.hasError()>
                    <cfset errorMessage = "Error al generar el reporte<br/>" & rbrReporte.getMessage() />
                    <cfthrow type="Application" message="#errorMessage#">
            </cfif>

            <cfset Local.archivos=[{
                dir="reporteOrdenesCompra/reporteEntradaPorCompra_Orden"&#arguments.id_ordenDeCompra#&".pdf",
                name='reporte',
                sn_deleteFile= "no"
            }]>

            <cfset Local.parametros={
                id_ordenDeCompra = arguments.id_ordenDeCompra,
                nb_proveedor = arguments.nb_proveedor,
                fh_registroOrdenCompra = arguments.fh_registroOrdenCompra,
                fh_EntregaProbable = arguments.fh_EntregaProbable,
                fh_recepcion = arguments.fh_recepcion,
                nu_diasRetrazo = arguments.nu_diasRetrazo,
                fl_facturaRemision = arguments.fl_facturaRemision,
                fh_facturaRemision = arguments.fh_facturaRemision,
                de_entrego = arguments.de_entrego,
                de_estatusSurtido = Local.estatusSurtido.de_estatusSurtidoOrdenDeCompra
            }/>
            <!--- +APM- \u00f3  &#243; --->
            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                      method="sendMail"
                      destinatarios="#local.destinatarios#"
                      asunto="NotificaciÃ³n de entrada por compra"
                      imagenes="#Local.imagenes#"
                      archivos="#Local.archivos#"
                      parametros="#Local.parametros#"
                      nu_requisision = "N/A"
                      sn_plantilla="YES"
                      dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailEntradaPorCompra.html"
                      returnvariable="Local.rbr"/>
        </cfif>

        <cfset Local.Data = structNew()>
        <cfset variables.RBR.setData(Local.Data)>

        <!--- Finalmente hacemos los calculos correspondientes para esta tabla usando la funcion de Flavio --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                  method="ActualizarPorEntradaAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_movimiento="#local.nextId_Movimiento#"
                  id_tipoMovimiento="#arguments.de_tipomovimento#"/>

        <!--- se hace la inserccion en la tabla de DocumentosProveedoresInvMovimientos --->
        <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedoresInvMovimientos')#"
                  method="AgregarDocumentosProveedoresInvMovimientos"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#SESSION.ID_SUCURSAL#"
                  cl_tipodocumento="NF"
                  id_documento ="#local.documento.id_documento#"
                  id_almacen="#session.ID_ALMACEN#"
                  id_movimiento="#local.nextId_Movimiento#"/>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="nb_proveedor" type="string" required="true">
        <cfargument name="fh_registroOrdenCompra" type="string" required="true">
        <cfargument name="fh_EntregaProbable" type="string" required="true">
        <cfargument name="fh_recepcion" type="string" required="true">
        <cfargument name="nu_diasRetrazo" type="string" required="true">
        <cfargument name="fl_facturaRemision" type="string" required="true">
        <cfargument name="fh_facturaRemision" type="string" required="true">
        <cfargument name="de_entrego" type="string" required="true">
        <cfargument name="insumos" type="array" required="true">
        <cfargument name="im_TotalMN" type="string" required="true">


        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteEntradaPorCompra">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteEntradaPorCompra.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteEntradaPorCompra#"
                  pdf="reporteEntradaPorCompra_Orden#id_ordenDeCompra#"
                  debug="no"
                  path="#expandPath('../reporteOrdenesCompra/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <cffunction name="ObtenerActivoFijoEntradaCompra" access="public" returntype="Any">
        <cfargument name='id_Movimiento' type='string' required='yes'>
        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>
        <cfset arguments.id_Sucursal = #SESSION.ID_SUCURSAL#>
        <cfset arguments.id_Almacen = #session.ID_ALMACEN#>

        <cfinvoke component="#Application.RF.getPath('dao','ConsultaEntradaCompra')#"
                method="ObtenerActivoFijoEntradaCompra"
                argumentcollection="#arguments#"
                returnvariable="Local.RS">

        <cfif Local.RS.Result EQ 1>
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosEncabezado"
                  argumentcollection="#arguments#"
                  returnvariable="data">

            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="insumos">

                <!---Enviar Notificación de Entrada Activo Fijo, Omar Ibarra 07/06/2017--->
                <cfset datos = structNew()>
                <cfset local.datosEC = structNew()>
                <cfset local.datosEC = {
                    nb_Empresa =  #data.nb_Empresa#,
                    nb_Sucursal = #data.nb_Sucursal#,
                    nb_Almacen =  #data.nb_Almacen#,
                    nb_Almacenista = #data.nb_Almacenista#,
                    fecha_Entrada = #data.fh_RegistroOrdenCompra#,
                    folio_Entrada = #data.fl_movimiento#,
                    ordenDe_Compra = #data.id_OrdenDeCompra#,
                    insumos = #insumos#
                }>

                <cfset datos ={
                    datosEC = local.datosEC
                }>

                <!--- Generamos las notificaciones --->
                <cfinvoke component="#Application.RF.getPath('Bro','configuracionNotificaciones')#"
                            method="NotificarEmpleados"
                            argumentcollection="#arguments#"
                            id_Sucursal="#SESSION.ID_SUCURSAL#"
                            id_Notificacion="16"
                            datos="#datos#"
                            dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailNotificacionEntradaActivoFijo.html"
                            returnvariable="local.notificacion">
        </cfif>

        <cfset variables.RBR.setData(Local.RS.Result)>
        <cfreturn variables.RBR>
    </cffunction>

    <cfscript>
        private function queryToArray(q) {
            var s = [];
            var cols = q.columnList;
            var colsLen = listLen(cols);
            for(var i=1; i<=q.recordCount; i++) {
                row = {};
                for(var k=1; k<=colsLen; k++) {
                    row[lcase(listGetAt(cols, k))] = q[listGetAt(cols, k)][i];
                }
                arrayAppend(s, row);
            }
            return s;
        }
    </cfscript>

    <cfscript>
        /**
         * Función para ordenar un array por el campo 'id_requisicionDetalle'.
         * @param arrayData El array de estructuras a ordenar.
         * @return El array ordenado por 'id_requisicionDetalle'.
         */
        function ordenarPorIdInsumo(arrayData) {
            // Ordena el array usando arraySort y una función de comparación.
            arraySort(arrayData, function(a, b) {
                return compare(a.id_Insumo, b.id_Insumo);
            });
            return arrayData;
        }

    </cfscript>

</cfcomponent>
