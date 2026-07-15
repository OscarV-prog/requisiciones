<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="GetProveedorPemex" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="GetProveedorPemex"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar_ProveedoresTiposComprobantes" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric" required="true">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listar_ProveedoresTiposComprobantes"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresSn_Transorte" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="string" required="false" default=""/>
        <cfargument name="sn_Transporte" type="string" required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listarProveedoresSn_Transorte"
            argumentcollection="#arguments#"
            returnvariable="local.datos">

        <cfset variables.RBR.setQuery(Local.datos)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresSn_TallerMecanico" access="public" returntype="Any">
        <cfargument name="sn_TallerMecanico" type="string" required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listarProveedoresSn_TallerMecanico"
            argumentcollection="#arguments#"
            returnvariable="local.datos">

        <cfset variables.RBR.setQuery(Local.datos)>
        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listar_TiposComprobantes" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listar_TiposComprobantes"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Convierte cualquier valor típico (1/0, true/false, "true"/"false", "", null) a 0/1 --->
        <cffunction name="toBit" access="private" returntype="numeric" output="false">
          <cfargument name="v" type="any" required="true">

          <cfset var s = "" />

          <cfif isNull(arguments.v)>
            <cfreturn 0>
          </cfif>

          <cfif isBoolean(arguments.v)>
            <cfreturn arguments.v ? 1 : 0>
          </cfif>

          <cfif isNumeric(arguments.v)>
            <cfreturn (val(arguments.v) EQ 1 ? 1 : 0)>
          </cfif>

          <cfset s = lcase(trim(toString(arguments.v)))>

          <cfif s EQ "1" OR s EQ "true" OR s EQ "si" OR s EQ "sí" OR s EQ "on" OR s EQ "yes">
            <cfreturn 1>
          </cfif>

          <cfreturn 0>
        </cffunction>


        <!--- REGLA: enviar SOLO si es suministro "exclusivo" (los demás en false) --->
        <cffunction name="esSuministroExclusivo" access="private" returntype="boolean" output="false">
          <cfargument name="sn_Transporte" type="any" required="false" default="0">
          <cfargument name="sn_Suministro" type="any" required="false" default="0">
          <cfargument name="sn_ProveedorGasLP" type="any" required="false" default="0">
          <cfargument name="sn_ProveedorDieselGasolinas" type="any" required="false" default="0">
          <cfargument name="sn_ProveedorCompra" type="any" required="false" default="0">
          <cfargument name="sn_ProveedorAditivo" type="any" required="false" default="0">
          <cfargument name="sn_Consignacion" type="any" required="false" default="0">

          <cfset var t  = this.toBit(arguments.sn_Transporte)>
          <cfset var s  = this.toBit(arguments.sn_Suministro)>
          <cfset var glp = this.toBit(arguments.sn_ProveedorGasLP)>
          <cfset var dg = this.toBit(arguments.sn_ProveedorDieselGasolinas)>
          <cfset var cp = this.toBit(arguments.sn_ProveedorCompra)>
          <cfset var ad = this.toBit(arguments.sn_ProveedorAditivo)>
          <cfset var co = this.toBit(arguments.sn_Consignacion)>

          <cfreturn (t EQ 0 AND s EQ 1 AND glp EQ 0 AND dg EQ 0 AND cp EQ 0 AND ad EQ 0 AND co EQ 0)>
        </cffunction>

        <cffunction name="notificarCambioProveedorSuministro"
            access="private"
            returntype="struct"
            output="false">

              <cfargument name="id_Proveedor" type="numeric" required="true"/>
              <cfargument name="sn_Suministro_Nuevo" type="any" required="true"/>
              <cfargument name="esEdicion" type="boolean" required="true"/>
              <cfargument name="nb_Proveedor" type="string" required="false" default=""/>
              <cfargument name="de_RFC" type="string" required="false" default=""/>
              <cfargument name="debug" type="boolean" required="false" default="false"/>

              <cfset var result = {
                  debeNotificar: false,
                  antes: -1,
                  nuevo: 0,
                  correos_raw: "",
                  destinatarios: [],
                  envio_intentado: false,
                  envio_ok: false,
                  error_envio: "",
                  asunto: "",
                  tipoCambio: "",
                  puesto_usuario: ""
              }>

              <cfif isBoolean(arguments.sn_Suministro_Nuevo)>
                  <cfset result.nuevo = (arguments.sn_Suministro_Nuevo ? 1 : 0)>
              <cfelseif isNumeric(arguments.sn_Suministro_Nuevo)>
                  <cfset result.nuevo = (val(arguments.sn_Suministro_Nuevo) EQ 1 ? 1 : 0)>
              <cfelse>
                  <cfset result.nuevo = ((lcase(trim(arguments.sn_Suministro_Nuevo)) EQ "true") OR (trim(arguments.sn_Suministro_Nuevo) EQ "1") ? 1 : 0)>
              </cfif>

              <cfset var qAntes   = "" >
              <cfset var qCorreos = "" >
              <cfset var qPuesto  = "" >
              <cfset var mail     = "" >
              <cfset var correo   = structNew() >
              <cfset var rbrMail  = "" >
              <cfset var fhMov    = DateFormat(Now(),"dd/mm/yyyy") & " " & TimeFormat(Now(),"hh:mm tt")>

                <cfif arguments.esEdicion EQ true>

                    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                              method="getByID"
                              id_Empresa="#session.ID_EMPRESA#"
                              id_Proveedor="#arguments.id_Proveedor#"
                              returnvariable="qAntes"/>

                    <cfif isQuery(qAntes) AND qAntes.recordCount GT 0 AND listFindNoCase(qAntes.columnList,"sn_ProveedorCombustible")>
                        <cfset result.antes = val( queryGetCell(qAntes,"sn_ProveedorCombustible",1) )>
                    <cfelse>
                        <cfreturn result>
                    </cfif>

                    <cfif (result.antes EQ 0 AND result.nuevo EQ 1)>
                        <cfset result.debeNotificar = true>
                        <cfset result.tipoCambio = "0_a_1">
                        <cfset result.asunto = "Proveedor cambiado a tipo Suministro">

                    <cfelseif (result.antes EQ 1 AND result.nuevo EQ 0)>
                        <cfset result.debeNotificar = true>
                        <cfset result.tipoCambio = "1_a_0">
                        <cfset result.asunto = "Proveedor dejó de ser tipo Suministro">
                    </cfif>

                <cfelse>
                    <cfif result.nuevo EQ 1>
                        <cfset result.debeNotificar = true>
                        <cfset result.tipoCambio = "alta">
                        <cfset result.asunto = "Proveedor tipo Suministro (Alta)">
                    </cfif>
                </cfif>


              <cfif NOT result.debeNotificar>
                  <cfreturn result>
              </cfif>

<cfset result.puesto_usuario = "">

<cftry>
    <cfinvoke component="#Application.RF.getPath('dao','Usuario')#"
              method="upL_PuestoByidUsuario"
              id_Usuario="#val(session.ID_USUARIO)#"
              returnvariable="qPuesto"/>

    <cfif isQuery(qPuesto) AND qPuesto.recordCount GT 0 AND listFindNoCase(qPuesto.columnList,"nb_Puesto")>
        <cfset result.puesto_usuario = trim(queryGetCell(qPuesto, "nb_Puesto", 1))>
    </cfif>

    <cfcatch>
        <cfset result.puesto_usuario = "">
        <cflog file="notificaciones_proveedores"
               type="error"
               text="ERROR PUESTO (by usuario): idUsuario=#session.ID_USUARIO# msg=[#cfcatch.message#] detail=[#cfcatch.detail#]">
    </cfcatch>
</cftry>

<cfif NOT len(result.puesto_usuario) AND structKeyExists(session,"ID_EMPLEADO") AND val(session.ID_EMPLEADO) GT 0>
    <cftry>
        <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                  method="listar"
                  id_Empleado="#val(session.ID_EMPLEADO)#"
                  returnvariable="qEmp"/>

        <cfif isQuery(qEmp) AND qEmp.recordCount GT 0>
            <cfif listFindNoCase(qEmp.columnList,"nb_Puesto")>
                <cfset result.puesto_usuario = trim(queryGetCell(qEmp,"nb_Puesto",1))>
            <cfelseif listFindNoCase(qEmp.columnList,"NB_PUESTO")>
                <cfset result.puesto_usuario = trim(queryGetCell(qEmp,"NB_PUESTO",1))>
            </cfif>
        </cfif>

        <cfcatch>
            <cflog file="notificaciones_proveedores"
                   type="error"
                   text="ERROR PUESTO (fallback empleado): idEmpleado=#session.ID_EMPLEADO# msg=[#cfcatch.message#] detail=[#cfcatch.detail#]">
        </cfcatch>
    </cftry>
</cfif>


              <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="upL_CorreosNotificacionProveedorSuministro"
                        returnvariable="qCorreos"/>

              <cfif isQuery(qCorreos) AND qCorreos.recordCount GT 0 AND structKeyExists(qCorreos, "de_valor")>
                  <cfset result.correos_raw = qCorreos.de_valor>
              </cfif>

              <cfif len(trim(result.correos_raw))>
                  <cfloop list="#result.correos_raw#" delimiters="," index="mail">
                      <cfset mail = trim(mail)>
                      <cfif len(mail) AND find("@", mail)>
                          <cfset arrayAppend(result.destinatarios, mail)>
                      </cfif>
                  </cfloop>
              </cfif>

              <cfif arrayLen(result.destinatarios) EQ 0>
                  <cfreturn result>
              </cfif>

              <cfset correo.destinatarios = result.destinatarios>
              <cfset correo.asunto = result.asunto>
              <cfset correo.sn_plantilla = "true">
              <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailProveedorSuministro.html">

              <cfset correo.parametros = structNew()>
              <cfset correo.parametros.asunto = result.asunto>
              <cfset correo.parametros.id_Proveedor = arguments.id_Proveedor>
              <cfset correo.parametros.nb_Proveedor = arguments.nb_Proveedor>
              <cfset correo.parametros.de_RFC = arguments.de_RFC>
              <cfset correo.parametros.fh_Movimiento = fhMov>

              <cfset correo.parametros.id_Usuario = session.ID_USUARIO>
              <cfset correo.parametros.nb_Usuario = session.NB_EMPLEADOCOMPLETO>
              <cfset correo.parametros.nb_PuestoUsuario = result.puesto_usuario>

              <cfif result.tipoCambio EQ "alta">
                  <cfset correo.parametros.de_mensaje =
                      "Se registró un <b>nuevo proveedor</b> y fue <b>agregado como Suministro</b> en el sistema."
                      & "<br><br>"
                      & "Favor de validar la información registrada y continuar con los procesos administrativos correspondientes.">
                  <cfset correo.parametros.sn_nuevo = result.nuevo>

              <cfelseif result.tipoCambio EQ "0_a_1">
                  <cfset correo.parametros.de_mensaje =
                      "Se detectó una <b>modificación</b> en la clasificación del proveedor."
                      & "<br><br>"
                      & "El proveedor fue actualizado de <b>No Suministro</b> a <b>Suministro</b>."
                      & "<br><br>"
                      & "Favor de validar la información y proceder conforme a los lineamientos establecidos.">
                  <cfset correo.parametros.sn_antes = result.antes>
                  <cfset correo.parametros.sn_nuevo = result.nuevo>

              <cfelseif result.tipoCambio EQ "1_a_0">
                  <cfset correo.parametros.de_mensaje =
                      "Se detectó una <b>modificación</b> en la clasificación del proveedor."
                      & "<br><br>"
                      & "El proveedor fue actualizado de <b>Suministro</b> a <b>No Suministro</b>."
                      & "<br><br>"
                      & "Favor de revisar este cambio para asegurar la correcta continuidad de los procesos operativos.">
                  <cfset correo.parametros.sn_antes = result.antes>
                  <cfset correo.parametros.sn_nuevo = result.nuevo>
              </cfif>

              <cfset correo.imagenes = [
                  { dir="#session.AR_IMAGENREPORTE#", disposicion="inline", name="logo" },
                  { dir="../../assets/img/greenLeaf.jpg", disposicion="inline", name="footer" }
              ]>

              <cfset result.envio_intentado = true>

              <cftry>
                  <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            argumentcollection="#correo#"
                            returnvariable="rbrMail"/>

                  <cfif isDefined("rbrMail") AND isObject(rbrMail) AND structKeyExists(rbrMail, "hasError")>
                      <cfif rbrMail.hasError()>
                          <cfset result.envio_ok = false>
                          <cfset result.error_envio = rbrMail.getMessage()>
                      <cfelse>
                          <cfset result.envio_ok = true>
                      </cfif>
                  <cfelse>
                      <cfset result.envio_ok = true>
                  </cfif>

                  <cfcatch>
                      <cfset result.envio_ok = false>
                      <cfset result.error_envio = cfcatch.message & " | " & cfcatch.detail>
                  </cfcatch>
              </cftry>

              <cfif NOT result.envio_ok>
                  <cflog file="notificaciones_proveedores"
                        type="error"
                        text="Correo suministro NO enviado. id_Proveedor=#arguments.id_Proveedor# tipo=#result.tipoCambio# antes=#result.antes# nuevo=#result.nuevo# usuario=#session.ID_USUARIO# puesto=[#result.puesto_usuario#] correos_raw=[#result.correos_raw#] error=[#result.error_envio#]">
              <cfelse>
                  <cflog file="notificaciones_proveedores"
                        type="information"
                        text="Correo suministro ENVIADO. id_Proveedor=#arguments.id_Proveedor# tipo=#result.tipoCambio# antes=#result.antes# nuevo=#result.nuevo# usuario=#session.ID_USUARIO# puesto=[#result.puesto_usuario#] destinatarios=#serializeJSON(result.destinatarios)#">
              </cfif>

              <cfreturn result>
          </cffunction>






    <cffunction name="agregar" access="public" returntype="Any">
        <cfargument name="id_Empresa"                        type="numeric"required="true"/>
        <cfargument name="nb_Proveedor"                      type="string" required="true"/>
        <!--- <cfargument name="de_Email"                    type="string" required="false"/> --->
        <cfargument name="de_RazonSocial"                    type="string" required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric"required="false"/>
        <cfargument name="de_RFC"                            type="string" required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric"required="false"/>
        <!---       <cfargument name="de_Direccion"                  type="string" required="false"/> --->
        <cfargument name="id_TipoProveedor"                  type="numeric"required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string" required="false"/>
        <!--- <cfargument name="nb_Contacto"                 type="string" required="false"/> --->
        <cfargument name="nu_CuentaBancaria"                 type="string" required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string" required="false"/>
        <cfargument name="sn_borrado"                        type="string" required="false"/>
        <cfargument name="Contactos"                         type="array"  required="true"/>
        <cfargument name="referencia"                        type="string" required="false"/>
        <cfargument name="sn_Extranjero"                     type="string" required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string" required="false"/>
        <!--- Direccion --->
        <cfargument name="sn_Transporte"                     type="string" required="false"/>
        <cfargument name="sn_Grupo"                          type="string" required="false"/>
        <cfargument name="sn_Suministro"                     type="string" required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string" required="false"/>
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
        <cfargument name="sn_AccesoSistema"                  type="boolean"required="false" />
        <cfargument name="ProveedoresUsuarios"               type="array"  required="false" />
        <cfargument name="TiposComprobantes"                 type="array"  required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string" required="false"/>
        <cfargument name="nu_PermisoCRETransporte"           type="string" required="false"/>
        <cfargument name="nu_PermisoCRECombustible"          type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string" required="false"/>
        <cfargument name="Cuentas"                           type="array"  required="true"/>
        <cfargument name="sn_ProveedorCompra"                type="string" required="false"/>
        <cfargument name="adjuntarArchivo"                   type="file"   required="false"/>
        <cfargument name="sn_RegimenConfianza"               type="string" required="false"/>
        <cfargument name="nb_Empleado"                       type="string" required="false"/>
        <cfargument name="fh_Registro"                       type="string" required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string" required="false"/>
        <cfargument name="sn_ConsultaPortalCRE"              type="string" required="false"/>
        <cfargument name="sn_ProveedorGasLP"                 type="string" required="false"/>
        <cfargument name="ConceptosServicios"                type="array"  required="false"/>
        <cfargument name="sn_rdioCMF"                        type="string" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Prorrateable"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>

            <cfif NOT variables.RBR.hasError()>
                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="existeProveedor"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Proveedor="0"
                    nb_Proveedor="#Arguments.nb_Proveedor#"
                    returnvariable="Local.exist">

                        <cfif NOT Local.exist>

                            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                method="upR_Proveedores_snReferencia"
                                id_Empresa="#arguments.id_Empresa#"
                                id_Proveedor="0"
                                referencia="#arguments.referencia#"
                                returnvariable="sn_Repetido">


                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                method="upR_snDe_AliasProveedor"
                                id_Empresa="#arguments.id_Empresa#"
                                id_Proveedor="0"
                                de_AliasProveedor="#de_aliasproveedor#"
                                returnvariable="n">

                                <cfif #n.N# NEQ '0'>
                                    <cfset variables.RBR.setError('El alias ya existe.')>
                                    <cfreturn variables.RBR>
                                </cfif>

                                <cfif #sn_Repetido# EQ '0' OR #referencia# EQ ''>
                                    <!--- <cfcontent type="text/html">
                                    <cfdump var="#sn_Repetido#" label="arguments" abort="true"> --->
                                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                                          method="nextID"
                                          id_Empresa = "#session.ID_EMPRESA#"
                                          returnvariable="Local.id_Proveedor">

                                          <cfset Est = StructNew()>
                                          <cfset Est.id = #Local.id_Proveedor#>

                                          <cfset variables.RBR.setData(Est)>

                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                            method="agregar"
                                            id_Proveedor="#Local.id_Proveedor#"
                                            argumentcollection="#arguments#">

                                    <cfif #sn_Extranjero# EQ '0'>
                                        <cfif isDefined("de_RFC") AND #de_RFC# NEQ ''>
                                            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                                method="sn_RFCRepetido"
                                                id_Proveedor="#Local.id_Proveedor#"
                                                RFC="#de_RFC#"
                                                returnvariable="sn_Repetido">

                                            <cfif #sn_Repetido# EQ '1'>
                                                    <cfset variables.RBR.setError('El RFC ya está dado de alta.')>
                                                    <cfreturn variables.RBR>
                                            </cfif>
                                        </cfif>

                                    </cfif>


                                    <cfloop from="1" to="#arrayLen(arguments.Contactos)#" index="local.j">
                                            <cfset local.DatosProveedorContacto = structNew()>

                                            <cfset local.DatosProveedorContacto.id_Empresa = arguments.id_Empresa>
                                            <cfset local.DatosProveedorContacto.id_Proveedor = local.id_Proveedor>
                                            <cfset local.DatosProveedorContacto.nb_ProveedorContacto = arguments.Contactos[local.j].nb_ProveedorContacto>
                                            <cfset local.DatosProveedorContacto.de_Email = arguments.Contactos[local.j].de_Email>

                                            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                                        method="nextIDProveedorContacto"
                                                        id_Empresa="#arguments.id_Empresa#"
                                                        id_Proveedor ="#local.id_Proveedor#"
                                                        returnvariable="Local.id_ProveedorContacto">

                                            <cfset local.DatosProveedorContacto.id_ProveedorContacto = local.id_ProveedorContacto>

                                            <!--- <cfdump var="#local.DatosProveedorContacto#"><cfabort> --->

                                            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                                        method="agregarProveedorContacto"
                                                        argumentcollection="#Local.DatosProveedorContacto#">

                                    </cfloop>

                                    <cfloop array="#arguments.ProveedorPermisoCRE#" index="PermisoCRE">
                                            <cfset DatosProveedorPermiso = structNew()>
                                            <cfset DatosProveedorPermiso.id_Proveedor             = local.id_Proveedor>
                                            <cfset DatosProveedorPermiso.nu_PermisoCRE            = PermisoCRE.nu_PermisoCRE>
                                            <cfset DatosProveedorPermiso.id_TipoPermisoCRE        = PermisoCRE.id_TipoPermisoCRE>

                                            <cfif StructKeyExists(PermisoCRE, "id_DireccionRetiro" ) and isnumeric(PermisoCRE.id_DireccionRetiro)>
                                            <cfset DatosProveedorPermiso.id_DireccionRetiro       = PermisoCRE.id_DireccionRetiro>
                                            </cfif>
                                            <cfif StructKeyExists(PermisoCRE, "id_Plaza" ) and isnumeric(PermisoCRE.id_Plaza)>
                                            <cfset DatosProveedorPermiso.id_Plaza                 = PermisoCRE.id_Plaza>
                                            </cfif>
                                            <cfif PermisoCRE.sn_Default>
                                                    <cfset DatosProveedorPermiso.sn_Default               = 1>
                                                <cfelse>
                                                    <cfset DatosProveedorPermiso.sn_Default               = 0>
                                            </cfif>

                                            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                                                      method="ProveedorPermisoCreNextID"
                                                      id_Proveedor = "#Local.id_Proveedor#"
                                                      returnvariable="Local.id_ProveedorPermiso">

                                             <cfset DatosProveedorPermiso.id_ProveedorPermiso   = local.id_ProveedorPermiso>

                                            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                                        method="agregarProveedorPermisoCRE"
                                                        argumentcollection="#DatosProveedorPermiso#">

                                    </cfloop>

                                    <cfif isDefined("arguments.sn_AccesoSistema") AND arguments.sn_AccesoSistema>
                                        <cfloop index="i" from="1" to="#arrayLen(arguments.ProveedoresUsuarios)#">
                                            <cfinvoke   component="#Application.RF.getPath('dao','Usuario')#"
                                                        method="AgregarProveedorUsuario"
                                                        id_Empresa="#session.ID_EMPRESA#"
                                                        id_Proveedor="#Local.id_Proveedor#"
                                                        id_Usuario="#ProveedoresUsuarios[i].id_Usuario#"
                                                        id_UsuarioRegistro="#session.ID_USUARIO#">
                                        </cfloop>
                                    </cfif>

                                    <!---<cfif isDefined("arguments.Cuentas") AND #arrayLen(arguments.Cuentas)#>
                                        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                                                    method="resetCuentasContables">

                                        <cfloop array="#arguments.Cuentas#" index="item">
                                            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                                                    method="AgregarCuentasContables"
                                                    id_Proveedor="#Local.ID_PROVEEDOR#"
                                                    id_CuentaBancaria="#item.ID_CUENTABANCARIA#"
                                                    id_TipoTransferencia ="#item.ID_TIPOTRANSFERENCIA#"
                                                    nb_ClaveProveedor ="#item.NB_CLAVEPROVEEDOR#"
                                                    nb_CuentaBancaria="#item.NB_CUENTABANCARIA#"
                                                    nu_CuentaBancaria="#item.NU_CUENTABANCARIA#"
                                                    nu_ClabeInterbancaria="#item.NU_CLABEINTERBANCARIA#"
                                                    id_Banco="#item.ID_BANCO#"
                                                    id_Moneda="#item.ID_MONEDA#">
                                        </cfloop>
                                    </cfif>--->


                                    <cfif isDefined("arguments.TiposComprobantes") AND #arrayLen(arguments.TiposComprobantes)#>
                                        <cfloop array="#arguments.TiposComprobantes#" index="item">
                                            <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                                    method="AgregarProveedoresTiposComprobantes"
                                                    id_Proveedor="#Local.ID_PROVEEDOR#"
                                                    id_TipoComprobante="#item.id_TipoComprobante#">
                                        </cfloop>
                                    </cfif>

                                    <cfif isDefined("arguments.ConceptosServicios") AND #arrayLen(arguments.ConceptosServicios)#>
                                        <cfloop array="#arguments.ConceptosServicios#" index="item">
                                <!--- <cfcontent type="text/html">
                                <cfdump var="#item#" format="simple" label="arguments" abort="true"> --->
                                            <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                                    method="AgregarProveedoresInsumosServicios"
                                                    id_Proveedor="#Local.ID_PROVEEDOR#"
                                                    id_Insumo="#item.ID_INSUMO#">
                                        </cfloop>
                                    </cfif>

                                    <!--- Enviar correo de notificacion a para cambios en proveedores tipo suministro --->

                                      <cfinvoke method="notificarCambioProveedorSuministro"
                                            id_Proveedor="#Local.id_Proveedor#"
                                            sn_Suministro_Nuevo="#arguments.sn_Suministro#"
                                            esEdicion="false"
                                            nb_Proveedor="#arguments.nb_Proveedor#"
                                            de_RFC="#arguments.de_RFC#"
                                            returnvariable="Local.notifSuministroAlta" />





                                    <!--- Enviar correo de notificacion a tesoreria --->
                                    <cfset correo = structNew()>
                                    <cfset correo.destinatarios = arrayNew(1)>
                                    <cfinvoke component="#Application.RF.getPath('dao','configuracionnotificaciones')#"
                                              method="leer_ConfiguracionNotificacionesEmpleados"
                                              id_Empresa="#session.ID_EMPRESA#"
                                              id_Notificacion="7"
                                              returnvariable="rs.EmpleadosTesoreria">
                                    <cfloop query="rs.EmpleadosTesoreria">
                                        <cfif arguments.sn_Transporte && rs.EmpleadosTesoreria.id_Empleado EQ 6096><!--- Transporte a katherine de C&E  --->
                                            <cfset arrayAppend(correo.destinatarios, rs.EmpleadosTesoreria.de_Email)>
                                        </cfif>
                                        <cfif arguments.sn_Suministro && rs.EmpleadosTesoreria.id_Empleado EQ 111> <!--- Suministro a guadalupe valle --->
                                            <cfset arrayAppend(correo.destinatarios, rs.EmpleadosTesoreria.de_Email)>
                                        </cfif>
                                        <cfif rs.EmpleadosTesoreria.id_Empleado NEQ 6096 && rs.EmpleadosTesoreria.id_Empleado NEQ 111>
                                            <cfset arrayAppend(correo.destinatarios, rs.EmpleadosTesoreria.de_Email)>
                                        </cfif>
                                    </cfloop>

                                    <cfset correo.asunto = 'Nuevo proveedor agregado'>
                                    <cfset correo.sn_plantilla = "true">
                                    <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailNuevoProveedor.html">
                                    <cfset correo.parametros = structNew()>
                                    <cfset correo.parametros.asunto = 'Nuevo proveedor agregado.'>
                                    <cfset correo.parametros.de_mensaje = 'Se agrego un nuevo proveedor.'>
                                    <cfset correo.parametros.nb_Proveedor = arguments.nb_Proveedor>
                                    <cfset correo.parametros.de_RFC = arguments.de_RFC>

                                    <cfset correo.imagenes=[
                                        {
                                            dir="#session.AR_IMAGENREPORTE#",
                                            disposicion='inline',
                                            name="logo"
                                        },
                                        {
                                            <!--- dir="assets/img/greenLeaf.jpg", se corrige la ruta  --->
                                            dir="../../assets/img/greenLeaf.jpg",
                                            disposicion='inline',
                                            name="footer"
                                        }
                                    ]>
                                    <cfif arrayLen(correo.destinatarios) GT 0>
                                        <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                                  method="sendMail"
                                                  argumentcollection="#correo#"
                                                  returnvariable="Local.rbr"/>

                                        <cfif Local.rbr.hasError()>
                                            <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                                        <cfelse>
                                            <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n a quien corresponde. Operaci&oacute;n exitosa. ")>
                                        </cfif>
                                    <cfelse>
                                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                                    </cfif>
                                    <!--- CORREO PARA VALIDAR SI SE REGISTRO UN NUMERO DE PERMISO CRE CORRECTO --->
                                    <cfset correo = structNew()>
                                    <cfset correo.destinatarios = arrayNew(1)>

                                    <cfinvoke component="#Application.RF.getPath('dao','configuracionnotificaciones')#"
                                                method="leer_ConfiguracionNotificacionesEmpleados"
                                                id_Empresa="#session.ID_EMPRESA#"
                                                id_Sucursal="#SESSION.ID_SUCURSAL#"
                                                id_Notificacion="59"
                                                returnvariable="EmpleadosNotificacion">

                                    <cfloop query="EmpleadosNotificacion">
                                        <cfset arrayAppend(correo.destinatarios, EmpleadosNotificacion.de_Email)>
                                    </cfloop>

                                    <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                                    method="listar"
                                    id_Empleado="#SESSION.ID_EMPLEADO#"
                                    returnvariable="Local.empleado"/>

                                    <cfset correo.asunto = '¡Se ha registrado un proveedor con número de permiso CRE!'>
                                    <cfset correo.sn_plantilla = "true">
                                    <cfset correo.dir_plantilla = "templates/correos/notificaciones/not_validacionPermisoCRE.html">
                                    <cfset correo.parametros = structNew()>
                                    <cfset correo.parametros.fh_Movimiento = DateFormat(Now(), "dd/mm/yyyy") & '' & TimeFormat(now(),' hh:mm tt')>
                                    <cfset correo.parametros.nb_Empleado = "#Local.empleado.nb_Empleado#">
                                    <cfset correo.parametros.nb_Departamento = '#Local.empleado.nb_Departamento#'>
                                    <cfset correo.parametros.de_RazonSocial = '#arguments.nb_Proveedor#'>
                                    <cfset correo.parametros.sn_ConsultaPortalCRE = '#arguments.sn_ConsultaPortalCRE#'>
                                    <cfset correo.parametros.body_text = '¡Hola! Se detectó una alta de un proveedor en el sistema SIPP en el cual fue agregado junto con un número de permiso CRE con la siguiente información:'>
                                    <cfif #arguments.sn_Transporte# && isDefined("arguments.sn_ConsultaPortalCRET")>
                                        <cfif #arguments.sn_ConsultaPortalCRET#>
                                            <cfset correo.parametros.de_Observaciones = 'Registro Público de la CRE'>
                                        <cfelse>
                                            <cfset correo.parametros.de_Observaciones = 'Ingresado manualmente'>
                                        </cfif>
                                        <cfset correo.parametros.sn_ConsultaPortalCRE = #arguments.sn_ConsultaPortalCRET#>
                                        <cfset correo.parametros.nb_TipoClienteCRE = 'Transportistas'>
                                        <cfset correo.parametros.de_PermisoCRE = #arguments.nu_PermisoCRETransporte#>
                                        <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                                method="sendMail"
                                                argumentcollection="#correo#">
                                    </cfif>

                                    <cfif #arguments.sn_Suministro# && isDefined("arguments.sn_ConsultaPortalCREC")>
                                        <cfif #arguments.sn_ConsultaPortalCREC#>
                                            <cfset correo.parametros.de_Observaciones = 'Registro Público de la CRE'>
                                        <cfelse>
                                            <cfset correo.parametros.de_Observaciones = 'Ingresado manualmente'>
                                        </cfif>
                                        <cfset correo.parametros.sn_ConsultaPortalCRE = #arguments.sn_ConsultaPortalCREC#>
                                        <cfset correo.parametros.nb_TipoClienteCRE = 'Combustibles'>
                                        <cfset correo.parametros.de_PermisoCRE = #arguments.nu_PermisoCRECombustible#>
                                        <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                                method="sendMail"
                                                argumentcollection="#correo#">
                                    </cfif>
                                    <!--- CORREO PARA GUADALUPE VALLE --->
                                    <cfif #sn_Transporte# EQ 1>
                                      	<cfif Arguments.nu_DiasRegistroComprasCombustible EQ 0 OR Arguments.nu_DiasRegistroComprasCombustible  EQ nullValue()>
                                            <cfset Arguments.nu_DiasRegistroComprasCombustible = 3>
                                        </cfif>
                                    </cfif>
                                      <cfif Arguments.nu_DiasCredito EQ 0 OR Arguments.nu_DiasCredito  EQ nullValue()>
                                          <cfset Arguments.nu_DiasCredito = 0>
                                      </cfif>
                                      <cfif Arguments.de_RFC EQ ''>
                                        <cfset Arguments.de_RFC = '-'>
                                    </cfif>
                                        <cfset correo = structNew()>
                                        <cfset correo.destinatarios = arrayNew(1)>

                                        <cfinvoke component="#Application.RF.getPath('dao','configuracionnotificaciones')#"
                                                  method="leer_ConfiguracionNotificacionesEmpleados"
                                                  id_Empresa="#session.ID_EMPRESA#"
                                                  id_Notificacion="52"
                                                  returnvariable="rs.EmpleadosTesoreria">
                                        <cfloop query="rs.EmpleadosTesoreria">
                                            <cfset arrayAppend(correo.destinatarios, rs.EmpleadosTesoreria.de_Email)>
                                        </cfloop>

                                        <!--- <cfset correo.destinatarios = ['gvalle@petroil.com.mx']> --->
                                        <cfset correo.asunto = 'Se ha Registrado el alta de un Proveedor  Transportista '>
                                        <cfset correo.sn_plantilla = "true">
                                        <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailNuevoProveedorTransportista.html">
                                        <cfset correo.parametros = structNew()>
                                        <cfset correo.parametros.asunto = 'Nuevo Proveedor Transportista Agregado.'>
                                        <cfset correo.parametros.de_mensaje = 'Se agrego un nuevo proveedor transportista.'>
                                        <cfset correo.parametros.nb_Proveedor = arguments.nb_Proveedor>
                                        <cfset correo.parametros.de_RFC = arguments.de_RFC>
                                        <cfset correo.parametros.nu_DiasCredito = arguments.nu_DiasCredito>
                                        <cfset correo.parametros.nu_DiasRegistroComprasCombustible = arguments.nu_DiasRegistroComprasCombustible>
                                        <cfset correo.parametros.nb_Empleado = arguments.nb_Empleado>
                                        <cfset correo.parametros.fh_Registro = arguments.fh_Registro>

                                        <cfset correo.imagenes=[
                                            {
                                                dir="#session.AR_IMAGENREPORTE#",
                                                disposicion='inline',
                                                name="logo"
                                            },
                                            {
                                                dir="../../assets/img/greenLeaf.jpg",
                                                disposicion='inline',
                                                name="footer"
                                            }
                                        ]>
                                        <cfif arrayLen(correo.destinatarios) GT 0>
                                            <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                                        method="sendMail"
                                                        argumentcollection="#correo#"
                                                        returnvariable="Local.rbr"/>

                                            <cfif Local.rbr.hasError()>
                                                <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                                            <cfelse>
                                                <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n a tesoreria. Operaci&oacute;n exitosa. ")>
                                            </cfif>
                                        <cfelse>
                                            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                                        </cfif>
                                    <cfelse>
                                        <cfset variables.RBR.setError('La referencia contable ya existe, favor de insertar otra distinta.')>
                            </cfif>
                        <cfelse>
                                <cfset variables.RBR.setError('El Proveedor ya está registrado.')>
                        </cfif>
                    </cfif>

            <cfreturn variables.RBR>
     </cffunction>

    <cffunction name="editar"access="public" returntype="Any">

        <cfargument name="id_Empresa"                        type="numeric"required="true"/>
        <cfargument name="id_Proveedor"                      type="numeric"required="true"/>
        <cfargument name="nb_Proveedor"                      type="string" required="true"/>
        <!--- <cfargument name="de_Email"                   type="string" required="false"/> --->
        <cfargument name="de_RazonSocial"                    type="string" required="false"/>
        <cfargument name="im_LimiteCredito"                  type="numeric"required="false"/>
        <cfargument name="de_RFC"                            type="string" required="false"/>
        <cfargument name="nu_DiasCredito"                    type="numeric"required="false"/>
        <cfargument name="de_Direccion"                      type="string" required="false"/>
        <cfargument name="id_TipoProveedor"                  type="numeric"required="true"/>
        <cfargument name="id_GrupoProveedor"                 type="string" required="false"/>
        <cfargument name="nu_CodigoPostal"                   type="string" required="false"/>
        <cfargument name="nb_Banco"                          type="string" required="false"/>
        <cfargument name="de_aliasproveedor"                 type="string" required="false"/>
        <!--- <cfargument name="nb_Contacto"                    type="string" required="false"/> --->
        <cfargument name="sn_Transporte"                     type="string"  required="false"/>
        <cfargument name="nu_CuentaBancaria"                 type="string" required="false"/>
        <cfargument name="nu_Telefono"                       type="string" required="false"/>
        <cfargument name="nu_ClabeInterbancaria"             type="string" required="false"/>
        <cfargument name="nu_Fax"                            type="string" required="false"/>
        <cfargument name="sn_borrado"                        type="string" required="false"/>
        <cfargument name="Contactos"                         type="array"  required="true"/>
        <cfargument name="ContactosEliminar"                 type="array"  required="false"/>
        <cfargument name="referencia"                        type="string" required="false"/>
        <cfargument name="sn_Extranjero"                     type="string" required="false"/>
        <cfargument name="sn_AccesoSistema"                  type="boolean"required="false" />
        <cfargument name="ProveedoresUsuarios"               type="array"  required="false" />
        <cfargument name="ProveedoresUsuariosEliminado"      type="array"  required="false" />
        <cfargument name="TiposComprobantes"                 type="array"  required="false"/>
        <cfargument name="sn_Grupo"                          type="string" required="false"/>
        <cfargument name="sn_Suministro"                     type="string" required="false"/>
        <cfargument name="sn_Ambientaltek"                   type="string" required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible" type="string" required="false"/>
		<cfargument name="nu_PermisoCRETransporte"		     type="string" required="false"/>
		<cfargument name="nu_PermisoCRECombustible"          type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"       type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"               type="string" required="false"/>
        <cfargument name="sn_ProveedorCompra"                type="string" required="false"/>
        <cfargument name="Cuentas"                           type="array"  required="false"/>
        <cfargument name="sn_RegimenConfianza"               type="string" required="false"/>
        <cfargument name="sn_TallerMecanico"                 type="string" required="false"/>
        <cfargument name="sn_ProveedorGasLP"                 type="string" required="false"/>
        <cfargument name="ConceptosServicios"                type="array"  required="false"/>
        <cfargument name="sn_rdioCMF"                        type="string" required="false"/>
        <cfargument name="sn_NoGenerarPruebaCalidad"         type="string" required="false"/>
        <cfargument name="sn_TransportaDG"                   type="string" required="false"/>
        <cfargument name="sn_TransportaAL"                   type="string" required="false"/>
        <cfargument name="sn_Consignacion"                   type="string" required="false"/>
        <cfargument name="de_EmailProveedor"                 type="string" required="false"/>
        <cfargument name="id_EmpresaSILT"                    type="numeric"required="false"/>
        <cfargument name="sn_suspendido"                     type="string" required="false"/>
        <cfargument name="de_MotivoSuspension"                   type="string" required="false"/>
        <cfargument name="id_UsuarioSupendio"                 type="string" required="false"/>
        <cfargument name="fh_suspension"                     type="string" required="false"/>

        <cfif NOT variables.RBR.hasError()>

            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="existeProveedor"
                        id_Empresa="#arguments.id_Empresa#"
                        id_Proveedor="#Arguments.id_Proveedor#"
                        nb_Proveedor="#arguments.nb_Proveedor#"
                        returnvariable="Local.exist">

            <cfif NOT Local.exist>

                <!--- Se revisa que la referencia contable no se repita --->
                <!---  <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                    method="upR_Proveedores_snReferencia"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Proveedor="#Arguments.id_Proveedor#"
                    referencia="#arguments.referencia#"
                    returnvariable="sn_Repetido">

                    <cfif #sn_Repetido# EQ '0' OR #referencia# EQ ''> --->


                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="upR_snDe_AliasProveedor"
                        id_Empresa="#arguments.id_Empresa#"
                        id_Proveedor="#id_Proveedor#"
                        de_AliasProveedor="#de_aliasproveedor#"
                        returnvariable="n">

                <cfif #n.N# NEQ '0'>
                    <cfset variables.RBR.setError('El alias ya existe.')>
                    <cfreturn variables.RBR>
                </cfif>

                <cfset local.DatosEliminarContacto = structNew()>
                <cfset local.DatosEliminarContacto.id_Empresa = session.ID_EMPRESA>
                <cfset local.DatosEliminarContacto.id_Proveedor = arguments.id_Proveedor>

                <!--- <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                            method="CountContactosProveedor"
                            argumentcollection="#local.DatosEliminarContacto#"
                            returnvariable="local.NumerodeContactos">

                <cfloop     query="local.NumerodeContactos">
                    <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                method="eliminarProveedorContacto"
                                argumentcollection="#local.DatosEliminarContacto#">
                </cfloop> --->

                 <cfloop array="#arguments.ProveedorPermisoCRE#" index="PermisoCRE">
                        <cfset DatosProveedorPermiso = structNew()>
                        <cfset DatosProveedorPermiso.id_Proveedor             = arguments.id_Proveedor>
                        <cfset DatosProveedorPermiso.nu_PermisoCRE            = PermisoCRE.nu_PermisoCRE>
                        <cfset DatosProveedorPermiso.id_TipoPermisoCRE        = PermisoCRE.id_TipoPermisoCRE>
                        <cfif StructKeyExists(PermisoCRE, "id_DireccionRetiro" ) and isnumeric(PermisoCRE.id_DireccionRetiro)>
                            <cfset DatosProveedorPermiso.id_DireccionRetiro       = PermisoCRE.id_DireccionRetiro>
                        </cfif>
                        <cfif StructKeyExists(PermisoCRE, "id_Plaza" ) and isnumeric(PermisoCRE.id_Plaza)>
                            <cfset DatosProveedorPermiso.id_Plaza                 = PermisoCRE.id_Plaza>
                        </cfif>
                        <cfif PermisoCRE.sn_Default>
                            <cfset DatosProveedorPermiso.sn_Default               = 1>
                        <cfelse>
                            <cfset DatosProveedorPermiso.sn_Default               = 0>
                        </cfif>
                          <cfif StructKeyExists(PermisoCRE, "id_ProveedorPermiso" ) and isnumeric(PermisoCRE.id_ProveedorPermiso)>
                            <cfset DatosProveedorPermiso.id_ProveedorPermiso                 = PermisoCRE.id_ProveedorPermiso>
                        </cfif>
                        <cfif StructKeyExists(PermisoCRE, "id_ProveedorPermiso" ) and PermisoCRE.id_ProveedorPermiso EQ ''>
                            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                                        method="ProveedorPermisoCreNextID"
                                        id_Proveedor = "#arguments.id_Proveedor#"
                                        returnvariable="Local.id_ProveedorPermiso">

                                <cfset DatosProveedorPermiso.id_ProveedorPermiso      = Local.id_ProveedorPermiso>
                        </cfif>

                        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                    method="agregarProveedorPermisoCRE"
                                    argumentcollection="#DatosProveedorPermiso#">
                </cfloop>

                <cfloop from="1" to="#arrayLen(arguments.Contactos)#" index="local.j">
                    <cfset local.DatosProveedorContacto = structNew()>

                    <cfset local.DatosProveedorContacto.id_Empresa = arguments.id_Empresa>
                    <cfset local.DatosProveedorContacto.id_Proveedor = arguments.id_Proveedor>

                    <cfif arguments.Contactos[local.j].id_Proveedor EQ ''>
                        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                                    method="nextIDProveedorContacto"
                                    id_Empresa="#arguments.id_Empresa#"
                                    id_Proveedor ="#arguments.id_Proveedor#"
                                    returnvariable="Local.id_ProveedorContacto">

                        <cfset local.DatosProveedorContacto.id_ProveedorContacto = local.id_ProveedorContacto>
                        <cfset local.DatosProveedorContacto.nb_ProveedorContacto = arguments.Contactos[local.j].nb_ProveedorContacto>
                        <cfset local.DatosProveedorContacto.de_Email = arguments.Contactos[local.j].de_Email>

                        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                    method="agregarProveedorContacto"
                                    argumentcollection="#Local.DatosProveedorContacto#">


                    <cfelse>
                        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                    method="getProveedor"
                                    id_Empresa="#arguments.id_Empresa#"
                                    id_Proveedor ="#arguments.id_Proveedor#"
                                    id_ProveedorContacto = "#arguments.Contactos[local.j].id_ProveedorContacto#"
                                    returnvariable="Local.Proveedor">

                        <cfif local.Proveedor.nb_ProveedorContacto NEQ arguments.Contactos[local.j].nb_ProveedorContacto OR local.Proveedor.de_Email NEQ arguments.Contactos[local.j].de_Email>
                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                            method="editarProveedorContactoEliminar"
                                            id_Empresa="#session.ID_EMPRESA#"
                                            id_Proveedor="#arguments.id_Proveedor#"
                                            id_ProveedorContacto ="#arguments.Contactos[local.j].id_ProveedorContacto#"
                                            >

                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                            method="nextIDProveedorContacto"
                                            id_Empresa="#arguments.id_Empresa#"
                                            id_Proveedor ="#arguments.id_Proveedor#"
                                            returnvariable="Local.id_ProveedorContacto">

                                <cfset local.DatosProveedorContacto.id_ProveedorContacto = local.id_ProveedorContacto>
                                <cfset local.DatosProveedorContacto.nb_ProveedorContacto = arguments.Contactos[local.j].nb_ProveedorContacto>
                                <cfset local.DatosProveedorContacto.de_Email = arguments.Contactos[local.j].de_Email>

                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                            method="agregarProveedorContacto"
                                            argumentcollection="#Local.DatosProveedorContacto#">

                            <cfelse>
                                <cfset local.DatosProveedorContacto.id_ProveedorContacto = arguments.Contactos[local.j].id_ProveedorContacto>
                                <cfset local.DatosProveedorContacto.nb_ProveedorContacto = arguments.Contactos[local.j].nb_ProveedorContacto>
                                <cfset local.DatosProveedorContacto.de_Email = arguments.Contactos[local.j].de_Email>


                                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                            method="editarProveedorContacto"
                                            argumentcollection="#Local.DatosProveedorContacto#">
                        </cfif>
                    </cfif>
                </cfloop>

                <cfloop array="#arguments.Cuentas#" index="item">
                    <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                        method="AgregarCuentasContables"
                        id_Proveedor            ="#arguments.ID_PROVEEDOR#"
                        id_CuentaBancaria       ="#item.ID_CUENTABANCARIA#"
                        nb_CuentaBancaria       ="#item.NB_CUENTABANCARIA#"
                        id_TipoTransferencia    ="#item.ID_TIPOTRANSFERENCIA#"
                        nb_ClaveProveedor       ="#item.NB_CLAVEPROVEEDOR#"
                        nu_ClabeInterbancaria   ="#item.NU_CLABEINTERBANCARIA#"
                        id_Banco                ="#item.ID_BANCO#"
                        id_Moneda               ="#item.ID_MONEDA#"
                        de_Concepto             ="#item.DE_CONCEPTO#"
                        returnvariable="local.rs">

                    <cfif item.keyExists("NB_DOCUMENTO")>
                        <cfif item.NB_DOCUMENTO.length() GT 0>
                            <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                                method="uploadFile_CuentasBancarias"
                                id_Banco="#item.ID_BANCO#"
                                nb_CuentaBancaria="#item.NB_CUENTABANCARIA#"
                                nu_ClabeInterbancaria="#item.NU_CLABEINTERBANCARIA#"
                                id_TipoTransferencia="#item.ID_TIPOTRANSFERENCIA#"
                                id_Moneda="#item.ID_MONEDA#"
                                id_Proveedor="#arguments.ID_PROVEEDOR#"
                                id_CuentaBancaria="#local.rs.id_CuentaBancaria#"
                                de_ruta="#item.DE_RUTA#"
                                nb_Documento="#item.NB_DOCUMENTO#">
                        </cfif>
                    </cfif>
                </cfloop>

                <cfloop from="1" to="#arrayLen(arguments.ContactosEliminar)#" index="local.i">
                    <cfif arguments.ContactosEliminar[local.i].id_ContactoProveedor NEQ ''>
                        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                    method="editarProveedorContactoEliminar"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    id_Proveedor="#arguments.id_Proveedor#"
                                    id_ProveedorContacto ="#arguments.ContactosEliminar[local.i].id_ContactoProveedor#"
                                    >
                    </cfif>
                </cfloop>


                <cfif #sn_Extranjero# EQ '0'>
                    <cfif isDefined("de_RFC") AND #de_RFC# NEQ ''>
                        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                            method="sn_RFCRepetido"
                            id_Proveedor="#arguments.id_Proveedor#"
                            RFC="#de_RFC#"
                            returnvariable="sn_Repetido">

                        <cfif #sn_Repetido# EQ '1'>
                                <cfset variables.RBR.setError('El RFC ya esta dado de alta.')>
                                <cfreturn variables.RBR>
                        </cfif>
                    </cfif>
                </cfif>


                <cfif isDefined("arguments.sn_AccesoSistema") AND arguments.sn_AccesoSistema>

                    <cfloop index="i" from="1" to="#arrayLen(arguments.ProveedoresUsuariosEliminado)#">
                        <cfinvoke   component="#Application.RF.getPath('dao','Usuario')#"
                                    method="EliminarProveedorUsuario"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    id_Proveedor="#arguments.id_Proveedor#"
                                    id_Usuario="#ProveedoresUsuariosEliminado[i].id_Usuario#"
                                    id_UsuarioElimino="#session.ID_USUARIO#">
                    </cfloop>

                    <cfloop index="i" from="1" to="#arrayLen(arguments.ProveedoresUsuarios)#">
                        <cfinvoke   component="#Application.RF.getPath('dao','Usuario')#"
                                    method="AgregarProveedorUsuario"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    id_Proveedor="#arguments.id_Proveedor#"
                                    id_Usuario="#ProveedoresUsuarios[i].id_Usuario#"
                                    id_UsuarioRegistro="#session.ID_USUARIO#">
                    </cfloop>
                <cfelse>

                    <cfinvoke   component="#Application.RF.getPath('dao','Usuario')#"
                            method="ProveedoresUsuariosListado"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_Proveedor="#arguments.id_Proveedor#"
                            returnvariable="RSUsuarios">

                    <cfloop query="RSUsuarios">
                        <cfinvoke   component="#Application.RF.getPath('dao','Usuario')#"
                                    method="EliminarProveedorUsuario"
                                    id_Empresa="#session.ID_EMPRESA#"
                                    id_Proveedor="#arguments.id_Proveedor#"
                                    id_Usuario="#RSUsuarios.id_Usuario#"
                                    id_UsuarioElimino="#session.ID_USUARIO#">
                    </cfloop>
                </cfif>

                <cfset correo = structNew()>
                <cfset correo.destinatarios = arrayNew(1)>
                <cfinvoke component="#Application.RF.getPath('dao','configuracionnotificaciones')#"
                          method="leer_ConfiguracionNotificacionesEmpleados"
                          id_Notificacion="7"
                          returnvariable="Local.conf">

                <cfloop query="Local.conf">
                    <cfif arguments.sn_Transporte && Local.conf.id_Empleado EQ 6096><!--- Transporte a katherine de C&E  --->
                        <cfset arrayAppend(correo.destinatarios, Local.conf.de_Email)>
                    </cfif>
                    <cfif arguments.sn_Suministro && Local.conf.id_Empleado EQ 111> <!--- Suministro a guadalupe valle --->
                        <cfset arrayAppend(correo.destinatarios, Local.conf.de_Email)>
                    </cfif>
                    <cfif Local.conf.id_Empleado NEQ 6096 && Local.conf.id_Empleado NEQ 111>
                        <cfset arrayAppend(correo.destinatarios, Local.conf.de_Email)>
                    </cfif>
                </cfloop>

                <cfset correo.asunto = 'Alta/Modificación de Proveedor'>
                <cfset correo.sn_plantilla = "true">
                <cfset correo.dir_plantilla = "templates/correos/Proveedores/templateMailNuevoProveedor.html">
                <cfset correo.parametros = structNew()>
                <cfset correo.parametros.asunto = 'Alta/Modificación de Proveedor.'>
                <cfset correo.parametros.de_mensaje = 'Te informamos que se ha realizado un alta o modificación de la información del proveedor:'>
                <cfset correo.parametros.nb_Proveedor = arguments.nb_Proveedor>
                <cfset correo.parametros.de_RFC = arguments.de_RFC>

                <cfset correo.imagenes=[
                    {
                        dir="#session.AR_IMAGENREPORTE#",
                        disposicion='inline',
                        name="logo"
                    },
                    {
                        <!--- dir="assets/img/greenLeaf.jpg", se corrige la ruta  --->
                        dir="../../assets/img/greenLeaf.jpg",
                        disposicion='inline',
                        name="footer"
                    }
                ]>
                <cfif arrayLen(correo.destinatarios) GT 0>
                    <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                              method="sendMail"
                              argumentcollection="#correo#"
                              returnvariable="Local.rbr"/>

                    <cfif Local.rbr.hasError()>
                        <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                    </cfif>
                </cfif>

                <!--- CORREO PARA VALIDAR SI SE REGISTRO UN NUMERO DE PERMISO CRE CORRECTO --->
                <cfset correo = structNew()>
                <cfset correo.destinatarios = arrayNew(1)>

                <cfinvoke component="#Application.RF.getPath('dao','configuracionnotificaciones')#"
                            method="leer_ConfiguracionNotificacionesEmpleados"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_Sucursal="#SESSION.ID_SUCURSAL#"
                            id_Notificacion="59"
                            returnvariable="EmpleadosNotificacion">

                <cfloop query="EmpleadosNotificacion">
                    <cfset arrayAppend(correo.destinatarios, EmpleadosNotificacion.de_Email)>
                </cfloop>

                <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                        method="listar"
                        id_Empleado="#SESSION.ID_EMPLEADO#"
                        returnvariable="Local.empleado"/>

                <cfset correo.asunto = '¡Se ha registrado un proveedor con número de permiso CRE!'>
                <cfset correo.sn_plantilla = "true">
                <cfset correo.dir_plantilla = "templates/correos/notificaciones/not_validacionPermisoCRE.html">
                <cfset correo.parametros = structNew()>
                <cfset correo.parametros.fh_Movimiento = DateFormat(Now(), "dd/mm/yyyy") & '' & TimeFormat(now(),' hh:mm tt')>
                <cfset correo.parametros.nb_Empleado = "#Local.empleado.nb_Empleado#">
                <cfset correo.parametros.nb_Departamento = '#Local.empleado.nb_Departamento#'>
                <cfset correo.parametros.de_RazonSocial = '#arguments.nb_Proveedor#'>
                <cfset correo.parametros.body_text = '¡Hola! Se detectó una alta de un proveedor en el sistema SIPP en el cual fue agregado junto con un número de permiso CRE con la siguiente información:'>

                <cfif #arguments.sn_Transporte# && isDefined("arguments.sn_ConsultaPortalCRET")>
                    <cfif #arguments.sn_ConsultaPortalCRET#>
                        <cfset correo.parametros.de_Observaciones = 'Registro Público de la CRE'>
                    <cfelse>
                        <cfset correo.parametros.de_Observaciones = 'Ingresado manualmente'>
                    </cfif>

                    <cfset correo.parametros.sn_ConsultaPortalCRE = #arguments.sn_ConsultaPortalCRET#>
                    <cfset correo.parametros.nb_TipoClienteCRE = 'Transportistas'>
                    <cfset correo.parametros.de_PermisoCRE = #arguments.nu_PermisoCRETransporte#>

                    <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            argumentcollection="#correo#">
                </cfif>

                <cfif #arguments.sn_Suministro# && isDefined("arguments.sn_ConsultaPortalCREC")>
                    <cfif #arguments.sn_ConsultaPortalCREC#>
                        <cfset correo.parametros.de_Observaciones = 'Registro Público de la CRE'>
                    <cfelse>
                        <cfset correo.parametros.de_Observaciones = 'Ingresado manualmente'>
                    </cfif>
                    <cfset correo.parametros.sn_ConsultaPortalCRE = #arguments.sn_ConsultaPortalCREC#>
                    <cfset correo.parametros.nb_TipoClienteCRE = 'Combustibles'>
                    <cfset correo.parametros.de_PermisoCRE = #arguments.nu_PermisoCRECombustible#>
                    <cfinvoke   component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            argumentcollection="#correo#">
                </cfif>

                          <cfset Local.esSuministroNuevo = this.esSuministroExclusivo(
                    sn_Suministro=arguments.sn_Suministro
                )>

                <cfinvoke method="notificarCambioProveedorSuministro"
                    id_Proveedor="#arguments.id_Proveedor#"
                    sn_Suministro_Nuevo="#(Local.esSuministroNuevo ? 1 : 0)#"
                    esEdicion="true"
                    nb_Proveedor="#arguments.nb_Proveedor#"
                    de_RFC="#arguments.de_RFC#"
                    returnvariable="Local.notifSuministro" />





                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                            method="editar"
                            id_Proveedor="#arguments.id_Proveedor#"
                            argumentcollection="#arguments#">
                <!--- <cfreturn variables.RBR> --->



                <!--- <cfif isDefined("arguments.Cuentas") AND #arrayLen(arguments.Cuentas)#>
                    <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                                id_proveedor="#arguments.id_proveedor#"
                                method="resetCuentasContables">

                                <cfloop array="#arguments.Cuentas#" index="item">
                                    <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                                            method="AgregarCuentasContables"
                                            id_Proveedor            ="#arguments.ID_PROVEEDOR#"
                                            id_CuentaBancaria       ="#item.ID_CUENTABANCARIA#"
                                            nb_CuentaBancaria       ="#item.NB_CUENTABANCARIA#"
                                            id_TipoTransferencia    ="#item.ID_TIPOTRANSFERENCIA#"
                                            nb_ClaveProveedor       ="#item.NB_CLAVEPROVEEDOR#"
                                            nu_ClabeInterbancaria   ="#item.NU_CLABEINTERBANCARIA#"
                                            id_Banco                ="#item.ID_BANCO#"
                                            id_Moneda               ="#item.ID_MONEDA#">
                                </cfloop>
                </cfif> --->

                <!--- <cfdump var="#arguments#"><cfabort> --->
                <cfif isDefined("arguments.TiposComprobantes") AND #arrayLen(arguments.TiposComprobantes)#>
                    <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                method="EliminarProveedoresTiposComprobantes"
                                id_Proveedor="#arguments.ID_PROVEEDOR#" >
                    <cfloop array="#arguments.TiposComprobantes#" index="item">

                        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                method="AgregarProveedoresTiposComprobantes"
                                id_Proveedor="#arguments.ID_PROVEEDOR#"
                                id_TipoComprobante="#item.id_TipoComprobante#">
                    </cfloop>
                </cfif>

                <cfif isDefined("arguments.ConceptosServicios") AND #arrayLen(arguments.ConceptosServicios)#>
                    <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                method="DesactivarProveedoresServicios"
                                id_Proveedor="#arguments.ID_PROVEEDOR#" >

                    <cfloop array="#arguments.ConceptosServicios#" index="item">
                        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                                    method="ActivarProveedoresServicios"
                                    id_Proveedor="#arguments.ID_PROVEEDOR#"
                                    id_Insumo="#item.ID_INSUMO#">
                    </cfloop>
                </cfif>


                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
                <!---  <cfelse>
                    <cfset variables.RBR.setError('La referencia contable ya existe.')>
                </cfif> --->

            <cfelse>
                    <cfset variables.RBR.setError('El Proveedor ya esta registrado.')>
            </cfif>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Proveedor"            type="string" required="false"/>
        <cfargument name="nb_Proveedor"            type="string" required="false"/>
        <cfargument name="id_TipoProveedor"        type="string" required="false"/>
        <cfargument name="page"                    type="string" required="false"/>
        <cfargument name="pageSize"                type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible" type="string" required="false" />
        <cfargument name="sn_ProveedoresPago"      type="string" required="false" />

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfif arguments.sn_ProveedorCombustible EQ '1'>
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="listarCombustibleSn"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">
        <cfelse>
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="listar"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">
        </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar2" access="public" returntype="Any">
        <cfargument name="id_Proveedor"       type="string" required="false"/>
        <cfargument name="nb_Proveedor"       type="string" required="false"/>
        <cfargument name="id_TipoProveedor"   type="string" required="false"/>
        <cfargument name="page"               type="string" required="false"/>
        <cfargument name="pageSize"           type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible"         type="string" required="false" />

        <cfset arguments.id_Empresa = session.ID_EMPRESA>


        <cfif arguments.sn_ProveedorCombustible EQ '1'>
          <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarCombustibleSn"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfelse>
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="listar2"
                        argumentcollection="#arguments#"
                        returnvariable="Local.rs">
        </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarCatalogo" access="public" returntype="Any">
        <cfargument name="id_Proveedor"         type="string" required="false"/>
        <cfargument name="nb_Proveedor"         type="string" required="false"/>
        <cfargument name="id_TipoProveedor"     type="string" required="false"/>
        <cfargument name="page"                 type="string" required="false"/>
        <cfargument name="pageSize"             type="string" required="false"/>
        <cfargument name="de_RFC"               type="string" required="false"/>
        <cfargument name="sn_Transporte"        type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible" type="string" required="false"/>
        <cfargument name="sn_Reporte"           type="boolean"required="no" default="0">

        <cfset metodo = 'listarCatalogo'>
        <cfif arguments.sn_Reporte EQ 1 >
          <cfset metodo = 'listadoExcel'>
        </cfif>
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                      method="#metodo#"
                      argumentcollection="#arguments#"
                      returnvariable="local.rs">

            <cfset variables.RBR.setQuery(local.rs)>
          <cfreturn variables.RBR>
    </cffunction>


    <!---
        Victor Sanchez
        04/01/2016
        Lista los proveedores que son transportistas
      --->
    <cffunction name="upR_ProveedoresTransportistas" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="upR_ProveedoresTransportistas"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarContactosProveedores" access="public" returntype="Any">
        <cfargument name="id_Proveedor"  type="string" required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarContactosProveedores"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="Cmb_TiposProveedores" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="Cmb_TiposProveedores"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresCombo" access="public" returntype="Any">
        <cfargument name="sn_ProveedorCombustible"  type="string"  required="false"/>
        <cfargument name="sn_Extranjero"            type="string"  required="false"/>
        <cfargument name="sn_Transporte"            type="string"  required="false"/>
        <cfargument name="sn_CargaMasiva"           type="numeric" required="false"/>
        <cfargument name="sn_Pemex"                 type="numeric" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarProveedoresCombo"
                  id_Empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresComboTranspCombustible" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarProveedoresComboTranspCombustible"
                  id_Empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresAutoComplete" access="public" returntype="Any">
      <cfargument name="id_Proveedor"            type="string"       required="false"/>
      <cfargument name="nb_Proveedor"            type="string"       required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarProveedoresAutoComplete"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listarProveedoresTransporteAutoComplete" access="public" returntype="Any">
      <cfargument name="id_Proveedor"            type="string"       required="false"/>
      <cfargument name="nb_Proveedor"            type="string"       required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarProveedoresTransporteAutoComplete"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listarTelefonoProveedor"  access="public"  returntype="Any">
      <cfargument name="id_Proveedor"    type="numeric"   required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarTelefonoProveedor"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="eliminar" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric"  required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfset local.DatosEliminarContacto = structNew()>
        <cfset local.DatosEliminarContacto.id_Empresa = session.ID_EMPRESA>
        <cfset local.DatosEliminarContacto.id_Proveedor = arguments.id_Proveedor>



        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="CountContactosProveedor"
                  argumentcollection="#local.DatosEliminarContacto#"
                  returnvariable="local.NumerodeContactos">

        <!--- <cfdump var="#local.valor#"><cfabort> --->

        <cfloop query="local.NumerodeContactos">
            <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                        method="getCotizacionesAsignadas"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Proveedor = "#arguments.id_Proveedor#"
                        id_ProveedorContacto ="#local.NumerodeContactos.id_ProveedorContacto#"
                        returnvariable="local.CotizacionesAsignadas">

            <cfif local.CotizacionesAsignadas.nu_Existencia GTE 0 >
                <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                            method="editarProveedorContactoEliminar"
                            id_Empresa="#session.ID_EMPRESA#"
                            id_Proveedor="#arguments.id_Proveedor#"
                            id_ProveedorContacto ="#local.NumerodeContactos.id_ProveedorContacto#">

                <cfelse>
                    <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                                method="eliminarProveedorContacto"
                                argumentcollection="#local.DatosEliminarContacto#">
            </cfif>
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="editareliminarlogico"
                  argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: GCP
          Fecha: 02/10/2015
          Listado para el reporte de proveedores ordenes de compras con detalle--->
    <cffunction name="reporteProveedoresOrdenesCompraDetalle" access="public" returntype="Any">
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
        <cfargument name="cl_tipoReporte"      type="string" required="false"/>
        <cfargument name="nb_sucursal"         type="string" required="false"/>
        <cfargument name="nb_proveedor"        type="string" required="false"/>
        <cfargument name="nb_Departamento"     type="string" required="false"/>
        <cfargument name="nb_Almacen"          type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_Insumo"           type="string" required="false"/>
        <cfargument name="de_tipoRequisicion"  type="string" required="false"/>

        <cfset Arguments.id_Empresa = session.ID_EMPRESA>

        <cfif isDefined("Arguments.id_sucursal") and Arguments.id_sucursal EQ ''>
            <cfset Arguments.id_sucursal ='NULL'>
        </cfif>

        <cfif isDefined("Arguments.id_Proveedor") and Arguments.id_Proveedor EQ ''>
            <cfset Arguments.id_Proveedor ='NULL'>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="reporteProveedoresOrdenesCompraDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset year=Mid(Arguments.fh_inicio,1,4)>
        <cfset month=Mid(Arguments.fh_inicio,6,2)>
        <cfset day=Mid(Arguments.fh_inicio,9,2)>
        <cfset Arguments.fh_inicio=createDate(year, month, day)>

        <cfset year=Mid(Arguments.fh_fin,1,4)>
        <cfset month=Mid(Arguments.fh_fin,6,2)>
        <cfset day=Mid(Arguments.fh_fin,9,2)>
        <cfset Arguments.fh_fin=createDate(year, month, day)>

        <cfset Local.reporte=structNew()>
        <cfset Local.reporte.query=Local.rs>
        <cfset Local.reporte.de_directorio='reportes'>
        <cfset Local.reporte.nb_archivo='comprasProveedoresDetalle_#SESSION.ID_EMPLEADO#_#dateFormat(now(),"dd-mm-yyyy")#.xls'>
        <cfswitch expression="#Arguments.cl_tipoReporte#">
            <!--- *********** EXCEL ********** --->
            <cfcase value="excel">

                <cfif #Local.rs.recordcount# EQ 0>
                        <cfset variables.RBR.setError('No existen registros para generar el reporte.')>
                        <cfreturn variables.RBR>
                </cfif>



                <cfset Local.header="Sucursal,Proveedor,Importe Comprado">
                <cfset Local.campos="nb_sucursal,nb_proveedor,im_total">
                <cfset Local.formatos="General|General|($##,####0_($##,####0)">

                <!--- <cfset createExcelDetalle(
                    query=Local.rs,
                    nb_directorio=Local.reporte.de_directorio,
                    nb_archivo=Local.reporte.nb_archivo,
                    nb_proveedor= Arguments.nb_proveedor,
                    nb_sucursal= Arguments.nb_sucursal,
                    fh_inicio=Arguments.fh_inicio,
                    fh_fin= Arguments.fh_fin
                    )> --->
            </cfcase>
            <!--- *********** PDF ************ --->
            <cfcase value="pdf">
                <cfif #Local.rs.recordcount# EQ 0>
                        <cfset variables.RBR.setError('No existen registros para generar el reporte.')>
                        <cfreturn variables.RBR>
                </cfif>

                <!--- Se prepara el contenido del reporte --->
                <cfsavecontent variable="reporteComprasProveedores">
                    <cfinclude template="../../templates/reportes/Compras/reporteProveedoresOrdenesCompraDocDetalle.html">
                </cfsavecontent>

                <!--- Se hace el invoke del metodo que genera el PDF --->
                <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                          method="generatePDFNoDownload"
                          content="#reporteComprasProveedores#"
                          pdf="#Local.reporte.nb_archivo#"
                          path="#expandPath('../#Local.reporte.de_directorio#/')#">

                <cfset Local.reporte.nb_archivo=Local.reporte.nb_archivo&'.pdf'>
            </cfcase>
        </cfswitch>

        <cfset Variables.RBR.setData(Local.reporte)>
        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->

        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: Rey David Dominguez
          Fecha: 19/02/2015
          Listado para el reporte de proveedores ordenes de compras --->
    <cffunction name="reporteProveedoresOrdenesCompra" access="public" returntype="Any">
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
        <cfargument name="cl_tipoReporte"      type="string" required="false"/>
        <cfargument name="nb_sucursal"         type="string" required="false"/>
        <cfargument name="nb_proveedor"        type="string" required="false"/>
        <cfargument name="nb_Departamento"     type="string" required="false"/>
        <cfargument name="nb_Almacen"          type="string" required="false"/>
        <cfargument name="nb_FamiliaInsumo"    type="string" required="false"/>
        <cfargument name="nb_SubFamiliaInsumo" type="string" required="false"/>
        <cfargument name="nb_Insumo"           type="string" required="false"/>
        <cfargument name="de_tipoRequisicion"  type="string" required="false"/>

        <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        <cfif isDefined("Arguments.id_sucursal") and Arguments.id_sucursal EQ ''>
            <cfset Arguments.id_sucursal ='NULL'>
        </cfif>

        <cfif isDefined("Arguments.id_Proveedor") and Arguments.id_Proveedor EQ ''>
            <cfset Arguments.id_Proveedor ='NULL'>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="reporteProveedoresOrdenesCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset year=Val(Mid(Arguments.fh_inicio,1,4))>
        <cfset month=Val(Mid(Arguments.fh_inicio,6,2))>
        <cfset day=Val(Mid(Arguments.fh_inicio,9,2))>
        <cfset Arguments.fh_inicio=createDate(year, month, day)>

        <cfset year=Val(Mid(Arguments.fh_fin,1,4))>
        <cfset month=Val(Mid(Arguments.fh_fin,6,2))>
        <cfset day=Val(Mid(Arguments.fh_fin,9,2))>
        <cfset Arguments.fh_fin=createDate(year, month, day)>

        <cfset Local.reporte=structNew()>
        <cfset Local.reporte.query=Local.rs>
        <cfset Local.reporte.de_directorio='reportes'>
        <cfset Local.reporte.nb_archivo='comprasProveedores_#SESSION.ID_EMPLEADO#_#dateFormat(now(),"dd-mm-yyyy")#.xls'>

        <cfswitch expression="#Arguments.cl_tipoReporte#">
            <!--- *********** EXCEL ********** --->
            <cfcase value="excel">
                <cfif #Local.rs.recordcount# EQ 0>
                        <cfset variables.RBR.setError('No existen registros para generar el reporte.')>
                        <cfreturn variables.RBR>
                </cfif>

                <cfset Local.header="Sucursal,Proveedor,Importe Comprado">
                <cfset Local.campos="nb_sucursal,nb_proveedor,im_total">
                <cfset Local.formatos="General|General|($##,####0_($##,####0)">

                <!--- <cfset Variables.RBR.setData(Local.rs)>
                <cfreturn variables.RBR>

                <cfset createExcel(
                    query=Local.rs,
                    nb_directorio=Local.reporte.de_directorio,
                    nb_archivo=Local.reporte.nb_archivo,
                    nb_proveedor= Arguments.nb_proveedor,
                    nb_sucursal= Arguments.nb_sucursal,
                    fh_inicio=Arguments.fh_inicio,
                    fh_fin= Arguments.fh_fin
                    )> --->
            </cfcase>
            <!--- *********** PDF ************ --->
            <cfcase value="pdf">
                <cfif #Local.rs.recordcount# EQ 0>
                        <cfset variables.RBR.setError('No existen registros para generar el reporte.')>
                        <cfreturn variables.RBR>
                </cfif>
                <!--- Se prepara el contenido del reporte --->
                <cfsavecontent variable="reporteComprasProveedores">
                    <cfinclude template="../../templates/reportes/Compras/reporteProveedoresOrdenesCompraDoc.html">
                </cfsavecontent>

                <!--- Se hace el invoke del metodo que genera el PDF --->
                <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                          method="generatePDFNoDownload"
                          content="#reporteComprasProveedores#"
                          pdf="#Local.reporte.nb_archivo#"
                          path="#expandPath('../#Local.reporte.de_directorio#/')#">

                <cfset Local.reporte.nb_archivo=Local.reporte.nb_archivo&'.pdf'>
            </cfcase>
        </cfswitch>

        <cfset Variables.RBR.setData(Local.reporte)>
        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="createExcel" access="private" returntype="void">
        <cfargument name="query" type="query" required="true">
        <cfargument name="nb_directorio" type="string" required="true">
        <cfargument name="nb_archivo" type="string" required="true">
        <cfargument name="nb_proveedor" type="string" required="true">
        <cfargument name="nb_sucursal" type="string" required="true">
        <cfargument name="fh_inicio" type="string" required="true">
        <cfargument name="fh_fin" type="string" required="true">







        <!--- Import the POI tag library. --->
        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#Arguments.nb_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#Arguments.nb_directorio#/'))>
        </cfif>

        <!--- Create an excel document and store binary data into
            REQUEST variable. --->

        <poi:document
            name="REQUEST.ExcelData"
            file="#ExpandPath( '../#Arguments.nb_directorio#/#Arguments.nb_archivo#')#"
            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">

            <!--- Define style classes. --->
            <poi:classes>
                <poi:class
                    name="title"
                    style="font-family: Arial ; color: black ; background-color: ##f5f5f5 ; font-size: 12pt ; text-align: left; font-weight: bold;"
                    />

                <poi:class
                    name="header"
                    style="font-family: Arial ; background-color: FFCC33  ; color: black ; font-size: 11pt; font-weight: bold;"
                    />

                <poi:class
                    name="fondo"
                    style="background-color: GREY_25_PERCENT; "
                />
                <poi:class
                    name="derecha"
                    style=" text-align: right;"
                />
                <poi:class
                    name="Total"
                    style="
                        text-align: right;
                        font-family: Arial;
                        font-size: 11pt;
                        border-right: 2px;
                        border-bottom: 2px;"
                />

                <poi:class
                    name="Contenido"
                    style="
                        font-family: Arial ;
                        color: black ;
                        background-color:white;
                        font-size: 10pt;"
                />


                <poi:class name="filtros" style="font-weight: bold;color:blue;text-align:right;"/>

                <poi:class name="left" style="border-left:2px solid black"/>
                <poi:class name="right" style="border-right:2px solid black"/>
                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                <poi:class name="top" style="border-top:2px solid black"/>


            </poi:classes>

            <!--- Define Sheets. --->
            <poi:sheets>
                <poi:sheet
                    name="Reporte compras"
                    <!--- freezerow="8" --->
                    orientation="landscape"
                    zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 250px ;" />
                        <poi:column style="width: 250px ;" />
                        <poi:column style="width: 150px ;text-align: right ;" />
                        <poi:column style="width: 150px ;text-align: right ;" />
                        <poi:column style="width: 150px ;text-align: right ;" />
                    </poi:columns>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Reporte de Compras por proveedores" colspan="3"  class="title"/>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                    </poi:row>

                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="Sucursal:" class="filtros"/>
                        <poi:cell value="#Arguments.nb_sucursal#"/>
                        <poi:cell value="Proveedor:" class="filtros"/>
                        <poi:cell value="#Arguments.nb_proveedor#"/>
                    </poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="De:" class="filtros"/>
                        <poi:cell value="#dateFormat(Arguments.fh_inicio,'dd/mm/yyyy')#"/>
                        <poi:cell value="A:" class="filtros"/>
                        <poi:cell value="#dateFormat(Arguments.fh_fin,'dd/mm/yyyy')#"/>
                    </poi:row>
                    <poi:row class=''></poi:row>

                    <!--- Header row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value='' class="fondo left top bottom"/>
                        <poi:cell value="Sucursal"  class="header fondo top bottom"/>
                        <poi:cell value="Proveedor"  class="header fondo top bottom"/>
                        <poi:cell value="SubTotal "  class="header fondo top bottom"/>
                        <poi:cell value="IVA "  class="header fondo top bottom"/>
                        <poi:cell value="Total "  class="header fondo top bottom right"/>
                    </poi:row>

                    <!--- Output the people. --->
                    <cfset result.Total = 0>
                    <cfloop query="Arguments.query">
                            <cfset result.Total = result.Total + Arguments.query.im_total>
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="" class="left bottom Contenido"/>
                            <poi:cell value="#Arguments.query.nb_sucursal#" class="Contenido bottom"/>
                            <poi:cell value="#Arguments.query.nb_proveedor#" class="Contenido bottom"/>
                            <poi:cell value="#Arguments.query.IM_SUBTOTAL#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha" alias="SubTotalRow#currentRow#"/>
                            <poi:cell value="#Arguments.query.IM_IVA#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha"  alias="IvaRow#currentRow#"/>
                            <poi:cell value="#Arguments.query.IM_TOTAL#" type="numeric" numberformat="($##,####0.00);($##,####0.00)" class="bottom derecha right"  alias="TotalRow#currentRow#"/>
                        </poi:row>

                    </cfloop>

                    <poi:row>
                    </poi:row>

                    <poi:row class="header fondo">
                        <poi:cell index="2" value="" colspan="2"/>
                        <poi:cell value="Total:" class="derecha"/>
                        <poi:cell value="SUM(@SubTotalRow1:@SubTotalRow#query.recordcount#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                        <poi:cell value="SUM(@IvaRow1:@IvaRow#query.recordcount#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                        <poi:cell value="SUM(@TotalRow1:@TotalRow#query.recordcount#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" />

                    </poi:row>

                </poi:sheet>

            </poi:sheets>

        </poi:document>

        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="addImage"
                  nb_excelFile="#ExpandPath( '../#Arguments.nb_directorio#/#Arguments.nb_archivo#')#"
                  src_image="#ExpandPath( '../assets/img/bg_body.png')#"
                  nb_sheet="Reporte compras"
                  nu_colWidth="3"
                  nu_startRow="4">

        <!--- <cfset fileDelete(ExpandPath( '../reportes/petroiltemplate.xls' ))> --->
    </cffunction>

    <cffunction name="createExcelDetalle" access="private" returntype="void">
        <cfargument name="query" type="query" required="true">
        <cfargument name="nb_directorio" type="string" required="true">
        <cfargument name="nb_archivo" type="string" required="true">
        <cfargument name="nb_proveedor" type="string" required="true">
        <cfargument name="nb_sucursal" type="string" required="true">
        <cfargument name="fh_inicio" type="string" required="true">
        <cfargument name="fh_fin" type="string" required="true">
        <!--- Import the POI tag library. --->
        <cfset SubTotalRow = ''>
        <cfset IvaRow = ''>
        <cfset TotalRow = ''>
        <cfset index = 0>
        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#Arguments.nb_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#Arguments.nb_directorio#/'))>
        </cfif>

        <!--- Create an excel document and store binary data into
            REQUEST variable. --->

        <poi:document
            name="REQUEST.ExcelData"
            file="#ExpandPath( '../#Arguments.nb_directorio#/#Arguments.nb_archivo#')#"
            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">

            <!--- Define style classes. --->
            <poi:classes>
                <poi:class
                    name="title"
                    style="font-family: Arial ; color: black ; background-color: ##f5f5f5 ; font-size: 12pt ; text-align: left; font-weight: bold;"
                    />

                <poi:class
                    name="header"
                    style="font-family: Arial ; background-color: FFCC33  ; color: black ; font-size: 10pt; font-weight: bold;"
                    />

                <poi:class
                    name="fondo"
                    style="background-color: GREY_25_PERCENT; "
                />
                <poi:class
                    name="fondo2"
                    style="background-color: GREY_50_PERCENT; "
                />
                <poi:class
                    name="derecha"
                    style=" text-align: right; font-weight: bold;"
                />
                <poi:class
                    name="Total"
                    style="
                        text-align: right;
                        font-family: Arial;
                        font-size: 11pt;
                        border-right: 2px;
                        border-bottom: 2px;"
                />

                <poi:class
                    name="Contenido"
                    style="
                        font-family: Arial ;
                        color: black ;
                        background-color:white;
                        font-size: 10pt;"
                />


                <poi:class name="filtros" style="font-weight: bold;color:blue;text-align:right;"/>

                <poi:class name="left" style="border-left:2px solid black"/>
                <poi:class name="right" style="border-right:2px solid black"/>
                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                <poi:class name="top" style="border-top:2px solid black"/>


            </poi:classes>

            <!--- Define Sheets. --->
            <poi:sheets>
                <poi:sheet
                    name="Reporte compras"
                    <!--- freezerow="8" --->
                    orientation="landscape"
                    zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 150px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 150px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                        <poi:column style="width: 100px ;" />
                    </poi:columns>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Reporte de Compras por proveedores detallado" colspan="4"  class="title"/>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                    </poi:row>

                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="Sucursal:" class="filtros"/>
                        <poi:cell value="#Arguments.nb_sucursal#"/>
                        <poi:cell value="Proveedor:" class="filtros"/>
                        <poi:cell value="#Arguments.nb_proveedor#"/>
                    </poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="De:" class="filtros"/>
                        <poi:cell value="#dateFormat(Arguments.fh_inicio,'dd/mm/yyyy')#"/>
                        <poi:cell value="A:" class="filtros"/>
                        <poi:cell value="#dateFormat(Arguments.fh_fin,'dd/mm/yyyy')#"/>
                    </poi:row>
                    <poi:row class='fondo2'></poi:row>
                    <cfset  nb_ProveedorAct = Arguments.query.NB_PROVEEDOR >
                    <!--- Header row. --->
                    <poi:row class='fondo2'>
                        <poi:cell index="2" value="Detalle de Ordenes de Compra #nb_ProveedorAct#" colspan="12"/>
                    </poi:row>
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Sucursal"          class="header left fondo top bottom"/>
                        <poi:cell value="Proveedor"         class="header left fondo top bottom"/>
                        <poi:cell value="Folio OC"          class="header left fondo top bottom"/>
                        <poi:cell value="Fecha OC"          class="header fondo top bottom"/>
                        <poi:cell value="Factura"           class="header left fondo top bottom"/>
                        <poi:cell value="Fecha Factura"     class="header fondo top bottom"/>
                        <poi:cell value="Insumo"            class="header fondo top bottom"/>
                        <poi:cell value="Cantidad"          class="header fondo top bottom"/>
                        <poi:cell value="Precio Unitario"   class="header fondo top bottom"/>
                        <poi:cell value="Sub Total"         class="header fondo top bottom"/>
                        <poi:cell value="IVA"               class="header fondo top bottom"/>
                        <poi:cell value="Total"             class="header fondo top bottom right"/>
                    </poi:row>

                    <!--- Output the people. --->
                    <cfloop query="query">
                        <cfif nb_ProveedorAct NEQ Arguments.query.NB_PROVEEDOR>
                            <poi:row class="header fondo" style="text-align: left;">
                                <poi:cell index ="2" colspan="9"/>
                                <poi:cell value="SUM(@IM_SUBTOTAL#(CurrentRow-index)#:@IM_SUBTOTAL#(CurrentRow-1)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_SUBTOTAL_S_#CurrentRow#"/>
                                <cfset SubTotalRow = SubTotalRow & '@IM_SUBTOTAL_S_#CurrentRow#+'>
                                <poi:cell value="SUM(@IM_IVA#(CurrentRow-index)#:@IM_IVA#(CurrentRow-1)#)"           type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_IVA_S_#CurrentRow#"/>
                                <cfset IvaRow = IvaRow & '@IM_IVA_S_#CurrentRow#+'>
                                <poi:cell value="SUM(@IM_TOTAL#(CurrentRow-index)#:@IM_TOTAL#(CurrentRow-1)#)"       type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_TOTAL_S_#CurrentRow#"/>
                                <cfset TotalRow = TotalRow & '@IM_TOTAL_S_#CurrentRow#+'>
                            </poi:row >
                            <poi:row class='fondo2'>
                                <poi:cell index="2" value="Detalle de Ordenes de Compra #query.NB_PROVEEDOR#" colspan="12"/>
                            </poi:row>

                            <cfset  nb_ProveedorAct = query.NB_PROVEEDOR >
                            <cfset index =  0>
                        </cfif>
                            <poi:row>
                                <poi:cell value="" />
                                <poi:cell value="#query.NB_SUCURSAL#"            class="left Contenido bottom"/>
                                <poi:cell value="#query.NB_PROVEEDOR#"           class="left Contenido bottom"/>
                                <poi:cell value="#query.ID_OrdenDeCompra#"       class="left Contenido bottom" style="text-align: center"/>
                                <poi:cell value="#query.FH_REGISTROORDENCOMPRA#" class="left bottom" style="text-align: center"/>
                                <poi:cell value="#query.NU_FACTURA#"             class="left bottom" style="text-align: center"/>
                                <poi:cell value="#query.FH_FACTURA#"             class="left bottom" style="text-align: center"/>
                                <poi:cell value="#query.NB_NOMBREINSUMO#"        class="left bottom"/>
                                <poi:cell value="#query.NU_CANTIDAD#"            type="numeric" numberformat="##,####0.00" class="left bottom"/>
                                <poi:cell value="#query.IM_PRECIOUNITARIO#"      type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" class="left bottom"/>
                                <poi:cell value="#query.IM_SUBTOTAL#"            class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_SUBTOTAL#CurrentRow#"/>
                                <poi:cell value="#query.IM_IVA#"                 class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_IVA#CurrentRow#"/>
                                <poi:cell value="#query.IM_TOTAL#"               class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_TOTAL#CurrentRow#"/>
                            </poi:row>
                            <cfset index =  index + 1>
                    </cfloop>
                    <poi:row class="header fondo" style="text-align: left;">
                        <poi:cell index ="2" colspan="9"/>
                        <poi:cell value="SUM(@IM_SUBTOTAL#(query.recordcount-index+1)#:@IM_SUBTOTAL#(query.recordcount)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_SUBTOTAL_S_#query.recordcount#"/>
                        <cfset SubTotalRow = SubTotalRow & '@IM_SUBTOTAL_S_#query.recordcount#+'>
                        <poi:cell value="SUM(@IM_IVA#(query.recordcount-index+1)#:@IM_IVA#(query.recordcount)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_IVA_S_#query.recordcount#"/>
                        <cfset IvaRow = IvaRow & '@IM_IVA_S_#query.recordcount#+'>
                        <poi:cell value="SUM(@IM_TOTAL#(query.recordcount-index+1)#:@IM_TOTAL#(query.recordcount)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_TOTAL_S_#query.recordcount#"/>
                        <cfset TotalRow = TotalRow & '@IM_TOTAL_S_#query.recordcount#+'>
                    </poi:row >
                    <poi:row>
                    </poi:row>
                    <cfset SubTotalRow=reReplace(SubTotalRow, '\+$', "", "ALL")>
                    <cfset IvaRow=reReplace(IvaRow, '\+$', "", "ALL")>
                    <cfset TotalRow=reReplace(TotalRow, '\+$', "", "ALL")>
                    <poi:row class="header fondo" style="text-align: left;">
                        <poi:cell index ="2" colspan="8"/>
                        <poi:cell value="Totales"/>
                        <poi:cell value="SUM(#SubTotalRow#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                        <poi:cell value="SUM(#IvaRow#)"      type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                        <poi:cell value="SUM(#TotalRow#)"    type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" />
                    </poi:row>

                    <poi:row>
                    </poi:row>

                </poi:sheet>

            </poi:sheets>

        </poi:document>

        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="addImage"
                  nb_excelFile="#ExpandPath( '../#Arguments.nb_directorio#/#Arguments.nb_archivo#')#"
                  src_image="#ExpandPath( '../assets/img/bg_body.png')#"
                  nb_sheet="Reporte compras"
                  nu_colWidth="3"
                  nu_startRow="4">
    </cffunction>




    <!---
        Victor Sanchez
     --->
    <cffunction  name="agregarDispersion"            access="public" returntype="Any">
        <cfargument name="id_CuentaBancaria"  type="string" required="true"/>
        <cfargument name="im_TotalDispersion" type="string" required="true"/>
        <cfargument name="fh_DiaPago"         type="string" required="true"/>
        <cfargument name="fh_DiaOperacion"    type="string" required="true"/>
        <cfargument name="id_Moneda"          type="string" required="true"/>
        <cfargument name="im_TipoCambio"      type="string" required="true"/>
        <cfargument name="Detalle"            type="array"  required="true"/>
        <cfargument name="Dispersion"         type="array"  required="true"/>

        <!--- Primero se inserta el encabezado --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="agregar_dispersionEncabezado"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#SESSION.ID_SUCURSAL#"
            argumentcollection="#arguments#"
            returnvariable="nextId_Dispersion">

        <!--- Se agrega la dispersion por proveedor --->
        <cfloop array="#Dispersion#" index="Local.opcion">
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="agregar_dispersionProveedor"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#SESSION.ID_SUCURSAL#"
                id_Dispersion="#nextId_Dispersion.ID#"
                id_Proveedor="#Local.opcion.ID_PROVEEDOR#"
                im_TotalProveedor="#Local.opcion.IMPORTE#"
                id_CuentaBancaria="#Local.opcion.ID_CUENTABANCARIA#"
                de_ReferenciaLayout="#Local.opcion.de_ReferenciaLayout#"
                id_DeudorDiverso="#Local.opcion.ID_DEUDORDIVERSO#"
                id_AcreedorDiverso="#Local.opcion.ID_ACREEDORDIVERSO#">
        </cfloop>

        <!--- Se agrega el detalle --->
        <cfset nd = 1>
        <cfloop array="#Detalle#" index="Local.opcion">
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="agregar_dispersionDetalle"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#SESSION.ID_SUCURSAL#"
                id_Dispersion="#nextId_Dispersion.ID#"
                id_Proveedor="#local.opcion.ID_PROVEEDOR#"
                nd_Dispersion="#nd#"
                cl_TipoDocumento="#local.opcion.CL_TIPO#"
                id_Documento="#local.opcion.ID_DOCUMENTO#"
                im_Documento="#local.opcion.IM_TOTAL#"
                id_ProgramacionPago="#local.opcion.ID_PROGRAMACION#"
                id_ProgramacionPagoDetalle="#local.opcion.ID_PROGRAMACIONPAGODETALLE#"
                id_SucursalDocumento="#local.opcion.ID_SUCURSALDOCUMENTO#"
                sn_AnticipoPagar =  "#IIF(local.opcion.SN_ANTICIPOPAGAR, DE('1') , DE('0'))#"
                im_DocumentoMN="#local.opcion.IM_TOTALMN#"
                id_Moneda="#local.opcion.ID_MONEDA#"
                im_TipoCambio="#local.opcion.IM_TIPOCAMBIO#"
                id_DeudorDiverso="#Local.opcion.ID_DEUDORDIVERSO#"
                id_AcreedorDiverso="#Local.opcion.ID_ACREEDORDIVERSO#">

            <cfset nd = nd+1>
        </cfloop>

        <cfreturn variables.RBR>
    </cffunction>

     <cffunction  name="upR_DispersionBanProveedor" access="public" returntype="Any">
        <cfargument name="id_Empresa"    type="string" required="false" default="">
        <cfargument name="id_Sucursal"   type="string" required="false" default="">
        <cfargument name="id_Dispersion" type="string" required="false" default="">
        <cfargument name="id_Proveedor"  type="string" required="false" default="">

        <cfinvoke component="#Application.RF.getPath("dao","Proveedores")#"
            method="upR_DispersionBanProveedor"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
     </cffunction>

    <!---
        Victor Sanchez
     --->
    <cffunction name="listar_DispersionesProveedores"  access="public" returntype="Any">
        <cfargument name="id_Dispersion"       type="string" required="no">
        <cfargument name="fh_Operacion"        type="string" required="no">
        <cfargument name="id_CuentaBancaria"   type="string" required="no">
        <cfargument name="id_Moneda"           type="string" required="no">
        <cfargument name="id_TipoBeneficiario" type="string" required="no">
        <cfargument name="id_Proveedor"        type="string" required="no">
        <cfargument name="id_DeudorDiverso"    type="string" required="no">
        <cfargument name="id_AcreedorDiverso"  type="string" required="no">
        <cfargument name="fh_Pago"             type="string" required="no">

        <cfset arguments.id_Empresa = "#session.ID_EMPRESA#">
        <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listar_DispersionesProveedores"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!---
        Victor Sanchez
     --->
    <cffunction name="listar_DispersionesDetalle" access="public" returntype="Any">
        <cfargument name="id_Dispersion" type="string" required="yes">

        <cfset arguments.id_Empresa = "#session.ID_EMPRESA#">
        <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listar_DispersionesDetalle"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
     </cffunction>

    <!---
        Victor Sanchez
        12/02/2016
        Edita una dispersion
     --->
    <cffunction  name="editarDispersion" access="public" returntype="Any">
        <cfargument name="id_CuentaBancaria"    type="string" required="true"/>
        <cfargument name="im_TotalDispersion"   type="string" required="true"/>
        <cfargument name="fh_DiaPago"           type="string" required="true"/>
        <cfargument name="fh_DiaOperacion"      type="string" required="true"/>
        <cfargument name="id_Moneda"            type="string" required="true"/>
        <cfargument name="im_TipoCambio"        type="string" required="true"/>
        <cfargument name="id_Dispersion"        type="string" required="true"/>
        <cfargument name="Detalle"              type="array"  required="true"/>
        <cfargument name="Dispersion"           type="array"  required="true"/>
        <cfargument name="DocumentosPERechazar" type="array"  required="false"/>


        <!--- Primero se edita el encabezado --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="update_dispersionEncabezado"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#SESSION.ID_SUCURSAL#"
            argumentcollection="#arguments#">

        <!--- Elimina la dispersion por proveedor y su detalle  --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="delete_dispersionProveedor"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#SESSION.ID_SUCURSAL#"
            argumentcollection="#arguments#">

        <!--- Se agrega la dispersion por proveedor --->
        <cfloop array="#Dispersion#" index="Local.opcion">
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="agregar_dispersionProveedor"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#SESSION.ID_SUCURSAL#"
                id_Dispersion="#id_Dispersion#"
                id_Proveedor="#Local.opcion.ID_PROVEEDOR#"
                im_TotalProveedor="#Local.opcion.IMPORTE#"
                id_CuentaBancaria="#Local.opcion.ID_CUENTABANCARIA#"
                de_ReferenciaLayout="#Local.opcion.de_ReferenciaLayout#"
                id_DeudorDiverso="#Local.opcion.ID_DEUDORDIVERSO#"
                id_AcreedorDiverso="#Local.opcion.ID_ACREEDORDIVERSO#">
        </cfloop>

        <!--- Se agrega el detalle --->
        <cfset nd = 1>
        <cfloop array="#Detalle#" index="Local.opcion">
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="agregar_dispersionDetalle"
                id_Empresa="#session.ID_EMPRESA#"
                id_Sucursal="#SESSION.ID_SUCURSAL#"
                id_Dispersion="#id_Dispersion#"
                id_Proveedor="#local.opcion.ID_PROVEEDOR#"
                nd_Dispersion="#nd#"
                cl_TipoDocumento="#local.opcion.CL_TIPO#"
                id_Documento="#local.opcion.ID_DOCUMENTO#"
                im_Documento="#local.opcion.IM_TOTAL#"
                id_ProgramacionPago="#local.opcion.ID_PROGRAMACION#"
                id_ProgramacionPagoDetalle="#local.opcion.ID_PROGRAMACIONPAGODETALLE#"
                id_SucursalDocumento="#local.opcion.ID_SUCURSALDOCUMENTO#"
                <!--- sn_AnticipoPagar =  "#local.opcion.SN_ANTICIPOPAGAR#" --->
                sn_AnticipoPagar =  "#IIF(local.opcion.SN_ANTICIPOPAGAR, DE('1') , DE('0'))#"
                im_DocumentoMN="#local.opcion.IM_TOTALMN#"
                id_Moneda="#local.opcion.ID_MONEDA#"
                im_TipoCambio="#local.opcion.IM_TIPOCAMBIO#"
                id_DeudorDiverso="#Local.opcion.ID_DEUDORDIVERSO#"
                id_AcreedorDiverso="#Local.opcion.ID_ACREEDORDIVERSO#">

            <cfset nd = nd+1>
        </cfloop>

        <!--- Empezamos con el rechazo de los pagos extraordinarios --->
        <cfloop array="#arguments.DocumentosPERechazar#" index="pe">
            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesPago')#"
                method="rechazarPagoExtraordinario"
                id_Empresa="#session.ID_EMPRESA#"
                id_SolicitudPago="#pe.id_SolicitudPago#"
                de_MotivoRechazo="#pe.de_MotivoRechazo#"
                nu_NivelAutorizacion="#pe.nu_NivelAutorizacion#">
        </cfloop>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="generarTXT" access="public" returntype="Any">
        <cfargument name="id_Dispersion"     type="string"  required="true">
        <cfargument name="CL_CODIGOABM"      type="string"  required="true">
        <cfargument name="id_CuentaBancaria" type="numeric" required="false">
        <cfargument name="ID_MONEDA"         type="numeric" required="false">

        <cftry>
            <cfset local.nb_Banco = ''>
            <cfswitch expression="#Trim(CL_CODIGOABM)#">
                <cfcase value="14">
                    <!--- Santander --->
                    <cfset local.nb_Banco = 'Santander'>
                    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="upC_LayoutSantander"
                        id_Dispersion="#id_Dispersion#"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal="#SESSION.ID_SUCURSAL#"
                        returnvariable="Local.Layout">
                </cfcase>

                <cfcase value="58">
                    <!--- BanRegio --->
                    <cfset local.nb_Banco = 'BanRegio'>
                    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="upC_LayoutBanRegio"
                        id_Dispersion="#id_Dispersion#"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal="#SESSION.ID_SUCURSAL#"
                        returnvariable="Local.Layout">
                </cfcase>

                <cfcase value="765">
                    <!--- Banorte --->
                    <cfset local.nb_Banco = 'Banorte'>
                </cfcase>

                <cfcase value="455">
                    <!--- BBVA Bancomer --->
                    <cfset local.nb_Banco = 'BBVA Bancomer'>
                </cfcase>

                <cfcase value="12">
                    <!--- BBVA Bancomer --->
                    <cfset local.nb_Banco = 'BBVA Bancomer'>
                    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="upC_LayoutBBVA"
                        id_Empresa ="#session.ID_EMPRESA#"
                        id_Sucursal="#SESSION.ID_SUCURSAL#"
                        id_Dispersion="#id_Dispersion#"
                        id_CuentaBancaria = #id_CuentaBancaria#
                        id_Moneda = #ID_MONEDA#
                        returnvariable="Local.Layout">
                </cfcase>

                <cfdefaultcase></cfdefaultcase>
            </cfswitch>

            <cfif NOT isDefined("Local.Layout")>
                <cfset variables.RBR.setError('No se cuenta con un Layout configurado para el banco: #local.nb_Banco#')>
                <cfreturn variables.RBR>
            </cfif>

            <cfset var Local.infoReport = {
                de_directorio = "Reportes",
                nb_archivo = local.nb_Banco & '_' & SESSION.nb_Empresa & '_' & DateFormat(now(), 'yyyy-mm-dd') & ".txt"
            }>

            <cfset path = ExpandPath('../#Local.infoReport.de_directorio#/')>
            <cfset ruta = path & "#Local.infoReport.nb_archivo#"/>

            <cfif fileExists(ruta)>
                <cffile action="delete" file="#ruta#">
            </cfif>

            <cfset contador = 1>
            <cfset tope = #Local.Layout.recordcount#>
            <cffile action="write" file="#ruta#" output="" addnewline="no" charset="utf-8"/>

            <cfloop query="Local.Layout">
                <cfif #contador# EQ #tope#>
                    <cffile action="append" file="#ruta#" output="#texto#" addnewline="no">
                <cfelse>
                    <cffile action="append" file="#ruta#" output="#texto#" addnewline="yes"/>
                    <cfset contador = #contador# + 1>
                </cfif>
            </cfloop>

            <cfset variables.RBR.setData(Local.infoReport)>

            <cfcatch type=''>
                <cfset variables.RBR.setError('#cfcatch.Detail#')>
            </cfcatch>
        </cftry>

        <cfreturn variables.RBR>
    </cffunction>



    <!--- jc 13-02-2016 --->
    <cffunction  name="guardaremisiondepago"    access="public" returntype="Any">
        <cfargument name="prov"                type="struct"  required="yes">
        <cfargument name="id_DeudorDiverso"    type="string"  required="false">
        <cfargument name="de_DeudorDiverso"    type="string"  required="false">
        <cfargument name="id_AcreedorDiverso"  type="string"  required="false">
        <cfargument name="de_AcreedorDiverso"  type="string"  required="false">
        <cfargument name="cb"                  type="struct"  required="yes">
        <cfargument name="pago"                type="struct"  required="yes">
        <cfargument name="fh_pago"             type="string"  required="yes">
        <cfargument name="nu_cheque"           type="string"  required="false" default="NULL">
        <cfargument name="facturas"            type="array"   required="yes">
        <cfargument name="notas"               type="array"   required="yes">
        <cfargument name="anticipos"           type="array"   required="no">
        <cfargument name="im_TotalPago"        type="numeric" required="yes">
        <cfargument name="im_TotalMovBancario" type="numeric" required="yes">
        <cfargument name="bandera"             type="boolean" required="no" default="false">
        <cfargument name="id_Dispersion"       type="numeric" required="no" default="0">

        <!--- <cfdump var="#arguments#" /><cfabort /> --->
        <cfset arguments.id_Empresa = "#session.ID_EMPRESA#">
        <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">

        <cfif isDefined("prov.ID_PROVEEDOR")>
            <cfset arguments.id_Proveedor = prov.ID_PROVEEDOR >
        </cfif>

        <cfif isDefined("prov.NB_PROVEEDOR")>
            <cfset arguments.nb_Proveedor = prov.NB_PROVEEDOR >
        </cfif>

        <cfif isDefined("cb.ID_CUENTABANCARIA")>
            <cfset arguments.id_cuentabancaria = cb.ID_CUENTABANCARIA >
        </cfif>

        <cfset local.tfac = 0>
        <cfset local.tnot = 0>
        <cfset local.tant = 0>

        <!--- se hace un recorrido para validar de nuevo los montos de las notas y anticipos --->
        <cfloop from="1" to="#arrayLen(arguments.facturas)#" index="local.i">
            <cfset local.tfac += arguments.facturas[local.i].IM_TOTAL >
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.notas)#" index="local.i">
            <cfset local.tnot += arguments.notas[local.i].IM_TOTAL >
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.anticipos)#" index="local.i">
            <cfset local.tant += arguments.anticipos[local.i].IM_TOTAL >
        </cfloop>

        <cfif (local.tnot + local.tant) GT local.tfac>
            <cfset variables.rbr.setError('El monto de las notas de créditos mas los anticipos debe ser menor al total de las facturas seleccionadas.')>
            <cfreturn>
        </cfif>

        <!--- <cfif isDefined("mon.ID_MONEDA")>
            <cfset arguments.id_moneda = cb.ID_MONEDA>
        </cfif>

        <cfif isDefined("mon.IM_TIPOCAMBIO")>
            <cfset arguments.im_TipoCambio = cb.IM_TIPOCAMBIO>
        </cfif> --->

        <cfset arguments.im_TipoCambio = cb.IM_TIPOCAMBIO>
        <cfset arguments.id_moneda = cb.ID_MONEDA>

        <cfset bo_EmitirPagoProveedor = StructNew()>

        <!--- Agregar Pago General --->
        <cfset Local.im_AnticipoAplicado = 0>
        <cfset Local.id_Estatus          = 1105>
        <cfset Local.id_PolizaCont       = 0>
        <cfset Local.fh_PolizaCont       ='1900-01-01'>
        <cfset Local.id_PolizaCancel     = 0>
        <cfset Local.fh_PolizaCancel     ='1900-01-01'>

        <!--- Agregar Movimiento Bancario --->
        <cfset mbArgs                      = StructNew()>
        <cfset mbArgs.id_Empresa           = "#Arguments.id_Empresa#">
        <cfset mbArgs.id_CuentaBancaria    = "#Arguments.id_CuentaBancaria#">
        <cfset mbArgs.de_Concepto          = "Emision de Pago">
        <cfset mbArgs.cl_Naturaleza        = "E">
        <cfset mbArgs.fh_Movimiento        = "#Arguments.fh_Pago#">
        <cfset mbArgs.im_Movimiento        = "#Arguments.im_TotalPago#">
        <cfset mbArgs.id_Moneda            = "#Arguments.id_Moneda#">
        <cfset mbArgs.im_TipoCambio        = "#Arguments.im_TipoCambio#">
        <cfset mbArgs.nu_cheque            = "#arguments.nu_cheque#">
        <cfset mbArgs.fh_Captura           = dateformat(now(), 'yyyy-mm-dd')>
        <cfset mbArgs.id_Estatus           = 1105>
        <cfset mbArgs.sn_Conciliado        = 0>
        <cfset mbArgs.sn_PolizaGenerada    = 0>
        <cfset mbArgs.id_empleado          = "#SESSION.ID_EMPLEADO#">
        <cfset mbArgs.id_empresaoperadora  = "#session.ID_EMPRESAOPERADORA#">
        <cfset mbArgs.fh_Registro          = dateformat(now(), 'yyyy-mm-dd')>
        <cfset mbArgs.id_proveedor         = #arguments.id_proveedor#>
        <cfset mbArgs.id_DeudorDiverso     = #arguments.id_DeudorDiverso#>
        <cfset mbArgs.id_AcreedorDiverso   = #arguments.id_AcreedorDiverso#>
        <cfset mbArgs.sn_AnticipoProveedor = 0>

        <cfif arguments.id_Proveedor NEQ nullValue()>
            <cfset mbArgs.nb_beneficiario = prov.NB_PROVEEDOR>

        <cfelseif arguments.id_DeudorDiverso NEQ nullValue()>
            <cfset mbArgs.nb_beneficiario = arguments.de_DeudorDiverso>

        <cfelseif arguments.id_AcreedorDiverso NEQ nullValue()>
            <cfset mbArgs.nb_beneficiario = arguments.de_AcreedorDiverso>

        </cfif>

        <!--- se manda a guardar a cuentasbancariasmov --->
        <cfinvoke component="#Application.RF.getPath('dao','cuentasbancarias')#"
            method="agregarmovimientocuentabancaria"
            argumentcollection="#mbArgs#"
            returnvariable="local.idcuentamov">

        <!--- Si el Medio de Pago es Cheque actualizar nu_Cheque de la cuenta bancaria--->
        <cfif pago.SN_CHEQUE EQ 'true'>
            <cfinvoke component="#Application.RF.getPath('dao','cuentasbancarias')#"
                method="udpatecheque"
                id_empresa ="#session.ID_EMPRESA#"
                id_cuentabancaria ="#arguments.id_cuentabancaria#"
                nu_cheque ="#nu_cheque#">
        </cfif>

        <!--- <cfset Local.id_Pago             = "#RSSiguientePago.RS.NextID#"> --->
        <!--- <cfset Local.id_Cheque               = "#RSSiguienteCheque.RS.NextID#"> --->
        <cfset Local.im_TotalPagoMN        =  #Arguments.im_TotalMovBancario# * #Arguments.im_TipoCambio#>
        <cfset Local.im_TotalMovBancarioMN =  #Arguments.im_TotalPago# * #Arguments.im_TipoCambio#>

        <!--- Agregar ProveedoresPago --->
        <cfset ppArgs                       = StructNew()>
        <cfset ppArgs.id_Empresa            = "#Arguments.id_Empresa#">
        <cfset ppArgs.id_Sucursal           = "#Arguments.id_Sucursal#">
        <cfset ppArgs.fh_Pago               = "#Arguments.fh_Pago#">
        <cfset ppArgs.id_Moneda             = "#Arguments.id_Moneda#">
        <cfset ppArgs.im_TipoCambio         = "#Arguments.im_TipoCambio#">
        <cfset ppArgs.im_TotalPago          = "#Arguments.im_TotalMovBancario#">
        <cfset ppArgs.im_TotalPagoMN        = "#Local.im_TotalPagoMN#"> <!--- Suma de los totales de las facturas --->
        <cfset ppArgs.im_TotalMovBancario   = "#Arguments.im_TotalPago#">
        <cfset ppArgs.im_TotalMovBancarioMN = "#Local.im_TotalMovBancarioMN#">
        <cfset ppArgs.sn_Anticipo           = "N">
        <cfset ppArgs.im_AnticipoAplicado   = "0">
        <cfset ppArgs.id_Proveedor          = "#Arguments.id_Proveedor#">
        <cfset ppArgs.id_DeudorDiverso      = "#Arguments.id_DeudorDiverso#">
        <cfset ppArgs.id_AcreedorDiverso    = "#Arguments.id_AcreedorDiverso#">
        <cfset ppArgs.id_CuentaBancaria     = "#Arguments.id_CuentaBancaria#">
        <cfset ppArgs.id_CuentaBancariamov  = "#local.idcuentamov.id_CuentaBancariamov#">
        <cfset ppArgs.nu_Cheque             = "#arguments.nu_Cheque#">
        <cfset ppArgs.id_Estatus            = "#Local.id_Estatus#">
        <cfset ppArgs.id_empleado           = "#SESSION.ID_EMPLEADO#">
        <cfset ppArgs.id_empresaempleado    = "#session.ID_EMPRESAOPERADORA#">
        <cfset ppArgs.id_PolizaCont         = "#Local.id_PolizaCont#">
        <cfset ppArgs.fh_PolizaCont         = "#Local.fh_PolizaCont#">
        <cfset ppArgs.id_PolizaCancel       = "#Local.id_PolizaCancel#">
        <cfset ppArgs.fh_PolizaCancel       = "#Local.fh_PolizaCancel#">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="agregarpagoproveedor"
            argumentcollection="#ppArgs#"
            returnvariable="local.nextidpago">

        <!--- AGREGAR EN PROVEEDORESPAGOSDETALLES--->

        <cfset Local.FoliosFacturas = ' '>

        <!--- Facturas (NF) --->
        <cfloop array="#arguments.Facturas#" index="Local.i">
            <!--- <cfloop index="i" from="1" to="#Arraylen(Facturas)#"> --->

            <!--- Armar Cadena de Folios de facturas --->

            <cfif(isDefined("Local.i.nu_FolioDocumento") ) >
                <cfif 1 LT #Arraylen(Facturas)# >
                    <cfif Local.FoliosFacturas EQ ' '>
                        <cfset Local.FoliosFacturas = Local.FoliosFacturas & Local.i.nu_FolioDocumento>
                    <cfelse>
                        <cfset Local.FoliosFacturas = Local.FoliosFacturas & ', ' & Local.i.nu_FolioDocumento >
                    </cfif>
                <cfelseif 1 EQ #Arraylen(Facturas)# >
                    <cfset Local.FoliosFacturas = Local.FoliosFacturas & Local.i.nu_FolioDocumento>
                </cfif>
            </cfif>

            <cfset ppdArgs                               = StructNew()>
            <cfset ppdArgs.id_Empresa                    = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal                   = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago                       = "#Local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago                        = #RSSiguientePagoDetalleNF.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago                   = #Local.i.CL_TIPODOCUMENTO#>
            <cfset ppdArgs.cl_TipoDocumento              = #Local.i.CL_TIPODOCUMENTO#>
            <cfset ppdArgs.id_Documento                  = #Local.i.ID_DOCUMENTO#>
            <cfset ppdArgs.im_Documento                  = #Local.i.IM_TOTAL#>
            <cfset ppdArgs.id_ProgramacionPago           = #Local.i.ID_PROGRAMACIONPAGO#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle    = #Local.i.ID_PROGRAMACIONPAGODETALLE#>
            <cfset ppdArgs.id_SucursalDocumento          = #Local.i.ID_SUCURSALDOCUMENTO#>

            <cfset ppdArgs.im_TipoCambio                 = #local.i.IM_TIPOCAMBIO#>
            <cfset ppdArgs.id_Moneda                     = #local.i.ID_MONEDA#>
            <cfset ppdArgs.im_DocumentoMN                = #Local.i.IM_TOTALMN#>

            <!--- Agregar Detalle NF--->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="agregarpagoproveedordetalle"
                argumentcollection="#ppdArgs#"
                returnvariable="local.nextidndpago">

            <cfif NOT Local.i.keyExists('ID_SOLICITUDPAGODETALLE') AND Local.i.CL_TIPODOCUMENTO EQ 'SP'>
                <cfset Local.i.ID_SOLICITUDPAGODETALLE = 1> <!--- Esto por que al momento de ponerlo, las solicitudes de pago solo tienen 1 detalle --->
            </cfif>

            <cfif NOT isDefined("Local.i.nu_FolioDocumento")>
                <cfset #Local.i.NU_FOLIODOCUMENTO# = ''>
            </cfif>
            <cfset im_Saldo = 0>
            <cfif  #Local.i.CL_TIPODOCUMENTO# EQ 'NA' >
                <cfset im_Saldo = ppdArgs.im_DocumentoMN>
            </cfif>
            <!--- Actualizar id_Estatus a PAGADA de la Factura si se paga totalmente--->
            <!--- <cfif facturas[i].im_total EQ facturas[i].im_total> --->
            <cfif  #Local.i.CL_TIPODOCUMENTO# EQ 'SP'>
                <cfinvoke component="#Application.RF.getPath('dao','SolicitudesPago')#"
                    method="cambiarEstatusDetalle"
                    id_Empresa    = "#session.ID_EMPRESA#"
                    id_SolicitudPago = "#Local.i.ID_SOLICITUDPAGO#"
                    id_SolicitudPagoDetalle = "#Local.i.ID_SOLICITUDPAGODETALLE#"
                    id_Estatus="1126">

                <cfif NOT isNull(Local.i.ID_SOLICITUDPAGO)>
                    <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                        method="ActualizarEstatusPP"
                        id_Empresa="#session.ID_EMPRESA#"
                        id_SolicitudPago="#Local.i.ID_SOLICITUDPAGO#"
                        id_Estatus="1126">
                </cfif>
            <cfelse>
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="updatedocumentoproveedor"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#Local.i.ID_SUCURSALDOCUMENTO#"
                        cl_tipodocumento ="#Local.i.CL_TIPODOCUMENTO#"
                        id_documento ="#Local.i.ID_DOCUMENTO#"
                        id_proveedor ="#Local.i.ID_PROVEEDOR#"
                        id_DeudorDiverso ="#Local.i.ID_DEUDORDIVERSO#"
                        id_AcreedorDiverso ="#Local.i.ID_ACREEDORDIVERSO#"
                        nu_foliodocumento ="#Local.i.NU_FOLIODOCUMENTO#"
                        im_Saldo ="#im_Saldo#"
                        sn_Pagado ="1"
                        <!--- id_Estatus="1105" --->
                        <!--- Estatus pagada, igual a la programacion --->
                        id_Estatus="1105"
                        >
                    <!--- </cfif> --->

                <cfset dpmArgs                       = StructNew()>
                <cfset dpmArgs.id_Empresa            = "#Arguments.id_Empresa#">
                <cfset dpmArgs.id_Sucursal           = "#Local.i.id_SucursalDocumento#">
                <cfset dpmArgs.cl_TipoDocumento      = "#Local.i.cl_TipoDocumento#">
                <cfset dpmArgs.id_Documento          = "#Local.i.id_Documento#">
                <!--- <cfset dpmArgs.nd_Movimiento   = "#RSSiguienteDPM_NF.RS.NextID#"> --->
                <cfset dpmArgs.fh_Movimiento         = "#Arguments.fh_Pago#">
                <cfset dpmArgs.cl_Naturaleza         = "C">
                <cfset dpmArgs.im_Movimiento         = "#Local.i.im_total#">
                <cfset dpmArgs.id_OrigenMovimiento   = 4>
                <cfset dpmArgs.id_Pago               = "#Local.nextidpago.id_pago#">
                <!--- <cfset dpmArgs.nd_Pago         = "#RSSiguientePagoDetalleNF.RS.NextID#"> --->

                <cfset dpmArgs.nd_Pago               = "#local.nextidndpago.nd_Pago#">
                <cfset dpmArgs.sn_AfectacionContable = 0>
                <cfset dpmArgs.id_Estatus            = 1105>

                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                            method="agregardocumentoproveedoresmovimientos"
                            argumentcollection="#dpmArgs#">
            </cfif>
        </cfloop>

        <!--- Notas de Credito (NC) --->
        <cfloop index="j" from="1" to="#Arraylen(Notas)#">

            <cfset ppdArgs                               = StructNew()>
            <cfset ppdArgs.id_Empresa                    = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal                   = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago                       = "#Local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago                        = #RSSiguientePagoDetalleNC.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago                   = 'NC'>
            <cfset ppdArgs.cl_TipoDocumento              = #Notas[j].CL_TIPODOCUMENTO#>
            <cfset ppdArgs.id_Documento                  = #Notas[j].ID_DOCUMENTO#>
            <cfset ppdArgs.im_Documento                  = #Notas[j].IM_TOTAL#>
            <cfset ppdArgs.id_ProgramacionPago           = #Notas[j].ID_PROGRAMACIONPAGO#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle    = #Notas[j].ID_PROGRAMACIONPAGODETALLE#>
            <cfset ppdArgs.id_SucursalDocumento          = #Notas[j].ID_SUCURSALDOCUMENTO#>
            <cfset ppdArgs.im_DocumentoMN                = #Notas[j].IM_TOTAL# * #Arguments.IM_TIPOCAMBIO#>

            <cfset ppdArgs.id_Moneda                     = "#Arguments.id_Moneda#">
            <cfset ppdArgs.im_TipoCambio                 = "#Arguments.im_TipoCambio#">

            <!--- Agregar Detalle NC --->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="agregarpagoproveedordetalle"
                        argumentcollection="#ppdArgs#"
                        returnvariable="local.nextidndpago">

            <!--- Saldar Nota de Credito  --->
            <!--- Actualizar id_Estatus a PAGADA de la Nota de Credito si se paga totalmente--->
            <!--- <cfif Notas[j].im_total EQ Notas[j].im_total> --->
            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                    method="updatedocumentoproveedor"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#Notas[j].id_SucursalDocumento#"
                    cl_tipodocumento ="#Notas[j].cl_TipoDocumento#"
                    id_documento ="#Notas[j].id_Documento#"
                    id_proveedor ="#Notas[j].id_proveedor#"
                    nu_foliodocumento ="#Notas[j].nu_FolioDocumento#"
                    im_Saldo ="0"
                    sn_Pagado ="1"
                    <!--- id_Estatus="1105" --->
                    id_Estatus="1105"
                    >
            <!--- </cfif> --->

            <cfset dpmArgs                     = StructNew()>
            <cfset dpmArgs.id_Empresa          = "#Arguments.id_Empresa#">
            <cfset dpmArgs.id_Sucursal         = "#Arguments.id_SucursalDocumento#">
            <cfset dpmArgs.cl_TipoDocumento    = "#Notas[j].cl_TipoDocumento#">
            <cfset dpmArgs.id_Documento        = "#Notas[j].id_Documento#">
            <!--- <cfset dpmArgs.nd_Movimiento       = "#RSSiguienteDPM_NC.RS.NextID#"> --->
            <cfset dpmArgs.fh_Movimiento       = "#Arguments.fh_Pago#">
            <cfset dpmArgs.cl_Naturaleza       = "A">
            <cfset dpmArgs.im_Movimiento       = "#Notas[j].im_total#">
            <cfset dpmArgs.id_OrigenMovimiento = 2>
            <cfset dpmArgs.id_Pago               = "#Local.nextidpago.id_Pago#">
            <cfset dpmArgs.nd_Pago               = "#local.nextidndpago.nd_pago#">
            <cfset dpmArgs.sn_AfectacionContable = 0>
            <cfset dpmArgs.id_Estatus            = 1103>

            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="agregardocumentoproveedoresmovimientos"
                        argumentcollection="#dpmArgs#">
        </cfloop>

        <!--- Anticipos (AN) --->
        <cfloop index="j" from="1" to="#Arraylen(Anticipos)#">

            <cfset ppdArgs                               = StructNew()>
            <cfset ppdArgs.id_Empresa                    = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal                   = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago                       = "#local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago            = #RSSiguientePagoDetalleAN.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago                   = 'NA'>
            <cfset ppdArgs.id_PagoAnticipo               = #Anticipos[j].ID_PAGO#>
            <cfset ppdArgs.im_Documento                  = #Anticipos[j].IM_TOTAL#>
            <cfset ppdArgs.id_ProgramacionPago           = #Anticipos[j].ID_PROGRAMACIONPAGO#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle    = #Anticipos[j].ID_PROGRAMACIONPAGODETALLE#>
            <cfset ppdArgs.id_SucursalDocumento          = #Anticipos[j].ID_SUCURSALDOCUMENTO#>
            <cfset ppdArgs.cl_Tipodocumento              = #Anticipos[j].CL_TIPODOCUMENTO#>
            <cfset ppdArgs.id_Documento                  = #Anticipos[j].ID_DOCUMENTO#>
            <!--- <cfset ppdArgs.im_DocumentoMN                  = #Anticipos[j].IM_TOTAL# * #Anticipos[j].IM_TIPOCAMBIO#> ---><!---#Anticipos[j].im_Monto# * #Arguments.im_TipoCambio#>--->
            <cfset ppdArgs.im_TipoCambio                 = #Anticipos[j].IM_TIPOCAMBIO#>
            <cfset ppdArgs.id_Moneda                     = #Anticipos[j].ID_MONEDA#>
            <cfset ppdArgs.im_DocumentoMN                = #Anticipos[j].IM_TOTALMN#>

            <cfset ppdArgs.id_Moneda                     = "#Arguments.id_Moneda#">
            <cfset ppdArgs.im_TipoCambio                 = "#Arguments.im_TipoCambio#">

            <!--- Agregar Detalle AN --->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="agregarpagoproveedordetalle"
                    argumentcollection="#ppdArgs#"
                    returnvariable="local.nextidndpago">

            <!--- Saldar Anticipos  --->
            <!--- Actualizar id_Estatus a PAGADA de la Nota de Credito si se paga totalmente--->
            <!--- <cfif Anticipos[j].im_total EQ Anticipos[j].im_total> --->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method ="updatepagosproveedoresestatus"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_sucursal     ="#Anticipos[j].ID_SUCURSALDOCUMENTO#"
                    id_proveedor    ="#arguments.id_proveedor#"
                    id_pago         ="#anticipos[j].id_pago#"
                    sn_anticipo     ="S"
                    <!--- id_estatus        ="1105" --->
                    id_Estatus="1105"
                    im_anticipoaplicado ="#anticipos[j].im_total#"
                    opc             ="2">
            <!--- <cfelse>
                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method ="updatepagosproveedoresestatus"
                        id_empresa      ="#session.ID_EMPRESA#"
                        id_sucursal     ="#SESSION.ID_SUCURSAL#"
                        id_proveedor    ="#arguments.id_proveedor#"
                        id_pago         ="#anticipos[j].id_pago#"
                        sn_anticipo     ="S"
                        im_anticipoaplicado ="#im_anticipoaplicado + anticipos[j].im_Monto#"
                        opc="2">
            </cfif> --->
           <!---  <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="updatedocumentoproveedor"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        cl_tipodocumento ="#anticipos[j].cl_TipoDocumento#"
                        id_documento ="#anticipos[j].id_Documento#"
                        im_Saldo ="0"
                        <!--- id_Estatus="1105" --->
                        id_Estatus="1105"
                        > --->
        </cfloop>

        <!--- Generar Poliza del Pago al Proveedor --->
        <cfset pArgs                = StructNew()>
        <cfset pArgs.id_Empresa     = "#Arguments.id_Empresa#">
        <cfset pArgs.id_Sucursal    = "#Arguments.id_Sucursal#">
        <cfset pArgs.id_Pago        = "#local.nextidpago.id_pago#">
        <cfset pArgs.id_Usuario     = "#session.ID_USUARIO#">
        <cfset pArgs.fh_Poliza      = "#Arguments.fh_Pago#">
        <cfset pArgs.CadenaFacturas = "#Local.FoliosFacturas#">

       <!---  <cfinvoke component="#Application.RF.getPath('dao','Polizas')#"
                    method="agregarpolizas"
                    argumentcollection="#pArgs#"> --->

        <!---/**
        * Se realiza la actualizacion de estatus de la requisicionCMF
        * (si es que es una, lo verifica dentro del SP)
        */--->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                  method="ActualizarEstatusCMF"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_Sucursal="#Arguments.id_Sucursal#"
                  id_Pago="#local.nextidpago.id_pago#"
                  id_estatus="1105">

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->
        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 13-02-2016 --->
    <cffunction name="generarexcelemisiondepagos"    access="public"     returntype="Any">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfif isDefined("estatus")>
            <cfset arguments.nb_estatus = estatus.DE_ESTATUS>
            <cfset arguments.id_estatus = estatus.ID_ESTATUS>
        <cfelse>
            <cfset arguments.nb_estatus = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.proveedor")>
            <cfset arguments.nb_proveedor = proveedor.NB_PROVEEDOR>
            <cfset arguments.id_proveedor = proveedor.ID_PROVEEDOR>
        <cfelse>
            <cfset arguments.nb_proveedor = 'Todos los proveedores'>
        </cfif>


        <cfset ano =Mid(#fh_inicio#,1,4)>
        <cfset mes =Mid(#fh_inicio#,5,2)>
        <cfset dia =Mid(#fh_inicio#,7,2)>
        <cfset arguments.fh_inicioreporte = dia&'/'&mes&'/'&ano>

        <cfset ano1 =Mid(Arguments.fh_fin,1,4)>
        <cfset mes1 =Mid(Arguments.fh_fin,5,2)>
        <cfset dia1 =Mid(Arguments.fh_fin,7,2)>

        <cfset Arguments.fh_finreporte = dia1&'/'&mes1&'/'&ano1>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                method             ="getdatareporteemisiondepagos"
                argumentcollection ="#arguments#"
                returnvariable     ="local.data">

        <cfif local.data.recordcount eq 0>
            <cfset variables.rbr.setError('Los filtros seleccionados no proporcionaron información para generar el excel.')>
            <cfreturn variables.rbr>
        </cfif>


        <cfset variables.RBR.setQuery(Local.data)>
        <cfreturn Variables.RBR>

        <!--- ///////////////////////////////////////////////////////////////////////////////////////////////////////////
                          SE DESHABILITA POI
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////--->

        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteEmisionPagos#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <!--- Import the POI tag library. --->
        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
        </cfif>
        <!---
            Create an excel document and store binary data into
            REQUEST variable.
        --->

        <poi:document
            name="REQUEST.ExcelData"
            file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">


            <!--- Define style classes. --->
            <poi:classes>
                <poi:class
                    name="title"
                    style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
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
                    style="border-bottom:2px; border-left:2px; border-right:2px;"
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
                    freezerow="12"
                    orientation="landscape"
                    zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 50px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 300px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                    </poi:columns>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Emisiones de pago a proveedor"colspan="3"  class="title"/>
                        <poi:cell value=''>
                        <poi:cell value=''>
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
                        <poi:cell value=''/>
                        <poi:cell value='Proveedor:' class="header"/>
                        <poi:cell value='#arguments.nb_proveedor#'/>
                        <poi:cell value='Estatus:' class="header"/>
                        <poi:cell value='#arguments.nb_estatus#'/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value='Fecha inicio:' class="header"/>
                        <poi:cell value='#arguments.fh_inicioreporte#'/>
                        <poi:cell value='Fecha fin:' class="header"/>
                        <poi:cell value='#arguments.fh_finreporte#'/>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Header row. --->
                    <poi:row >
                        <poi:cell value=''/>
                        <poi:cell value="Folio"         class="header fondo "/>
                        <poi:cell value="Folio póliza"  class="header fondo "/>
                        <poi:cell value="Beneficiario"  class="header fondo "/>
                        <poi:cell value="Moneda"        class="header fondo "/>
                        <poi:cell value="Importe"       class="header fondo "/>
                        <poi:cell value="Medio de pago"         class="header fondo "/>
                        <poi:cell value="Estatus"       class="header fondo "/>
                    </poi:row>

                    <!--- Output the people. --->
                    <cfloop query="local.data">
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="#local.data.ID_PAGO#" class="Contenido borders" style="text-align:right;"/>
                            <poi:cell value="#local.data.ID_POLIZACONT#" class="Contenido borders" style="text-align:right;"/>
                            <poi:cell value="#local.data.NB_BENEFICIARIO#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#local.data.NB_MONEDA#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#LSCurrencyFormat(local.data.IM_TOTALPAGOMN)#" style="text-align:right;" class="Contenido borders"/>
                            <poi:cell value="#local.data.MEDIO#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#local.data.DE_ESTATUS#" style="text-align:left" class="Contenido borders"/>
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
                  nu_colWidth="2">


        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc 13-02-2016 --->
    <cffunction name="generarpdfemisiondepagos"    access="public"     returntype="Any">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfif isDefined("estatus")>
            <cfset arguments.nb_estatus = estatus.DE_ESTATUS>
            <cfset arguments.id_estatus = estatus.ID_ESTATUS>
        <cfelse>
            <cfset arguments.nb_estatus = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.proveedor")>
            <cfset arguments.nb_proveedor = proveedor.NB_PROVEEDOR>
            <cfset arguments.id_proveedor = proveedor.ID_PROVEEDOR>
        <cfelse>
            <cfset arguments.nb_proveedor = 'Todos los proveedores'>
            <cfset arguments.id_proveedor = 'NULL'>
        </cfif>

        <cfset ano =Mid(#fh_inicio#,1,4)>
        <cfset mes =Mid(#fh_inicio#,5,2)>
        <cfset dia =Mid(#fh_inicio#,7,2)>
        <cfset arguments.fh_inicioreporte = dia&'/'&mes&'/'&ano>

        <cfset ano1 =Mid(Arguments.fh_fin,1,4)>
        <cfset mes1 =Mid(Arguments.fh_fin,5,2)>
        <cfset dia1 =Mid(Arguments.fh_fin,7,2)>

        <cfset Arguments.fh_finreporte = dia1&'/'&mes1&'/'&ano1>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                method             ="getdatareporteemisiondepagos"
                argumentcollection ="#arguments#"
                returnvariable     ="local.data">

        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('Los filtros seleccionados no proporcionaron información para generar el pdf.')>
            <cfreturn variables.RBR>
        </cfif>


        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="Emisiondepagos#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="emisiondepagos">
            <cfinclude template="../../templates/reportes/Proveedores/emisiondepagos.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#emisiondepagos#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc 17-02-2016 --->
    <cffunction name="getinformacionemisionpago" access="public" returntype="Any">
        <cfargument name="data"    type="struct" required="true"/>

        <cfset arguments.id_Empresa = #session.ID_EMPRESA#>
        <cfset arguments.id_Sucursal = #SESSION.ID_SUCURSAL#>
        <cfset arguments.id_pago = data.ID_PAGO>

        <!--- <cfdump var="#data#" /><cfabort /> --->
        <cfset datos = structNew()>
        <!--- Se obtienen las facturas de proveedor --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                    method="getfacturas"
                    argumentcollection="#arguments#"
                    returnvariable="local.fact">
        <cfset datos.facturacion = #local.fact#>

        <!--- Se obtienen las notas de credito por proveedor --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                    method="getnotas"
                    argumentcollection="#arguments#"
                    returnvariable="local.nc">

        <cfset datos.notascredito = #local.nc#>

        <!--- jc Se obtienen los anticipos por proveedor --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                    method="getanticipos"
                    argumentcollection="#arguments#"
                    returnvariable="local.ant">

        <cfset datos.anticipos = #local.ant#>

        <!--- se manda por la informacion de las cuentas contables --->
        <cfif isDefined("data.ID_CUENTABANCARIA")>
            <cfif data.ID_CUENTABANCARIA EQ '' OR data.ID_CUENTABANCARIA EQ 'null'>
                <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                        method="getinformacioncuentascontables"
                        argumentcollection="#arguments#"
                        returnvariable="local.infocuentascontables">

                <cfset datos.cuentacontable = #local.infocuentascontables#>
            </cfif>
        </cfif>

        <cfset variables.RBR.setData(datos)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 13-02-2016 --->
    <cffunction  name="guardaremisiondepagosincheque"   access="public" returntype="Any">
        <cfargument name='prov'                 type='struct'   required='yes'>
        <cfargument name='moneda'               type='struct'   required='yes'>
        <cfargument name='fh_pago'              type='string'   required='yes'>
        <cfargument name='facturas'             type='array'    required='yes'>
        <cfargument name='notas'                type='array'    required='yes'>
        <cfargument name='anticipos'            type='array'    required='no'>
        <cfargument name="im_TotalPago"         type="numeric" required="yes">
        <cfargument name="im_TotalMovBancario"  type="numeric" required="yes">
        <cfargument name="bandera"              type="boolean" required="no" default="false">
        <cfargument name="id_Dispersion"        type="numeric" required="no" default="0">
        <cfargument name='id_cuenta'            type='numeric'  required='yes'>
        <cfargument name='id_scuenta'           type='numeric'  required='yes'>
        <cfargument name='id_sscuenta'          type='numeric'  required='yes'>
        <cfargument name='id_ssscuenta'         type='numeric'  required='yes'>

        <cfset arguments.id_Empresa = "#session.ID_EMPRESA#">
        <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">

        <cfif isDefined("prov.ID_PROVEEDOR")>
            <cfset arguments.id_Proveedor = prov.ID_PROVEEDOR >
        </cfif>

        <cfif isDefined("prov.NB_PROVEEDOR")>
            <cfset arguments.nb_Proveedor = prov.NB_PROVEEDOR >
        </cfif>

        <cfset local.tfac = 0>
        <cfset local.tnot = 0>
        <cfset local.tant = 0>

        <!--- se hace un recorrido para validar de nuevo los montos de las notas y anticipos --->
        <cfloop from="1" to="#arrayLen(arguments.facturas)#" index="local.i">
            <cfset local.tfac += arguments.facturas[local.i].IM_TOTAL >
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.notas)#" index="local.i">
            <cfset local.tnot += arguments.notas[local.i].IM_TOTAL >
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.anticipos)#" index="local.i">
            <cfset local.tant += arguments.anticipos[local.i].IM_TOTAL >
        </cfloop>

        <cfif (local.tnot + local.tant) GT local.tfac>
            <cfset variables.rbr.setError('El monto de las notas de créditos mas los anticipos debe ser menor al total de las facturas seleccionadas.')>
            <cfreturn>
        </cfif>


        <cfset arguments.im_TipoCambio = moneda.IM_TIPOCAMBIO>
        <cfset arguments.id_moneda = moneda.ID_MONEDA>

        <cfset bo_EmitirPagoProveedor = StructNew()>

        <!--- Agregar Pago General --->
        <cfset Local.im_AnticipoAplicado = 0>
        <cfset Local.id_Estatus          = 1105>
        <cfset Local.id_PolizaCont       = 0>
        <cfset Local.fh_PolizaCont       ='1900-01-01'>
        <cfset Local.id_PolizaCancel     = 0>
        <cfset Local.fh_PolizaCancel     ='1900-01-01'>

        <!--- <cfset Local.id_Pago          = "#RSSiguientePago.RS.NextID#"> --->
        <!--- <cfset Local.id_Cheque        = "#RSSiguienteCheque.RS.NextID#"> --->
        <cfset Local.im_TotalPagoMN        = #Arguments.im_TotalPago# * #Arguments.im_TipoCambio#>
        <cfset Local.im_TotalMovBancarioMN = #Arguments.im_TotalPago# * #Arguments.im_TipoCambio#>

        <!--- Agregar ProveedoresPago --->
        <cfset ppArgs                       = StructNew()>
        <cfset ppArgs.id_Empresa            = "#Arguments.id_Empresa#">
        <cfset ppArgs.id_Sucursal           = "#Arguments.id_Sucursal#">
        <!--- <cfset ppArgs.id_Pago         = "#Local.id_Pago#"> --->
        <cfset ppArgs.fh_Pago               = "#Arguments.fh_Pago#">
        <cfset ppArgs.id_Moneda             = "#Arguments.id_Moneda#">
        <cfset ppArgs.im_TipoCambio         = "#Arguments.im_TipoCambio#">
        <cfset ppArgs.im_TotalPago          = "#Arguments.im_TotalPago#">
        <cfset ppArgs.im_TotalPagoMN        = "#Local.im_TotalPagoMN#"> <!--- Suma de los totales de las facturas --->
        <cfset ppArgs.im_TotalMovBancario   = "0"><!--- Total con NotasCredito y Anticipos (Total del cheque) --->
        <cfset ppArgs.im_TotalMovBancarioMN = "0">
        <cfset ppArgs.sn_Anticipo           = "N">
        <cfset ppArgs.im_AnticipoAplicado   = "0">
        <cfset ppArgs.id_Proveedor          = "#Arguments.id_Proveedor#">
        <!--- <cfset ppArgs.id_CuentaBancaria   = "#Arguments.id_CuentaBancaria#">
        <cfset ppArgs.id_CuentaBancariamov  = "#local.idcuentamov.id_CuentaBancariamov#"> --->
        <!--- <cfset ppArgs.id_Cheque           = "#Local.id_Cheque#"> --->
        <!--- <cfset ppArgs.nu_Cheque           = "#arguments.nu_Cheque#"> --->
        <!--- <cfset ppArgs.id_Modulo               = "#Arguments.id_Modulo#"> --->
        <!--- <cfset ppArgs.id_TipoMovimiento   = "#Arguments.id_TipoMovimiento#"> --->
        <cfset ppArgs.id_Estatus            = "#Local.id_Estatus#">
        <!--- <cfset ppArgs.id_Usuario          = "#Arguments.id_Usuario#"> --->
        <cfset ppArgs.id_empleado           = "#SESSION.ID_EMPLEADO#">
        <cfset ppArgs.id_empresaempleado    = "#session.ID_EMPRESAOPERADORA#">
        <cfset ppArgs.id_PolizaCont         = "#Local.id_PolizaCont#">
        <cfset ppArgs.fh_PolizaCont         = "#Local.fh_PolizaCont#">
        <cfset ppArgs.id_PolizaCancel       = "#Local.id_PolizaCancel#">
        <cfset ppArgs.fh_PolizaCancel       = "#Local.fh_PolizaCancel#">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="agregarpagoproveedor"
                    argumentcollection="#ppArgs#"
                    returnvariable="local.nextidpago">

        <!--- AGREGAR EN PROVEEDORESPAGOSDETALLES--->
        <cfset Local.FoliosFacturas = ' '>

        <cfset ccArgs                = StructNew()>
        <cfset ccArgs.id_Empresa     = "#Arguments.id_Empresa#">
        <cfset ccArgs.id_Sucursal    = "#Arguments.id_Sucursal#">
        <cfset ccArgs.id_Pago        = "#Local.nextidpago.id_pago#">
        <!--- <cfset ccArgs.nd_Pago          = "#RSSiguientePagoDetalleCC.RS.NextID#"> --->
        <cfset ccArgs.cl_TipoPago    = 'CC'>
        <cfset ccArgs.id_Cuenta      = "#Arguments.id_Cuenta#">
        <cfset ccArgs.id_SCuenta     = "#Arguments.id_SCuenta#">
        <cfset ccArgs.id_SSCuenta    = "#Arguments.id_SSCuenta#">
        <cfset ccArgs.id_SSSCuenta   = "#Arguments.id_SSSCuenta#">
        <!---<cfset ccArgs.id_Documento     = #facturas[i].id_Documento#>--->
        <cfset ccArgs.im_Documento   = "#Arguments.im_TotalPago#">
        <cfset ccArgs.im_DocumentoMN = "#Local.im_TotalMovBancarioMN#">


        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="upC_ProveedoresPagosDetalle"
                argumentcollection="#ccArgs#"
                returnvariable="local.nextndpago">


        <!--- Facturas (NF) --->
        <!--- <cfloop index="i" from="1" to="#Arraylen(Facturas)#"> --->
          <cfloop array="#arguments.Facturas#" index="Local.i">

            <!--- Armar Cadena de Folios de facturas --->
             <cfif(isDefined("Local.i.nu_FolioDocumento") ) >
            <cfif 1 LT #Arraylen(Facturas)# >
                <cfif Local.FoliosFacturas EQ ' '>
                    <cfset Local.FoliosFacturas = Local.FoliosFacturas & Local.i.nu_FolioDocumento>
                <cfelse>
                    <cfset Local.FoliosFacturas = Local.FoliosFacturas & ', ' & Local.i.nu_FolioDocumento >
                </cfif>
             <cfelseif 1 EQ #Arraylen(Facturas)# >
                    <cfset Local.FoliosFacturas = Local.FoliosFacturas & Local.i.nu_FolioDocumento>
            </cfif>
          </cfif>

            <cfset ppdArgs                  = StructNew()>
            <cfset ppdArgs.id_Empresa       = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal      = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago          = "#Local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago            = #RSSiguientePagoDetalleNF.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago      = 'NF'>
            <cfset ppdArgs.cl_TipoDocumento = #Local.i.cl_Tipodocumento#>
            <cfset ppdArgs.id_Documento     = #Local.i.id_Documento#>
            <cfset ppdArgs.im_Documento     = #Local.i.im_total#>
            <cfset ppdArgs.im_DocumentoMN   = #Local.i.im_total# * #Arguments.im_TipoCambio#>
            <cfset ppdArgs.id_ProgramacionPago  = #Local.i.id_ProgramacionPago#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle   = #Local.i.id_ProgramacionPagoDetalle#>
            <cfset ppdArgs.id_SucursalDocumento     = #Local.i.id_SucursalDocumento#>

            <cfset ppdArgs.id_Moneda                     = "#Arguments.id_Moneda#">
            <cfset ppdArgs.im_TipoCambio                 = "#Arguments.im_TipoCambio#">


            <!--- Agregar Detalle NF--->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="agregarpagoproveedordetalle"
                    argumentcollection="#ppdArgs#"
                    returnvariable="local.nextidndpago">

            <cfif NOT isDefined("Local.i.nu_FolioDocumento")>
                <cfset #Local.i.NU_FOLIODOCUMENTO# = ''>
            </cfif>

            <cfset im_Saldo = 0>
            <cfif  #Local.i.CL_TIPODOCUMENTO# EQ 'NA' >
                 <cfset im_Saldo = ppdArgs.im_DocumentoMN>
              </cfif>

            <!--- Actualizar id_Estatus a PAGADA de la Factura si se paga totalmente--->
            <cfif facturas[i].im_total EQ facturas[i].im_total>
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="updatedocumentoproveedor"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        cl_tipodocumento ="#Local.i.cl_tipodocumento#"
                        id_documento ="#Local.i.id_documento#"
                        id_proveedor ="#Local.i.id_proveedor#"
                        nu_foliodocumento ="#Local.i.nu_foliodocumento#"
                        id_Estatus="1105"
                        im_Saldo ="#im_Saldo#"
                        sn_Pagado ="1">
            </cfif>

            <cfset dpmArgs                       = StructNew()>
            <cfset dpmArgs.id_Empresa            = "#Arguments.id_Empresa#">
            <cfset dpmArgs.id_Sucursal           = "#Arguments.id_Sucursal#">
            <cfset dpmArgs.cl_TipoDocumento      = "#Local.i.cl_TipoDocumento#">
            <cfset dpmArgs.id_Documento          = "#Local.i.id_Documento#">
            <!--- <cfset dpmArgs.nd_Movimiento   = "#RSSiguienteDPM_NF.RS.NextID#"> --->
            <cfset dpmArgs.fh_Movimiento         = "#Arguments.fh_Pago#">
            <cfset dpmArgs.cl_Naturaleza         = "C">
            <cfset dpmArgs.im_Movimiento         = "#Local.i.im_total#">
            <cfset dpmArgs.id_OrigenMovimiento   = 4>
            <cfset dpmArgs.id_Pago               = "#Local.nextidpago.id_pago#">
            <!--- <cfset dpmArgs.nd_Pago         = "#RSSiguientePagoDetalleNF.RS.NextID#"> --->
            <cfset dpmArgs.nd_Pago               = "#local.nextidndpago.nd_Pago#">
            <cfset dpmArgs.sn_AfectacionContable = 0>
            <cfset dpmArgs.id_Estatus            = 1103>

            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="agregardocumentoproveedoresmovimientos"
                        argumentcollection="#dpmArgs#">
        </cfloop>

        <!--- Notas de Credito (NC) --->
        <cfloop index="j" from="1" to="#Arraylen(Notas)#">
            <cfset ppdArgs                  = StructNew()>
            <cfset ppdArgs.id_Empresa       = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal      = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago          = "#Local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago            = #RSSiguientePagoDetalleNC.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago      = 'NC'>
            <cfset ppdArgs.cl_TipoDocumento = #Notas[j].cl_Tipodocumento#>
            <cfset ppdArgs.id_Documento     = #Notas[j].id_Documento#>
            <cfset ppdArgs.im_Documento     = #Notas[j].im_total#>
            <cfset ppdArgs.im_DocumentoMN   = #Notas[j].im_total# * #Arguments.im_TipoCambio#>
            <cfset ppdArgs.id_ProgramacionPago  = #Notas[j].id_ProgramacionPago#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle   = #Notas[j].id_ProgramacionPagoDetalle#>
            <cfset ppdArgs.id_SucursalDocumento     = #Notas[j].id_SucursalDocumento#>

            <cfset ppdArgs.id_Moneda                     = "#Arguments.id_Moneda#">
            <cfset ppdArgs.im_TipoCambio                 = "#Arguments.im_TipoCambio#">

            <!--- Agregar Detalle NC --->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method="agregarpagoproveedordetalle"
                        argumentcollection="#ppdArgs#"
                        returnvariable="local.nextidndpago">

            <!--- Saldar Nota de Credito  --->
            <!--- Actualizar id_Estatus a PAGADA de la Nota de Credito si se paga totalmente--->
            <!--- <cfif Notas[j].im_total EQ Notas[j].im_total> --->
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="updatedocumentoproveedor"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        cl_tipodocumento ="#Notas[j].cl_TipoDocumento#"
                        id_documento ="#Notas[j].id_Documento#"
                        id_proveedor ="#Notas[j].id_proveedor#"
                        nu_foliodocumento ="#Notas[j].nu_FolioDocumento#"
                        id_Estatus="1105"
                        im_Saldo ="0"
                        sn_Pagado ="1">
            <!--- /cfif>
                 --->
            <cfset dpmArgs                     = StructNew()>
            <cfset dpmArgs.id_Empresa          = "#Arguments.id_Empresa#">
            <cfset dpmArgs.id_Sucursal         = "#Arguments.id_Sucursal#">
            <cfset dpmArgs.cl_TipoDocumento    = "#Notas[j].cl_TipoDocumento#">
            <cfset dpmArgs.id_Documento        = "#Notas[j].id_Documento#">
            <!--- <cfset dpmArgs.nd_Movimiento       = "#RSSiguienteDPM_NC.RS.NextID#"> --->
            <cfset dpmArgs.fh_Movimiento       = "#Arguments.fh_Pago#">
            <cfset dpmArgs.cl_Naturaleza       = "A">
            <cfset dpmArgs.im_Movimiento       = "#Notas[j].im_total#">
            <cfset dpmArgs.id_OrigenMovimiento = 2>
            <cfset dpmArgs.id_Pago               = "#Local.nextidpago.id_Pago#">
            <cfset dpmArgs.nd_Pago               = "#local.nextidndpago.nd_pago#">
            <cfset dpmArgs.sn_AfectacionContable = 0>
            <cfset dpmArgs.id_Estatus            = 1103>

            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="agregardocumentoproveedoresmovimientos"
                        argumentcollection="#dpmArgs#">
        </cfloop>

        <!--- Anticipos (AN) --->
        <cfloop index="j" from="1" to="#Arraylen(Anticipos)#">

            <cfset ppdArgs                  = StructNew()>
            <cfset ppdArgs.id_Empresa       = "#Arguments.id_Empresa#">
            <cfset ppdArgs.id_Sucursal      = "#Arguments.id_Sucursal#">
            <cfset ppdArgs.id_Pago          = "#local.nextidpago.id_pago#">
            <!--- <cfset ppdArgs.nd_Pago            = #RSSiguientePagoDetalleAN.RS.NextID#> --->
            <cfset ppdArgs.cl_TipoPago      = 'NA'>
            <cfset ppdArgs.id_PagoAnticipo  = #Anticipos[j].id_Pago#>
            <cfset ppdArgs.im_Documento     = #Anticipos[j].im_total#>
            <cfset ppdArgs.im_DocumentoMN   = #Anticipos[j].im_total# * #Anticipos[j].im_TipoCambio#><!---#Anticipos[j].im_Monto# * #Arguments.im_TipoCambio#>--->
            <cfset ppdArgs.id_ProgramacionPago  = #Anticipos[j].id_ProgramacionPago#>
            <cfset ppdArgs.id_ProgramacionPagoDetalle   = #Anticipos[j].id_ProgramacionPagoDetalle#>
            <cfset ppdArgs.id_SucursalDocumento     = #Anticipos[j].id_SucursalDocumento#>

            <cfset ppdArgs.id_Moneda                     = "#Arguments.id_Moneda#">
            <cfset ppdArgs.im_TipoCambio                 = "#Arguments.im_TipoCambio#">

            <!--- Agregar Detalle AN --->
            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="agregarpagoproveedordetalle"
                    argumentcollection="#ppdArgs#"
                    returnvariable="local.nextidndpago">

            <!--- Saldar Anticipos  --->
            <!--- Actualizar id_Estatus a PAGADA de la Nota de Credito si se paga totalmente--->
            <!--- <cfif Anticipos[j].im_total EQ Anticipos[j].im_total> --->
                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method ="updatepagosproveedoresestatus"
                        id_empresa      ="#session.ID_EMPRESA#"
                        id_sucursal     ="#SESSION.ID_SUCURSAL#"
                        id_proveedor    ="#arguments.id_proveedor#"
                        id_pago         ="#anticipos[j].id_pago#"
                        sn_anticipo     ="S"
                        id_estatus      ="1105"
                        im_anticipoaplicado ="#anticipos[j].im_total#"
                        opc             ="1"
                        >
            <!--- <cfelse>
                <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                        method ="updatepagosproveedoresestatus"
                        id_empresa      ="#session.ID_EMPRESA#"
                        id_sucursal     ="#SESSION.ID_SUCURSAL#"
                        id_proveedor    ="#arguments.id_proveedor#"
                        id_pago         ="#anticipos[j].id_pago#"
                        sn_anticipo     ="S"
                        im_anticipoaplicado ="#im_anticipoaplicado + anticipos[j].im_total#"
                        opc="2">
            </cfif> --->
            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                        method="updatedocumentoproveedor"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        cl_tipodocumento ="#anticipos[j].cl_TipoDocumento#"
                        id_documento ="#anticipos[j].id_Documento#"
                        im_Saldo ="0"
                        <!--- id_Estatus="1105" --->
                        id_Estatus="1105"
                        >
        </cfloop>

        <!--- Generar Poliza del Pago al Proveedor --->
        <cfset pArgs                = StructNew()>
        <cfset pArgs.id_Empresa     = "#Arguments.id_Empresa#">
        <cfset pArgs.id_Sucursal    = "#Arguments.id_Sucursal#">
        <cfset pArgs.id_Pago        = "#local.nextidpago.id_pago#">
        <cfset pArgs.id_Usuario     = "#session.ID_USUARIO#">
        <cfset pArgs.fh_Poliza      = "#Arguments.fh_Pago#">
        <cfset pArgs.CadenaFacturas = "#Local.FoliosFacturas#">

        <!--- <cfinvoke component="#Application.RF.getPath('dao','Polizas')#"
                    method="agregarpolizas"
                    argumentcollection="#pArgs#"> --->

        <!--- <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")> --->
        <cfset variables.RBR.setdata(local.nextidpago.ID_PAGO)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 18-02-2016 --->
    <cffunction name="generarexcelemisiondepagossincheque"    access="public"     returntype="Any">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfif isDefined("estatus")>
            <cfset arguments.nb_estatus = estatus.DE_ESTATUS>
            <cfset arguments.id_estatus = estatus.ID_ESTATUS>
        <cfelse>
            <cfset arguments.nb_estatus = 'Todos'>
        </cfif>

        <cfset arguments.nb_proveedor = proveedor.NB_PROVEEDOR>
        <cfset arguments.id_proveedor = proveedor.ID_PROVEEDOR>

        <cfset ano =Mid(#fh_inicio#,1,4)>
        <cfset mes =Mid(#fh_inicio#,5,2)>
        <cfset dia =Mid(#fh_inicio#,7,2)>
        <cfset arguments.fh_inicioreporte = dia&'/'&mes&'/'&ano>

        <cfset ano1 =Mid(Arguments.fh_fin,1,4)>
        <cfset mes1 =Mid(Arguments.fh_fin,5,2)>
        <cfset dia1 =Mid(Arguments.fh_fin,7,2)>

        <cfset Arguments.fh_finreporte = dia1&'/'&mes1&'/'&ano1>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                method             ="getdatareporteemisiondepagossincheque"
                argumentcollection ="#arguments#"
                returnvariable     ="local.data">

        <cfif local.data.recordcount eq 0>
            <cfset variables.rbr.setError('Los filtros seleccionados no proporcionaron información para generar el excel.')>
            <cfreturn variables.rbr>
        </cfif>

        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteEmisionPagosSinCheques#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <!--- Import the POI tag library. --->
        <cfimport taglib="/lib/tags/poi/" prefix="poi" />

        <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
            <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
        </cfif>
        <!---
            Create an excel document and store binary data into
            REQUEST variable.
        --->

        <poi:document
            name="REQUEST.ExcelData"
            file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
            style="font-family: Arial ; font-size: 10pt ; color: black ; white-space: nowrap ;">


            <!--- Define style classes. --->
            <poi:classes>
                <poi:class
                    name="title"
                    style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
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
                    style="border-bottom:2px; border-left:2px; border-right:2px;"
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
                    freezerow="12"
                    orientation="landscape"
                    zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 50px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 300px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                    </poi:columns>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Emisiones de pago a proveedor sin cheque" colspan="3"  class="title"/>
                        <poi:cell value=''>
                        <poi:cell value=''>
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
                        <poi:cell value=''/>
                        <poi:cell value='Proveedor:' class="header"/>
                        <poi:cell value='#arguments.nb_proveedor#'/>
                        <poi:cell value='Estatus:' class="header"/>
                        <poi:cell value='#arguments.nb_estatus#'/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value='Fecha inicio:' class="header"/>
                        <poi:cell value='#arguments.fh_inicioreporte#'/>
                        <poi:cell value='Fecha fin:' class="header"/>
                        <poi:cell value='#arguments.fh_finreporte#'/>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <!--- Header row. --->
                    <poi:row >
                        <poi:cell value=''/>
                        <poi:cell value="Folio"         class="header fondo"/>
                        <poi:cell value="Folio póliza"  class="header fondo"/>
                        <poi:cell value="Beneficiario"  class="header fondo"/>
                        <poi:cell value="Fecha"         class="header fondo"/>
                        <poi:cell value="Moneda"        class="header fondo"/>
                        <poi:cell value="Importe"       class="header fondo"/>
                        <poi:cell value="Cuenta contable"   class="header fondo"/>
                        <poi:cell value="Estatus"       class="header fondo"/>
                    </poi:row>

                    <!--- Output the people. --->
                    <cfloop query="local.data">
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="#local.data.ID_PAGO#" class="Contenido borders"/>
                            <poi:cell value="#local.data.ID_POLIZACONT#" class="Contenido borders"/>
                            <poi:cell value="#local.data.NB_BENEFICIARIO#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#local.data.FH_PAGO#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#local.data.NB_MONEDA#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#LSCurrencyFormat(local.data.IM_TOTALPAGOMN)#" style="text-align:right;" class="Contenido borders"/>
                            <poi:cell value="#local.data.NU_CUENTACONTABLE#" style="text-align:left" class="Contenido borders"/>
                            <poi:cell value="#local.data.DE_ESTATUS#" style="text-align:left" class="Contenido borders"/>
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
                  nu_colWidth="2">


        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc 18-02-2016 --->
    <cffunction name="generarpdfemisiondepagossincheque"    access="public"     returntype="Any">
        <cfargument name="fh_inicio"    type="string" required="false"/>
        <cfargument name="fh_fin"       type="string" required="false"/>
        <cfargument name="estatus"      type="struct" required="false"/>
        <cfargument name="proveedor"    type="struct" required="true"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfif isDefined("estatus")>
            <cfset arguments.nb_estatus = estatus.DE_ESTATUS>
            <cfset arguments.id_estatus = estatus.ID_ESTATUS>
        <cfelse>
            <cfset arguments.nb_estatus = 'Todos'>
        </cfif>

        <cfset arguments.nb_proveedor = proveedor.NB_PROVEEDOR>
        <cfset arguments.id_proveedor = proveedor.ID_PROVEEDOR>

        <cfset ano =Mid(#fh_inicio#,1,4)>
        <cfset mes =Mid(#fh_inicio#,5,2)>
        <cfset dia =Mid(#fh_inicio#,7,2)>
        <cfset arguments.fh_inicioreporte = dia&'/'&mes&'/'&ano>

        <cfset ano1 =Mid(Arguments.fh_fin,1,4)>
        <cfset mes1 =Mid(Arguments.fh_fin,5,2)>
        <cfset dia1 =Mid(Arguments.fh_fin,7,2)>

        <cfset Arguments.fh_finreporte = dia1&'/'&mes1&'/'&ano1>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                method             ="getdatareporteemisiondepagossincheque"
                argumentcollection ="#arguments#"
                returnvariable     ="local.data">

        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('Los filtros seleccionados no proporcionaron información para generar el pdf.')>
            <cfreturn variables.RBR>
        </cfif>


        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="EmisiondepagosSincheque#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="emisiondepagossincheque">
            <cfinclude template="../../templates/reportes/Proveedores/emisiondepagossincheque.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#emisiondepagossincheque#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc 19-02-2016 devuelve la información para el modal del detalle de la pantalla de emision detalle visualizar --->
    <cffunction name="getinfodetalle" access="public" returntype="Any">
        <cfargument name="data"    type="struct" required="true"/>

        <cfset datos = structNew()>

        <!--- Se obtienen los movimientos de una emision de pago --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="getmovimientos"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_sucursal     ="#data.ID_SUCURSALDOCUMENTO#"
                    id_documento    ="#data.id_documento#"
                    cl_tipodocumento ="#data.cl_TipoDocumento#"
                    returnvariable   ="local.movimientos">

        <cfset datos.detallemovimientos = #local.movimientos#>

        <!--- Se obtienen la informacion de la cabecera del detalle de los mivimientos de una emision de pago --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="getinfomovimiento"
                    id_empresa         ="#session.ID_EMPRESA#"
                    id_sucursal        ="#data.ID_SUCURSALDOCUMENTO#"
                    id_documento       ="#data.id_documento#"
                    cl_tipodocumento   ="#data.cl_TipoDocumento#"
                    id_proveedor       ="#data.id_proveedor#"
                    id_DeudorDiverso   ="#data.id_DeudorDiverso#"
                    id_AcreedorDiverso ="#data.id_AcreedorDiverso#"
                    returnvariable  ="local.infomovimientos">

        <cfset datos.infomov = #local.infomovimientos#>

        <cfset variables.RBR.setData(datos)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 19-02-2016 cancela la emision de un pago --->
    <cffunction name="cancelaremisionpago" access="public" returntype="Any">
        <cfargument name="data"    type="struct" required="true"/>

        <!--- <cfdump var="#data#" /><cfabort /> --->

        <cfset datos = structNew()>
        <cfset local.id_cuentabancaria = 0>
        <!--- Se obtienen la cuenta bancaria y el nu_cheque --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
            method="getcuentacheque"
            id_empresa      ="#session.ID_EMPRESA#"
            id_sucursal     ="#SESSION.ID_SUCURSAL#"
            id_pago         ="#data.id_pago#"
            id_Estatus      ="1105"
            returnvariable   ="local.cuentacheque">

        <cfif #local.cuentacheque.RECORDCOUNT# GT 0 AND local.cuentacheque.ID_CUENTABANCARIA NEQ '' AND local.cuentacheque.ID_CUENTABANCARIA NEQ nullValue()>
            <cfset local.id_cuentabancaria = local.cuentacheque.ID_CUENTABANCARIA>

            <!--- cancelamos el movimiento bancario --->
            <cfinvoke component="#Application.RF.getPath('dao','cuentasbancarias')#"
                method="CuentasBancariasMovCancelar"
                id_empresa ="#session.ID_EMPRESA#"
                id_cuentabancaria = "#local.id_cuentabancaria#"
                id_cuentabancariaMov = "#local.cuentacheque.ID_CUENTABANCARIAMOV#"
                id_Estatus = "1102">
        </cfif>

        <!--- Se manda a setear el estatus a cancelado a los proveedorespagos  --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                    method="setcancelarpagosproveedores"
                    id_empresa              ="#session.ID_EMPRESA#"
                    id_sucursal             ="#SESSION.ID_SUCURSAL#"
                    id_pago                 ="#data.id_pago#"
                    <!--- id_proveedor            ="#data.id_proveedor#" --->
                    <!--- id_cuentabancaria     ="#local.id_cuentabancaria#" --->
                    id_estatus              ="1102"
                    de_MotivoCancelacion    ="#data.de_MotivoCancelacion#">

        <!--- Se obtienen los pagos proveedores detalle  --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                    method="getproveedoresdetalle"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_sucursal     ="#SESSION.ID_SUCURSAL#"
                    id_pago         ="#data.id_pago#"
                    returnvariable  ="local.proveedoresdetalle">

        <cfif #local.proveedoresdetalle.RECORDCOUNT# GT 0>

            <!--- se eliminan los documentos proveedores --->
            <cfloop query="local.proveedoresdetalle">

                <cfif local.proveedoresdetalle.cl_TipoPago EQ 'NA' AND  NOT isDefined("Local.proveedoresdetalle.id_PagoAnticipo") >

                    <cfinvoke component="#Application.RF.getPath('dao','Proveedorespagos2')#"
                            method="updateproveedorespagosanticipos"
                            id_empresa          ="#session.ID_EMPRESA#"
                            id_sucursal         ="#SESSION.ID_SUCURSAL#"
                            sn_Anticipo         ="S"
                            id_pago             ="#local.proveedoresdetalle.id_PagoAnticipo#"
                            id_proveedor        ="#data.id_proveedor#">

                    <cfinvoke component="#Application.RF.getPath('dao','documentosproveedores')#"
                                method="deletedocumentosproveedoresmovimientos"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                cl_tipodocumento    ="NA"
                                <!--- cl_tipodocumento  ="S" --->
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_pago             ="#local.proveedoresdetalle.ID_PAGO#"
                                nd_pago             ="#local.proveedoresdetalle.ND_PAGO#">

                    <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                                method="updatedocumentoproveedor"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                <!--- cl_tipodocumento  ="S" --->
                                cl_tipodocumento    ="NA"
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_estatus          ="1106">

                <cfelseif (local.proveedoresdetalle.cl_TipoPago EQ 'NF') OR  (local.proveedoresdetalle.cl_TipoPago EQ 'NA' AND  isDefined("Local.proveedoresdetalle.id_PagoAnticipo"))>

                    <cfinvoke component="#Application.RF.getPath('dao','documentosproveedores')#"
                                method="deletedocumentosproveedoresmovimientos"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                cl_tipodocumento    ="#local.proveedoresdetalle.CL_TIPODOCUMENTO#"
                                <!--- cl_tipodocumento  ="S" --->
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_pago             ="#local.proveedoresdetalle.ID_PAGO#"
                                nd_pago             ="#local.proveedoresdetalle.ND_PAGO#">

                    <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                                method="updatedocumentoproveedor"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                <!--- cl_tipodocumento  ="S" --->
                                cl_tipodocumento    ="#local.proveedoresdetalle.CL_TIPODOCUMENTO#"
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_estatus          ="1109"
                                sn_Pagado           ="0">

                    <!--- Se Actualiza el estatus de la Progamcion de pago para que se pueda pagar otra ves --->
                    <!--- <cfinvoke component="#Application.RF.getPath('dao','programacionpagos')#"
                                method="ActualizarEstatusProgamacion"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#SESSION.ID_SUCURSAL#"
                                <!--- cl_tipodocumento  ="S" --->
                                cl_tipodocumento    ="NF"
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_estatus          ="1113"> --->
                <cfelseif local.proveedoresdetalle.cl_TipoPago  EQ 'SP'>
                                    <cfinvoke component="#Application.RF.getPath('dao','SolicitudesPago')#"
                                    method                  = "cambiarEstatusDetalle"
                                    id_Empresa              = "#session.ID_EMPRESA#"
                                    id_SolicitudPago        = "#Local.proveedoresdetalle.ID_SOLICITUDPAGO#"
                                    id_SolicitudPagoDetalle = "#Local.proveedoresdetalle.ID_SOLICITUDPAGODETALLE#"
                                    id_Estatus              = 1128>


                <cfelseif local.proveedoresdetalle.cl_TipoPago EQ 'NC'>
                    <cfinvoke component="#Application.RF.getPath('dao','documentosproveedores')#"
                                method="deletedocumentosproveedoresmovimientos"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                cl_tipodocumento    ="NC"
                                <!--- cl_tipodocumento  ="S" --->
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_pago             ="#local.proveedoresdetalle.ID_PAGO#"
                                nd_pago             ="#local.proveedoresdetalle.ND_PAGO#">

                    <cfinvoke component="#Application.RF.getPath('dao','DocumentosProveedores')#"
                                method="updatedocumentoproveedor"
                                id_empresa          ="#session.ID_EMPRESA#"
                                id_sucursal         ="#local.proveedoresdetalle.ID_SUCURSALDOCUMENTO#"
                                <!--- cl_tipodocumento  ="S" --->
                                cl_tipodocumento    ="NC"
                                id_documento        ="#local.proveedoresdetalle.ID_DOCUMENTO#"
                                id_estatus          ="1106"
                                sn_Pagado           ="0">
                </cfif>
            </cfloop>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','polizas')#"
                    method="GeneraPolizaCancelaPagoProv"
                    id_Empresa     = "#session.ID_EMPRESA#"
                    id_Sucursal    = "#SESSION.ID_SUCURSAL#"
                    id_Pago        = "#data.id_Pago#"
                    id_Usuario     = "#session.ID_USUARIO#"
                    fh_Poliza      = "#data.FH_POLIZACONTCONVERT#"
                    fl_Poliza      = "#data.fl_Poliza#"
                    returnvariable = "local.datarespuesta">

        <!---/**
        * Se realiza la actualizacion de estatus de la requisicionCMF
        * (si es que es una, lo verifica dentro del SP)
        */--->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
            method="ActualizarEstatusCMF"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#session.ID_SUCURSAL#"
            id_Pago="#data.id_pago#"
            id_estatus="1102">

        <cfset variables.RBR.setdata(local.datarespuesta)>
        <!--- Alguno de los pagos a proveedor ya se encuentra contabilizado --->
        <cfif local.datarespuesta.id_PolizaCancel EQ -1>
            <cfset variables.RBR.setError('El pago a proveedor esta contabilizado.')>
            <cfreturn variables.RBR>
        <!--- <cfelse>
            <cfset variables.RBR.setdata(local.datarespuesta)>
        </cfif> --->
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 19-02-2016  imprime el cheque del pago --->
    <cffunction name="imprimircheque" access="public" returntype="Any">
        <cfargument name="id_pc"    type="string" required="true"/>
        <cfargument name="formato"  type="numeric" required="true"/>
        <cfargument name="leyenda"  type="string" required="false" />

        <cfset datos = structNew()>


        <!--- Se obtienen la información que se pintara en el cheque --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="getinformacioncheque"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_polizacont   ="#id_pc#"
                    returnvariable  ="local.datacheque">

        <!--- <cfdump var="#local.datacheque#" /><cfabort /> --->

        <cfif local.datacheque.recordcount eq 0>
            <cfset variables.rbr.seterror('No hay información para imprimir el cheque.')>
            <cfreturn variables.rbr>
        </cfif>

        <!--- se pregunta que formato de cheque se va a imprimir --->
        <cfif formato eq 1>
            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="Chequeformato1#dateFormat(now(),'dd-mm-yyyy')#"
            }>

            <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
            <cfsavecontent variable="chequeformato1">
                <cfinclude template="../../templates/reportes/Proveedores/chequeformato1.html">
            </cfsavecontent>

            <!--- Se hace el invoke del metodo que genera el PDF --->
            <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                      method="generatePDFNoDownload"
                      content="#chequeformato1#"
                      pdf="#local.infoReport.nb_archivo#"
                      debug="no"
                      path="#expandPath('../#local.infoReport.de_directorio#/')#">

            <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
            <cfset variables.RBR.setData(Local.infoReport)>

        <cfelseif formato eq 2>

            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="Chequeformato2#dateFormat(now(),'dd-mm-yyyy')#"
            }>

            <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
            <cfsavecontent variable="chequeformato2">
                <cfinclude template="../../templates/reportes/Proveedores/Chequeformato2.html">
            </cfsavecontent>

            <!--- Se hace el invoke del metodo que genera el PDF --->
            <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                      method="generatePDFNoDownload"
                      content="#chequeformato2#"
                      pdf="#local.infoReport.nb_archivo#"
                      debug="no"
                      path="#expandPath('../#local.infoReport.de_directorio#/')#">

            <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
            <cfset variables.RBR.setData(Local.infoReport)>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 19-02-2016 imprime el cheque de la cancelacion de un pago --->
    <cffunction name="imprimirchequecancelacion" access="public" returntype="Any">
        <cfargument name="id_polizacancel"  type="numeric" required="true"/>
        <cfargument name="leyenda"          type="string"  required="false" default=""/>
        <cfargument name="id_formato"       type="numeric" required="true"/>

        <cfset datos = structNew()>

        <!--- Se obtienen la información que se pintara en el cheque --->
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="getinformacionchequecancelacion"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_polizacont   ="#id_polizacancel#"
                    returnvariable  ="local.datacheque">

        <cfif local.datacheque.recordcount eq 0>
            <cfset variables.rbr.seterror('No hay información para imprimir el cheque.')>
            <cfreturn variables.rbr>
        </cfif>

        <!--- se pregunta que formato de cheque se va a imprimir --->
        <cfif ID_FORMATO EQ 2>

        <cfelseif ID_FORMATO EQ 1>
            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="Chequeformato1#dateFormat(now(),'dd-mm-yyyy')#"
            }>

            <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
            <cfsavecontent variable="chequeformato1">
                <cfinclude template="../../templates/reportes/Proveedores/chequeformato1.html">
            </cfsavecontent>

            <!--- Se hace el invoke del metodo que genera el PDF --->
            <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                      method="generatePDFNoDownload"
                      content="#chequeformato1#"
                      pdf="#local.infoReport.nb_archivo#"
                      debug="no"
                      path="#expandPath('../#local.infoReport.de_directorio#/')#">

            <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
            <cfset variables.RBR.setData(Local.infoReport)>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listarProveedoresCuentasContables" access="public" returntype="Any">
        <cfargument name="id_Moneda" type="string" required="false" default="">
        <cfargument name="id_proveedor" type="string" required="false" default="">

            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarProveedoresCuentasContables"
                  id_Empresa   = "#session.ID_EMPRESA#"
                  id_moneda    = "#Arguments.id_moneda#"
                  id_proveedor = "#Arguments.id_proveedor#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <!--- jc 2016.02.24 imprimir póliza de generacón de pago sin cheque--->
    <cffunction name="imprimirpolizachequesinpago" access="public" returntype="Any">
        <cfargument name="id_pago"          type="string"       required="false"/>
        <cfargument name="id_poliza"        type="string"       required="false"/>
        <cfargument name="opc"              type="numeric"      required="true"/>

        <!--- <cfdump var="#arguments#" /><cfabort /> --->
        <cfif opc eq 1>
            <cfif id_pago eq ''>
                <cfset variables.RBR.setError('El id_pago no tiene formato correcto.')>
                <cfreturn variables.RBR>
            </cfif>
            <!--- se manda por la poliza que se acaba de generar al momento de emitir un pago de cheque sin pago --->
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                    method="getpolizaflpoliza"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_sucursal     ="#SESSION.ID_SUCURSAL#"
                    id_pago         ="#id_pago#"
                    returnvariable  ="local.polizaflpoliza">

            <!--- se manda por la informacion que se mandara a imprimir en el pdf --->
            <cfinvoke component="#Application.RF.getPath('dao','Polizas')#"
                      method="getinfopolizapagosincheque"
                      id_empresa    ="#session.ID_EMPRESA#"
                      id_poliza     ="#local.polizaflpoliza.ID_POLIZACONT#"
                      returnvariable="local.datapoliza">
        <cfelseif opc eq 2>
            <cfif id_poliza eq ''>
                <cfset variables.RBR.setError('El id_poliza no tiene formato correcto.')>
                <cfreturn variables.RBR>
            </cfif>
            <!--- se manda por la poliza que se acaba de generar al momento de emitir un pago de cheque sin pago --->
            <!--- <cfinvoke component="#Application.RF.getPath('dao','ProveedoresPagos2')#"
                    method="getpolizaflpoliza"
                    id_empresa      ="#session.ID_EMPRESA#"
                    id_sucursal     ="#SESSION.ID_SUCURSAL#"
                    id_pago         ="#id_pago#"
                    returnvariable  ="local.polizaflpoliza"> --->

            <!--- se manda por la informacion que se mandara a imprimir en el pdf --->
            <cfinvoke component="#Application.RF.getPath('dao','Polizas')#"
                      method="getinfopolizapagosinchequecancelacion"
                      id_empresa    ="#session.ID_EMPRESA#"
                      id_poliza     ="#id_poliza#"
                      cl_tipopoliza ="C"
                      returnvariable="local.datapoliza">
        <cfelse>
            <cfset variables.RBR.setError('Has intentado manipular el javascript de una forma inusual, la opc que mando no es valida.')>
            <cfreturn variables.RBR>
        </cfif>


        <cfif local.datapoliza.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para imprimir en la póliza.')>
            <cfreturn variables.RBR>
        </cfif>

        <cfset var Local.infoReport={
            de_directorio   ="Reportes",
            nb_archivo      ="Polizapagosincheque#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="polizapagosincheque">
            <cfinclude template="../../templates/reportes/Proveedores/polizaspagossincheque.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#polizapagosincheque#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc 2016.04.27 listado de las programaciones de pago--->
    <cffunction  name="listarprogramacionpagos" access="public" returntype="Any">
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>
        <cfargument name="id_Proveedor"     type="string"       required="false"/>

        <cfset arguments.id_Empresa = "#session.ID_EMPRESA#">
        <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="listarprogramacionpagos"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction  name="listarprogramacionpagosEmpresas" access="public" returntype="Any">
        <cfargument name="Empresas"         type="string"       required="false"/>
        <cfargument name="clprogramacion"   type="string"       required="false"/>
        <cfargument name="fh_i"             type="string"       required="false"/>
        <cfargument name="fh_f"             type="string"       required="false"/>
        <cfargument name="accion"           type="numeric"      required="true"/>
        <cfargument name="page"             type="numeric"      required="true"/>
        <cfargument name="pageSize"         type="numeric"      required="true"/>
        <cfargument name="Estatus"          type="string"       required="false"/>

        <!---  <cfset arguments.id_Sucursal = "#SESSION.ID_SUCURSAL#">--->

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="listarprogramacionpagosEmpresas"
                    id_Empleado="#SESSION.ID_EMPLEADO#"
                    id_EmpresaEmpleado="#session.ID_EMPRESAOPERADORA#"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AyudaProveedores" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="string" required="false"/>
        <cfargument name="id_Proveedor"       type="string" required="false"/>
        <cfargument name="nb_Proveedor"       type="string" required="false"/>
        <cfargument name="id_TipoProveedor"   type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerproveedor" access="public" returntype="Any">
        <cfargument name="id_Proveedor"       type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerproveedor"
                  argumentcollection="#arguments#"
                  id_empresa = "#session.ID_EMPRESA#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerProveedorRFC" access="public" returntype="Any">
        <cfargument name="de_rfc"       type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerProveedorRFC"
                  id_empresa = "#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="validarGenerarOC" access="public" returntype="Any">
        <cfargument name="id_proveedor"       type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="getByID"
                  id_Empresa="#session.ID_EMPRESA#"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">


            <cfif Local.rs.ID_REFERENCIACONTABLE EQ '' >
                <cfset variables.RBR.setError('El proveedor no cuenta con Referencia Contable capturada.')>
                <cfreturn variables.RBR>
            </cfif>
            <cfif Local.rs.NU_CUENTABANCARIA EQ ''>
                <cfset variables.RBR.setError('El proveedor no cuenta con Cuenta Bancaria capturada.')>
                <cfreturn variables.RBR>
            </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="obtenerCuentasBancarias" access="public" returntype="Any">
        <cfargument name="id_Proveedor"       type="numeric" required="false"/>
        <cfargument name="id_Moneda"          type="numeric" required="false"/>


        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerCuentasBancarias"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>
    <cffunction name="obtenerCuentasBancariasReporte" access="public" returntype="Any">
        <cfargument name="id_Proveedor"          type="string" required="false"/>
        <cfargument name="id_CuentaBancaria"     type="string" required="false"/>
        <cfargument name="id_DeudorDiverso"     type="string" required="false"/>



        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerCuentasBancariasReporte"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
                  <cfset informacion = structNew()>
                  <cfset informacion.Proveedores = Local.rs.Proveedores>
                  <cfset informacion.Deudores = Local.rs.Deudores>
                  <cfset variables.RBR.setDATA(#informacion#)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerCuentasBancariasCombo" access="public" returntype="Any">
        <cfargument name="id_Proveedor"       type="string" required="true"/>
        <cfargument name="id_Moneda" type="string" required="false">


        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerCuentasBancariasCombo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

     <cffunction name="aplicarClasificacion" access="public" returntype="any" output="false">
  <cfargument name="id_Proveedor"     type="string" required="true"/>
  <cfargument name="id_Clasificacion" type="string" required="true"/>

  <cfset var Local = {}>

  <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="aplicarClasificacion"
            argumentcollection="#arguments#"
            returnvariable="Local.res" />

  <!--- Blindaje: si DAO no regresó struct, crea uno --->
  <cfif NOT isStruct(Local.res)>
    <cfset Local.res = { ISOK = false, MSG = "DAO no regresó struct válido", DETAIL = "" }>
  </cfif>

  <cfif NOT structKeyExists(Local.res, "ISOK")>
    <cfset Local.res.ISOK = false>
  </cfif>
  <cfif NOT structKeyExists(Local.res, "MSG")>
    <cfset Local.res.MSG = "Sin mensaje">
  </cfif>
  <cfif NOT structKeyExists(Local.res, "DETAIL")>
    <cfset Local.res.DETAIL = "">
  </cfif>

  <!--- Convertir a QUERY para setQuery (tu framework) --->
  <cfset var q = queryNew("ISOK,MSG,DETAIL", "bit,varchar,varchar")>
  <cfset queryAddRow(q, 1)>
  <cfset querySetCell(q, "ISOK",   (Local.res.ISOK ? 1 : 0), 1)>
  <cfset querySetCell(q, "MSG",    Local.res.MSG, 1)>
  <cfset querySetCell(q, "DETAIL", Local.res.DETAIL, 1)>

  <cfset variables.RBR.setQuery(q)>
  <cfreturn variables.RBR>
</cffunction>



 <cffunction name="listaridentificadorCom" access="public" returntype="struct">
    <cfset var Local = {} />
    <cfset var args  = duplicate(arguments) />

    <cfset args.id_usuario = session.ID_USUARIO />

    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
              method="listaridentificadorCom"
              argumentcollection="#args#"
              returnvariable="Local.rsIdentificadores" />

    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
              method="permisoClasificacion"
              argumentcollection="#args#"
              returnvariable="Local.rsPermiso" />

    <cfreturn {
        identificadores = Local.rsIdentificadores,
        permiso        = Local.rsPermiso
    } />
</cffunction>

    <cffunction name="listarTransferenciasCombo" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="listarTransferenciasCombo"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="editarCuentaBancaria"     access="public" returntype="Any">
        <cfargument name="id_Proveedor"         type="numeric"  required="true"/>
        <cfargument name="Cuentas"              type="array"    required="true"/>

        <cfloop array="#arguments.Cuentas#" index="item">
            <cfinvoke
                component="#Application.RF.getPath('dao','proveedores')#"
                method="AgregarCuentasContables"
                id_Proveedor            ="#arguments.ID_PROVEEDOR#"
                id_CuentaBancaria       ="#item.ID_CUENTABANCARIA#"
                nb_CuentaBancaria       ="#item.NB_CUENTABANCARIA#"
                id_TipoTransferencia    ="#item.ID_TIPOTRANSFERENCIA#"
                nb_ClaveProveedor       ="#item.NB_CLAVEPROVEEDOR#"
                nu_ClabeInterbancaria   ="#item.NU_CLABEINTERBANCARIA#"
                id_Banco                ="#item.ID_BANCO#"
                id_Moneda               ="#item.ID_MONEDA#"
                ar_Caratula             ="#item.AR_CARATULA#"
                de_Concepto             ="#item.DE_CONCEPTO#">
        </cfloop>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="editarCuentaBancariaReporteProveedores"     access="public" returntype="Any">
        <cfargument name="id_Proveedor"          type="numeric" required="false"/>
        <cfargument name="ID_BANCO"             type="numeric" required="false"/>
        <cfargument name="NB_CUENTABANCARIA"    type="string" required="false"/>
        <cfargument name="NU_CLABEINTERBANCARIA"type="string" required="false"/>
        <cfargument name="ID_TIPOTRANSFERENCIA" type="string" required="false"/>
        <cfargument name="ID_MONEDA"            type="string" required="false"/>
        <cfargument name="ID_CUENTABANCARIA"    type="string" required="false"/>
        <cfargument name="NU_CUENTABANCARIA"    type="string" required="false"/>
        <cfargument name="NB_CLAVEPROVEEDOR"    type="string" required="false"/>
                        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                        method="AgregarCuentasContables"
                        id_Proveedor            ="#arguments.ID_PROVEEDOR#"
                        id_CuentaBancaria       ="#arguments.ID_CUENTABANCARIA#"
                        nb_CuentaBancaria       ="#arguments.NB_CUENTABANCARIA#"
                        id_TipoTransferencia    ="#arguments.ID_TIPOTRANSFERENCIA#"
                        nb_ClaveProveedor       ="#arguments.NB_CLAVEPROVEEDOR#"
                        nu_ClabeInterbancaria   ="#arguments.NU_CLABEINTERBANCARIA#"
                        id_Banco                ="#arguments.ID_BANCO#"
                        id_Moneda               ="#arguments.ID_MONEDA#"
                        returnvariable          = "Local.rs">
                <cfset variables.RBR.setQuery(Local.rs)>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>

    <cffunction name="resetCuentasContables"     access="public" returntype="Any">
        <cfargument name="id_Proveedor"          type="numeric" required="false"/>
        <cfargument name="id_CuentaBancaria"     type="numeric" required="false"/>
            <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#" label="arguments" abort="true"> --->

        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
        method="resetCuentasContables"
        argumentcollection="#arguments#">


        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>

    <cffunction name="editarCuentaBancariaReporte"     access="public" returntype="Any">
        <cfargument name="id_Proveedor"         type="numeric"  required="true"/>
        <cfargument name="Cuentas"              type="array"    required="true"/>

        <cfloop array="#arguments.Cuentas#" index="item">
            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="EditarCuentasContablesReporte"
                    id_Proveedor            ="#arguments.ID_PROVEEDOR#"
                    id_CuentaBancaria       ="#item.ID_CUENTABANCARIA#"
                    nb_CuentaBancaria       ="#item.NB_CUENTABANCARIA#"
                    id_TipoTransferencia    ="#item.ID_TIPOTRANSFERENCIA#"
                    nb_ClaveProveedor       ="#item.NB_CLAVEPROVEEDOR#"
                    nu_ClabeInterbancaria   ="#item.NU_CLABEINTERBANCARIA#"
                    id_Banco                ="#item.ID_BANCO#"
                    id_Moneda               ="#item.ID_MONEDA#">
        </cfloop>


        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>




        <!--- Jesus Reyes--->
    <cffunction name="ExcelDocumentosEmisionPago"    access="public"     returntype="Any">
        <cfargument name="data" type="struct" required="false"/>

            <cfinvoke component="#Application.RF.getPath('bro','Proveedores')#"
                  method="getinformacionemisionpago"
                  argumentcollection="#arguments#"
                  returnvariable="Local.Emision">


            <cfif local.Emision.hasError()>
                <cfset Variables.RBR.setError(local.Emision.getMessage())>
                <cfreturn variables.RBR>
            </cfif>

            <cfset DatosEmision =  local.Emision.getData()>

            <cfif (#DatosEmision.ANTICIPOS.recordCount# EQ 0) AND (#DatosEmision.FACTURACION.recordCount# EQ 0) AND (#DatosEmision.NOTASCREDITO.recordCount# EQ 0)>
                <cfset variables.RBR.setError('No  se encontraron registros para mostrar.')>
                <cfreturn Variables.RBR>
            </cfif>

            <cfset local.DatosReporte = structNew()>
                <cfset var Local.infoReport={
                    de_directorio="Reportes",
                    nb_archivo="ExcelDocumentosEmisionPago#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                            style="font-family: Arial; color: black; font-size:14pt; text-align:center; font-weight: bold;"
                        />
                        <poi:class
                            name="titleEncabezado"
                            style="font-family: Arial; color: black; font-size:18pt; text-align:center; font-weight: bold;"
                        />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color:black; font-weight: bold;text-align:right; font-size:12pt;"
                        />
                        <poi:class
                            name="fondo"
                            style="background-color: GREY_25_PERCENT; "
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-top:2px; border-bottom:2px; border-left:2px; border-rigth:2px;"
                        />
                        <poi:class
                            name="header"
                            style="font-family: Arial ; color: black ; font-size: 12pt; font-weight: bold; text-align: Right ;"
                        />

                        <poi:class
                            name="odd"
                            style="background-color: GREY_25_PERCENT; "
                        />

                        <poi:class
                            name="totalSC"
                            style="background-color: YELLOW; "
                        />

                        <poi:class
                            name="totalEC"
                            style="background-color: GREY_25_PERCENT; "
                        />

                        <poi:class
                            name="totalGC"
                            style="background-color: BLUE; "
                        />

                        <poi:class
                            name="totalCC"
                            style="background-color: GREEN; "
                        />

                        <!---GRID--->
                        <poi:class
                            name="tituloGrid"
                            style="font-family: Arial ; color:black; font-weight: bold;text-align:center; font-size:11pt;"
                        />
                    </poi:classes>

                    <!--- Define Sheets. --->
                    <poi:sheets>

                        <poi:sheet
                            name="Aplicacion de Pagos"
                            orientation="portrait"
                            zoom="80%">
                            <!---Columnas globales del Excel--->
                            <poi:columns>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 120px;"/>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 110px;"/>
                                <poi:column style="width: 110px;"/>
                                <poi:column style="width: 120px;"/>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 100px;"/>
                                <poi:column style="width: 100px;"/>
                            </poi:columns>

                            <!--- Title row. --->
                            <poi:row>
                                <poi:cell value="#session.NB_RAZONSOCIAL#" class="title" style="text-align: left;"/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="negrita" style="text-align: right;"/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value="Sucursal #session.NB_SUCURSAL#" style="text-align:left"/>
                            </poi:row>

                            <poi:row class=''>
                                <poi:cell value="#session.NB_DIRECCION#" style="text-align:left"/>
                            </poi:row>
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell colspan="7" value='Emisión de Pagos' style="text-align:center; font-size: 12px;font-weight: bold"/>
                            </poi:row>

                            <poi:row class=''></poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Proveedor'  style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.NB_BENEFICIARIO#" style="text-align:left"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Cuenta Bancaria'  style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.NB_CUENTABANCARIA#" style="text-align:left"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Moneda:'  style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.NB_MONEDA#" style="text-align:left"/>
                                <poi:cell value=''/>
                                <poi:cell value='Tipo Cambio:' style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.IM_TIPOCAMBIO#" style="text-align:left"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Medio de pago:'  style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.MEDIO#" style="text-align:left"/>
                                <poi:cell value=''/>
                                <poi:cell value='Num.Cheque/Transf:'  style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.NU_CHEQUE#" style="text-align:left" type="general"/>
                                <poi:cell value=''/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value='Fecha de pago:' style="text-align:right;font-weight: bold"/>
                                <poi:cell value="#arguments.data.FH_PAGOCONVERT#" style="text-align:left"/>
                            </poi:row>
                            <!--- ******************************************************************* --->
                            <!---                       FACTURAS                                      --->
                            <!--- ******************************************************************* --->

                            <poi:row class=''></poi:row>
                            <poi:row class=''>
                                <poi:cell value="Facturas"  style="text-align:left; font-size: 12px;font-weight: bold"/>
                            </poi:row>

                            <cfif DatosEmision.FACTURACION.recordCount GT 0>

                                <poi:row class=''>
                                    <poi:cell value="Tipo"         class="tituloGrid fondo borders"/>
                                    <poi:cell value="Factura"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Sucursal"     class="tituloGrid fondo borders"/>
                                    <poi:cell value="Fecha"        class="tituloGrid fondo borders"/>
                                    <poi:cell value="Vencimiento"  class="tituloGrid fondo borders"/>
                                    <poi:cell value="Moneda"       class="tituloGrid fondo borders"/>
                                    <poi:cell value="Importe"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Impuesto"     class="tituloGrid fondo borders"/>
                                    <poi:cell value="Total"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Total MN"     class="tituloGrid fondo borders"/>
                                </poi:row>

                                <cfoutput query="DatosEmision.FACTURACION">
                                    <poi:row class=''>
                                        <poi:cell value="#DE_DOCUMENTO#"            class="Contenido borders"  style="text-align: left"/>
                                        <poi:cell value="#NU_FOLIODOCUMENTO#"       class="Contenido borders"  style="text-align: left"/>
                                        <poi:cell value="#NB_SUCURSAL#"             class="Contenido borders"  style="text-align: left"/>
                                        <poi:cell value="#FH_REGISTRO#"             class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#FH_VENCIMIENTO#"          class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#NB_MONEDA#"               class="Contenido borders"  style="text-align: left"/>
                                        <poi:cell value="#IMPORTE#"                 type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#IMPUESTO#"                type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#IM_TOTAL#"                type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#IM_TOTAL*IM_TIPOCAMBIO#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                    </poi:row>
                                </cfoutput>

                            <cfelse>
                                <poi:row class=''>
                                    <poi:cell value="La emisión de pago no cuenta con documentos relacionados." class="Contenido"  style="text-align: left;font-style: italic"/>
                                </poi:row>
                            </cfif>

                            <!--- ******************************************************************* --->
                            <!---                       NOTAS DE CREDITO                              --->
                            <!--- ******************************************************************* --->
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell value="Notas Credito"  style="text-align:left; font-size: 12px;font-weight: bold"/>
                            </poi:row>


                            <cfif DatosEmision.NOTASCREDITO.recordCount GT 0>

                                <poi:row class=''>
                                    <poi:cell value=""      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Factura"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Fecha"        class="tituloGrid fondo borders"/>
                                    <poi:cell value="Vencimiento"  class="tituloGrid fondo borders"/>
                                    <poi:cell value="Moneda"       class="tituloGrid fondo borders"/>
                                    <poi:cell value="Importe"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Total MN"     class="tituloGrid fondo borders"/>
                                </poi:row>

                                <cfoutput query="DatosEmision.NOTASCREDITO">
                                    <poi:row class=''>
                                        <poi:cell value=""                         class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#NU_FOLIODOCUMENTO#"      class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#FH_REGISTRO#"            class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#FH_VENCIMIENTO#"         class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#NB_MONEDA#"              class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#IM_TOTAL#"               type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#IM_TOTAL*IM_TIPOCAMBIO#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                    </poi:row>
                                </cfoutput>

                            <cfelse>
                                <poi:row class=''>
                                    <poi:cell value="La emisión de pago no cuenta con documentos relacionados." class="Contenido"  style="text-align: left;font-style: italic"/>
                                </poi:row>
                            </cfif>

                            <!--- ******************************************************************* --->
                            <!---                           ANTICIPOS                                 --->
                            <!--- ******************************************************************* --->
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell value="Anticipos"  style="text-align:left; font-size: 12px;font-weight: bold"/>
                            </poi:row>

                            <cfif DatosEmision.NOTASCREDITO.recordCount GT 0>

                                <poi:row class=''>
                                    <poi:cell value=""             class="tituloGrid fondo borders"/>
                                    <poi:cell value="Factura"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Fecha"        class="tituloGrid fondo borders"/>
                                    <poi:cell value="Vencimiento"  class="tituloGrid fondo borders"/>
                                    <poi:cell value="Moneda"       class="tituloGrid fondo borders"/>
                                    <poi:cell value="Importe"      class="tituloGrid fondo borders"/>
                                    <poi:cell value="Total MN"     class="tituloGrid fondo borders"/>
                                </poi:row>

                                <cfoutput query="DatosEmision.ANTICIPOS">
                                    <poi:row class=''>
                                        <poi:cell value=""                         class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#NU_FOLIODOCUMENTO#"      class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#FH_REGISTRO#"            class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#FH_VENCIMIENTO#"         class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#NB_MONEDA#"              class="Contenido borders"  style="text-align: center"/>
                                        <poi:cell value="#IM_TOTAL#"               type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#IM_TOTAL*IM_TIPOCAMBIO#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                    </poi:row>
                                </cfoutput>

                            <cfelse>
                                <poi:row class=''>
                                    <poi:cell value="La emisión de pago no cuenta con documentos relacionados." class="Contenido"  style="text-align: left;font-style: italic"/>
                                </poi:row>
                            </cfif>

                            <!--- ******************************************************************* --->
                            <!---                           TOTALES                                   --->
                            <!--- ******************************************************************* --->
                            <poi:row class=''></poi:row>
                            <poi:row class=''></poi:row>

                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Total cheque:' style="text-align:right"/>
                                <poi:cell value="#arguments.data.IM_TOTCHEQUE#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Notas por aplicar:' style="text-align:right"/>/>
                                <poi:cell value="#arguments.data.IM_TOTNOTAS#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Anticipos por aplicar:' style="text-align:right"/>/>
                                <poi:cell value="#arguments.data.IM_TOTANTICIPOS#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido"/>
                            </poi:row>
                            <poi:row class=''>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value=''/>
                                <poi:cell value='Total por abonar:' style="text-align:right"/>
                                <poi:cell value="#arguments.data.IM_TOTABONAR#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido"/>
                            </poi:row>
                        </poi:sheet>
                    </poi:sheets>
                </poi:document>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>


    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiro"     access="public" returntype="Any">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="false"/>
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
        <cfargument name="EDITAR"               type="string" required="false"/>
        <cfargument name="ID_TAR"               type="string" required="false"/>

        <cfif #arguments.EDITAR#>
            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="domiciliosRetiroEditar"
                    argumentcollection="#arguments#">
        <cfelse>
            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="domiciliosRetiroAgregar"
                    argumentcollection="#arguments#">
        </cfif>



        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroListar" access="public" returntype="Any">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="cf_SimuladorCostos"   type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="domiciliosRetiroListar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!---
        JOSE IBARRA
        27/02/2018
    --->
    <cffunction name="domiciliosRetiroEliminar"     access="public" returntype="Any">
        <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
        <cfargument name="ID_DIRECCIONRETIRO"   type="string" required="true"/>

            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="domiciliosRetiroEliminar"
                    argumentcollection="#arguments#">

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>

    <!---
        JOSE IBARRA
        04/05/2018
    --->
    <cffunction name="ProveedoresTransportistas" access="public" returntype="Any">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="ProveedoresTransportistas"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>



    <cffunction name="ReporteProveedoresPasivos"    access="public"     returntype="Any">
        <cfargument name="id_Empresa"       type="string"   required="false"/>
        <cfargument name="fh_inicio"        type="string"   required="false"/>
        <cfargument name="fh_fin"           type="string"   required="false"/>
        <cfargument name="id_Sucursal"      type="string"   required="false"/>
        <cfargument name="id_Proveedor"     type="string"   required="false"/>
        <cfargument name="nb_Empresa"       type="string"   required="false"/>
        <cfargument name="nb_Sucursal"      type="string"   required="false"/>
        <cfargument name="nb_Proveedores"   type="string"   required="false"/>
        <cfargument name="id_Moneda"        type="string"   required="false"   default=""/>

        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                    method="ReporteProveedoresPasivos"
                    argumentcollection="#arguments#"
                    returnvariable="local.RS"/>

        <cfset LocalResult = local.RS>
        <cfif #LocalResult.recordcount# EQ 0>
          <cfset variables.RBR.setError('No existen registros para mostrar.')>
          <cfreturn Variables.RBR>
        </cfif>

        <cfset variables.RBR.setData(LocalResult)>
        <cfreturn variables.RBR>

        <!---
        <cfset local.DatosReporte = structNew()>
        <cfset var Local.infoReport={
            de_directorio="ReporteProveedoresPasivos",
            nb_archivo="ReporteProveedoresPasivos#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
        }>

        <cfif local.rs.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para generar el Reporte.')>
            <cfreturn variables.RBR>
        </cfif>


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
                            style="font-family: Arial ; color: black ; font-size: 14pt ; text-align: left; font-weight: bold;"
                            />

                <poi:class  name="fondo"
                            style="border-left:2px; border-right:2px;  background-color: GREY_25_PERCENT; "
                            />

                <poi:class  name="Total"
                            style="color: red; text-align: right ;"
                            />

                <poi:class  name="header"
                            style="font-family: Arial ; color: sky-blue ; font-size: 10pt; font-weight: bold; height: 15px"
                            />
                <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                <poi:class
                            name="borde"
                            style="border-left:2px; border-right:2px; font-family: Arial;"
                            />
            </poi:classes>

            <poi:sheets>
                <poi:sheet  name="Reporte"
                            freezerow="11"
                            orientation="landscape"
                            zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 70px;"/>
                        <poi:column style="width: 70px;"/>
                        <poi:column style="width: 130px;"/>
                        <poi:column style="width: 100px;"/>
                        <poi:column style="width: 125px;"/>
                        <poi:column style="width: 120px;"/>
                        <poi:column style="width: 130px;"/>
                        <poi:column style="width: 90px;"/>
                        <poi:column style="width: 300px;"/>
                        <poi:column style="width: 100px;"/>
                        <poi:column style="width: 100px;"/>
                        <poi:column style="width: 90px;"/>
                        <poi:column style="width: 100px;"/>
                        <poi:column style="width: 100px;"/>
                    </poi:columns>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value="#session.NB_RAZONSOCIAL#" class="title" style="text-align: left;"/>
                        <poi:cell index="13" value="#dateFormat(now(),'dd/mm/yyyy')#" class="negrita" style="text-align: right;"/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value="Sucursal #session.NB_SUCURSAL#" style="text-align:left"/>
                        <poi:cell index="13" value="#session.NB_USUARIO#" class="negrita" style="text-align: right;"/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value="#session.NB_DIRECCION#" style="text-align:left"/>
                    </poi:row>
                    <poi:row class=''></poi:row>

                    <poi:row>
                        <poi:cell colspan="13" value="Reporte de Proveedores Pasivos" class="title" style="text-align: center"/>
                    </poi:row>

                    <poi:row class=''></poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="Empresa:" style="text-align: right" class="negrita"/>
                        <poi:cell value="#arguments.NB_EMPRESA#" style="text-align: left"/>
                        <poi:cell value=""/>
                        <poi:cell value="Fecha Inicio:" style="text-align: right" class="negrita"/>
                        <poi:cell value="#arguments.fh_inicioStr#" style="text-align: left"/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="Sucursal:" style="text-align: right" class="negrita"/>
                        <poi:cell value="#arguments.NB_SUCURSAL#" style="text-align: left"/>
                        <poi:cell value=""/>
                        <poi:cell value="Fecha Fin:" style="text-align: right" class="negrita"/>
                        <poi:cell value="#arguments.fh_finStr#" style="text-align: left"/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="Proveedor:" style="text-align: right" class="negrita"/>
                        <poi:cell value="#arguments.NB_PROVEEDORES#" style="text-align: left"/>
                    </poi:row>


                    <poi:row class=''></poi:row>

                    <poi:row rowHeight="1" class='header'>

                        <poi:cell value="Empresa"            class="header fondo" style="text-align: center"/>
                        <poi:cell value="Sucursal"           class="header fondo" style="text-align: center"/>
                        <poi:cell value="Tipo Movimiento"    class="header fondo" style="text-align: center"/>
                        <poi:cell value="Factura"            class="header fondo" style="text-align: center"/>
                        <poi:cell value="Fecha Documento"    class="header fondo" style="text-align: center"/>
                        <poi:cell value="Fecha Poliza"     class="header fondo" style="text-align: center"/>
                        <poi:cell value="Fecha Cancelación"  class="header fondo" style="text-align: center"/>
                        <poi:cell value="Estatus"            class="header fondo" style="text-align: center"/>
                        <poi:cell value="Proveedor"          class="header fondo" style="text-align: center"/>
                        <poi:cell value="Moneda"             class="header fondo" style="text-align: center"/>
                        <poi:cell value="SubTotal"           class="header fondo" style="text-align: center"/>
                        <poi:cell value="IVA"                class="header fondo" style="text-align: center"/>
                        <poi:cell value="Retenciones"        class="header fondo" style="text-align: center"/>
                        <poi:cell value="Total"              class="header fondo" style="text-align: center"/>

                    </poi:row>

                    <cfloop query="local.rs">
                        <poi:row>
                            <poi:cell value="#local.rs.EMPRESA#"      class="borde" style="text-align: left"/>
                            <poi:cell value="#local.rs.SUCURSAL#"     class="borde" style="text-align: left"/>
                            <poi:cell value="#local.rs.TIPOALMACEN#"  class="borde" style="text-align: left"/>
                            <poi:cell value="#local.rs.FACTURA#"      class="borde" style="text-align: left"/>
                            <poi:cell value="#local.rs.FH_DOCUMENTO#" class="borde" style="text-align: center"/>
                            <poi:cell value="#local.rs.FH_REVISION#"  class="borde" style="text-align: center"/>
                            <poi:cell value="#local.rs.FH_CANCELA#"   class="borde" style="text-align: center"/>
                            <poi:cell value="#local.rs.ESTATUS#"      class="borde" style="text-align: center"/>
                            <poi:cell value="#local.rs.PROVEEDOR#"    class="borde" style="text-align: left"/>
                            <poi:cell value="#local.rs.MONEDA#"       class="borde" style="text-align: center"/>

                            <poi:cell type="numeric" value="#local.rs.SUBTOTAL#"    numberformat="##,####0.00" class="borde" style="text-align: right;"/>
                            <poi:cell type="numeric" value="#local.rs.IVA#"         numberformat="##,####0.00" class="borde" style="text-align: right;"/>
                            <poi:cell type="numeric" value="#local.rs.RETENCIONES#" numberformat="##,####0.00" class="borde" style="text-align: right;"/>
                            <poi:cell type="numeric" value="#local.rs.TOTAL#"       numberformat="##,####0.00" class="borde" style="text-align: right;"/>
                        </poi:row>
                    </cfloop>
                </poi:sheet>
            </poi:sheets>
        </poi:document>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>--->
    </cffunction>

    <cffunction name="ProveedorProductoListar" access="public" returntype="Any">
      <cfargument name="ID_PROVEEDOR"         type="string" required="true"/>
      <cfargument name="sn_Activo"            type="string"   required="false"/>

      <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="ProveedorProductoListar"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

      <cfset variables.RBR.setQuery(Local.rs)>

      <cfreturn variables.RBR>
  </cffunction>

  <cffunction name="guardarProveedorProducto"     access="public" returntype="Any">
    <cfargument name="id_Proveedor"   type="string" required="true"/>
    <cfargument name="nb_Producto"    type="string" required="false"/>
    <cfargument name="sn_Activo"      type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                method="guardarProveedorProducto"
                argumentcollection="#arguments#">


    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
    <cfreturn variables.RBR>

  </cffunction>

  <cffunction name="activarDesactivarProveedorProducto"     access="public" returntype="Any">
    <cfargument name="id_Proveedor"             type="string" required="true"/>
    <cfargument name="id_ProductoProveedor"     type="string" required="true"/>
    <cfargument name="sn_Activo"                type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
                method="activarDesactivarProveedorProducto"
                argumentcollection="#arguments#">

    <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
    <cfreturn variables.RBR>

  </cffunction>

  <cffunction name="almc_TipoDeAditivoCompra" access="public" returntype="Any">

    <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
              method="upL_almc_TipoDeAditivoCompra"
              argumentcollection="#arguments#"
              returnvariable="Local.rs">

    <cfset variables.RBR.setQuery(Local.rs)>
    <cfreturn variables.RBR>
  </cffunction>

  <cffunction name="listadoProveedoresConSolicitud" access="public" returntype="Any">
    <cfargument name="id_Plaza"       type="string" required="false"/>
    <cfargument name="fh_Margen"      type="string" required="false"/>
    <cfargument name="tiposProductos" type="string" required="false"/>

      <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="listadoProveedoresConSolicitud"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

    <cfset variables.RBR.setQuery(Local.rs)>
    <cfreturn variables.RBR>
</cffunction>


    <!---
        JPFarber    -   04/06/2021  -   Actualizar los campos de Proveedor Transporte y/o Combustible
    --->
    <cffunction name="guardarOpcionesProveedor" access="remote" returntype="Any">
        <cfargument name="id_Proveedor"                         type="string" required="false"/>
        <cfargument name="sn_Transporte"                        type="string" required="false"/>
        <cfargument name="sn_ProveedorCombustible"              type="string" required="false"/>
	    <cfargument name="nu_PermisoCRETransporte"              type="string" required="false"/>
	    <cfargument name="nu_PermisoCRECombustible"             type="string" required="false"/>
        <cfargument name="sn_ProveedorDieselGasolinas"          type="string" required="false"/>
        <cfargument name="sn_ProveedorAditivo"                  type="string" required="false"/>
        <cfargument name="id_TipoDeAditivo"                     type="string" required="false"/>
        <cfargument name="nu_DiasRegistroComprasCombustible"    type="string" required="false"/>


        <!--- <cfcontent type="text/html">
        <cfdump var="#arguments#">
        <cfabort> --->

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="guardarOpcionesProveedor"
                argumentcollection="#arguments#"/>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="listarCuentasBancariasPaginados" access="public" returntype="any">
        <cfargument name="id_TipoReporte"        type="string"  required="false"/>
        <cfargument name="fh_Incio"              type="string"  required="false"/>
        <cfargument name="fh_Fin"                type="string"  required="false"/>
        <cfargument name="page"                  type="string"  required="false" default=""/>
        <cfargument name="pageSize"              type="string"  required="false" default=""/>
        <cfargument name="sn_PagoExtraOrdinario" type="string"  required="false" default="0"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listarCuentasBancariasPaginados"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="obtenerCuentasBancariasDeudores" access="public" returntype="Any">
        <cfargument name="id_DeudorDiverso"       type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="obtenerCuentasBancariasDeudores"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="editarCuentaBancariaDeudores"     access="public" returntype="Any">
        <cfargument name="id_DeudorDiverso"     type="numeric"  required="true"/>
        <cfargument name="Cuentas"              type="array"    required="true"/>
<!---
        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="resetCuentasContablesDeudores"
                    id_DeudorDiverso="#arguments.ID_DEUDORDIVERSO#"> --->

        <cfloop array="#arguments.Cuentas#" index="item">
            <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="AgregarCuentasContablesDeudores"
                    id_DeudorDiverso        ="#arguments.ID_DEUDORDIVERSO#"
                    nb_CuentaBancaria       ="#item.NB_CUENTABANCARIA#"
                    nu_ClabeInterbancaria   ="#item.NU_CLABEINTERBANCARIA#"
                    id_Banco                ="#item.ID_BANCO#"
                    id_Moneda               ="#item.ID_MONEDA#">
        </cfloop>

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="CuentasBancariasReporte" access="public" returntype="Any">
        <cfargument name="id_TipoReporte"  type="string"  required="false"/>
        <cfargument name="fh_Inicio"       type="string"   required="false"/>
        <cfargument name="fh_Fin"          type="string"   required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
              method="CuentasBancariasReporte"
              argumentcollection="#arguments#"
              returnvariable="local.reporte">

        <cfset variables.RBR.setQuery(Local.reporte)>
        <cfreturn variables.RBR>
      </cffunction>


    <cffunction name="actualizarLogo"     access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric"required="false"/>
        <cfargument name="imgLogo"      type="string" required="false"/>

        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
                    method="actualizarLogo"
                    argumentcollection="#arguments#">

        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="VerificarEmpleadoCompra" access="public" returntype="Any">
        <cfargument name="Empleado" type="numeric" required="true">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="VerificarEmpleadoCompra"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setData(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>


    <cffunction name="eliminarCuentasBancarias" access="public" returntype="Any">
            <cfargument name="id_Proveedor" type="string" required="false">
            <cfargument name="id_CuentaBancaria" type="string" required="false">
            <cfargument name="nb_CuentaBancaria" type="string" required="false">
            <cfargument name="id_TipoTransferencia"  type="string" required="false">
            <cfargument name="nb_ClaveProveedor"     type="string" required="false">
            <cfargument name="nu_ClabeInterbancaria" type="string" required="false">
            <cfargument name="id_Banco"              type="string" required="false">
            <cfargument name="id_Moneda"             type="string" required="false">
            <cfargument name="de_Concepto"           type="string" required="false">

            <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                method="eliminarCuentasBancarias"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">
        <!--- Modal de facturas pendientes de pago --->
            <!--- <cfset variables.RBR.setQuery(local.rs)> --->
            <cfreturn variables.RBR>s
    </cffunction>

    <cffunction name="ReporteAuxiliarPagos"    access="public"     returntype="Any">
        <cfargument name="arr_Empresas"         type="string"   required="false"/>
        <cfargument name="arr_Sucursarles"      type="string"   required="false"/>
        <cfargument name="arr_Proveedores"      type="string"   required="false"/>
        <cfargument name="fh_Inicio"            type="string"   required="false"/>
        <cfargument name="fh_Fin"               type="string"   required="false"/>
        <cfargument name="id_TipoNegocio"       type="string"   required="false"/>


        <cfinvoke   component="#Application.RF.getPath('dao','Proveedores')#"
                    method="ReporteAuxiliarPagos"
                    argumentcollection="#arguments#"
                    returnvariable="local.RS"/>

        <cfif #local.RS.datos.recordcount# EQ 0>
          <cfset variables.RBR.setError('No existen registros para mostrar.')>
          <cfreturn Variables.RBR>
        </cfif>

        <cfset variables.RBR.setData(local.RS)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ProveedoresServicios_listar" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="ProveedoresServicios_listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarCMF" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="string" required="false"/>
        <cfargument name="id_Sucursal"      type="string" required="false"/>
        <cfargument name="id_Proveedor"     type="string" required="false"/>
        <cfargument name="id_Estatus"       type="string" required="false"/>
        <cfargument name="fh_inicio"        type="string" required="false"/>
        <cfargument name="fh_fin"           type="string" required="false"/>
        <cfargument name="page"             type="string" required="false"/>
        <cfargument name="pageSize"         type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="ListarCMF"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs.INFOLIST">

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="ListarCMFReporte"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs.RPT">

        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarProveedorPermisosCRE" access="public" returntype="Any">
        <cfargument name="id_Proveedor"     type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                    method="ListarProveedorPermisosCRE"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EliminarPermisoCRE"     access="public" returntype="Any">
        <cfargument name="id_Proveedor"                 type="numeric" required="true"/>
        <cfargument name="id_ProveedorPermiso"          type="numeric" required="true"/>

        <cfinvoke   component="#Application.RF.getPath('dao','proveedores')#"
        method="EliminarPermisoCRE"
        argumentcollection="#arguments#">


        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>

    </cffunction>

    <cffunction name="ListarProveedoresConsignacion" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
            method="ListarProveedoresConsignacion"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListarProveedoresConsignacionByInsumo" access="public" returntype="Any">
        <cfargument name="id_Proveedor" type="numeric" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','proveedores')#"
            method="ListarProveedoresConsignacionByInsumo"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarProveedoresSn_PerteneceGrupo" access="public" returntype="Any">
        <cfargument name="sn_PerteneceGrupo" type="string" required="false" default=""/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="listarProveedoresSn_PerteneceGrupo"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

     <cffunction name="AccesosPuestoEmpleado" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
                  method="AccesosPuestoEmpleado"
                  returnvariable="Local.rs">
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="PermisosPorUsuarioProv" access="public" returntype="Any">
        <cfargument name="id_Usuario" type="string" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','Proveedores')#"
            method="PermisosPorUsuarioProv"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="InfoIndicadoresPago" access="public" returntype="Any">
        <cfargument name="id_Indicador" type="string" required="false"/>

        <cfinvoke component="#Application.RF.getPath('dao','Facturacion')#"
            method="FacturasPorProveedor"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#session.ID_SUCURSAL#"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
