<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="MovimientosDevolucionParaNotaCredito" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="numeric" required="false"/>
        <cfargument name="id_Sucursal"  type="numeric" required="true"/>
        <cfargument name="id_Almacen"   type="numeric" required="true"/>
        <cfargument name="id_Proveedor" type="numeric" required="true"/>
        <cfargument name="fh_Inicio"    type="string" required="true"/>
        <cfargument name="fh_Fin"       type="string" required="true"/>

        <cfif NOT isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="MovimientosDevolucionParaNotaCredito"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="folio"            type="string" required="false"/>
        <cfargument name="requisicion"      type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez
        05/11/2015
        lista los movimientos que son Entrada por devolucion de salida --->
    <cffunction name="upL_ConsultaDevolucionSalida" access="public" returntype="Any">
<!---       <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/> --->
        <cfargument name="folio"    type="string" required="false"/>
        <cfargument name="nombre"    type="string" required="false"/>
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"    type="string" required="false"/>


        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="upL_ConsultaDevolucionSalida"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez
        05/11/2015
        Trae el detalle de una entrada por devolucion de salida --->
    <cffunction name="upR_EntradaDevolucionSalidaDetalle" access="public" returntype="Any">
        <cfargument name="id_sucursal"              type="string" required="true"/>
        <cfargument name="id_almacen"               type="string" required="true"/>
        <cfargument name="id_movimiento"            type="string" required="true"/>
        <cfset arguments.id_empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="upR_EntradaDevolucionSalidaDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Victor Sanchez
        05/11/2015
        Trae el detalle de una entrada por devolucion de salida --->
    <cffunction name="upR_EntradaPorDevolucion_O_Faltante" access="public" returntype="Any">
            <cfargument name="id_proveedor"    type="string" required="false"/>
            <cfargument name="fh_inicio"    type="string" required="false"/>
            <cfargument name="fh_fin"    type="string" required="false"/>
            <cfargument name="porFaltante"    type="string" required="false"/>

            <cfif #porFaltante# EQ '1'>
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upR_EntradaPorFaltante"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">
            <cfelse>
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upR_EntradaPorDevolucion"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">
            </cfif>

        <cfset variables.RBR.setQuery(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>


    <!--- Victor Sanchez
        29/12/2015
        Registra las entradas por surtido de devolucion/faltante --->
    <cffunction name="RegistrarEntradaPorSurtidoDevolucionFaltante" access="public" returntype="Any">
            <cfargument name="porFaltante"    type="string" required="false"/>
            <cfargument name="insumosSeriados"    type="array" required="false"/>
            <cfargument name="seleccionados"    type="array" required="false"/>

<!---               <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upL_EntradaPorSurtidoDevolucionFaltante"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs"> --->
                    <cfset obj = structNew()>
                    <cfset obj.serieRepetida = false>



        <!--- Se actualiza el movimiento con la cantidad regresada   --->
        <cfif #porFaltante# EQ '1'>

            <!--- si es por faltante, se suma la cantidad registrada con la nu_cantidad --->
            <cfloop array="#seleccionados#" index="opcion">
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upU_EntradaPorFaltante"
                    id_empresa="#opcion.ID_EMPRESA#"
                    id_sucursal="#opcion.ID_SUCURSAL#"
                    id_Almacen="#opcion.ID_ALMACEN#"
                    id_insumo="#opcion.ID_INSUMO#"
                    id_movimiento="#opcion.ID_MOVIMIENTO#"
                    nd_movimientodetalle="#opcion.ND_MOVIMIENTODETALLE#"
                    nu_cantidadrecibida ="#opcion.CANTIDADRECIBIDA#">
            </cfloop>
        <cfelse>
            <!--- si es por devolucion, se resta la cantidad registrada a la nu_cantidadDevolucion, y se suma a la nu_cantidad --->
            <cfloop array="#seleccionados#" index="opcion">
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upU_EntradaPorDevolucion"
                    id_empresa="#opcion.ID_EMPRESA#"
                    id_sucursal="#opcion.ID_SUCURSAL#"
                    id_almacen="#opcion.ID_ALMACEN#"
                    id_movimiento="#opcion.ID_MOVIMIENTO#"
                    nd_movimientodetalle="#opcion.ND_MOVIMIENTODETALLE#"
                    id_insumo="#opcion.ID_INSUMO#"
                    nu_cantidadrecibida = "#opcion.CANTIDADRECIBIDA#"
                    >
            </cfloop>
        </cfif>

        <!---  1.1 Se inserta el movimiento en IM --->
        <cfset mov = structNew()>
        <cfset mov.id_Empresa = #seleccionados[1].ID_EMPRESA#>
        <cfset mov.id_Sucursal = #seleccionados[1].ID_SUCURSAL#>
        <cfset mov.id_Almacen = #seleccionados[1].ID_ALMACEN#>
        <cfset mov.id_TipoMovimiento = 11>
        <cfset mov.id_Almacen = #seleccionados[1].ID_ALMACEN#>
        <cfset mov.id_UsuarioRegistroMovimiento = #session.ID_USUARIO#>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="AgregarMovimiento"
            argumentcollection="#mov#"
            returnvariable="Local.movimiento.id_Movimiento">

        <!---  1.2 Se inserta el movimiento en DocumentosProveedoresInvMovimientos
                para dejar la referencia que para la factura seleccionada
                se registro un movimiento de surtido por faltante/devolución. --->
        <cfset doc = structNew()>
        <cfset doc.id_empresa = #seleccionados[1].ID_EMPRESA#>
        <cfset doc.id_sucursal = #seleccionados[1].ID_SUCURSAL#>
        <cfset doc.cl_tipodocumento = #seleccionados[1].CL_TIPODOCUMENTO#>
        <cfset doc.id_documento = #seleccionados[1].ID_DOCUMENTO#>
        <cfset doc.id_almacen = #seleccionados[1].ID_ALMACEN#>
        <cfset doc.id_movimiento = #Local.movimiento.id_Movimiento#>

            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedoresInvMovimientos')#"
                      method="AgregarDocumentosProveedoresInvMovimientos"
                      argumentcollection="#doc#"
                     >
        <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>
        <!---  1.3 Se inserta el movimiento en IMD --->

        <cfloop array="#seleccionados#" index="opcion">
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                      method="AgregarInventarioMovDetalle"
                      id_empresa="#opcion.ID_EMPRESA#"
                      id_sucursal="#opcion.ID_SUCURSAL#"
                      id_Almacen="#opcion.ID_ALMACEN#"
                      id_Movimiento="#Local.movimiento.id_Movimiento#"
                      id_insumo="#opcion.ID_INSUMO#"
                      nu_Cantidad="#opcion.CANTIDADRECIBIDA#"
                      im_PrecioUnitarioEntrada="#local.fnc.unformatNumber(opcion.IM_PRECIOUNITARIOENTRADA)#"
                        im_precioTotalEntrada="#local.fnc.unformatNumber(opcion.IM_PRECIOUNITARIOENTRADA) * opcion.CANTIDADRECIBIDA#"
                        <!--- id_MonedaEntrada="#Local.insumo.IDMONEDA#" --->
                        im_tipoCambioEntrada="#opcion.IM_TIPOCAMBIOENTRADA#"

                      returnvariable="Local.nd_MovimientoDetalle">
                      <cfset em = #opcion.ID_EMPRESA#>
                      <cfset suc = #opcion.ID_SUCURSAL#>
                      <cfset alm = #opcion.ID_ALMACEN#>
        <!---  2 Se insertan las series en InventariosMovimientosDetalleSeries --->
                <cfloop array="#insumosSeriados#" index="insumos">
                    <cfif #insumos.ID_INSUMO# EQ #opcion.ID_INSUMO#>
                        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                            method="agregarinventariomovmientoseries"
                            id_empresa ="#insumos.ID_EMPRESA#"
                            id_sucursal = "#insumos.ID_SUCURSAL#"
                            id_almacen = "#insumos.ID_ALMACEN#"
                            id_movimiento = "#Local.movimiento.id_Movimiento#"
                            nd_movimientoDetalle = "#Local.nd_MovimientoDetalle#"
                            de_Etiqueta = "#insumo.DE_ETIQUETA#"
                            <!---nd_inventarioMovimientoDetalleSerie = "#local.nd_inventariomovimientodetalleserie#"--->
                            de_serieInsumo="#insumos.DE_SERIE#">
                    <!--- Si es seriado, necesita registrar en Activos Fijos --->
                    <!--- Primero se valida si el insumo ya se encuentra en la tabla de activos fijos --->
                        <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                              method="upR_ActivoFijo"
                              id_empresa="#session.ID_EMPRESA#"
                              de_SerieActivo="#insumos.DE_SERIE#"
                              returnvariable="Activo"
                              >

                              <!--- FIX: Sanitizar nb_ActivoFijo para asegurar que el numero de serie o etiqueta 
                                   no quede concatenado al nombre del insumo. --->
                              <cfset local.nb_NombreSanitizado = trim(insumos.NB_NOMBREINSUMO)>
                              <cfset local.serieSanitizar = trim(insumos.DE_SERIE)>
                              <cfset local.etiquetaSanitizar = trim(insumos.DE_ETIQUETA)>

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

                              <cfif #Activo.RecordCount# EQ 0>
                                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                          method="AgregarActivosFijos"
                                         <!--- id_ActivoFijo="#nextID#"--->
                                          nb_ActivoFijo="#local.nb_NombreSanitizado#"
                                          de_SerieActivo="#insumos.DE_SERIE#"
                                          id_SucursalAsignado="#SESSION.ID_SUCURSAL#"
                                          id_AlmacenEntrada="#session.ID_ALMACEN#"
                                          id_MovimientoEntrada="#Local.movimiento.id_Movimiento#"
                                          nd_MovimientoDetalleEntrada="#Local.nd_MovimientoDetalle#"
                                          <!---fh_EntradaAlmacen="#dateFormat(Now(),'yyyyMMdd')#"
                                          fh_ComienzoDevaluacion="#dateFormat(Now(),'yyyyMMdd')#"--->
                                          sn_Activo='0'
                                          />
                                <cfelse>
                                    <cfset variables.RBR.setData({})>
                                    <cfset Variables.RBR.setError("La serie ya esta registrada.")>
                                    <cfreturn variables.RBR>
                              </cfif>

                    </cfif>

                </cfloop>
        </cfloop>
        <!--- funcion del flavio para actualizar costos promedios --->
            <!--- Se aplica el metodo del flavio AplicaMetodoAEntrada --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                      method="AplicaMetodoAEntrada"
                      id_empresa="#em#"
                      id_sucursal="#suc#"
                      id_almacen="#alm#"
                      id_movimiento="#Local.movimiento.id_Movimiento#"/>

        <!--- Finalmente hacemos los calculos correspondientes para esta tabla usando la funcion de Flavio --->
        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
              method="ActualizarCostoPromedioAlmacen"
              id_empresa="#em#"
              id_sucursal="#suc#"
              id_almacen="#alm#"
              id_movimiento="#Local.movimiento.id_Movimiento#"
              id_tipoMovimiento="2"/>

        <!--- Insertamos en AlmacenesExistenciasSeriesInsumos --->
        <cfloop array="#insumosSeriados#" index="opcion">
            <!--- verificamos si la serie ya esta registrada --->
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                method="existeSerie"
                de_serieInsumo="#opcion.DE_SERIE#"
                returnvariable="Local.sn_existe">

            <!--- Si esta registrada marcamos error y salimos --->
            <cfif Local.sn_existe>
            <!--- Se define cual fue el error --->
                <cfset obj.serieRepetida = true>
                <cfset obj.serie = '#opcion.DE_SERIE#'>
                <cfset Variables.RBR.setError("La serie ya esta registrada.")>
                <cfset variables.RBR.setData(obj)>
                <cfreturn variables.RBR>
            </cfif>

            <!--- Se agregan las series en almacenesExistencias --->
            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                method="AgregarSeriesInsumos"
                id_empresa="#opcion.ID_EMPRESA#"
                id_sucursal="#opcion.ID_SUCURSAL#"
                id_Almacen="#opcion.ID_ALMACEN#"
                id_insumo="#opcion.ID_INSUMO#"
                de_SerieInsumo="#opcion.DE_SERIE#">
        </cfloop>

        <cfset variables.RBR.setData(obj)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Victor Sanchez
        05/11/2015
        Trae el detalle de una entrada por devolucion de salida --->
    <cffunction name="upL_EntradaPorSurtidoDevolucionFaltante" access="public" returntype="Any">
            <cfargument name="folio"    type="string" required="false"/>

                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upL_EntradaPorSurtidoDevolucionFaltante"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">


        <cfset variables.RBR.setQuery(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que va por los movimientos de salida y entrada por devolucion a proveedor --->
    <cffunction name="getmovements" access="public" returntype="Any">
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getmovements"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- Victor Sanchez
        trae query de inventarios movimientos detalle para generar el reporte de existencias y movimientos
              --->
    <cffunction name="upR_InventariosMovimimientos" access="public" returntype="Any">
        <cfargument name="id_Sucursal"    type="string" required="false"/>
        <cfargument name="id_Almacen"    type="string" required="false"/>
        <cfargument name="id_Insumo"    type="string" required="false"/>
        <cfargument name="fh_Inicio"    type="string" required="false"/>
        <cfargument name="fh_Fin"    type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"    type="string" required="false"/>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upR_InventariosMovimimientos"
                    argumentcollection="#arguments#"
                    returnvariable="resultado">

            <!--- <cfdump var="#resultado#" /><cfabort /> --->

        <!--- <cfset arreglo = ArrayNew(1)>
        <cfloop query="resultado" >
            <cfset Linea = StructNew()>
            <cfset Linea.NU_CANTIDADINICIAL = #resultado.NU_EXISTENCIAANTERIOR#>
            <cfset Linea.NB_UNIDADMEDIDA = #resultado.NB_UNIDADMEDIDA#>
            <cfset Linea.NB_NOMBREINSUMO = #resultado.NB_NOMBREINSUMO#>
            <!--- Entradas --->
            <cfset Linea.NU_ENTRADASPORCOMPRA = #resultado.NU_ENTRADASPORCOMPRA#>
            <cfset Linea.NU_ENTRADASTRASPASO = #resultado.NU_ENTRADASPORTRASPASOS#>
            <cfset Linea.NU_ENTRADASAJUSTE = #resultado.NU_ENTRADASPORAJUSTE#>
            <cfset Linea.TOTAL_ENTRADAS = #resultado.NU_ENTRADASPORCOMPRA# + #resultado.NU_ENTRADASPORTRASPASOS# + #resultado.NU_ENTRADASPORAJUSTE#>
            <!--- Salidas --->
            <cfset Linea.NU_SALIDASPORCONSUMO =  #resultado.NU_SALIDASPORCONSUMO#>
            <cfset Linea.NU_SALIDATRASPASO =  #resultado.NU_SALIDASPORTRASPASO#>
            <cfset Linea.NU_SALIDADEVOLUCION = #resultado.NU_SALIDASPORDEVOLUCION# >
            <cfset Linea.NU_SALIDAAJUSTE = #resultado.NU_SALIDASPORAJUSTE# >
            <cfset Linea.TOTAL_SALIDAS = #resultado.NU_SALIDASPORCONSUMO# + #resultado.NU_SALIDASPORTRASPASO# + #resultado.NU_SALIDASPORDEVOLUCION# + #resultado.NU_SALIDASPORAJUSTE#>

            <cfset Linea.EXISTENCIA_TEORICA = Linea.NU_CANTIDADINICIAL + Linea.TOTAL_ENTRADAS - Linea.TOTAL_SALIDAS>

            <cfset ArrayAppend(arreglo, Linea)>
        </cfloop> --->

        <cfset variables.RBR.setData(resultado)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- funcion que devuelve los movimientos de entrada de servicio --->
    <cffunction name="getmovementsofentrada" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="string" required="false"/>
        <cfargument name="id_Sucursal"              type="string" required="false"/>
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_OrdenCompra"           type="string" required="false"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>
        <cfargument name="SubioFactura"             type="numeric" required="false"/>
        <cfargument name="nu_Siniestro"             type="string" required="false"/>


        <cfset arguments.id_Almacen = session.ID_ALMACEN>
        <cfset arguments.id_movimiento = 12>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getmovementsofentrada"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <cffunction name="getmovementsdetailofservice" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_movimiento"            type="numeric" required="true"/>


        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getmovementsdetailofservice"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que va por los movimientos de salida y entrada por devolucion a proveedor --->
    <cffunction name="getmovementsdetail" access="public" returntype="Any">
        <cfargument name="id_movimiento"            type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <!--- funcion que devuelve el detalle de insumos del movimiento --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getmovementsdetail"
                  argumentcollection="#arguments#"
                  returnvariable="Local.detail">

        <cfset variables.RBR.setQuery(local.detail)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que va por los movimientos de que se van ajustar correspondientes a un insumo --->
    <cffunction name="movimientosajustes" access="public" returntype="Any">
        <cfargument name="id_inventariofisico"      type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>
        <cfargument name="id_almacen"               type="numeric" required="true"/>
        <cfargument name="id_insumo"                type="numeric" required="false"/>
        <cfargument name="id_empresa"               type="numeric" required="true"/>
        <!--- <cfargument name="id_movimiento"          type="numeric" required="true"/> --->
        <!--- <cfargument name="id_insumo"              type="numeric" required="true"/> --->

        <!--- invoke que devuelve todos los movimientos del inventario fisico --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getmovimientosinventariofisico"
                  id_empresa ="#arguments.id_empresa#"
                  id_sucursal ="#arguments.id_Sucursal#"
                  id_almacen ="#arguments.id_almacen#"
                  id_inventariofisico ="#arguments.id_inventariofisico#"
                  id_insumo ="#arguments.id_insumo#"
                  returnvariable="Local.movimientos">

        <!--- estructura que ira almacenando los insumos por movimiento --->
        <cfset local.movinsumos = structNew()>
        <!--- arreglo que ira almacenando las estructuras --->
        <cfset local.arreglomovinsumos = arrayNew(1)>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <!--- se hace un recorrido de todos los movimientos correspondiente al inventario fisico y al insumo  --->
        <cfloop query="local.movimientos">
            <!--- invoke que devuelve todos los insumos registrados por cada movimientos --->
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                      method="getinsumosmovimientos"
                      argumentcollection="#arguments#"
                      id_movimiento = "#local.movimientos.ID_MOVIMIENTO#"
                      returnvariable="Local.rs">

            <cfset arrayAppend(local.arreglomovinsumos, local.rs)>

        </cfloop>


        <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="movimientosajustes"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs"> --->

        <cfset variables.RBR.setData(local.arreglomovinsumos)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- funcion que seta el id_tiposugerenciacargo de inventarios movimientos --->
    <cffunction name="setcargo" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"              type="numeric"      required="true"/>
        <cfargument name="id_almacen"               type="numeric"      required="true"/>
        <cfargument name="insumosajuste"            type="array"        required="true"/>
        <cfargument name="id_empresa"               type="numeric"      required="true"/>


        <cfloop from="1" to="#arrayLen(arguments.insumosajuste)#" index="local.i">
            <cfif arguments.insumosajuste[local.i].SN_MOSTRAR>
                <cfset arguments.id_movimiento = arguments.insumosajuste[local.i].ID_MOVIMIENTO>

                <cfif arguments.insumosajuste[local.i].SN_SALIDA>
                    <cfset arguments.id_tiposugerenciacargo = arguments.insumosajuste[local.i].CARGO.id_tiposugerenciacargo>
                    <cfset arguments.de_comentarios = arguments.insumosajuste[local.i].de_comentarios>
                    <cfset arguments.de_comentarioscobro = arguments.insumosajuste[local.i].de_comentarioscobro>
                </cfif>

                <cfif arguments.insumosajuste[local.i].SN_ENTRADA>
                    <cfset arguments.de_comentarios = arguments.insumosajuste[local.i].de_comentarios>
                    <cfset arguments.de_comentarioscobro = arguments.insumosajuste[local.i].de_comentarioscobro>
                </cfif>


                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                            method="setcargo"
                            argumentcollection="#arguments#">
            </cfif>
        </cfloop>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarSalidasporAjuste" access="public" returntype="Any">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="listarSalidasporAjuste"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- JULIO CESAR ACOSTA LOPEZ 19/03/2015 --->
    <cffunction name="listarEntradasporAjuste" access="public" returntype="Any">
        <cfargument name="fh_Inicio"        type="string" required="false"/>
        <cfargument name="fh_Fin"           type="string" required="false"/>
        <cfargument name="fl_Movimiento"    type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="listarEntradasporAjuste"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


<!--- Victor Sanchez
    22/10/2015
     funcion que devuelve las requisiciones que tengan movimientos de salida por consumo  --->
    <cffunction name="upR_RequisicionesSalidaConsumo" access="public" returntype="Any">
        <cfargument name="id_Requisicion"               type="string" required="false"/>
        <cfargument name="nb_Empleado"                  type="string" required="false"/>
        <cfargument name="fh_inicial"                   type="string" required="false"/>
        <cfargument name="fh_final"                 type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="upR_RequisicionesSalidaConsumo"
                  id_Sucursal="#SESSION.ID_SUCURSAL#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


<!--- Victor Sanchez
    23/10/2015
     funcion que devuelve las requisiciones que tengan movimientos de salida por consumo  --->
    <cffunction name="Obtener_InventariosMovimientosDetalle" access="public" returntype="Any">
        <cfargument name="id_Empresa"                   type="string" required="false"/>
        <cfargument name="id_Sucursal"                  type="string" required="false"/>
        <cfargument name="id_Almacen"                   type="string" required="false"/>
        <cfargument name="id_Movimiento"                type="string" required="false"/>
        <cfargument name="nd_MovimientoDetalle"         type="string" required="false"/>
        <cfif NOT isDefined('Arguments.id_Empresa')>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="Obtener_InventariosMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Registra los movimientos de salida de inventario por una solicitud de traspaso     --->
    <cffunction name="creaMovimientoSalidaPorTraspaso" access="public" returntype="Any">
        <cfargument name="id_inventarioTraspaso"  type="numeric" required="true"/>
        <cfargument name="id_UsuarioRecibio"      type="string" required="false"/>
        <cfargument name="de_Recibio"             type="string" required="false"/>
        <cfargument name="id_sucursalOrigen"      type="numeric" required="false"/>
        <cfargument name="id_sucursalDestino"     type="numeric" required="false"/>
        <cfargument name="id_almacenOrigen"       type="numeric" required="false"/>
        <cfargument name="id_almacenDestino"      type="numeric" required="false"/>
        <cfargument name="detalles"               type="array"   required="true"/>
        <cfargument name="de_Comentarios"         type="string"  required="false"/>
        <cfargument name="id_Requisicion"         type="string"  required="false"/>
        <cfargument name="id_TipoMovimiento"      type="string"   required="false"/>
        <cfargument name="id_Flete"         type="string"  required="false"/>
        <cfargument name="im_Flete"         type="string"  required="false"/>
        <cfargument name="de_Ruta"         type="string"  required="false"/>
        <cfargument name="de_NombrePDF"         type="string"  required="false"/>
        <cfargument name="de_Paqueteria"         type="string"  required="false"/>
        <cfargument name="de_Guia"         type="string"  required="false"/>

        <cfset Local.movimiento ={
            id_Empresa  = session.ID_EMPRESA,
            id_Sucursal = arguments.id_sucursalDestino EQ nullValue() ? SESSION.ID_SUCURSAL : arguments.id_sucursalDestino,
            id_Almacen  = arguments.id_almacenDestino EQ nullValue() ? session.ID_ALMACEN : arguments.id_almacenDestino,
            id_Requisicion  = arguments.id_Requisicion
        }>

        <!--- Obtener la informacion del traspaso --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                  method="getByID"
                  id_empresa="#session.ID_EMPRESA#"
                  id_inventarioTraspaso="#Arguments.id_inventarioTraspaso#"
                  returnvariable="Local.traspaso">

        <!--- Si el traspaso ya tiene estatus surtido, indicamos error para evitar duplicar salidas --->
        <cfif Local.traspaso.id_EstatusEnviosTraspaso EQ 3>
            <!--- <cfset Variables.RBR.setError("i&El traspaso ###Arguments.id_inventarioTraspaso# ya se encuentra surtido.")> --->
            <cfset errorMessage = "El traspaso ###Arguments.id_inventarioTraspaso# ya se encuentra surtido."/>
            <cfthrow type="info" message="#errorMessage#">
            <cfset variables.RBR.setData(Arguments.detalles)>
            <cfreturn variables.RBR>
        </cfif>

        <!--- Verifica que el traspaso este autorizado --->
        <cfif Local.traspaso.id_EstatusAutorizacionTraspaso NEQ 3>
            <!--- <cfset Variables.RBR.setError("i&El traspaso ###Arguments.id_inventarioTraspaso# no esta autorizado.")> --->
            <cfset errorMessage = "El traspaso ###Arguments.id_inventarioTraspaso# no esta autorizado."/>
            <cfthrow type="info" message="#errorMessage#">
            <cfset variables.RBR.setData(Arguments.detalles)>
            <cfreturn variables.RBR>
        </cfif>

        <!---<cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getNextID"
                  argumentcollection="#Local.movimiento#"
                  returnvariable="Local.movimiento.id_Movimiento">--->

        <!--- Movimiento por traspaso  --->
        <cfset Local.movimiento.id_TipoMovimiento = (arguments.id_TipoMovimiento EQ nullValue() ? 8 : arguments.id_TipoMovimiento)>

        <!---<cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                  method="getFolio"
                  argumentcollection="#Local.movimiento#"
                  returnvariable="Local.movimiento.fl_Movimiento">--->

        <!---<cfset Local.movimiento.fh_Movimiento = "#dateFormat(Now(),'yyyyMMdd')#">
        <cfset Local.movimiento.fh_Registro = "#dateFormat(Now(),'yyyyMMdd')#">--->
        <cfset Local.movimiento.id_UsuarioRegistroMovimiento =session.ID_USUARIO >
        <cfset Local.movimiento.id_UsuarioEntrego =session.ID_USUARIO >
        <cfset Local.movimiento.id_InventarioTraspaso = Arguments.id_InventarioTraspaso>
        <cfif isDefined("Arguments.de_Comentarios") >
            <cfset Local.movimiento.de_Comentarios = "#Arguments.de_Comentarios#">
        <cfelse>
            <cfset Local.movimiento.de_Comentarios = ''>
        </cfif>


        <cfif isDefined("Arguments.id_UsuarioRecibio") AND Arguments.id_UsuarioRecibio NEQ ''>
            <cfset Local.movimiento.id_UsuarioRecibio = Arguments.id_UsuarioRecibio>
        <cfelseif isDefined("Arguments.de_Recibio") AND Arguments.de_Recibio NEQ ''>
            <cfset Local.movimiento.de_Recibio = Arguments.de_Recibio>
        <cfelse>
            <!--- <cfset variables.RBR.setError("i&Es necesario especificar quien recibira para hacer la transferencia.")> --->
            <cfset errorMessage = "Es necesario especificar quien recibira para hacer la transferencia."/>
            <cfthrow type="info" message="#errorMessage#">
            <cfreturn>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="AgregarMovimiento"
                  argumentcollection="#Local.movimiento#"
                   returnvariable="Local.movimiento.id_Movimiento">

        <!--- <cfdump var="#Arguments.detalles#"><cfabort /> --->
        <cfset Local.sn_error =false >
        <cfset Local.detalleValor=0>

        <cfloop array="#Arguments.detalles#" index="Local.detalle">
            <!--- Si el detalle no ha sido surtido --->
            <cfif !Local.detalle.sn_surtida>
                <!--- Obtiene que cantidad hay del insumo en el almacen --->
                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="getNu_existencia"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#Local.movimiento.id_Sucursal#"
                    id_Almacen="#Local.movimiento.id_Almacen#"
                    id_Insumo="#Local.detalle.id_insumo#"
                    returnvariable="Local.existencia">

                <cfset Local.nu_ExistenciaAnterior=0>

                <cfif (Local.existencia.recordCount EQ 0 AND Local.detalle.nu_cantidadTraspasar EQ 0) OR
                      (Local.existencia.recordCount GT 0 AND
                      Local.existencia.nu_existencia GTE Local.detalle.nu_cantidadTraspasar)>

                    <cfif !Local.sn_error>
                        <cfif Local.existencia.recordCount GT 0  AND Local.detalle.nu_cantidadTraspasar GT 0>
                            <!--- <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                method="AgregarExistencia"
                                id_empresa="#session.ID_EMPRESA#"
                                id_sucursal="#SESSION.ID_SUCURSAL#"
                                id_Almacen="#session.ID_ALMACEN#"
                                id_Insumo="#Local.detalle.id_insumo#"
                                nu_Cantidad="-#Local.detalle.nu_cantidadTraspasar#"> --->

                            <cfset Local.nu_ExistenciaAnterior=Local.existencia.nu_existencia>

                        <cfelseif Local.existencia.recordCount EQ 0 AND Local.detalle.nu_cantidadTraspasar EQ 0>
                            <!--- <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                method="RSAgregar"
                                id_Empresa="#session.ID_EMPRESA#"
                                id_Sucursal="#SESSION.ID_SUCURSAL#"
                                id_Almacen="#session.ID_ALMACEN#"
                                id_Insumo="#Local.detalle.id_insumo#"
                                nu_Existencia="0"> --->

                            <cfset Local.nu_ExistenciaAnterior=0>
                        </cfif>

                        <cfif Local.detalle.nu_cantidadTraspasar GT 0>
                            <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="getNextID"
                                id_empresa="#session.ID_EMPRESA#"
                                id_sucursal="#SESSION.ID_SUCURSAL#"
                                id_Almacen="#session.ID_ALMACEN#"
                                id_Movimiento="#Local.movimiento.id_Movimiento#"
                                returnvariable="Local.nd_MovimientoDetalle"> --->

                            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                method="AgregarInventarioMovDetalle"
                                id_empresa="#session.ID_EMPRESA#"
                                id_sucursal="#Local.movimiento.id_Sucursal#"
                                id_Almacen="#Local.movimiento.id_Almacen#"
                                id_Movimiento="#Local.movimiento.id_Movimiento#"
                                <!---nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"--->
                                id_SucursalProveniente ='#arguments.id_sucursalOrigen#'
                                id_AlmacenProveniente ='#arguments.id_almacenOrigen#'
                                id_MovimientoProveniente ='#arguments.id_inventarioTraspaso#'
                                nd_MovimientoDetalleProveniente ='#local.detalle.nd_inventarioTraspasoDetalle#'
                                id_insumo="#Local.detalle.id_insumo#"
                                nu_Cantidad="#Local.detalle.nu_cantidadTraspasar#"
                                nu_ExistenciaAnterior="#Local.nu_ExistenciaAnterior#"
                                returnvariable="Local.nd_MovimientoDetalle">

                            <!--- Si el traspaso es por una consignacion, Actualizamos la información del Precio Promedio --->
                            <!--- <cfif Local.movimiento.id_TipoMovimiento EQ 62>
                                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                    method="ActualizarPrecioPromedio"
                                    id_empresa="#session.ID_EMPRESA#"
                                    id_sucursal="#local.movimiento.id_Sucursal#"
                                    id_Almacen="#local.movimiento.id_Almacen#"
                                    id_insumo="#local.detalle.id_insumo#"
                                    id_TipoMovimiento="#Local.movimiento.id_TipoMovimiento#">
                            </cfif> --->

                            <!--- isDefined("Local.detalle.series") AND isArray(Local.detalle.series) --->
                            <cfif Local.detalle.sn_insumoSeriado>
                                <cfif isDefined("Local.detalle.series") AND isArray(Local.detalle.series)>
                                    <cfloop array="#Local.detalle.series#" index="Local.serie">
                                        <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                            method="getNextID"
                                            id_empresa="#session.ID_EMPRESA#"
                                            id_sucursal="#SESSION.ID_SUCURSAL#"
                                            id_Almacen="#session.ID_ALMACEN#"
                                            id_Movimiento="#Local.movimiento.id_Movimiento#"
                                            nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                                            returnvariable="Local.nd_InventarioMovimientoDetalleSerie"> --->

                                        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                            method="agregarinventariomovmientoseries"
                                            id_empresa="#Local.movimiento.id_Empresa#"
                                            id_sucursal="#Local.movimiento.id_Sucursal#"
                                            id_Almacen="#Local.movimiento.id_Almacen#"
                                            id_Movimiento="#Local.movimiento.id_Movimiento#"
                                            nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                                            <!--- nd_InventarioMovimientoDetalleSerie="#Local.nd_InventarioMovimientoDetalleSerie#"--->
                                            de_SerieInsumo="#Local.serie.DE_SERIEINSUMO#"
                                            de_Etiqueta="#Local.serie.DE_ETIQUETA#">

                                        <!--- Ahora se va eliminar la serie del inventario al momento de realizar la entrada
                                            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                                            method="RSEliminar"
                                            id_empresa="#Local.movimiento.id_Empresa#"
                                            id_sucursal="#Local.movimiento.id_Sucursal#"
                                            id_Almacen="#Local.movimiento.id_Almacen#"
                                            id_insumo="#Local.detalle.ID_INSUMO#"
                                            id_AlmacenExistenciaSerieInsumo="#Local.serie.ID_ALMACENEXISTENCIASERIEINSUMO#">--->

                                    </cfloop>
                                </cfif>
                            </cfif>


                            <cfset ++Local.detalleValor>
                            <cfset Local.detalle.value=Local.detalleValor>
                        </cfif>
                    </cfif>
                <cfelse>
                    <cfset Local.sn_error=true>
                    <cfset Local.detalle.sn_errorExists = true >
                </cfif>
            </cfif>
        </cfloop>
        <!--- Si no hubo ningun detalle con cantidad a transferir mayor a 0, marcar error para no registrar
            movimientos con cantidades igual a cero --->
        <cfif Local.detalleValor EQ 0 AND !Local.sn_error>
            <!--- <cfset variables.RBR.setError("w&No se puede registrar el movimiento de salida.<br>Debe existir al menos una <b>cantidad a traspasar</b> superior a 0 (Cero).")> --->
            <cfset errorMessage = "No se puede registrar el movimiento de salida.<br>Debe existir al menos una <b>cantidad a traspasar</b> superior a 0 (Cero)."/>
            <cfthrow type="warning" message="#errorMessage#">
            <cfset variables.RBR.setData(Arguments.detalles)>
            <cfreturn variables.RBR>
        </cfif>


        <!--- Se aplica el movimiento del estatus de envio --->
                <!--- Se saca cuantos insumos se le dieron salida --->
                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upR_nuInsumosSalidaById_InventarioTraspaso"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_inventarioTraspaso ="#arguments.id_inventarioTraspaso#"
                    returnvariable="Local.InsumosSalida">

                <!--- se saca cuantos insumos se solicitaron en el traspaso --->
                <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                    method="upR_InsumosSolicitadosById_InventarioTraspaso"
                    id_Empresa="#session.ID_EMPRESA#"
                    id_inventarioTraspaso ="#arguments.id_inventarioTraspaso#"
                    returnvariable="Local.InsumosSolicitados">


                    <cfif #Local.InsumosSalida.NU_CANTIDAD# LT #Local.InsumosSolicitados.NU_CANTIDADSOLICITADA# >
                        <!--- se le pone estatus 'Enviado Parcial' si la cantidad que se le dio salida es menor
                        a la solicitada --->
                        <cfset Local.estatusTraspasoEnviado = 7>
                    </cfif>

                    <cfif #Local.InsumosSalida.NU_CANTIDAD# EQ #Local.InsumosSolicitados.NU_CANTIDADSOLICITADA# >
                        <!--- se le pone estatus 'Enviado Completo' si la cantidad que se le dio salida es menor
                        a la solicitada --->
                        <cfset Local.estatusTraspasoEnviado = 8>
                    </cfif>


        <!--- Se actualiza el estatus del traspaso --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                    method="updateEstatusEnvio"
                    id_Empresa="#Local.movimiento.id_Empresa#"
                    id_inventarioTraspaso="#arguments.id_inventarioTraspaso#"
                    id_EstatusTraspaso="#Local.estatusTraspasoEnviado#"
                    id_Flete = #arguments.id_Flete#
                    im_Flete = #arguments.im_Flete#
                    de_Ruta = #arguments.de_Ruta#
                    de_NombrePDF = #arguments.de_NombrePDF#
                    de_Paqueteria = #arguments.de_Paqueteria#
                    de_Guia = #arguments.de_Guia#

                    >



        <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                    method="AplicaMetodoASalida"
                    argumentcollection="#Local.movimiento#">

        <!--- Jesus Reyes --->
        <cfinvoke   component="#Application.RF.getPath('dao','CosteoInventarios')#"
                    method="ActualizarCostoPromedioAlmacen"
                    id_empresa        = "#Local.movimiento.id_Empresa#"
                    id_sucursal       = "#Local.movimiento.id_Sucursal#"
                    id_almacen        = "#Local.movimiento.id_Almacen#"
                    id_movimiento     = "#local.movimiento.id_Movimiento#">


        <cfif Local.sn_error>
            <!--- <cfset variables.RBR.setError("w&No hay existencia suficiente para surtir los insumos marcados.")> --->
            <cfset errorMessage = "No hay existencia suficiente para surtir los insumos marcados."/>
            <cfthrow type="warning" message="#errorMessage#">
            <cfset variables.RBR.setData(Arguments.detalles)>
        </cfif>

        <cfset variables.RBR.setData(Local.movimiento)>
        <cfreturn variables.RBR>
    </cffunction>


    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Obtiene los empleados con usuario y/o las personas que ya han sido registradas en
          movimientos anteriores.    --->
    <cffunction name="getPersonasReciben" access="public" returntype="Any">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getPersonasReciben"
                  id_empresa="#session.ID_EMPRESA#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 30/04/2015
          Obtiene los movimientos de inventario que se generaron para la solicitud de traspaso   --->
    <cffunction name="getByTraspaso" access="public" returntype="Any">
        <cfargument name="id_inventarioTraspaso" type="numeric" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getByTraspaso"
                  id_empresa="#session.ID_EMPRESA#"
                  id_inventarioTraspaso="#Arguments.id_inventarioTraspaso#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 24/04/2015
          Registra los movimientos de entrada de inventario por una solicitud de traspaso    --->
    <cffunction name="creaMovimientoEntradaPorTraspaso" access="public" returntype="Any">
        <cfargument name="id_inventarioTraspaso"  type="numeric" required="true"/>
        <cfargument name="id_movimiento"          type="string"  required="false"/> <!--- id_Movimiento de salida en inventariosMovimientos--->
        <cfargument name="id_sucursalOrigen"      type="string"  required="false"/> <!--- Desde cual sucursal me mandan los insumos --->
        <cfargument name="id_almacenOrigen"       type="string"  required="false"/> <!--- Desde cual almacen me mandan los insumos --->
        <cfargument name="detalles"               type="array"   required="true"/>
        <cfargument name="id_TipoMovimiento"      type="string"   required="false"/>
        <cfargument name="id_sucursalDestino"     type="string"   required="false"/>
        <cfargument name="id_almacenDestino"      type="string"   required="false"/>

        <!--- Comenzamos a generar el movimiento --->
        <cfset Local.movimiento ={
            id_Empresa = session.ID_EMPRESA,
            id_Sucursal = arguments.id_sucursalDestino EQ nullValue() ? SESSION.ID_SUCURSAL : arguments.id_sucursalDestino,
            id_Almacen  = arguments.id_almacenDestino EQ nullValue() ? session.ID_ALMACEN : arguments.id_almacenDestino,
        }>

        <!--- Movimiento por entreda traspaso  --->
        <cfset Local.movimiento.id_TipoMovimiento = (arguments.id_TipoMovimiento EQ nullValue() ? 3 : arguments.id_TipoMovimiento)>
        <cfset Local.movimiento.id_UsuarioRegistroMovimiento =session.ID_USUARIO >
        <cfset Local.movimiento.id_UsuarioRecibio =session.ID_USUARIO >
        <cfset Local.movimiento.id_InventarioTraspaso = Arguments.id_inventarioTraspaso>

        <!--- agregamos el movimiento en InventariosMovimiento --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="AgregarMovimiento"
                  argumentcollection="#Local.movimiento#"
                    returnvariable="Local.movimiento.id_Movimiento">

        <!--- Recorremos el detalle del traspaso --->
        <cfloop array="#Arguments.detalles#" index="Local.detalle">
            <!--- Si en el detalle no indicamos que surtiriamos algo, nos lo brincamos --->

            <cfif not isDefined("local.detalle.NU_CANTIDADREGISTRO") >
                <cfcontinue>
            <cfelse>
                <cfif local.detalle.NU_CANTIDADREGISTRO EQ 0>
                    <cfcontinue>
                </cfif>
            </cfif>

            <!--- Si el detalle no ha sido surtido --->
            <cfif Local.detalle.nu_cantidadPendiente GT 0>
                <!--- verifico cuantos insumos tengo en mi almacen --->
                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                          method="getNu_existencia"
                          id_empresa="#session.ID_EMPRESA#"
                          id_sucursal="#Local.movimiento.ID_SUCURSAL#"
                          id_Almacen="#Local.movimiento.id_Almacen#"
                          id_Insumo="#Local.detalle.id_insumo#"
                          returnvariable="Local.existencia">

                <!--- Si el query anterior no trajo registros, debemos marcar la existencia anterior como 0 --->
                <cfset Local.nu_ExistenciaAnterior = Local.existencia.recordCount GT 0? Local.existencia.NU_EXISTENCIA :0>

                <!--- Actualizamos la cantidad recibida por traspaso en la tabla InventariosMovimientosDetalle --->
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                          method="setCantidadRecibidaTraspaso"
                          id_empresa="#session.ID_EMPRESA#"
                          id_sucursal="#local.detalle.ID_SUCURSALPROVENIENTE#"
                          id_Almacen="#local.detalle.ID_ALMACENPROVENIENTE#"
                          id_Movimiento="#arguments.ID_MOVIMIENTO#"
                          nd_MovimientoDetalle="#local.detalle.ND_MOVIMIENTODETALLE#"
                          id_insumo="#local.detalle.ID_INSUMO#"
                          nu_CantidadRecibidaTraspaso="#local.detalle.NU_CANTIDADREGISTRO#">

                <!--- Actualizamos las cantidades surtidas del detalle del traspaso --->
                <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasosDetalle')#"
                          method="updateCantidadSurtida"
                          id_empresa="#session.ID_EMPRESA#"
                          id_inventarioTraspaso="#Arguments.ID_INVENTARIOTRASPASO#"
                          nd_inventarioTraspasoDetalle="#Local.detalle.ND_INVENTARIOTRASPASODETALLE#"
                          nu_cantidadSurtida="#Local.detalle.NU_CANTIDADREGISTRO#">

                <!--- Obtenemos el precio promedio del insumo origen (AlmacenesExistencias) - upR_PrecioPromedio_AlmacenesExistencias  --->
                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="upR_PrecioPromedio_AlmacenesExistencias"
                          id_empresa="#session.ID_EMPRESA#"
                          id_sucursal="#local.detalle.ID_SUCURSALPROVENIENTE#"
                          id_Almacen="#local.detalle.ID_ALMACENPROVENIENTE#"
                          id_insumo="#local.detalle.ID_INSUMO#"
                        returnvariable="Local.rs">

                <cfset Local.precioUnitarioEntradaExistencia = Local.rs.im_PrecioPromedio>
                <cfset Local.precioTotalEntradaExistencia = Local.rs.im_PrecioPromedio * Local.detalle.NU_CANTIDADREGISTRO>

                <!--- Creamos un nuevo detalle de movimiento --->
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                    method="AgregarInventarioMovDetalle"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#Local.movimiento.id_sucursal#"
                    id_Almacen="#Local.movimiento.id_Almacen#"
                    id_Movimiento="#Local.movimiento.ID_MOVIMIENTO#"
                    <!---nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"--->
                    im_PrecioUnitarioEntrada = #Local.precioUnitarioEntradaExistencia#
                    im_PrecioTotalEntrada = #Local.precioTotalEntradaExistencia#
                    id_insumo="#Local.detalle.ID_INSUMO#"
                    nu_Cantidad="#Local.detalle.NU_CANTIDADREGISTRO#"
                    nu_ExistenciaAnterior="#Local.nu_ExistenciaAnterior#"
                    id_TipoMovimiento="#Local.movimiento.id_TipoMovimiento#"
                    returnvariable="Local.nd_MovimientoDetalle">

                <!--- Si el traspaso es por una consignacion, Actualizamos el Precio Promedio --->
                <cfif Local.movimiento.id_TipoMovimiento EQ 61>

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="upR_PrecioPromedio_AlmacenesExistencias"
                          id_empresa="#session.ID_EMPRESA#"
                          id_sucursal="#local.detalle.ID_SUCURSALPROVENIENTE#"
                          id_Almacen="#local.detalle.ID_ALMACENPROVENIENTE#"
                          id_insumo="#local.detalle.ID_INSUMO#"
                        returnvariable="Local.rs">

                    <cfset Local.precioUnitarioEntradaExistencia = Local.rs.im_PrecioPromedio>
                    <cfset Local.precioTotalEntradaExistencia = (Local.rs.im_PrecioPromedio NEQ '' ? Local.rs.im_PrecioPromedio : 0) * Local.detalle.NU_CANTIDADREGISTRO>
                </cfif>

                <!--- tenemos series?? --->
                <cfloop array="#Local.detalle.seriesSeleccionadas#" index="Local.serie">
                    <!--- Obtenemos el nextId de InventariosMovimientosDetalleSeries --->
                    <!---- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                              method="getNextID"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#SESSION.ID_SUCURSAL#"
                              id_Almacen="#session.ID_ALMACEN#"
                              id_Movimiento="#Local.movimiento.id_Movimiento#"
                              nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                              returnvariable="Local.nd_InventarioMovimientoDetalleSerie">--->

                    <!--- Agrgamos un nuevo registro --->
                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                              method="agregarinventariomovmientoseries"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#Local.movimiento.id_sucursal#"
                              id_Almacen="#Local.movimiento.id_Almacen#"
                              id_Movimiento="#Local.movimiento.id_Movimiento#"
                              nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                              <!---nd_InventarioMovimientoDetalleSerie="#Local.nd_InventarioMovimientoDetalleSerie#"--->
                              de_SerieInsumo="#Local.serie.de_serieInsumo#"
                              de_etiqueta="#Local.serie.de_etiqueta#">

                              <cfset _datos = structNew()>
                              <cfset _datos.emp = Local.serie.ID_EMPRESA>
                              <cfset _datos.sucAnt =Local.serie.ID_SUCURSAL>
                              <cfset _datos.almAnt =Local.serie.ID_ALMACEN>
                              <cfset _datos.serie = Local.serie.DE_SERIEINSUMO>
                              <cfset _datos.suc = SESSION.ID_SUCURSAL>
                              <cfset _datos.alm = session.ID_ALMACEN>
                              <cfset _datos.mov = Local.movimiento.ID_MOVIMIENTO>
                              <cfset _Datos.movdet = Local.nd_MovimientoDetalle>


                    <!--- Modificacion :Victor
                          Descripcion: Se procede a modificar la tabla ActivosFijos para ponerlo en el nuevo lugar despues
                          de realizar el traspaso --->
                        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                  method="upU_ActivosFijos"
                                  id_EmpresaAnt="#Local.serie.ID_EMPRESA#"
                                  id_SucursalAnt="#Local.serie.ID_SUCURSAL#"
                                  id_AlmacenAnt="#Local.serie.ID_ALMACEN#"
                                  Serie="#Local.serie.DE_SERIEINSUMO#"
                                  id_Sucursal="#Local.movimiento.id_Sucursal#"
                                  id_Almacen="#Local.movimiento.id_Almacen#"
                                  id_MovimientoEntrada="#Local.movimiento.ID_MOVIMIENTO#"
                                  nd_MovimientoDetalleEntrada="#Local.nd_MovimientoDetalle#"
                                 >


                  <!--- Se lee el acrivo fijo por su serie y empresa --->
                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                              method="upR_ActivoFijo"
                              id_empresa="#Local.serie.ID_EMPRESA#"
                              de_SerieActivo="#Local.serie.DE_SERIEINSUMO#"
                              returnvariable="Activo"
                              >


                    <!--- Se agrega el detalle de Activos Fijos --->
                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                          method="upC_ActivosFijosDetalleEntradas"
                          id_Empresa="#Local.serie.ID_EMPRESA#"
                          id_ActivoFijo="#Activo.id_ActivoFijo#"
                          id_Sucursal="#Local.movimiento.id_Sucursal#"
                          id_Almacen="#Local.movimiento.id_Almacen#"
                          id_Movimiento="#Local.movimiento.ID_MOVIMIENTO#"
                          nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                          />


                    <!--- Obtenemos el nextId para la tabla AlmacenesExistenciasSeriesInsumos --->
                    <!---<cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                              method="getNextID"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#SESSION.ID_SUCURSAL#"
                              id_Almacen="#session.ID_ALMACEN#"
                              id_Insumo="#Local.detalle.id_insumo#"
                              returnvariable="Local.id_AlmacenExistenciaSerieInsumo">--->

                    <!--- Agregamo el nuevo registro --->
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                              method="AgregarSeriesInsumos"
                              id_empresa="#session.ID_EMPRESA#"
                              id_sucursal="#Local.movimiento.id_sucursal#"
                              id_Almacen="#Local.movimiento.id_Almacen#"
                              id_insumo="#Local.detalle.id_insumo#"
                              <!---id_AlmacenExistenciaSerieInsumo="#Local.id_AlmacenExistenciaSerieInsumo#"--->
                              de_SerieInsumo="#Local.serie.de_serieInsumo#">
                </cfloop>
            </cfif>
        </cfloop>


        <!--- Actualizamos el estatus surtido del TRASPASO --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                  method="updateEstatusSurtido"
                  id_empresa="#session.ID_EMPRESA#"
                  id_inventarioTraspaso="#Arguments.ID_INVENTARIOTRASPASO#">

        <!--- Actualizamos el idEstatusSurtidoTraspaso del MOVIMIENTO --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="setEstatusSurtidoTraspaso"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#arguments.ID_SUCURSALORIGEN#"
                  id_almacen="#arguments.ID_ALMACENORIGEN#"
                  id_movimiento="#arguments.ID_MOVIMIENTO#">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                  method="checkIfComplete"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursalDestino="#Local.movimiento.id_Sucursal#"
                  id_AlmacenDestino="#Local.movimiento.id_Almacen#"
                  id_inventarioTraspaso="#Arguments.ID_INVENTARIOTRASPASO#"
                  returnvariable="Local.traspasoComplete">

        <!--- Si solo hay un registro en el query y la columna es 1, indica que todos los insumos
            estan surtidos, por lo tanto se actualiza la fecha de entrada de la solicitud de traspaso --->
        <cfif Local.traspasoComplete.recordCount EQ 1 AND Local.traspasoComplete.sn_recibida EQ 1>
            <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                      method="updateDateEntrada"
                      id_empresa="#session.ID_EMPRESA#"
                      id_inventarioTraspaso="#Arguments.id_inventarioTraspaso#"
                      fh_entrada="#dateFormat(now(),'yyyymmdd')#">
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                  method="AplicaMetodoAEntradaProvenienteDeSalida"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#Local.movimiento.id_sucursal#"
                  id_Almacen="#Local.movimiento.id_Almacen#"
                  id_Movimiento="#Local.movimiento.id_Movimiento#">

        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                  method="ActualizarPorEntradaAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  id_sucursal="#Local.movimiento.id_sucursal#"
                  id_Almacen="#Local.movimiento.id_Almacen#"
                  id_Movimiento="#Local.movimiento.id_Movimiento#"
                  id_tipoMovimiento="#Local.movimiento.id_TipoMovimiento#">

        <cfset variables.RBR.setData(Local.movimiento)>
        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez
        26/10/2015
        Guarda la entrada por devolucion --->
    <cffunction name="GuardarEntradaPorDevolucion" access="public" returntype="Any">
        <cfargument name="Insumos"    type="array" required="false"/>
        <cfargument name="Series"       type="array" required="false"/>
        <cfargument name="Movimientos"      type="array" required="false"/>

            <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>
        <!--- se crea la cantidad de movimientos de acuerdo a la cantidad de almacenes seleccionados --->
        <cfloop array="#Movimientos#" index="mov">

                <cfset DatosMovimiento = structNew()>
                <cfset IM_TOTAL = 0>

        <!--- <cfset local.im_precunitario = local.fnc.unformatNumber(local.detalle.im_PrecioUnitario)> --->
        <cfloop array="#Insumos#" index="opcion">
          <!--- Vamos hacer solo movimientos por el almacen --->
          <cfif #opcion.ALMACEN.ID_ALMACEN# EQ #mov#>
                    <cfset DatosMovimiento.ID_EMPRESA = opcion.ID_EMPRESA >
                    <cfset DatosMovimiento.ID_SUCURSAL = opcion.ALMACEN.ID_SUCURSAL >
                    <cfset DatosMovimiento.ID_ALMACEN = opcion.ALMACEN.ID_ALMACEN >
                    <cfset DatosMovimiento.ID_TIPOMOVIMIENTO = 2 >
                    <cfif #opcion.IM_PRECIOULTIMO# EQ '$0.00'>
                        <cfset DatosMovimiento.IM_PRECIOULTIMO = 0 >
                        <cfelse>
                        <cfset DatosMovimiento.IM_PRECIOULTIMO = local.fnc.unformatNumber(opcion.IM_PRECIOULTIMO) >
                    </cfif>

                    <cfset DatosMovimiento.CANTIDAD_REGRESA = opcion.CANTIDAD_REGRESA>
                    <cfset DatosMovimiento.ID_REQUISICION = opcion.ID_REQUISICION>

          <cfif isNull("DatosMovimiento.IM_PRECIOULTIMO")>
                        <cfset IM_TOTAL = 0>
          <cfelse>
            <cfset IM_TOTAL = IM_TOTAL + (DatosMovimiento.IM_PRECIOULTIMO * DatosMovimiento.CANTIDAD_REGRESA)>
                    </cfif>


                    <!--- Antes de actualizar almacenesExistencia, se verifica si existen datos en ese almacen  --->
                    <!--- Obtenemos el nu de existencia para el registro --->
                    <!---
                    Esta parte lo actualiza un TRIGGER
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                              method="getNu_existencia"
                              id_empresa="#DatosMovimiento.ID_EMPRESA#"
                              id_sucursal="#DatosMovimiento.ID_SUCURSAL#"
                              id_almacen="#DatosMovimiento.ID_ALMACEN#"
                              id_insumo="#opcion.ID_INSUMO#"
                              returnvariable="Local.en_Existencia"/>


                     Verificamos si hay algun registro para este insumo
                    <cfif #Local.en_Existencia.recordCount# EQ 0>
                         Si no trajo ningun registro, no existe el almacen, por tanto se agrega
                        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                  method="RSAgregar"
                                  id_empresa="#DatosMovimiento.ID_EMPRESA#"
                                  id_sucursal="#DatosMovimiento.ID_SUCURSAL#"
                                  id_almacen="#DatosMovimiento.ID_ALMACEN#"
                                  id_insumo="#opcion.ID_INSUMO#"
                                  nu_existencia="#opcion.CANTIDAD_REGRESA#"
                                  sn_activo="1"/>

                        <cfelse>
                             Si existe el registro entonces se suma
                            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                                      method="AgregarExistencia"
                                      id_empresa="#DatosMovimiento.ID_EMPRESA#"
                                      id_sucursal="#DatosMovimiento.ID_SUCURSAL#"
                                      id_almacen="#DatosMovimiento.ID_ALMACEN#"
                                      id_insumo="#opcion.ID_INSUMO#"
                                      nu_cantidad="#opcion.CANTIDAD_REGRESA#"/>
                    </cfif> --->
                </cfif>
            </cfloop>
            <cfset DatosMovimiento.IM_TOTALMN = IM_TOTAL>
            <cfset DatosMovimiento.id_UsuarioRegistroMovimiento = #session.ID_USUARIO#>

                    <!--- Se inserta el movimiento --->
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                      method="AgregarMovimiento"
                      argumentcollection="#DatosMovimiento#"
                      returnvariable="Local.movimiento.id_Movimiento">

                        <!--- Procedemos a insertar el detalle del movimiento --->
                    <cfloop array="#Insumos#" index="i">
                        <cfif #mov# EQ #i.ALMACEN.ID_ALMACEN#>

                                    <cfset DatosDet = structNew()>
                                    <cfset DatosDet.id_Empresa = #i.ID_EMPRESA#>
                                    <cfset DatosDet.id_Sucursal = #i.ALMACEN.ID_SUCURSAL#>
                                    <cfset DatosDet.id_Almacen = #i.ALMACEN.ID_ALMACEN#>
                                    <cfset DatosDet.id_Insumo = #i.ID_INSUMO#>
                                    <cfset DatosDet.id_Movimiento = #Local.movimiento.id_Movimiento#>
                                    <cfset DatosDet.nu_Cantidad = #i.CANTIDAD_REGRESA#>
                                    <cfif #i.IM_PRECIOULTIMO# EQ '$0.00'>

                                    <cfelse>
                                        <cfset DatosDet.im_PrecioUnitarioEntrada = #i.IM_PRECIOULTIMO#>
                                    </cfif>

                                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                      method="AgregarInventarioMovDetalle"
                                      argumentcollection="#DatosDet#"
                                      returnvariable="Local.nd_MovimientoDetalle">




                                      <!--- Actualizamos el detalle de donde procede el insumo, para restarle la cantidad
                                            que se regreso al almacen, y actualizar el estatus a 'Surtido Completo con devolucion'
                                            o 'Surtido Parcial con devolucion' --->
                                    <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                                              method="upU_RequisicionesDetalleEntradaSalidaDevolucion"
                                              id_Empresa="#i.ID_EMPRESA#"
                                              id_Requisicion="#i.ID_REQUISICION#"
                                              id_RequisicionDetalle="#i.ID_REQUISICIONDETALLE#"
                                              Cantidad="#i.CANTIDAD_REGRESA#"
                                              >


                                      <!--- Procedemos a ver si tenemos series de ese insumo --->
                                    <!--- tenemos series?? --->
                                    <cfif i.SN_INSUMOSERIADO EQ 'YES'>
                                        <cfloop array="#Series#" index="serie">
                                            <cfif #serie.ID_INSUMO# EQ #i.ID_INSUMO#>
                                            <!--- Agrgamos un nuevo registro en inventariosMovimientoSeries --->
                                                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleSeries')#"
                                                          method="agregarinventariomovmientoseries"
                                                          id_empresa="#serie.ID_EMPRESA#"
                                                          id_sucursal="#serie.ID_SUCURSAL#"
                                                          id_Almacen="#serie.ID_ALMACEN#"
                                                          id_Movimiento="#Local.movimiento.id_Movimiento#"
                                                          nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                                                          de_SerieInsumo="#serie.DE_SERIEINSUMO#">

                                                <!--- Agregamo el nuevo registro  en Almacenes Existencias Series Insumos--->
                                                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                                                          method="AgregarSeriesInsumos"
                                                          id_empresa="#serie.ID_EMPRESA#"
                                                          id_sucursal="#serie.ID_SUCURSAL#"
                                                          id_Almacen="#serie.ID_ALMACEN#"
                                                          id_insumo="#serie.ID_INSUMO#"
                                                          <!---id_AlmacenExistenciaSerieInsumo="#Local.id_AlmacenExistenciaSerieInsumo#"--->
                                                          de_SerieInsumo="#serie.DE_SERIEINSUMO#">

                                                          <!--- Se lee el activo fijo por su serie y empresa --->
                                                            <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                                                      method="upR_ActivoFijo"
                                                                      id_empresa="#serie.ID_EMPRESA#"
                                                                      de_SerieActivo="#serie.DE_SERIEINSUMO#"
                                                                      returnvariable="Activo"
                                                                      >

                                                            <!--- Si retorno algo la lectura del activo, quiere decir que encontro la serie --->
                                                            <cfif Activo.recordCount EQ '0'>
                                                                <cfset Variables.RBR.setError("No se encontro serie dentro de los activos fijos.")>
                                                                <cfreturn variables.RBR>
                                                            </cfif>

                                                            <!--- Se agrega la condicion sn_ActivoFijo = 0, para evitar
                                                            esten poniendo la misma serie siempre. si el sn_activo esta en 0, esta en almacen,
                                                            si esta en 1  se encuentra en uso en sucursal --->
                                                            <cfif Activo.sn_Activo EQ '0'>
                                                                <cfset Variables.RBR.setError("El insumo con esa serie ya se encuentra registrado en almacén.")>
                                                                <cfreturn variables.RBR>
                                                            </cfif>

                                                            <!--- Actualizamos el ActivoFijo, cambio su movimiento y pongo el sn_Activo = 0 --->
                                                                <!--- Si es el mismo almacen, y la misma sucursal se ingresa todo --->
                                                                <cfif #Activo.ID_ALMACENENTRADA# EQ #serie.ID_ALMACEN# AND #Activo.ID_SUCURSALASIGNADO# EQ #serie.ID_SUCURSAL#>
                                                                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                                                          method="upU_ActivosFijos"
                                                                          id_empresaAnt="#Activo.ID_EMPRESA#"
                                                                          id_SucursalAnt="#Activo.ID_SUCURSALASIGNADO#"
                                                                          id_AlmacenAnt="#Activo.ID_ALMACENENTRADA#"
                                                                          Serie="#serie.DE_SERIEINSUMO#"
                                                                          id_Sucursal="#serie.ID_SUCURSAL#"
                                                                          id_Almacen="#serie.ID_ALMACEN#"
                                                                          id_CentroCosto="#Activo.ID_CENTROCOSTO#"
                                                                          id_MovimientoEntrada="#Local.movimiento.id_Movimiento#"
                                                                          nd_MovimientoDetalleEntrada="#Local.nd_MovimientoDetalle#"
                                                                          >
                                                                    <cfelse>
                                                                        <cfif #serie.SN_ALMACENNUEVO# EQ 'YES'>
                                                                                <cfset Variables.RBR.setError("Los insumos solo pueden regresarse a su almacén original, a menos que transfieras a almacenes de usados.")>
                                                                                <!--- <cfset variables.RBR.setData(Arguments.detalles)> --->
                                                                                <cfreturn variables.RBR>

                                                                            <cfelse>
                                                                                <cfif  #Activo.ID_SUCURSALASIGNADO# EQ #serie.ID_SUCURSAL#>
                                                                                    <!--- Si el insumo se regresa a un almacen viejo no se le pasa su centroCosto --->
                                                                                    <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                                                                      method="upU_ActivosFijos"
                                                                                      id_empresaAnt="#Activo.ID_EMPRESA#"
                                                                                      id_SucursalAnt="#Activo.ID_SUCURSALASIGNADO#"
                                                                                      id_AlmacenAnt="#Activo.ID_ALMACENENTRADA#"
                                                                                      Serie="#serie.DE_SERIEINSUMO#"
                                                                                      id_Sucursal="#serie.ID_SUCURSAL#"
                                                                                      id_Almacen="#serie.ID_ALMACEN#"
                                                                                      <!--- id_CentroCosto="#Activo.ID_CENTROCOSTO#" --->
                                                                                      id_MovimientoEntrada="#Local.movimiento.id_Movimiento#"
                                                                                      nd_MovimientoDetalleEntrada="#Local.nd_MovimientoDetalle#"
                                                                                      >
                                                                                <cfelse>
                                                                                    <cfset Variables.RBR.setError("Los insumos solo pueden regresarse a su almacen original, a menos que transfieras a almacenes de usados.")>
                                                                                    <!--- <cfset variables.RBR.setData(Arguments.detalles)> --->
                                                                                    <cfreturn variables.RBR>
                                                                                </cfif>

                                                                        </cfif>
                                                                <!--- Error, solo se puede regresar al almacen que pertenece --->
                                                                </cfif>
                                                                <!--- Se agrega el detalle de la entrada --->
                                                                <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                                                                  method="upC_ActivosFijosDetalleEntradas"
                                                                  id_Empresa="#Activo.id_Empresa#"
                                                                  id_ActivoFijo="#Activo.id_ActivoFijo#"
                                                                  id_Sucursal="#serie.ID_SUCURSAL#"
                                                                  id_Almacen="#serie.ID_ALMACEN#"
                                                                  id_Movimiento="#Local.movimiento.id_Movimiento#"
                                                                  nd_MovimientoDetalle="#Local.nd_MovimientoDetalle#"
                                                                  />

                                                            <!--- El centro de costo del activo fijo se pone sn_Activo = 0 --->
                                                                <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                                                                      method="upU_CentroCostoSet_sn_Activo"
                                                                      id_Empresa="#Activo.ID_EMPRESA#"
                                                                      id_Sucursal="#Activo.ID_SUCURSALASIGNADO#"
                                                                      id_CentroCosto="#Activo.ID_CENTROCOSTO#"
                                                                      sn_Activo="0"
                                                                      >

                                            </cfif>

                                        </cfloop>
                                    </cfif> <!--- if InsumosSeriados --->


                        </cfif><!--- if #mov# EQ #i.ALMACEN.ID_ALMACEN# --->
                    </cfloop>


                        <!--- Se aplica el metodo del flavio AplicaMetodoAEntradaProvenienteDeSalida  --->
                        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                                  method="AplicaMetodoAEntradaProvenienteDeSalida"
                                  id_empresa="#Insumos[1].ALMACEN.ID_EMPRESA#"
                                  id_sucursal="#Insumos[1].ALMACEN.ID_SUCURSAL#"
                                  id_almacen="#mov#"
                                  id_movimiento="#Local.movimiento.id_Movimiento#"
                                  id_tipoMovimiento="2"/>


                                <!--- Finalmente hacemos los calculos correspondientes para esta tabla usando la funcion de Flavio --->
                        <cfinvoke component="#Application.RF.getPath('dao','CosteoInventarios')#"
                              method="ActualizarPorEntradaAlmacen"
                              id_empresa="#Insumos[1].ALMACEN.ID_EMPRESA#"
                              id_sucursal="#Insumos[1].ALMACEN.ID_SUCURSAL#"
                              id_almacen="#mov#"
                              id_movimiento="#Local.movimiento.id_Movimiento#"
                              id_tipoMovimiento="2"/>



        </cfloop><!--- Loop de los Movimientos --->





        <cfreturn variables.RBR>
    </cffunction>


    <!--- Victor Sanchez
    Genera pdf de las existencias y movimientos de los insumos
     --->
    <cffunction name="generaPDF_MovimientoYExistencia"    access="public"     returntype="Any">
        <cfargument name='sucursal' type='string'  required='true'>
        <cfargument name='almacen'  type='string'  required='true'>
        <cfargument name='insumo'   type='struct'  required='false'>
        <cfargument name='fh_inicio'    type='string'  required='true'>
        <cfargument name='fh_fin'   type='string'  required='true'>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="true"/>
        <cfargument name="nb_SubFamiliaInsumo"    type="string" required="true"/>
        <cfargument name='datos'    type='array'  required='true'>



        <cfif isDefined("insumo")>
            <cfset arguments.nb_insumo = insumo.NB_NOMBREINSUMO>
        <cfelse>
            <cfset arguments.nb_insumo = 'Todos'>
        </cfif>


        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteMovimientosYExistencias#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/ReporteMovimientosYExistencias.html">
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

    <!--- Victor Sanchez
        15/12/2015
        genera excel de movimientos y existencias
     --->
    <cffunction name="generaExcel_MovimientoYExistencia"    access="public"     returntype="Any">
        <cfargument name='sucursal' type='string'  required='true'>
        <cfargument name='almacen'  type='string'  required='true'>
        <cfargument name='insumo'   type='struct'  required='false'>
        <cfargument name='fh_inicio'    type='string'  required='true'>
        <cfargument name='fh_fin'   type='string'  required='true'>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="true"/>
        <cfargument name="nb_SubFamiliaInsumo"    type="string" required="true"/>
        <cfargument name='datos'    type='array'  required='true'>

        <cfif isDefined("insumo")>
            <cfset arguments.nb_insumo = insumo.NB_NOMBREINSUMO>
        <cfelse>
            <cfset arguments.nb_insumo = 'Todos'>
        </cfif>

            <cfset local.DatosReporte = structNew()>

                <cfset var Local.infoReport={
                    de_directorio="Reportes",
                    nb_archivo="ReporteMovimientosYExistencias#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
                }>
                <cfimport taglib="/lib/tags/poi/" prefix="poi" />

                <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
                    <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
                </cfif>

                <poi:document
                    name="REQUEST.ExcelData"
                    file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                    style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">


                    <poi:classes>
                        <poi:class
                            name="title"
                            style="font-family: Arial ; color: black ; font-size: 16pt ; text-align: left; font-weight: bold;"
                            />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                        <poi:class
                            name="fondo"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; "
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-bottom:2px; border-left:2px; border-rigth:2px;"
                        />
                        <poi:class
                            name="header"
                            style="font-family: Arial ; color: sky-blue ; font-size: 12pt; font-weight: bold;"
                            />
                    </poi:classes>

                    <!--- Define Sheets. --->
                    <poi:sheets>
                        <poi:sheet
                            name="Reporte"
                            freezerow="9"
                            orientation="landscape"
                            zoom="80%">

                            <!--- Define global column styles. --->
                            <poi:columns>
                                <poi:column style="width: 50px ;"/>
                                <poi:column style="width: 160px ;"/>
                                <poi:column style="width: 130px ;"/>
                                <poi:column style="width: 130px ;" />
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 130px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 160px ;"/>
                            </poi:columns>

                            <poi:row class=''>
                            </poi:row>

                            <!--- Title row. --->
                            <poi:row>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value="Tarjeta de Almacén" colspan="4"  class="title"/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value="Fecha de impresión:" class="title" style="text-align:right;font-size:12pt;"/>
                                <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#"  style="text-align: left;"/>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>


                            <poi:row class="" style="font-size:12pt;">
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='Sucursal:' class="negrita"/>
                                <poi:cell value=' #sucursal#'/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='Almacén:' class="negrita"/>
                                <poi:cell value='#almacen#'/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                            </poi:row>

                            <poi:row class="" style="font-size:12pt;">
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='Familia Insumo:' class="negrita"/>
                                <poi:cell value='#nb_FamiliaInsumo#'/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='SubFamilia Insumo:' class="negrita"/>
                                <poi:cell value='#nb_SubFamiliaInsumo#'/>
                            </poi:row>

                            <poi:row class="" style="font-size:12pt;">
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='Insumo:' class="negrita"/>
                                <poi:cell value='#nb_insumo#' />

                            </poi:row>

                            <poi:row class="" style="font-size:12pt;">
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value='Fecha Inicio:' class="negrita" />
                                <poi:cell value='#fh_inicio#'/>
                                <poi:cell value=""/>
                                <poi:cell value='Fecha Fin:' class="negrita"/>
                                <poi:cell value='#fh_fin#'/>

                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                                <poi:cell value=""  class="fondo"/>
                                <poi:cell value="Entradas"   class="fondo"/>
                                <poi:cell value=""      class="fondo"/>
                                <poi:cell value=""/>
                                <poi:cell value=" "     class="fondo"/>
                                <poi:cell value="Salidas "          class="fondo"/>
                                <poi:cell value=" "         class="fondo"/>
                                <poi:cell value=" "         class="fondo"/>
                                <poi:cell value=""/>
                                <poi:cell value=""/>
                            </poi:row>
                            <!--- Header row. --->
                            <poi:row >
                                <poi:cell value=''/>
                                <poi:cell value="Insumo"      class="header fondo borders"/>
                                <poi:cell value="Unidad Medida"     class="header fondo borders"/>
                                <poi:cell value="Cantidad Inicial"              class="header fondo borders"/>
                                <poi:cell value="Compra"  class="header fondo borders"/>
                                <poi:cell value="Traspaso"   class="header fondo borders"/>
                                <poi:cell value="Ajuste"    class="header fondo borders"/>
                                <poi:cell value="Total Entradas"   class="header fondo borders"/>
                                <poi:cell value="Consumo"       class="header fondo borders"/>
                                <poi:cell value="Traspaso"          class="header fondo borders"/>
                                <poi:cell value="Devolución"           class="header fondo borders"/>
                                <poi:cell value="Ajuste"        class="header fondo borders"/>
                                <poi:cell value="Total Salida"          class="header fondo borders"/>
                                <poi:cell value="Existencia Teórica"           class="header fondo borders"/>
                            </poi:row>

                            <!--- Output the people. --->
                            <cfloop from="1" to="#arrayLen(arguments.datos)#" index="local.i">
                                <poi:row>
                                    <poi:cell value="" />
                                    <poi:cell value="#arguments.datos[local.i].NB_NOMBREINSUMO#" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NB_UNIDADMEDIDA#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_CANTIDADINICIAL#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_ENTRADASPORCOMPRA#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_ENTRADASTRASPASO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_ENTRADASAJUSTE#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].TOTAL_ENTRADAS#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_SALIDASPORCONSUMO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_SALIDATRASPASO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_SALIDADEVOLUCION#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].NU_SALIDAAJUSTE#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].TOTAL_SALIDAS#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#arguments.datos[local.i].EXISTENCIA_TEORICA#" style="text-align:center" class="Contenido borders"/>
                                </poi:row>
                            </cfloop>

                        </poi:sheet>
                    </poi:sheets>

                </poi:document>

                <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                          method="addImage"
                          nb_excelFile="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                          src_image="#SERVER.ar_ImagenReporteBinary[session.ID_EMPRESA]#"
                          nb_sheet="Reporte"
                          nu_startRow="4"
                          nu_startCol="2"
                          nu_colWidth="1.5">


        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>


    <cffunction name="GenerarRegresoPDF"    access="public"     returntype="Any">
        <cfargument name='Movimientos'          type='array'  required='true'>
        <cfargument name='Insumos'  type='array'  required='true'>
        <cfargument name='Series'               type='array'  required='true'>

                <cfset NB_Sucursal = "#Insumos[1].ALMACEN.NB_SUCURSAL#" />
                <cfset EmpleadoRegreso ="#session.NB_EMPLEADOCOMPLETO#" />

        <cfset datosPorAlmacen =  arrayNew(1)>

        <!--- loop para los almacenes que van dirigidos --->
        <cfloop array="#arguments.Movimientos#" index="mov">
                <!--- Se lee el almacen para saber quien es el empleado responsable --->
                <cfset datos =  arrayNew(1)>
                <cfset local.arrayinsumos =  arrayNew(1)>
                <cfset local.DatosReporte = structNew()>
                    <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                                  method="Listar"
                                  id_empresa="#Insumos[1].ALMACEN.ID_EMPRESA#"
                                  id_sucursal="#Insumos[1].ALMACEN.ID_SUCURSAL#"
                                  id_almacen="#mov#"
                                returnvariable="Alm"
                                 />

                <cfset id_EmpleadoResponsable = Alm.ID_EMPLEADORESPONSABLE />
                    <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                                  method="Listar"
                                  id_Empleado="#id_EmpleadoResponsable#"
                                returnvariable="EmpleadoResponsable"
                                 />

            <!--- Todos los insumos --->
            <cfloop  array="#arguments.insumos#" index="local.i">

                <cfif local.i.ALMACEN.ID_ALMACEN EQ mov>

                    <cfif local.i.SN_INSUMOSERIADO EQ 'YES'>
                        <!--- loop para los insumos seriados --->
                        <cfloop array="#Series#" index="serie">
                            <cfif #local.i.ID_INSUMO# EQ #serie.ID_INSUMO#>
                                    <cfset  datos = {
                                        ID_INSUMO = local.i.ID_INSUMO,
                                        NB_NOMBREINSUMO = serie.NB_NOMBREINSUMO,
                                        NU_CANTIDAD = 1,
                                        NB_ALMACEN = local.i.ALMACEN.NB_ALMACEN,
                                        NB_SUCURSAL = local.i.ALMACEN.NB_SUCURSAL,
                                        DE_SERIEINSUMO = serie.DE_SERIEINSUMO
                                    }>

                                <cfset arrayAppend(local.arrayinsumos, datos)>
                            </cfif>
                        </cfloop>
                    </cfif>

                    <cfif local.i.SN_INSUMOSERIADO EQ 'NO'>

                        <cfset  datos = {
                            ID_INSUMO = local.i.ID_INSUMO,
                            NB_NOMBREINSUMO = local.i.NB_NOMBREINSUMO,
                            NU_CANTIDAD = local.i.NU_CANTIDAD,
                            NB_ALMACEN = local.i.ALMACEN.NB_ALMACEN,
                            NB_SUCURSAL = local.i.ALMACEN.NB_SUCURSAL,
                            DE_SERIEINSUMO = ''
                        }>


                        <cfset arrayAppend(local.arrayinsumos, datos)>
                    </cfif>

                </cfif>
            </cfloop>

            <cfset DatosReporte.nb_sucursal = NB_Sucursal>
            <cfset DatosReporte.nb_almacen = Alm.NB_ALMACEN>
            <cfset DatosReporte.EmpleadoRegreso = EmpleadoRegreso>
            <cfset DatosReporte.EmpleadoResponsable = EmpleadoResponsable.NB_EMPLEADO>
            <cfset DatosReporte.datos = local.arrayinsumos>
            <cfset arrayAppend(datosPorAlmacen, DatosReporte)>

        </cfloop>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="DocuentodeEntrega#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfset local.DatosReporte.fh_fechaentrega = #dateFormat(now(),'dd/MM/yyyy')#>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/DocumentoRegresoAlmacen.html">
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

    <!--- Jesus Reyes --->
    <cffunction name="repSalidasPorAlmacen" access="public" returntype="Any">
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <cfargument name='page'                 type='string'  required='false'>
        <cfargument name='pageSize'             type='string'  required='false'>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="repSalidasPorAlmacenPaginado"
                  id_empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="repSalidasPorAlmacenPDF"    access="public"     returntype="Any">
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='nb_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='nb_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='nb_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='nb_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <cfargument name='fh_inicio2'   type='string'  required='true'>
        <cfargument name='fh_fin2'  type='string'  required='true'>


        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="repSalidasPorAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="datos">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/ReporteSalidasPorAlmacen.html">
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

    <cffunction name="repSalidasPorAlmacenExcel"    access="public"     returntype="Any">
        <cfargument name='id_sucursal'          type='string'  required='false'>
        <cfargument name='nb_sucursal'          type='string'  required='false'>
        <cfargument name='id_almacen'           type='string'  required='false'>
        <cfargument name='nb_almacen'           type='string'  required='false'>
        <cfargument name='id_insumo'            type='string'  required='false'>
        <cfargument name='nb_insumo'            type='string'  required='false'>
        <cfargument name='id_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='nb_tipoMovimiento'    type='string'  required='false'>
        <cfargument name='fh_inicio'            type='string'  required='false'>
        <cfargument name='fh_fin'               type='string'  required='false'>
        <cfargument name='fh_inicio2'   type='string'  required='true'>
        <cfargument name='fh_fin2'  type='string'  required='true'>


        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="repSalidasPorAlmacen"
                  id_empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="datos">

            <cfset local.DatosReporte = structNew()>

                <cfset var Local.infoReport={
                    de_directorio="Reportes",
                    nb_archivo="repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
                }>
                <cfimport taglib="/lib/tags/poi/" prefix="poi" />

                <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
                    <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
                </cfif>

                <poi:document
                    name="REQUEST.ExcelData"
                    file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                    style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">


                    <poi:classes>
                        <poi:class
                            name="title"
                            style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                            />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                        <poi:class
                            name="fondo"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; "
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-bottom:2px; border-left:2px; border-rigth:2px;"
                        />
                        <poi:class
                            name="header"
                            style="font-family: Arial ; color: sky-blue ; font-size: 12pt; font-weight: bold;"
                            />
                    </poi:classes>

                    <!--- Define Sheets. --->
                    <poi:sheets>
                        <poi:sheet
                            name="Reporte"
                            freezerow="15"
                            orientation="landscape"
                            zoom="80%">

                            <!--- Define global column styles. --->
                            <poi:columns>
                                <poi:column style="width: 150px ;"/>
                                <poi:column style="width: 260px ;"/>
                                <poi:column style="width: 180px ;"/>
                                <poi:column style="width: 230px ;" />
                                <poi:column style="width: 150px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 250px ;"/>
                                <poi:column style="width: 180px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 100px ;"/>
                                <poi:column style="width: 160px ;"/>
                            </poi:columns>

                            <poi:row class=''>
                            </poi:row>

                            <!--- Title row. --->
                            <poi:row>
                                <poi:cell value=''/>
                                <poi:cell value="Reporte Salidas Por Almacén" colspan="4"  class="title"/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Sucursal:' class="negrita"/>
                                <poi:cell value=' #arguments.nb_sucursal#'/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Almacén:' class="negrita"/>
                                <poi:cell value='#arguments.nb_almacen#'/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Insumo:' class="negrita"/>
                                <poi:cell value='#arguments.nb_insumo#' />
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Tipo de Movimiento:' class="negrita"/>
                                <poi:cell value='#arguments.nb_tipoMovimiento#' />
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Fecha Inicio:' class="negrita" />
                                <poi:cell value='#arguments.fh_inicio2#'/>
                                <poi:cell value='Fecha Fin:' class="negrita"/>
                                <poi:cell value='#arguments.fh_fin2#'/>
                            </poi:row>

                            <poi:row class=''>
                            </poi:row>

                            <!--- Header row. --->
                            <poi:row >
                                <poi:cell value="Folio Movimiento"          class="header fondo borders"/>
                                <poi:cell value="Tipo Movimiento"           class="header fondo borders"/>
                                <poi:cell value="Fecha Movimiento"          class="header fondo borders"/>
                                <poi:cell value="Insumo"                    class="header fondo borders"/>
                                <poi:cell value="Serie"                     class="header fondo borders"/>
                                <poi:cell value="Cantidad"                  class="header fondo borders"/>
                                <poi:cell value="Precio Promedio Unitario"  class="header fondo borders"/>
                                <poi:cell value="Importe Por Insumo"        class="header fondo borders"/>
                            </poi:row>

                            <!--- Output the people. --->
                            <cfloop query="datos">
                                <poi:row>
                                    <poi:cell value="#datos.FL_MOVIMIENTO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#datos.NB_TIPOMOVIMIENTO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#datos.FH_MOVIMIENTO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#datos.NB_NOMBREINSUMO#" class="Contenido borders"/>
                                    <poi:cell value="#datos.DE_SERIEINSUMO#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#datos.NU_CANTIDAD#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#LSCurrencyFormat(datos.IM_PRECIOPROMEDIO)#" style="text-align:center" class="Contenido borders"/>
                                    <poi:cell value="#LSCurrencyFormat(datos.IM_PRECIOINSUMO)#" style="text-align:center" class="Contenido borders"/>
                                </poi:row>
                            </cfloop>

                        </poi:sheet>
                    </poi:sheets>

                </poi:document>

                <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                          method="addImage"
                          nb_excelFile="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                          src_image="#SERVER.ar_ImagenReporteBinary[session.ID_EMPRESA]#"
                          nb_sheet="Reporte"
                          nu_startRow="4"
                          nu_startCol="2"
                          nu_colWidth="1">

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>


    <cffunction name="impresionDeMovimientos"    access="public"     returntype="Any">
        <cfargument name='id_Movimiento'        type='string'  required='false'>
        <cfargument name='id_Empresa'        type='string'  required='false'>
        <cfargument name='id_Sucursal'        type='string'  required='false'>
        <cfargument name='id_Almacen'        type='string'  required='false'>

        <cfif not isDefined('arguments.id_Empresa')>
            <cfset arguments.id_Empresa = #session.ID_EMPRESA#>
        </cfif>

        <cfif not isDefined('arguments.id_Sucursal')>
            <cfset arguments.id_Sucursal = #SESSION.ID_SUCURSAL#>
        </cfif>

        <cfif not isDefined('arguments.id_Almacen')>
            <cfset arguments.id_Almacen = #session.ID_ALMACEN#>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosEncabezado"
                  argumentcollection="#arguments#"
                  returnvariable="datos">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="detalle">

        <cfif detalle.recordCount EQ 0>
            <cfset variables.RBR.setError('No se encontro el archivo solicitado.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="repEntradaPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientosInventarioTemplate.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#DocumentodeEntrega#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset Local.infoReport.ar_archivoPDF=#DocumentodeEntrega# >
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>


    <cffunction name="impresionSalidasConsumo"    access="public"     returntype="Any">
        <cfargument name='id_Movimiento'        type='string'  required='false'>

        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>
        <cfset arguments.id_Sucursal = #SESSION.ID_SUCURSAL#>
        <cfset arguments.id_Almacen = #session.ID_ALMACEN#>


        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosEncabezado"
                  argumentcollection="#arguments#"
                  returnvariable="datos">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="detalle">
        
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDivision"
                  argumentcollection="#arguments#"
                  returnvariable="division">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientosInventarioSalidasConsumo.html">
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

    <cffunction name="impresionSalidasConsumoBandejaEntrada"    access="public"     returntype="Any">
        <cfargument name='id_Movimiento'        type='string'  required='false'>
        <cfargument name='id_Empresa'        type='string'  required='false'>
        <cfargument name='id_Sucursal'        type='string'  required='false'>
        <cfargument name='id_Almacen'        type='string'  required='false'>


        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosEncabezado"
                  argumentcollection="#arguments#"
                  returnvariable="datos">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="detalle">
        
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosDivision"
                  argumentcollection="#arguments#"
                  returnvariable="division">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientosInventarioSalidasConsumo.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#DocumentodeEntrega#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset  Local.infoReport.ar_archivoPDF=#DocumentodeEntrega# >
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>

<cffunction name="impresionDeMovimientosServicio"    access="public"     returntype="Any">
        <cfargument name='id_Empresa'       type='string'  required='false'>
        <cfargument name='id_Sucursal'      type='string'  required='false'>
        <cfargument name='id_Movimiento'    type='string'  required='false'>


        <cfset arguments.id_Almacen = #session.ID_ALMACEN#>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="impresionDeMovimientosServicio"
                  argumentcollection="#arguments#"
                  returnvariable="detalle">


                    <cfset datos.id_movimiento              = #detalle.ID_MOVIMIENTO#>
                    <cfset datos.fh_movimiento              = #detalle.FH_MOVIMIENTO#>
                    <cfset datos.nb_empresa                 = #detalle.NB_EMPRESA#>
                    <cfset datos.nb_Sucursal                = #detalle.NB_SUCURSAL#>
                    <cfset datos.id_OrdenDeCompra           = #detalle.ID_ORDENDECOMPRA#>
                    <cfset datos.fh_RegistroOrdenCompra     = #detalle.FH_REGISTROORDENCOMPRA#>
                    <cfset datos.de_usuarioSolicitoOC       = #detalle.DE_USUARIOSOLICITOOC#>
                    <cfset datos.de_usuarioRecibio          = #detalle.DE_USUARIORECIBIO#>
                    <cfset datos.nb_Estatus                 = #detalle.NB_ESTATUS#>
                    <cfset datos.nu_Siniestro               = #detalle.NU_SINIESTRO#>
                    <cfset datos.id_ClasificadoRequisicion  = #detalle.ID_CLASIFICADOREQUISICION#>
                    <cfset datos.de_Comentarios             = #detalle.de_Comentarios#>



        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="repSalidasPorAlmacen#dateFormat(now(),'dd-mm-yyyy')#"
        }>


        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientosInventarioServicio.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#DocumentodeEntrega#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset Local.infoReport.ar_archivoPDF=#DocumentodeEntrega# >
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>
    <!--- funcion que devuelve los movimientos de entrada de servicio --->
    <cffunction name="GastosMovimientosContable" access="public" returntype="Any">
        <cfargument name="fh_inicioMovimiento"      type="string" required="false"/>
        <cfargument name="fh_finMovimiento"         type="string" required="false"/>
        <cfargument name="id_proveedor"             type="string" required="false"/>
        <cfargument name="id_sucursal"              type="string" required="false"/>
        <cfargument name="page"                     type="string" required="true"/>
        <cfargument name="pageSize"                 type="string" required="true"/>
        <cfargument name = "id_FolioMov"                   type="string"  required="false">
        <cfargument name = "id_FolioFac"                   type="string"  required="false">
        <cfargument name = "id_FolioOC"                    type="string"  required="false">
        <cfargument name = "id_Moneda"                     type="numeric"  required="false">


        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = arguments.id_Sucursal>
        <!--- <cfset arguments.id_Almacen = session.ID_ALMACEN> --->
        <cfset arguments.id_movimiento = 12>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="GastosMovimientosContable"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que trae el detalle de un movimiento de entrada de servicio --->
    <cffunction name="GastosMovimientosdetalleContable" access="public" returntype="Any">
        <cfargument name="id_movimiento"            type="numeric" required="true"/>
        <cfargument name="id_sucursal"              type="numeric" required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="GastosMovimientosdetalleContable"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfif Local.rs.id_Cuenta != '' || Local.rs.id_SCuenta != '' || Local.rs.id_SSCuenta != '' || Local.rs.id_SSSCuenta != ''>
            <cfif Local.rs.id_Cuenta == ''>
                <cfset Local.rs.id_Cuenta = '0000'>
            </cfif>
            <cfif Local.rs.id_SCuenta == ''>
                <cfset Local.rs.id_SCuenta = '0000'>
            </cfif>
            <cfif Local.rs.id_SSCuenta == ''>
                <cfset Local.rs.id_SSCuenta = '0000'>
            </cfif>
            <cfif Local.rs.id_SSSCuenta == ''>
                <cfset Local.rs.id_SSSCuenta = '0000'>
            </cfif>
        </cfif>

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarGeneral" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false"/>
        <cfargument name="id_Sucursal"          type="numeric" required="false"/>
        <cfargument name="id_Almacen"           type="numeric" required="false"/>

        <cfargument name="fh_Inicio"            type="string"   required="false"/>
        <cfargument name="fh_Fin"               type="string"   required="false"/>
        <cfargument name="fl_Movimiento"        type="string"   required="false"/>
        <cfargument name="id_TipoMovimiento"    type="numeric"  required="false"/>
        <cfargument name="nb_Insumo"            type="string"   required="false"/>
        <cfargument name="id_Estatus"           type="numeric"  required="false"/>
        <cfargument name="nu_FolioMovimiento"   type="string"   required="false"/>

        <cfif NOT isDefined("Arguments.id_Empresa")>
            <cfset arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>
        <cfif NOT isDefined("Arguments.id_Sucursal")>
            <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        </cfif>
        <cfif NOT isDefined("Arguments.id_Almacen")>
            <cfset arguments.id_Almacen = session.ID_ALMACEN>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="listarGeneral"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!---
        AUTOR: FLORENTINO
    --->
    <cffunction name="CancelarMovimiento" access="public" returntype="Any">
        <cfargument name="id_movimiento"        type="numeric" required="true"/>
        <cfargument name="de_observaciones"     type="string" required="true"/>

        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen  = session.ID_ALMACEN>

        <!--- Se valida, si el movimiento que se intenta cancelar se encuentra dentro de un periodo de cierre --->
        <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="upR_sn_DentroDeUnCierre"
                  argumentcollection="#arguments#"
                  returnvariable="sn">

        <cfif #sn.sn_DentroDeUnCierre# EQ '1'>
            <!--- Se manda mensaje de alerta --->
                <cfset Variables.RBR.setError("No es posible cancelar el movimiento por que ya fue considerado en un cierre de inventario.")>
                <cfreturn variables.RBR>
        </cfif> --->


        <!--- SE VALIDA:
            Cuando se cancela  un movimiento de Salida Por Transferencia, si ay movimientos(InventariosMovimientos)
            de entrada tipoMovimiento 8 que este en estatus 301  y que en la tabla InventariosMovimientosDetalleImportes
            tenga referencia hacia el  que se esta eliminando(id_SucursalLoteOrigen, id_AlmacenLoteOrigen, id_MovimientoLoteOrigen),
            si es asi mandar mensaje "No se puede cancelar el movimiento porque ya se encuentra recibido"
        --->
        <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="IMExisteDetalleImportes"
                  argumentcollection="#arguments#"
                  returnvariable="sn">

        <cfif #sn.recordCount# GT 0>
            <!--- Se manda mensaje de alerta --->
                <cfset Variables.RBR.setError("No se puede cancelar el movimiento porque ya se encuentra recibido.")>
                <cfreturn variables.RBR>
        </cfif> --->

<!---       <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="listarGeneral"
                  argumentcollection="#arguments#"
                  returnvariable="Local.RSMovimiento"> --->

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="leerMovimiento"
                  argumentcollection="#arguments#"
                  returnvariable="Local.RSMovimiento">



        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                  method="listarGeneral"
                  argumentcollection="#arguments#"
                  returnvariable="Local.RSMovimientoDetalle">

<!---       <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                  method="upR_InventariosMovimientosDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="Local.Detalle"> --->

        <!---******************************************************************************************
                VERIFICAR SI LA SALIDA ESTA RELACIONADA  AUNA FACTURA DEL PROVEEDOR CON ESTATUS 1102
        *******************************************************************************************************--->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="existeFactura"
                  id_TipoDocumentoSoporte="2"
                  argumentcollection="#arguments#">

        <!--- <cfif #sn.recordCount# GT 0>
            <!--- Se manda mensaje de alerta --->
                <cfset Variables.RBR.setError("No se Puede cancelar la entrada porque esta relacionada a una factura Subida.")>
                <cfreturn variables.RBR>
        </cfif> --->

            <!--- *********************************************************************************************************************
                            SALIDAS POR TRANSFERENCIA
            *********************************************************************************************************************--->
        <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 8>
                <!--- Validar que no existan movimientos de entrada para esa Salida Por Transferencia --->
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                      method="IMExisteDetalleImportes"
                      argumentcollection="#arguments#"
                      returnvariable="sn">

                <cfif #sn.recordCount# GT 0>
                    <!--- Se manda mensaje de alerta --->
                        <cfset Variables.RBR.setError("No se puede cancelar el movimiento porque ya se encuentra recibido.")>
                        <cfreturn variables.RBR>
                </cfif>

                <!--- Validar si hay otro movimiento de salida de ese transpaso --->
                <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                      method="IMExisteMovimientosTraspasos"
                      argumentcollection="#arguments#"
                      id_tipomovimiento="8"
                      returnvariable="sn">

                <!--- existen movimientos, el transpaso ponerlo en Enviado parcial (7)--->
                <cfif #sn.recordCount# GT 0>
                        <cfinvoke component="#Application.RF.getPath('dao','inventariosTraspasos')#"
                            method="updateEstatusEnvio"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                            id_EstatusTraspaso="7">

                        <cfinvoke component="#Application.RF.getPath('dao','inventariosMovimientos')#"
                            method="InventariosTraspasosDetalleSetEstatusEnvioDesdeMovimiento"
                            argumentcollection="#arguments#"
                            id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                            id_EstatusTraspaso="7">

                    <!--- SI NO existen movimientos, el transpaso ponerlo en Sin Enviar (6) --->
                    <cfelse>
                        <cfinvoke component="#Application.RF.getPath('dao','inventariosTraspasos')#"
                            method="updateEstatusEnvio"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                            id_EstatusTraspaso="6">

                        <cfinvoke component="#Application.RF.getPath('dao','inventariosMovimientos')#"
                            method="InventariosTraspasosDetalleSetEstatusEnvioDesdeMovimiento"
                            argumentcollection="#arguments#"
                            id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                            id_EstatusTraspaso="6">
                </cfif>

                <!--- aumentar la existencia en la(AlmacenesExistencias) de los insumos involucrados --->
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosmovimientosDetalle')#"
                          method="cancelarMovimientoDisminuirExistencia"
                          argumentcollection="#arguments#">

                <!--- insertar en la tabla AlmacenesExistenciasSeriesInsumos los insumos del movimiento  que se encuentran
                    en InventariosMovimientosDetalleSeries. --->
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosmovimientosDetalle')#"
                          method="cancelarMovimientoInsertarSeriesInsumos"
                          argumentcollection="#arguments#">


            <!--- *********************************************************************************************************************
                            ENTRADAS POR TRANSFERENCIA
            *********************************************************************************************************************--->
        <cfelseif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 3>

            <!--- Validamos que los insumos involucrados en el movimiento se encuentren en el almacen --->
            <cfloop query="Local.RSMovimientoDetalle" >

                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="listado"
                        argumentcollection="#arguments#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        returnvariable="RSExistencia" >

                <cfif Local.RSMovimientoDetalle.nu_Cantidad GT RSExistencia.nu_Existencia  >
                    <cfset errorMessage = "No se puede cancelar el movimiento porque uno o mas insumos no tienen la existencia suficiente del movimiento."/>
                    <cfthrow type="warning" message="#errorMessage#">
                    <cfreturn>
                    <!--- <cfset Variables.RBR.setError("No se puede cancelar el movimiento porque uno o mas insumos no tienen la existencia suficiente del movimiento.")>
                    <cfreturn variables.RBR> --->
                </cfif>

                <cfif Local.RSMovimientoDetalle.SN_INSUMOSERIADO EQ 1>
                    <!--- SE VERIFICA QUE HAY EXISTENCIA PARA REDUCIR --->
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosmovimientosDetalle')#"
                        method="VerificarExistenciaPorSerie"
                        argumentcollection="#arguments#"
                        id_Insumo      =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_SerieInsumo =  "#Local.RSMovimientoDetalle.de_SerieInsumo#"
                        returnvariable="RSValidarSerie" >

                    <cfif RSValidarSerie.RecordCount EQ 0  >
                        <cfset Variables.RBR.setError("El insumo con serie #Local.RSMovimientoDetalle.de_SerieInsumo# no se encuentra en el almacen.")>
                        <cfreturn variables.RBR>
                    </cfif>
                </cfif>

            </cfloop>


            <!--- Disminuir la existencia en la(AlmacenesExistencias) de los insumos involucrados
                y restarle a la cantidadSurtida(InventariosTraspasosDetalle)  de los insumos del movimiento --->
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosmovimientosDetalle')#"
                          method="cancelarMovimientoEntradaDisminuirExistencia"
                          argumentcollection="#arguments#">

            <!--- eliminar en la tabla AlmacenesExistenciasSeriesInsumos los insumos del movimiento  que se encuentran
                    en InventariosMovimientosDetalleSeries. --->
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosmovimientosDetalle')#"
                          method="cancelarMovimientoEliminarSeriesInsumos"
                          argumentcollection="#arguments#">

            <!--- Validar si hay otro movimiento de entrada de ese transpaso --->
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="IMExisteMovimientosTraspasos"
                  argumentcollection="#arguments#"
                  id_tipomovimiento="3"
                  returnvariable="sn">

            <!--- existen movimientos, el transpaso ponerlo en Recibido Parcial (4)--->
            <cfif #sn.recordCount# GT 0>
                <cfinvoke component="#Application.RF.getPath('dao','inventariosTraspasos')#"
                        method="updateEstatusRecepcion"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                        id_EstatusRecepcionTraspaso="4">

                <!--- SI NO existen movimientos, el transpaso ponerlo en Sin Recibir (9) --->
                <cfelse>
                    <cfinvoke component="#Application.RF.getPath('dao','inventariosTraspasos')#"
                        method="updateEstatusRecepcion"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_inventarioTraspaso="#Local.rsMovimiento.id_inventarioTraspaso#"
                        id_EstatusRecepcionTraspaso="9">
            </cfif>

            <!--- *********************************************************************************************************************
                                        ENTRADAS Y SALIDAS POR AJUSTE
            *********************************************************************************************************************--->
        <cfelseif ( Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 10 ) OR ( Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 5 )>
            <!--- validar que este congelado el  inventario --->
            <cfinvoke component="#Application.RF.getPath('dao','almacenes')#"
                        method="AlmacenCongelado"
                        argumentcollection="#arguments#"
                        returnvariable="sn">

            <!---<cfif sn.sn_congelado EQ 0  >
                <cfset Variables.RBR.setError("El almacen debe estar en estatus congelado para cancelar el movimiento.")>
                <cfreturn variables.RBR>
            </cfif> --->


            <cfinvoke component="#Application.RF.getPath('dao','InventariosFisicos')#"
                        method="PerteneceMovimientoACongelacion"
                        argumentcollection="#arguments#"
                        returnvariable="sn">

            <!---<cfif sn.recordCount EQ 0  >
                <cfset Variables.RBR.setError("El movimiento solo se puede cancelar durante la congelación de inventario en que fue realizado.")>
                <cfreturn variables.RBR>
            </cfif> --->

            <cfloop query="Local.RSMovimientoDetalle" >

                <!--- Afectamos la cantidad por ajustar --->
                <cfif Local.RSMovimiento.id_NaturalezaMovimiento EQ 1>

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                            method="updateexistenciasporajustarentrada"
                            argumentcollection="#arguments#"
                            id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                            nu_cantidad = "#Local.RSMovimientoDetalle.nu_Cantidad#"  >

                <cfelseif Local.RSMovimiento.id_NaturalezaMovimiento EQ 2>

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                            method="Editarnu_cantidadporajustarsalida"
                            argumentcollection="#arguments#"
                            id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                            nu_cantidad = "#Local.RSMovimientoDetalle.nu_Cantidad#"  >
                </cfif>


                <!--- ENTRADAS --->
                <cfif Local.RSMovimientoDetalle.sn_InsumoSeriado AND Local.RSMovimiento.id_NaturalezaMovimiento EQ 1 >

                    <!--- SE VERIFICA QUE EXISTA LA SERIE DEL INSUMO EN INVENTARIO --->
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="existsSerieInsumo"
                        argumentcollection="#arguments#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieInsumo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"
                        returnvariable="RSExisteInsumoSerie"  >

                    <cfif NOT RSExisteInsumoSerie.sn_Existe >
                        <cfset errorMessage = "No es posible cancelar el movimiento.<br>Insumos pertenecientes a este movimiento ya se les dio salida."/>
                        <cfthrow type="info" message="#errorMessage#">
                        <!--- <cfset Variables.RBR.setError("No es posible cancelar el movimiento.<br>Insumos pertenecientes a este movimiento ya se les dio salida.")>
                        <cfreturn variables.RBR> --->
                        <cfreturn>
                    </cfif>

                    <!--- SI ES UN INSUMO SERIADO SE AGREGA O BORRA DE LA TABLA ALMACENES EXISTENCIAS SERIES INSUMOS --->
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="eliminarserie"
                        argumentcollection="#arguments#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieInsumo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"  >

                <!--- SALIDAS --->
                <cfelseif Local.RSMovimientoDetalle.sn_InsumoSeriado AND Local.RSMovimiento.id_NaturalezaMovimiento EQ 2 >

                    <!--- VALIDAMOS QUE EL INSUMO NO EXISTA COMO ACTIVO FIJO
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="AgregarSeriesInsumos"
                        argumentcollection="#arguments#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"  >

                    <cfif sn.recordCount GT 0 >
                        <cfset Variables.RBR.setError("No es posible cancelar el movimiento.<br> La serie del insumo se encuentra registrada como activo fijo.")>
                        <cfreturn variables.RBR>
                    </cfif> --->

                    <!--- SI ES UN INSUMO SERIADO SE AGREGA O BORRA DE LA TABLA ALMACENES EXISTENCIAS SERIES INSUMOS --->
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="AgregarSeriesInsumos"
                        argumentcollection="#arguments#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"  >

                </cfif>
            </cfloop>



        <cfelse>

            <!--- *********************************************************************************************************************
                                        SALIDAS POR CONSUMO
            *********************************************************************************************************************--->
            <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 6 >
                <!--- validar si ay un movimiento de tipo 1  estatus 301  de la misma  orden de compra
                si lo encuentra poner en la tabla **OrdenesDeCompra**   id_EstatusSurtido=2 si no id_EstatusSurtido=3 --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="CancelarSalidaDeConsumo"
                            argumentcollection="#arguments#">
            </cfif>

            <!--- *********************************************************************************************************************
                                        ENTRADAS POR COMPRA
            *********************************************************************************************************************--->
            <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 1 >
                <!--- validar si ay un movimiento de tipo 1  estatus 301  de la misma  orden de compra
                si lo encuentra poner en la tabla **OrdenesDeCompra**   id_EstatusSurtido=2 si no id_EstatusSurtido=3 --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="CambiarEstatusSurtidoCancelacionDeDocumento"
                            argumentcollection="#arguments#">

                <!--- en la tabla del detalle ** OrdenesDeCompraDetalle** actualizar la nu_cantidadSurtida y validar si
                la  nu_cantidad - nu_cantidadSurtida  = 0 si es asi poner el detalle id_EstatusSurtido=3 si no id_EstatusSurtido=2 --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="OCDetalleRestarCantidadSurtida"
                            argumentcollection="#arguments#">

            </cfif>
            <!--- *********************************************************************************************************************
                                        SALIDA POR DEVOLUCIÓN A PROVEEDOR
            *********************************************************************************************************************--->
            <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 7 >
                <!--- afectara  el detalle de la tabla OrdenesDeCompraDetalle sumandole  a la nu_CantidadSurtida de cada insumo la cantidad del
                movimiento y validando si la nu_Cantidad =  nu_CantidadSurtida   quedaron iguales entonces id_EstatusSurtido del registro
                ponerlo en 1 sino Surtido parcial 2 --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="OCDetalleSumarCantidadSurtida"
                            argumentcollection="#arguments#">

                <!--- Validar si ay otro movimiento de salida de esa orden de compra si no encuentra afectara la tabla principal
                OrdenesDeCompra   validando el detalle si encuentra un detalle en id_EstatusSurtido  = 2 ponerla en
                id_EstatusSurtido  = 2, sino id_EstatusSurtido =1. --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="CambiarEstatusSurtidoCancelarSalidaDevolucion"
                            argumentcollection="#arguments#">
            </cfif>

            <!--- *********************************************************************************************************************
                                            ENTRADA POR SURTIDO DE  DEVOLUCIÓN  A PROVEEDOR
            *********************************************************************************************************************--->
            <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 11 >
                <!--- afectar la tabla de OrdenesDeCompra Y OrdenesDeCompraDetalle  poner los estatus  en id_EstatusSurtido= 4
                y  la cantidad de los insumos de los movientos  restarlos a la cantidad surtida --->
                <cfinvoke component="#Application.RF.getPath('dao','ordenesCompras')#"
                            method="CambiarEstatusSurtidoCancelarEntradaDevolucion"
                            argumentcollection="#arguments#">

                <!--- VALIDAMOS QUE EL INSUMO NO EXISTA COMO ACTIVO FIJO --->
                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                    method="AgregarSeriesInsumos"
                    argumentcollection="#arguments#"
                    id_Insumo =  "#sn#"  >

                <cfif sn.recordCount GT 0 >
                    <cfset Variables.RBR.setError("No es posible cancelar el movimiento.<br> La serie del insumo se encuentra registrada como activo fijo.")>
                    <cfreturn variables.RBR>
                </cfif>
            </cfif>

            <!---
            Si lo que se va a cancelar es una entrada por compra, y los insumos de la entrada son seriados,
            se revisa que existan los insumos seriados en almacen.
             --->
            <cfif Local.RSMovimiento.id_NaturalezaMovimiento EQ 1>
                <!--- Si la naturaleza del movimiento es entrada, la cancelacion seria sacarlo --->
                <cfset multiplicar = -1>
            <cfelseif Local.RSMovimiento.id_NaturalezaMovimiento EQ 2>
                <!--- si la naturaleza es salida, es registrarlo de nuevo en almacen --->
                <cfset multiplicar = 1>
            </cfif>


            <cfloop query="Local.RSMovimientoDetalle" >

                <!--- SE VERIFICA QUE HAY EXISTENCIA PARA DEDUCIR EN EL CASO DE LAS ENTRADAS --->
                <cfif Local.RSMovimiento.id_NaturalezaMovimiento EQ 1>
                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                        method="listado"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen = "#session.ID_ALMACEN#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        returnvariable="RSExistencia" >

                    <cfif Local.RSMovimientoDetalle.nu_Cantidad GT RSExistencia.nu_Existencia  >
                        <cfset errorMessage = "No se puede cancelar el movimiento porque uno o mas insumos no tienen la existencia suficiente del movimiento."/>
                        <cfthrow type="warning" message="#errorMessage#">
                        <cfreturn>
                        <!--- <cfset Variables.RBR.setError("No se puede cancelar el movimiento porque uno o mas insumos no tienen la existencia suficiente del movimiento.")>
                        <cfreturn variables.RBR> --->
                    </cfif>
                </cfif>

                <!--- <cfcontent type="text/html">
                <cfdump var="#Local.RSMovimientoDetalle.nu_CantidadConversion#" format="simple" label="Local.RSMovimientoDetalle.nu_CantidadConversion" abort="true"> --->

                <!--- SE DEDUCE LA CANTIDAD O SE AGREGA DEPENDIENDO DE LA NATURALEZA DEL MOVIMIENTO --->
                <cfif Local.RSMovimientoDetalle.nu_CantidadConversion GT 0>
                    <cfset Cantidad = Local.RSMovimientoDetalle.nu_CantidadConversion * multiplicar>
                <cfelse>
                    <cfset Cantidad = Local.RSMovimientoDetalle.nu_Cantidad * multiplicar>
                </cfif>

                <!--- <cfcontent type="text/html">
                <cfdump var="#Cantidad#" format="simple" label="Cantidad" abort="true"> --->

                <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="AgregarExistencia"
                      id_Empresa ="#session.ID_EMPRESA#"
                      id_Sucursal = "#SESSION.ID_SUCURSAL#"
                      id_Almacen = "#session.ID_ALMACEN#"
                      id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                      nu_Cantidad = "#Cantidad#"  >

                <!--- SE VERIFICA QUE EXISTA LA SERIE DEL INSUMO EN INVENTARIO --->
                <!--- SI ES UN INSUMO SERIADO SE AGREGA O BORRA DE LA TABLA ALMACENES EXISTENCIAS SERIES INSUMOS --->
                <cfif Local.RSMovimientoDetalle.sn_InsumoSeriado AND Local.RSMovimiento.id_NaturalezaMovimiento EQ 1 >

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="existsSerieInsumo"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen = "#session.ID_ALMACEN#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieInsumo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"
                        returnvariable="RSExisteInsumoSerie"  >

                    <cfif NOT RSExisteInsumoSerie.sn_Existe >
                        <cfset errorMessage = "No es posible cancelar el movimiento.<br>Insumos pertenecientes a este movimiento ya se les dio salida."/>
                        <cfthrow type="info" message="#errorMessage#">
                        <!--- <cfset Variables.RBR.setError("No es posible cancelar el movimiento.<br>Insumos pertenecientes a este movimiento ya se les dio salida.")>
                        <cfreturn variables.RBR> --->
                        <cfreturn>
                    </cfif>

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="eliminarserie"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen = "#session.ID_ALMACEN#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieInsumo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"  >

                <cfelseif Local.RSMovimientoDetalle.sn_InsumoSeriado AND Local.RSMovimiento.id_NaturalezaMovimiento EQ 2 >

                    <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="AgregarSeriesInsumos"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal = "#SESSION.ID_SUCURSAL#"
                        id_Almacen = "#session.ID_ALMACEN#"
                        id_Insumo =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieInsumo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"  >


                    <!--- SI LA NATURALEZA DEL MOVIMIENTO ES SALIDA SE DESACTIVARA DE LA TABLA CENTROS DE COSTOS Y ACTIVOS FIJOS --->
                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                        method="upR_ActivoFijo"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_SucursalAsignado = "#SESSION.ID_SUCURSAL#"
                        id_AlmacenEntrada = "#session.ID_ALMACEN#"
                        id_MovimientoEntrada =  "#Local.RSMovimientoDetalle.id_Insumo#"
                        de_serieActivo = "#Local.RSMovimientoDetalle.de_SerieInsumo#"
                        returnvariable="RSActivoFijo" >



                    <cfinvoke component="#Application.RF.getPath('dao','ActivosFijos')#"
                        method="ActualisarActivo"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_ActivoFijo = "#RSActivoFijo.id_ActivoFijo#"
                        sn_Activo = "0"
                         >

                    <!--- CUANDO ES UNA SALIDA POR CONSUMO --->
                    <!--- <cfif Local.RSMovimiento.ID_TIPOMOVIMIENTO EQ 6>

                        <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                            method="upU_CentroCostoSet_sn_Activo"
                            id_Empresa ="#session.ID_EMPRESA#"
                            id_Sucursal = "#SESSION.ID_SUCURSAL#"
                            id_CentroCosto = "#RSActivoFijo.id_CentroCosto#"
                            sn_Activo="0"
                            sn_Borrado="0" >
                    </cfif> --->
                </cfif>
            </cfloop>

            <!--- Salidas por consumo -- Consignación --->
            <cfif Local.rsMovimiento.ID_TIPOMOVIMIENTO EQ 6 >
                <!--- Generamos el traspaso del almacen de session al consignación --->
                <cfinvoke component="#Application.RF.getPath('bro','AlmacenesExistencias')#"
                    method="GenerarTraspasoConsignacionPorCancelacion"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Sucursal="#arguments.id_Sucursal#"
                    id_Almacen="#arguments.id_Almacen#"
                    id_Movimiento="#arguments.id_Movimiento#"
                    returnvariable="local.Traspaso">

                <cfif local.Traspaso.hasError()>
                    <cfset Variables.RBR.setError(local.Traspaso.getMessage())>
                    <cfreturn variables.RBR>
                </cfif>
            </cfif>

        </cfif>

        <!--- <cfset arregloTiposMovimientos = arrayNew(1)>

        <cfset sn_Detalle = false>
        <cfset strNew = structNew()>
        <cfloop query="Local.RSMovimientoDetalle" >
            <cfif isNumeric(Local.RSMovimientoDetalle.id_Poliza) >
                <cfset sn_Detalle = true>
                <cfset strNew[Local.RSMovimientoDetalle.id_TipoMovimiento] = structNew()>
                <cfset strNew[Local.RSMovimientoDetalle.id_TipoMovimiento].id_TipoMovimiento = Local.RSMovimientoDetalle.id_TipoMovimiento>
                <cfset strNew[Local.RSMovimientoDetalle.id_TipoMovimiento].id_Poliza = Local.RSMovimientoDetalle.id_Poliza>
            </cfif>
        </cfloop>

        <cfif sn_Detalle >
            <cfloop collection="#strNew#" item="str">
                <cfset arrayAppend(arregloTiposMovimientos, strNew[str])>
            </cfloop>
        <cfelse>
            <cfset strNew = structNew()>
            <cfset strNew.id_TipoMovimiento = Local.RSMovimiento.id_TipoMovimiento>
            <cfset strNew.id_Poliza = Local.RSMovimiento.id_Poliza>
            <cfset arrayAppend(arregloTiposMovimientos, strNew)>
        </cfif>

        <!--- SI EL MOVIMIENTO GENERO POLIZA SE GENERA SU POLIZA DE "CANCELACION" --->
        <cfif IsNumeric(Local.RSMovimiento.id_Poliza) OR sn_Detalle>

            <cfloop from="1" to="#arrayLen(arregloTiposMovimientos)#" index="i">

                <!--- funcion que va por la configuracion del movimiento a la tabla tiposmovimientospolizasdetalle --->
                <cfinvoke   component="#Application.RF.getPath('dao','TiposMovimientosPolizaDetalles')#"
                    method="getdetalleconfiguracionpolizasdetalle"
                    id_empresa ="#session.ID_EMPRESA#"
                    id_tipomovimiento = "#arregloTiposMovimientos[i].id_TipoMovimiento#"
                    returnvariable="local.detalleconfiguracion">

                <cfinvoke   component="#Application.RF.getPath('dao','TiposMovimientos')#"
                    method="listar"
                    id_TipoMovimiento = "#arregloTiposMovimientos[i].id_TipoMovimiento#"
                    nb_TipoMovimiento = ""
                    returnvariable="Local.rs">

                <cfinvoke   component="#Application.RF.getPath('dao','Polizas')#"
                    method="listar"
                    id_Empresa = "#session.ID_EMPRESA#"
                    id_Poliza = "#arregloTiposMovimientos[i].id_Poliza#"
                    returnvariable="Local.rsPolizaRef">


                <!---  SE CREA UNA ESTRUCTURA CON LA CABECERA DE POLIZA --->
                <cfset local.datapoliza = structNew()>
                <cfset local.datapoliza.id_empresa = session.ID_EMPRESA >
                <!--- <cfset local.datapoliza.id_poliza = local.id_poliza> --->
                <cfset local.datapoliza.id_tipopoliza = 4>
                <cfset local.datapoliza.id_ejercicio = datePart("yyyy", now())>
                <cfset local.datapoliza.nu_mes = datePart("m", now())>
                <cfset local.datapoliza.id_usuario = session.ID_USUARIO>
                <cfset local.datapoliza.fh_registro = dateFormat(now(),'yyyyMMdd')>
                <cfset local.datapoliza.de_poliza = 'Cancelación de ' & local.rs.de_poliza>
                <cfset local.datapoliza.id_tipomovimiento = arregloTiposMovimientos[i].id_TipoMovimiento>
                <cfset local.datapoliza.id_estatuspoliza = 901>
                <cfset local.datapoliza.cl_contabilidad = 'A'>
                <cfset local.datapoliza.fh_poliza = dateFormat(now(),'yyyyMMdd')>
                <cfset local.datapoliza.nb_tipopoliza = local.rs.nb_tipopoliza >
                <cfset local.datapoliza.fl_PolizaReferencia = Local.rsPolizaRef.fl_Poliza>


                <!--- Validamos que exista un ejercicio y periodo abierto --->
                <cfinvoke   component="#Application.RF.getPath('dao','PeriodosContables')#"
                            method="exists"
                            argumentcollection="#local.datapoliza#"
                            returnvariable="local.exists">


                <cfif NOT Local.exists>
                        <cfset variables.RBR.setError('No existe Ejercicio ó Periodo contable abierto para el rango de fechas seleccionado.')>
                        <cfreturn variables.RBR>
                </cfif>


                <!--- incoke para el tipo cambio --->
                <cfinvoke   component="#Application.RF.getPath('dao','MonedasTipoCambio')#"
                            method="getim_tipocambio"
                            id_moneda="1"
                            fh_cambio = "#dateFormat(now(),'yyyyMMdd')#"
                            returnvariable="local.importecambio">

                <cfset ArregloMovimientos =  arrayNew(1)>

                <cfloop query="local.detalleconfiguracion">
                    <cfinvoke   component="#Application.RF.getPath('dao','PolizasMovimientos')#"
                                    <!--- method="generarpolizamovimiento" --->
                                    method="detallepolizamovimiento"
                                    <!--- argumentcollection="#local.datapolizamovimiento#" --->
                                    id_empresa = "#session.ID_EMPRESA#"
                                    id_sucursal ="#arguments.id_sucursal#"
                                    fh_inicio ="#arguments.fh_inicio#"
                                    fh_fin="#arguments.fh_fin#"
                                    id_tipomovimiento ="#arregloTiposMovimientos[i].id_TipoMovimiento#"
                                    cl_naturaleza="#local.detalleconfiguracion.CL_NATURALEZA#"
                                    sn_agrupado ="#local.detalleconfiguracion.AGRUPA#"
                                    id_tipomovimientopolizadetalle ="#local.detalleconfiguracion.ID_TIPOMOVIMIENTOPOLIZADETALLE#"
                                    id_AlmacenInventario ="#arguments.id_Almacen#"
                                    id_MovimientoInventario ="#arguments.id_Movimiento#"
                                    sn_TraerMovimientos="1"
                                    returnvariable="local.polizadetalle">

                        <cfloop query="local.polizadetalle">
                            <!--- se verifica que si el importe es cero, si lo es no se insertara un nuevo registro en polizamovimiento --->
                            <cfif local.polizadetalle.im_poliza GT 0>
                                <cfset local.polizamov = structNew()>

                                <cfif local.importecambio.im_tipocambio EQ ''>
                                    <cfset local.polizamov.im_tipocambio = 1>
                                <cfelse>
                                    <cfset local.polizamov.im_tipocambio = local.importecambio.im_tipocambio>
                                </cfif>

                                <cfset local.polizamov.id_empresa = session.ID_EMPRESA>
                                <!--- <cfset local.polizamov.id_polizamovimiento = Local.id_polizaMovimiento> --->
                                <!--- <cfset local.polizamov.id_poliza = local.id_poliza>  --->

                                <cfset local.polizamov.id_cuenta = local.polizadetalle.id_cuenta>
                                <cfset local.polizamov.id_scuenta = local.polizadetalle.id_scuenta>
                                <cfset local.polizamov.id_sscuenta = local.polizadetalle.id_sscuenta>
                                <cfset local.polizamov.id_ssscuenta = local.polizadetalle.id_ssscuenta>
                                <cfset local.polizamov.de_polizamovimiento = local.polizadetalle.de_PolizaMovimiento>
                                <cfset local.polizamov.cl_naturaleza = local.polizadetalle.cl_naturaleza>
                                <cfset local.polizamov.im_poliza = local.polizadetalle.im_poliza * -1>
                                <!--- <cfset local.polizamov.im_tipocambio = local.datapolizamovimiento.im_tipocambio > --->
                                <cfset local.polizamov.id_moneda = 1>
                                <cfset arrayAppend(ArregloMovimientos,structCopy(local.polizamov))>

                                <cfset StructClear(local.polizamov)>
                            </cfif>
                        </cfloop>

                </cfloop>

                <!--- SE GENERA LA POLIZA SOLO SI GENERO MOVIMIENTOS --->
                <cfif arrayLen(ArregloMovimientos) GT 0>
                    <cfinvoke   component="#Application.RF.getPath('dao','Polizas')#"
                        method="agregarpoliza"
                        argumentcollection="#local.datapoliza#"
                        returnvariable="local.poliza">
                    <cfloop index="x" from="1" to="#arrayLen(ArregloMovimientos) #">
                        <cfinvoke   component="#Application.RF.getPath('dao','PolizasMovimientos')#"
                                method="generarpolizamovimientobop"
                                id_Poliza="#local.poliza.id_Poliza#"
                                argumentcollection="#ArregloMovimientos[x]#">
                    </cfloop>

                    <cfif NOT sn_Detalle>
                        <!--- setea el valor de la poliza en inventarios movimientos o gastosmovimientos segun sea el caso--->
                        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                                    method="editarpolizaCancelacion"
                                    id_empresa ="#session.ID_EMPRESA#"
                                    id_sucursal ="#SESSION.ID_SUCURSAL#"
                                    id_Almacen ="#arguments.id_Almacen#"
                                    id_Movimiento="#arguments.id_Movimiento#"
                                    id_PolizaCancel ="#local.poliza.id_Poliza#"
                                    fh_PolizaCancel = "#dateFormat(now(),'yyyyMMdd')#">
                    <cfelse>
                        <cfinvoke   component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                                    method="editarpolizaCancelacion"
                                    id_empresa ="#session.ID_EMPRESA#"
                                    id_sucursal ="#SESSION.ID_SUCURSAL#"
                                    id_Almacen ="#arguments.id_Almacen#"
                                    id_Movimiento="#arguments.id_Movimiento#"
                                    id_TipoMovimiento="#arregloTiposMovimientos[i].id_TipoMovimiento#"
                                    id_PolizaCancel ="#local.poliza.id_Poliza#"
                                    fh_PolizaCancel = "#dateFormat(now(),'yyyyMMdd')#">
                    </cfif>

                </cfif>

            </cfloop>
        </cfif> --->

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="ActualizarColEstatus"
            argumentcollection="#arguments#"
            id_Empresa="#session.ID_EMPRESA#"
            id_usuarioCan="#session.ID_USUARIO#"
            de_observacionesCan="#arguments.de_observaciones#"
            id_Estatus="302">

            <!--- La informacion de la cancelacion se guarda en el momento en que se actualiza el estatus --->
        <!--- <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="ActualizarFechaCancelacion"
            id_empresa       = "#session.ID_EMPRESA#"
            id_sucursal      = "#SESSION.ID_SUCURSAL#"
            id_Almacen       = "#arguments.id_Almacen#"
            id_Movimiento    = "#arguments.id_Movimiento#"
      fh_Cancelacion   = "#dateTimeFormat(now(),'yyyy-MM-dd hh:nn:ss')#"> --->

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="ObtenerTarjetaAlmacen" access="public" returntype="Any">
        <cfargument name="id_Sucursal" type="string" required="true"/>
        <cfargument name="id_Almacen" type="string" required="true"/>
        <cfargument name="id_FamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false" default=""/>
        <cfargument name="fh_Inicio" type="string" required="false" default=""/>
        <cfargument name="fh_Fin" type="string" required="false" default=""/>
        <cfargument name="nb_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_Insumo" type="string" required="false" default=""/>
        <cfargument name="id_AlmacenFisico" type="string" required="false" default=""/>

            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                method="ObtenerTarjetaAlmacen"
                id_Empresa ="#session.ID_EMPRESA#"
                argumentcollection="#arguments#"
                returnvariable="resultado">

            <cfset variables.RBR.setData(resultado)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Kardex" access="remote" returnformat="JSON">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="id_sucursal"          type="string" required="false"/>
        <cfargument name="id_almacen"           type="string" required="false"/>
        <cfargument name="id_Naturaleza"        type="string" required="false" default=""/>
        <cfargument name="id_TipoMovimiento"    type="string" required="false" default=""/>
        <cfargument name="fh_movimientoIni"     type="string" required="true"/>
        <cfargument name="fh_movimientoFin"     type="string" required="true"/>
        <cfargument name="id_insumo"            type="string" required="false" default=""/>
        <cfargument name="id_TipoNegocio"       type="string" required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="Kardex"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">


        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    
    <cffunction name="getSalidasConsumo" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="false"/>
        <cfargument name="id_Requisicion"          type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="getSalidasConsumo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="guardarFletes" access="public" returntype="Any">
        <cfargument name="id_Empresa"  type="string" required="true"/>
        <cfargument name="id_inventarioTraspaso"  type="string" required="true"/>
        <cfargument name="id_Flete"         type="string"  required="false"/>
        <cfargument name="im_Flete"         type="string"  required="false"/>
        <cfargument name="de_Ruta"         type="string"  required="false"/>
        <cfargument name="de_NombrePDF"         type="string"  required="false"/>
        <cfargument name="de_Paqueteria"         type="string"  required="false"/>
        <cfargument name="de_Guia"         type="string"  required="false"/>
        
        <!--- Se actualiza el estatus del traspaso --->
        <cfinvoke   component="#Application.RF.getPath('dao','InventariosTraspasos')#"
                    method="guardarFletes"
                    id_Empresa="#arguments.id_Empresa#"
                    id_inventarioTraspaso="#arguments.id_inventarioTraspaso#"
                    id_Flete = #arguments.id_Flete#
                    im_Flete = #arguments.im_Flete#
                    de_Ruta = #arguments.de_Ruta#
                    de_NombrePDF = #arguments.de_NombrePDF#
                    de_Paqueteria = #arguments.de_Paqueteria#
                    de_Guia = #arguments.de_Guia#
                    >

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="impresionSalidasTraspaso" access="public" returntype="Any">
        <cfargument name="id_Empresa"              type="string" required="false">
        <cfargument name="id_InventarioTraspaso"   type="string" required="false">
        <cfargument name="id_InventarioMovimiento" type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="impresionSalidasTraspasoInformacion"
            argumentcollection="#arguments#"
            returnvariable="datos">

        <cfset DetInsumos = datos.Detalle>
        <cfset Encab = datos.Encabezado>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="Salidas Por Traspaso - #dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/MovimientoSalidaTraspaso.html">
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
