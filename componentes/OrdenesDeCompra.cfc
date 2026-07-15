<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="OrdenCompraEnviarCorreo" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_OrdenDeCompra"     type="numeric" required="true"/>
        <cfargument name="sn_Politica" type="string" required="false">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="OrdenCompraEnviarCorreo"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset Variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="generarOrdenCompra" access="remote" returnformat="JSON">
        <cfargument name = "id_Empresa"                  type="numeric" required="true"/>
        <cfargument name = "id_cotizacion"               type="string"  required="true"/>
        <cfargument name = "id_requisicion"              type="string"  required="false"/>
        <cfargument name = "id_proveedor"                type="string"  required="true"/>
        <cfargument name = 'id_ProveedorContacto'        type='string'  required='yes'/>
        <cfargument name = "sn_cotizacionElegida"        type="boolean" required="true"/>
        <cfargument name = "de_comentarios"              type="string"  required="true"/>
        <cfargument name = "fh_EntregaProbable"          type="string"  required="true"/>
        <cfargument name = "ordenCompraDetalle"          type="array"   required="true"/>
        <cfargument name = "id_moneda"                   type="string"  required="true"/>
        <cfargument name = "nb_moneda"                   type="string"  required="true"/>
        <cfargument name = 'im_SubTotal'                 type='string'  required='true'/>
        <cfargument name = 'im_Descuento'                type='string'  required='true'/>
        <cfargument name = 'im_Total'                    type='string'  required='true'/>
        <cfargument name = "impuestos"                   type="array"   required="true"/>
        <cfargument name = "insumosComprar"              type="array"   required="true"/>
        <cfargument name = "totalesOrdenCompra"          type="struct"  required="true"/>
        <cfargument name = "de_observaciones"            type="string"  required="false"/>
        <cfargument name = "sn_CorreoProveedor"          type="string"  required="false"/>
        <cfargument name="id_Sucursal"                   type="string"  required="false"/>
        <cfargument name="sn_DescuentoNC"                type="string"  required="false"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="generarOrdenCompra"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset Variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setJson({'ID_ORDENDECOMPRA': Local.BRO.ID_ORDENDECOMPRA})>
                </cfif>

                <cfcatch type="any">
                    <!--- <cfdump var="#cfcatch#"><cfabort /> --->
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="SubirRutaArchivoAutorizacion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="numeric"  required="true"/>
        <cfargument name="id_OrdenCompra"   type="numeric"  required="true"/>
        <cfargument name="nombre"           type="string"   required="false"/>
        <cfargument name="ruta"             type="string"   required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#" 
                          method="SubirRutaArchivoAutorizacion"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO" />
                <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset Variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getById" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"       type="string" required="false">
        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="id_Usuario"       type="string" required="false">
        <cfargument name="sn_ParaEntrada"   type="boolean" required="false" default="false">

            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="getById"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getByIdOC" access="remote" returnformat="JSON">
        <cfargument name="id_ordenDeCompra" type="string" required="true">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getByIdOC"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

<!--- Victor Sanchez
    24/12/2015
    trae los datos para la devolucion a proveedor
 --->
        <cffunction name="getByFolioOC" access="remote" returnformat="JSON">
        <cfargument name="Folio" type="string" required="true">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getByFolioOC"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getByIdProveedor" access="remote" returnformat="JSON">
        <!--- En algunas pantallas id_proveedor no es requerido --->
        <cfargument name="id_Proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getByIdProveedor"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getOrdenesSinSurtir" access="remote" returnformat="JSON">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getOrdenesSinSurtir"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>


            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getOrdenesSinSurtirDevolucion" access="remote" returnformat="JSON">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getOrdenesSinSurtirDevolucion"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="getOrdenesIncumplidas" access="remote" returnformat="JSON">
        <cfargument name="id_sucursal"                    type="string" required="false"/>
        <cfargument name="id_Proveedor"                   type="string" required="false"/>
        <cfargument name="id_Departamento"                type="string" required="false"/>
        <cfargument name="id_Almacen"                     type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="id_insumo"                      type="string" required="false"/>
        <cfargument name="id_estatusSurtidoOrdenDeCompra" type="string" required="false"/>
        <cfargument name="fh_inicio"                      type="string" required="false"/>
        <cfargument name="fh_fin"                         type="string" required="false"/>
        <cfargument name="nb_sucursal"                    type="string" required="false"/>
        <cfargument name="nb_proveedor"                   type="string" required="false"/>
        <cfargument name="nb_Departamento"                type="string" required="false"/>
        <cfargument name="nb_Almacen"                     type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"               type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"                      type="string" required="false"/>
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false"/>

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                method="getOrdenesIncumplidas"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO"/>


            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="reporteIncumplimientoPorProveedor" access="remote" returnformat="JSON">
        <cfargument name="nb_sucursal" type="string" required="false">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="reporteIncumplimientoPorProveedor"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="reporteIncumplimientoPorProveedorPDF" access="remote" returnformat="JSON">
        <cfargument name="nb_sucursal" type="string" required="false">
        <cfargument name="nb_proveedor" type="string" required="false">
        <cfargument name="de_estatusSurtidoOrdenDeCompra" type="string" required="false">
        <cfargument name="fh_inicio" type="string" required="false">
        <cfargument name="fh_fin" type="string" required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="reporteIncumplimientoPorProveedorPDF"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 18/05/2015
          Cambia el estatus a cancelado de la orden de compra --->
    <cffunction name="cancelarOrdenCompra" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_ordenDeCompra"     type="string" required="true">
        <cfargument name="de_MotivoCancelacion" type="string" required="true">
        <cfargument name="sn_CorreoProveedor"   type="string" required="true">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="cancelarOrdenCompra"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de Compra cancelada exitosamente.")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 28/05/2015
          Obtiene el listado para control de ordenes de compra para el usuario especificado --->
    <cffunction name="listadoControl" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string"  required="false">
        <cfargument name="id_Sucursal"              type="string"  required="false">
        <cfargument name="id_ordenDeCompra"         type="string"  required="false">
        <cfargument name="fh_inicio"                type="string"  required="false">
        <cfargument name="fh_fin"                   type="string"  required="false">
        <cfargument name="id_proveedor"             type="string"  required="false">
        <cfargument name="id_estatusAutorizacion"   type="string"  required="false">
        <cfargument name="id_estatusSurtido"        type="string"  required="false">
        <cfargument name="page"                     type="numeric" required="true">
        <cfargument name="pageSize"                 type="numeric" required="true">
        <cfargument name="id_SolicitudCompra"       type="string" required="false">
        <cfargument name="id_Requisicion"           type="string" required="false">
        <cfargument name="id_TipoDivision"          type="string" required="false">
        <cfargument name="nu_Siniestro"             type="string" required="false">

        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                      method="listadoControl"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfelse>
                    <cfset Variables.ctrl.setQuery(Local.BRO.getQuery())>
                    <cfset variables.ctrl.setMessage("Ordenes de compra listadas correctamente.")>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>


    <!--- Jesus Reyes --->
    <cffunction name="imprimirOC" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa" type="string" required="false"/>
        <cfargument name="id_ordenDeCompra" type="string" required="true">
        <cfargument name="sn_Politica" type="string" required="false">
        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="imprimirOC"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>


          <!--- marcar para no trabajar o trabajar  la orden de compra --->
    <cffunction name="MarcarSolicitudCompra" access="remote" returnformat="JSON">
        <cfargument name="id_SolicitudCompra"           type="string" required="true">
        <cfargument name="id_Empresa"                   type="string" required="true">
        <cfargument name="sn_Comprar"                   type="string" required="true">
        <cfargument name="de_ObservacionesNoComprar"    type="string" required="false">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                          method="MarcarSolicitudCompra"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Orden de marcada exitosamente.")>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

    <cffunction name="generarReporte" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string"  required="false">
        <cfargument name="id_Sucursal"              type="string"  required="false">
        <cfargument name="id_ordenDeCompra"         type="string"  required="false">
        <cfargument name="fh_inicio"                type="string"  required="false">
        <cfargument name="fh_fin"                   type="string"  required="false">
        <cfargument name="id_proveedor"             type="string"  required="false">
        <cfargument name="id_estatusAutorizacion"   type="string"  required="false">
        <cfargument name="id_estatusSurtido"        type="string"  required="false">
        <cfargument name="id_SolicitudCompra"       type="string" required="false">
        <cfargument name="id_Requisicion"           type="string" required="false">
        <cfargument name="id_TipoDivision"          type="string" required="false">

        <cfargument name="empresa"          type="string" required="false">
        <cfargument name="sucursal"         type="string" required="false">
        <cfargument name="folioR"           type="string" required="false">
        <cfargument name="folioSC"          type="string" required="false">
        <cfargument name="folioOC"          type="string" required="false">
        <cfargument name="fechaInicio"      type="string" required="false">
        <cfargument name="fechaFin"         type="string" required="false">
        <cfargument name="estatusA"         type="string" required="false">
        <cfargument name="proveedor"        type="string" required="false">
        <cfargument name="estatusS"         type="string" required="false">
        <cfargument name="division"         type="string" required="false">

        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                      method="generarReporte"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset Variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
                <cfset variables.ctrl.rollback()>
            </cfcatch>
        </cftry>


        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="getById_Surtir" access="remote" returnformat="JSON">
      <cfargument name="id_Empresa"           type="string" required="false">
      <cfargument name="id_ordenDeCompra"     type="string" required="true">
      <cfargument name="id_Usuario"           type="string" required="false">
      <cfargument name="id_TipoRequisicion"   type="string" required="false">

          <cftry>
              <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                        method="getById_Surtir"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

              <cfif Local.BRO.hasError()>
                      <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                      <cfset Variables.ctrl.rollback()>
                  <cfelse>
                      <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                      <cfset variables.ctrl.setJson(Local.BRO.getData())>
              </cfif>

              <cfcatch type="any">
                  <cfset variables.ctrl.setCatch(cfcatch)>
                  <cfset Variables.ctrl.rollback()>
              </cfcatch>
          </cftry>

      <cfreturn variables.ctrl.toStruct() />
  </cffunction>

  <cffunction name="imprimirOCConta" access="remote" returnformat="JSON">
    <cfargument name="id_Empresa" type="string" required="false"/>
    <cfargument name="id_ordenDeCompra" type="string" required="true">
    <cftransaction>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                      method="imprimirOCConta"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset Variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <cfset variables.ctrl.setJson(Local.BRO.getData())>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
                <cfset Variables.ctrl.rollback()>
            </cfcatch>
        </cftry>
    </cftransaction>

    <cfreturn variables.ctrl.toStruct() />
</cffunction>

<cffunction name="GuardarInfoSustitucion" access="remote" returnformat="JSON">
    <cfargument name="id_Empresa"                   type="numeric" required="true"/>
    <cfargument name="id_OrdenCompra"               type="numeric" required="true"/>
    <cfargument name="sn_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="id_Sustitucion"               type="numeric" required="true"/>
    <cfargument name="de_ObservacionesSustitucion"  type="string" required="true"/>
    <cfargument name="ar_SoporteSustitucion"        type="string" required="true"/>

    <cftransaction>
        <cftry>
            <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                      method="GuardarInfoSustitucion"
                      argumentcollection="#arguments#"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                <cfset Variables.ctrl.rollback()>
            <cfelse>
                <cfset variables.ctrl.setMessage("Información por sustitucion<br>Guardada con exito")>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
                <cfset Variables.ctrl.rollback()>
            </cfcatch>
        </cftry>
    </cftransaction>

    <cfreturn variables.ctrl.toStruct() />
</cffunction>

    <cffunction name="SearchDocumentoSustitucion" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa" type="string" required="false"/>
        <cfargument name="id_OrdenCompra" type="string" required="true">

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeCompra')#"
                        method="SearchDocumentoSustitucion"
                        argumentcollection="#arguments#"
                        returnvariable="Local.BRO"/>

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset Variables.ctrl.rollback()>
                    <cfelse>
                        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setJson(Local.BRO.getData())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset Variables.ctrl.rollback()>
                </cfcatch>
            </cftry>
        </cftransaction>

        <cfreturn variables.ctrl.toStruct() />
    </cffunction>

</cfcomponent>
