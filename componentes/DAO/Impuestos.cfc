<cfcomponent extends="wiz/impuestos">

    <cffunction name="upl_TasasIvaPorSucursal" access="public" returntype="Query">
        <cfargument name="id_Empresa"           type="numeric" required="true">
        <cfargument name="id_Sucursal"          type="numeric" required="true">

        <cfquery  name="Local.RSImpuestos" datasource="#variables.cnx#">
            EXEC upl_TasasIvaPorSucursal
                    @id_Empresa = #Arguments.id_Empresa#,
                    @id_Sucursal = #Arguments.id_Sucursal#
        </cfquery>

        <cfreturn Local.RSImpuestos />
    </cffunction>

    <cffunction name="GetProductoInsumoImpuestosTasas" access="public" returntype="any">
        <cfargument name="id_Empresa"           type="numeric" required="true">
        <cfargument name="id_Producto"          type="string" required="false" default="">
        <cfargument name="id_Insumo"            type="string" required="false" default="">
        <cfargument name="id_Cliente"           type="string" required="false" default="">
        <cfargument name="id_Sucursal"          type="string" required="false" default="">
        <cfargument name="cl_TipoDocumento"     type="string" required="false" default="">
        <cfargument name="id_Estacion"          type="string" required="false" default="">
        <cfargument name="fh_Remisiones"        type="string" required="false" default="">

        <cfset local.ResultStruct = structNew()>
        <cfstoredproc procedure="upL_ProductoInsumoImpuestosTasas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Producto"      value="#arguments.id_Producto#"         null="#iif(isNumeric(arguments.id_Producto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"        value="#arguments.id_Insumo#"           null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Cliente"       value="#arguments.id_Cliente#"          null="#iif(isNumeric(arguments.id_Cliente),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"dbvarname="@id_Sucursal"      value="#arguments.id_Sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_TipoDocumento" value="#arguments.cl_TipoDocumento#"    null="#iif(Len(arguments.cl_TipoDocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estacion"      value="#arguments.id_Estacion#"         null="#iif(isNumeric(arguments.id_Estacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Remisiones"    value="#arguments.fh_Remisiones#"       null="#iif(Len(arguments.fh_Remisiones),false,true)#">
                        
            <cfprocresult name="local.ResultStruct.Impuestos" resultset="1">
            <cfprocresult name="local.ResultStruct.Descuentos" resultset="2">
        </cfstoredproc>


        <cfreturn Local.ResultStruct />
    </cffunction>

    
    <cffunction name="getDefault" access="public" returntype="Query">
        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            EXEC upL_impuestosDefault
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>


    <cffunction name="listarImpuestosparaRegistroComprasCombustibles" access="public" returntype="Query">
        <cfquery  name="Local.Impuestos" datasource="#variables.cnx#">
            EXEC upL_ImpuestosparaRegistroComprasCombustibles
        </cfquery>

        <cfreturn Local.Impuestos />
    </cffunction>

    <cffunction name="listarImpuestosEdicionRegistroComprasCombustible" access="public" returntype="Query">
    <cfargument name='id_Empresa'                     type='numeric'  required='true'>      
    <cfargument name='id_RegistroCompraCombustible'   type='numeric'  required='true'>

        <cfquery  name="Local.Impuestos" datasource="#variables.cnx#">
            EXEC upL_RegistroComprasCombustibleparaEdicion
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_RegistroCompraCombustible#
        </cfquery>

        <cfreturn Local.Impuestos />
    </cffunction>

    <cffunction name="getByOrdenDeCompra" access="public" returntype="Query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="id_ordenDeCompra" type="numeric" required="true">

        <cfquery  name="Local.Impuestos" datasource="#variables.cnx#">
            EXEC upL_ImpuestosByOrdenDeCompra #Arguments.id_Empresa#,#Arguments.id_ordenDeCompra#
        </cfquery>

        <cfreturn Local.Impuestos />
    </cffunction>

    <!--- funcion que devuelve los impuestos que se le aplicaran a la orden de compra que se generar
        17/10/2015 --->
    <cffunction name="getimpuestosgeneraroc" access="public" returntype="Query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="id_solicitudcompra" type="numeric" required="true">

        <cfquery  name="Local.Impuestos" datasource="#variables.cnx#">
            EXEC upL_Impuestospararegistrarordendecompra
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_solicitudcompra#
        </cfquery>
        <cfreturn Local.Impuestos />
    </cffunction>

    <!--- funcion que devuelve los impuestos que se le aplicaran a la orden de compra que se generan desde la pantalla de cotizaciones
        04-11-2015 --->
    <cffunction name="getimpuestosgeneraroccotizaciones" access="public" returntype="Query">
        <cfargument name="id_Empresa"           type="numeric" required="true">
        <cfargument name="id_tiporequisicion"   type="numeric" required="true">

        <cfquery  name="Local.Impuestos" datasource="#variables.cnx#">
            EXEC upL_Impuestospararegistrarordendecompracotizaciones
                                                    #arguments.id_Empresa#,
                                                    #arguments.id_tiporequisicion#
        </cfquery>
        <cfreturn Local.Impuestos />
    </cffunction>

    <cffunction name="impuestosTazas" access="public" returntype="Query">
        <cfargument name="id_empresa"   type="string" required="true">
        <cfargument name="id_impuesto"  type="string" required="true">
        
        <cfstoredproc procedure="upR_impuestosTazas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"  value="#arguments.id_empresa#"  null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_impuesto" value="#arguments.id_impuesto#" null="#iif(isNumeric(arguments.id_impuesto),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="TiposComprobantesImpuestos" access="public" returntype="Query">
        <cfargument name="id_tipoComprobante"   type="string" required="true">
        <cfstoredproc procedure="upR_TiposComprobantesImpuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoComprobante" value="#arguments.id_tipoComprobante#" null="#iif(isNumeric(arguments.id_tipoComprobante),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs />
    </cffunction>

    <cffunction name="impuestosTazasDefault" access="public" returntype="Query">
        <cfquery  name="Local.rs" datasource="#variables.cnx#">
            EXEC upL_impuestosTazasDefault #session.ID_EMPRESA#
        </cfquery>

        <cfreturn Local.rs />
    </cffunction>

    <!---   IMPUESTOS   --->
    <cffunction name="getListadoImpuestos" access="public" returntype="any">
        <cfargument name="id_Impuesto"      type="string" required="false" default=""/>
        <cfargument name="cl_Naturaleza"    type="string" required="false" default=""/>
        <cfargument name="page"             type="string" required="false" default="">
        <cfargument name="pageSize"         type="string" required="false" default="">

        <cfstoredproc procedure="upL_Impuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Impuesto"      value="#arguments.id_Impuesto#"     null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_Naturaleza"    value="#arguments.cl_Naturaleza#"   null="#iif(Len(arguments.cl_Naturaleza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"             value="#arguments.page#"            null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"         value="#arguments.pageSize#"        null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

     <cffunction name="getComboImpuestos" access="public" returntype="any">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            EXEC upR_Impuestos
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="agregarImpuesto" access="remote" returnformat="JSON">
        <cfargument name="nb_Impuesto"           type="string" required="true"/>
        <cfargument name="pj_Aplicar"            type="string" required="true"/>
        <cfargument name="cl_Naturaleza"         type="string" required="true"/>
        <cfargument name="id_ImpuestoReferencia" type="string" required="false" default=""/>
        <cfargument name="c_ImpuestoSAT"         type="string" required="false" default=""/>
        <cfargument name="sn_Sistema"            type="string" required="false" default=""/>
        <cfargument name="sn_Iva"                type="string" required="false" default=""/>
        <cfargument name="sn_AplicableDefault"   type="string" required="false" default=""/>
        
        <cfstoredproc procedure="upC_Impuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Impuesto"           value="#arguments.nb_Impuesto#"            null="#iif(Len(arguments.nb_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@pj_Aplicar"            value="#arguments.pj_Aplicar#"             null="#iif(isNumeric(arguments.pj_Aplicar),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_CHAR"    dbvarname="@cl_Naturaleza"         value="#arguments.cl_Naturaleza#"          null="#iif(Len(arguments.cl_Naturaleza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ImpuestoReferencia" value="#arguments.id_ImpuestoReferencia#"  null="#iif(isNumeric(arguments.id_ImpuestoReferencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@c_ImpuestoSAT"         value="#arguments.c_ImpuestoSAT#"          null="#iif(Len(arguments.c_ImpuestoSAT),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Sistema"            value="#arguments.sn_Sistema#"             null="#iif(isBoolean(arguments.sn_Sistema),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Iva"                value="#arguments.sn_Iva#"                 null="#iif(isBoolean(arguments.sn_Iva),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_AplicableDefault"   value="#arguments.sn_AplicableDefault#"    null="#iif(isBoolean(arguments.sn_AplicableDefault),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="editarImpuesto" access="remote" returnformat="JSON">
        <cfargument name="id_Impuesto"           type="string" required="true"/> 
        <cfargument name="nb_Impuesto"           type="string" required="true"/>
        <cfargument name="pj_Aplicar"            type="string" required="true"/>
        <cfargument name="cl_Naturaleza"         type="string" required="true"/>
        <cfargument name="id_ImpuestoReferencia" type="string" required="false" default=""/>
        <cfargument name="c_ImpuestoSAT"         type="string" required="false" default=""/>
        <cfargument name="sn_Sistema"            type="string" required="false" default=""/>
        <cfargument name="sn_Iva"                type="string" required="false" default=""/>
        <cfargument name="sn_AplicableDefault"   type="string" required="false" default=""/>
        
        <cfstoredproc procedure="upU_Impuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Impuesto"           value="#arguments.id_Impuesto#"            null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Impuesto"           value="#arguments.nb_Impuesto#"            null="#iif(Len(arguments.nb_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@pj_Aplicar"            value="#arguments.pj_Aplicar#"             null="#iif(isNumeric(arguments.pj_Aplicar),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_CHAR"    dbvarname="@cl_Naturaleza"         value="#arguments.cl_Naturaleza#"          null="#iif(Len(arguments.cl_Naturaleza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ImpuestoReferencia" value="#arguments.id_ImpuestoReferencia#"  null="#iif(isNumeric(arguments.id_ImpuestoReferencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@c_ImpuestoSAT"         value="#arguments.c_ImpuestoSAT#"          null="#iif(Len(arguments.c_ImpuestoSAT),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Sistema"            value="#arguments.sn_Sistema#"             null="#iif(isBoolean(arguments.sn_Sistema),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Iva"                value="#arguments.sn_Iva#"                 null="#iif(isBoolean(arguments.sn_Iva),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_AplicableDefault"   value="#arguments.sn_AplicableDefault#"    null="#iif(isBoolean(arguments.sn_AplicableDefault),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <!---   IMPUESTOS TASAS   --->
    <cffunction name="getListadoImpuestosTasas" access="public" returntype="any">
        <cfargument name="id_Impuesto"   type="string" required="false" default=""/>
        <cfargument name="cl_Naturaleza" type="string" required="false" default=""/>
        <cfargument name="nu_Tasa"       type="string" required="false" default=""/>
        <cfargument name="page"          type="string" required="false" default="">
        <cfargument name="pageSize"      type="string" required="false" default="">

        <cfstoredproc procedure="upL_ImpuestosTasasGeneral" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"    value="#session.ID_EMPRESA#"       null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Impuesto"   value="#arguments.id_Impuesto#"    null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_CHAR"    dbvarname="@cl_Naturaleza" value="#arguments.cl_Naturaleza#"  null="#iif(Len(arguments.cl_Naturaleza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@nu_Tasa"       value="#arguments.nu_Tasa#"        null="#iif(Len(arguments.nu_Tasa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"          value="#arguments.page#"           null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"      value="#arguments.pageSize#"       null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="agregarImpuestoTasas" access="remote" returnformat="JSON">
        <cfargument name="id_Impuesto"          type="string" required="true"/>
        <cfargument name="nu_Taza"              type="string" required="true"/>
        <cfargument name="de_ImpuestoTaza"      type="string" required="true"/>
        <cfargument name="sn_AplicableDefault"  type="string" required="false" default=""/>
        <cfargument name="nu_TasaFrontera"      type="string" required="false" default=""/>

        <cfstoredproc procedure="upC_ImpuestosTasas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Empresa"           value="#session.ID_EMPRESA#"            null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Impuesto"          value="#arguments.id_Impuesto#"         null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@nu_Taza"              value="#arguments.nu_Taza#"             null="#iif(isNumeric(arguments.nu_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ImpuestoTaza"      value="#arguments.de_ImpuestoTaza#"     null="#iif(Len(arguments.de_ImpuestoTaza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_AplicableDefault"  value="#arguments.sn_AplicableDefault#" null="#iif(isBoolean(arguments.sn_AplicableDefault),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@nu_TasaFrontera"      value="#arguments.nu_TasaFrontera#"     null="#iif(isNumeric(arguments.nu_TasaFrontera),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="editarImpuestoTasas" access="remote" returnformat="JSON">
        <cfargument name="id_Impuesto"          type="string" required="true"/>
        <cfargument name="id_Taza"              type="string" required="true"/>
        <cfargument name="nu_Taza"              type="string" required="true"/>
        <cfargument name="de_ImpuestoTaza"      type="string" required="true"/>
        <cfargument name="sn_AplicableDefault"  type="string" required="true"/>
        <cfargument name="nu_TasaFrontera"      type="string" required="true"/>

        <cfstoredproc procedure="upU_ImpuestosTasas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Empresa"           value="#session.ID_EMPRESA#"            null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Impuesto"          value="#arguments.id_Impuesto#"         null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Taza"              value="#arguments.id_Taza#"             null="#iif(isNumeric(arguments.id_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@nu_Taza"              value="#arguments.nu_Taza#"             null="#iif(isNumeric(arguments.nu_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ImpuestoTaza"      value="#arguments.de_ImpuestoTaza#"     null="#iif(Len(arguments.de_ImpuestoTaza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_AplicableDefault"  value="#arguments.sn_AplicableDefault#" null="#iif(isBoolean(arguments.sn_AplicableDefault),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"   dbvarname="@nu_TasaFrontera"      value="#arguments.nu_TasaFrontera#"     null="#iif(isNumeric(arguments.nu_TasaFrontera),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getListadoImpuestosTasasByEmpresa" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa" type="string" required="true"/>

        <cfstoredproc procedure="upL_ImpuestosTasas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT" dbvarname="@id_Empresa" value="#session.ID_EMPRESA#" null="#iif(isNumeric(session.ID_EMPRESA),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="GuardarImpuestosCMF" access="remote" returntype="void">
        <cfargument name="id_Empresa"       type="string"   required="true"/>
        <cfargument name="id_Requisicion"   type="string"   required="true"/>
        <cfargument name="id_Impuesto"      type="string"   required="true"/>
        <cfargument name="id_Taza"          type="string"   required="true"/>
        <cfargument name="nu_Taza"          type="string"   required="true"/>
        <cfargument name="im_Impuesto"      type="string"   required="true"/>
        <cfargument name="cl_Naturaleza"    type="string"   required="true"/>

        <cfstoredproc procedure="upC_Requisicion_CargaMasivaImpuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Requisicion"   value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Impuesto"      value="#arguments.id_Impuesto#"       null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Taza"          value="#arguments.id_Taza#"           null="#iif(isNumeric(arguments.id_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@nu_Taza"          value="#arguments.nu_Taza#"           null="#iif(isNumeric(arguments.nu_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Impuesto"      value="#arguments.im_Impuesto#"       null="#iif(isNumeric(arguments.im_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_Naturaleza"    value="#arguments.cl_Naturaleza#"     null="#iif(len(arguments.cl_Naturaleza),false,true)#">
        </cfstoredproc>

        <cfreturn/>
    </cffunction>

    <cffunction name="EliminarImpuestosCMF" access="remote" returntype="void">
        <cfargument name="id_Empresa"       type="string"   required="true"/>
        <cfargument name="id_Requisicion"   type="string"   required="true"/>

        <cfstoredproc procedure="upD_Requisicion_CargaMasivaImpuestos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Requisicion"   value="#arguments.id_Requisicion#"    null="#iif(isNumeric(arguments.id_Requisicion),false,true)#">
        </cfstoredproc>

        <cfreturn />
    </cffunction>

</cfcomponent>