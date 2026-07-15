<cfcomponent>

    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

     <cffunction name="get_Insumos_AyudaFacturacion" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="numeric"  required="false" default="#session.ID_EMPRESA#"/>
        <cfargument name="nb_NombreInsumo"  type="string"   required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="get_Insumos_AyudaFacturacion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EmpleadoInfo" access="public" returntype="Any">
        <cfargument name="id_empresa"   type="string" required="true"/>
        <cfargument name="id_Empleado"  type="string" required="true"/>
        <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                  method="getEmpleadoByID"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="SubFamiliaInsumo" access="public" returntype="Any">
        <cfargument name="id_Familia"     type="numeric" required="false"/>
        <cfargument name="id_Subfamilia"  type="numeric" required="false"/>
        <cfargument name="nb_Subfamilia"  type="string" required="false"/>
        <cfargument name="id_Empresa"     type="numeric" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="SubFamiliaInsumo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Marcas" access="public" returntype="Any">
        <cfargument name="id_marca"     type="numeric" required="false"/>
        <cfargument name="nb_marca"     type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="Marcas"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="UnidadesMedida" access="public" returntype="Any">
        <cfargument name="id_UnidadMedida"     type="numeric" required="false"/>
        <cfargument name="nb_UnidadMedida"     type="string" required="false"/>
        <cfargument name="id_Empresa"           type="numeric" required="false"/>


        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="UnidadesMedida"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listarTodos" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="numeric" required="false"/>
        <cfargument name="id_Insumo"      type="numeric" required="false"/>
        <cfargument name="nb_Insumo"      type="string" required="false"/>
        <cfargument name="id_SubFamilia"  type="numeric" required="false"/>
        <cfargument name="id_FamiliaInsumo" type="numeric" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarTodos"
                  argumentcollection="#Arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="combo_impuestosTazas" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="combo_impuestosTazas"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="agregar" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="string" required="false" default="#session.ID_EMPRESA#"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="no"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="no"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="string" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_ActivoFijo"            type="string" required="false"/>
        <cfargument name="sn_CentroCosto"           type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true"/>
        <cfargument name="id_Taza"                  type="string" required="true"/>
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>

            <cfset dt = structNew()>

            <cfif arguments.nb_NombreInsumo EQ ''>
                    <cfset variables.RBR.setError('el nombre del insumo es requerido.')>
                <!--- <cfelseif arguments.nb_NombreCortoInsumo EQ ''>
                    <cfset variables.RBR.setError('el nombre corto del insumo es requerido.')> --->
                <cfelseif arguments.id_UnidadMedida EQ ''>
                    <cfset variables.RBR.setError('La unidad de medida es requerida.')>
                <cfelse>

                    <cfset Local.argumentos=structNew()>

                    <cfset Local.argumentos.nb_NombreInsumo=arguments.nb_NombreInsumo>
                    <cfset Local.argumentos.nb_NombreCortoInsumo=arguments.nb_NombreCortoInsumo>
                    <cfset Local.argumentos.id_SubFamiliaInsumo=arguments.id_SubFamiliaInsumo>
                    <cfset Local.argumentos.id_SubFamiliaDinamica=arguments.id_SubFamiliaDinamica>
                    <cfset Local.argumentos.id_UnidadMedida=arguments.id_UnidadMedida>
                    <cfset local.argumentos.id_Marca=arguments.id_Marca>
                    <cfset local.argumentos.sn_Requizitable='YES'>
                    <cfset local.argumentos.sn_Seriado=arguments.sn_Seriado>
                    <cfset local.argumentos.id_Empresa = arguments.id_Empresa>
                    <cfset local.argumentos.id_TipoAlmacen = arguments.id_TipoAlmacen>
                    <cfset local.argumentos.sn_ActivoFijo = arguments.sn_ActivoFijo>
                    <cfset local.argumentos.sn_CentroCosto = arguments.sn_CentroCosto>
                    <cfset local.argumentos.id_TipoRequisicion = arguments.id_TipoRequisicion>
                    <cfset local.argumentos.sn_Transporte = arguments.sn_Transporte>
                    <cfset local.argumentos.sn_Arrendamiento = arguments.sn_Arrendamiento>

                    <cfif arguments.sn_InsumoActivo EQ "">
                        <cfset local.argumentos.sn_InsumoActivo=0>
                        <cfelse>
                            <cfset local.argumentos.sn_InsumoActivo=1>
                    </cfif>

                    <cfif arguments.sn_Relevante EQ "">
                        <cfset local.argumentos.sn_Relevante=0>
                        <cfelse>
                            <cfset local.argumentos.sn_Relevante=1>
                    </cfif>

                    <cfset local.argumentos.id_TipoDestino = arguments.id_TipoDestino>
                    <cfif isDefined("arguments.id_ReferenciaContable")>
                        <cfset local.argumentos.id_ReferenciaContable = arguments.id_ReferenciaContable>
                    </cfif>
                    <cfset local.argumentos.id_Impuesto = arguments.id_Impuesto>
                    <cfset local.argumentos.id_Taza = arguments.id_Taza>
                    <cfset local.argumentos.c_ClaveProdServ = arguments.c_ClaveProdServ>


                    <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                              method="existeInsumo"
                              id_empresa="#arguments.id_Empresa#"
                              id_Insumo="0"
                              nb_NombreInsumo="#Arguments.nb_NombreInsumo#"
                              returnvariable="Local.exists"
                              >

                    <cfif NOT Local.exists>
                            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                                      method="nextID"
                                      id_Empresa="#arguments.id_Empresa#"
                                      returnvariable="Local.argumentos.id_Insumo">

                            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                                      method="agregar"
                                      argumentcollection="#Local.argumentos#">

                                      <!--- Modificacion: Victor Sanchez
                                            16/10/2015
                                            Verifica los conceptos de gastos, para agregar el insumo
                                            cuando la bandera de ligamiento al insumo este en 1

                                      <cfinvoke component="#Application.RF.getPath('dao','ConceptosGastos')#"
                                          method="listar"
                                          id_Empresa="#arguments.id_Empresa#"
                                          returnvariable="Local.conceptosGastos">
                                          --->
<!---
                                          <cfloop query="Local.conceptosGastos">
                                                 Si el concepto de gasto esta con la bandera activada
                                                se agrega


                                            <cfif #Local.conceptosGastos.SN_LIGADOAINSUMOS# AND #sn_ActivoFijo# EQ 'NO'>

                                              <cfinvoke component="#Application.RF.getPath('dao','ConceptosGastosInsumos')#"
                                              method="guardar"
                                              id_empresa="#arguments.id_Empresa#"
                                              id_conceptogasto="#Local.conceptosGastos.ID_CONCEPTOGASTO#"
                                              id_insumo="#Local.argumentos.id_Insumo#">
                                            </cfif>
                                          </cfloop>

--->
                            <cfset dt.sn_existe = 1>
                            <cfset dt.de_mensaje = 'Operación exitosa.'>

                            <cfset variables.RBR.setData(dt)>
                            <!--- <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")> --->
                        <cfelse>
                            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                                method="upR_InsumoByName"
                                nb_insumo="#nb_NombreInsumo#"
                                returnvariable="query">
                                <cfif #query.SN_INSUMOACTIVO# EQ '1'>
                                    <cfset estado = 'Activo'>
                                <cfelse>
                                    <cfset estado = 'Inactivo'>
                                </cfif>

                                <cfset dt.sn_existe = 0>
                                <cfset dt.de_mensaje = 'No se pudo guardar el listado debido a que el Insumo "'&nb_NombreInsumo&'" ya se encuentra registrado.'>

                                <cfset variables.RBR.setData(dt)>
                            <!--- <cfset variables.RBR.setError('El Insumo "'&nb_NombreInsumo&'" ya está registrado con estatus "'&estado&'".')> --->
                       </cfif>
                      </cfif>
            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AgregarMultiplesInsumos" access="public" returntype="Any">

        <cfargument name="multiplesInsumos"     type="array" required="true"/>

        <cfset dt = structNew()>

        <cfloop array="#multiplesInsumos#" index="local.multiplesInsumos">


            <cfif local.multiplesInsumos.nb_NombreInsumo EQ ''>

                <cfset dt.de_mensaje = 'El nombre del insumo es requerido.'>
                <cfset variables.RBR.setData(dt)>

                <!--- <cfset variables.RBR.setError('el nombre del insumo es requerido.')> --->
                <!--- <cfelseif local.multiplesInsumos.nb_NombreCortoInsumo EQ ''>
                    <cfset variables.RBR.setError('el nombre corto del insumo es requerido.')> --->
                <cfelseif local.multiplesInsumos.id_UnidadMedida EQ ''>

                    <cfset dt.de_mensaje = 'La unidad de medida es requerida.'>
                    <cfset variables.RBR.setData(dt)>
                    <!--- <cfset variables.RBR.setError('La unidad de medida es requerida.')> --->

                <cfelse>

                    <cfset Local.argumentos=structNew()>

                    <cfset Local.argumentos.nb_NombreInsumo=local.multiplesInsumos.nb_NombreInsumo>
                    <cfset Local.argumentos.nb_NombreCortoInsumo=local.multiplesInsumos.nb_NombreCortoInsumo>
                    <cfset Local.argumentos.id_SubFamiliaInsumo=local.multiplesInsumos.id_SubFamiliaInsumo>

                    <cfset local.argumentos.id_SubFamiliaDinamica = (local.multiplesInsumos.id_SubFamiliaDinamica gt 0  ? local.multiplesInsumos.id_SubFamiliaDinamica : false) />

                    <!--- <cfset Local.argumentos.id_SubFamiliaDinamica=local.multiplesInsumos.id_SubFamiliaDinamica> --->

                    <cfset Local.argumentos.id_UnidadMedida=local.multiplesInsumos.id_UnidadMedida>
                    <cfset local.argumentos.id_Marca=local.multiplesInsumos.id_Marca>
                    <cfset local.argumentos.sn_Requizitable=1>

                    <cfif local.multiplesInsumos.sn_Seriado EQ false>
                        <cfset local.argumentos.sn_Seriado=0>
                    <cfelse>
                        <cfset local.argumentos.sn_Seriado=1>
                    </cfif>

                    <cfset local.argumentos.id_Empresa = session.ID_EMPRESA>
                    <cfset local.argumentos.id_TipoAlmacen = local.multiplesInsumos.id_TipoAlmacen>

                    <cfif local.multiplesInsumos.sn_ActivoFijo EQ false>
                        <cfset local.argumentos.sn_ActivoFijo=0>
                    <cfelse>
                        <cfset local.argumentos.sn_ActivoFijo=1>
                    </cfif>

                    <cfif local.multiplesInsumos.sn_CentroCosto EQ false>
                        <cfset local.argumentos.sn_CentroCosto=0>
                    <cfelse>
                        <cfset local.argumentos.sn_CentroCosto=1>
                    </cfif>

                    <cfif local.multiplesInsumos.sn_Relevante EQ false>
                        <cfset local.argumentos.sn_Relevante=0>
                    <cfelse>
                        <cfset local.argumentos.sn_Relevante=1>
                    </cfif>

                    <cfset local.argumentos.sn_Transporte = (local.multiplesInsumos.sn_Transporte ? 1 : 0) />
                    <cfset local.argumentos.sn_InsumoActivo = (local.multiplesInsumos.sn_InsumoActivo ? 1 : 0) />

                    <!--- <cfset local.argumentos.sn_ActivoFijo = local.multiplesInsumos.sn_ActivoFijo> --->
                    <!--- <cfset local.argumentos.sn_CentroCosto = local.multiplesInsumos.sn_CentroCosto> --->
                    <cfset local.argumentos.id_TipoRequisicion = local.multiplesInsumos.id_TipoRequisicion>
                    <!--- <cfset local.argumentos.sn_Transporte = local.multiplesInsumos.sn_Transporte> --->
                    <cfset local.argumentos.sn_Arrendamiento = local.multiplesInsumos.sn_Arrendamiento>

                    <cfset local.argumentos.id_TipoDestino = local.multiplesInsumos.id_TipoDestino>
                    <cfif isDefined("local.multiplesInsumos.id_ReferenciaContable")>
                        <cfset local.argumentos.id_ReferenciaContable = local.multiplesInsumos.id_ReferenciaContable>
                    </cfif>
                    <cfset local.argumentos.id_Impuesto = local.multiplesInsumos.id_Impuesto>
                    <cfset local.argumentos.id_Taza = local.multiplesInsumos.id_Taza>
                    <cfset local.argumentos.c_ClaveProdServ = local.multiplesInsumos.c_ClaveProdServ>

                    <cfinvoke
                        component="#Application.RF.getPath('dao','Insumos')#"
                        method="existeInsumo"
                        id_empresa="#session.ID_EMPRESA#"
                        id_Insumo="0"
                        nb_NombreInsumo="#local.multiplesInsumos.nb_NombreInsumo#"
                        returnvariable="Local.exists">

                    <cfif NOT Local.exists>
                            <cfinvoke
                                component="#Application.RF.getPath('dao','Insumos')#"
                                method="nextID"
                                id_Empresa="#session.ID_EMPRESA#"
                                returnvariable="Local.argumentos.id_Insumo">

                            <cfinvoke
                                component="#Application.RF.getPath('dao','Insumos')#"
                                method="AgregarMultiplesInsumos"
                                argumentcollection="#Local.argumentos#">

                            <cfset dt.sn_existe = 1>
                            <cfset dt.de_mensaje = 'Operación exitosa.'>

                            <cfset variables.RBR.setData(dt)>

                            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                        <cfelse>

                            <cfinvoke
                                component="#Application.RF.getPath('dao','Insumos')#"
                                method="upR_InsumoByName"
                                nb_insumo="#local.multiplesInsumos.nb_NombreInsumo#"
                                returnvariable="query">

                            <cfif #query.SN_INSUMOACTIVO# EQ '1'>
                                <cfset estado = 'Activo'>
                                <cfelse>
                                    <cfset estado = 'Inactivo'>
                            </cfif>

                            <cfset dt.sn_existe = 0>
                            <cfset dt.de_mensaje = 'No se pudo guardar el listado debido a que el Insumo "'&local.multiplesInsumos.nb_NombreInsumo&'" ya se encuentra registrado.'>

                            <cfset variables.RBR.setData(dt)>
                            <cfreturn variables.RBR>

                            <!--- <cfset variables.RBR.setError('El Insumo "'&local.multiplesInsumos.nb_NombreInsumo&'" ya se encuentra registrado.')> --->
                            <!--- <cfreturn variables.RBR> --->
                    </cfif>
            </cfif>

        </cfloop>

        <cfreturn variables.RBR>

    </cffunction>

    <cffunction name="listarcombounidades" access="public" returntype="Any">

        <cfinvoke component="#Application.RF.getPath('dao','UnidadesMedida')#"
                  method="listarcombounidades"
                  argumentcollection="#Local.argumentos#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!---
        Victor Sanchez
        30/12/2015
     --->
    <cffunction name="upL_InsumosProductosAyuda" access="public" returntype="Any">
        <cfargument name="nb_insumo"      type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="upL_InsumosProductosAyuda"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerUnidadMedidadeInsumo" access="public" returntype="Any">
        <cfargument name="id_insumo"      type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','UnidadesMedida')#"
                  method="listarcombounidades"
                  argumentcollection="#Local.argumentos#"
                  id_insumo="#arguments.id_insumo#"
                  id_empresa="#session.ID_EMPRESA#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez
      Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel2" access="public" returntype="Any">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="yes"/>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="SubFamiliasDinamicasNivel2"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- Victor Sanchez
      Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel3" access="public" returntype="Any">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="SubFamiliasDinamicasNivel3"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Victor Sanchez
      Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel4" access="public" returntype="Any">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="SubFamiliasDinamicasNivel4"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


        <!--- Victor Sanchez
      Date: 23/07/2015
      saca el nivel de una subfamilia --->
    <cffunction name="sacarNivel" access="public" returntype="Any">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="sacarNivel"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

            <!--- Victor Sanchez
      Date: 23/07/2015
      saca el nivel de una subfamilia --->
    <cffunction name="sacarPadre" access="public" returntype="Any">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="sacarPadre"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getNumeroInsumos" access="public" returntype="Any">
        <cfargument name="id_Almacen"       type="string"       required="true">

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesBloqueosInventarios')#"
                  method="getUltimoBloqueInventarioAlmacen"
                  argumentcollection="#arguments#"
                  returnvariable="Local.Bloqueo">

        <cfset arguments.id_BloqueoInventario = local.Bloqueo.id_AlmacenBloqueoInventario>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  argumentcollection="#arguments#"
                  method="getNumeroInsumos"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string"   required="false"/>
        <cfargument name="id_insumo"            type="string"   required="false"/>
        <cfargument name="nb_insumo"            type="string"   required="false"/>
        <cfargument name="id_subfamilia"        type="string"   required="false"/>
        <cfargument name="sn_activo"            type="string"   required="false"/>
        <cfargument name="id_TipoRequisicion"   type="string"   required="false"/>
        <cfargument name="page"                 type="string"   required="false"/>
        <cfargument name="pageSize"             type="string"   required="false"/>
        <cfargument name="id_familia"           type="string"   required="false"/>
        <cfargument name="sn_InsumoActivo"      type="string"   required="false"/>
        <cfargument name="sn_Relevante"         type="string"   required="false"/>
        <cfargument name="sn_MostrarTodas"      type="string"   required="false" default="#0#"/>

            <!--- <cfset Local.argumentos=structNew()> --->

            <!--- <cfif isDefined("Arguments.id_Empresa")  AND Arguments.id_Empresa NEQ ''>
                <cfset arguments.id_Empresa = arguments.id_Empresa>
                <cfelse>
                    <cfset arguments.id_Empresa = session.ID_EMPRESA>
            </cfif> --->

            

            <!--- <cfif isDefined("Arguments.id_insumo")  AND Arguments.id_insumo NEQ ''>
                <cfset Local.argumentos.id_insumo=arguments.id_insumo>
            </cfif>

            <cfif Arguments.nb_insumo NEQ ''>
                <cfset Local.argumentos.nb_insumo=arguments.nb_insumo>
            </cfif>

            <cfif Arguments.id_subfamilia NEQ ''>
                <cfset Local.argumentos.id_subfamilia=arguments.id_subfamilia>
            </cfif> --->

            <!--- Si tiene la bandera sn_MostrarTodas, significa que debe mostrar todos los insumos de todas las empresas--->
            <!--- Si no tiene nombre del insumo, que agarre la empresa de sesión para no sobrecargar la BD --->
            <cfif NOT structKeyExists(arguments, "nb_insumo") OR arguments.nb_insumo EQ '' OR arguments.sn_MostrarTodas EQ 0>
                <cfset arguments.id_Empresa = session.ID_EMPRESA>
            </cfif>

            <cfif isDefined("arguments.page")>
                <cfif IsNumeric("#arguments.page#")>
                    <cfset arguments.page = arguments.page>
                <cfelse>
                    <cfset arguments.page = ''>
                </cfif>

            <cfelse>
                <cfset arguments.page = ''>
            </cfif>

            <cfif isDefined("arguments.pageSize")>
                <cfif IsNumeric("#arguments.pageSize#")>
                    <cfset arguments.pageSize = arguments.pageSize>
                <cfelse>
                    <cfset arguments.pageSize = ''>
                </cfif>

            <cfelse>
                <cfset arguments.pageSize = ''>
            </cfif>

            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                      method="listar"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

            <cfset variables.RBR.setQuery(Local.rs)>

            <cfreturn variables.RBR>
    </cffunction>

    <!--- julio cesar acosta lopez
          listar los insumos para la asignacion de los conceptos de gastos a cada insumo
          08/07/2015 --->
    <cffunction name="listarinsumosasignacionconceptogasto" access="remote" returnformat="JSON">
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"         type="string" required="false"/>
        <cfargument name="nb_InsumoListado"         type="string" required="false"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>

        <cfset arguments.id_Empresa =  session.ID_EMPRESA>

            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                      method="listarinsumosasignacionconceptogasto"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

            <!--- <cfset variables.RBR.setData(Local.insumos)> --->
            <cfset variables.RBR.setQuery(Local.rs)>
            <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="DatosInsumo" access="public" returntype="Any">
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

            <!--- <cfdump var="#arguments#"><cfabort> --->

            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                      method="DatosInsumo"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

            <cfset variables.RBR.setQuery(Local.rs)>
            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="InsumosCombo" access="public" returntype="Any">
        <cfif not isDefined("Arguments.id_Empresa") OR arguments.id_Empresa EQ ''>
            <cfset arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="InsumosCombo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosCotizar" access="public" returntype="Any">
        <cfargument name="id_Proveedor"    type="numeric"   required="true"/>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosCotizar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosAutoComplete" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_TipoRequisicion"   type="numeric" required="false">

        <cfif NOT isDefined("Arguments.id_Empresa")>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
      method="listarInsumosAutoComplete"
      argumentcollection="#arguments#"
      returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="UltimoPrecioCompra" access="public" returntype="Any">
      <cfargument name="id_Insumo"            type="string"       required="true"/>

      <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="UltimoPrecioCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosAutoCompleteRegistroCompraCombustible" access="public" returntype="Any">
      <cfargument name="id_Insumo"            type="string"       required="false"/>
      <cfargument name="nb_NombreInsumo"      type="string"       required="false"/>

      <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <!--- <cfdump var="#arguments.id_Empresa#"><cfabort> --->

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosAutoCompleteRegistroCompraCombustible"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosparaAutorizarOrdenCompra" access="public" returntype="Any">
      <cfargument name="id_Cotizacion"            type="string"       required="false"/>
      <cfargument name="sn_Genero"                type="string"       required="false"/>

      <cfset arguments.id_Empresa = session.ID_EMPRESA>
       <!--- <cfdump var="#arguments.id_Empresa#"><cfabort> --->
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosparaAutorizarOrdenCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="editar" access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="string" required="true"/>
        <cfargument name="id_Insumo"                type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="true"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="true"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="string" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_ActivoFijo"            type="string" required="false"/>
        <cfargument name="sn_CentroCosto"           type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true"/>
        <cfargument name="id_Taza"                  type="string" required="true"/>
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>
        <cfargument name="sn_AplicarTodasEmpresas"  type="string" required="false"/>


            <cfset dt = structNew()>

            <cfif arguments.nb_NombreInsumo EQ ''>
                <cfset variables.RBR.setError('el nombre del insumo es requerido.')>
            <!--- <cfelseif arguments.nb_NombreCortoInsumo EQ ''>
                <cfset variables.RBR.setError('el nombre corto del insumo es requerido.')> --->
                <cfelseif arguments.id_UnidadMedida EQ ''>
                    <cfset variables.RBR.setError('el nombre de la unidad es requerido.')>

                <cfelse>

                    <cfset Local.argumentos=structNew()>

                    <cfset local.argumentos.id_SubFamiliaDinamica = (arguments.id_SubFamiliaDinamica gt 0  ? arguments.id_SubFamiliaDinamica : false) />
                    <cfset local.argumentos.sn_Requizitable=1>

                    <cfif arguments.sn_Seriado EQ false>
                        <cfset local.argumentos.sn_Seriado=0>
                    <cfelse>
                        <cfset local.argumentos.sn_Seriado=1>
                    </cfif>

                    <cfset local.argumentos.id_Empresa = arguments.id_Empresa>
                    <cfset local.argumentos.id_TipoAlmacen = arguments.id_TipoAlmacen>

                    <cfif arguments.sn_ActivoFijo EQ false>
                        <cfset local.argumentos.sn_ActivoFijo=0>
                    <cfelse>
                        <cfset local.argumentos.sn_ActivoFijo=1>
                    </cfif>

                    <cfif arguments.sn_CentroCosto EQ false>
                        <cfset local.argumentos.sn_CentroCosto=0>
                    <cfelse>
                        <cfset local.argumentos.sn_CentroCosto=1>
                    </cfif>

                    <cfif arguments.sn_InsumoActivo EQ "">
                        <cfset local.argumentos.sn_InsumoActivo=0>
                    <cfelse>
                        <cfset local.argumentos.sn_InsumoActivo=1>
                    </cfif>

                    <cfif arguments.sn_Relevante EQ "">
                        <cfset local.argumentos.sn_Relevante=0>
                    <cfelse>
                        <cfset local.argumentos.sn_Relevante=1>
                    </cfif>

                    <cfset local.argumentos.sn_Transporte = (arguments.sn_Transporte ? 1 : 0) />
                    <!--- <cfset local.argumentos.InsumoActivo = (arguments.InsumoActivo ? 1 : 0) /> --->
                    <cfset local.argumentos.sn_Arrendamiento = (arguments.sn_Arrendamiento ? 1 : 0) />

                    <cfset Local.argumentos.id_Insumo=arguments.id_Insumo>
                    <cfset Local.argumentos.nb_NombreInsumo=arguments.nb_NombreInsumo>
                    <cfset Local.argumentos.nb_NombreCortoInsumo=arguments.nb_NombreCortoInsumo>
                    <cfset Local.argumentos.id_SubFamiliaInsumo=arguments.id_SubFamiliaInsumo>
                    <cfset Local.argumentos.id_SubFamiliaDinamica=arguments.id_SubFamiliaDinamica>
                    <cfset Local.argumentos.id_UnidadMedida=arguments.id_UnidadMedida>
                    <cfset local.argumentos.id_Marca=arguments.id_Marca>
                    <!--- <cfset local.argumentos.sn_Requizitable='YES'> --->
                    <!--- <cfset local.argumentos.sn_Seriado=arguments.sn_Seriado> --->
                    <cfset local.argumentos.id_Empresa = arguments.id_Empresa>
                    <!--- <cfset local.argumentos.id_TipoAlmacen = arguments.id_TipoAlmacen> --->
                    <!--- <cfset local.argumentos.sn_ActivoFijo = arguments.sn_ActivoFijo> --->
                    <!--- <cfset local.argumentos.sn_CentroCosto = arguments.sn_CentroCosto> --->
                    <cfset local.argumentos.id_TipoRequisicion = arguments.id_TipoRequisicion>
                    <!--- <cfset local.argumentos.sn_Transporte = arguments.sn_Transporte> --->
                    <!--- <cfset local.argumentos.InsumoActivo = arguments.InsumoActivo> --->
                    <!--- <cfset local.argumentos.sn_Arrendamiento = arguments.sn_Arrendamiento> --->
                    <cfset local.argumentos.id_TipoDestino = arguments.id_TipoDestino>
                    <cfif isDefined("arguments.id_ReferenciaContable")>
                        <cfset local.argumentos.id_ReferenciaContable = arguments.id_ReferenciaContable>
                    </cfif>
                    <cfset local.argumentos.id_Impuesto = arguments.id_Impuesto>
                    <cfset local.argumentos.id_Taza = arguments.id_Taza>
                    <cfset local.argumentos.c_ClaveProdServ = arguments.c_ClaveProdServ>
                    <cfset local.argumentos.sn_AplicarTodasEmpresas = arguments.sn_AplicarTodasEmpresas>


                    <cfinvoke
                        component="#Application.RF.getPath('dao','Insumos')#"
                        method="existeInsumo"
                        id_empresa="#Arguments.id_empresa#"
                        id_Insumo="#Arguments.id_Insumo#"
                        nb_NombreInsumo="#Arguments.nb_NombreInsumo#"
                        returnvariable="Local.exists">

                    <!--- <cfdump var="#arguments#">
                    <cfdump var="#Local.exists#">
                    <cfabort> --->
                    <cfif NOT Local.exists>

                        <!--- <cfcontent type="text/html">
                        <cfdump var="#Local.argumentos#" format="simple" label="arguments" abort="true"> --->

                            <cfinvoke
                                component="#Application.RF.getPath('dao','Insumos')#"
                                method="editar"
                                argumentcollection="#Local.argumentos#">

                                <cfset dt.sn_existe = 1>
                                <cfset dt.de_mensaje = 'Operación exitosa.'>

                                <cfset variables.RBR.setData(dt)>
                            <!--- <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")> --->
                        <cfelse>
                            <cfset dt.sn_existe = 0>
                            <cfset dt.de_mensaje = 'El Insumo ya se encuentra registrado.'>

                            <cfset variables.RBR.setData(dt)>
                            <!--- <cfset variables.RBR.setError('El Insumo ya esta registrado.')> --->
                    </cfif>
            </cfif>

            <cfreturn variables.RBR>
    </cffunction>

    <!--- function para asignar los conceptos de gastos a los insumos
            julio cesar acosta lopez
            09/07/2015--->
    <cffunction name="AsignarConceptoGasto" access="public" returntype="Any">
        <cfargument name="insumos"  type="array" required="true"/>

            <!--- <cfdump var="#arguments.insumos#"/><cfabort /> --->
            <cfloop from="1" to="#arrayLen(arguments.insumos)#" index="local.i">
                <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                          method="AsignarConceptoGasto"
                          id_empresa="#session.ID_EMPRESA#"
                          id_insumo = "#arguments.insumos[local.i].id_insumo#"
                          id_conceptogasto ="#arguments.insumos[local.i].CONCEPTOGASTO.ID_CONCEPTOGASTO#"
                          >
            </cfloop>
            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="buscarID" access="public" returntype="Any">
        <cfargument name="id_Insumo"        type="string" required="false"/>

        <!--- <cfinvoke
            component="#Application.RF.getPath('dao','Insumos')#"
            method="buscarID"
            argumentcollection="#arguments#"
            returnvariable="Local.rs"> --->

        <cfinvoke
            component="#Application.RF.getPath('dao','Insumos')#"
            method="nextID"
            id_Empresa="#session.ID_EMPRESA#"
            returnvariable="Local.rs">
        <cfset local.insumos = structNew()>
        <cfset local.insumos.id_Insumo = Local.rs>

        <cfset variables.RBR.setData(insumos)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="Any">
        <cfargument name="id_insumo"        type="string" required="true"/>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="eliminar"
                  argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosporIdCotizacion" access="public" returntype="Any">
        <cfargument name="id_Cotizacion"   type="numeric"     required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosporIdCotizacion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <!--- <cfset variables.RBR.setData(Local.rs)> --->

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosporOrdenCompra" access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"   type="numeric"     required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosporOrdenCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <!--- <cfset variables.RBR.setData(Local.rs)> --->

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosbyIDorNB" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="numeric"  required="false"/>
        <cfargument name="id_insumo"    type="numeric"  required="false"/>
        <cfargument name="nb_insumo"    type="string"   required="false"/>

        <cfif NOT isDefined("Arguments.id_Empresa")>
            <cfset arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosbyIDorNB"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumosByIDorName" access="public" returntype="Any">
        <cfargument name="id_Empresa"  type="numeric" required="true"/>
        <cfargument name="id_Sucursal" type="numeric" required="true"/>
        <cfargument name="id_Almacen"  type="numeric" required="true"/>
        <cfargument name="id_insumo"   type="numeric" required="false"/>
        <cfargument name="nb_insumo"   type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosbyIDorNB"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AutocompleteInsumo" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="numeric"  required="false"/>
        <cfargument name="id_Sucursal"  type="numeric"  required="false"/>
        <cfargument name="id_Almacen"   type="numeric"  required="false"/>
        <cfargument name="id_insumo"    type="numeric"  required="true"/>

        <cfif NOT isDefined("Arguments.id_Empresa")>
            <cfset arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>
        <cfif NOT isDefined("arguments.id_Sucursal")>
            <cfset arguments.id_Sucursal = session.ID_EMPRESA>
        </cfif>
        <cfif NOT isDefined("arguments.id_Almacen")>
            <cfset arguments.id_Almacen = session.ID_EMPRESA>
        </cfif>

        <!--- <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen = session.ID_ALMACEN> --->

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="AutocompleteInsumo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarInsumos"  access="public"  returntype="Any">
        <cfargument name="id_Empresa"           type="numeric"  required="false">
        <cfargument name="id_SolicitudCompra"    type="string"  required="false"/>
        <cfargument name="id_Insumo"             type="string"  required="false"/>

        <cfif not isDefined("Arguments.id_Empresa") >
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfset local.ListaInsumos = structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosSolicitudCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.SolicitudCompra">

        <cfset local.ListaInsumos.SolicitudCompra = Local.SolicitudCompra>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getinsumossolicitudcompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.SolicitudComprains">

        <cfset local.ListaInsumos.SolicitudCompraInsumos = Local.SolicitudComprains>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosSolicitudCompraDatos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.SolicitudCompraDatos">

        <cfset local.ListaInsumos.SolicitudCompraDatos = local.SolicitudCompraDatos>


        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getSolicitudCompraInsumosParaCotizacion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.InsumosParaCotizacion">
        <cfset local.ListaInsumos.InsumosParaCotizacion = local.InsumosParaCotizacion>


        <cfset variables.RBR.setData(Local.ListaInsumOS)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getInsumosPorSolicitudCompra" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true">

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif arguments.id_solicitudCompra NEQ ''>
            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getInsumosPorSolicitudCompra"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_SolicitudCompra="#Arguments.id_SolicitudCompra#"
                  returnvariable="Local.rs">
            <cfset variables.RBR.setQuery(Local.rs)>
        <cfelse>
            <cfset variables.RBR.setError('Folio de Solicitud de compra invalido')>
        </cfif>


        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getInsumosPorSolicitudCompraAlmacen" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_Sucursal"          type="numeric" required="false">
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true">

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif not isDefined("Arguments.id_Sucursal")>
            <cfset Arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        </cfif>

        <cfif arguments.id_solicitudCompra NEQ ''>
            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getInsumosPorSolicitudCompraAlmacen"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_Sucursal="#Arguments.id_Sucursal#"
                  id_SolicitudCompra="#Arguments.id_SolicitudCompra#"
                  returnvariable="Local.rs">
            <cfset variables.RBR.setQuery(Local.rs)>
        <cfelse>
            <cfset variables.RBR.setError('Folio de Solicitud de compra invalido')>
        </cfif>


        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarByCotizacion" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="numeric" required="false">
        <cfargument name="id_Cotizacion"    type="numeric" required="true"/>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif arguments.id_cotizacion NEQ ''>
                <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                      method="listarByCotizacion"
                      id_Empresa="#Arguments.id_Empresa#"
                      id_Cotizacion="#Arguments.id_Cotizacion#"
                      returnvariable="Local.rs">

                <cfset variables.RBR.setQuery(Local.rs)>
            <cfelse>
                <cfset variables.RBR.setError('Folio de Cotizaci&oacute;n invalido')>
        </cfif>


        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarByCotizacion_SC" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="numeric" required="false">
        <cfargument name="id_Cotizacion"    type="numeric" required="true"/>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfif arguments.id_cotizacion NEQ ''>
                <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                      method="listarByCotizacion_SC"
                      id_Empresa="#Arguments.id_Empresa#"
                      id_Cotizacion="#Arguments.id_Cotizacion#"
                      returnvariable="Local.rs">

                <cfset variables.RBR.setQuery(Local.rs)>
            <cfelse>
                <cfset variables.RBR.setError('Folio de Cotizaci&oacute;n invalido')>
        </cfif>


        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 08/05/2015
          OBTIENE LOS INSUMOS PARA AUTOCOMPLETE POR PROVEEDOR --->
    <cffunction name="listarInsumosAutoCompleteByProveedor" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric" required="true">

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosAutoCompleteByProveedor"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>

    </cffunction>



    <cffunction name="tipoDestinoInsumos" access="public" returntype="Any">
       <!--- <cfdump var="#arguments.id_Empresa#"><cfabort> --->
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="tipoDestinoInsumos"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>

    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="InsumosMaterialesCombo" access="public" returntype="Any">
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="InsumosMaterialesCombo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerinsumos" access="public" returntype="Any">
        <cfargument name="page"                 type="string"   required="false">
        <cfargument name="pageSize"             type="string"   required="false">
        <cfargument name="id_familia"           type="string"   required="false">
        <cfargument name="id_subfamilia"        type="string"   required="false">
        <cfargument name="nb_insumo"            type="string"   required="false">

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="obtenerinsumos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="getInsumosPorFamilia" access="public" returntype="Any">
        <cfargument name="FamiliaInsumo"    type="string"   required="false">
        <cfargument name="SubFamiliaInsumo" type="string"   required="false">

        <cfif isDefined("FamiliaInsumo") && arguments.FamiliaInsumo NEQ nullValue()>
            <cfset arguments.id_FamiliaInsumo = arguments.FamiliaInsumo.ID_FAMILIAINSUMO>
        </cfif>

        <cfif isDefined("SubFamiliaInsumo") && arguments.SubFamiliaInsumo NEQ nullValue()>
            <cfset arguments.id_SubFamiliaInsumo = arguments.SubFamiliaInsumo.ID_SUBFAMILIAINSUMO>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getInsumosPorFamilia"
                  id_Empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="getInsumosMultiEmpresa" access="public" returntype="Any">
        <cfargument name="id_Empresa"          type="string"    required="true" default="">
        <cfargument name="id_FamiliaInsumo"    type="string"    required="false" default="">
        <cfargument name="id_SubFamiliaInsumo" type="string"    required="false" default="">

            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="getInsumosMultiEmpresa"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

            <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="catalogoInsumo" access="public" returntype="Any">

            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="catalogoInsumo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

            <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GenerarExcel" access="remote" returnformat="JSON">

        <cfinvoke   component="#Application.RF.getPath('dao','Insumos')#"
                    method="catalogoInsumo"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs"/>
<!--- <cfdump var="#local.rs#">
        <cfabort> --->
        <cfif #Local.rs.recordcount# EQ 0>
            <cfset variables.RBR.setError('No se Encontro Registro para Imprimer el Reporte.')>
            <cfreturn Variables.RBR>
        </cfif>
        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="CatalogoDeInsumos#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
        </cfif>

        <poi:document   name="REQUEST.ExcelData"
                        file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                        style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;"
                        >

            <poi:classes>
                <poi:class  name="title"
                            style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                            />

                <poi:class  name="fondo"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; "
                            />

                <poi:class  name="Total"
                            style="color: red; text-align: right ;"
                            />

                <poi:class  name="header"
                            style="font-family: Arial ; color: sky-blue ; font-size: 10pt; font-weight: bold;"
                            />
                <poi:class  name="fondo2"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; font-weight: bold;"
                            />

                <poi:class name="left" style="border-left:2px solid black"/>
                <poi:class name="right" style="border-right:2px solid black"/>
                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                <poi:class name="top" style="border-top:2px solid black"/>
                <poi:class name="filtros" style="text-align:right;color:blue;font-weight:bold"/>
                <poi:class name="gris" style="background-color: LIGHT_CORNFLOWER_BLUE;"/>
            </poi:classes>

            <poi:sheets>
                 <poi:sheet name="Catalogo De Insumos"
                            freezerow="7"
                            orientation="landscape"
                            zoom="100%">
                        <poi:columns>
                            <poi:column style="width: 50px  ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 300px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 300px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 100px  ;"/>
                            <poi:column style="width: 80px  ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 110px ;"/>
                        </poi:columns>
                    <poi:row class=''></poi:row>

                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Catalogo De Insumos"  class="title"/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="#dateFormat(now(),'dd/mm/yyyy ')# #timeFormat(now(), ' hh:mm')#" class="title" style="text-align: right;" colspan="1"/>
                    </poi:row>

                    <poi:row class=''></poi:row>
                    <poi:row>
                        <poi:cell value=""/>
                            <poi:cell value="Empresa:" class="filtros"/>
                            <poi:cell value="#session.NB_EMPRESA#"/>
                            <poi:cell value="Clave Del Insumo:" class="filtros"/>
                            <poi:cell value="#id_Insumo#"/>
                            <poi:cell value="Nimbre Insumo:" class="filtros"/>
                            <poi:cell value="#nb_Insumo#"/>
                    </poi:row>
                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Activo Fijo:" class="filtros"/>
                        <poi:cell value="#nb_ActivoFijo#"/>
                        <poi:cell value="SubFamilia:" class="filtros"/>
                        <poi:cell value="#nb_Subfamilia#"/>
                    </poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="CODIGO" class="header fondo left top bottom"/>
                        <poi:cell value="INSUMO" class="header fondo left top bottom"/>
                        <poi:cell value="SUBFAMILIA INSUMO" class="header fondo left top bottom"/>
                        <poi:cell value="FAMILIA INSUMO" class="header fondo top bottom left"/>
                        <poi:cell value="UNIDAD MEDIDA" class="header fondo top bottom left"/>
                        <poi:cell value="TIPO REQUISICION" class="header fondo top bottom left"/>
                        <poi:cell value="REQUISITABLE" class="header fondo top bottom left"/>
                        <poi:cell value="COMPRA PARA STOCK" class="header fondo top bottom left"/>
                        <poi:cell value="CLAVE EQUIVALENTE" class="header fondo top bottom left"/>
                        <poi:cell value="INSUMO EQUIVALENTE" class="header fondo top bottom left"/>
                        <poi:cell value="UM EQUIVALENTE" class="header fondo top bottom left"/>
                        <poi:cell value="TIPO DE ALMACEN" class="header fondo top bottom left"/>
                        <poi:cell value="TIPO REQUISICION" class="header fondo top bottom left"/>
                        <poi:cell value="SERIADO" class="header fondo top bottom left right"/>
                        <poi:cell value="ACTIVO FIJO" class="header fondo top bottom left right"/>
                        <poi:cell value="CENTRO COSTO" class="header fondo top bottom left right"/>
                        <poi:cell value="EQUIPO DE TRANSPORTE" class="header fondo top bottom left right"/>
                        <poi:cell value="ACTIVO EN SISTEMA" class="header fondo top bottom left right"/>
                        <poi:cell value="TIPO DESTINO" class="header fondo top bottom left right"/>
                        <poi:cell value="REFERENCIA CONTABLE" class="header fondo top bottom left right"/>
                        <poi:cell value="RESGUARDO" class="header fondo top bottom left right"/>
                        <poi:cell value="CVE PROD SER SAT" class="header fondo top bottom left right"/>
                        <poi:cell value="STOCK MINIMO" class="header fondo top bottom left right"/>
                        <poi:cell value="STOCK MAXIMO" class="header fondo top bottom left right"/>
                    </poi:row>
                    <cfloop query="Local.rs">
                        <poi:row>
                            <poi:cell value=""/>
                            <poi:cell value="#Local.rs.CODIGO#" class="Contenido left" />
                            <poi:cell value="#Local.rs.INSUMO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.SUBFAMILIAINSUMO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.FAMILIAINSUMO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.UNIDADMEDIDA#" class="Contenido left" style="text-align: center"/>
                            <poi:cell value="#Local.rs.TIPOREQUISICION#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.REQUISITABLE#" class="Contenido left" style="text-align: center"/>
                            <poi:cell value="#Local.rs.COMPRAPARASTOCK#" class="Contenido left" style="text-align: center"/>
                            <poi:cell value="#Local.rs.CVEINSUMOEQUIVALENTE#" class = "Contenido left right" />
                            <poi:cell value="#Local.rs.INSUMOEQUIVALENTE#" class = "Contenido left right"/>
                            <poi:cell value="#Local.rs.UNIDADMEDIDAEQUIVALENTE#" class = "Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.TIPOALMACEN#"class = "Contenido left right"/>
                            <poi:cell value="#Local.rs.TIPOREQUISICION#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.SERIADO#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.ACTIVOFIJO#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.CENTROCOSTO#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.EQUIPODETRANSPORTE#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.ACTIVOENSISTEMA#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.TIPODESTINO#" class="Contenido left right"/>
                            <poi:cell value="#Local.rs.REFERENCIACONTABLE#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.RESGUARDO#" class="Contenido left right" style="text-align: center"/>
                            <poi:cell value="#Local.rs.CVEPRODSERSAT#" class="Contenido left right"/>
                            <poi:cell value="#Local.rs.STOCKMINIMO#" class="Contenido left right" style="text-align: right"/>
                            <poi:cell value="#Local.rs.STOCKMAXIMO#" class="Contenido left right" style="text-align: right"/>
                        </poi:row>
                    </cfloop>
                </poi:sheet>
            </poi:sheets>
        </poi:document>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="listarInsumosAutoCompleteSolicitudCompraAlmacen" access="public" returntype="Any">

        <cfset arguments.id_Empresa  = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <cfset arguments.id_Almacen  = session.ID_ALMACEN>
       <cfargument name="id_insumo"  type="string"   required="false"/>
       <cfargument name="nb_insumo"  type="string"   required="false"/>
       <cfargument name="page"       type="string"   required="false"/>
       <cfargument name="pageSize"   type="string"   required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="listarInsumosAutoCompleteSolicitudCompraAlmacen"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="ListarInsumosInactivos" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="ListarInsumosInactivos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarInsumosActivos" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="ListarInsumosActivos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarDatosInsumosInactivos" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>
        <cfargument name="id_Insumo"            type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="ListarDatosInsumosInactivos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

        <cffunction name="ListarDatosInsumosActivos" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string"  required="false"/>
        <cfargument name="id_Sucursal"          type="string"  required="false"/>
        <cfargument name="id_Almacen"           type="string"  required="false"/>
        <cfargument name="id_Insumo"            type="string"  required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="ListarDatosInsumosActivos"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

        <cffunction name="ListarDatosAlmacenesExistencias" access="public" returntype="Any">

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="ListarDatosAlmacenesExistencias"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="InsumosServicios" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="string" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                  method="InsumosServicios"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarExistGral" access="public" returntype="Any">
        <cfargument name="insumos"              type="array" required="false"/>
        <cfargument name="id_FamiliaInsumo"     type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>

        <cfif arrayLen(arguments.insumos) GT 0>

            <cfset InfoInsumos = queryNew(
                "ID_EMPRESA, NB_EMPRESA, ID_SUCURSAL, NB_SUCURSAL, ID_ALMACEN, NB_ALMACEN, ID_INSUMO, NB_NOMBREINSUMO, ID_FAMILIAINSUMO, NB_FAMILIAINSUMO, ID_SUBFAMILIAINSUMO, NB_SUBFAMILIAINSUMO, NB_UNIDADMEDIDA, DE_SERIEINSUMO, NU_EXISTENCIA, NU_TRANSITO, NU_PENDSURTIR, FH_ULTIMASALIDA",
                "numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, numeric, varchar, varchar, varchar, numeric, numeric, numeric, varchar,"
            )>
            <cfset InsumosNull = queryNew("id_Insumo", "numeric")>

            <cfloop array="#arguments.insumos#" index="local.i">
                <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                    method="ListarExistGralbyInsumos"
                    id_Insumo="#local.i.ID_INSUMO#"
                    returnvariable="insumos">

                    <cfif insumos.RecordCount == 0 && InsumosNull.RecordCount < 11>
                        <cfset queryAddRow(InsumosNull, [local.i.ID_INSUMO])>
                    </cfif>

                    <cfloop query="#insumos#">
                        <cfset queryAddRow(
                            InfoInsumos, [
                                insumos.ID_EMPRESA,
                                insumos.NB_EMPRESA,
                                insumos.ID_SUCURSAL,
                                insumos.NB_SUCURSAL,
                                insumos.ID_ALMACEN,
                                insumos.NB_ALMACEN,
                                insumos.ID_INSUMO,
                                insumos.NB_NOMBREINSUMO,
                                insumos.ID_FAMILIAINSUMO,
                                insumos.NB_FAMILIAINSUMO,
                                insumos.ID_SUBFAMILIAINSUMO,
                                insumos.NB_SUBFAMILIAINSUMO,
                                insumos.NB_UNIDADMEDIDA,
                                insumos.DE_SERIEINSUMO,
                                insumos.NU_EXISTENCIA,
                                insumos.NU_TRANSITO,
                                insumos.NU_PENDSURTIR,
                                insumos.FH_ULTIMASALIDA,
                            ])>
                    </cfloop>
            </cfloop>

            <cfset Info = structNew()>
            <cfset Info.InfoInsumos = InfoInsumos>
            <cfset Info.InsumosNull = InsumosNull>
        <cfelse>
            <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                method="ListarExistGralbyFamilia"
                argumentcollection="#arguments#"
                returnvariable="InfoInsumos">

            <cfset Info = structNew()>
            <cfset Info.InfoInsumos = InfoInsumos>
        </cfif>

        <cfset variables.RBR.setData(Info)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerHistorialMovimientos" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="string"  required="false"/>
        <cfargument name="id_Insumo"        type="string"  required="false"/>
        <cfargument name="nb_Insumo"        type="string"  required="false"/>
        <cfargument name="id_SubFamilia"    type="string"  required="false"/>
        <cfargument name="sn_InsumoActivo"  type="string"  required="false"/>
        <cfargument name="sn_Relevante"     type="string"  required="false"/>

        <cfinvoke
            component="#Application.RF.getPath('dao','Insumos')#"
            method="obtenerHistorialMovimientos"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
