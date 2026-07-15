<cfcomponent extends="wiz/sucursales">

  <cffunction name="listar" access="public" returntype="query">
      <cfargument name="id_Empresa"                    type="numeric" required="true"/>
      <cfargument name="id_Usuario"                    type="numeric" required="true"/>
      <cfargument name="id_OrdenCompra"                type="string"  required="false"/>
      <cfargument name="id_SucursaListado"             type="string"  required="false"/>
      <cfargument name="fh_InicioListado"              type="string"  required="false"/>
      <cfargument name="fh_FinListado"                 type="string"  required="false"/>
      <cfargument name="id_DepartamentoListado"        type="string"  required="false"/>
      <cfargument name="id_EstatusAutorizacionListado" type="string"  required="false"/>
      <cfargument name="id_EstatusSurtidoListado"      type="string"  required="false" default=""/>
      <cfargument name="nu_Siniestro"                  type="string"  required="false" default=""/>
      <cfargument name="id_TipoDocumento"              type="string"  required="false"/>

      <cfstoredproc procedure="upL_OrdenesCompra" datasource="#variables.cnx#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"                    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"           value="#arguments.id_OrdenCompra#"                null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"              value="#arguments.id_SucursaListado#"             null="#iif(isNumeric(arguments.id_SucursaListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"                value="#arguments.fh_InicioListado#"              null="#iif(len(arguments.fh_InicioListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin"                   value="#arguments.fh_FinListado#"                 null="#iif(len(arguments.fh_FinListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Departamento"          value="#arguments.id_DepartamentoListado#"        null="#iif(isNumeric(arguments.id_DepartamentoListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacion"   value="#arguments.id_EstatusAutorizacionListado#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"               value="#arguments.id_Usuario#"                    null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusSurtidoListado" value="#arguments.id_EstatusSurtidoListado#"      null="#iif(isNumeric(arguments.id_EstatusSurtidoListado),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_Siniestro"             value="#arguments.nu_Siniestro#"                  null="#iif(len(arguments.nu_Siniestro),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoDocumento"         value="#arguments.id_TipoDocumento#"              null="#iif(isNumeric(arguments.id_TipoDocumento),false,true)#">
          <cfprocresult name="Local.OrdenesCompras" resultset="1">
      </cfstoredproc>

      <cfreturn Local.OrdenesCompras/>
  </cffunction>


  <cffunction name="Editar" access="public" returntype="void">
      <cfargument name="id_Empresa"                           type="numeric" required="true"/>
      <cfargument name="id_OrdenCompra"                       type="numeric" required="true"/>
    <cfargument name="id_EstatusAutorizacionOrdenCompra"  type="numeric" required="true"/>
    <cfargument name="id_Usuario"                         type="numeric" required="true"/>
      <cfargument name="de_Observaciones"                     type="string" required="true"/>

  <cfstoredproc procedure="upU_OrdenesDeComprasUsuariosAutorizacion" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                         value="#arguments.id_Empresa#"                        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"                     value="#arguments.id_OrdenCompra#"                    null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacionOrdenCompra"  value="#arguments.id_EstatusAutorizacionOrdenCompra#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionOrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"                         value="#session.ID_USUARIO#"                          null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Observaciones"                   value="#arguments.de_Observaciones#"                  null="#iif(len(arguments.de_Observaciones),false,true)#">
  </cfstoredproc>

  </cffunction>


  <cffunction name="EditarOrdenCompraGeneral" access="public" returntype="void">
      <cfargument name="id_Empresa"                           type="numeric" required="true"/>
      <cfargument name="id_OrdenCompra"                       type="numeric" required="true"/>
      <cfargument name="id_EstatusAutorizacionOrdenCompra"    type="numeric" required="true"/>
      <cfargument name="id_Sucursal"                          type="numeric" required="false"/>
      <cfargument name="id_Almacen"                           type="string" required="false"/>

  <cfstoredproc procedure="upU_OrdenesDeCompras" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"             value="#arguments.id_Empresa#"                        null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"         value="#arguments.id_OrdenCompra#"                    null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusOrdenComprar" value="#arguments.id_EstatusAutorizacionOrdenCompra#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionOrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"            value="#arguments.id_Sucursal#"                       null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"             value="#arguments.id_Almacen#"                        null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
  </cfstoredproc>


  </cffunction>


  <cffunction name="listarOrdenesAsignadasaUsuarios" access="public" returntype="query">
      <cfargument name="id_Empresa"               type="numeric" required="true"/>
      <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
      <cfargument name="sn_PreAutorizacion"       type="string"  required="false" default="false"/>

  <cfstoredproc procedure="upL_OrdenesComprasUsuariosAutorizanEstatusAutorizaciones" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"     value="#arguments.id_OrdenCompra#"      null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@sn_PreAutorizacion" value="#arguments.sn_PreAutorizacion#"  null="#iif(len(arguments.sn_PreAutorizacion),false,true)#">
    <cfprocresult name="Local.listaestatus" resultset="1">
  </cfstoredproc>

      <cfreturn local.listaestatus>
  </cffunction>

<!--- Victor Sanchez
    Date: 30/09/2015
    lee si un usuario tiene ordenes de compras pendientes para autorizar
    Regresa 1 si existen, 0 si no existen --->
  <cffunction name="sn_ObtenerOCPendientesByUsuario" access="public" returntype="query">
      <cfargument name="id_usuario"               type="string" required="true"/>
    <cfstoredproc procedure="upR_OrdenesComprasPendiente" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_usuario"     value="#arguments.id_usuario#"  null="#iif(isNumeric(arguments.id_usuario),false,true)#">
      <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

          <cfreturn local.rs>
  </cffunction>

  <cffunction name="listarInformacionOrdenCompra" access="public" returntype="query">
      <cfargument name="id_Empresa"               type="numeric" required="true"/>
      <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>
      <cfargument name="id_Usuario"               type="numeric" required="true"/>
      <cfargument name="id_Cotizacion"            type="numeric" required="true"/>

    <cfstoredproc procedure="upL_OrdenesComprasInformacionparaEmail" datasource="#variables.cnx#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_OrdenCompra"    value="#arguments.id_OrdenCompra#"   null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Cotizacion"  value="#arguments.id_Cotizacion#" null="#iif(isNumeric(arguments.id_Cotizacion),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Usuario"     value="#arguments.id_Usuario#"    null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
              <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>

          <cfreturn local.rs>
  </cffunction>

<!--- Victor Sanchez
      19/10/2015
      Lista ordenes de compra tipo servicio --->
  <cffunction name="listar_OrdenesCompraServicios" access="public" returntype="query">
      <cfargument name="id_Empresa"           type="numeric"  required="true"/>
      <cfargument name="id_Sucursal"          type="string"   required="false"/>
      <cfargument name="nb_proveedor"         type="string"   required="false"/>
      <cfargument name="fh_inicio"            type="string"   required="false"/>
      <cfargument name="fh_fin"               type="string"   required="false"/>
      <cfargument name="id_Usuario"           type="string"   required="false"/>
      <cfargument name="nu_Siniestro"         type="string" required="false"/>

          <cfstoredproc procedure="upL_OrdenesComprasServicios" datasource="#variables.cnx#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"  value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_proveedor" value="#arguments.id_proveedor#"  null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Inicio"    value="#arguments.fh_Inicio#"     null="#iif(len(arguments.fh_Inicio),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Fin"       value="#arguments.fh_Fin#"        null="#iif(len(arguments.fh_Fin),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Usuario"   value="#arguments.id_Usuario#"    null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Siniestro" value="#arguments.nu_Siniestro#"  null="#iif(len(arguments.nu_Siniestro),false,true)#">
              <cfprocresult name="Local.OrdenesCompras" resultset="1">
    </cfstoredproc>

      <cfreturn Local.OrdenesCompras/>
  </cffunction>

<!--- Victor Sanchez
      19/10/2015
      agrega el gastoMovimiento --->
  <cffunction name="agregarGastoMovimiento" access="public" returntype="string">
      <cfargument name="id_Empresa"                       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"                      type="numeric" required="true"/>
    <cfargument name="id_TipoMovimiento"              type="numeric" required="true"/>
    <cfargument name="fh_Movimiento"                  type="string" required="true"/>
      <cfargument name="fl_FacturaRemision"               type="string" required="true"/>
      <cfargument name="fh_FacturaRemision"               type="string" required="true"/>
      <cfargument name="im_TotalMN"                       type="string" required="true"/>
      <cfargument name="de_Entrego"                       type="string" required="no"/>
      <cfargument name="id_OrdenCompra"                   type="string" required="true"/>
      <cfargument name="de_Comentarios"                   type="string" required="no"/>
      <cfargument name="id_UsuarioRegistroMovimiento"     type="string" required="true"/>
      <cfargument name="fh_Registro"                      type="string" required="true"/>
      <cfargument name="id_Poliza"                        type="string" required="no"/>
      <cfargument name="id_SucursalMovimiento"                        type="numeric" required="true"/>


  <cfstoredproc procedure="upC_GastoMovimiento" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"                   value="#arguments.id_Empresa#"                      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Sucursal"                  value="#arguments.id_Sucursal#"                     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoMovimiento"            value="#arguments.id_TipoMovimiento#"               null="#iif(isNumeric(arguments.id_TipoMovimiento),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Movimiento"                value="#arguments.fh_Movimiento#"                   null="#iif(isNumeric(arguments.fh_Movimiento),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fl_FacturaRemision"           value="#arguments.fl_FacturaRemision#"              null="#iif(Len(arguments.fl_FacturaRemision),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_FacturaRemision"           value="#arguments.fh_FacturaRemision#"              null="#iif(isNumeric(arguments.fh_FacturaRemision),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@im_TotalMN"                   value="#arguments.im_TotalMN#"                      null="#iif(isNumeric(arguments.im_TotalMN),false,true)#" scale="10">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_Entrego"                   value="#arguments.de_Entrego#"                      null="#iif(Len(arguments.de_Entrego),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_OrdenCompra"               value="#arguments.id_OrdenCompra#"                  null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_Comentarios"               value="#arguments.de_Comentarios#"                  null="#iif(Len(arguments.de_Comentarios),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioRegistroMovimiento" value="#arguments.id_UsuarioRegistroMovimiento#"    null="#iif(isNumeric(arguments.id_UsuarioRegistroMovimiento),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@fh_Registro"                  value="#arguments.fh_Registro#"                     null="#iif(Len(arguments.fh_Registro),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Poliza"                    value="#arguments.id_Poliza#"                       null="#iif(isNumeric(arguments.id_Poliza),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_SucursalMovimiento"        value="#arguments.id_SucursalMovimiento#"           null="#iif(isNumeric(arguments.id_SucursalMovimiento),false,true)#">

    <cfprocresult name="Local.rs" resultset="1">
  </cfstoredproc>

      <cfreturn local.rs.NEXTID />
  </cffunction>


  <cffunction name="agregarGastoMovimientoDetalle" access="public" returntype="query">
      <cfargument name="id_Empresa"              type="numeric" required="true"/>
      <cfargument name="id_Sucursal"             type="numeric" required="true"/>
      <cfargument name="id_Movimiento"           type="numeric" required="true"/>
      <cfargument name="id_Insumo"               type="string"  required="true"/>
      <cfargument name="id_CentroCosto"          type="string"  required="true"/>
      <cfargument name="nu_Cantidad"             type="string"  required="true"/>
      <cfargument name="NU_CANTIDADRECIBIDA"     type="string"  required="no"/>
      <cfargument name="im_PrecioUnitario"       type="string"  required="true"/>
      <cfargument name="im_PrecioTotalEntrada"   type="string"  required="no"/>
      <cfargument name="id_Moneda"               type="string"  required="true"/>
      <cfargument name="im_TipoCambio"           type="string"  required="true"/>
      <cfargument name="im_TotalMN"              type="string"  required="no"/>
      <cfargument name="id_TipoCosteo"           type="string"  required="no"/>
      <cfargument name="id_OrdenDeCompra"        type="string"  required="no"/>
      <cfargument name="id_OrdenDeCompraDetalle" type="string"  required="no"/>
      <cfargument name="id_GrupoGasto"           type="string"  required="no" default=""/>
      <cfargument name="id_ConceptoGasto"        type="string"  required="no" default=""/>
      <cfargument name="id_Poliza"               type="string"  required="no"/>
      <cfargument name="id_TipoMovimiento"       type="string"  required="no"/>
      <cfargument name="contador"                type="string"  required="no"/>
      <cfargument name="id_RequisicionDetalle"   type="string"  required="no"/>
      <cfargument name="id_GrupoCentroCosto"     type="string"  required="no"/>
      <cfargument name="ff_Presupuestos"         type="string"  required="no"/>

  <cfstoredproc procedure="upC_GastosMovimientoDetalle" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"                 value="#arguments.id_Empresa#"                      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_Sucursal"                value="#arguments.id_Sucursal#"                     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Movimiento"              value="#arguments.id_Movimiento#"                   null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"  dbvarname="@id_Insumo"                  value="#arguments.id_Insumo#"                        null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_CentroCosto"             value="#arguments.id_CentroCosto#"                  null="#iif(isNumeric(arguments.id_CentroCosto),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@nu_Cantidad"                value="#arguments.NU_CANTIDADRECIBIDA#"             null="#iif(isNumeric(arguments.NU_CANTIDADRECIBIDA),false,true)#" scale="9">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@nu_CantidadFacturada"       value="#arguments.NU_CANTIDADRECIBIDA#"             null="#iif(isNumeric(arguments.NU_CANTIDADRECIBIDA),false,true)#" scale="9">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@im_PrecioUnitarioEntrada"   value="#arguments.im_PrecioUnitario#"               null="#iif(isNumeric(arguments.im_PrecioUnitario),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@im_PrecioTotalEntrada"      value="#arguments.im_PrecioTotalEntrada#"           null="#iif(isNumeric(arguments.im_PrecioTotalEntrada),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_MonedaEntrada"           value="#arguments.id_Moneda#"                       null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_FLOAT"     dbvarname="@im_TipoCambioEntrada"       value="#arguments.im_TipoCambio#"                   null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_DECIMAL"   dbvarname="@im_TotalMN"                 value="#arguments.im_TotalMN#"                      null="#iif(isNumeric(arguments.im_TotalMN),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_TipoCosteo"              value="#arguments.id_TipoCosteo#"                   null="#iif(isNumeric(arguments.id_TipoCosteo),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_OrdenDeCompra"           value="#arguments.id_OrdenDeCompra#"                null="#iif(isNumeric(arguments.id_OrdenDeCompra),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_OrdenDeCompraDetalle"    value="#arguments.id_OrdenDeCompraDetalle#"         null="#iif(isNumeric(arguments.id_OrdenDeCompraDetalle),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_GrupoGasto"              value="#arguments.id_GrupoGasto#"                   null="#iif(isNumeric(arguments.id_GrupoGasto),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_ConceptoGasto"           value="#arguments.id_ConceptoGasto#"                null="#iif(isNumeric(arguments.id_ConceptoGasto),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Poliza"                  value="#arguments.id_Poliza#"                       null="#iif(isNumeric(arguments.id_Poliza),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_TipoMovimiento"          value="#arguments.id_TipoMovimiento#"               null="#iif(isNumeric(arguments.id_TipoMovimiento),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@contador"                   value="#arguments.contador#"                        null="#iif(isNumeric(arguments.contador),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_RequisicionDetalle"      value="#arguments.id_RequisicionDetalle#"           null="#iif(isNumeric(arguments.id_RequisicionDetalle),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_GrupoCentroCosto"        value="#arguments.id_GrupoCentroCosto#"             null="#iif(isNumeric(arguments.id_GrupoCentroCosto),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@ff_Presupuestos"            value="#arguments.ff_Presupuestos#"                 null="#iif(isNumeric(arguments.ff_Presupuestos),false,true)#">
    <cfprocresult name="Local.rs" resultset="1">
  </cfstoredproc>

  <cfreturn Local.rs/>
  </cffunction>


  <cffunction name="GuardarImpuestos" access="public" returntype="void">
    <cfargument name="id_Empresa"            type="numeric" required="true"/>
    <cfargument name="id_Sucursal"           type="numeric" required="true"/>
    <cfargument name="id_Movimiento"         type="numeric" required="true"/>
    <cfargument name="id_Impuesto"           type="string"  required="true"/>
    <cfargument name="pj_Aplicar"            type="string"  required="true"/>
    <cfargument name="im_AplicacionImpuesto" type="string"  required="true"/>

    <cfstoredproc procedure="upC_GastoMovimientoImpuesto" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"           value="#arguments.id_Sucursal#"           null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"         value="#arguments.id_Movimiento#"         null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Impuesto"           value="#arguments.id_Impuesto#"           null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@pj_Aplicar"            value="#arguments.pj_Aplicar#"            null="#iif(isNumeric(arguments.pj_Aplicar),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_AplicacionImpuesto" value="#arguments.im_AplicacionImpuesto#" null="#iif(isNumeric(arguments.im_AplicacionImpuesto),false,true)#">
    </cfstoredproc>

  </cffunction>


  <cffunction name="CambiarEstatusSurtidoCancelacionDeDocumento" access="public" returntype="void">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_Almacen"       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"      type="numeric" required="true"/>
    <cfargument   name="id_Movimiento"  type="numeric" required="true"/>

  <cfstoredproc procedure="upR_OrdenesCompraCambiarEstatusSurtidoCancelacionDeDocumento" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
  </cfstoredproc>
  </cffunction>

  <cffunction name="CambiarEstatusSurtidoCancelarSalidaDevolucion" access="public" returntype="void">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_Almacen"       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"      type="numeric" required="true"/>
    <cfargument name="id_Movimiento"  type="numeric" required="true"/>

  <cfstoredproc procedure="upU_OrdenesCompraCambiarEstatusSurtidoCancelarEntradaDevolucion" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
  </cfstoredproc>

  </cffunction>

  <cffunction name="CambiarEstatusSurtidoCancelarEntradaDevolucion" access="public" returntype="void">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_Almacen"       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"      type="numeric" required="true"/>
    <cfargument name="id_Movimiento"  type="numeric" required="true"/>

  <cfstoredproc procedure="upU_OrdenesCompraCambiarEstatusSurtidoCancelarEntradaDevolucion" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
  </cfstoredproc>

  </cffunction>

  <cffunction name="OCDetalleRestarCantidadSurtida" access="public" returntype="void">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_Almacen"       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"      type="numeric" required="true"/>
    <cfargument name="id_Movimiento"  type="numeric" required="true"/>

  <cfstoredproc procedure="upU_OrdenesDeCompraDetalleRestarCantidadSurtida" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
  </cfstoredproc>

  </cffunction>

  <cffunction name="OCDetalleSumarCantidadSurtida" access="public" returntype="void">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_Almacen"       type="numeric" required="true"/>
      <cfargument name="id_Sucursal"      type="numeric" required="true"/>
    <cfargument name="id_Movimiento"  type="numeric" required="true"/>

  <cfstoredproc procedure="upU_OrdenesDeCompraDetalleSumarCantidadSurtida" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">

  </cfstoredproc>

  </cffunction>


  <cffunction name="getRequisitanteTipoServicios" access="public" returntype="query">
      <cfargument name="id_Empresa"       type="numeric" required="true"/>
      <cfargument name="id_ordencompra"   type="numeric" required="true"/>

  <cfstoredproc procedure="upR_OrdenesDeCompraGetRequisitanteTipoServicios" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ordencompra" value="#arguments.id_ordencompra#" null="#iif(isNumeric(arguments.id_ordencompra),false,true)#">
    <cfprocresult name="Local.rs" resultset="1">
  </cfstoredproc>

      <cfreturn Local.rs/>
  </cffunction>

  <cffunction name="listarCentrosCostos" access="public" returntype="query">
      <cfargument name="id_Empresa"     type="string" required="false" default=""/>
      <cfargument name="id_OrdenCompra" type="string" required="false" default=""/>

          <cfstoredproc procedure="upR_OrdenesDeCompraCentrosCostos" datasource="#variables.cnx#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"       value="#arguments.id_Empresa#"     null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenDeCompra" value="#arguments.id_OrdenCompra#" null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
              <cfprocresult name="Local.rs" resultset="1">
          </cfstoredproc>

      <cfreturn Local.rs/>
</cffunction>

<cffunction name="CancelarSalidaDeConsumo" access="public" returntype="void">
  <cfargument name="id_Empresa"       type="numeric" required="true"/>
  <cfargument name="id_Almacen"       type="numeric" required="true"/>
  <cfargument name="id_Sucursal"      type="numeric" required="true"/>
  <cfargument name="id_Movimiento"    type="numeric" required="true"/>

  <cfstoredproc procedure="upU_RequisicionDetalleCancelarSalidaDevolucion" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"    value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Almacen"     value="#arguments.id_Almacen#"    null="#iif(isNumeric(arguments.id_Almacen),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Movimiento"  value="#arguments.id_Movimiento#" null="#iif(isNumeric(arguments.id_Movimiento),false,true)#">
  </cfstoredproc>
</cffunction>


<cffunction name="AutorizarOCEdenred" access="public" returntype="query">
  <cfargument name="id_Empresa"                type="string" required="no" default="">
  <cfargument name="id_SolicitudPago"          type="string" required="no" default="">
  <cfargument name="id_OrdenCompra"            type="string" required="no" default="">
  <cfargument name="id_EstatusAutorizacionOC"  type="string" required="no" default="">
  <cfstoredproc procedure="spC_AutorizarOC_Edenred" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"               null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SolicitudPago"         value="#arguments.id_SolicitudPago#"         null="#iif(isNumeric(arguments.id_SolicitudPago),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_OrdenCompra"           value="#arguments.id_OrdenCompra#"           null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EstatusAutorizacionOC" value="#arguments.id_EstatusAutorizacionOC#" null="#iif(isNumeric(arguments.id_EstatusAutorizacionOC),false,true)#">
      <cfprocresult name="Local.rs" resultset="2">
    </cfstoredproc>
    
    <cfreturn Local.rs/>
</cffunction>

<cffunction name="RecepcionServiciosCMF" access="public" returntype="void">
  <cfargument name="id_Empresa"               type="numeric" required="true"/>
  <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>

  <cfstoredproc procedure="spC_AutorizarOC_GPS" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_OrdenCompra"    value="#arguments.id_OrdenCompra#"   null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocresult name="Local.rs" resultset="1">
  </cfstoredproc>
</cffunction>

<cffunction name="listarIdSeguimientoOC" access="public" returntype="query">
  <cfargument name="id_Empresa"               type="numeric" required="true"/>
  <cfargument name="id_OrdenCompra"           type="numeric" required="true"/>

  <cfstoredproc procedure="upR_OrdenesDeCompra_GetSeguimiento" datasource="#variables.cnx#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"     value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_OrdenCompra" value="#arguments.id_OrdenCompra#"  null="#iif(isNumeric(arguments.id_OrdenCompra),false,true)#">
    <cfprocresult name="Local.rs" resultset="1">
  </cfstoredproc>
</cffunction>

</cfcomponent>
