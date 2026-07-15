
<cfcomponent extends="wiz/sucursales">

    <cffunction name="GetProveedorPemex" access="public" returntype="query">
        <cfstoredproc  procedure="upr_ProveedorPemex" datasource="#variables.cnx#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- OBTENER ID_PROVEEDOR Y ID_COMPROBANTE --->
    <cffunction name="listar_ProveedoresTiposComprobantes" access="public" returntype="query">
        <cfargument name="id_Proveedor" type="numeric" required="true">
        <cfquery name="Local.RS" datasource="#variables.cnx#" >
            EXECUTE upR_TiposComprobantes
                        @id_Proveedor       = #arguments.id_Proveedor#
        </cfquery>
        <cfreturn Local.RS/>
    </cffunction>

    <!---Obtener disponibilidad de la cuenta bancaria proveedor--->
    <cffunction  name="ObtenerDisponibilidad" access="public" returntype="any">
        <cfargument name="id_Empresa"   type="numeric" required="true">
        <cfargument name="id_Sucursal"   type="numeric" required="true">
        <cfargument name="id_Dispersion" type="numeric" required="true">

        <cfstoredproc  procedure="upr_getDisponibilidadCuentaCliente" datasource="#variables.cnx#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#arguments.id_Empresa#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#arguments.id_Sucursal#">
              <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname=" @id_Dispersion" value="#arguments.id_Dispersion#">
              <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- OBTENER id_Proveedor, nb_Proveedor, sn_Pemex, sn_PerteneceGrupo  --->
    <cffunction name="listarProveedoresSn_Transorte" access="public" returntype="query">
        <cfargument name="id_Proveedor" type="string" required="false" default=""/>
        <cfargument name="sn_Transporte" type="string" required="false" default=""/>

            <cfstoredproc procedure="upL_ProveedoresSN_Transporte" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"           value="#arguments.id_Proveedor#"           null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Transporte"          value="#arguments.sn_Transporte#"          null="#iif(isNumeric(arguments.sn_Transporte),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarProveedoresSn_TallerMecanico" access="public" returntype="query">
        <cfargument name="sn_TallerMecanico" type="string" required="false" default=""/>

            <cfstoredproc procedure="upL_ProveedoresSN_TallerMecanico" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_TallerMecanico"          value="#arguments.sn_TallerMecanico#"          null="#iif(isNumeric(arguments.sn_TallerMecanico),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- Elimina los registros de ProveedoresTiposComprobantes para un proveedor (CON DELETE) --->
    <cffunction name="EliminarProveedoresTiposComprobantes" access="public" returntype="void">
        <cfargument name="id_Proveedor"           type="numeric"  required="true"/>
        <cfquery datasource="#variables.cnx#" >
            EXECUTE upD_TiposComprobantes
                        @id_Proveedor       = #arguments.id_Proveedor#
        </cfquery>
    </cffunction>

    <!--- Inserta un registro de ProveedoresTiposComprobantes  --->
    <cffunction name="AgregarProveedoresTiposComprobantes" access="public" returntype="void">
        <cfargument name="id_Proveedor"           type="numeric"  required="true"/>
        <cfargument name="id_TipoComprobante"     type="numeric"  required="true"/>
            <cfquery datasource="#variables.cnx#" >
                EXECUTE upC_TiposComprobantes
                        @id_Proveedor       = #arguments.id_Proveedor#,
                        @id_TipoComprobante = #arguments.id_TipoComprobante#
            </cfquery>
    </cffunction>

    <cffunction name="listar_TiposComprobantes" access="public" returntype="query">
        <cfquery name="Local.RS" datasource="#variables.cnx#" >
            EXECUTE upL_TiposComprobantes
        </cfquery>
        <cfreturn Local.RS/>
    </cffunction>

    <!--- OBTENER el siguiente id de Proveedores --->
    <cffunction name="nextID" access="public" returntype="string">
        <cfargument name="id_Empresa"      type="numeric"         required="true">
        <cfquery name="Local.Proveedor" datasource="#variables.cnx#" >
            exec upR_ProveedoresNextID
                            #arguments.id_Empresa#
        </cfquery>
        <cfreturn Local.Proveedor.nextID />
    </cffunction>

    <!--- OBTENER SIGUIENTE ID DE PROVEEDORESCONTACTOS  --->
    <cffunction name="nextIDProveedorContacto" access="public" returntype="string">
        <cfargument name="id_Empresa"      type="numeric"         required="true">
        <cfargument name="id_Proveedor"    type="numeric"         required="true">

            <cfquery name="Local.ProveedorContacto" datasource="#variables.cnx#" >
                exec upR_ProveedoresContactosNEXTID
                                            #arguments.id_Empresa#,
                                            #arguments.id_Proveedor#
            </cfquery>

            <cfreturn Local.ProveedorContacto.nextID />
    </cffunction>


<!--- Victor Sanchez
    Verifica que la referencia contable no se repita
 --->
    <cffunction name="upR_Proveedores_snReferencia" access="public" returntype="string">
        <cfargument name="id_Empresa"      type="numeric"         required="true">
        <cfargument name="id_Proveedor"    type="numeric"         required="true">
        <cfargument name="referencia"    type="string"         required="true">

            <cfquery name="Local.ProveedorContacto" datasource="#variables.cnx#" >
                exec upR_Proveedores_snReferencia
                                            #arguments.id_Empresa#,
                                            #arguments.id_Proveedor#,
                                            '#referencia#'
            </cfquery>

            <cfreturn Local.ProveedorContacto.sn_Repetido />
    </cffunction>

    <!--- CREA UN  REGISTRO EN PROVEEDORES CONTACTOS --->
    <cffunction name="agregarProveedorContacto" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_Proveedor"             type="numeric"  required="true"/>
        <cfargument name="id_ProveedorContacto"     type="numeric"  required="true"/>
        <cfargument name="nb_ProveedorContacto"     type="string"   required="true"/>
        <cfargument name="de_Email"                 type="string"   required="true"/>


            <cfquery datasource="#variables.cnx#" >
                exec upC_ProveedoresContactos
                                          #Arguments.id_Empresa#,
                                          #arguments.id_Proveedor#,
                                          #Arguments.id_ProveedorContacto#,
                                         '#arguments.nb_ProveedorContacto#',
                                         '#arguments.de_Email#'
            </cfquery>
    </cffunction>

    <!--- ACTUALIZA REGISTROS EN PROVEEDORES CONTACTOS --->
    <cffunction name="editarProveedorContacto" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_Proveedor"             type="numeric"  required="true"/>
        <cfargument name="id_ProveedorContacto"     type="numeric"  required="true"/>
        <cfargument name="nb_ProveedorContacto"     type="string"   required="true"/>
        <cfargument name="de_Email"                 type="string"   required="true"/>


            <cfquery datasource="#variables.cnx#" >
                exec upU_ProveedoresContactos
                                          #Arguments.id_Empresa#,
                                          #arguments.id_Proveedor#,
                                          #Arguments.id_ProveedorContacto#,
                                         '#arguments.nb_ProveedorContacto#',
                                         '#arguments.de_Email#'
            </cfquery>
    </cffunction>

    <!--- ACTUALIZA REGISTROS EN PROVEEDORES CONTACTOS EL SN_BORRADO LOGICO --->
    <cffunction name="editarProveedorContactoEliminar" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="numeric"  required="true"/>
        <cfargument name="id_Proveedor"             type="numeric"  required="true"/>
        <cfargument name="id_ProveedorContacto"     type="numeric"  required="true"/>

            <!--- <cfdump var="#arguments#" /><cfabort /> --->
            <cfquery datasource="#variables.cnx#" >
                exec upU_ProveedoresContactosEliminar
                                          #Arguments.id_Empresa#,
                                          #arguments.id_Proveedor#,
                                          #Arguments.id_ProveedorContacto#
            </cfquery>
    </cffunction>

    <!--- valida si existe un proveedor--->
    <cffunction name="existeProveedor" access="public" returntype="boolean">
        <cfargument name="id_Empresa"             type="numeric" required="true"/>
        <cfargument name="id_Proveedor"           type="numeric" required="true"/>
        <cfargument name="nb_Proveedor"           type="string" required="true"/>

        <cfquery name="Local.Proveedor" datasource="#variables.cnx#" >
            exec upR_ProveedoresExist
                                      #Arguments.id_Empresa#,
                                      #arguments.id_Proveedor#,
                                      '#Arguments.nb_Proveedor#'
        </cfquery>
        <cfreturn Local.Proveedor.isExists/>
    </cffunction>

    <!--- CREA UN REGISTRO EN PROVEEDORES Y GENERA LA REFERENCIA CONTABLE AUTOMATICAMENTE --->
    <cffunction name="agregar" access="public" returntype="any">
        <cfargument name="id_Empresa"                        type="numeric"required="true"/>
        <cfargument name="id_Proveedor"                      type="numeric"required="false"/>
        <cfargument name="nb_Proveedor"                      type="string" required="true"/>
        <cfargument name="de_RazonSocial"                    type="string" required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric"required="false"/>
        <cfargument name="de_RFC"                            type="string" required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric"required="false"/>
        <cfargument name="id_TipoProveedor"                  type="numeric"required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string" required="false"/>
        <cfargument name="nu_CuentaBancaria"                 type="string" required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string" required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string" required="false"/>

        <cfargument name="sn_borrado"                        type="string" required="false"/>
        <cfargument name="referencia"                        type="string" required="false"/>
        <cfargument name="sn_Extranjero"                     type="string" required="false"/>
        <!--- Direccion --->
        <cfargument name="sn_Transporte"                     type="string" required="false"/>
        <cfargument name="id_Pais"                           type="string" required="false"/>
        <cfargument name="id_estado"                         type="string" required="false"/>
        <cfargument name="id_municipio"                      type="string" required="false"/>
        <cfargument name="localidad"                         type="string" required="false"/>
        <cfargument name="colonia"                           type="string" required="false"/>
        <cfargument name="calle"                             type="string" required="false"/>
        <cfargument name="numero"                            type="string" required="false"/>
        <cfargument name="nu_Telefono"                       type="string" required="false"/>
        <cfargument name="nu_CodigoPostal"                   type="string" required="false"/>
        <cfargument name="nu_Fax"                            type="string" required="false"/>
        <cfargument name="imgLogo"                           type="string" required="false"/>
        <cfargument name="sn_AccesoSistema"                  type="string" required="false"/>
        <cfargument name="sn_Grupo"                          type="string" required="false"/>
        <cfargument name="sn_Suministro"                     type="string" required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string" required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string" required="false"/>
        <cfargument name="id_TipoDeAditivo"                  type="string" required="false"/>
        <cfargument name="nu_PermisoCRETransporte"           type="string" required="false"/>
        <cfargument name="nu_PermisoCRECombustible"          type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string" required="false"/>
        <cfargument name="sn_ProveedorCompra"                type="string"required="false"/>
        <cfargument name="sn_RegimenConfianza"               type="string" required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string"required="false"/>
        <cfargument name="sn_ProveedorGasLP"                        type="string"required="false" default="0"/>
        <cfargument name="sn_rdioCMF"                        type="string"required="false" default="0"/>
        <cfargument name="sn_NoGenerarPruebaCalidad"         type="string" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Prorrateable"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>
        <cfargument name="sn_PagoExtraordinario"             type="string" required="false"/>

        <cfstoredproc procedure="upC_Proveedores" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"                           value="#arguments.id_Empresa#"                         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Proveedor"                         value="#arguments.id_Proveedor#"                       null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Proveedor"                         value="#arguments.nb_Proveedor#"                       null="#iif(len(arguments.nb_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_RazonSocial"                       value="#arguments.de_RazonSocial#"                     null="#iif(len(arguments.de_RazonSocial),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_MONEY"     dbvarname="@im_LimiteCredito"                     value="#arguments.im_LimiteCredito#"                   null="#iif(isNumeric(arguments.im_LimiteCredito),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_RFC"                               value="#arguments.de_RFC#"                             null="#iif(len(arguments.de_RFC),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_MONEY"     dbvarname="@nu_DiasCredito"                       value="#arguments.nu_DiasCredito#"                     null="#iif(isNumeric(arguments.nu_DiasCredito),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoProveedor"                     value="#arguments.id_TipoProveedor#"                   null="#iif(isNumeric(arguments.id_TipoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_CodigoPostal"                      value="#arguments.nu_CodigoPostal#"                    null="#iif(len(arguments.nu_CodigoPostal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Banco"                             value="#arguments.nb_Banco#"                           null="#iif(len(arguments.nb_Banco),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_CuentaBancaria"                    value="#arguments.nu_CuentaBancaria#"                  null="#iif(len(arguments.nu_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Telefono"                          value="#arguments.nu_Telefono#"                        null="#iif(len(arguments.nu_Telefono),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_ClabeInterbancaria"                value="#arguments.nu_ClabeInterbancaria#"              null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Fax"                               value="#arguments.nu_Fax#"                             null="#iif(len(arguments.nu_Fax),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_borrado"                           value="#arguments.sn_borrado#"                         null="#iif(isBoolean(arguments.sn_borrado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@id_ReferenciaContable"                value="#arguments.referencia#"                         null="#iif(len(arguments.referencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Extranjero"                        value="#arguments.sn_Extranjero#"                      null="#iif(isBoolean(arguments.sn_Extranjero),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Pais"                              value="#arguments.id_Pais#"                            null="#iif(isNumeric(arguments.id_Pais),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_estado"                            value="#arguments.id_estado#"                          null="#iif(isNumeric(arguments.id_estado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_municipio"                         value="#arguments.id_municipio#"                       null="#iif(isNumeric(arguments.id_municipio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_localidad"                         value="#arguments.localidad#"                          null="#iif(isNumeric(arguments.localidad),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@colonia"                              value="#arguments.colonia#"                            null="#iif(len(arguments.colonia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@calle"                                value="#arguments.calle#"                              null="#iif(len(arguments.calle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Exterior"                          value="#arguments.numero#"                             null="#iif(len(arguments.numero),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Transporte"                        value="#arguments.sn_Transporte#"                      null="#iif(isBoolean(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@ar_ImagenLogo"                        value="#arguments.imgLogo#"                            null="#iif(len(arguments.imgLogo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_aliasproveedor"                    value="#arguments.de_aliasproveedor#"                  null="#iif(len(arguments.de_aliasproveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_AccesoSistema"                     value="#arguments.sn_AccesoSistema#"                   null="#iif(isBoolean(arguments.sn_AccesoSistema),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_empresaoperadora"                  value="#session.ID_EMPRESAOPERADORA#"                  null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empleado"                          value="#SESSION.ID_EMPLEADO#"                          null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Grupo"                             value="#arguments.sn_Grupo#"                           null="#iif(isBoolean(arguments.sn_Grupo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Suministro"                        value="#arguments.sn_Suministro#"                      null="#iif(isBoolean(arguments.sn_Suministro),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Ambientaltek"                      value="#arguments.sn_Ambientaltek#"                    null="#iif(isBoolean(arguments.sn_Ambientaltek),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@nu_DiasRegistroComprasCombustible"    value="#arguments.nu_DiasRegistroComprasCombustible#"  null="#iif(isNumeric(arguments.nu_DiasRegistroComprasCombustible),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoDeAditivo"                     value="#arguments.id_TipoDeAditivo#"                   null="#iif(isNumeric(arguments.id_TipoDeAditivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRETransporte"              value="#arguments.nu_PermisoCRETransporte#"            null="#iif(len(arguments.nu_PermisoCRETransporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRECombustible"             value="#arguments.nu_PermisoCRECombustible#"           null="#iif(len(arguments.nu_PermisoCRECombustible),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorDieselGasolinas"          value="#arguments.sn_ProveedorDieselGasolinas#"        null="#iif(isBoolean(arguments.sn_ProveedorDieselGasolinas),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorAditivo"                  value="#arguments.sn_ProveedorAditivo#"                null="#iif(isBoolean(arguments.sn_ProveedorAditivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorCompra"                   value="#arguments.sn_ProveedorCompra#"                 null="#iif(isBoolean(arguments.sn_ProveedorCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_RegimenConfianza"                  value="#arguments.sn_RegimenConfianza#"                null="#iif(isBoolean(arguments.sn_RegimenConfianza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TallerMecanico"                    value="#arguments.sn_TallerMecanico#"                  null="#iif(isBoolean(arguments.sn_TallerMecanico),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorGasLP"                    value="#arguments.sn_ProveedorGasLP#"                  null="#iif(isBoolean(arguments.sn_ProveedorGasLP),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_CargaMasiva"                       value="#arguments.sn_rdioCMF#"                         null="#iif(isBoolean(arguments.sn_rdioCMF),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_NoGenerarPruebaCalidad"            value="#arguments.sn_NoGenerarPruebaCalidad#"          null="#iif(isBoolean(arguments.sn_NoGenerarPruebaCalidad), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TransportaDieselGasolina"          value="#arguments.sn_TransportaDG#"                    null="#iif(isBoolean(arguments.sn_TransportaDG), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TransportaAditivo"                 value="#arguments.sn_TransportaAL#"                    null="#iif(isBoolean(arguments.sn_TransportaAL), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Prorrateable"                      value="#arguments.sn_Prorrateable#"                    null="#iif(isBoolean(arguments.sn_Prorrateable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_GrupoProveedor"                    value="#arguments.id_GrupoProveedor#"                  null="#iif(len(arguments.id_GrupoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Consignacion"                      value="#arguments.sn_Consignacion#"                    null="#iif(isBoolean(arguments.sn_Consignacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_PagoExtraordinario"                value="#arguments.sn_PagoExtraordinario#"              null="#iif(isBoolean(arguments.sn_PagoExtraordinario),false,true)#">
        </cfstoredproc>

        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#" label="arguments" abort="true">

        <cfquery datasource="#variables.cnx#" name="Local.RS">
            exec upC_Proveedores  #arguments.id_Empresa#,
            #arguments.id_Proveedor#,
            "#arguments.nb_Proveedor#",
            <cfif      isDefined("Arguments.de_RazonSocial")        AND ARGUMENTS.de_RazonSocial        NEQ ''>'#Arguments.de_RazonSocial#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.im_LimiteCredito")      AND ARGUMENTS.im_LimiteCredito      NEQ ''>'#Arguments.im_LimiteCredito#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.de_RFC")                AND ARGUMENTS.de_RFC                NEQ ''>'#Arguments.de_RFC#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_DiasCredito")        AND ARGUMENTS.nu_DiasCredito        NEQ ''>'#Arguments.nu_DiasCredito#' <cfelse>NULL</cfif>,
            <!---<cfif isDefined("Arguments.de_Direccion")          AND ARGUMENTS.de_Direccion          NEQ ''>'#Arguments.de_Direccion#'<cfelse>NULL</cfif>, --->
            <cfif      isDefined("Arguments.id_TipoProveedor")      AND ARGUMENTS.id_TipoProveedor      NEQ ''>'#Arguments.id_TipoProveedor#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_CodigoPostal")       AND ARGUMENTS.nu_CodigoPostal       NEQ ''>'#Arguments.nu_CodigoPostal#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nb_Banco")              AND ARGUMENTS.nb_Banco              NEQ ''>'#Arguments.nb_Banco#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_CuentaBancaria")     AND ARGUMENTS.nu_CuentaBancaria     NEQ ''>'#Arguments.nu_CuentaBancaria#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_Telefono")           AND ARGUMENTS.nu_Telefono           NEQ ''>'#Arguments.nu_Telefono#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_ClabeInterbancaria") AND ARGUMENTS.nu_ClabeInterbancaria NEQ ''>'#Arguments.nu_ClabeInterbancaria#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.nu_Fax")                AND ARGUMENTS.nu_Fax                NEQ ''>'#Arguments.nu_Fax#' <cfelse>NULL</cfif>,
            <cfif      isDefined("Arguments.sn_borrado")            AND ARGUMENTS.sn_borrado            NEQ ''>
                <cfif ARGUMENTS.sn_borrado EQ 'YES'>
                    1
                <cfelse>
                    0
                </cfif>
            <cfelse>
                NULL
            </cfif>,
            <cfif isDefined("referencia") AND #referencia# NEQ ''>'#referencia#' <cfelse>NULL</cfif>,
            #sn_Extranjero#,
            <cfif isDefined("id_Pais")       AND #id_Pais#       NEQ ''>'#id_Pais#'       <cfelse>NULL</cfif>,
            <cfif isDefined("id_estado")     AND #id_estado#     NEQ ''>'#id_estado#'     <cfelse>NULL</cfif>,
            <cfif isDefined("id_municipio")  AND #id_municipio#  NEQ ''>'#id_municipio#'  <cfelse>NULL</cfif>,
            <cfif isDefined("localidad")     AND #localidad#     NEQ ''>'#localidad#'     <cfelse>NULL</cfif>,
            <cfif isDefined("colonia")       AND #colonia#       NEQ ''>'#colonia#'       <cfelse>NULL</cfif>,
            <cfif isDefined("calle")         AND #calle#         NEQ ''>'#calle#'         <cfelse>NULL</cfif>,
            <cfif isDefined("numero")        AND #numero#        NEQ ''>'#numero#'        <cfelse>NULL</cfif>,
            <cfif isDefined("sn_Transporte") AND #sn_Transporte# NEQ ''>'#sn_Transporte#' <cfelse>NULL</cfif>,
            <cfif isDefined("imgLogo")       AND #imgLogo#       NEQ ''>'#imgLogo#'       <cfelse>NULL</cfif>,
            '#de_aliasproveedor#',
            <cfif isDefined("arguments.sn_AccesoSistema")>'#arguments.sn_AccesoSistema#' <cfelse>0</cfif>,
            #session.ID_EMPRESAOPERADORA#,
            #SESSION.ID_EMPLEADO#,
            <cfif isDefined("sn_Grupo")        AND #sn_Grupo#        NEQ ''>'#sn_Grupo#'        <cfelse>0</cfif>,
            <cfif isDefined("sn_Suministro")   AND #sn_Suministro#   NEQ ''>'#sn_Suministro#'   <cfelse>0</cfif>,
            <cfif isDefined("sn_Ambientaltek") AND #sn_Ambientaltek# NEQ ''>'#sn_Ambientaltek#' <cfelse>0</cfif>,
            <cfif isDefined("Arguments.nu_DiasRegistroComprasCombustible") AND ARGUMENTS.nu_DiasRegistroComprasCombustible NEQ ''>'#Arguments.nu_DiasRegistroComprasCombustible#' <cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_TipoDeAditivo")                  AND ARGUMENTS.id_TipoDeAditivo                  NEQ ''>'#Arguments.id_TipoDeAditivo#' <cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nu_PermisoCRETransporte")           AND #nu_PermisoCRETransporte#                   NEQ ''>'#nu_PermisoCRETransporte#' <cfelse>NULL</cfif>,
		    <cfif isDefined("Arguments.nu_PermisoCRECombustible")          AND #nu_PermisoCRECombustible#                  NEQ ''>'#nu_PermisoCRECombustible#' <cfelse>NULL</cfif>,
            <cfif isDefined("sn_ProveedorDieselGasolinas")                 AND #sn_ProveedorDieselGasolinas#               NEQ ''>'#sn_ProveedorDieselGasolinas#' <cfelse>0</cfif>,
		    <cfif isDefined("sn_ProveedorAditivo")                         AND #sn_ProveedorAditivo#                       NEQ ''>'#sn_ProveedorAditivo#' <cfelse>0</cfif>,
            <cfif isDefined("Arguments.sn_ProveedorCompra")                AND #sn_ProveedorCompra#                        NEQ ''>'#sn_ProveedorCompra#' <cfelse>NULL</cfif>,
            <cfif isDefined("sn_RegimenConfianza") AND #sn_RegimenConfianza# NEQ ''>'#sn_RegimenConfianza#' <cfelse>0</cfif>
            <cfif isDefined("sn_TallerMecanico") AND #sn_TallerMecanico# NEQ ''>'#sn_TallerMecanico#' <cfelse>0</cfif>

        </cfquery> --->
        <!--- <cfdump var="#Local.RS#"> --->
    </cffunction>

    <!--- Validar que no se repita los rfc para proveedores nacionales --->
    <cffunction name="sn_RFCRepetido" access="public" returntype="string">
        <cfargument name="id_Proveedor"          type="string"      required="true"/>
        <cfargument name="RFC"          type="string"      required="true"/>

            <cfquery name="Local.RS" datasource="#variables.cnx#" >
                exec upR_ProveedoresRFC_Repetido #id_Proveedor#,'#arguments.RFC#'
            </cfquery>
            <cfreturn Local.RS.sn_Repetido/>
    </cffunction>


    <!--- ACTUALIZACION DE REGISTROS EN PROVEEDORES  --->
    <cffunction name="editar" access="public" returntype="void">
        <cfargument name="id_Empresa"                        type="numeric" required="true"/>
        <cfargument name="id_Proveedor"                      type="numeric" required="true"/>
        <cfargument name="nb_Proveedor"                      type="string"  required="true"/>
        <cfargument name="de_RazonSocial"                    type="string"  required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric" required="false"/>
        <cfargument name="de_RFC"                            type="string"  required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric" required="false"/>
        <cfargument name="id_TipoProveedor"                  type="numeric" required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string"  required="false"/>
        <cfargument name="nu_CuentaBancaria"                 type="string"  required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string"  required="false"/>
        <cfargument name="sn_borrado"                        type="string"  required="false"/>
        <cfargument name="referencia"                        type="string"  required="false"/>
        <cfargument name="sn_Extranjero"                     type="string"  required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string"  required="false"/>
        <cfargument name="sn_Transporte"                     type="string"  required="false"/>
        <cfargument name="id_Pais"                           type="string"  required="false"/>
        <cfargument name="id_estado"                         type="string"  required="false"/>
        <cfargument name="id_municipio"                      type="string"  required="false"/>
        <cfargument name="localidad"                         type="string"  required="true"/>
        <cfargument name="colonia"                           type="string"  required="false"/>
        <cfargument name="calle"                             type="string"  required="false"/>
        <cfargument name="numero"                            type="string"  required="false"/>
        <cfargument name="nu_Telefono"                       type="string"  required="false"/>
        <cfargument name="nu_CodigoPostal"                   type="string"  required="false"/>
        <cfargument name="nu_Fax"                            type="string"  required="false"/>
        <cfargument name="imgLogo"                           type="string"  required="false"/>
        <cfargument name="sn_AccesoSistema"                  type="boolean" required="false"/>
        <cfargument name="sn_Grupo"                          type="string"  required="false"/>
        <cfargument name="sn_Suministro"                     type="string"  required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string"  required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string"  required="false"/>
        <cfargument name="id_TipoDeAditivo"                  type="string"  required="false"/>
	    <cfargument name="nu_PermisoCRETransporte"	         type="string"	required="false"/>
	    <cfargument name="nu_PermisoCRECombustible"	         type="string"	required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string"  required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string"  required="false"/>
        <cfargument name="sn_ProveedorCompra"                type="string"  required="false"/>
        <cfargument name="sn_RegimenConfianza"               type="string"  required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string" required="false"/>
        <cfargument name="sn_ProveedorGasLP"                        type="string" required="false" default="0"/>
        <cfargument name="sn_rdioCMF"                        type="string" required="false" default="0"/>
        <cfargument name="sn_NoGenerarPruebaCalidad"         type="string" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Prorrateable"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>
        <cfargument name="de_EmailProveedor"                 type="string" required="false"/>
        <cfargument name="id_EmpresaSILT"                    type="numeric" required="false"/>
        <cfargument name="sn_suspendido"                     type="string" required="false"/>
        <cfargument name="de_MotivoSuspension"                   type="string" required="false"/>
        <cfargument name="id_UsuarioSupendio"                 type="numeric" required="false"/>
        <cfargument name="fh_suspension"                     type="string" required="false"/>

        <!--- <cfcontent type="text/html">
<cfdump var="#arguments#" format="simple" label="arguments" abort="true"> --->

        <cfstoredproc procedure="upU_Proveedores" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empresa"                           value="#arguments.id_Empresa#"                         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Proveedor"                         value="#arguments.id_Proveedor#"                       null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Proveedor"                         value="#arguments.nb_Proveedor#"                       null="#iif(len(arguments.nb_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_RazonSocial"                       value="#arguments.de_RazonSocial#"                     null="#iif(len(arguments.de_RazonSocial),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_MONEY"     dbvarname="@im_LimiteCredito"                     value="#arguments.im_LimiteCredito#"                   null="#iif(isNumeric(arguments.im_LimiteCredito),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_RFC"                               value="#arguments.de_RFC#"                             null="#iif(len(arguments.de_RFC),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_MONEY"     dbvarname="@nu_DiasCredito"                       value="#arguments.nu_DiasCredito#"                     null="#iif(isNumeric(arguments.nu_DiasCredito),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoProveedor"                     value="#arguments.id_TipoProveedor#"                   null="#iif(isNumeric(arguments.id_TipoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_GrupoProveedor"                    value="#arguments.id_GrupoProveedor#"                  null="#iif(len(arguments.id_GrupoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_CodigoPostal"                      value="#arguments.nu_CodigoPostal#"                    null="#iif(len(arguments.nu_CodigoPostal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nb_Banco"                             value="#arguments.nb_Banco#"                           null="#iif(len(arguments.nb_Banco),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_CuentaBancaria"                    value="#arguments.nu_CuentaBancaria#"                  null="#iif(len(arguments.nu_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Telefono"                          value="#arguments.nu_Telefono#"                        null="#iif(len(arguments.nu_Telefono),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_ClabeInterbancaria"                value="#arguments.nu_ClabeInterbancaria#"              null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Fax"                               value="#arguments.nu_Fax#"                             null="#iif(len(arguments.nu_Fax),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_borrado"                           value="#arguments.sn_borrado#"                         null="#iif(isBoolean(arguments.sn_borrado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@id_ReferenciaContable"                value="#arguments.referencia#"                         null="#iif(len(arguments.referencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Extranjero"                        value="#arguments.sn_Extranjero#"                      null="#iif(isBoolean(arguments.sn_Extranjero),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Pais"                              value="#arguments.id_Pais#"                            null="#iif(isNumeric(arguments.id_Pais),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_estado"                            value="#arguments.id_estado#"                          null="#iif(isNumeric(arguments.id_estado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_municipio"                         value="#arguments.id_municipio#"                       null="#iif(isNumeric(arguments.id_municipio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_localidad"                         value="#arguments.localidad#"                          null="#iif(isNumeric(arguments.localidad),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@colonia"                              value="#arguments.colonia#"                            null="#iif(len(arguments.colonia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@calle"                                value="#arguments.calle#"                              null="#iif(len(arguments.calle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_Exterior"                          value="#arguments.numero#"                             null="#iif(len(arguments.numero),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Transporte"                        value="#arguments.sn_Transporte#"                      null="#iif(isBoolean(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@ar_ImagenLogo"                        value="#arguments.imgLogo#"                            null="#iif(len(arguments.imgLogo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_aliasproveedor"                    value="#arguments.de_aliasproveedor#"                  null="#iif(len(arguments.de_aliasproveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_AccesoSistema"                     value="#arguments.sn_AccesoSistema#"                   null="#iif(isBoolean(arguments.sn_AccesoSistema),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_empresaoperadora"                  value="#session.ID_EMPRESAOPERADORA#"                  null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Empleado"                          value="#SESSION.ID_EMPLEADO#"                          null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Grupo"                             value="#arguments.sn_Grupo#"                           null="#iif(isBoolean(arguments.sn_Grupo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Suministro"                        value="#arguments.sn_Suministro#"                      null="#iif(isBoolean(arguments.sn_Suministro),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Ambientaltek"                      value="#arguments.sn_Ambientaltek#"                    null="#iif(isBoolean(arguments.sn_Ambientaltek),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@nu_DiasRegistroComprasCombustible"    value="#arguments.nu_DiasRegistroComprasCombustible#"  null="#iif(isNumeric(arguments.nu_DiasRegistroComprasCombustible),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoDeAditivo"                     value="#arguments.id_TipoDeAditivo#"                   null="#iif(isNumeric(arguments.id_TipoDeAditivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRETransporte"              value="#arguments.nu_PermisoCRETransporte#"            null="#iif(len(arguments.nu_PermisoCRETransporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRECombustible"             value="#arguments.nu_PermisoCRECombustible#"           null="#iif(len(arguments.nu_PermisoCRECombustible),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorDieselGasolinas"          value="#arguments.sn_ProveedorDieselGasolinas#"        null="#iif(isBoolean(arguments.sn_ProveedorDieselGasolinas),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorAditivo"                  value="#arguments.sn_ProveedorAditivo#"                null="#iif(isBoolean(arguments.sn_ProveedorAditivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorCompra"                   value="#arguments.sn_ProveedorCompra#"                 null="#iif(isBoolean(arguments.sn_ProveedorCompra),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_RegimenConfianza"                  value="#arguments.sn_RegimenConfianza#"                null="#iif(isBoolean(arguments.sn_RegimenConfianza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TallerMecanico"                    value="#arguments.sn_TallerMecanico#"                  null="#iif(isBoolean(arguments.sn_TallerMecanico),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorGasLP"                    value="#arguments.sn_ProveedorGasLP#"                  null="#iif(isBoolean(arguments.sn_ProveedorGasLP),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_CargaMasiva"                       value="#arguments.sn_rdioCMF#"                         null="#iif(isBoolean(arguments.sn_rdioCMF),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_NoGenerarPruebaCalidad"            value="#arguments.sn_NoGenerarPruebaCalidad#"          null="#iif(isBoolean(arguments.sn_NoGenerarPruebaCalidad), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TransportaDieselGasolina"          value="#arguments.sn_TransportaDG#"                    null="#iif(isBoolean(arguments.sn_TransportaDG), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_TransportaAditivo"                 value="#arguments.sn_TransportaAL#"                    null="#iif(isBoolean(arguments.sn_TransportaAL), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Prorrateable"                      value="#arguments.sn_Prorrateable#"                    null="#iif(isBoolean(arguments.sn_Prorrateable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Consignacion"                      value="#arguments.sn_Consignacion#"                    null="#iif(isBoolean(arguments.sn_Consignacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_EmailProveedor"                    value="#arguments.de_EmailProveedor#"                  null="#iif(len(arguments.de_EmailProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EmpresaSILT"                       value="#arguments.id_EmpresaSILT#"                     null="#iif(isNumeric(arguments.id_EmpresaSILT),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_suspendido"                        value="#arguments.sn_suspendido#"                    null="#iif(isBoolean(arguments.sn_suspendido),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@de_MotivoSuspension"                      value="#arguments.de_MotivoSuspension#"                    null="#iif(len(arguments.de_MotivoSuspension),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_UsuarioSupendio"                    value="#SESSION.ID_USUARIO#"                  null="#iif(isNumeric(SESSION.ID_USUARIO),false,true)#">

        </cfstoredproc>
    </cffunction>

    <!--- ACTUALIZACION DE REGISTROS EN PROVEEDORES BORRADO LOGICO --->
    <cffunction name="editareliminarlogico" access="public" returntype="void">
        <cfargument name="id_Empresa"             type="numeric" required="true"/>
        <cfargument name="id_Proveedor"           type="numeric" required="true"/>

        <cfquery datasource="#variables.cnx#">
                exec upU_ProveedoresEliminar
                                    #arguments.id_Empresa#,
                                    #arguments.id_Proveedor#,
                                    #session.ID_EMPRESAOPERADORA#,
                                    #SESSION.ID_EMPLEADO#

        </cfquery>
    </cffunction>

    <!---
        Victor Sanchez
        04/01/2015
        muestra los proveedores que son transportistas
     --->
    <cffunction name="upR_ProveedoresTransportistas" access="public" returntype="query">


        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upR_ProveedoresTransportistas

        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_Empresa"              type="string" required="false">
        <cfargument name="id_Proveedor"            type="string" required="false"/>
        <cfargument name="nb_Proveedor"            type="string" required="false"/>
        <cfargument name="id_TipoProveedor"        type="string" required="false"/>
        <cfargument name="page"                    type="string" required="false" default="1"/>
        <cfargument name="pageSize"                type="string" required="false" default="10"/>
        <cfargument name="sn_ProveedorCombustible" type="string" required="false" />
        <cfargument name="de_RFC"                  type="string" required="false" />
        <cfargument name="sn_ProveedoresPago"      type="string" required="false" />

        <cfstoredproc procedure="upL_Proveedores" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"       value="#arguments.id_Proveedor#"       null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Proveedor"       value="#arguments.nb_Proveedor#"       null="#iif(len(arguments.nb_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoProveedor"   value="#arguments.id_TipoProveedor#"   null="#iif(len(arguments.id_TipoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"               value="#arguments.page#"               null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"           value="#arguments.pageSize#"           null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@de_RFC"             value="#arguments.de_RFC#"             null="#iif(isNumeric(arguments.de_RFC),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_ProveedoresPago" value="#arguments.sn_ProveedoresPago#" null="#iif(isNumeric(arguments.sn_ProveedoresPago),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <cffunction name="listar2" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string" required="false">
        <cfargument name="id_Proveedor"         type="string" required="false"/>
        <cfargument name="nb_Proveedor"         type="string" required="false"/>
        <cfargument name="id_TipoProveedor"     type="string" required="false"/>
        <cfargument name="page"                 type="string" required="false" default="1"/>
        <cfargument name="pageSize"             type="string" required="false" default="10"/>
        <cfargument name="sn_ProveedorCombustible"         type="string" required="false" />

        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upL_Proveedores2
            <cfif isDefined("Arguments.id_Empresa")       AND ARGUMENTS.id_Empresa       NEQ ''>#Arguments.id_Empresa#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Proveedor")     AND ARGUMENTS.id_Proveedor     NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_Proveedor")     AND ARGUMENTS.nb_Proveedor     NEQ ''>'#Arguments.nb_Proveedor#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_TipoProveedor") AND ARGUMENTS.id_TipoProveedor NEQ ''>'#Arguments.id_TipoProveedor#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.page")             AND ARGUMENTS.page             NEQ ''>'#Arguments.page#'<cfelse>1</cfif>,
            <cfif isDefined("Arguments.pageSize")         AND ARGUMENTS.page             NEQ ''>'#Arguments.pageSize#'<cfelse>1</cfif>
        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

     <cffunction name="listarCombustibleSn" access="public" returntype="query">
    <cfargument name="id_Empresa"           type="string" required="false">
    <cfargument name="id_Proveedor"         type="string" required="false"/>
    <cfargument name="nb_Proveedor"         type="string" required="false"/>
    <cfargument name="id_TipoProveedor"     type="string" required="false"/>
    <cfargument name="page"                 type="string" required="false" default="1"/>
    <cfargument name="pageSize"             type="string" required="false" default="10"/>
    <cfargument name="sn_ProveedorCombustible"         type="string" required="false" />

        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upL_ProveedoresCombustibleSn
            <cfif isDefined("Arguments.id_Empresa")       AND ARGUMENTS.id_Empresa       NEQ ''>#Arguments.id_Empresa#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Proveedor")     AND ARGUMENTS.id_Proveedor     NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_Proveedor")     AND ARGUMENTS.nb_Proveedor     NEQ ''>'#Arguments.nb_Proveedor#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_TipoProveedor") AND ARGUMENTS.id_TipoProveedor NEQ ''>'#Arguments.id_TipoProveedor#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.page")             AND ARGUMENTS.page             NEQ ''>'#Arguments.page#'<cfelse>1</cfif>,
            <cfif isDefined("Arguments.pageSize")         AND ARGUMENTS.page             NEQ ''>'#Arguments.pageSize#'<cfelse>1</cfif>
        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

<!--- listado de Proveedores --->
<cffunction name="listarCatalogo" access="public" returntype="query">
    <cfargument name="id_Empresa"           type="string" required="false">
    <cfargument name="id_Proveedor"         type="string" required="false"/>
    <cfargument name="nb_Proveedor"         type="string" required="false"/>
    <cfargument name="id_TipoProveedor"     type="string" required="false"/>
    <cfargument name="page"                 type="string" required="false" default="1"/>
    <cfargument name="pageSize"             type="string" required="false" default="10"/>
    <cfargument name="de_RFC"               type="string" required="false"/>
    <cfargument name="sn_Transporte"        type="string" required="false"/>
    <cfargument name="sn_ProveedorCombustible" type="string" required="false"/>

        <cfstoredproc procedure="upL_ProveedoresListado" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"         value="#arguments.id_Proveedor#"            null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Proveedor"         value="#arguments.nb_Proveedor#"            null="#iif(len(arguments.nb_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoProveedor"     value="#arguments.id_TipoProveedor#"        null="#iif(isNumeric(arguments.id_TipoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"                 value="#arguments.page#"                    null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"             value="#arguments.pageSize#"                null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RFC"               value="#arguments.de_RFC#"                  null="#iif(len(arguments.de_RFC),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT" dbvarname="@sn_Transporte"            value="#arguments.sn_Transporte#"           null="#iif(IsNumeric(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT" dbvarname="@sn_ProveedorCombustible"  value="#arguments.sn_ProveedorCombustible#" null="#iif(isNumeric(arguments.sn_ProveedorCombustible),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- reporte de Proveedores --->
<cffunction name="listadoExcel" access="public" returntype="query">
    <cfargument name="id_Proveedor"         type="string" required="false"/>
    <cfargument name="nb_Proveedor"         type="string" required="false"/>
    <cfargument name="id_TipoProveedor"     type="string" required="false"/>
    <cfargument name="de_RFC"               type="string" required="false"/>
    <cfargument name="sn_Transporte"        type="string" required="false"/>
    <cfargument name="sn_ProveedorCombustible" type="string" required="false"/>

        <cfstoredproc procedure="upL_almr_Proveedores_Reporte" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"             value="#arguments.id_Proveedor#"            null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Proveedor"             value="#arguments.nb_Proveedor#"            null="#iif(len(arguments.nb_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoProveedor"         value="#arguments.id_TipoProveedor#"        null="#iif(isNumeric(arguments.id_TipoProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_RFC"                   value="#arguments.de_RFC#"                  null="#iif(len(arguments.de_RFC),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Transporte"            value="#arguments.sn_Transporte#"           null="#iif(IsNumeric(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_ProveedorCombustible"  value="#arguments.sn_ProveedorCombustible#" null="#iif(isNumeric(arguments.sn_ProveedorCombustible),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>


    <!---
        Victor Sanchez
        17/02/2016
        revisa que no este repetido el de_AliasProveedor
     --->
    <cffunction name="upR_snDe_AliasProveedor" access="public" returntype="query">
        <cfargument name="id_Proveedor"             type="string" required="true">
        <cfargument name="de_AliasProveedor"            type="string" required="true">

        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upR_snDe_AliasProveedor #id_Proveedor#,'#de_AliasProveedor#'

        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- listado de contacto en especifico --->
    <cffunction name="getProveedor" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true">
        <cfargument name="id_Proveedor"             type="string" required="false"/>
        <cfargument name="id_ProveedorContacto"     type="string" required="false"/>

            <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
                exec upL_ProveedoresContactosUnoEspecifico
                        #arguments.id_Empresa#,
                        #arguments.id_Proveedor#,
                        #arguments.id_ProveedorContacto#

            </cfquery>
            <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- COUNT PARA SABER SI UN CONTACTO TIENE ASIGNADA COTIZACIONES --->
    <cffunction name="getCotizacionesAsignadas" access="public" returntype="query">
    <cfargument name="id_Empresa"   type="numeric" required="true">
    <cfargument name="id_Proveedor"     type="string" required="false"/>
    <cfargument name="id_ProveedorContacto"     type="string" required="false"/>


        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_CotizacionesContactosProveedores
                    #arguments.id_Empresa#,
                    #arguments.id_Proveedor#,
                    #arguments.id_ProveedorContacto#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- NUMERO DE CONTACTOS ASIGNADOS A UN PROVEEDOR EN ESPECIFICO  --->
    <cffunction name="CountContactosProveedor" access="public" returntype="query">
    <cfargument name="id_Empresa"       type="numeric" required="true">
    <cfargument name="id_Proveedor"     type="string" required="true"/>

        <cfquery name="Local.CountContactos" datasource="#variables.cnx#" >
            exec upL_ProveedoresContactosCount
                                                #arguments.id_Empresa#,
                                                #arguments.id_Proveedor#

        </cfquery>

        <!--- <cfdump var="#local.CountContactos#"><cfabort> --->

        <cfreturn Local.CountContactos/>
    </cffunction>


    <!--- listado de contactos por proveedores --->
    <cffunction name="listarContactosProveedores" access="public" returntype="query">
    <cfargument name="id_Empresa"           type="numeric" required="true">
    <cfargument name="id_Proveedor"         type="string" required="true"/>


        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upL_ProveedoresContactos
                    #arguments.id_Empresa#,
                    #arguments.id_Proveedor#

        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- llenado del combo de tipos de Proveedores en la interfas de proveedores --->
    <cffunction name="Cmb_TiposProveedores" access="public" returntype="query">
        <cfquery name="Local.CmbProveedores" datasource="#variables.cnx#" >
            exec upLC_TiposProveedores
        </cfquery>
        <cfreturn Local.CmbProveedores/>
    </cffunction>

    <!--- LISTADO DE PROVEEDORES PARA EL COMBO EN LAINTERFAZ DE COTIZACIONES --->
    <cffunction name="listarProveedoresCombo" access="public" returntype="query">
        <cfargument name="sn_ProveedorCombustible"  type="string"  required="false"/>
        <cfargument name="sn_Extranjero"            type="string"  required="false"/>
        <cfargument name="sn_Transporte"            type="string"  required="false"/>
        <cfargument name="sn_CargaMasiva"           type="numeric" required="false"/>
        <cfargument name="sn_Pemex"                 type="numeric" required="false"/>
        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upL_ProveedoresCombo
                <cfif isDefined("Arguments.sn_ProveedorCombustible")    AND ARGUMENTS.sn_ProveedorCombustible   NEQ ''>#Arguments.sn_ProveedorCombustible#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Extranjero")              AND ARGUMENTS.sn_Extranjero             NEQ ''>#Arguments.sn_Extranjero#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Transporte")              AND ARGUMENTS.sn_Transporte             NEQ ''>#Arguments.sn_Transporte#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_CargaMasiva")             AND ARGUMENTS.sn_CargaMasiva            NEQ ''>#Arguments.sn_CargaMasiva#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Pemex")                   AND ARGUMENTS.sn_Pemex                  NEQ ''>#Arguments.sn_Pemex#<cfelse>NULL</cfif>
        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <cffunction name="listarProveedoresComboTranspCombustible" access="public" returntype="query">
        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upL_ProveedoresComboTranspCombustible
        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- BORRAR UN REGISTRO EN PROVEEDORES --->
    <cffunction name="eliminar" access="public" returntype="void">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Proveedor"   type="numeric" required="true"/>

        <cfquery name="Local.Proveedor" datasource="#variables.cnx#" >
            exec upD_Proveedores
                                #arguments.id_Empresa#,
                                 #Arguments.id_Proveedor#
        </cfquery>
    </cffunction>

    <!--- BORRAR UN REGISTRO EN PROVEEDORESCONTACTOS --->
    <cffunction name="eliminarProveedorContacto" access="public" returntype="void">
        <cfargument name="id_Empresa"    type="numeric" required="true"/>
        <cfargument name="id_Proveedor"   type="numeric" required="true"/>

        <cfquery name="Local.Proveedor" datasource="#variables.cnx#" >
            exec upD_ProveedoresContactos
                                 #arguments.id_Empresa#,
                                 #Arguments.id_Proveedor#
        </cfquery>
    </cffunction>

    <!--- SELECCION DE TELEFONO POR PROVEEDOR  --->
    <cffunction name="listarTelefonoProveedor" access="public" returntype="query">
       <cfargument name="id_Proveedor"    type="numeric"    required="true"/>
        <cfquery name="Local.Telefono" datasource="#variables.cnx#" >
            exec upL_ProveedoresTelefono
            <cfif isDefined("Arguments.id_Proveedor") AND arguments.id_Proveedor NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>
        </cfquery>
        <cfreturn Local.Telefono/>
    </cffunction>

    <!--- LISTADO DE PROVEEDORES PARA EL AUTOCOMPLETE EN LA INTERFAZ DE AGREGAR COTIZACION   --->
    <cffunction name="listarProveedoresAutoComplete" access="public" returntype="query">
       <cfargument name="id_Proveedor"       type="string"       required="false"/>
       <cfargument name="nb_Proveedor"       type="string"       required="false"/>

       <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfquery name="Local.ProveedoresAutoComplete" datasource="#variables.cnx#" >

            exec upL_ProveedoresAutoComplete
                    #arguments.id_Empresa#,
            <cfif isDefined("Arguments.id_Proveedor")    AND arguments.id_Proveedor NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_Proveedor")    AND arguments.nb_Proveedor NEQ ''>#Arguments.nb_Proveedor#<cfelse>NULL</cfif>

        </cfquery>
        <cfreturn Local.ProveedoresAutoComplete/>
    </cffunction>

    <!--- LISTADO DE PROVEEDORES DE TRANSPORTE PARA EL AUTOCOMPLETE EN LA INTERFAZ DE AGREGAR COTIZACION  --->
    <cffunction name="listarProveedoresTransporteAutoComplete" access="public" returntype="query">
       <cfargument name="id_Proveedor"       type="string"       required="false"/>
       <cfargument name="nb_Proveedor"       type="string"       required="false"/>

        <cfquery name="Local.ProveedoresAutoComplete" datasource="#variables.cnx#" >

            exec upL_ProveedoresTransporteAutoComplete

            <cfif isDefined("Arguments.id_Proveedor")    AND arguments.id_Proveedor NEQ ''>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_Proveedor")    AND arguments.nb_Proveedor NEQ ''>#Arguments.nb_Proveedor#<cfelse>NULL</cfif>

        </cfquery>
        <cfreturn Local.ProveedoresAutoComplete/>
    </cffunction>

    <!--- OBTIENE LA INFORMACION DEL PROVEEDOR DE ACUERDO A SU ID Y CONCATENA LOS CORREOS VALIDOS DE LOS CONTACTOS ASOCIADOS
            AL PROVEEDOR SEPARADOS POR ';'--->
    <cffunction name="getByID" access="public" returntype="query">
        <cfargument name="id_empresa"    type="string" required="true"/>
        <cfargument name="id_Proveedor"  type="string" required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_ProveedoresByID #Arguments.id_empresa#,#Arguments.id_Proveedor#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- OBTIENE UN REPORTE DE COMPRAS PROVEEDOR DETALLE--->
    <cffunction name="reporteProveedoresOrdenesCompra" access="public" returntype="query">
        <cfargument name="id_Empresa"          type="string" required="false"/>
        <cfargument name="id_sucursal"         type="string" required="false"/>
        <cfargument name="id_Proveedor"        type="string" required="false"/>
        <cfargument name="id_Departamento"     type="string" required="false"/>
        <cfargument name="id_Almacen"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_NombreInsumo"     type="string" required="false"/>
        <cfargument name="id_tipoRequisicion"  type="string" required="false"/>
        <cfargument name="fh_inicio"           type="string" required="false"/>
        <cfargument name="fh_fin"              type="string" required="false"/>

        <cfstoredproc procedure="upR_ComprasProveedoresDetalle" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"          value="#arguments.id_empresa#"          null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal"         value="#arguments.id_sucursal#"         null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"        value="#arguments.id_proveedor#"        null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_departamento"     value="#arguments.id_departamento#"     null="#iif(isNumeric(arguments.id_departamento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen"          value="#arguments.id_almacen#"          null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"    value="#arguments.id_FamiliaInsumo#"    null="#iif(isNumeric(arguments.id_FamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_NombreInsumo"     value="#arguments.nb_Nombreinsumo#"     null="#iif(len(arguments.nb_NombreInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoRequisicion"  value="#arguments.id_tipoRequisicion#"  null="#iif(isNumeric(arguments.id_tipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"           value="#arguments.fh_inicio#"           null="#iif(len(arguments.fh_inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"              value="#arguments.fh_fin#"              null="#iif(len(arguments.fh_fin),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <!--- <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            /*exec upL_ProveedoresOrdenesComprasReporte*/
            exec upL_ProveedoresOrdenesComprasReporteJulio
                    #arguments.id_Empresa#,
            <cfif isDefined("Arguments.id_sucursal")>#Arguments.id_sucursal#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Proveedor")>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Proveedor")>#Arguments.id_Proveedor#<cfelse>NULL</cfif>,
                    '#Arguments.fh_inicio#',
                    '#Arguments.fh_fin#'

        </cfquery> --->
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- OBTIENE EL REPORTE DE COMPRAS PROVEEDOR DETALLE--->
    <cffunction name="reporteProveedoresOrdenesCompraDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"         type="string" required="false"/>
        <cfargument name="id_sucursal"         type="string" required="false"/>
        <cfargument name="id_Proveedor"        type="string" required="false"/>
        <cfargument name="id_Departamento"     type="string" required="false"/>
        <cfargument name="id_Almacen"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_NombreInsumo"     type="string" required="false"/>
        <cfargument name="id_tipoRequisicion"  type="string" required="false"/>
        <cfargument name="fh_inicio"           type="string" required="false"/>
        <cfargument name="fh_fin"              type="string" required="false"/>

        <cfstoredproc procedure="upR_ComprasProveedoresDetalle" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"         value="#arguments.id_Sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"        value="#arguments.id_Proveedor#"        null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_departamento"     value="#arguments.id_departamento#"     null="#iif(isNumeric(arguments.id_departamento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_almacen"          value="#arguments.id_almacen#"          null="#iif(isNumeric(arguments.id_almacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"    value="#arguments.id_FamiliaInsumo#"    null="#iif(isNumeric(arguments.id_FamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_NombreInsumo"     value="#arguments.nb_Nombreinsumo#"     null="#iif(len(arguments.nb_NombreInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_tipoRequisicion"  value="#arguments.id_tipoRequisicion#"  null="#iif(isNumeric(arguments.id_tipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"           value="#arguments.fh_Inicio#"           null="#iif(len(arguments.fh_Inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin"              value="#arguments.fh_Fin#"              null="#iif(len(arguments.fh_Fin),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        Inserta el encabezado de la dispercion de pago
     --->
    <cffunction name="agregar_dispersionEncabezado" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_CuentaBancaria"    type="string"   required="true"/>
        <cfargument name="im_TotalDispersion"   type="string"   required="true"/>
        <cfargument name="fh_DiaPago"           type="string"   required="true"/>
        <cfargument name="fh_DiaOperacion"      type="string"   required="true"/>
        <cfargument name="id_Moneda"            type="string"   required="true"/>
        <cfargument name="im_TipoCambio"        type="string"   required="true"/>

        <cfstoredproc procedure="upC_DispersionBanEncabezado" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"           value="#arguments.id_empresa#"           null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"          value="#arguments.id_Sucursal#"          null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"    value="#arguments.id_CuentaBancaria#"    null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalDispersion"   value="#arguments.im_TotalDispersion#"   null="#iif(isNumeric(arguments.im_TotalDispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_DiaPago"           value="#arguments.fh_DiaPago#"           null="#iif(len(arguments.fh_DiaPago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_DiaOperacion"      value="#arguments.fh_DiaOperacion#"      null="#iif(len(arguments.fh_DiaOperacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"            value="#arguments.id_Moneda#"            null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"        value="#arguments.im_TipoCambio#"        null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        Lista las dispersiones generadas
     --->
    <cffunction name="listar_DispersionesProveedores" access="public" returntype="query">
        <cfargument name="id_Empresa"          type="string" required="yes">
        <cfargument name="id_Sucursal"         type="string" required="yes">
        <cfargument name="id_Dispersion"       type="string" required="no">
        <cfargument name="fh_Operacion"        type="string" required="no">
        <cfargument name="id_CuentaBancaria"   type="string" required="no">
        <cfargument name="id_Moneda"           type="string" required="no">
        <cfargument name="id_TipoBeneficiario" type="string" required="no">
        <cfargument name="id_Proveedor"        type="string" required="no">
        <cfargument name="id_DeudorDiverso"    type="string" required="no">
        <cfargument name="id_AcreedorDiverso"  type="string" required="no">
        <cfargument name="fh_Pago"             type="string" required="no">

        <cfstoredproc procedure="upL_DispersionesProveedores" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"         value="#arguments.id_Sucursal#"         null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion"       value="#arguments.id_Dispersion#"       null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Operacion"        value="#arguments.fh_Operacion#"        null="#iif(len(arguments.fh_Operacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"   value="#arguments.id_CuentaBancaria#"   null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"           value="#arguments.id_Moneda#"           null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoBeneficiario" value="#arguments.id_TipoBeneficiario#" null="#iif(isNumeric(arguments.id_TipoBeneficiario),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"        value="#arguments.id_Proveedor#"        null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"    value="#arguments.id_DeudorDiverso#"    null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso"  value="#arguments.id_AcreedorDiverso#"  null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Pago"             value="#arguments.fh_Pago#"             null="#iif(len(arguments.fh_Pago),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- Jose Miguel
            Lee las los registros de dipersion por proveedor --->
    <cffunction name="upR_DispersionBanProveedor" access="public" returntype="any">
        <cfargument name="id_Empresa"         type="string" required="true">
        <cfargument name="id_Sucursal"        type="string" required="true">
        <cfargument name="id_Dispersion"      type="string" required="true">
        <cfargument name="id_Proveedor"       type="string" required="false">
        <cfargument name="id_DeudorDiverso"   type="string" required="false">
        <cfargument name="id_AcreedorDiverso" type="string" required="false">

        <cfstoredproc procedure="upR_DispersionBanProveedor" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"        null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion"      value="#arguments.id_Dispersion#"      null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"       value="#arguments.id_Proveedor#"       null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"   value="#arguments.id_DeudorDiverso#"   null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso" value="#arguments.id_AcreedorDiverso#" null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
            <cfprocresult name="rsDispersionBanProveedor" resultset="1">
        </cfstoredproc>

        <cfreturn rsDispersionBanProveedor>
    </cffunction>

    <!---
        Victor Sanchez
        Inserta el detalle de una dispersion de proveedores
     --->
    <cffunction name="agregar_dispersionDetalle" access="public" returntype="void">
        <cfargument name="id_Empresa"                   type="string" required="true"/>
        <cfargument name="id_Sucursal"                  type="string" required="true"/>
        <cfargument name="id_Dispersion"                type="string" required="true"/>
        <cfargument name="id_Proveedor"                 type="string" required="false"/>
        <cfargument name="nd_Dispersion"                type="string" required="true"/>
        <cfargument name="cl_TipoDocumento"             type="string" required="true"/>
        <cfargument name="id_Documento"                 type="string" required="true"/>
        <cfargument name="im_Documento"                 type="string" required="true"/>
        <cfargument name="id_ProgramacionPago"          type="string" required="true"/>
        <cfargument name="id_ProgramacionPagoDetalle"   type="string" required="true"/>
        <cfargument name="id_SucursalDocumento"         type="string" required="true"/>
        <cfargument name="sn_AnticipoPagar"             type="string" required="true"/>
        <cfargument name="im_DocumentoMN"               type="string" required="true">
        <cfargument name="id_Moneda"                    type="string" required="true">
        <cfargument name="im_TipoCambio"                type="string" required="true">
        <cfargument name="id_DeudorDiverso"             type="string" required="false">
        <cfargument name="id_AcreedorDiverso"           type="string" required="false">

        <cfstoredproc procedure="upC_dispercionDetalle" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                 value="#arguments.id_Empresa#"                 null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                value="#arguments.id_Sucursal#"                null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion"              value="#arguments.id_Dispersion#"              null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"               value="#arguments.id_Proveedor#"               null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@nd_Dispersion"              value="#arguments.nd_Dispersion#"              null="#iif(isNumeric(arguments.nd_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_TipoDocumento"           value="#arguments.cl_TipoDocumento#"           null="#iif(len(arguments.cl_TipoDocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Documento"               value="#arguments.id_Documento#"               null="#iif(isNumeric(arguments.id_Documento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_Documento"               value="#arguments.im_Documento#"               null="#iif(isNumeric(arguments.im_Documento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProgramacionPago"        value="#arguments.id_ProgramacionPago#"        null="#iif(isNumeric(arguments.id_ProgramacionPago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProgramacionPagoDetalle" value="#arguments.id_ProgramacionPagoDetalle#" null="#iif(isNumeric(arguments.id_ProgramacionPagoDetalle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalDocumento"       value="#arguments.id_SucursalDocumento#"       null="#iif(isNumeric(arguments.id_SucursalDocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_AnticipoPagar"           value="#arguments.sn_AnticipoPagar#"           null="#iif(isBoolean(arguments.sn_AnticipoPagar),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"                  value="#arguments.id_Moneda#"                  null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"              value="#arguments.im_TipoCambio#"              null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_DocumentoMN"             value="#arguments.im_DocumentoMN#"             null="#iif(isNumeric(arguments.im_DocumentoMN),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado"         value="#session.ID_EMPRESAOPERADORA#"          null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"                value="#SESSION.ID_EMPLEADO#"                  null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"           value="#arguments.id_DeudorDiverso#"           null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso"         value="#arguments.id_AcreedorDiverso#"         null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
        </cfstoredproc>

    </cffunction>

    <!---
        Victor Sanchez
        inserta en dispersion de banco por proveedor
     --->
    <cffunction name="agregar_dispersionProveedor" access="public" returntype="void">
        <cfargument name="id_Empresa"            type="string" required="true"/>
        <cfargument name="id_Sucursal"           type="string" required="true"/>
        <cfargument name="id_Dispersion"         type="string" required="true"/>
        <cfargument name="id_Proveedor"          type="string" required="false"/>
        <cfargument name="im_TotalProveedor"     type="string" required="true"/>
        <cfargument name="id_CuentaBancaria"     type="string" required="true"/>
        <cfargument name="nu_CuentaBancaria"     type="string" required="false"/>
        <cfargument name="nu_ClabeInterbancaria" type="string" required="false"/>
        <cfargument name="de_ReferenciaLayout"   type="string" required="true"/>
        <cfargument name="id_DeudorDiverso"      type="string" required="false"/>
        <cfargument name="id_AcreedorDiverso"    type="string" required="false"/>

        <cfstoredproc procedure="upC_dispersionProveedor" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"           value="#arguments.id_Sucursal#"           null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion"         value="#arguments.id_Dispersion#"         null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"          value="#arguments.id_Proveedor#"          null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalProveedor"     value="#arguments.im_TotalProveedor#"     null="#iif(isNumeric(arguments.im_TotalProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"     value="#arguments.id_CuentaBancaria#"     null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_CuentaBancaria"     value="#arguments.nu_CuentaBancaria#"     null="#iif(len(arguments.nu_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_ClabeInterbancaria" value="#arguments.nu_ClabeInterbancaria#" null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_ReferenciaLayout"   value="#arguments.de_ReferenciaLayout#"   null="#iif(len(arguments.de_ReferenciaLayout),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"      value="#arguments.id_DeudorDiverso#"      null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso"    value="#arguments.id_AcreedorDiverso#"    null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
        </cfstoredproc>
    </cffunction>


    <!---
        Victor Sanchez
        Lista el detalle de la dispersion
     --->
    <cffunction name="listar_DispersionesDetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="yes">
        <cfargument name="id_Dispersion" type="string" required="yes">

        <cfstoredproc procedure="upR_DispersionDetalle" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#id_Empresa#" null="#iif(isNumeric(id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal" value="#id_Sucursal#" null="#iif(isNumeric(id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion" value="#id_Dispersion#" null="#iif(isNumeric(id_Dispersion),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        Actualiza el encabezado de una dispersion
     --->
    <cffunction name="update_dispersionEncabezado" access="public" returntype="void">
        <cfargument name="id_Empresa"         type="string" required="true"/>
        <cfargument name="id_Sucursal"        type="string" required="true"/>
        <cfargument name="id_Dispersion"      type="string" required="true"/>
        <cfargument name="id_CuentaBancaria"  type="string" required="true"/>
        <cfargument name="im_TotalDispersion" type="string" required="true"/>
        <cfargument name="fh_DiaPago"         type="string" required="true"/>
        <cfargument name="fh_DiaOperacion"    type="string" required="true"/>
        <cfargument name="id_Moneda"          type="string" required="true"/>
        <cfargument name="im_TipoCambio"      type="string" required="true"/>

        <cfstoredproc procedure="upU_DispercionEncabezado" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"         null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"        value="#arguments.id_Sucursal#"        null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion"      value="#arguments.id_Dispersion#"      null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"  value="#arguments.id_CuentaBancaria#"  null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalDispersion" value="#arguments.im_TotalDispersion#" null="#iif(isNumeric(arguments.im_TotalDispersion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_DiaPago"         value="#arguments.fh_DiaPago#"         null="#iif(len(arguments.fh_DiaPago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_DiaOperacion"    value="#arguments.fh_DiaOperacion#"    null="#iif(len(arguments.fh_DiaOperacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"          value="#arguments.id_Moneda#"          null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"      value="#arguments.im_TipoCambio#"      null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
        </cfstoredproc>
    </cffunction>


    <!---
        Victor Sanchez
        Elimina la dispersion de proveedor y su detalle
     --->
    <cffunction name="delete_dispersionProveedor" access="public" returntype="void">
        <cfargument name="id_Empresa"    type="string" required="true"/>
        <cfargument name="id_Sucursal"   type="string" required="true"/>
        <cfargument name="id_Dispersion" type="string" required="true"/>

        <cfstoredproc procedure="upD_DispersionPorProveedor" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"    value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"   value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion" value="#arguments.id_Dispersion#" null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
        </cfstoredproc>
    </cffunction>
    <!---
        Jose Miguel
        Genera los datos para crear el layout.txt de santander
     --->
    <cffunction name="upC_LayoutBanRegio" access="public" returntype="query">
        <cfargument name="id_Empresa"    type="numeric" required="yes">
        <cfargument name="id_Sucursal"   type="numeric" required="yes">
        <cfargument name="id_Dispersion" type="numeric" required="yes">

        <cfstoredproc procedure="upC_LayoutBanRegio" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"    value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"   value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion" value="#arguments.id_Dispersion#" null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
     --->
    <cffunction name="upC_LayoutSantander" access="public" returntype="query">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="yes">
        <cfargument name="id_Dispersion" type="string" required="yes">

        <cfstoredproc procedure="upC_LayoutSantander" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"    value="#arguments.id_Empresa#"    null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"   value="#arguments.id_Sucursal#"   null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Dispersion" value="#arguments.id_Dispersion#" null="#iif(isNumeric(arguments.id_Dispersion),false,true)#">
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        Proveedores Pagos Agregar
     --->
     <cffunction name="upC_LayoutBBVA" access="public" returntype="query">
        <cfargument name="id_Empresa"        type="numeric" required="yes">
        <cfargument name="id_Sucursal"       type="numeric" required="yes">
        <cfargument name="id_Dispersion"     type="numeric" required="yes">
        <cfargument name="id_CuentaBancaria" type="numeric" required="yes">
        <cfargument name="ID_MONEDA"         type="numeric" required="false">

        <cfstoredproc procedure="upC_LayoutBBVA" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"        value="#arguments.id_Empresa#"        null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"       value="#arguments.id_Sucursal#"       null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@iid_Dispersion"    value="#arguments.id_Dispersion#"     null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria" value="#arguments.id_CuentaBancaria#" null="false">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"         value="#arguments.ID_MONEDA#"         null="false">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="upC_proveedoresPagosAgregar" access="public" returntype="query">
        <cfargument name='id_Empresa'                       type='string'   required='yes'>
        <cfargument name='id_Sucursal'                      type='string'   required='yes'>
        <cfargument name='fh_pago'                          type='string'   required='no'>
        <cfargument name='id_moneda'                        type='string'   required='no'>
        <cfargument name='im_tipoCambio'                    type='string'   required='no'>
        <cfargument name='im_totalPago'                     type='string'   required='no'>
        <cfargument name='im_totalPagoMN'                   type='string'   required='no'>
        <cfargument name='im_TotalMovBancario'              type='string'   required='no'>
        <cfargument name='im_TotalMovBancarioMN'            type='string'   required='no'>
        <cfargument name='sn_Anticipo'                      type='string'   required='no'>
        <cfargument name='im_AnticipoAplicado'              type='string'   required='no'>
        <cfargument name='id_Proveedor'                     type='string'   required='no'>
        <cfargument name='id_CuentaBancaria'                type='string'   required='no'>
        <cfargument name='id_CuentaBancariaMov'             type='string'   required='no'>
        <cfargument name='id_Estatus'                       type='string'   required='no'>
        <cfargument name='id_EmpresaEmpleado'               type='string'   required='no'>
        <cfargument name='id_Empleado'                      type='string'   required='no'>
        <cfargument name='id_PolizaCont'                    type='string'   required='no'>
        <cfargument name='fh_PolizaCont'                    type='string'   required='no'>
        <cfargument name='id_PolizaCancel'                  type='string'   required='no'>
        <cfargument name='fh_PolizaCancel'                  type='string'   required='no'>
        <cfargument name='sn_ReposicionGastos'              type='string'   required='no'>

        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upC_proveedoresPagosAgregar
                    #id_Empresa#,
                    #id_Sucursal#,
                    '#fh_Pago#',
                    #id_moneda#,
                    #im_tipoCambio#,
                    #im_totalPago#,
                    #im_totalPagoMN#,
                    #im_TotalMovBancario#,
                    #im_TotalMovBancarioMN#,
                    <cfif isDefined("sn_Anticipo") AND #sn_Anticipo# NEQ ''>#sn_Anticipo#<cfelse>'N'</cfif>,
                    <cfif isDefined("im_AnticipoAplicado") AND #im_AnticipoAplicado# NEQ ''>#im_AnticipoAplicado#<cfelse>0</cfif>,
                    <cfif isDefined("id_Proveedor") AND #id_Proveedor# NEQ ''>#id_Proveedor#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_CuentaBancaria") AND #id_CuentaBancaria# NEQ ''>#id_CuentaBancaria#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_CuentaBancariaMov") AND #id_CuentaBancariaMov# NEQ ''>#id_CuentaBancariaMov#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_Estatus") AND #id_Estatus# NEQ ''>#id_Estatus#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_EmpresaEmpleado") AND #id_EmpresaEmpleado# NEQ ''>#id_EmpresaEmpleado#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_Empleado") AND #id_Empleado# NEQ ''>#id_Empleado#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_PolizaCont") AND #id_PolizaCont# NEQ ''>#id_PolizaCont#<cfelse>0</cfif>,
                    <cfif isDefined("fh_PolizaCont") AND #fh_PolizaCont# NEQ ''>'#fh_PolizaCont#'<cfelse>'1900-01-01'</cfif>,
                    <cfif isDefined("id_PolizaCancel") AND #id_PolizaCancel# NEQ ''>#id_PolizaCancel#<cfelse>NULL</cfif>,
                    <cfif isDefined("fh_PolizaCancel") AND #fh_PolizaCancel# NEQ ''>'#fh_PolizaCancel#'<cfelse>'1900-01-01'</cfif>,
                    <cfif isDefined("sn_ReposicionGastos") AND #sn_ReposicionGastos# NEQ ''>#sn_ReposicionGastos#<cfelse>0</cfif>
        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        Inserta el detalle de proveedores pagos
     --->
    <cffunction name="upC_ProveedoresPagosDetalle" access="public" returntype="query">
        <cfargument name='id_Empresa'           type='string'   required='yes'>
        <cfargument name='id_Sucursal'          type='string'   required='yes'>
        <cfargument name='id_Pago'              type='string'   required='no'>
        <cfargument name='cl_TipoPago'          type='string'   required='no'>
        <cfargument name='cl_TipoDocumento'     type='string'   required='no' default="NULL">
        <cfargument name='id_Documento'         type='string'   required='no' default="NULL">
        <cfargument name='id_PagoAnticipo'      type='string'   required='no'>
        <cfargument name='id_Cuenta'            type='string'   required='no'>
        <cfargument name='id_SCuenta'           type='string'   required='no'>
        <cfargument name='id_SSCuenta'          type='string'   required='no'>
        <cfargument name='id_SSSCuenta'         type='string'   required='no'>
        <cfargument name='im_Documento'         type='string'   required='no'>
        <cfargument name='im_DocumentoMN'       type='string'   required='no'>
        <cfargument name="id_SucursalDocumento"          type="string" required="false"/>
        <cfargument name="id_ProgramacionPago"           type="string" required="false"/>
        <cfargument name="id_ProgramacionPagoDetalle"    type="string" required="false"/>
        <cfargument name="id_Moneda"                    type="numeric" required="false">
        <cfargument name="im_TipoCambio"                type="numeric" required="false">


        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upC_ProveedoresPagosDetalle
                    #id_Empresa#,
                    #id_Sucursal#,
                    #id_Pago#,
                    '#cl_TipoPago#',
                    '#cl_TipoDocumento#',
                    #id_Documento#,
                    <cfif isDefined("id_PagoAnticipo") AND #id_PagoAnticipo# NEQ ''>#id_PagoAnticipo#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_Cuenta")>'#id_Cuenta#'<cfelse>NULL</cfif>,
                    <cfif isDefined("id_SCuenta")>'#id_SCuenta#'<cfelse>NULL</cfif>,
                    <cfif isDefined("id_SSCuenta")>'#id_SSCuenta#'<cfelse>NULL</cfif>,
                    <cfif isDefined("id_SSSCuenta")>'#id_SSSCuenta#'<cfelse>NULL</cfif>,
                    #im_Documento#,
                    #im_DocumentoMN#,
                    <cfif isDefined("id_ProgramacionPago")>#id_ProgramacionPago#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_ProgramacionPagoDetalle")>#id_ProgramacionPagoDetalle#<cfelse>NULL</cfif>,
                    <cfif isDefined("id_SucursalDocumento")>#id_SucursalDocumento#<cfelse>NULL</cfif>,


                    <cfif isDefined("Arguments.id_Moneda")>#Arguments.id_Moneda# <cfelse>NULL</cfif>,
                    <cfif isDefined("Arguments.im_TipoCambio")>#Arguments.im_TipoCambio# <cfelse>NULL</cfif>

        </cfquery>
        <cfreturn  Local.Proveedores />
    </cffunction>

    <!--- jc 14/02/2016
        Proveedores Pagos Agregar  --->
    <cffunction name="agregarpagoproveedor" access="public" returntype="query">
        <cfargument name="id_Empresa"            type="numeric" required="yes">
        <cfargument name="id_Sucursal"           type="numeric" required="yes">
        <cfargument name="fh_Pago"               type="string"  required="yes">
        <cfargument name="id_Moneda"             type="numeric" required="yes">
        <cfargument name="im_TipoCambio"         type="numeric" required="yes">
        <cfargument name="im_TotalPago"          type="numeric" required="yes">
        <cfargument name="im_TotalPagoMN"        type="numeric" required="yes">
        <cfargument name="im_TotalMovBancario"   type="numeric" required="yes">
        <cfargument name="im_TotalMovBancarioMN" type="numeric" required="yes">
        <cfargument name="sn_Anticipo"           type="string"  required="yes">
        <cfargument name="im_AnticipoAplicado"   type="numeric" required="yes">
        <cfargument name="id_Proveedor"          type="string"  required="no">
        <cfargument name="id_DeudorDiverso"      type="string"  required="no">
        <cfargument name="id_AcreedorDiverso"    type="string"  required="no">
        <cfargument name="id_CuentaBancaria"     type="numeric" required="no">
        <cfargument name="id_CuentaBancariamov"  type="numeric" required="no">
        <cfargument name="nu_Cheque"             type="string"  required="no">
        <cfargument name="id_Estatus"            type="numeric" required="yes">
        <cfargument name="id_PolizaCont"         type="numeric" required="yes">
        <cfargument name="fh_PolizaCont"         type="string"  required="yes">
        <cfargument name="id_PolizaCancel"       type="numeric" required="yes">
        <cfargument name="fh_PolizaCancel"       type="string"  required="yes">
        <cfargument name="sn_ReposicionGastos"   type="boolean" required="no" default="0">
        <cfargument name="id_empresaempleado"    type="string"  required="no">
        <cfargument name="id_empleado"           type="string"  required="no">

        <cfstoredproc procedure="upC_proveedoresPagosAgregar" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"            null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"           value="#arguments.id_Sucursal#"           null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Pago"               value="#arguments.fh_Pago#"               null="#iif(len(arguments.fh_Pago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"             value="#arguments.id_Moneda#"             null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"         value="#arguments.im_TipoCambio#"         null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalPago"          value="#arguments.im_TotalPago#"          null="#iif(isNumeric(arguments.im_TotalPago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalPagoMN"        value="#arguments.im_TotalPagoMN#"        null="#iif(isNumeric(arguments.im_TotalPagoMN),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalMovBancario"   value="#arguments.im_TotalMovBancario#"   null="#iif(isNumeric(arguments.im_TotalMovBancario),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TotalMovBancarioMN" value="#arguments.im_TotalMovBancarioMN#" null="#iif(isNumeric(arguments.im_TotalMovBancarioMN),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@sn_Anticipo"           value="#arguments.sn_Anticipo#"           null="#iif(len(arguments.sn_Anticipo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_AnticipoAplicado"   value="#arguments.im_AnticipoAplicado#"   null="#iif(isNumeric(arguments.im_AnticipoAplicado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"          value="#arguments.id_Proveedor#"          null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"     value="#arguments.id_CuentaBancaria#"     null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancariamov"  value="#arguments.id_CuentaBancariamov#"  null="#iif(isNumeric(arguments.id_CuentaBancariamov),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"            value="#arguments.id_Estatus#"            null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_empresaempleado"    value="#arguments.id_empresaempleado#"    null="#iif(len(arguments.id_empresaempleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_empleado"           value="#arguments.id_empleado#"           null="#iif(len(arguments.id_empleado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PolizaCont"         value="#arguments.id_PolizaCont#"         null="#iif(isNumeric(arguments.id_PolizaCont),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_PolizaCont"         value="#arguments.fh_PolizaCont#"         null="#iif(len(arguments.fh_PolizaCont),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PolizaCancel"       value="#arguments.id_PolizaCancel#"       null="#iif(isNumeric(arguments.id_PolizaCancel),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_PolizaCancel"       value="#arguments.fh_PolizaCancel#"       null="#iif(len(arguments.fh_PolizaCancel),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_ReposicionGastos"   value="#arguments.sn_ReposicionGastos#"   null="#iif(isBoolean(arguments.sn_ReposicionGastos),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"      value="#arguments.id_DeudorDiverso#"      null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso"    value="#arguments.id_AcreedorDiverso#"    null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
            <cfprocresult name="local.nextid" resultset="1">
        </cfstoredproc>

        <cfreturn local.nextid>
    </cffunction>

    <!--- jc 15/02/2016
        Agregar pago detalle proveedor --->
    <cffunction name="agregarpagoproveedordetalle" access="public" returntype="query">
        <cfargument name="id_Empresa"                    type="string" required="true"/>
        <cfargument name="id_Sucursal"                   type="string" required="true"/>
        <cfargument name="id_pago"                       type="string" required="true"/>
        <cfargument name="cl_tipopago"                   type="string" required="true"/>
        <cfargument name="cl_tipodocumento"              type="string" required="true"/>
        <cfargument name="id_Documento"                  type="string" required="true"/>
        <cfargument name="id_PagoAnticipo"               type="string" required="false"  default="NULL"/>
        <cfargument name="im_documento"                  type="string" required="true"/>
        <cfargument name="id_SucursalDocumento"          type="string" required="true"/>
        <cfargument name="id_ProgramacionPago"           type="string" required="true"/>
        <cfargument name="id_ProgramacionPagoDetalle"    type="string" required="true"/>
        <cfargument name="im_documentoMN"                type="string" required="true"/>
        <cfargument name="id_Moneda"                     type="string" required="false" default="NULL>"/>
        <cfargument name="im_TipoCambio"                 type="string" required="false" default="NULL"/>
        <cfargument name="sn_AjusteCentavos"             type="string" required="false" default="#0#"/>

        <cfstoredproc procedure="bop_ProveedoresPagosDetalles_Agregar" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"                 value="#id_Empresa#"                  null="#iif(isNumeric(id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"                value="#id_Sucursal#"                 null="#iif(isNumeric(id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_pago"                    value="#id_pago#"                     null="#iif(isNumeric(id_pago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_tipopago"                value="#cl_tipopago#"                 null="#iif(len(cl_tipopago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_tipodocumento"           value="#cl_tipodocumento#"            null="#iif(len(cl_tipodocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Documento"               value="#id_Documento#"                null="#iif(isNumeric(id_Documento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PagoAnticipo"            value="#id_PagoAnticipo#"             null="#iif(isNumeric(id_PagoAnticipo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Cuenta"                  value="#nullValue()#"                 null="true">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SCuenta"                 value="#nullValue()#"                 null="true">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SSCuenta"                value="#nullValue()#"                 null="true">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SSSCuenta"               value="#nullValue()#"                 null="true">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_documento"               value="#im_documento#"                null="#iif(isNumeric(im_documento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_documentoMN"             value="#im_documentoMN#"              null="#iif(isNumeric(im_documentoMN),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProgramacionPago"        value="#id_ProgramacionPago#"         null="#iif(isNumeric(id_ProgramacionPago),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProgramacionPagoDetalle" value="#id_ProgramacionPagoDetalle#"  null="#iif(isNumeric(id_ProgramacionPagoDetalle),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SucursalDocumento"       value="#id_SucursalDocumento#"        null="#iif(isNumeric(id_SucursalDocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"                  value="#arguments.id_Moneda#"         null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_NUMERIC" dbvarname="@im_TipoCambio"              value="#arguments.im_TipoCambio#"     null="#iif(isNumeric(arguments.im_TipoCambio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"                 value="#session.ID_USUARIO#"          null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_AjusteCentavos"          value="#arguments.sn_AjusteCentavos#" null="#iif(isNumeric(arguments.sn_AjusteCentavos),false,true)#">
            <cfprocresult name="Local.nextid" resultset="1">
        </cfstoredproc>

        <cfreturn local.nextid>
    </cffunction>

    <!--- jc 15/02/2016
        Actualizar pago detalle proveedor--->
    <cffunction name="updatepagosproveedoresestatus" access="public" returntype="void">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_proveedor"         type="string"   required="true"/>
        <cfargument name="id_pago"              type="string"   required="true"/>
        <cfargument name="sn_anticipo"          type="string"   required="true"/>
        <cfargument name="id_estatus"           type="string"   required="false" default="NULL"/>
        <cfargument name="im_anticipoaplicado"  type="string"   required="true"/>
        <cfargument name="opc"                  type="string"   required="true"/>

        <cfquery name="Local.nextid" datasource="#variables.cnx#" >
            exec pagosproveedoresupdatestatusmonto
                    #id_empresa#,
                    #id_sucursal#,
                    #id_proveedor#,
                    #id_pago#,
                    '#sn_anticipo#',
                    #id_estatus#,
                    #im_anticipoaplicado#,
                    #opc#
        </cfquery>
    </cffunction>

    <!--- jc 19.2.16 obtiene los movimiento de una emision de pagos --->
    <cffunction name="getmovimientos" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_Sucursal"          type="string"   required="true"/>
        <cfargument name="id_documento"         type="string"   required="true"/>
        <cfargument name="cl_tipodocumento"     type="string"   required="true"/>


        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upr_documentosproveedoresmovimientos
                    #id_empresa#,
                    #id_sucursal#,
                    '#cl_TipoDocumento#',
                    #id_documento#
        </cfquery>
        <cfreturn local.rs>
    </cffunction>

    <!--- jc 19.2.16 obtiene la informacion de  los movimiento de una emision de pagos --->
    <cffunction name="getinfomovimiento" access="public" returntype="query">
        <cfargument name="id_Empresa"         type="string" required="true"/>
        <cfargument name="id_Sucursal"        type="string" required="true"/>
        <cfargument name="id_documento"       type="string" required="true"/>
        <cfargument name="cl_tipodocumento"   type="string" required="true"/>
        <cfargument name="id_proveedor"       type="string" required="false"/>
        <cfargument name="id_DeudorDiverso"   type="string" required="false"/>
        <cfargument name="id_AcreedorDiverso" type="string" required="false"/>

        <cfstoredproc procedure="upR_DocumentosProveedoresgetinformacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"         value="#arguments.id_empresa#"         null="#iif(isNumeric(arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal"        value="#arguments.id_sucursal#"        null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_TipoDocumento"   value="#arguments.cl_TipoDocumento#"   null="#iif(len(arguments.cl_TipoDocumento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_documento"       value="#arguments.id_documento#"       null="#iif(isNumeric(arguments.id_documento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"       value="#arguments.id_proveedor#"       null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"   value="#arguments.id_DeudorDiverso#"   null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_AcreedorDiverso" value="#arguments.id_AcreedorDiverso#" null="#iif(isNumeric(arguments.id_AcreedorDiverso),false,true)#">
            <cfprocresult name="local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn local.rs>
    </cffunction>

    <!--- 22.02.16 jc  obtiene la informacion que se pintara en el formato de cheque--->
    <!--- <cffunction name="getinformacioncheque" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_PolizaCont"            type="string"   required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec up_RptChequePagoProveedor
                    #id_empresa#,
                    #id_PolizaCont#
        </cfquery>
        <cfreturn local.rs>
    </cffunction> --->
    <cffunction name="getinformacioncheque" access="public" returntype="query">
        <cfargument name="id_Empresa"     type="string"   required="true"/>
        <cfargument name="id_PolizaCont"  type="string"   required="true"/>

            <cfstoredproc procedure="up_RptChequePagoProveedor" datasource="#variables.cnx#" >
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"     value="#Arguments.id_Empresa#"     null="#iif(isNumeric(Arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_PolizaCont"  value="#Arguments.id_PolizaCont#"  null="#iif(isNumeric(Arguments.id_PolizaCont),false,true)#">

                <cfprocresult name="local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn local.rs/>
    </cffunction>

    <!--- 22.02.16 jc  obtiene la informacion que se pintara en el formato de cheque cuando es de cancelacion--->
    <cffunction name="getinformacionchequecancelacion" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="string"   required="true"/>
        <cfargument name="id_PolizaCont"            type="string"   required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec up_RptChequePagoProveedor_PolizaCancel2
                    #id_empresa#,
                    #id_PolizaCont#
        </cfquery>
        <cfreturn local.rs>
    </cffunction>


    <!---  Arroja el listado de proveedores activos con sus posibles cuentas contables   --->
    <cffunction name="listarProveedoresCuentasContables" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string" required="false">
        <cfargument name="id_Moneda"    type="string" required="false">
        <cfargument name="id_proveedor" type="string" required="false">

            <cfstoredproc procedure="upR_ProveedoresCuentasContables" datasource="#variables.cnx#" >
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"   value="#Arguments.id_empresa#"   null="#iif(isNumeric(Arguments.id_empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_moneda"  value="#Arguments.id_moneda#"  null="#iif(isNumeric(Arguments.id_moneda),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#Arguments.id_proveedor#" null="#iif(isNumeric(Arguments.id_proveedor),false,true)#">

                <cfprocresult name="Local.Proveedores" resultset="1">
            </cfstoredproc>

        <cfreturn Local.Proveedores/>
    </cffunction>

    <!---
        Victor Sanchez
        23/03/2016
        Se obtiene el correo del proveedor de las cotizaciones
     --->
    <cffunction name="upR_emailProveedorCotizacion" access="public" returntype="query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="id_Cotizacion" type="numeric" required="true">

        <cfquery name="Local.Proveedores" datasource="#variables.cnx#" >
            exec upR_emailProveedorCotizacion #id_Empresa#,#id_Cotizacion#

        </cfquery>
        <cfreturn Local.Proveedores/>
    </cffunction>

    <!--- listado de las programaciones de pagos  --->
    <cffunction name="listarprogramacionpagos" access="public" returntype="query">
        <cfargument name="id_empresa"       type="numeric"      required="true"/>
        <cfargument name="id_sucursal"      type="numeric"      required="true"/>
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>
        <cfargument name="id_Proveedor"     type="string"       required="false"/>

        <!--- <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_Programacionespagos
            #id_empresa#,
            #id_sucursal#,
            <cfif isDefined("Arguments.clprogramacion") AND ARGUMENTS.clprogramacion NEQ ''>#Arguments.clprogramacion#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.fh_i") AND ARGUMENTS.fh_i NEQ ''>'#Arguments.fh_i#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.fh_f") AND ARGUMENTS.fh_f NEQ ''>'#Arguments.fh_f#'<cfelse>NULL</cfif>,
            #accion#,
            #page#,
            #pageSize#,
            <cfif isDefined("Arguments.Estatus") AND ARGUMENTS.Estatus NEQ ''>'#Arguments.Estatus#'<cfelse>NULL</cfif>,
                                <cfif   IsDefined('arguments.id_Proveedor') AND #arguments.id_Proveedor# NEQ ''>
                                    #arguments.id_Proveedor#
                                <cfelse>
                                    NULL
                                </cfif>,
                                <cfif   IsDefined('arguments.nu_FolioDocumento') AND #arguments.nu_FolioDocumento# NEQ ''>
                                    '#arguments.nu_FolioDocumento#'
                                <cfelse>
                                    NULL
                                </cfif>

        </cfquery>  
        <cfreturn Local.rs/>--->
       <cfstoredproc procedure="upL_Programacionespagos" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_empresa"        value="#Arguments.id_empresa#"       null="#iif(isNumeric(Arguments.id_empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal"       value="#Arguments.id_sucursal#"      null="#iif(isNumeric(Arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@cl_programacion"   value="#Arguments.clprogramacion#"   null="#iif(len(Arguments.clprogramacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DATE"    dbvarname="@fh_inicio"         value="#Arguments.fh_i#"             null="#iif(len(Arguments.fh_i),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_DATE"    dbvarname="@fh_fin"            value="#Arguments.fh_f#"             null="#iif(len(Arguments.fh_f),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@accion"            value="#Arguments.accion#"           null="#iif(isNumeric(Arguments.accion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"              value="#Arguments.page#"             null="#iif(isNumeric(Arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"          value="#Arguments.pageSize#"         null="#iif(isNumeric(Arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Estatus"           value="#Arguments.Estatus#"          null="#iif(len(Arguments.Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"      value="#Arguments.id_Proveedor#"     null="#iif(isNumeric(Arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_FolioDocumento" value="">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- OBTENER PROVEEDOREES --->
    <cffunction name="obtenerproveedor" access="public" returntype="query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="id_proveedor" type="numeric" required="true">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_proveedoresnombre
            #id_Empresa#,
            #id_proveedor#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- OBTENER RFC PROVEEDORES--->
    <cffunction name="obtenerProveedorRFC" access="public" returntype="query">
        <cfargument name="id_Empresa" type="numeric" required="true">
        <cfargument name="de_RFC"     type="string"  required="true">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upR_proveedoresRFC
            #id_Empresa#,
            '#de_RFC#'
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="resetCuentasContables" access="public" returntype="void">
        <cfargument name="id_proveedor" type="string" required="false">
        <cfargument name="id_CuentaBancaria" type="string" required="false">

        <cfstoredproc procedure="upU_ProveedoresCuentasContablesReset" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#Arguments.id_proveedor#" null="#iif(isNumeric(Arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria" value="#Arguments.id_CuentaBancaria#" null="#iif(isNumeric(Arguments.id_CuentaBancaria),false,true)#">
        </cfstoredproc>
    </cffunction>

    <!--- AGREGAR CUENTAS CONTABLES --->
    <cffunction name="AgregarCuentasContables" access="public" returntype="any">
        <cfargument name="id_proveedor"          type="string" required="false">
        <cfargument name="id_CuentaBancaria"     type="string" required="false">
        <cfargument name="nb_CuentaBancaria"     type="string" required="false">
        <cfargument name="id_TipoTransferencia"  type="string" required="false">
        <cfargument name="nb_ClaveProveedor"     type="string" required="false">
        <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
        <cfargument name="id_Banco"              type="string" required="false">
        <cfargument name="id_Moneda"             type="string" required="false">
        <cfargument name="ar_Caratula"           type="string" required="false">
        <cfargument name="de_Concepto"           type="string" required="false">

        <cfstoredproc procedure="upC_ProveedoresCuentasBancarias" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"          value="#arguments.id_proveedor#"          null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"     value="#arguments.id_CuentaBancaria#"     null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_CuentaBancaria"     value="#arguments.nb_CuentaBancaria#"     null="#iif(len(arguments.nb_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoTransferencia"  value="#arguments.id_TipoTransferencia#"  null="#iif(isNumeric(arguments.id_TipoTransferencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ClaveProveedor"     value="#arguments.nb_ClaveProveedor#"     null="#iif(len(arguments.nb_ClaveProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_ClabeInterbancaria" value="#arguments.nu_ClabeInterbancaria#" null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Banco"              value="#arguments.id_Banco#"              null="#iif(isNumeric(arguments.id_Banco),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"             value="#arguments.id_Moneda#"             null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Usuario"            value="#session.ID_USUARIO#"              null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ar_Caratula"           value="#arguments.ar_Caratula#"           null="#iif(len(arguments.ar_Caratula),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Concepto"           value="#arguments.de_Concepto#"           null="#iif(len(arguments.de_Concepto),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="EditarCuentasContablesReporte" access="public" returntype="void">
        <cfargument name="id_proveedor"          type="string" required="false">
        <cfargument name="id_CuentaBancaria"     type="string" required="false">
        <cfargument name="nb_CuentaBancaria"     type="string" required="false">
        <cfargument name="id_TipoTransferencia"  type="string" required="false">
        <cfargument name="nb_ClaveProveedor"     type="string" required="false">
        <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
        <cfargument name="id_Banco"              type="string" required="false">
        <cfargument name="id_Moneda"             type="string" required="false">


        <cfstoredproc procedure="upU_ProveedoresCuentasBancariasReporte" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"          value="#arguments.id_proveedor#"          null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"     value="#arguments.id_CuentaBancaria#"     null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_CuentaBancaria"     value="#arguments.nb_CuentaBancaria#"     null="#iif(len(arguments.nb_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoTransferencia"  value="#arguments.id_TipoTransferencia#"  null="#iif(isNumeric(arguments.id_TipoTransferencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ClaveProveedor"     value="#arguments.nb_ClaveProveedor#"     null="#iif(len(arguments.nb_ClaveProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_ClabeInterbancaria" value="#arguments.nu_ClabeInterbancaria#" null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Banco"              value="#arguments.id_Banco#"              null="#iif(isNumeric(arguments.id_Banco),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"             value="#arguments.id_Moneda#"             null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Usuario"            value="#session.ID_USUARIO#"              null="#iif(isNumeric(session.ID_USUARIO),false,true)#">

        </cfstoredproc>
    </cffunction>

    <cffunction name="upL_PuestoByidUsuario" access="public" returntype="query" output="false">
    <cfargument name="id_Usuario" type="numeric" required="true">

        <cfquery name="q" datasource="#application.datasource#">
            exec upL_PuestoByidUsuario #val(arguments.id_Usuario)#
        </cfquery>

        <cfreturn q>
    </cffunction>


    <!--- OBTENER CUENTAS VANCARIAS--->
    <cffunction name="obtenerCuentasBancarias" access="public" returntype="query">
        <cfargument name="id_proveedor"       type="string" required="false">
        <cfargument name="id_Moneda"          type="numeric" required="false"/>

            <cfstoredproc procedure="upL_ProveedoresCuentasBancarias" datasource="#variables.cnx#" >
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#Arguments.id_proveedor#"    null="#iif(isNumeric(Arguments.id_proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"    value="#Arguments.id_Moneda#"       null="#iif(isNumeric(Arguments.id_Moneda),false,true)#">

                <cfprocresult name="Local.Proveedores" resultset="1">
            </cfstoredproc>

            <cfreturn Local.Proveedores/>
        </cffunction>
        <cffunction name="obtenerCuentasBancariasReporte" access="public" returntype="struct">
            <cfargument name="id_proveedor"       type="string" required="false">
        <cfargument name="id_CuentaBancaria"     type="string" required="false"/>

            <cfargument name="id_DeudorDiverso"  type="string" required="false"/>

                <cfstoredproc procedure="upL_ProveedoresCuentasBancariasReporteProv" datasource="#variables.cnx#" >
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"      value="#Arguments.id_proveedor#"      null="#iif(isNumeric(Arguments.id_proveedor),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria" value="#Arguments.id_CuentaBancaria#" null="#iif(isNumeric(Arguments.id_CuentaBancaria),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"      value="#Arguments.id_DeudorDiverso#"      null="#iif(isNumeric(Arguments.id_DeudorDiverso),false,true)#">

                    <cfprocresult name="Local.rs.Proveedores" resultset="1">
                    <cfprocresult name="Local.rs.Deudores" resultset="2">
                </cfstoredproc>

                <cfreturn Local.rs/>
            </cffunction>

    <cffunction name="obtenerCuentasBancariasCombo" access="public" returntype="query">
        <cfargument name="id_proveedor" type="string" required="true">
        <cfargument name="id_Moneda" type="string" required="false">

            <cfstoredproc procedure="upR_ProveedoresCuentasBancariascombo" datasource="#variables.cnx#" >
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#Arguments.id_proveedor#" null="#iif(isNumeric(Arguments.id_proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda" value="#Arguments.id_Moneda#" null="#iif(isNumeric(Arguments.id_Moneda),false,true)#">

                <cfprocresult name="Local.Proveedores" resultset="1">
            </cfstoredproc>

            <cfreturn Local.Proveedores/>
        </cffunction>

        <cffunction name="aplicarClasificacion" access="public" returntype="struct" output="false">
  <cfargument name="id_Proveedor"     type="string" required="true"/>
  <cfargument name="id_Clasificacion" type="string" required="true"/>

  <cfset var Local = {}>

  <cftry>
    <cfstoredproc procedure="upU_clasificacionProveedor" datasource="#variables.cnx#">
      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@idProveedor"
                   value="#arguments.id_Proveedor#"
                   null="#iif(isNumeric(arguments.id_Proveedor), false, true)#" />

      <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@idClasificacion"
                   value="#arguments.id_Clasificacion#"
                   null="#iif(isNumeric(arguments.id_Clasificacion), false, true)#" />
    </cfstoredproc>

    <cfset Local = { ISOK = true, MSG = "OK" }>

    <cfcatch type="any">
      <cfset Local = {
        ISOK   = false,
        MSG    = cfcatch.message,
        DETAIL = cfcatch.detail
      }>
    </cfcatch>
  </cftry>

  <cfreturn Local>
</cffunction>



    <cffunction name="listarTransferenciasCombo" access="public" returntype="query">

        <cfstoredproc procedure="upL_TipoTransferencia" datasource="#variables.cnx#" >
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Proveedores/>

    </cffunction>

    <cffunction name="listaridentificadorCom" access="public" returntype="query">

        <cfstoredproc procedure="upL_tipoOrigenProveedores" datasource="#variables.cnx#" >
            <cfprocresult name="Local.Proveedores" resultset="1">
        </cfstoredproc>


        <cfreturn Local.Proveedores/>

    </cffunction>

      <cffunction name="upL_CorreosNotificacionProveedorSuministro" access="public" returntype="query">
          <cfquery name="Local.q" datasource="#variables.cnx#">
              exec upL_CorreosNotificacionProveedorSuministro
          </cfquery>
          <cfreturn Local.q/>
      </cffunction>



    <cffunction name="permisoClasificacion" access="public" returntype="query">
      <cfargument name="id_usuario" type="any" required="true">

      <cfset var Local = {} />
      <cfset var vIdUsuario = (isNumeric(trim(arguments.id_usuario)) ? int(arguments.id_usuario) : 0) />

      <cfstoredproc procedure="upL_PermisoClasificacionProveedor" datasource="#variables.cnx#">

          <cfprocparam type="IN"
                      cfsqltype="CF_SQL_INTEGER"
                      dbvarname="@idUsuario"
                      value="#vIdUsuario#"
                      null="#(vIdUsuario LTE 0)#" />

          <cfprocresult name="Local.Permiso" resultset="1" />
      </cfstoredproc>

      <cfreturn Local.Permiso />
    </cffunction>


    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroAgregar" access="public" returntype="void">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_PAIS"              type="string" required="true"/>
        <cfargument name="ID_ESTADO"            type="string" required="true"/>
        <cfargument name="ID_MUNICIPIO"         type="string" required="true"/>
        <cfargument name="ID_LOCALIDAD"         type="string" required="true"/>
        <cfargument name="NB_COLONIA"           type="string" required="true"/>
        <cfargument name="NB_CALLE"             type="string" required="true"/>
        <cfargument name="DE_REFERENCIA"        type="string" required="false"/>
        <cfargument name="NU_EXTERIOR"          type="string" required="false"/>
        <cfargument name="NU_INTERIOR"          type="string" required="false"/>
        <cfargument name="NU_CP"                type="string" required="false"/>
        <cfargument name="NU_TELEFONO"          type="string" required="false"/>
        <cfargument name="ID_TAR"               type="string" required="false"/>


        <cfstoredproc procedure="upC_ProveedoresDireccionesRetiros" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PROVEEDOR"       value="#arguments.ID_PROVEEDOR#"      null="#iif(isNumeric(arguments.ID_PROVEEDOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PAIS"            value="#arguments.ID_PAIS#"           null="#iif(isNumeric(arguments.ID_PAIS),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_ESTADO"          value="#arguments.ID_ESTADO#"         null="#iif(isNumeric(arguments.ID_ESTADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_MUNICIPIO"       value="#arguments.ID_MUNICIPIO#"      null="#iif(isNumeric(arguments.ID_MUNICIPIO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_LOCALIDAD"       value="#arguments.ID_LOCALIDAD#"      null="#iif(isNumeric(arguments.ID_LOCALIDAD),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NB_COLONIA"         value="#arguments.NB_COLONIA#"        null="#iif(len(arguments.NB_COLONIA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NB_CALLE"           value="#arguments.NB_CALLE#"          null="#iif(len(arguments.NB_CALLE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@DE_REFERENCIA"      value="#arguments.DE_REFERENCIA#"     null="#iif(len(arguments.DE_REFERENCIA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_EXTERIOR"        value="#arguments.NU_EXTERIOR#"       null="#iif(len(arguments.NU_EXTERIOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_EXTERIOR"        value="#arguments.NU_EXTERIOR#"       null="#iif(len(arguments.NU_EXTERIOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@NU_CP"              value="#arguments.NU_CP#"             null="#iif(len(arguments.NU_CP),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_TELEFONO"        value="#arguments.NU_TELEFONO#"       null="#iif(len(arguments.NU_TELEFONO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPRESAEMPLEADO" value="#session.ID_EMPRESAOPERADORA#" null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPLEADO"        value="#SESSION.ID_EMPLEADO#"         null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_TAR"             value="#arguments.ID_TAR#"            null="#iif(isNumeric(arguments.ID_TAR),false,true)#">
        </cfstoredproc>
    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroListar" access="public" returntype="query">
        <cfargument name="ID_PROVEEDOR"       type="string" required="true"/>
        <cfargument name="cf_SimuladorCostos" type="string" required="false"/>

        <cfstoredproc procedure="upL_ProveedoresDireccionesRetiros" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PROVEEDOR" value="#arguments.ID_PROVEEDOR#" null="#iif(isNumeric(arguments.ID_PROVEEDOR), false, true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT" dbvarname="@cf_SimuladorCostos" value="#arguments.cf_SimuladorCostos#" null="#iif(isNumeric(arguments.cf_SimuladorCostos), false, true)#">

            <cfprocresult name="Local.dir" resultset="1">
        </cfstoredproc>

        <cfreturn Local.dir/>
    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroEditar" access="public" returntype="void">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="true"/>
        <cfargument name="ID_PAIS"              type="string" required="true"/>
        <cfargument name="ID_ESTADO"            type="string" required="true"/>
        <cfargument name="ID_MUNICIPIO"         type="string" required="true"/>
        <cfargument name="ID_LOCALIDAD"         type="string" required="true"/>
        <cfargument name="NB_COLONIA"           type="string" required="true"/>
        <cfargument name="NB_CALLE"             type="string" required="true"/>
        <cfargument name="DE_REFERENCIA"        type="string" required="false"/>
        <cfargument name="NU_EXTERIOR"          type="string" required="false"/>
        <cfargument name="NU_INTERIOR"          type="string" required="false"/>
        <cfargument name="NU_CP"                type="string" required="false"/>
        <cfargument name="NU_TELEFONO"          type="string" required="false"/>
        <cfargument name="ID_TAR"               type="string" required="false"/>


        <cfstoredproc procedure="upU_ProveedoresDireccionesRetiros" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PROVEEDOR"       value="#arguments.ID_PROVEEDOR#"      null="#iif(isNumeric(arguments.ID_PROVEEDOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_DIRECCIONRETIRO" value="#arguments.ID_DIRECCIONRETIRO#"null="#iif(isNumeric(arguments.ID_DIRECCIONRETIRO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PAIS"            value="#arguments.ID_PAIS#"           null="#iif(isNumeric(arguments.ID_PAIS),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_ESTADO"          value="#arguments.ID_ESTADO#"         null="#iif(isNumeric(arguments.ID_ESTADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_MUNICIPIO"       value="#arguments.ID_MUNICIPIO#"      null="#iif(isNumeric(arguments.ID_MUNICIPIO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_LOCALIDAD"       value="#arguments.ID_LOCALIDAD#"      null="#iif(isNumeric(arguments.ID_LOCALIDAD),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NB_COLONIA"         value="#arguments.NB_COLONIA#"        null="#iif(len(arguments.NB_COLONIA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NB_CALLE"           value="#arguments.NB_CALLE#"          null="#iif(len(arguments.NB_CALLE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@DE_REFERENCIA"      value="#arguments.DE_REFERENCIA#"     null="#iif(len(arguments.DE_REFERENCIA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_EXTERIOR"        value="#arguments.NU_EXTERIOR#"       null="#iif(len(arguments.NU_EXTERIOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_EXTERIOR"        value="#arguments.NU_EXTERIOR#"       null="#iif(len(arguments.NU_EXTERIOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@NU_CP"              value="#arguments.NU_CP#"             null="#iif(len(arguments.NU_CP),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@NU_TELEFONO"        value="#arguments.NU_TELEFONO#"       null="#iif(len(arguments.NU_TELEFONO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPRESAEMPLEADO" value="#session.ID_EMPRESAOPERADORA#" null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPLEADO"        value="#SESSION.ID_EMPLEADO#"         null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_TAR"             value="#arguments.ID_TAR#"            null="#iif(isNumeric(arguments.ID_TAR),false,true)#">
        </cfstoredproc>
    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroEliminar" access="public" returntype="void">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="true"/>

        <cfstoredproc procedure="upD_ProveedoresDireccionesRetiros" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PROVEEDOR"       value="#arguments.ID_PROVEEDOR#"      null="#iif(isNumeric(arguments.ID_PROVEEDOR),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_DIRECCIONRETIRO" value="#arguments.ID_DIRECCIONRETIRO#"null="#iif(isNumeric(arguments.ID_DIRECCIONRETIRO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPRESAEMPLEADO" value="#session.ID_EMPRESAOPERADORA#" null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_EMPLEADO"        value="#SESSION.ID_EMPLEADO#"         null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
        </cfstoredproc>
    </cffunction>

    <!---
        JOSE IBARRA
        04/05/2018
    --->
    <cffunction name="ProveedoresTransportistas" access="public" returntype="query">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_ProveedoresTransportistas
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="ReporteProveedoresPasivos" access="public" returntype="any">
        <cfargument name="id_Empresa"   type="string"   required="false"/>
        <cfargument name="fh_inicio"    type="string"   required="false"/>
        <cfargument name="fh_fin"       type="string"   required="false"/>
        <cfargument name="id_Sucursal"  type="string"   required="false"/>
        <cfargument name="id_Proveedor" type="string"   required="false"/>
        <cfargument name="id_Moneda"    type="string"   required="false"/>


        <cfstoredproc procedure="upR_documentosproveedores_ListadodeProvision" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"   null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"          dbvarname="@fh_inicio"    value="#arguments.fh_inicio#"    null="#iif(len(arguments.fh_inicio),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"          dbvarname="@fh_fin"       value="#arguments.fh_fin#"       null="#iif(len(arguments.fh_fin),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"  value="#arguments.id_Sucursal#"  null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"    value="#arguments.id_Moneda#"    null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs>
    </cffunction>

    <cffunction name="ProveedorProductoListar" access="public" returntype="query">
      <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
      <cfargument name="sn_Activo"            type="string"   required="false"/>

      <cfstoredproc procedure="upL_ProveedoresProductos" datasource="#variables.cnx#" >
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@ID_PROVEEDOR"   value="#arguments.ID_PROVEEDOR#"  null="#iif(isNumeric(arguments.ID_PROVEEDOR),false,true)#">
          <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Activo"      value="#arguments.sn_Activo#"     null="#iif(isNumeric(arguments.sn_Activo),false,true)#">
          <cfprocresult name="Local.dir" resultset="1">
      </cfstoredproc>

      <cfreturn Local.dir/>

  </cffunction>

  <cffunction name="guardarProveedorProducto" access="public" returntype="void">
    <cfargument name="id_Proveedor"   type="string" required="true"/>
    <cfargument name="nb_Producto"    type="string" required="true"/>
    <cfargument name="sn_Activo"      type="string" required="true"/>

    <cfstoredproc procedure="upC_ProveedoresProductos" datasource="#variables.cnx#" >
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#"   null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Producto"  value="#arguments.nb_Producto#"    null="#iif(len(arguments.nb_Producto),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Activo"    value="#arguments.sn_Activo#"      null="#iif(isNumeric(arguments.sn_Activo),false,true)#">
    </cfstoredproc>
  </cffunction>

  <cffunction name="activarDesactivarProveedorProducto" access="public" returntype="void">
    <cfargument name="id_Proveedor"             type="string" required="true"/>
    <cfargument name="id_ProductoProveedor"     type="string" required="true"/>
    <cfargument name="sn_Activo"                type="string" required="true"/>

    <cfstoredproc procedure="upU_ProveedoresProductos" datasource="#variables.cnx#" >
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"           value="#arguments.id_Proveedor#"            null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProductoProveedor"   value="#arguments.id_ProductoProveedor#"    null="#iif(isNumeric(arguments.id_ProductoProveedor),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Activo"              value="#arguments.sn_Activo#"               null="#iif(isNumeric(arguments.sn_Activo),false,true)#">
    </cfstoredproc>
  </cffunction>

  <cffunction name="upL_almc_TipoDeAditivoCompra" access="public" returntype="query">

    <cfstoredproc procedure="upL_almc_TipoDeAditivoCompra" datasource="#variables.cnx#" >
      <cfprocresult name="Local.dir" resultset="1">
    </cfstoredproc>
    <cfreturn Local.dir/>

  </cffunction>

  <cffunction name="listadoProveedoresConSolicitud" access="public" returntype="query">
    <cfargument name="id_Plaza"       type="string" required="false"/>
    <cfargument name="fh_Margen"      type="string" required="false"/>
    <cfargument name="tiposProductos" type="string" required="false"/>

      <cfstoredproc procedure="upL_Proveedores_SolicitudesDeCompraProductos" datasource="#variables.cnx#" >
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Plaza"       value="#arguments.id_Plaza#"        null="#iif(isNumeric(arguments.id_Plaza),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Margen"      value="#arguments.fh_Margen#"       null="#iif(len(arguments.fh_Margen),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@tiposProductos" value="#arguments.tiposProductos#"  null="#iif(len(arguments.tiposProductos),false,true)#">
        <cfprocresult name="Local.rs" resultset="1">
      </cfstoredproc>
      <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="guardarOpcionesProveedor" access="public" returntype="void">

        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#">
        <cfabort> --->

        <cfargument name="id_Proveedor"                type="string" required="true"/>
        <cfargument name="sn_Transporte"               type="string" required="true"/>
        <cfargument name="sn_ProveedorCombustible"     type="string" required="true"/>
	    <cfargument name="nu_PermisoCRETransporte"     type="string" required="false"/>
	    <cfargument name="nu_PermisoCRECombustible"    type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas" type="string" required="true"/>
        <cfargument name="sn_ProveedorAditivo"         type="string" required="true"/>
        <cfargument name="id_TipoDeAditivo"            type="string" required="true"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string"required="false"/>


        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#">
        <cfabort> --->

        <cfstoredproc procedure="upU_ProveedoresTransComb" datasource="#variables.cnx#" >
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_Proveedor"                 value="#arguments.id_Proveedor#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_Transporte"                value="#arguments.sn_Transporte#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorCombustible"      value="#arguments.sn_ProveedorCombustible#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRETransporte"      value="#arguments.nu_PermisoCRETransporte#" null="#iif(len(arguments.nu_PermisoCRETransporte),false,true)#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"   dbvarname="@nu_PermisoCRECombustible"     value="#arguments.nu_PermisoCRECombustible#"null="#iif(len(arguments.nu_PermisoCRECombustible),false,true)#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_EmpresaEmpleado"           value="#session.ID_EMPRESAOPERADORA#"null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_SMALLINT"  dbvarname="@id_empleado"                  value="#SESSION.ID_EMPLEADO#"null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorDieselGasolinas"  value="#arguments.sn_ProveedorDieselGasolinas#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"       dbvarname="@sn_ProveedorAditivo"          value="#arguments.sn_ProveedorAditivo#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@id_TipoDeAditivo"                 value="#arguments.id_TipoDeAditivo#">
		<cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"   dbvarname="@nu_DiasRegistroComprasCombustible"      value="#arguments.nu_DiasRegistroComprasCombustible#" null="#iif(isNumeric(arguments.nu_DiasRegistroComprasCombustible),false,true)#">

        </cfstoredproc>
    </cffunction>

    <cffunction name="listarCuentasBancariasPaginados" access="public" returntype="query">
        <cfargument name="id_TipoReporte"        type="string"  required="false"/>
        <cfargument name="fh_Incio"              type="string"  required="false"/>
        <cfargument name="fh_Fin"                type="string"  required="false"/>
        <cfargument name="page"                  type="string"  required="false" default=""/>
        <cfargument name="pageSize"              type="string"  required="false" default=""/>
        <cfargument name="sn_PagoExtraOrdinario" type="string"  required="false" default="0"/>

        <cfstoredproc procedure="upL_ProveedoresCuentasBancariasPaginado" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoReporte"        value="#arguments.id_TipoReporte#"                null="#iif(isNumeric(arguments.id_TipoReporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"             value="#arguments.fh_inicio#"                     null="#iif(len(arguments.fh_inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"                value="#arguments.fh_fin#"                        null="#iif(len(arguments.fh_fin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"                  value="#arguments.page#"                          null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"              value="#arguments.pageSize#"                      null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_PagoExtraOrdinario" value="#arguments.sn_PagoExtraOrdinario ? 1 : 0#" null="#iif(isNumeric(arguments.sn_PagoExtraOrdinario ? 1 : 0),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
        </cffunction>

        <cffunction name="obtenerCuentasBancariasDeudores" access="public" returntype="query">
            <cfargument name="id_DeudorDiverso" type="string" required="false">
            <!--- <cfcontent type="text/html">
<cfdump var="#arguments#" label="arguments" abort="true"> --->

                <cfstoredproc procedure="upL_ProveedoresCuentasBancariasDeudores" datasource="#variables.cnx#" >
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso" value="#Arguments.id_DeudorDiverso#" null="#iif(isNumeric(Arguments.id_DeudorDiverso),false,true)#">

                    <cfprocresult name="Local.Proveedores" resultset="1">
                </cfstoredproc>

                <cfreturn Local.Proveedores/>
            </cffunction>
<!---
            <cffunction name="resetCuentasContablesDeudores" access="public" returntype="void">
                <cfargument name="id_DeudorDiverso" type="string" required="false">
                <cfstoredproc procedure="upU_DeudoresCuentasContablesDeudoresReset" datasource="#variables.cnx#" >
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso" value="#Arguments.id_DeudorDiverso#" null="#iif(isNumeric(Arguments.id_DeudorDiverso),false,true)#">
                </cfstoredproc>
            </cffunction> --->

            <cffunction name="AgregarCuentasContablesDeudores" access="public" returntype="void">
                <cfargument name="id_DeudorDiverso"      type="string" required="false">
                <cfargument name="nb_CuentaBancaria"     type="string" required="false">
                <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
                <cfargument name="id_Banco"              type="string" required="false">
                <cfargument name="id_Moneda"             type="string" required="false">
              <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#" label="arguments" abort="true"> --->

                <cfstoredproc procedure="upU_DeudoresCuentasBancarias" datasource="#variables.cnx#" >
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DeudorDiverso"          value="#arguments.id_DeudorDiverso#"          null="#iif(isNumeric(arguments.id_DeudorDiverso),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_CuentaBancaria"     value="#arguments.nb_CuentaBancaria#"     null="#iif(len(arguments.nb_CuentaBancaria),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_ClabeInterbancaria" value="#arguments.nu_ClabeInterbancaria#" null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Banco"              value="#arguments.id_Banco#"              null="#iif(isNumeric(arguments.id_Banco),false,true)#">
                    <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"             value="#arguments.id_Moneda#"             null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
                    <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Usuario"            value="#session.ID_USUARIO#"              null="#iif(isNumeric(session.ID_USUARIO),false,true)#"> --->

                </cfstoredproc>
            </cffunction>


  <cffunction name="CuentasBancariasReporte" access="public" returntype="Any">
    <cfargument name="id_TipoReporte"  type="string"  required="false"/>
    <cfargument name="fh_Inicio"       type="string"   required="false"/>
    <cfargument name="fh_Fin"          type="string"   required="false"/>

    <cfstoredproc procedure="upL_ProveedoresCuentasBancariasReporte" datasource="#variables.cnx#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoReporte"   value="#arguments.id_TipoReporte#"	null="#iif(isNumeric(arguments.id_TipoReporte),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"        value="#arguments.fh_inicio#"       null="#iif(len(arguments.fh_inicio),false,true)#">
        <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"           value="#arguments.fh_fin#"          null="#iif(len(arguments.fh_fin),false,true)#">
       <cfprocresult name="Local.rs" resultset="1">
    </cfstoredproc>



        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="actualizarLogo" access="public" returntype="void">
        <cfargument name="id_Proveedor" type="numeric"required="false"/>
        <cfargument name="imgLogo"      type="string" required="false"/>


        <cfstoredproc procedure="upU_ProveedoresActualizarLogo" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor" value="#arguments.id_proveedor#"  null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@imgLogo"      value="#arguments.imgLogo#"       null="#iif(len(arguments.imgLogo),false,true)#">
        </cfstoredproc>

    </cffunction>


    <cffunction name="VerificarEmpleadoCompra" access="public" returntype="Any">
        <cfargument name="Empleado" type="string" required="false"/>
        <cfstoredproc procedure="upR_VerificarEmpleadoCompra" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"   value="#arguments.Empleado#"  null="#iif(isNumeric(arguments.Empleado),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
        </cffunction>


  <cffunction name="eliminarCuentasBancarias" access="public" returntype="void">
            <cfargument name="id_Proveedor" type="string" required="false">
            <cfargument name="id_CuentaBancaria" type="string" required="false">
            <cfargument name="nb_CuentaBancaria" type="string" required="false">
            <cfargument name="id_TipoTransferencia"  type="string" required="false">
            <cfargument name="nb_ClaveProveedor"     type="string" required="false">
            <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
            <cfargument name="id_Banco"              type="string" required="false">
            <cfargument name="id_Moneda"             type="string" required="false">
            <cfargument name="de_Concepto"           type="string" required="false">

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upD_ProveedoresCuentasBancarias
                    #id_Proveedor#, #id_CuentaBancaria#, '#nb_CuentaBancaria#', #id_TipoTransferencia#, '#nb_ClaveProveedor#','#nu_ClabeInterbancaria#', #id_Banco#, #id_Moneda#, #session.ID_USUARIO#, '#de_Concepto#'
        </cfquery>

</cffunction>


    <cffunction name="ReporteAuxiliarPagos" access="public" returntype="any">
        <cfargument name="arr_Empresas"         type="string"   required="false"/>
        <cfargument name="arr_Sucursarles"      type="string"   required="false"/>
        <cfargument name="arr_Proveedores"      type="string"   required="false"/>
        <cfargument name="fh_Inicio"            type="string"   required="false"/>
        <cfargument name="fh_Fin"               type="string"   required="false"/>
        <cfargument name="id_TipoNegocio"       type="string"   required="false"/>
        <cfargument name="id_Empleado"          type="string"   required="false"/>

        <cfstoredproc procedure="upL_proveedores_auxiliarPagos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Empresa"     value="#arguments.arr_Empresas#"    null="#iif(len(arguments.arr_Empresas),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Sucursales"     value="#arguments.arr_Sucursarles#" null="#iif(len(arguments.arr_Sucursarles),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Proveedores"    value="#arguments.arr_Proveedores#" null="#iif(len(arguments.arr_Proveedores),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Inicio"      value="#arguments.fh_Inicio#"       null="#iif(len(arguments.fh_Inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_Fin"         value="#arguments.fh_Fin#"          null="#iif(len(arguments.fh_Fin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_TipoNegocio" value="#arguments.id_TipoNegocio#"  null="#iif(len(arguments.id_TipoNegocio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"    value="#session.ID_EMPLEADO#"     null="#iif(isNumeric(session.ID_EMPLEADO),false,true)#">
            <cfprocresult name="Local.rs.datos" resultset="1">
            <cfprocresult name="Local.rs.bancos" resultset="2">
        </cfstoredproc>

        <cfreturn Local.rs>
    </cffunction>

     <!--- Inserta un registro en ProveedoresServicios --->
     <cffunction name="AgregarProveedoresInsumosServicios" access="public" returntype="void">
        <cfargument name="id_Proveedor" type="numeric"  required="true"/>
        <cfargument name="id_Insumo"    type="numeric"  required="true"/>

        <cfstoredproc procedure="upC_ProveedoresServicios_CMF" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Insumo"    value="#arguments.id_Insumo#"    null="#iif(len(arguments.id_Insumo),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="ProveedoresServicios_listar" access="public" returntype="query">
        <cfargument name="id_Proveedor" type="string" required="false" default=""/>

            <cfstoredproc procedure="upL_ProveedoresServiciosByProveedor" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="DesactivarProveedoresServicios" access="public" returntype="void">
        <cfargument name="id_Proveedor" type="string" required="false" default=""/>

            <cfstoredproc procedure="upD_ProveedoresServiciosDesactivar" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            </cfstoredproc>
    </cffunction>

    <cffunction name="ActivarProveedoresServicios" access="public" returntype="void">
        <cfargument name="id_Proveedor" type="numeric"  required="true"/>
        <cfargument name="id_Insumo"    type="numeric"  required="true"/>

            <cfstoredproc procedure="upU_ProveedoresServiciosActivar" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@id_Insumo"    value="#arguments.id_Insumo#"    null="#iif(len(arguments.id_Insumo),false,true)#">
            </cfstoredproc>
    </cffunction>

    <cffunction name="ListarCMF" access="public" returntype="struct">
        <cfargument name="id_Empresa"       type="string" required="false"/>
        <cfargument name="id_Sucursal"      type="string" required="false"/>
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="id_Estatus"       type="string" required="false"/>
        <cfargument name="fh_inicio"        type="string" required="false"/>
        <cfargument name="fh_fin"           type="string" required="false"/>
        <cfargument name="page"             type="string" required="false" default="1"/>
        <cfargument name="pageSize"         type="string" required="false" default="10"/>

        <cfstoredproc procedure="upL_CMFacturas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"  value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#"    null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"   value="#arguments.id_Estatus#"      null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"    value="#arguments.fh_inicio#"       null="#iif(len(arguments.fh_inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"       value="#arguments.fh_fin#"          null="#iif(len(arguments.fh_fin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"         value="#arguments.page#"            null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"     value="#arguments.pageSize#"        null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocresult name="Local.rs.result" resultset="1">
            <cfprocresult name="Local.rs.rows" resultset="2">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

     <cffunction name="ListarProveedorPermisosCRE" access="public" returntype="query">
        <cfargument name="id_Proveedor"     type="string" required="false"/>

        <cfstoredproc procedure="upL_ProveedorPermisosCRE" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#"    null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="EliminarPermisoCRE" access="public" returntype="void">
        <cfargument name="id_Proveedor"                 type="numeric" required="true"/>
        <cfargument name="id_ProveedorPermiso"          type="numeric" required="true"/>

        <cfstoredproc procedure="upD_ProveedoresPermisoCRE" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"        value="#Arguments.id_Proveedor#"        null="#iif(isNumeric(Arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorPermiso" value="#Arguments.id_ProveedorPermiso#" null="#iif(isNumeric(Arguments.id_ProveedorPermiso),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="agregarProveedorPermisoCRE" access="public" returntype="void">
        <cfargument name="id_Proveedor"          type="numeric" required="true"/>
        <cfargument name="nu_PermisoCRE"         type="string"  required="true"/>
        <cfargument name="id_ProveedorPermiso"   type="numeric" required="true"/>
        <cfargument name="id_TipoPermisoCRE"     type="numeric" required="true"/>
        <cfargument name="id_DireccionRetiro"    type="numeric" required="false"/>
        <cfargument name="id_Plaza"              type="numeric" required="false"/>
        <cfargument name="sn_Default"            type="numeric" required="true"/>

        <cfstoredproc procedure="upC_ProveedorPermisosCRE" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"             value="#Arguments.id_Proveedor#"        null="#iif(isNumeric(Arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_PermisoCRE"            value="#Arguments.nu_PermisoCRE#"       null="#iif(len(Arguments.nu_PermisoCRE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorPermiso"      value="#Arguments.id_ProveedorPermiso#" null="#iif(isNumeric(Arguments.id_ProveedorPermiso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoPermisoCRE"        value="#Arguments.id_TipoPermisoCRE#"   null="#iif(isNumeric(Arguments.id_TipoPermisoCRE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DireccionRetiro"       value="#Arguments.id_DireccionRetiro#"  null="#iif(isNumeric(Arguments.id_DireccionRetiro),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Plaza"                 value="#Arguments.id_Plaza#"            null="#iif(isNumeric(Arguments.id_Plaza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Default"               value="#Arguments.sn_Default#"          null="#iif(isNumeric(Arguments.sn_Default),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Usuario"               value="#session.ID_USUARIO#"            null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
        </cfstoredproc>
    </cffunction>

     <cffunction name="editarProveedorPermisoCRE" access="public" returntype="void">
        <cfargument name="id_Proveedor"          type="numeric" required="true"/>
        <cfargument name="nu_PermisoCRE"         type="string"  required="true"/>
        <cfargument name="id_ProveedorPermiso"   type="numeric" required="true"/>
        <cfargument name="id_TipoPermisoCRE"     type="numeric" required="true"/>
        <cfargument name="id_DireccionRetiro"    type="numeric" required="false"/>
        <cfargument name="id_Plaza"              type="numeric" required="false"/>
        <cfargument name="sn_Default"            type="numeric" required="true"/>

        <cfstoredproc procedure="upU_ProveedorPermisosCRE" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"             value="#Arguments.id_Proveedor#"        null="#iif(isNumeric(Arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_PermisoCRE"            value="#Arguments.nu_PermisoCRE#"       null="#iif(len(Arguments.nu_PermisoCRE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorPermiso"      value="#Arguments.id_ProveedorPermiso#" null="#iif(isNumeric(Arguments.id_ProveedorPermiso),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoPermisoCRE"        value="#Arguments.id_TipoPermisoCRE#"   null="#iif(isNumeric(Arguments.id_TipoPermisoCRE),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_DireccionRetiro"       value="#Arguments.id_DireccionRetiro#"  null="#iif(isNumeric(Arguments.id_DireccionRetiro),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Plaza"                 value="#Arguments.id_Plaza#"            null="#iif(isNumeric(Arguments.id_Plaza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_BIT"     dbvarname="@sn_Default"               value="#Arguments.sn_Default#"          null="#iif(isNumeric(Arguments.sn_Default),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INT"     dbvarname="@id_Usuario"               value="#session.ID_USUARIO#"            null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="ProveedorPermisoCreNextID" access="public" returntype="string">
        <cfargument name="id_Proveedor"      type="numeric"         required="true">

        <cfquery name="Local.id_ProveedorPermiso" datasource="#variables.cnx#" >
            exec  upR_PermisoCreProveedor
                    #id_Proveedor#
        </cfquery>
        <cfreturn Local.id_ProveedorPermiso.nextID/>
    </cffunction>

    <cffunction name="ListarCMFReporte" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="string" required="false"/>
        <cfargument name="id_Sucursal"      type="string" required="false"/>
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="id_Estatus"       type="string" required="false"/>
        <cfargument name="fh_inicio"        type="string" required="false"/>
        <cfargument name="fh_fin"           type="string" required="false"/>
        <cfargument name="page"             type="string" required="false" default="1"/>
        <cfargument name="pageSize"         type="string" required="false" default="10"/>

        <cfstoredproc procedure="upL_CMFacturas_Reporte" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"      null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Sucursal"  value="#arguments.id_Sucursal#"     null="#iif(isNumeric(arguments.id_Sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#"    null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Estatus"   value="#arguments.id_Estatus#"      null="#iif(isNumeric(arguments.id_Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_inicio"    value="#arguments.fh_inicio#"       null="#iif(len(arguments.fh_inicio),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_fin"       value="#arguments.fh_fin#"          null="#iif(len(arguments.fh_fin),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"         value="#arguments.page#"            null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"     value="#arguments.pageSize#"        null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarProveedoresConsignacion" access="public" returntype="query">
        <cfargument name="id_Proveedor" type="string" required="false"/>

        <cfstoredproc procedure="upL_listadoProveedoresConsignacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarProveedoresConsignacionByInsumo" access="public" returntype="query">
        <cfargument name="id_Proveedor" type="string" required="false"/>

        <cfstoredproc procedure="upL_listadoProveedoresConsignacionByInsumo" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa" value="#SESSION.ID_EMPRESA#" null="#iif(isNumeric(SESSION.ID_EMPRESA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarProveedoresSn_PerteneceGrupo" access="public" returntype="query">
        <cfargument name="sn_PerteneceGrupo" type="string" required="false" default=""/>

            <cfstoredproc procedure="upL_Proveedores_snPerteneceGrupo" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_PerteneceGrupo"          value="#arguments.sn_PerteneceGrupo#"          null="#iif(isNumeric(arguments.sn_PerteneceGrupo),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="AccesosPuestoEmpleado" access="public" returntype="query">
        <cfstoredproc  procedure="UpR_AccesosPuestoEmpleadoProveedores" datasource="#variables.cnx#"> 
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaOperadora"  value="#SESSION.ID_EMPRESAOPERADORA#" null="#iif(isNumeric(SESSION.ID_EMPRESAOPERADORA),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Puesto"            value="#SESSION.ID_PUESTO#"           null="#iif(isNumeric(SESSION.ID_PUESTO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"          value="#SESSION.ID_EMPLEADO#"         null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="PermisosPorUsuarioProv" access="public" returntype="query">
        <cfargument name="id_Usuario" type="string" required="true"/>

        <cfstoredproc procedure="upL_PerfilesUsuarios_AccesoBloques" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario" value="#arguments.id_Usuario#" null="#iif(isNumeric(arguments.id_Usuario),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- listado de las programaciones de pagos  --->
    <cffunction name="listarprogramacionpagosEmpresas" access="public" returntype="query">
        <cfargument name="Empresas"         type="string"      required="true"/>
        <cfargument name="id_sucursal"      type="numeric"      required="false"/>
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>
        <cfargument name="id_Empleado"      type="numeric"      required="false"/>
        <cfargument name="id_EmpresaEmpleado"      type="numeric"      required="false"/>



        <cfstoredproc procedure="upL_ProgramacionespagosPorEmpresas" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Empresas"      value="#arguments.Empresas#"      null="#iif(len(arguments.Empresas),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_sucursal"  value="#arguments.id_sucursal#"  null="#iif(isNumeric(arguments.id_sucursal),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@clprogramacion"          value="#arguments.clprogramacion#"          null="#iif(len(arguments.clprogramacion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_i"          value="#arguments.fh_i#"          null="#iif(len(arguments.fh_i),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@fh_f"          value="#arguments.fh_f#"          null="#iif(len(arguments.fh_f),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@accion"  value="#arguments.accion#"  null="#iif(isNumeric(arguments.accion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"  value="#arguments.page#"  null="#iif(isNumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"  value="#arguments.pageSize#"  null="#iif(isNumeric(arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@Estatus"  value="#arguments.Estatus#"  null="#iif(isNumeric(arguments.Estatus),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"  value="">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_FolioDocumento" value="">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empleado"  value="#SESSION.ID_EMPLEADO#"  null="#iif(isNumeric(SESSION.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_EmpresaEmpleado"  value="#session.ID_EMPRESAOPERADORA#"  null="#iif(isNumeric(session.ID_EMPRESAOPERADORA),false,true)#">


            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>



        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="AgregarEditarProveedorContacto" access="public" returntype="void">
        <cfargument name="id_Empresa"           type="string" required="true"/>
        <cfargument name="id_Proveedor"         type="string" required="true"/>
        <cfargument name="id_ProveedorContacto" type="string" required="false"/>
        <cfargument name="nb_ProveedorContacto" type="string" required="true"/>
        <cfargument name="de_Email"             type="string" required="true"/>

        <cfstoredproc procedure="upU_ProveedoresContactosEditarAgregar" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#"           null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"         value="#arguments.id_Proveedor#"         null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_ProveedorContacto" value="#arguments.id_ProveedorContacto#" null="#iif(isNumeric(arguments.id_ProveedorContacto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ProveedorContacto" value="#arguments.nb_ProveedorContacto#" null="#iif(len(arguments.nb_ProveedorContacto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@de_Email"             value="#arguments.de_Email#"             null="#iif(len(arguments.de_Email),false,true)#">
        </cfstoredproc>

    </cffunction>

    <cffunction name="AgregarProveedoresCuentasBancariasMov" access="public" returntype="void">
        <cfargument name="id_proveedor"          type="string" required="false">
        <cfargument name="id_CuentaBancaria"     type="string" required="false">

        <cfstoredproc procedure="upC_ProveedoresCuentasBancariasMov" datasource="#variables.cnx#" >
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_proveedor"      value="#arguments.id_proveedor#"      null="#iif(isNumeric(arguments.id_proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria" value="#arguments.id_CuentaBancaria#" null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Usuario"        value="#session.ID_USUARIO#"          null="#iif(isNumeric(session.ID_USUARIO),false,true)#">
        </cfstoredproc>
    </cffunction>

    <cffunction name="ValidarEdicionProveedorCuentaBancaria" access="public" returntype="query">
        <cfargument name="id_Proveedor"          type="string" required="true"/>
        <cfargument name="id_CuentaBancaria"     type="string" required="true"/>
        <cfargument name="nb_CuentaBancaria"     type="string" required="true"/>
        <cfargument name="id_TipoTransferencia"  type="string" required="true"/>
        <cfargument name="nb_ClaveProveedor"     type="string" required="true"/>
        <cfargument name="nu_ClabeInterbancaria" type="string" required="true"/>
        <cfargument name="id_Banco"              type="string" required="true"/>
        <cfargument name="id_Moneda"             type="string" required="true"/>

        <cfstoredproc procedure="upR_ProveedoresCuentasBancariasValidacion" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor"          value="#arguments.id_Proveedor#"          null="#iif(isNumeric(arguments.id_Proveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_CuentaBancaria"     value="#arguments.id_CuentaBancaria#"     null="#iif(isNumeric(arguments.id_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_CuentaBancaria"     value="#arguments.nb_CuentaBancaria#"     null="#iif(len(arguments.nb_CuentaBancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoTransferencia"  value="#arguments.id_TipoTransferencia#"  null="#iif(isNumeric(arguments.id_TipoTransferencia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_ClaveProveedor"     value="#arguments.nb_ClaveProveedor#"     null="#iif(len(arguments.nb_ClaveProveedor),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nu_ClabeInterbancaria" value="#arguments.nu_ClabeInterbancaria#" null="#iif(len(arguments.nu_ClabeInterbancaria),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Banco"              value="#arguments.id_Banco#"              null="#iif(isNumeric(arguments.id_Banco),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Moneda"             value="#arguments.id_Moneda#"             null="#iif(isNumeric(arguments.id_Moneda),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
