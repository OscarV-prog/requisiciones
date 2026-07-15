<cfcomponent>

    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>


    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Requisicion"                   type="numeric" required="true"/>
        <cfargument name="id_RequisicionUsuarioAutoriza"    type="numeric" required="false"/>
        <cfargument name="id_Empresa"                       type="numeric" required="false"/>


        <cfset local.DetalleRequisicion=structNew()>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                  method="listaDatosRequisicion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.DatosRequisicion">

        <cfset local.DetalleRequisicion.Requisicion = local.DatosRequisicion>

        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.DetalleReq">

        <cfset local.DetalleRequisicion.DetalleReq= local.DetalleReq>

         <!--- <cfdump var="#local.DetalleRequisicion#"> <cfabort> --->
        <cfset variables.RBR.setData(local.DetalleRequisicion)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="obtener_RequisicionesUsuariosAutorizan" access="public" returntype="Any">
        <cfargument name="id_Empresa"                    type="numeric" required="true"/>
        <cfargument name="id_Requisicion"                type="numeric" required="true"/>
        <cfargument name="id_RequisicionUsuarioAutoriza" type="numeric" required="true"/>



        <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                  method="obtener_RequisicionesUsuariosAutorizan"
                  argumentcollection="#arguments#"
                  returnvariable="Local.DetalleReq">



         <!--- <cfdump var="#local.DetalleRequisicion#"> <cfabort> --->
        <cfset variables.RBR.setData(local.DetalleReq)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="guardarCambios" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="numeric" required="true"/>
        <cfargument name="id_Requisicion" type="numeric" required="true"/>
        <cfargument name="im_Total"       type="string"  required="false"/>
        <cfargument name="Insumos"        type="array"   required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalleCamposDetalle')#"
            method="deletebyrequisiciondetallecampo"
            id_empresa="#Arguments.id_Empresa#"
            id_requisicion="#Arguments.id_Requisicion#">

        <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
            method="deleteByRequisicion"
            id_empresa="#Arguments.id_Empresa#"
            id_requisicion="#Arguments.id_Requisicion#">

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="updatePrecioRequisicion"
            id_Empresa="#Arguments.id_Empresa#"
            id_Requisicion="#Arguments.id_Requisicion#"
            im_Total="#Arguments.im_Total#"
            >

        <cfloop array="#arguments.Insumos#" index="ins">
            <cfif ins.SN_SHOWCOMMENTS NEQ 2> <!--- Si el registro no esta eliminado --->
                <cfinvoke component="#Application.RF.getPath('dao','requisicionesdetalle')#"
                    method="AgregarDetalle"
                    id_Empresa="#Arguments.id_Empresa#"
                    id_Requisicion="#Arguments.id_Requisicion#"
                    id_Insumo="#ins.ID_INSUMO#"
                    nu_Cantidad="#ins.NU_CANTIDAD#"
                    im_PrecioUnitario="#ins.IM_PRECIOUNITARIO#"
                    nu_CantidadSurtida="#ins.NU_CANTIDADSURTIDA#"
                    id_EstatusSurtido="#ins.ID_ESTATUSSURTIDO#"
                    id_SucursalCentroCosto="#ins.ID_SUCURSALCENTROCOSTO#"
                    id_CentroCosto="#ins.ID_CENTROCOSTO#"
                    id_Moneda="#ins.ID_MONEDA#"
                    im_TipoCambio="#ins.IM_TIPOCAMBIO#"
                    id_grupoGasto="#ins.ID_GRUPOGASTO#"
                    id_conceptoGasto="#ins.ID_CONCEPTOGASTO#"
                    id_GrupoCentroCosto="#ins.ID_GRUPOCENTROCOSTO#"
                    nu_kilometraje="#ins.NU_KILOMETRAJE#"
                    de_colaborador="#ins.DE_COLABORADOR#"
                    id_Direccion ="#ins.id_Direccion#"
                    id_TipoInstalacion ="#ins.ID_TIPOINSTALACION#"
                    returnvariable="Local.DetalleReq">

                <cfif #isDefined('ins.CAMPOS')#>
                    <cfloop array="#ins.CAMPOS#" index="cmp">
                        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalleCamposDetalle')#"
                            method="Agregar"
                            id_empresa="#Arguments.id_Empresa#"
                            id_requisicion ="#Arguments.id_Requisicion#"
                            id_requisiciondetalle ="#ins.SN_SHOWCOMMENTS NEQ 2 ? Local.DetalleReq.id_requisiciondetalle : ins.ID_REQUISICIONDETALLE#"
                            id_campodetalle ="#cmp.ID_CAMPODETALLE#"
                            nb_campodetalle="#cmp.NB_CAMPODETALLE#"
                            de_valorcampodetalle="#cmp.DE_VALORCAMPODETALLE#">
                    </cfloop>
                </cfif>
            </cfif>

            <cfif ins.SN_SHOWCOMMENTS NEQ 0>
                <cfinvoke component="#Application.RF.getPath('dao','DetalleRequisicion')#"
                    method="guardarCambiosHistorial"
                    id_Empresa="#Arguments.id_Empresa#"
                    id_SucursalCentroCosto="#ins.ID_SUCURSALCENTROCOSTO#"
                    id_Requisicion="#Arguments.id_Requisicion#"
                    id_RequisicionDetalle="#ins.SN_SHOWCOMMENTS NEQ 2 ? Local.DetalleReq.id_requisiciondetalle : ins.ID_REQUISICIONDETALLE#"
                    id_Insumo="#ins.ID_INSUMO#"
                    im_PrecioUnitario="#ins.IM_PRECIOUNITARIO#"
                    id_Moneda="#ins.ID_MONEDA#"
                    im_TipoCambio="#ins.IM_TIPOCAMBIO#"
                    id_CentroCosto="#ins.ID_CENTROCOSTO#"
                    id_GrupoCentroCosto="#ins.ID_GRUPOCENTROCOSTO#"
                    nu_Cantidad="#ins.NU_CANTIDAD#"
                    nu_Kilometraje="#ins.NU_KILOMETRAJE#"
                    de_Colaborador="#ins.DE_COLABORADOR#"
                    sn_ShowComments="#ins.SN_SHOWCOMMENTS#"
                    sn_NewItem="#ins.SN_NEWITEM#"
                    de_ComentariosMovimientos="#ins.DE_COMENTARIOSEDICION#">
            </cfif>
        </cfloop>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>