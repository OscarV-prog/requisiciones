<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="obtener_requisicion" access="public" returntype="Any">
        <cfargument name='id_Empresa'     type='numeric' required='true'>
        <cfargument name='id_Requisicion' type='numeric' required='true'>
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="obtener_requisicion"
                  argumentcollection="#Arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="agregar" access="public" returntype="any">
        <cfargument name="id_TipoRequisicion"        type="string" required="yes">
        <cfargument name="id_tipoDivision"           type="string" required="yes">
        <cfargument name="id_Departamento"           type="string" required="yes">
        <cfargument name="id_SucursalSolicita"       type="string" required="yes">
        <cfargument name="id_ClasificadoRequisicion" type="string" required="yes">
        <cfargument name="fh_Expedicion"             type="string" required="yes">
        <cfargument name="id_Proveedor"              type="string" required="no">
        <cfargument name="de_Observaciones"          type="string" required="no">
        <cfargument name="detalleRequisicion"        type="array"  required="yes">
        <cfargument name="im_totalRequisicion"       type="string" required="no">
        <cfargument name="nu_Viaje"                  type="string" required="no">
        <cfargument name="id_Empresa"                type="string" required="yes">
        <cfargument name="nu_siniestro"              type="string" required="no">
        <cfargument name="ar_soporte"                type="string" required="no">
        <cfargument name="de_Requisicion"            type="string" required="no">
        <cfargument name="id_TipoInstalacion"            type="string" required="no">
        <cfargument name="id_GrupoCentroCosto"                type="string" required="no">
        <cfargument name="id_Cliente"                type="string" required="no">
        <cfargument name="id_CentroCosto"       type="string" required="no">

        <cfset Local.requisicion=structNew()>
        <cfset Local.requisicion.id_Empresa = Arguments.id_Empresa>
        <cfset Local.requisicion.id_UsuarioSolicita = session.ID_USUARIO>
        <cfset Local.requisicion.id_TipoRequisicion = Arguments.id_TipoRequisicion>
        <cfset Local.requisicion.id_tipoDivision = Arguments.id_TipoDivision>
        <cfset Local.requisicion.id_Departamento = Arguments.id_Departamento>
        <cfset Local.requisicion.id_SucursalSolicita = Arguments.id_SucursalSolicita>
        <cfset Local.requisicion.id_ClasificadoRequisicion = Arguments.id_ClasificadoRequisicion>
        <cfset Local.requisicion.de_Requisicion = Arguments.de_Requisicion>
        <!---<cfset Local.requisicion.fh_Expedicion=dateFormat(now(),'yyyymmdd')>--->

        <cfif isDefined("Arguments.im_totalRequisicion") AND Arguments.im_totalRequisicion NEQ ''>
            <cfset Local.requisicion.im_PrecioTotal=Arguments.im_totalRequisicion>
        </cfif>
        <cfif isDefined("Arguments.id_Proveedor") AND Arguments.id_Proveedor NEQ ''>
            <cfset Local.requisicion.id_Proveedor=Arguments.id_Proveedor>
        </cfif>
        <cfif isDefined("Arguments.de_Observaciones") AND Arguments.de_Observaciones NEQ ''>
            <cfset Local.requisicion.de_Observaciones=Arguments.de_Observaciones>
        <cfelse>
            <cfset local.requisicion.de_Observaciones = ''>
        </cfif>

        <cfif isDefined("Arguments.nu_Viaje") AND Arguments.nu_Viaje NEQ ''>
            <cfset Local.requisicion.nu_Viaje=Arguments.nu_Viaje>
        </cfif>
        <cfif isDefined("Arguments.nu_siniestro") AND Arguments.nu_siniestro NEQ ''>
            <cfset Local.requisicion.nu_siniestro=Arguments.nu_siniestro>
        </cfif>
        <cfif isDefined("Arguments.ar_soporte") AND Arguments.ar_soporte NEQ ''>
            <cfset Local.requisicion.ar_soporte=Arguments.ar_soporte>
        </cfif>
        <cfif isDefined("Arguments.id_TipoInstalacion") AND Arguments.id_TipoInstalacion NEQ ''>
            <cfset Local.requisicion.id_TipoInstalacion=Arguments.id_TipoInstalacion>
        </cfif>

        <cfset Local.requisicion.id_EstatusAutorizacion=1><!--- Borrador --->
        <cfset Local.requisicion.id_EstatusSurtido=3><!--- Sin surtir --->

        <!---<cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="getNextID"
                  id_Empresa="#session.ID_EMPRESA#"
                  returnvariable="Local.requisicion.id_requisicion"> --->

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="agregar"
                  argumentcollection="#Local.requisicion#"
                  returnvariable="Local.requisicion.id_requisicion">


        <!--- Agregar a la tabla de Obras en Proceso --->
        <cfif isDefined("Arguments.id_TipoInstalacion") AND Arguments.id_TipoInstalacion NEQ ''>
           
            <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                method="agregarObraEnProceso"
                id_Empresa = "#arguments.id_Empresa#"
                id_Sucursal = "#arguments.id_SucursalSolicita#"
                id_Requisicion  = "#Local.requisicion.id_requisicion#"
                im_CostoTotal  = "#arguments.im_totalRequisicion#"
                id_GrupoCentroCosto  = "#arguments.id_GrupoCentroCosto#"
                id_CentroCosto  = "#arguments.id_CentroCosto#"
                id_Cliente  = "#arguments.id_Cliente#"
                id_Usuario = "#session.ID_USUARIO#"
                >

        </cfif> 


        <cfset Local.detalleRequisicion=structNew()>
        <cfset Local.i=1>
        <cfloop array="#Arguments.detalleRequisicion#" index="Local.detalle">
            <cfset structClear(Local.detalleRequisicion)>
            <cfset Local.detalleRequisicion.id_Empresa=Local.requisicion.id_Empresa>
            <cfset Local.detalleRequisicion.id_Requisicion=Local.requisicion.id_Requisicion>

            <cfset Local.detalleRequisicion.id_Insumo=Local.detalle.id_Insumo>
            <cfset Local.detalleRequisicion.nu_Cantidad=Local.detalle.nu_Cantidad>

            <cfif isDefined('Local.detalle.im_PrecioUnitario') AND Local.detalle.im_PrecioUnitario NEQ ''>
                <cfset Local.detalleRequisicion.im_PrecioUnitario=Local.detalle.im_PrecioUnitario>
            </cfif>
            <cfset Local.detalleRequisicion.nu_CantidadSurtida=0>
            <cfset Local.detalleRequisicion.id_EstatusSurtido=3>
            <cfset Local.detalleRequisicion.id_CentroCosto=Local.detalle.id_centroCosto>
            <cfset Local.detalleRequisicion.id_SucursalCentroCosto=Local.detalle.id_SucursalCentroCosto>
            <cfset Local.detalleRequisicion.id_Moneda=Local.detalle.id_tipoMoneda>
            <cfset Local.detalleRequisicion.im_TipoCambio=Local.detalle.im_TipoCambio>
            <cfset Local.detalleRequisicion.id_GrupoCentroCosto=Local.detalle.id_GrupoCentroCosto>
            <cfif isDEfined('Local.detalle.id_grupoGasto')>
                <cfset local.detalleRequisicion.id_grupoGasto = local.detalle.id_grupoGasto>
            </cfif>
            <cfif isDEfined('Local.detalle.id_conceptoGasto')>
                <cfset local.detalleRequisicion.id_conceptoGasto = local.detalle.id_conceptoGasto>
            </cfif>

            <cfset Local.detalleRequisicion.nu_kilometraje = ''>
            <cfset Local.detalleRequisicion.de_colaborador = ''>

            <cfif isDefined('Local.detalle.nu_kilometraje')>
                <cfset Local.detalleRequisicion.nu_kilometraje = Local.detalle.nu_kilometraje>
            </cfif>
            <cfif isDefined('Local.detalle.de_colaborador')>
                <cfset Local.detalleRequisicion.de_colaborador = Local.detalle.de_colaborador>
            </cfif>

            <cfif isDefined('Local.detalle.id_Direccion')>
                <cfset Local.detalleRequisicion.id_Direccion = Local.detalle.id_Direccion>
            </cfif>

            <cfif isDefined('Local.detalle.id_TipoInstalacion')>
                <cfset Local.detalleRequisicion.id_TipoInstalacion = Local.detalle.id_TipoInstalacion>
            </cfif>

            <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                      method="AgregarDetalle"
                      argumentcollection="#Local.detalleRequisicion#"
                      returnvariable="local.reqdet">

            <!--- <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                method="guardarCambiosHistorial"
                id_Empresa="#Local.detalleRequisicion.id_Empresa#"
                id_SucursalCentroCosto="#Local.detalleRequisicion.id_SucursalCentroCosto#"
                id_Requisicion="#Local.detalleRequisicion.id_Requisicion#"
                id_RequisicionDetalle="#local.reqdet.id_requisiciondetalle#"
                id_Insumo="#Local.detalleRequisicion.id_Insumo#"
                im_PrecioUnitario="#Local.detalleRequisicion.im_PrecioUnitario#"
                id_Moneda="#Local.detalleRequisicion.id_moneda#"
                im_TipoCambio="#Local.detalleRequisicion.im_tipoCambio#"
                id_CentroCosto="#Local.detalleRequisicion.id_CentroCosto#"
                id_GrupoCentroCosto="#Local.detalleRequisicion.id_GrupoCentroCosto#"
                nu_Cantidad="#Local.detalleRequisicion.nu_Cantidad#"
                nu_Kilometraje="#Local.detalleRequisicion.nu_kilometraje#"
                de_Colaborador="#Local.detalleRequisicion.de_colaborador#"
                sn_ShowComments="#0#"
                sn_NewItem="#0#"
                de_ComentariosMovimientos="Registro inicial - Requisición Recién Creada"> --->

            <cfif #isDefined("local.detalle.CAMPOS")#>
                <cfif local.detalle.sn_activofijo eq 'true'>
                    <cfloop from="1" to="#arrayLen(local.detalle.CAMPOS)#" index="local.p">
                        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalleCamposDetalle')#"
                                  method="Agregar"
                                  id_empresa="#Arguments.id_Empresa#"
                                  id_requisicion ="#Local.requisicion.id_requisicion#"
                                  id_requisiciondetalle ="#local.reqdet.id_requisiciondetalle#"
                                  id_campodetalle ="#local.detalle.CAMPOS[local.p].id_campodetalle#"
                                  nb_campodetalle="#local.detalle.CAMPOS[local.p].nb_campodetalle#"
                                  de_valorcampodetalle="#local.detalle.CAMPOS[local.p].de_valorcampodetalle#">
                    </cfloop>
                </cfif>
            </cfif>

            <cfset ++Local.i>
        </cfloop>

        <cfset variables.RBR.setData(Local.requisicion.id_requisicion)>
        <cfreturn variables.RBR />
    </cffunction>

    <cffunction name="listado" access="public" returntype="Any">
        <cfargument name="id_Empresa"      type="string" required="yes">
        <cfargument name="id_requisicion"  type="string" required="false">
        <cfargument name="fh_inicio"       type="string" required="false">
        <cfargument name="fh_fin"          type="string" required="false">
        <cfargument name="id_estatus"      type="string" required="false">
        <cfargument name="id_Sucursal"     type="string" required="false">
        <cfargument name="nb_NombreInsumo" type="string" required="false">
        <cfargument name="id_centrocosto"  type="string" required="false">
        <cfargument name="nu_Siniestro"    type="string" required="false">
        <cfargument name="de_Requisicion"  type="string" required="false">

        <cfset Local.requisicion=structNew()>
        <cfset Arguments.id_usuario = #session.ID_USUARIO#>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="listado"
            id_Usuario="#session.ID_USUARIO#"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!---   JULIO CESAR ACOSTA LOPEZ 17/03/2015
            listado de requisiciones para el registro de salidas por ajuste--->
    <cffunction name="listarSalidasAjuste" access="public" returntype="Any">
        <cfargument name="id_Requisicion"   type="numeric" required="true"/>

        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen  = session.ID_ALMACEN>

        <cfset local.DetalleRequisicion=structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
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

<!--- Victor Sanchez
    17/11/2015
Se hace una sola llamada para traer todos los datos a la pantalla de requisicionesAgregar
     --->
    <cffunction name="RequisicionesAgregarData" access="public" returntype="Any">
        <cfargument name="id_Empresa" type="string" required="no">
    <cfargument name="id_TipoRequisicion" type="string" required="no">
        <cfset local.DetalleRequisicion=structNew()>

            <cfinvoke component="#Application.RF.getPath('dao','sucursales')#"
                      method="listarPorEmpleado"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_Empleado="#SESSION.ID_EMPLEADO#"
                      returnvariable="Local.Sucursales">

            <cfset local.DetalleRequisicion.Sucursales = local.Sucursales>

            <cfinvoke component="#Application.RF.getPath('dao','Departamentos')#"
                      method="listar"
                      returnvariable="Local.Departamentos">

            <cfset local.DetalleRequisicion.Departamentos = local.Departamentos>


            <cfinvoke component="#Application.RF.getPath('dao','TiposRequisicion')#"
                      method="listar"
                      returnvariable="Local.TiposRequisicion">

            <cfset local.DetalleRequisicion.TiposRequisicion = local.TiposRequisicion>

            <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
                      method="listar"
                      returnvariable="Local.ClasificadosRequisicion">

            <cfset local.DetalleRequisicion.ClasificadosRequisicion = local.ClasificadosRequisicion>


            <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
                      method="TiposRequisicionesDivisionesCombo"
                      id_Empresa="#arguments.id_Empresa#"
                      returnvariable="Local.Divisiones">

            <cfset local.DetalleRequisicion.Divisiones = local.Divisiones>


            <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
                      method="listarTipoInstalacion"
                      returnvariable="Local.Instalaciones">

            <cfset local.DetalleRequisicion.Instalaciones = local.Instalaciones>

            <cfset variables.RBR.setData(local.DetalleRequisicion)>

        <cfreturn variables.RBR>
    </cffunction>


<!--- Victor Sanchez
    17/11/2015
Se hace una sola llamada para traer todos los datos a la pantalla de requisicionesEditar
     --->
    <cffunction name="RequisicionesEditarData" access="public" returntype="Any">
        <cfargument name="id_TipoRequisicion" type="string" required="no">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Sucursal"   type="numeric" required="no"/>
        <cfset local.DetalleRequisicion=structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','sucursales')#"
            method="listarPorEmpleado"
            id_Empresa="#Arguments.id_Empresa#"
            id_Empleado="#SESSION.ID_EMPLEADO#"
            returnvariable="Local.Sucursales">

        <cfset local.DetalleRequisicion.Sucursales = local.Sucursales>

        <cfinvoke component="#Application.RF.getPath('dao','Departamentos')#"
            method="listar"
            returnvariable="Local.Departamentos">

        <cfset local.DetalleRequisicion.Departamentos = local.Departamentos>

        <cfinvoke component="#Application.RF.getPath('dao','TiposRequisicion')#"
            method="listar"
            returnvariable="Local.TiposRequisicion">

        <cfset local.DetalleRequisicion.TiposRequisicion = local.TiposRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','ClasificadosRequisicion')#"
            method="listar"
            returnvariable="Local.ClasificadosRequisicion">

        <cfset local.DetalleRequisicion.ClasificadosRequisicion = local.ClasificadosRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','GruposCentrosCostos')#"
            id_Empresa="#Arguments.id_Empresa#"
            id_Sucursal="#Arguments.id_Sucursal#"
            method="listarCombo"
            returnvariable="Local.GruposCentrosCostos">

        <cfset local.DetalleRequisicion.GruposCentrosCostos = local.GruposCentrosCostos>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
            method="listar"
            id_Requisicion="#id_Requisicion#"
            id_Empresa="#Arguments.id_Empresa#"
            returnvariable="Local.DetRequisicion">

        <cfset local.DetalleRequisicion.DetalleRequisicion = local.DetRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getById"
            id_Requisicion="#id_Requisicion#"
            id_Empresa="#Arguments.id_Empresa#"
            returnvariable="Local.Requisiciones">

        <cfset local.DetalleRequisicion.Requisiciones = local.Requisiciones>

        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalle')#"
            method="getByIdRequisicion"
            id_Requisicion="#id_Requisicion#"
            id_Empresa="#Arguments.id_Empresa#"
            returnvariable="Local.RecDetalle">

        <!--- Convierto el detalle de la requisicion a json --->
        <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
            method="queryToJSon"
            query="#Local.RecDetalle#"
            returnvariable="Local.Detalle"/>

        <!--- listar_CentrosCostoPorDestino --->
        <cfloop array="#Local.Detalle#" index="opcion">
            <cfinvoke component="#Application.RF.getPath('dao','CentrosCostos')#"
                method="listar_CentrosCostoPorDestino"
                id_Empresa="#Arguments.id_Empresa#"
                id_Sucursal="#Arguments.id_Sucursal#"
                id_TipoDestino="#opcion.ID_TIPODESTINO#"
                id_Departamento ="#Local.Requisiciones.id_Departamento#"
                id_GrupoCentroCosto="#opcion.id_GrupoCentroCosto#"
                returnvariable="Local.CC">

            <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                method="queryToJSon"
                query="#Local.CC#"
                returnvariable="Local.CENTROSCOSTOS"/>

            <cfset opcion.CENTROSCOSTOS = #Local.CENTROSCOSTOS#>

            <cfinvoke component="#Application.RF.getPath('dao','configuracionCamposDetalle')#"
                method="obtenerconfiguracionEditar"
                id_empresa="#arguments.id_Empresa#"
                id_Requisicion="#id_Requisicion#"
                id_subFamiliaInsumo="#opcion.ID_SUBFAMILIAINSUMO#"
                id_subFamiliaDinamica="#opcion.ID_SUBFAMILIADINAMICA#"
                id_insumo="#opcion.ID_INSUMO#"
                id_RequisicionDetalle="#opcion.ID_REQUISICIONDETALLE#"
                returnvariable="Local.CmpDet">

            <cfinvoke component="#Application.RF.getPath('cfc','funciones')#"
                method="queryToJSon"
                query="#Local.CmpDet#"
                returnvariable="Local.CampoDet"/>

            <cfset opcion.CAMPOS = #Local.CampoDet#>
        </cfloop>

        <cfset local.DetalleRequisicion.RequisicionesDetalle = Local.Detalle>

       <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
            method="TiposRequisicionesDivisionesCombo"
            returnvariable="Local.Divisiones">

        <cfset local.DetalleRequisicion.Divisiones = local.Divisiones>

        
        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
                      method="listarTipoInstalacion"
                      returnvariable="Local.Instalaciones">

        <cfset local.DetalleRequisicion.Instalaciones = local.Instalaciones>

        <cfset variables.RBR.setData(local.DetalleRequisicion)>
        <cfreturn variables.RBR>
    </cffunction>



    <cffunction name="enviarRequisicion" access="public" returntype="any">
        <cfargument name='id_requisicion'      type='string' required='yes'>
        <cfargument name='estatus'             type='numeric' required='true'>
        <cfargument name='id_Empresa'          type='numeric' required='true'>
        <cfargument name='id_TipoRequisicion'  type='numeric' required='true'>

        <cfset ff_Presupuestos = Application.RENV.getProperty('FF_PRESUPUESTOS')>

        <!--- se pregunta de que estatus viene la requisicion, esto para saber si viene editada una vez que la rechazaron la primera vez
              modificacion: 28/09/2015
        --->
        <cfif arguments.estatus EQ 6>
            <cfset arguments.autorizacion = 7>
        <cfelse>
            <cfset arguments.autorizacion = 2>
        </cfif>

        <cfif arguments.autorizacion = 2>

            <cfif arguments.id_TipoRequisicion EQ 1>
                <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                    method         = "getRequisicionDetalleServicios"
                    id_empresa     = "#arguments.id_empresa#"
                    id_requisicion = "#arguments.ID_REQUISICION#"
                    returnvariable = "Local.insumos">

            <cfelseif arguments.id_TipoRequisicion EQ 2>
                <cfinvoke component="#Application.RF.getPath('dao','AutorizaciondeRequisicion')#"
                        method         = "getRequisicionDetalleAlmacenExistencia"
                        id_empresa     = "#arguments.id_empresa#"
                        id_requisicion = "#arguments.ID_REQUISICION#"
                        returnvariable = "Local.insumos">
            </cfif>

            <!--- Recuperamos la bandera de presupuesto por la sucursal --->
            <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                    method         = "getBanderaPresupuestoSucursal"
                    id_Empresa     = "#local.insumos.id_Empresa#"
                    id_Sucursal    = "#local.insumos.id_SucursalSolicita#"
                    returnvariable = "local.sucursal_bandera">

            <!--- Si se encuentra activado el consumo de presupuestos se hacen las validaciones --->
            <cfif ff_Presupuestos EQ 1 AND "#local.sucursal_bandera.sn_Presupuestos#" EQ 1>
                <!--- Formateamos un json para validar todos los insumos a la vez --->
                <cfset local.JSON_Insumos = "[">
                <cfloop query="Local.insumos">
                    <cfset local.JSON_Insumos = local.JSON_Insumos & '{
                        "id_Insumo": "#Local.insumos.id_Insumo#",
                        "id_CuentaPresupuesto": "#Local.insumos.id_CuentaPresupuesto#",
                        "im_TotalInsumo": "#Local.insumos.im_TotalInsumo#"
                    },'>
                </cfloop>
                <cfset local.JSON_Insumos = left(local.JSON_Insumos, len(local.JSON_Insumos)-1) & "]">

                <cfinvoke component="#Application.RF.getPath('dao','DashboardPresupuestos')#"
                    method="getPresupuestoDisponible"
                    id_Empresa="#arguments.id_empresa#"
                    id_CargaPresupuesto="#local.insumos.ID_CARGAPRESUPUESTO#"
                    id_Requisicion="#arguments.id_Requisicion#"
                    json_Insumos="#local.JSON_Insumos#"
                    returnVariable="local.ResInsumo">


                <cfset local.jsonres = "">
                <!--- Validamos el presupuesto disponible --->
                <cfloop query="local.ResInsumo">
                    <!--- Si no hay presupuesto disponible concatenamos el detalle del error --->
                    <cfif isDefined("local.ResInsumo.sn_Error") AND local.ResInsumo.sn_Error EQ 1>
                        <cfset local.jsonres = local.jsonres & '{
                            "nb_GrupoGasto": "#local.ResInsumo.nb_GrupoGasto#",
                            "im_PresupuestoFaltante": "#local.ResInsumo.im_PresupuestoFaltante#",
                            "nb_CuentaConcepto": "#local.ResInsumo.de_CuentaConcepto#",
                            "nb_Solicitante": "#local.ResInsumo.nb_Solicitante#",
                            "de_Email": "#local.ResInsumo.de_Email#",
                            "nb_Empresa": "#local.ResInsumo.nb_Empresa#",
                            "id_Requisicion": "#arguments.id_Requisicion#",
                            "nb_Jefe": "#local.ResInsumo.nb_Jefe#",
                            "de_Email_Jefe": "#local.ResInsumo.de_Email_Jefe#",
                            "sn_Autorizacion": 1
                        },'>
                    </cfif>
                </cfloop>

                <!--- Si jsonres no está vacío retornamos error --->
                <cfif len(local.jsonres) GT 0>
                    <cfset local.jsonres = "sn_PresupuestoFaltante<>[" & left(local.jsonres, len(local.jsonres)-1) & "]">
                    <cfset variables.RBR.setError(local.jsonres)>
                    <cfreturn variables.RBR>
                </cfif>
            </cfif>
        </cfif>


        <!--- Cambiamos el estatus de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
              method="updateEstatusAutorizacion"
              id_empresa="#Arguments.id_empresa#"
              id_requisicion="#Arguments.id_requisicion#"
              id_EstatusAutorizacion='#arguments.autorizacion#'>

        <!--- Nos traemos los datos de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getById"
            id_empresa="#Arguments.id_empresa#"
            id_requisicion="#Arguments.id_requisicion#"
            returnvariable="Local.requisicion">

        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
            method="getByIdRequisicion"
            id_empresa="#arguments.id_empresa#"
            id_requisicion="#arguments.ID_REQUISICION#"
            returnvariable="Local.Detalle">

        <cfloop query="#Local.Detalle#">
            <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                method="guardarCambiosHistorial"
                id_Empresa="#Arguments.id_Empresa#"
                id_SucursalCentroCosto="#local.requisicion.ID_SUCURSALSOLICITA#"
                id_Requisicion="#arguments.ID_REQUISICION#"
                id_RequisicionDetalle="#Local.Detalle.id_RequisicionDetalle#"
                id_Insumo="#Local.Detalle.id_Insumo#"
                im_PrecioUnitario="#Local.Detalle.im_PrecioUnitario#"
                id_Moneda="#Local.Detalle.id_Moneda#"
                im_TipoCambio="#Local.Detalle.im_TipoCambio#"
                id_CentroCosto="#Local.Detalle.id_CentroCosto#"
                id_GrupoCentroCosto="#Local.Detalle.id_GrupoCentroCosto#"
                nu_Cantidad="#Local.Detalle.nu_Cantidad#"
                nu_Kilometraje="#Local.Detalle.nu_kilometraje#"
                de_Colaborador="#Local.Detalle.de_colaborador#"
                sn_ShowComments="#0#"
                sn_NewItem="#0#"
                de_ComentariosMovimientos="Registro inicial - Requisición Recién Creada">
        </cfloop>

        <cfif Local.requisicion.im_PrecioTotal EQ ''>
            <cfset Local.im_totalRequisicion=0>
            <cfelse>
            <cfset Local.im_totalRequisicion=Local.requisicion.im_PrecioTotal>
        </cfif>

        <!--- Nos traemos el detalle de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                  method="getByIdRequisicion"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.detalleRequisicion">

        <!--- Nos traemos el empleado que autoriza en base EMPRESA, SUCURSAL, DIVISION, JEFE INMEDIATO --->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="RequisicionesUsuarioAutoriza"
                id_Empresa="#local.requisicion.ID_EMPRESA#"
                id_Sucursal="#local.requisicion.ID_SUCURSALSOLICITA#"
                id_tipoDivision="#local.requisicion.ID_TIPODIVISION#"
                id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
                id_Empleado="#SESSION.ID_EMPLEADO#"
                returnvariable="Local.empleadoAutoriza">

        <cfif Local.empleadoAutoriza.recordCount GT 0>

            <cfset Local.fh_AsignacionEstatus=  DateFormat(now(), "yyyy-mm-dd")>

            <cfset Local.destinatarios = arrayNew(1)>
            <cfloop query="Local.empleadoAutoriza">

              <cfif arguments.estatus EQ 6>
                  <!--- se va por id_Requisicionusuarioautoriza a la tabla de requisicionesusuariosautorizan --->
                  <!--- <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="getid_requisicionusuarioautoriza"
                            id_empresa="#Arguments.id_empresa#"
                            id_requisicion="#Local.requisicion.id_requisicion#"
                            returnvariable="requisicionusuarioautoriza"
                            id_Nivel="1">

                  <!--- se manda actualizar la tabla de requisicionesusuariosautorizan --->
                  <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="updaterequisicionesusuariosautorizan"
                            id_empresa="#Arguments.id_empresa#"
                            id_requisicion="#Local.requisicion.id_requisicion#"
                            id_requisicionusuarioautoriza = "#requisicionusuarioautoriza.id_Requisicionusuarioautoriza#"
                            id_UsuarioAutoriza="#Local.empleadoAutoriza.id_usuario#"
                            fh_AsignacionEstatus="#Local.fh_AsignacionEstatus#"
                            id_EstatusAutorizacionRequisicion="2"
                            > --->

                    <!--- Hacemos el insert en requisiciones ausuariosautorizan --->
                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="getNextID"
                            id_empresa="#Arguments.id_empresa#"
                            id_requisicion="#Local.requisicion.id_requisicion#"
                            returnvariable="Local.id_RequisicionUsuarioAutoriza">

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="RSAgregar"
                            id_Empresa="#Local.requisicion.id_Empresa#"
                            id_Requisicion="#Local.requisicion.id_Requisicion#"
                            id_RequisicionUsuarioAutoriza="#Local.id_RequisicionUsuarioAutoriza#"
                            fh_AsignacionEstatus="#Local.fh_AsignacionEstatus#"
                            id_UsuarioAutoriza="#Local.empleadoAutoriza.id_Usuario#"
                            de_Comentarios="">

                    <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="crearRequisicionesUsuariosAutorizanMovimientos"
                            id_Empresa="#Arguments.id_empresa#"
                            id_Requisicion="#Local.requisicion.id_requisicion#"
                            id_RequisicionUsuarioAutoriza = "#Local.id_RequisicionUsuarioAutoriza#"
                            id_UsuarioAutoriza="#Local.empleadoAutoriza.id_usuario#"
                            id_EstatusAutorizacionRequisicion="2"
                            fh_AsignacionEstatus="#Local.fh_AsignacionEstatus#"
                            id_Usuario = "#session.ID_USUARIO#"
                            de_Comentarios=""
                            id_Nivel="1"
                            fh_Autorizacion="">

              <cfelse>
                  <!--- Hacemos el insert en requisiciones ausuariosautorizan --->
                  <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="getNextID"
                            id_empresa="#Arguments.id_empresa#"
                            id_requisicion="#Local.requisicion.id_requisicion#"
                            returnvariable="Local.id_RequisicionUsuarioAutoriza">

                  <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="RSAgregar"
                            id_Empresa="#Local.requisicion.id_Empresa#"
                            id_Requisicion="#Local.requisicion.id_Requisicion#"
                            id_RequisicionUsuarioAutoriza="#Local.id_RequisicionUsuarioAutoriza#"
                            fh_AsignacionEstatus="#Local.fh_AsignacionEstatus#"
                            id_UsuarioAutoriza="#Local.empleadoAutoriza.id_Usuario#"
                            de_Comentarios="">

                  <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                            method="crearRequisicionesUsuariosAutorizanMovimientos"
                            id_Empresa="#Arguments.id_empresa#"
                            id_Requisicion="#Local.requisicion.id_requisicion#"
                            id_RequisicionUsuarioAutoriza = "#Local.id_RequisicionUsuarioAutoriza#"
                            id_UsuarioAutoriza="#Local.empleadoAutoriza.id_usuario#"
                            id_EstatusAutorizacionRequisicion="2"
                            fh_AsignacionEstatus="#Local.fh_AsignacionEstatus#"
                            id_Usuario = "#session.ID_USUARIO#"
                            de_Comentarios=""
                            id_Nivel="1"
                            fh_Autorizacion="">
              </cfif>

              <!---
                  Se mandaran los datos del autorizador para saber si se enviara correo o no
                  <cfdump var="#Local.sn_EviarCorreo#"> <cfabort>
              --->

              <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="RequisicionesEviarCorreo"
                  id_Empresa="#local.requisicion.ID_EMPRESA#"
                  id_Sucursal="#local.requisicion.ID_SUCURSALSOLICITA#"
                  id_tipoDivision="#local.requisicion.ID_TIPODIVISION#"
                  id_Empleado="#Local.empleadoAutoriza.id_Empleado#"
                  returnvariable="Local.rs">

              <cfif Local.rs.sn_EviarCorreo EQ 1>
                  <cfset arrayAppend(Local.destinatarios,Local.empleadoAutoriza.de_Email)>

                  <!---<cfset crearReporte(Local.requisicion,Local.detalleRequisicion,arguments.estatus)>--->

                  <!--- <cfinvoke
                      method="crearReporte"
                      requisicion="#Local.requisicion#"
                      requisicionDetalle="#Local.detalleRequisicion#"
                      estatus="#arguments.estatus#"
                      returnvariable="rbrREPORTE">

                  <cfif rbrREPORTE.hasError()>
                      <cfset errorMessage = "Error al generar el reporte " & rbrReporte.getMessage() />
                      <cfthrow type="warning" message="#errorMessage#">
                  </cfif>

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

                  <cfset Local.archivos=[{
                      dir="Reportes/requisicion#Local.requisicion.id_requisicion#.pdf",
                      name='reporte',
                      sn_deleteFile= "yes"
                  }]>

                  <cfset var Local.tipo=Local.requisicion.id_TipoRequisicion EQ 1?'Servicios':'Materiales'>

                  <cfset theURLBase = "http://">
                  <cfif CGI.HTTPS EQ "on">
                      <cfset theURLBase = 'https://' />
                  </cfif>

                  <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

                  <cfif arrayLen(Local.destinatarios) GT 0>
                      <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#Local.destinatarios#"
                                asunto="Solicitud de Requisicion de #Local.tipo#"
                                imagenes="#Local.imagenes#"
                                archivos="#Local.archivos#"
                                parametros="#Local.requisicion#"
                                estatus="#arguments.estatus#"
                                webPath="#Local.webPath#"
                                id_UsuarioAutoriza="#Local.empleadoAutoriza.id_usuario#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailRequisicion.html"
                                returnvariable="Local.RBR"/>
                  </cfif> --->

              </cfif>
            </cfloop>


            <cfif arrayLen(Local.destinatarios) GT 0>
                <cfinvoke
                    method="crearReporte"
                    requisicion="#Local.requisicion#"
                    requisicionDetalle="#Local.detalleRequisicion#"
                    estatus="#arguments.estatus#"
                    returnvariable="rbrREPORTE">

                <cfif rbrREPORTE.hasError()>
                    <cfset errorMessage = "Error al generar el reporte " & rbrReporte.getMessage() />
                    <cfthrow type="warning" message="#errorMessage#">
                </cfif>

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

                <cfset Local.archivos=[{
                    dir="Reportes/requisicion#Local.requisicion.id_requisicion#.pdf",
                    name='reporte',
                    sn_deleteFile= "yes"
                }]>

                <cfset var Local.tipo=Local.requisicion.id_TipoRequisicion EQ 1?'Servicios':'Materiales'>

                <cfset theURLBase = "http://">
                <cfif CGI.HTTPS EQ "on">
                    <cfset theURLBase = 'https://' />
                </cfif>

                <cfset Local.webPath = "#theURLBase##Application.RENV.getProperty('site-domain')#/">

                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                        method="sendMail"
                        destinatarios="#Local.destinatarios#"
                        asunto="Solicitud de Requisicion de #Local.tipo#"
                        imagenes="#Local.imagenes#"
                        archivos="#Local.archivos#"
                        parametros="#Local.requisicion#"
                        estatus="#arguments.estatus#"
                        webPath="#Local.webPath#"
                        id_UsuarioAutoriza="#Local.empleadoAutoriza.id_usuario#"
                        sn_plantilla="YES"
                        dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailRequisicion.html"
                        returnvariable="Local.RBR"/>
            </cfif>

        <cfelse>
            <cfset variables.RBR.setError("Error al enviar requisición.<br>No existe ningun empleado configurado para autorizar esta requisicion.")>
        </cfif>

        <cfreturn variables.RBR />
    </cffunction>

    <cffunction name="getById" access="public" returntype="Any">
        <cfargument name='id_requisicion' type='string' required='yes'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="getById"
                  id_empresa="#session.ID_EMPRESA#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="editar" access="public" returntype="any">
        <cfargument name="id_Requisicion"            type="string"  required="true"/>
        <cfargument name="id_TipoRequisicion"        type="string"  required="true">
        <cfargument name="id_TipoDivision"           type="string"  required="true">
        <cfargument name="id_Departamento"           type="string"  required="true">
        <cfargument name="id_SucursalSolicita"       type="string"  required="true">
        <cfargument name="id_ClasificadoRequisicion" type="string"  required="true">
        <cfargument name="fh_Expedicion"             type="string"  required="true">
        <cfargument name="id_Proveedor"              type="string"  required="true">
        <cfargument name="de_Observaciones"          type="string"  required="true">
        <cfargument name="detalleRequisicion"        type="array"   required="true">
        <cfargument name="im_totalRequisicion"       type="string"  required="true">
        <cfargument name="estatus"                   type="numeric" required="true">
        <cfargument name="nu_Viaje"                  type="string"  required="no">
        <cfargument name="id_Empresa"                type="string"  required="true">
        <cfargument name="nu_siniestro"              type="string"  required="no" default="">
        <cfargument name="ar_soporte"                type="string"  required="no" default="">
        <cfargument name="de_Requisicion"            type="string"  required="no">
        <cfargument name="id_TipoInstalacion"        type="string" required="no">

        <cfset Local.requisicion=structNew()>
        <cfset Local.requisicion.id_Empresa=Arguments.id_Empresa>
        <cfset Local.requisicion.id_Requisicion=Arguments.id_Requisicion>
        <cfset Local.requisicion.id_UsuarioSolicita=session.ID_USUARIO>
        <cfset Local.requisicion.id_TipoRequisicion=Arguments.id_TipoRequisicion>
        <cfset Local.requisicion.id_Departamento=Arguments.id_Departamento>
        <cfset Local.requisicion.id_SucursalSolicita=Arguments.id_SucursalSolicita>
        <cfset Local.requisicion.id_ClasificadoRequisicion=Arguments.id_ClasificadoRequisicion>
        <cfset Local.requisicion.fh_Expedicion=Arguments.fh_Expedicion>
        <cfset Local.requisicion.id_TipoDivision=Arguments.id_TipoDivision>
        <cfset Local.requisicion.de_Requisicion=Arguments.de_Requisicion>

        <cfif isDefined("Arguments.nu_Viaje") AND Arguments.nu_Viaje NEQ ''>
            <cfset Local.requisicion.nu_Viaje=Arguments.nu_Viaje>
        </cfif>

        <cfif isDefined("Arguments.nu_siniestro") AND Arguments.nu_siniestro NEQ ''>
            <cfset Local.requisicion.nu_siniestro=Arguments.nu_siniestro>
        </cfif>

        <cfif isDefined("Arguments.ar_soporte") AND Arguments.ar_soporte NEQ ''>
            <cfset Local.requisicion.ar_soporte=Arguments.ar_soporte>
        </cfif>

        <cfif isDefined("Arguments.im_totalRequisicion") AND Arguments.im_totalRequisicion NEQ ''>
            <cfset Local.requisicion.im_PrecioTotal=Arguments.im_totalRequisicion>
        </cfif>
        <cfif isDefined("Arguments.id_Proveedor") AND Arguments.id_Proveedor NEQ ''>
            <cfset Local.requisicion.id_Proveedor=Arguments.id_Proveedor>
        </cfif>
        <cfif isDefined("Arguments.de_Observaciones") AND Arguments.de_Observaciones NEQ ''>
            <cfset Local.requisicion.de_Observaciones=Arguments.de_Observaciones>
        </cfif>
        <cfif isDefined("Arguments.id_TipoInstalacion") AND Arguments.id_TipoInstalacion NEQ ''>
            <cfset Local.requisicion.id_TipoInstalacion=Arguments.id_TipoInstalacion>
        <cfelse> 
            <cfset Local.requisicion.id_TipoInstalacion=''>
        </cfif>

        <!--- se pregunta de que estatus viene la requisicion para saber a que estatus pasara,
                esto por el cambio de darle seguimiento a una requisicion si fue rechazada
                (4) rechazada si viene de rechazo se pasa al estatus de editada (6) y si biene de editada (6) ovio se quedara como editada o
                si esta devuelta (10), pasa a estar editada (6)--->
        <cfif arguments.estatus EQ 4 OR arguments.estatus EQ 6 OR arguments.estatus EQ 10>
            <cfset Local.requisicion.id_EstatusAutorizacion = 6><!--- editada despues de venir de un rechazo --->
        <cfelse>
            <cfset Local.requisicion.id_EstatusAutorizacion = 1><!--- se da por hecho que la estas editando por primera vez o se que esta en borrador --->
        </cfif>

        <cfset Local.requisicion.id_EstatusSurtido=3><!--- Sin surtir --->

        <!--- Antes de realizar la actualizacion, revisamos si el detalle tuvo cambios y registrarlos en el historial de cambios  --->
        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
            method="getByIdRequisicion"
            id_empresa="#arguments.id_empresa#"
            id_requisicion="#arguments.ID_REQUISICION#"
            returnvariable="Local.Detalle">

        <!--- <cfloop array="#arguments.detalleRequisicion#" index="newDet">
            <!--- El detalle de requisicion debe de existir --->
            <cfif newDet.id_RequisicionDetalle NEQ ''>
                <cfloop query="#Local.Detalle#">
                    <cfif newDet.id_RequisicionDetalle EQ Local.Detalle.id_RequisicionDetalle>
                        <!--- Si la cantidad, el grupo centro de costo o el centro de costo es diferente, guardamos el registro --->

                        <cfif Local.Detalle.nu_Cantidad NEQ newDet.nu_Cantidad OR
                            Local.Detalle.id_GrupoCentroCosto NEQ newDet.id_GrupoCentroCosto OR
                            Local.Detalle.id_CentroCosto NEQ newDet.id_CentroCosto>

                            <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                                method="guardarCambiosHistorial"
                                id_Empresa="#Arguments.id_Empresa#"
                                id_SucursalCentroCosto="#local.requisicion.ID_SUCURSALSOLICITA#"
                                id_Requisicion="#arguments.ID_REQUISICION#"
                                id_RequisicionDetalle="#Local.Detalle.id_RequisicionDetalle#"
                                id_Insumo="#Local.Detalle.id_Insumo#"
                                im_PrecioUnitario="#Local.Detalle.im_PrecioUnitario#"
                                id_Moneda="#Local.Detalle.id_Moneda#"
                                im_TipoCambio="#Local.Detalle.im_TipoCambio#"
                                id_CentroCosto="#newDet.id_CentroCosto#"
                                id_GrupoCentroCosto="#newDet.id_GrupoCentroCosto#"
                                nu_Cantidad="#newDet.nu_Cantidad#"
                                nu_Kilometraje="#Local.Detalle.nu_kilometraje#"
                                de_Colaborador="#Local.Detalle.de_colaborador#"
                                sn_ShowComments="#1#" <!--- Editado --->
                                sn_NewItem="#0#"
                                de_ComentariosMovimientos="Insumo Editado - Requisición antes del envío">
                        </cfif>

                        <cfbreak> <!-- Salir del loop cuando encontramos el valor -->
                    </cfif>
                </cfloop>
            </cfif>
        </cfloop> --->

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="editar"
            argumentcollection="#Local.requisicion#">

        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalleCamposDetalle')#"
            method="deletebyrequisiciondetallecampo"
            id_empresa="#Arguments.id_Empresa#"
            id_requisicion="#Local.requisicion.id_Requisicion#">

        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
            method="deleteByRequisicion"
            id_empresa="#Arguments.id_Empresa#"
            id_requisicion="#Local.requisicion.id_Requisicion#">

        <cfset Local.detalleRequisicion = structNew()>
        <cfset Local.funcion = createObject("component","#Application.RF.getPath('cfc','funciones')#") >
        <cfloop array="#Arguments.detalleRequisicion#" index="Local.detalle">

            <cfset structClear(Local.detalleRequisicion)>
            <cfset Local.detalleRequisicion.id_Empresa = Local.requisicion.id_Empresa>
            <cfset Local.detalleRequisicion.id_Requisicion = Local.requisicion.id_Requisicion>
            <cfset Local.detalleRequisicion.id_Insumo = Local.detalle.id_Insumo>
            <cfset Local.detalleRequisicion.nu_Cantidad = Local.detalle.nu_Cantidad>
            <cfset Local.detalleRequisicion.im_PrecioUnitario = Local.funcion.unformatNumber(Local.detalle.im_PrecioUnitario)>
            <cfset Local.detalleRequisicion.nu_CantidadSurtida = 0>
            <cfset Local.detalleRequisicion.id_EstatusSurtido = 3>
            <cfset Local.detalleRequisicion.id_moneda = Local.detalle.id_moneda>
            <cfset Local.detalleRequisicion.im_tipoCambio = Local.funcion.unformatNumber(Local.detalle.im_tipoCambio)>

            <cfif #id_TipoRequisicion# EQ '1'>
                <cfset Local.detalleRequisicion.id_SucursalCentroCosto = Local.detalle.id_SucursalCentroCosto>
            </cfif>

            <cfif isDefined("Local.detalle.id_GrupoCentroCosto")>
                <cfset Local.detalleRequisicion.id_GrupoCentroCosto=Local.detalle.id_GrupoCentroCosto>
            </cfif>

            <cfif isDefined("Local.detalle.id_CentroCosto")>
                <cfset Local.detalleRequisicion.id_CentroCosto = Local.detalle.id_centroCosto>
            </cfif>

            <cfif isDefined("Local.detalle.id_SucursalCentroCosto")>
                <cfset Local.detalleRequisicion.id_SucursalCentroCosto = Local.detalle.id_SucursalCentroCosto>
            </cfif>

            <cfif isDefined("Local.detalle.id_grupoGasto")>
                <cfset Local.detalleRequisicion.id_grupoGasto = Local.detalle.id_grupoGasto>
            </cfif>
            <cfif isDefined("Local.detalle.id_conceptoGasto")>
                <cfset Local.detalleRequisicion.id_conceptoGasto = Local.detalle.id_conceptoGasto>
            </cfif>
            <cfset Local.detalleRequisicion.nu_kilometraje=Local.detalle.nu_kilometraje>
            <cfset Local.detalleRequisicion.de_colaborador=Local.detalle.de_colaborador>

            <cfif isDefined('Local.detalle.id_Direccion')>
                <cfset Local.detalleRequisicion.id_Direccion = Local.detalle.id_Direccion>
            </cfif>

            <cfif isDefined('Local.detalle.id_TipoInstalacion')>
                <cfset Local.detalleRequisicion.id_TipoInstalacion = Local.detalle.id_TipoInstalacion>
            </cfif>

            <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                      method="AgregarDetalle"
                      argumentcollection="#Local.detalleRequisicion#"
                      returnvariable="local.reqdet">

            <!--- <cfif Local.detalle.id_RequisicionDetalle EQ ''>
                <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                    method="guardarCambiosHistorial"
                    id_Empresa="#Local.detalleRequisicion.id_Empresa#"
                    id_SucursalCentroCosto="#Local.detalleRequisicion.id_SucursalCentroCosto#"
                    id_Requisicion="#Local.detalleRequisicion.id_Requisicion#"
                    id_RequisicionDetalle="#local.reqdet.id_requisiciondetalle#"
                    id_Insumo="#Local.detalleRequisicion.id_Insumo#"
                    im_PrecioUnitario="#Local.detalleRequisicion.im_PrecioUnitario#"
                    id_Moneda="#Local.detalleRequisicion.id_moneda#"
                    im_TipoCambio="#Local.detalleRequisicion.im_tipoCambio#"
                    id_CentroCosto="#Local.detalleRequisicion.id_CentroCosto#"
                    id_GrupoCentroCosto="#Local.detalleRequisicion.id_GrupoCentroCosto#"
                    nu_Cantidad="#Local.detalleRequisicion.nu_Cantidad#"
                    nu_Kilometraje="#Local.detalleRequisicion.nu_kilometraje#"
                    de_Colaborador="#Local.detalleRequisicion.de_colaborador#"
                    sn_ShowComments="#1#"
                    sn_NewItem="#1#" <!--- Nuevo --->
                    de_ComentariosMovimientos="Insumo Nuevo - Requisición antes del envío">
            </cfif> --->

            <cfif local.detalle.sn_activofijo eq 'true'>
                <cfif #isDefined('local.detalle.CAMPOS')#>
                    <cfloop from="1" to="#arrayLen(local.detalle.CAMPOS)#" index="local.p">
                        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalleCamposDetalle')#"
                                  method="Agregar"
                                  id_empresa="#Arguments.id_empresa#"
                                  id_requisicion ="#Local.requisicion.id_requisicion#"
                                  id_requisiciondetalle ="#local.reqdet.id_requisiciondetalle#"
                                  id_campodetalle ="#local.detalle.CAMPOS[local.p].id_campodetalle#"
                                  nb_campodetalle="#local.detalle.CAMPOS[local.p].nb_campodetalle#"
                                  de_valorcampodetalle="#local.detalle.CAMPOS[local.p].de_valorcampodetalle#">
                    </cfloop>
                </cfif>
            </cfif>
        </cfloop>

        <cfreturn variables.RBR />
    </cffunction>

    <cffunction name="Eliminar" access="public" returntype="any">
        <cfargument name="id_requisicion"            type="string" required="true"/>

                <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                          method="RSEliminar"
                          id_empresa="#session.ID_EMPRESA#"
                          id_requisicion="#Arguments.id_requisicion#">

        <cfreturn variables.RBR />
    </cffunction>

    <cffunction name="getFechaRegistro" access="public" returntype="Any">
        <cfargument name='id_Empresa'       type='numeric' required='false'>
        <cfargument name='id_Requisicion'   type='numeric' required='yes'>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="getFechaRegistro"
                  id_Empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.rs">

        <cfset Local.data=structNew()>
        <cfset Local.data.fh_registro=Local.rs.fh_ExpedicionFormat>

        <cfset variables.RBR.setData(Local.data)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- Se agregaron dos nuevos campos en requisionesDetalle id_grupoGasto e id_conceptoGasto, aun no estan incluidos en el reporte --->
    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="requisicion"        type="query" required="true">
        <cfargument name="requisicionDetalle" type="query"  required="true">
        <cfargument name="estatus"            type="numeric"  required="true">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteAutorizacionRequisicion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicion.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteAutorizacionRequisicion#"
                  pdf="requisicion#Arguments.requisicion.id_requisicion#"
                  debug="no"
                  path="#expandPath('/root/Reportes/')#">

        <cfreturn Variables.RBR>
    </cffunction>


    <!--- Se agregaron dos nuevos campos en requisionesDetalle id_grupoGasto e id_conceptoGasto, aun no estan incluidos en el reporte --->
    <cffunction name="crearReporteNotificacion" access="public" returntype="any">
        <cfargument name="requisicion"        type="query" required="true">
        <cfargument name="requisicionDetalle" type="query"  required="true">
        <cfargument name="estatus"            type="numeric"  required="true">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteNotificacionRequisicion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicionNotificar.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteNotificacionRequisicion#"
                  pdf="requisicionNotif#Arguments.requisicion.id_requisicion#"
                  path="#expandPath('/root/Reportes/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <cffunction name="listadoRequisicionesFiltro" access="public" returntype="Any">
        <cfargument name='nb_Empleado'     type='string' required='false'>
        <cfargument name='nb_Sucursal'     type='string' required='false'>
        <cfargument name='fecha'            type='string' required='false'>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                 argumentcollection="#arguments#"
                  method="listadoRequisicionesFiltro"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez
        27/10/2015 --->
    <cffunction name="upL_RequisicionesDetalleEntradaDevolucionSalida" access="public" returntype="Any">
        <cfargument name='id_Empresa'      type='numeric' required='true'>
        <cfargument name='id_Requisicion'     type='numeric' required='true'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="upL_RequisicionesDetalleEntradaDevolucionSalida"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_requisicion="#Arguments.id_Requisicion#"
                  returnvariable="Local.rs">


        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="updateEstatusAutorizacion" access="public" returntype="Any">
        <cfargument name='id_Requisicion'         type='numeric' required='true'>
        <cfargument name='id_EstatusAutorizacion' type='numeric' required='true'>
        <cfargument name='id_Empresa'               type='numeric' required='true'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="updateEstatusAutorizacion"
                  <!---id_Empresa="#session.ID_EMPRESA#"--->
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="seguimientoRequisicion" access="public" returntype="Any">
        <cfargument name='id_Empresa'       type='string' required='yes'>
        <cfargument name='tipoBusqueda'     type='string' required='false' default="1">
        <cfargument name='id_Requisicion'   type='string' required='yes'>

        <cfif arguments.tipoBusqueda EQ 1>

            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="seguimientoRequisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfelseif arguments.tipoBusqueda EQ 2>

            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="seguimientoSolicitudCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfelseif arguments.tipoBusqueda EQ 3>

            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="seguimientoRequisicionCMF"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        </cfif>



        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="SolicitudCompraPorStock" access="public" returntype="any">
        <cfargument name='id_empresa'           type='string'   required='yes'>
        <cfargument name='id_solicitudcompra'   type='string'   required='yes'>

        <cfinvoke   component="#Application.RF.getPath('dao','Requisiciones')#"
                    method="SolicitudCompraPorStock"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs" >

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- Se agregaron dos nuevos campos en requisionesDetalle id_grupoGasto e id_conceptoGasto, aun no estan incluidos en el reporte --->
    <cffunction name="reporteRequisicion" access="public" returntype="any">

        <cfargument name='id_requisicion'   type='string' required='yes'>
        <cfargument name='estatus'          type="numeric"  required='false'>
        <cfargument name='id_Empresa'         type='numeric' required='true'>


        <!--- Nos traemos los datos de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="getById"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.requisicion">

        <!--- Nos traemos el detalle de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                  method="getByIdRequisicion"
                  id_empresa="#Arguments.id_empresa#"
                  id_requisicion="#Arguments.id_requisicion#"
                  returnvariable="Local.detalleRequisicion">
        <!--- Nos traemos la imagen de la empresa de donde es la remision  anteriomente se estaba tomando la imagen de la empresa session --->
        <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                  method="listar"
                  id_empresa="#Arguments.id_empresa#"
                  returnvariable="Local.imgEmpresa">

        <cfset arguments.requisicion = Local.requisicion>
        <cfset arguments.requisicionDetalle = Local.detalleRequisicion>
        <cfset arguments.imagenRequisicion = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.imgEmpresa.ar_ImagenLogo#">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="requisicion#Arguments.requisicion.id_requisicion#"
        }>
        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteAutorizacionRequisicion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicionImp.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteAutorizacionRequisicion#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('/root/Reportes/')#">

         <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
         <cfset Local.infoReport.ar_archivoPDF=#reporteAutorizacionRequisicion#>
        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>

    </cffunction>


    <cffunction name="FinalizarRequisicion" access="public" returntype="Any">
        <cfargument name='id_Requisicion'         type='numeric' required='true'>
        <cfargument name='id_EstatusAutorizacion' type='numeric' required='true'>
        <cfargument name='id_Empresa'             type='numeric' required='true'>
        <cfargument name='de_ComentariosFinaliza' type='string'  required='false' default="">

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="FinalizarRequisicion"
            id_Empresa="#Arguments.id_Empresa#"
            id_Usuario="#session.ID_USUARIO#"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">
        
        <!--- Verificar si existe en tabla de Obras en Proceso para guardar la fh de surtido materiales--->
         <!---   <cfinvoke component="#Application.RF.getPath('dao','SeguimientoObrasProceso')#"
                method="guardarFechaFinConstruccion"
                id_Empresa="#arguments.id_Empresa#"
                id_Requisicion="#arguments.id_Requisicion#"
                id_Usuario = "#session.ID_USUARIO#"
                >
                --->

    <!--- GENERAMOS LA NOTIFICACION --->

        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
            method="obtener_requisicion"
            id_empresa     = "#Arguments.id_empresa#"
            id_requisicion = "#Arguments.id_requisicion#"
            returnvariable="Local.destinatarios">

        <cfset local.destinatariosAutorizan = arrayNew(1)>

        <!--- Validación del Correo --->
        <cfif StructKeyExists(Local.destinatarios, "de_Email") AND Local.destinatarios.de_Email NEQ '' AND Local.destinatarios.de_Email NEQ nullValue()>
            <cfset arrayAppend(local.destinatariosAutorizan, Local.destinatarios.de_Email)>
            <cfset Local.DatosCorreo ={
                Asunto    = 'Requisición Finalizada.',
                Contenido = 'La requisición ' & #Arguments.id_Requisicion# & ' Realizada por ' & #session.NB_RAZONSOCIAL# & "/" & Local.destinatarios.nb_Sucursal & " ha sido finalizada. <br><br> Comentarios:<br>" & #Arguments.de_ComentariosFinaliza#
            }>

            <cfset Local.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                <!--- {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer",
                    isLocal:true
                } --->
            ]>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#local.destinatariosAutorizan#"
                asunto="Requisición Finalizada."
                parametros="#local.DatosCorreo#"
                imagenes="#Local.imagenes#"
                sn_plantilla="YES"
                dir_plantilla = "templates/correos/notificaciones/global.html"
                returnvariable="Local.rbr"/>

            <cfif Local.rbr.hasError()>
                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                <cfreturn variables.RBR>
            </cfif>
        </cfif>

        <cfif local.rs.OrdenesCompra.recordCount EQ 0>
            <cfreturn variables.RBR>
        </cfif>

        <!--- Hacemos un loop de las OC que se afectaron --->
        <cfloop query="local.rs.OrdenesCompra">
            <cfset local.Emails = structNew()>
            <cfloop query="Local.rs.Autorizadores"> <!--- Hacemos un listado de todas las OC para buscar los correos que corresponde --->
                <cfif Local.rs.OrdenesCompra.id_OrdenDeCompra EQ Local.rs.Autorizadores.id_OrdenDeCompra>
                    <cfset arrayAppend(local.Emails, Local.rs.Autorizadores.de_Email)>
                </cfif>
            </cfloop>

            <cfset Local.DatosCorreo = {
                Asunto    = 'Requisición Finalizada - Orden De Compra Cancelada.',
                Contenido = 'La Orden de Compra ' & #Local.rs.OrdenesCompra.id_OrdenDeCompra# & " a sido cancelada. <br>Esto se debe a la finalización de la requisición en la que tuvo origen."
            }>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                method="sendMail"
                destinatarios="#local.Emails#"
                asunto="Requisición Finalizada - Orden De Compra Cancelada."
                parametros="#local.DatosCorreo#"
                imagenes="#Local.imagenes#"
                sn_plantilla="YES"
                dir_plantilla = "templates/correos/notificaciones/global.html"
                returnvariable="Local.rbr2"/>

            <cfif Local.rbr2.hasError()>
                <cfset Variables.RBR.setError(Local.rbr2.getMessage())>
                <cfreturn variables.RBR>
            </cfif>
        </cfloop>

        <!--- Eliminamos los registros de recordatorio de la requisicion --->
        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicionConsultaAlmacen')#"
            method="RequisicionesEliminarRecordatorio"
            id_Empresa="#Arguments.id_empresa#"
            id_Requisicion="#Arguments.id_requisicion#">

        <cfreturn variables.RBR>
    </cffunction><!--- GENERAMOS LA NOTIFICACION --->


    <cffunction name="listarInsumosAyuda" access="public" returntype="Any">
        <cfargument name="id_Insumo"           type="string" required="false">
        <cfargument name="nb_Nombre"           type="string" required="false">
        <cfargument name="id_FamiliaInsumo"    type="string" required="false">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false">
        <cfargument name="id_Empresa"          type="string" required="false">
        <cfargument name="id_Sucursal"         type="string" required="false">
        <cfargument name="id_tipoSolicitud"    type="string" required="false">


        <!--- VERIFICAR QUE LA PERSONA - DEPARTAMENTO TENGA CONFIGURACION --->

        <cfinvoke component="#Application.RF.getPath('dao','ConfigInsumoDepartamentoColaborador')#"
                method="getExisteConfiguracion"
                id_Empresa = "#arguments.id_Empresa#"
                id_Sucursal = "#arguments.id_Sucursal#"
                id_Empleado = "#SESSION.ID_EMPLEADO#"
                id_FamiliaInsumo = "#arguments.id_FamiliaInsumo#"
                id_SubFamiliaInsumo = "#arguments.id_SubFamiliaInsumo#"
                returnvariable="Local.listadoInsumos"> 

        <cfif Local.listadoInsumos.RecordCount GT 0>

            <cfinvoke component="#Application.RF.getPath('dao','ConfigInsumoDepartamentoColaborador')#"
                    method="getConfiguracionInsumosRequisicion"
                    id_Empresa = "#arguments.id_Empresa#"
                    id_Sucursal = "#arguments.id_Sucursal#"
                    id_Empleado = "#SESSION.ID_EMPLEADO#"
                    id_FamiliaInsumo = "#arguments.id_FamiliaInsumo#"
                    id_SubFamiliaInsumo = "#arguments.id_SubFamiliaInsumo#"
                    id_Insumo = "#arguments.id_Insumo#"
                    nb_NombreInsumo = "#arguments.nb_Nombre#"
                    id_TipoSolicitud = "#arguments.id_tipoSolicitud#"
                    returnvariable="Local.rs">

        <cfelse>

            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="listarInsumosAyuda"
                argumentcollection="#arguments#"
                id_Usuario="#session.ID_USUARIO#"
                id_Puesto="#session.ID_PUESTO#"
                returnvariable="Local.rs">

        </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GuardarCMF" access="public" returntype="Any">
        <cfargument name="id_Requisicion"       type="string"  required="false" default="">
        <cfargument name="id_Empresa"           type="string"  required="false">
        <cfargument name="id_Sucursal"          type="string"  required="false">
        <cfargument name="id_Proveedor"         type="string"  required="false">
        <cfargument name="id_Concepto"          type="string"  required="false">
        <cfargument name="im_SubTotal"          type="string"  required="false">
        <cfargument name="im_Descuento"         type="string"  required="false">
        <cfargument name="im_Iva"               type="string"  required="false">
        <cfargument name="im_Retencion"         type="string"  required="false">
        <cfargument name="im_Total"             type="string"  required="false">
        <cfargument name="id_Estatus"           type="string"  required="false">
        <cfargument name="fh_Entrega"           type="string"  required="false">
        <cfargument name="Conceptos"            type="array"   required="false">
        <cfargument name="dataXML"              type="struct"  required="false">
        <cfargument name="dataPDF"              type="struct"  required="false">
        <cfargument name="sn_Enviar"            type="boolean" required="false">
        <cfargument name="sn_Modificar"         type="boolean" required="false" default="false">
        <cfargument name="de_tipoFactor"        type="string"  required="false">
        <cfargument name="id_TipoComprobante"   type="string"  required="false">
        <cfargument name="Impuestos"            type="array"   required="false">
        <cfargument name="de_ComentariosOC"     type="string"  required="false">

        <cfif #arguments.dataXML.sn_Mod NEQ 0#>
            <!--- Leemos y validamos que Xml este correcto --->
            <cfset xmlFile = expandPath("/root/#arguments.dataXML.de_Ruta##arguments.dataXML.nb_Archivo#")>
            <cfset xmlString = ''>
            <cffile action="Read" file="#xmlFile#" variable="XMLContent">

            <cfif isXML(XMLContent)>
                <cfset xmlString = XmlParse(XMLContent)>
            <cfelse>
            <!--- El Archivo XML esta dañado --->
                <cfset variables.rbr.seterror('El documento XML no se pudo leer o el archivo esta dañado. Favor de varificar.')>
                <cfreturn variables.rbr>
            </cfif>
            <cfset XMLStringLimpio = REReplace(toString(xmlString), "^[^<]*", "", "all" )>

            <cftry>
                <!--- Primer intento con el String del XML Limpio --->
                <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                        method="parseStringToXML"
                        XML_CFDI = "#XMLStringLimpio#"
                        returnvariable="ResponseXML" />

                <cfcatch type="any">
                    <cftry>
                        <!--- Segundo intento con el contenido original del documento XML --->
                        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                            method="parseStringToXML"
                            XML_CFDI = "#XMLContent#"
                            returnvariable="ResponseXML"/>
                        <cfcatch type="any">
                            <!---
                                En este punto no se pudo leer el xml en base de datos,
                                sin embargo ya se valido que el archivo en si es un XML valido para lucee

                                Pedirle al usuario que envie el correo a soporte sistemas para verificar
                                el contenido del XML por en busca de caracteres raros mal escapados o errores de formato
                            --->
                            <cfset local.ErrorMSG = '<b>La informaciOn del XML no se pudo leer de forma correcta.</b>'>
                            <cfset local.ErrorMSG &= '<br><br>Favor de solicitar apoyo al personal de Sistemas Desarrollo o via correo electronico dirigido a soportessipp@petroil.com.mx adjuntando el archivo XML que presenta el problema.'>
                            <cfset variables.rbr.setError(local.ErrorMSG)>
                            <cfreturn variables.rbr>
                        </cfcatch>
                    </cftry>
                </cfcatch>
            </cftry>

            <cfif #ResponseXML.documento.UUID EQ nullValue()#>
                <!---/**
                 * Si no trae el UUID, significa que no lo pudo leer adecuadamente
                 * por lo que realizamos la lectura por BD
                 */--->
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProductosProveedores')#"
                        method="upR_Parse_XML_Proveedores"
                        DE_XML = "#ResponseXML.documento.de_XML#"
                        returnvariable="doc">

                        <cfset ResponseXML.documento = doc.Documento >
            </cfif>

            <cfset #arguments.de_RutaXml# = #arguments.dataXML.de_Ruta#>
            <cfset #arguments.nb_ArchivoXml# = "F_#ResponseXML.documento.UUID#.xml">
            <cfset #arguments.de_Xml# = #ResponseXML.documento.de_xml#>
            <cfset #arguments.de_Folio# = #ResponseXML.documento.folio#>
            <cfset #arguments.de_RutaPdf# = #arguments.dataPDF.de_Ruta#>
            <cfset #arguments.nb_ArchivoPdf# = #arguments.dataPDF.nb_Archivo#>
            <cfset #arguments.de_Serie# = #ResponseXML.documento.serie#>
            <cfset #arguments.de_FormaPago# = #ResponseXML.documento.formaDePago#>
            <cfset #arguments.de_TipoComprobante# = #ResponseXML.documento.tipoDeComprobante#>
            <cfset #arguments.de_MetodoPago# = #ResponseXML.documento.metodoDePago#>
            <cfset #arguments.de_LugarExpedicion# = #ResponseXML.documento.LugarExpedicion#>

        <cfelse> <!--/** Si no se modifica el xml, se mandas sus datos en null */-->
            <cfset #arguments.de_RutaXml# = nullValue()>
            <cfset #arguments.nb_ArchivoXml# = nullValue()>
            <cfset #arguments.de_Xml# = nullValue()>
            <cfset #arguments.de_Folio# = nullValue()>
            <cfset #arguments.de_RutaPdf# = nullValue()>
            <cfset #arguments.nb_ArchivoPdf# = nullValue()>
            <cfset #arguments.de_Serie# = nullValue()>
            <cfset #arguments.de_FormaPago# = nullValue()>
            <cfset #arguments.de_TipoComprobante# = nullValue()>
            <cfset #arguments.de_MetodoPago# = nullValue()>
            <cfset #arguments.de_LugarExpedicion# = nullValue()>
        </cfif>

        <!---/**
         * Se hace la subida de la requisicion de carga masiva
         * Empezando por el registro en Requisiciones_CargaMasiva
         */--->
        <cfset #arguments.id_Usuario# = #SESSION.ID_USUARIO#>

        <cfif #arguments.sn_Modificar EQ true#>
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                      method="ModificarCMF"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

            <!--- Eliminamos los impuestos existentes --->
            <cfinvoke component="#Application.RF.getPath('dao', 'Impuestos')#"
                    method="EliminarImpuestosCMF"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Requisicion="#local.rs.ID_REQUISICION#">
        <cfelse>
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                      method="GuardarCMF"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">
        </cfif>

        <!--- Insertamos los impuestos registrados para la requisicion --->
        <cfloop array="#arguments.Impuestos#" index="local.i">
            <cfif local.i.keyExists('ID_TAZA')>
                <cfinvoke component="#Application.RF.getPath('dao', 'Impuestos')#"
                    method="GuardarImpuestosCMF"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Requisicion="#local.rs.ID_REQUISICION#"
                    id_Impuesto="#local.i.ID_IMPUESTO#"
                    id_Taza="#local.i.ID_TAZA#"
                    nu_Taza="#local.i.PJ_APLICABLE#"
                    im_Impuesto="#local.i.IM_IMPORTE#"
                    cl_Naturaleza="#local.i.CL_NATURALEZA#">
            </cfif>
        </cfloop>

        <!---/** Pregunta si es que es los archivos fueron cambiados */--->
        <cfif #arguments.dataXML.sn_Mod NEQ 0#>
            <!---/**
                * Se prepara la inforamcion de los archivos para su subida a la nube
                * empieza con el XML
                */--->
            <cfset xml               = structNew()>
            <!---                                   var/www/uploads/temp/       F_0F1E9A5C-2100-40CF-AD61-88D6F1FFEB11.xml --->
            <cfset pathLocalXML = expandPath("/root/#arguments.dataXML.de_Ruta##arguments.dataXML.nb_Archivo#")>
            <cfset xml.de_Ruta   = "Documentos/Proveedores/CargaMasivaFacturas/#local.rs.ID_EMPRESA#/#local.rs.ID_REQUISICION#/">

            <cfif #IsDefined("ResponseXML.documento.UUID")#>
                <cfset xml.UUID    = "#ResponseXML.documento.UUID#">
            </cfif>

            <cfif isDefined("xml.UUID")>
                    <cfset xml.nb_Archivo = "F_#xml.UUID#.xml">
                <cfelse>
                    <cfset xml.nb_Archivo = #arguments.nb_ArchivoXml#>
            </cfif>

            <cfset argsSubirArchivoXML = structnew()>
            <cfset argsSubirArchivoXML.fileField = pathLocalXML>
            <cfset argsSubirArchivoXML.nb_archivo = xml.nb_Archivo>
            <cfset argsSubirArchivoXML.de_PathDestino = xml.de_Ruta>
            <cfset argsSubirArchivoXML.rename = false>

            <!---/**
                * Continua con el PDF
                */--->
            <!---/** Leemos el archivo pdf para verificar si viene correctamente */--->
            <!---                         /root/    uploads/temp/           ooE6x2CoMX_ABA_MAZATLAN_FacturaB-1523.pdf--->
            <cfset pdfFile = expandPath("/root/#arguments.dataPDF.de_Ruta##arguments.nb_ArchivoPdf#")>
            <cffile action="Read" file="#pdfFile#" variable="PDFContent">

            <cfset pathLocalPDF = "/root/#arguments.dataPDF.de_Ruta##arguments.nb_ArchivoPdf#">

            <cfif isDefined("xml.UUID")>
                <cfset xml.de_NombrePDF = "F_#xml.UUID#.pdf">
            <cfelse>
                <cfset xml.de_NombrePDF = #arguments.nb_ArchivoPdf#>
            </cfif>

            <cfset argsSubirArchivoPDF = structnew()>
            <cfset argsSubirArchivoPDF.fileField = pathLocalPDF>
            <cfset argsSubirArchivoPDF.nb_archivo = xml.de_NombrePDF>
            <cfset argsSubirArchivoPDF.de_PathDestino = xml.de_Ruta>
            <cfset argsSubirArchivoPDF.rename = false>

            <!---/**
                * Una ves validado se realiza la subida
                */--->
            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                      method="subirArchivoGoogle"
                      argumentcollection="#argsSubirArchivoXML#"
                      returnvariable="RSFileUploadXML">


                      <!--- <cfcontent type="text/html">
                      <cfdump var="#argsSubirArchivoPDF#" format="simple" label="arguments" abort="true"> --->

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                      method="subirArchivoGoogle"
                      argumentcollection="#argsSubirArchivoPDF#"
                      returnvariable="RSFileUploadPDF">

            <!---/**
            * Actualiza las rutas de los archivos en base de datos
            */--->
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="updateRoutes"
                id_Empresa="#local.rs.ID_EMPRESA#"
                id_Requisicion="#local.rs.ID_REQUISICION#"
                nb_archivoXml = "#xml.nb_archivo#"
                de_rutaXml = "#xml.de_Ruta#"
                nb_archivoPdf = "#xml.de_NombrePDF#"
                de_rutaPdf = "#xml.de_Ruta#">

            <cfif FileExists(pathLocalXML)>
                <cffile action="delete" file="#pathLocalXML#">
            </cfif>
            <cfif FileExists(pathLocalPDF)>
                <cffile action="delete" file="#pathLocalPDF#">
            </cfif>
        </cfif>

        <!---/**
         * Si se esta modificando, primero elimina los detalles existentes
         */--->
        <cfif #arguments.sn_Modificar EQ true#>
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                      method="EliminarDetallesCMF"
                      id_Empresa="#local.rs.ID_EMPRESA#"
                      id_Requisicion="#local.rs.ID_REQUISICION#">

        </cfif>
        <!---/**
         *  Se realiza la subida de los detalles de la factura
         */--->
        <cfloop array="#arguments.Conceptos#" index="local.i">
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="GuardarDetalleCMF"
                id_Empresa="#local.rs.ID_EMPRESA#"
                id_Requisicion="#local.rs.ID_REQUISICION#"
                id_Insumo="#local.i.ID_INSUMO#"
                de_descripcion="#local.i.DE_DESCRIPCION#"
                nu_cantidad="#local.i.NU_CANTIDAD#"
                im_preciounitario="#local.i.IM_PRECIOUNITARIO#"
                im_Subtotal="#local.i.IM_SUBTOTAL#"
                im_Descuento="#local.i.IM_DESCUENTO#"
                nb_moneda="#local.i.NB_MONEDA#"
                im_Retencion="#local.i.IM_RETENCION#"
                id_centrocosto="#local.i.ID_CENTROCOSTO#"
                nd_Detalle="#local.i.ND_DETALLE#">
        </cfloop>

        <cfif arguments.sn_Enviar>
            <!---/**
             *   Proceso a realizar cuando se envie
             */--->
            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                      method="EnviarRequisicionCMF"
                      id_Empresa="#local.rs.ID_EMPRESA#"
                      id_Requisicion="#local.rs.ID_REQUISICION#">
        </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GetRequisicionCMFById" access="public" returntype="Any">
        <cfargument name='id_Empresa'       type='string'  required='false'>
        <cfargument name='id_Requisicion'   type='numeric' required='false'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="GetRequisicionCMFById"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <!---/**
         * Con la informacion general del registro se obtiene el archivo xml
         */--->
        <cfif (#local.rs.gral.RecordCount# EQ 0) OR (#LEN(Local.rs.gral.de_Xml)# EQ 0)>
            <cfset variables.RBR.setError('No se encontro el documento en el servidor.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset Local.documento = structNew()>
        <cfset #Local.documento.nb_archivo# = Local.rs.gral.nb_ArchivoXml>
        <cfset #Local.documento.de_rutaXML# = expandPath('../'&#Local.rs.gral.de_RutaXml#&'/'&#Local.documento.nb_archivo#)>
        <cfset #Local.documento.de_ruta# = #Local.rs.gral.de_RutaXml#>

        <!---/** obtenemos el documento Xml */--->
        <cfset XMLContent = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.documento.de_ruta##Local.documento.nb_archivo#">

        <cfset argsObtenerArchivoXML = structnew()/>
        <cfset argsObtenerArchivoXML.path = "#Local.documento.de_ruta##Local.documento.nb_archivo#"/>
        <cfset argsObtenerArchivoXML.getContent = true/>

        <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
            method="obtenerArchivo"
            argumentcollection="#argsObtenerArchivoXML#"
            returnvariable="RSExistsXML">

        <cfif RSExistsXML.ISOK EQ false>
            <cfset variables.rbr.seterror(#RSExistsXML.MSG#)>
            <cfreturn variables.rbr>
        <cfelse>
            <cfset Local.rs.dataXML.CONTENT = #RSExistsXML.DATA.CONTENT#>
            <cfset Local.rs.dataXML.FILENAME = #RSExistsXML.DATA.ORIGINAL_FILENAME#>
            <cfset Local.rs.dataXML.URI = #RSExistsXML.DATA.URI#>
        </cfif>

        <!---/**
         * Con la informacion general del registro se obtiene el archivo pdf
         */--->
        <cfset #Local.rs.dataPDF.nb_archivo# = #Local.rs.gral.nb_ArchivoPdf#>
        <cfset #Local.rs.dataPDF.de_ruta# = #Local.rs.gral.de_RutaPdf#>

        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EnviarRequisicionCMF" access="public" returntype="Any">
        <cfargument name='id_Empresa'       type='numeric' required='false'>
        <cfargument name='id_Requisicion'   type='numeric' required='false'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="EnviarRequisicionCMF"
                  argumentcollection="#arguments#">

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EstatusCMF" access="public" returntype="Any">
        <cfargument name='id_Empresa'           type='numeric' required='false'>
        <cfargument name='id_RequisicionCMF'    type='numeric' required='false'>
        <cfargument name='id_Estatus'           type='numeric' required='false'>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="EstatusCMF"
                  argumentcollection="#arguments#">

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="SucursalesAccesoEmpleadosCombo_Requisiciones" access="public" returntype="Any">
      <cfargument name="id_Empresa"       type="string" required="false"/>

      <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="SucursalesAccesoEmpleadosCombo_Requisiciones"
                id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
                id_Empleado="#SESSION.ID_EMPLEADO#"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

      <cfset variables.RBR.setQuery(Local.rs)>
      <cfreturn variables.RBR>
  </cffunction>

    <cffunction name="getHistorialRequisicion" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>
        <cfargument name="id_Empleado"    type="string" required="false"/>
        <cfargument name="id_Insumo"      type="string" required="false"/>
        <cfargument name="id_TipoMovimiento"     type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getHistorialRequisicion"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getHistorialRequisicion_Filtros" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getHistorialRequisicion_Filtros"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setData(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="TiposRequisicionesDivisionesCombo" access="public" returntype="Any">
        <cfargument name="id_Empresa"         type="string" required="true"/>
        <cfargument name="id_TipoRequisicion" type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
            method="TiposRequisicionesDivisionesCombo"
            id_Empresa="#arguments.id_Empresa#"
            id_TipoRequisicion="#arguments.id_TipoRequisicion#"
            returnvariable="Local.Divisiones">

        <cfset variables.RBR.setQuery(Local.Divisiones)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarRequisicionesToCopy" access="public" returntype="Any">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_Sucursal"        type="string" required="false"/>
        <cfargument name="id_TipoRequisicion" type="string" required="false"/>
        <cfargument name="id_Division"        type="string" required="false"/>
        <cfargument name="id_Requisicion"     type="string" required="false"/>
        <cfargument name="de_Requisicion"     type="string" required="false"/>
        <cfargument name="fn_Inicio"          type="string" required="false"/>
        <cfargument name="fn_Fin"             type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
            method="listarRequisicionesToCopy"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GenerarCopiaRequisicion" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true"/>
        <cfargument name="id_Requisicion" type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
            method="GenerarCopiaRequisicion"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="reporteRequisicionV2" access="public" returntype="any">

        <cfargument name="id_requisicion"   type="string" required="no">
        <cfargument name="id_Empresa"       type="string" required="no">


        <!--- Nos traemos los datos de la requisicion --->
        <cfinvoke
            component="#Application.RF.getPath('dao','Requisiciones')#"
            method="getById"
            id_empresa="#Arguments.id_empresa#"
            id_requisicion="#Arguments.id_requisicion#"
            returnvariable="Local.requisicion">

        <!--- Nos traemos el detalle de la requisicion --->
        <cfinvoke
            component="#Application.RF.getPath('dao','requisicionesdetalle')#"
            method="getByIdRequisicion_Reporte"
            id_empresa="#Arguments.id_empresa#"
            id_requisicion="#Arguments.id_requisicion#"
            returnvariable="Local.detalleRequisicion">
        
            <!--- Nos traemos la imagen de la empresa de donde es la remision  anteriomente se estaba tomando la imagen de la empresa session --->
        <cfinvoke
            component="#Application.RF.getPath('dao','Empresas')#"
            method="listar"
            id_empresa="#Arguments.id_empresa#"
            returnvariable="Local.imgEmpresa">

        <cfset arguments.requisicion = Local.requisicion>
        <cfset arguments.requisicionDetalle = Local.detalleRequisicion>
        <cfset arguments.imagenRequisicion = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.imgEmpresa.ar_ImagenLogo#">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="requisicion#Arguments.requisicion.id_requisicion#"
        }>
        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteAutorizacionRequisicion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicionImp_V2.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke
            component="#Application.RF.getPath('cfc','javaLoader')#"
            method="generatePDFNoDownload"
            content="#reporteAutorizacionRequisicion#"
            pdf="#local.infoReport.nb_archivo#"
            debug="no"
            path="#expandPath('/root/Reportes/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset Local.infoReport.ar_archivoPDF=#reporteAutorizacionRequisicion#>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>

    </cffunction>

    <cffunction name="listarDireccion" access="public" returntype="Any">
        <cfargument name="id_Cliente"     type="string" required="true"/>
        <cfargument name='id_Domicilio'       type='string' required='no'>

        <cfinvoke component="#Application.RF.getPath('dao','requisiciones')#"
                  method="listarDireccion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>
    
</cfcomponent>
