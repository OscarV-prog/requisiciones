<cfcomponent>
  <cfprocessingdirective pageencoding="utf-8">
  <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>
  <!--- Jesus Reyes --->
  <cffunction name="listar" access="public" returntype="Any">
      <cfargument name="id_empresa"    type="string" required="no">
      <cfargument name="id_Sucursal"   type="string" required="no">
      <cfargument name="id_Proveedor"  type="string" required="no">
      <cfargument name="id_Factura"    type="string" required="no">
      <cfargument name="de_folio"      type="string" required="no">
      <cfargument name="id_estatus"    type="string" required="no">
      <cfargument name="fh_inicio"     type="string" required="no">
      <cfargument name="fh_fin"        type="string" required="no">
      <cfargument name="cl_tipoCompra" type="string" required="no">
      <cfargument name="page"          type="string" required="no" default="">
      <cfargument name="pageSize"      type="string" required="no" default="">
      <cfset arguments.id_Usuario    = "#session.ID_USUARIO#">

      <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="listar"
                id_usuario = "#session.ID_USUARIO#"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

      <cfset variables.RBR.setQuery(Local.rs)>

      <cfreturn variables.RBR>
  </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="estatusFacturasCombo" access="public" returntype="Any">
      <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="estatusFacturasCombo"
                returnvariable="Local.rs">

      <cfset variables.RBR.setQuery(Local.rs)>

      <cfreturn variables.RBR>
  </cffunction>

  <cffunction name="validarUUID" access="public" returntype="Any">
      <cfargument name="UUID"         type="string" required="no">

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="validarUUID"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">
          <cfset variables.RBR.setQuery(Local.rs)>

      <cfreturn variables.RBR>
  </cffunction>

    <cffunction name="validarUUID2" access="public" returntype="Any">
        <cfargument name="UUID"             type="string" required="no">
        <cfargument name="id_Empresa"       type="string" required="no">
        <cfargument name="id_Sucursal"      type="string" required="no">
        <cfargument name="id_Proveedor"     type="string" required="no">
        <cfargument name="id_SolicitudPago" type="string" required="no">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="validarUUID2"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

<!--- Jesus Reyes --->
  <cffunction name="ValidarUUIDsatLocal" access="public" returntype="Any">
        <cfargument name="de_ruta"    type="string" required="true"/>
        <cfargument name="nb_archivo" type="string" required="true"/>

        <!--- obtenemos el documento --->
        <cfset xmlFile = expandPath("/root/#arguments.de_ruta##arguments.nb_archivo#")>
        <cfset xmlString = ''>
        <cffile action="Read" file="#xmlFile#" variable="XMLContent">

        <cfif isXML(XmlParse(XMLContent))>
          <cfset xmlString = XmlParse(XMLContent)>
        <cfelse>
          <!--- El Archivo XML esta dañado --->
          <cfset variables.RBR.setError('El documento XML no se pudo leer o el archivo esta dañado. Favor de varificar.')>
          <cfreturn variables.RBR>
        </cfif>

        <cfset doc = structNew()>
        <cfif #len(XmlSearch( xmlString, '/cfdi:Comprobante[1]/cfdi:Complemento'))# EQ 0>
            <!---/**
             * Si no lo pudo leer el componente, intentamos que la base de datos lo lea
             * !!! si realiza la lectura de manera exitosa por este metodo devolvera la estructura
             * !!! de la info ligeramente diferente - tener en cuenta al usar esta funcion
             */--->
            <cfinvoke component="#Application.RF.getPath('dao','DocumentosProductosProveedores')#"
                method="upR_Parse_XML_Proveedores"
                DE_XML = "#xmlString#"
                returnvariable="doc">


            <!--- <cfcontent type="text/html">
            <cfdump var="#doc#" format="simple" label="arguments" abort="true"> --->

            <cfif doc.Documento.UUID NEQ nullValue()>
                <cfset xml = XmlParse(doc.Documento.de_XML)>
                <cfset xmlString_limpio = REReplace( xmlString, "^[^<]*", "", "all" )>
                <cfset xmlData = xmlParse(xmlString_limpio)>

                <cfset documento = structNew()>
                <cfset documento.EmisorRFC = "#doc.Documento.Emisor_rfc#">
                <cfset documento.EmisorRFC = UCase(REReplace(documento.EmisorRFC,'&','&amp;','ALL') )>
                <cfset documento.ReceptorRFC = "#UCase(doc.Documento.Receptor_rfc)#">
                <cfset documento.total = "#doc.Documento.total#">
                <cfset documento.UUID = "#UCase(doc.Documento.UUID)#">
                <cfset documento.UUIDFacturaRelacionada = "#UCase(doc.RelacionadosNC.UUID)#">
                <cfset documento.Estado = ''>
                <cfset documento.documento = xmlData>
                <cfset documento.total = #numberFormat(documento.total, '.999999')#>
            <cfelse>
                <cfset variables.RBR.setError('El documento XML no se encuentra timbrado, ó su estructura no es valida.')>
                <cfreturn variables.RBR>
            </cfif>

        <cfelse>
            <cfset nodo = XmlChildPos(xmlString.Comprobante.Complemento,"CFDIRegistroFiscal",1)>
            <cfif nodo EQ 1 >
                <cfset ArrayDeleteAt(xmlString.Comprobante.Complemento.XmlChildren,nodo)>
            </cfif>
            <cfset xmlString_limpio = REReplace( xmlString, "^[^<]*", "", "all" )>

            <cfset xmlData = xmlParse(xmlString_limpio)>

            <!--- recuperamos los datos necesarios para la validacion --->
            <cfset documento = structNew()>
            <cfset documento.EmisorRFC = "#xmlData.Comprobante.Emisor.XmlAttributes.rfc#">
            <cfset documento.EmisorRFC = UCase(REReplace(documento.EmisorRFC,'&','&amp;','ALL') )>
            <cfset documento.ReceptorRFC = "#UCase(xmlData.Comprobante.Receptor.XmlAttributes.rfc)#">
            <cfset documento.total = "#xmlData.Comprobante.XmlAttributes.total#">
            <cfset documento.UUID = "#UCase(xmlData.Comprobante.Complemento.TimbreFiscalDigital.XmlAttributes.UUID)#">
            <cfset documento.Estado = ''>
            <cfset documento.documento = xmlData>
            <cfset documento.total = #numberFormat(xmlData.Comprobante.XmlAttributes.total, '.999999')#>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="obtenerWebserviceValidacion"
            returnvariable="Local.rs">

        <!--- Validamos con un 3ro --->
        <cfif local.rs.Validacion EQ 1>
          <cfset urlServicioSat ='http://www.gncys.com/cfdistatus/consulta.aspx?re=#UCase(documento.EmisorRFC)#&rr=#UCase(documento.ReceptorRFC)#&tt=#documento.total#&id=#UCase(documento.UUID)#'>
          <cfhttp url="#urlServicioSat#"
              timeout="15"
              throwOnError="true"
              method="get"
              result="Response"
              charset="utf-8"
              port="80">
          </cfhttp>
          <cfset Respuesta = Response.Filecontent.toString()>
          <cfset Respuesta = Replace(Respuesta, "'", '"', 'all')>

          <cfset ResponseJson = deserializeJSON(REspuesta)>
          <cfset documento.Estado   = ResponseJson.Estado>
        </cfif>

        <!--- Realizamos la consulta al servicio del SAT --->
        <cfif local.rs.Validacion EQ 2>
          <cfset Local = structNew()>
          <cfset Local.ws = createObject("webservice", "https://consultaqr.facturaelectronica.sat.gob.mx/ConsultaCFDIService.svc?wsdl")>
          <cfset Local.ss = Local.ws.consulta('re=#documento.EmisorRFC#&rr=#documento.ReceptorRFC#&tt=#documento.total#&id=#documento.UUID#')>

          <cfif #isDefined('Local.ss.estado')#>
              <cfset documento.Estado = #local.ss.estado#>
            <cfelse>
              <cfset documento.Estado = 'Vigente'>
          </cfif>
        </cfif>

        <cfset variables.RBR.setData(documento)>
        <cfreturn variables.RBR>
   </cffunction>


    <cffunction name="Agregar" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="yes">
        <cfargument name="id_Sucursal"          type="string" required="yes">
        <cfargument name="id_Proveedor"         type="string" required="yes">
        <cfargument name="id_Factura"           type="string" required="no">
        <cfargument name="cl_tipoCompra"        type="string" required="no">
        <cfargument name="sn_pdf"               type="any"    required="yes">
        <cfargument name="datosXML"             type="any"    required="no">
        <cfargument name="datosPDF"             type="any"    required="yes">
        <cfargument name="fl_FolioFactura"      type="string" required="no" default="">
        <cfargument name="im_TotalFactura"      type="string" required="no" default="">
        <cfargument name="fh_Factura"           type="string" required="no" default="">
        <cfargument name="im_ImporteExtra"      type="string" required="no" default="">
        <cfargument name="im_SubtotalGeneral"   type="string" required="no" default="">
        <cfargument name="datosNC"              type="struct" required="no">
        <cfargument name="sn_DescuentoNC"       type="string" required="no">

        <cfif isDefined("arguments.datosXML")>
            <cfset xmlFile = expandPath("/root/#arguments.datosXML.de_Ruta##arguments.datosXML.nb_Archivo#")>
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
                    returnvariable="ResponseXML"/>

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
                * Si no encontro el UUID, significa que es un documento valido mas no lo pudo leer adecuadamente
                * por lo que realizamos la lectura por medio de BD
                */--->
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProductosProveedores')#"
                        method="upR_Parse_XML_Proveedores"
                        DE_XML = "#ResponseXML.documento.de_XML#"
                        returnvariable="doc">

                <cfset ResponseXML.documento = doc.Documento >
            </cfif>
        </cfif>

        <!--- Obtenemos las variables para realizar el registro --->
        <cfset xml               = structNew()>
        <cfset xml.id_Empresa    = "#arguments.id_Empresa#">
        <cfset xml.id_Sucursal   = "#arguments.id_Sucursal#">
        <cfset xml.id_Proveedor  = "#arguments.id_Proveedor#">
        <cfset xml.cl_tipoCompra = "#arguments.cl_tipoCompra#">
        <cfset xml.de_RutaPDF    = "#arguments.datosPDF.de_ruta#">
        <cfset xml.de_NombrePDF  = "#arguments.datosPDF.nb_archivo#">
        <cfset xml.id_Moneda     = "#arguments.id_Moneda#">
        <cfset xml.id_Usuario    = "#session.ID_USUARIO#">
        <cfset xml.id_Estatus    = "1101">
        <cfif isDefined("arguments.datosXML")>
            <cfset xml.de_Ruta       = "#arguments.datosXML.de_Ruta#">
        </cfif>

        <!--- se prioriza el XML --->
        <cfif #IsDefined("ResponseXML.documento.UUID")#>
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="validarUUID2"
                UUID = "#ResponseXML.documento.UUID#"
                id_Empresa = "#arguments.id_Empresa#"
                id_Sucursal = "#arguments.id_Sucursal#"
                id_Proveedor = "#arguments.id_Proveedor#"
                returnvariable = "Local.documento">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.de_xml")#>
            <cfset xml.de_xml = #ResponseXML.documento.de_xml#>
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.UUID")#>
            <cfset xml.UUID    = "#ResponseXML.documento.UUID#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.version")#>
            <cfset xml.de_Serie = "#ResponseXML.documento.version#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.serie")#>
            <cfset xml.de_Serie = "#ResponseXML.documento.serie#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.folio")#>
            <cfset xml.de_Folio = "#ResponseXML.documento.folio#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.fecha")#>
            <cfset xml.de_Fecha = "#ResponseXML.documento.fecha#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.formaDePago")#>
            <cfset xml.de_FormaPago = "#ResponseXML.documento.formaDePago#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.condicionesDePago")#>
            <cfset xml.de_CondicionesPago = "#ResponseXML.documento.condicionesDePago#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.motivoDescuento")#>
            <cfset xml.de_MotivoDescuento = "#ResponseXML.documento.motivoDescuento#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.tipoDeComprobante")#>
            <cfset xml.de_TipoComprobante = "#ResponseXML.documento.tipoDeComprobante#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.metodoDePago")#>
            <cfset xml.de_MetodoPago = "#ResponseXML.documento.metodoDePago#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.LugarExpedicion")#>
            <cfset xml.de_LugarExpedicion = "#ResponseXML.documento.LugarExpedicion#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.NumCtaPago")#>
            <cfset xml.de_NumCtaPago = "#ResponseXML.documento.NumCtaPago#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.NumCtaPago")#>
            <cfset xml.de_NumCtaPago = "#ResponseXML.documento.NumCtaPago#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.FolioFiscalOrig")#>
            <cfset xml.de_FolioFiscalOriginal = "#ResponseXML.documento.FolioFiscalOrig#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.SerieFiscalOrig")#>
            <cfset xml.de_SerieFiscalOriginal = "#ResponseXML.documento.SerieFiscalOrig#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.FechaFiscalOrig")#>
            <cfset xml.de_FechaFiscalOriginal = #ResponseXML.documento.FechaFiscalOrig#>
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.total")#>
            <cfset xml.im_MontoFiscalOriginal = "#ResponseXML.documento.total#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.subtotal")#>
            <cfset xml.im_subtotal = "#ResponseXML.documento.subtotal#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.descuento")#>
            <cfset xml.im_Descuento = "#ResponseXML.documento.descuento#">
        </cfif>

        <cfif #IsDefined("ResponseXML.documento.total")#>
            <cfset xml.im_total = "#ResponseXML.documento.total#">
        </cfif>

        <cfif #IsDefined("ResponseXML.impuestos.Importe")#>
            <cfset xml.im_Iva = #ResponseXML.impuestos.Importe#>
        </cfif>

        <cfif #IsDefined("ResponseXML.impuestos")#>
            <cfloop query="ResponseXML.impuestos">
                <cfif #ResponseXML.impuestos.impuesto# EQ "IVA">
                    <cfset xml.im_RetencionIVA = "#ResponseXML.impuestos.importe#">
                </cfif>
                <cfif #ResponseXML.impuestos.impuesto# EQ "ISR">
                    <cfset xml.im_RetencionISR = "#ResponseXML.impuestos.importe#">
                </cfif>
            </cfloop>
        </cfif>

        <cfif isDefined("im_ImporteExtra")>
            <cfset xml.im_ImporteExtra = "#arguments.im_ImporteExtra#">
        </cfif>

        <cfif isDefined("im_SubtotalGeneral")>
            <cfset xml.im_SubtotalGeneral = "#arguments.im_SubtotalGeneral#">
        </cfif>

        <cfif #IsDefined("xmlData.Comprobante.Impuestos.Traslados.Traslado.XmlAttributes.impuesto")#>
            <cfset xml.im_IVA = "#ResponseXML.documAgregarnto.TotalImpuestosTrasladados#">
        </cfif>

        <cfif isDefined("id_Factura")>
            <cfset xml.id_Factura = "#arguments.id_Agregaractura#">
        </cfif>

        <!--- si no trae xml priorizamos lo que nAgregars da el usuario --->
        <cfif NOT isDefined("arguments.datosXML")>
            <!--- Si vienen sabemos que el proveedoAgregar es extranjero --->
            <cfif #IsDefined("arguments.fl_FolioFactura")#>
                <cfset xml.fl_FolioFactura = #arguments.fl_FolioFactura#>
            </cfif>
            <cfif #IsDefined("arguments.im_TotalFactura")#>
                <cfset xml.im_TotalFactura = #arguments.im_TotalFactura#>
            </cfif>
            <cfif #IsDefined("arguments.fh_Factura")#>
                <cfset xml.fh_Factura = #arguments.fh_Factura#>
            </cfif>
        </cfif>

        <cfif arguments.sn_DescuentoNC>
            <cfset xmlNcFile = expandPath("/root/#arguments.datosNC.datosXML.de_Ruta##arguments.datosNC.datosXML.nb_Archivo#")>
            <cfset xmlNcString = ''>
            <cffile action="Read" file="#xmlNcFile#" variable="XMLNcContent">

            <cfif isXML(XMLNcContent)>
                <cfset xmlNcString = XmlParse(XMLNcContent)>
            <cfelse>
                <!--- El Archivo XML esta dañado --->
                <cfset variables.rbr.seterror('El documento XML de la nota de crédito no se pudo leer o el archivo está dañado. Favor de varificar.')>
                <cfreturn variables.rbr>
            </cfif>
            <cfset XMLNcStringLimpio = REReplace(toString(xmlNcString), "^[^<]*", "", "all" )>

            <cftry>
              <!--- Primer intento con el String del XML Limpio --->
                <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                    method="parseStringToXML"
                    XML_CFDI = "#XMLNcStringLimpio#"
                    returnvariable="ResponseNcXML"/>

                <cfcatch type="any">
                    <cftry>
                        <!--- Segundo intento con el contenido original del documento XML --->
                        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                            method="parseStringToXML"
                            XML_CFDI = "#XMLNcContent#"
                            returnvariable="ResponseNcXML"/>
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

            <cfif #ResponseNcXML.documento.UUID EQ nullValue()#>
                <!---/**
                * Si no encontro el UUID, significa que es un documento valido mas no lo pudo leer adecuadamente
                * por lo que realizamos la lectura por medio de BD
                */--->
                <cfinvoke component="#Application.RF.getPath('dao','DocumentosProductosProveedores')#"
                        method="upR_Parse_XML_Proveedores"
                        DE_XML = "#ResponseNcXML.documento.de_XML#"
                        returnvariable="doc">

                <cfset ResponseNcXML.documento = doc.Documento>
            </cfif>

            <cfif #IsDefined("#ResponseNcXML.documento.UUID#")#>
                <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                    method="validarUUID2"
                    UUID="#ResponseNcXML.documento.UUID#"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Sucursal="#arguments.id_Sucursal#"
                    id_Proveedor="#arguments.id_Proveedor#"
                    returnvariable="Local.documentoNc">
            </cfif>

            <cfif #IsDefined("ResponseNcXML.documento.subtotal")#>
                <cfset xml.im_subtotal_NC = "#ResponseNcXML.documento.subtotal#">
            </cfif>

            <cfif #IsDefined("ResponseNcXML.documento.total")#>
                <cfset xml.im_total_NC = "#ResponseNcXML.documento.total#">
            </cfif>

            <cfif #IsDefined("ResponseNcXML.documento.UUID")#>
                <cfset xml.UUID_NC = "#ResponseNcXML.documento.UUID#">
            </cfif>

            <cfif isDefined("xml.UUID")>
                <cfif xml.UUID_NC EQ xml.UUID>
                    <cfthrow type="warning" message="El XML cargado para la factura no puede ser el mismo que el de la nota de crédito.">
                    <cfreturn>
                </cfif>
            </cfif>
        </cfif>

        <!--- agregamos el registro a la tabla de DocumentosProveedoresCFDI30 --->
        <!--- Si viene el id factura, se edita --->
        <cfif isDefined("id_Factura")>
            <cfset local.id_Factura = "#arguments.id_Factura#">

            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="editar"
                argumentcollection="#xml#"
                returnvariable="Local.rs">
        <cfelse>
            <!--- si no viene el id_Factura, agrega --->
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="agregar"
                argumentcollection="#xml#"
                returnvariable="Local.rs">

            <cfset local.id_Factura = "#Local.rs.id_Factura#">
        </cfif>

        <!--- Si se subio el pdf, se actualiza la ruta --->
        <cfif #sn_pdf#>
            <cfset pathLocal = "/root/#arguments.datosPDF.de_Ruta##arguments.datosPDF.nb_Archivo#">
            <cfset xml.de_RutaPDF = "Documentos/#arguments.id_Empresa#/Proveedores/#arguments.id_Proveedor#/Facturas/#local.id_Factura#/">

            <cfif isDefined("xml.UUID")>
                <cfset xml.de_NombrePDF = "F_#xml.UUID#.pdf">
            <cfelse>
                <cfset xml.de_NombrePDF = #arguments.datosPDF.nb_Archivo#>
            </cfif>

            <cfset argsSubirArchivoPDF = structnew()>
            <cfset argsSubirArchivoPDF.fileField = pathLocal>
            <cfset argsSubirArchivoPDF.nb_archivo = xml.de_NombrePDF>
            <cfset argsSubirArchivoPDF.de_PathDestino = xml.de_RutaPDF>
            <cfset argsSubirArchivoPDF.rename = false>

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                method="subirArchivoGoogle"
                argumentcollection="#argsSubirArchivoPDF#"
                returnvariable="RSFileUploadPDF">

            <!--- Guardamos el path final en base de datos --->
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="updatePDF"
                argumentcollection="#arguments#"
                id_Factura = "#local.id_Factura#"
                nb_archivo = "#xml.de_NombrePDF#"
                de_ruta = "#xml.de_RutaPDF#">

            <!--- Eliminamos archivo PDF Local porque ya no lo necesitamos--->
            <cfif FileExists(pathLocal)>
                <cffile action="delete" file="#pathLocal#">
            </cfif>
        </cfif>

        <!--- Si se subio el XML, se actualiza la ruta --->
        <cfif isDefined("arguments.datosXML")>

            <cfset pathLocal = expandPath("/root/#arguments.datosXML.de_Ruta##arguments.datosXML.nb_archivo#")>
            <cfset xml.de_Ruta = "Documentos/#arguments.id_Empresa#/Proveedores/#arguments.id_Proveedor#/Facturas/#local.id_Factura#/">

            <cfif isDefined("xml.UUID")>
                <cfset xml.nb_Archivo = "F_#xml.UUID#.xml">
            <cfelse>
                <cfset xml.nb_Archivo = #arguments.datosXML.nb_archivo#>
            </cfif>

            <cfset argsSubirArchivoXML = structnew()>
            <cfset argsSubirArchivoXML.fileField = pathLocal>
            <cfset argsSubirArchivoXML.nb_archivo = xml.nb_Archivo>
            <cfset argsSubirArchivoXML.de_PathDestino = xml.de_Ruta>
            <cfset argsSubirArchivoXML.rename = false>

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                method="subirArchivoGoogle"
                argumentcollection="#argsSubirArchivoXML#"
                returnvariable="RSFileUploadXML">

            <!--- <cffile action="move"  source="#Origen#" destination="#Destino#" nameConflict="Overwrite">  --->
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="updateXML"
                argumentcollection="#arguments#"
                id_Factura = "#local.id_Factura#"
                nb_archivo = "#xml.nb_archivo#"
                de_ruta = "#xml.de_Ruta#">

            <cfif FileExists(pathLocal)>
                <cffile action="delete" file="#pathLocal#">
            </cfif>
        </cfif>

        <cfif arguments.sn_DescuentoNC>
            <!--- Subimos el documento XML --->
            <cfset pathLocalNcXml = expandPath("/root/#arguments.datosNC.datosXML.de_Ruta##arguments.datosNC.datosXML.nb_archivo#")>
            <cfset xmlNC.de_Ruta = "Documentos/#arguments.id_Empresa#/Proveedores/#arguments.id_Proveedor#/Facturas/#local.id_Factura#/NotasCredito/">

            <cfif isDefined("xml.UUID_NC")>
                <cfset xmlNC.nb_Archivo = "NC_#xml.UUID_NC#.xml">
            <cfelse>
                <cfset xmlNC.nb_Archivo = #arguments.datosNC.datosXML.nb_archivo#>
            </cfif>

            <cfset argsSubirArchivoNcXML = structnew()>
            <cfset argsSubirArchivoNcXML.fileField = pathLocalNcXml>
            <cfset argsSubirArchivoNcXML.nb_archivo = xmlNC.nb_Archivo>
            <cfset argsSubirArchivoNcXML.de_PathDestino = xmlNC.de_Ruta>
            <cfset argsSubirArchivoNcXML.rename = false>

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                method="subirArchivoGoogle"
                argumentcollection="#argsSubirArchivoNcXML#"
                returnvariable="RSFileUploadNcXML">

            <!--- Subimos el documento PDF --->
            <cfset pathLocalNcPDF = expandPath("/root/#arguments.datosNC.datosPDF.de_Ruta##arguments.datosNC.datosPDF.nb_archivo#")>
            <cfset pdfNC.de_Ruta = "Documentos/#arguments.id_Empresa#/Proveedores/#arguments.id_Proveedor#/Facturas/#local.id_Factura#/NotasCredito/">

            <cfif isDefined("xml.UUID_NC")>
                <cfset pdfNC.nb_Archivo = "NC_#xml.UUID_NC#.pdf">
            <cfelse>
                <cfset pdfNC.nb_Archivo = #arguments.datosNC.datosPDF.nb_archivo#>
            </cfif>

            <cfset argsSubirArchivoNcPDF = structnew()>
            <cfset argsSubirArchivoNcPDF.fileField = pathLocalNcPDF>
            <cfset argsSubirArchivoNcPDF.nb_archivo = pdfNC.nb_Archivo>
            <cfset argsSubirArchivoNcPDF.de_PathDestino = pdfNC.de_Ruta>
            <cfset argsSubirArchivoNcPDF.rename = false>

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                method="subirArchivoGoogle"
                argumentcollection="#argsSubirArchivoNcPDF#"
                returnvariable="RSFileUploadNcPDF">

            <!--- Actualizamos las rutas en la BD --->
            <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="actualizarRutasNC"
                argumentcollection="#arguments#"
                id_Factura="#local.id_Factura#"
                nb_archivoXml="#xmlNC.nb_archivo#"
                nb_archivoPdf="#pdfNC.nb_Archivo#"
                de_ruta="#pdfNC.de_Ruta#">

            <cfif FileExists(pathLocalNcXml)>
                <cffile action="delete" file="#pathLocalNcXml#">
            </cfif>
            <cfif FileExists(pathLocalNcPDF)>
                <cffile action="delete" file="#pathLocalNcPDF#">
            </cfif>
        </cfif>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>


  <!--- Jesus Reyes --->
  <cffunction name="generarXML" access="public" returntype="Any">
      <cfargument name='id_Empresa'           type='string'  required='false'>
      <cfargument name='id_Sucursal'          type='string'  required='false'>
      <cfargument name='id_Proveedor'         type='string'  required='false'>
      <cfargument name='id_Factura'           type='string'  required='false'>

          <cfif #arguments.id_Empresa# EQ ''>
              <cfset #arguments.id_Empresa# = #session.ID_EMPRESA#>
          </cfif>

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="getXML"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

         <!--- <cfcontent type="text/html">
          <cfdump var="#arguments#" label="dump">
          <cfdump var="#Local.rs#" label="dump" abort="true">
         --->

          <cfif (#local.rs.RecordCount# EQ 0) OR (#LEN(Local.rs.DE_XML)# EQ 0)>
              <cfset variables.RBR.setError('No se encontro el documento XML en el servidor.')>
              <cfreturn Variables.RBR>
          </cfif>

            <cfset Local.documento = structNew()>
            <cfif #Local.rs.uuid# NEQ '' OR isDefined("#Local.rs.uuid#")>
                <cfset #Local.documento.nb_archivo# = 'F_#Local.rs.uuid#.xml'>
                <cfset #Local.documento.de_rutaXML# = expandPath('../'&#Local.rs.de_ruta#&'/'&#Local.documento.nb_archivo#)>
                <cfset #Local.documento.de_ruta# = #Local.rs.de_ruta#>
                <cfset #Local.documento.UUID# = #Local.rs.uuid#>
            <cfelse>
                <cfthrow type="warning" message="No se pudo encontrar la clave UUID del documento.<br>Favor de revisar que el documento se haya subido correctamente.">
                <cfreturn>
            </cfif>

          <!--- obtenemos el documento --->
          <cfset XMLContent = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.documento.de_ruta##Local.documento.nb_archivo#">

          <cfset argsObtenerArchivoXML = structnew()/>
          <cfset argsObtenerArchivoXML.path = "#Local.documento.de_ruta##Local.documento.nb_archivo#"/>
          <cfset argsObtenerArchivoXML.getContent = true/>

          <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
              method="obtenerArchivo"
              argumentcollection="#argsObtenerArchivoXML#"
              returnvariable="RSExistsXML">

           <!--- <cfcontent type="text/html">
           <cfdump var="#RSExistsXML#" label="dump" abort="true"> --->

        <cfif NOT RSExistsXML.ISOK> <!--- Volvemos a buscar el XML si es que no se encontro pero ahora con el nombre del documento del guardado en BD --->
            <cfset nb_Documento = ListFirst(Local.rs.de_NombrePDF, ".")>

            <cfset #Local.documento.nb_archivo# = '#nb_Documento#.xml'>

            <!--- obtenemos el documento --->
            <cfset XMLContent = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.documento.de_ruta##Local.documento.nb_archivo#">

            <cfset argsObtenerArchivoXML = structnew()/>
            <cfset argsObtenerArchivoXML.path = "#Local.documento.de_ruta##Local.documento.nb_archivo#"/>
            <cfset argsObtenerArchivoXML.getContent = true/>

            <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
                method="obtenerArchivo"
                argumentcollection="#argsObtenerArchivoXML#"
                returnvariable="RSExistsXML">
        </cfif>

          <cfif RSExistsXML.ISOK EQ false>
              <cfset variables.rbr.seterror(#RSExistsXML.MSG#)>
              <cfreturn variables.rbr>
            <cfelse>
              <cfset XMLContent = #RSExistsXML.DATA.CONTENT#>
          </cfif>

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="parseStringToXML"
                XML_CFDI="#XMLContent#"
                returnvariable="Local.rs">

          <cfset Local.documento.xml = Local.rs>

          <cfset variables.RBR.setData(Local.documento)>
      <cfreturn variables.RBR>
  </cffunction>

      <cffunction name="generarXMLNCAsociadoAFactura" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="string" required="false">
        <cfargument name="id_Sucursal"  type="string" required="false">
        <cfargument name="id_Proveedor" type="string" required="false">
        <cfargument name="id_Factura"   type="string" required="false">

        <cfif #arguments.id_Empresa# EQ ''>
            <cfset #arguments.id_Empresa# = #session.ID_EMPRESA#>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="getXMLNCAsociadoAFactura"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfif (#local.rs.RecordCount# EQ 0) OR (#LEN(Local.rs.UUID)# EQ 0)>
            <cfset variables.RBR.setError('No se encontro el documento XML en el servidor.')>
            <cfreturn Variables.RBR>
        </cfif>

        <cfset Local.documento = structNew()>
        <cfif #Local.rs.uuid# NEQ '' OR isDefined("#Local.rs.uuid#")>
            <cfset #Local.documento.nb_archivo# = Local.rs.de_NombreXML>
            <cfset #Local.documento.de_rutaXML# = expandPath('../'&#Local.rs.de_ruta#&'/'&#Local.documento.nb_archivo#)>
            <cfset #Local.documento.de_ruta# = #Local.rs.de_ruta#>
            <cfset #Local.documento.UUID# = #Local.rs.uuid#>
        <cfelse>
            <cfthrow type="warning" message="No se pudo encontrar la clave UUID del documento.<br>Favor de revisar que el documento se haya subido correctamente.">
            <cfreturn>
        </cfif>

        <!--- obtenemos el documento --->
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
            <cfset XMLContent = #RSExistsXML.DATA.CONTENT#>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="parseStringToXML"
            XML_CFDI="#XMLContent#"
            returnvariable="Local.rs">

        <cfset Local.documento.xml = Local.rs>

        <cfset variables.RBR.setData(Local.documento)>
        <cfreturn variables.RBR>
    </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="generarPDF" access="public" returntype="Any">
      <cfargument name='id_Empresa'           type='string'  required='false'>
      <cfargument name='id_Sucursal'          type='string'  required='false'>
      <cfargument name='id_Proveedor'         type='string'  required='false'>
      <cfargument name='id_Factura'           type='string'  required='false'>
      <cfargument name='id_documento'         type='string'  required='false'>

          <cfif #arguments.id_Empresa# EQ ''>
              <cfset #arguments.id_Empresa# = #session.ID_EMPRESA#>
          </cfif>

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="getXML"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">


              <cfif #local.rs.RecordCount# EQ 0>
                  <cfset variables.RBR.setError('No se encontro el documento PDF en el servidor.')>
                  <cfreturn Variables.RBR>
              </cfif>


              <cfset Local.documento = structNew()>
              <cfset #Local.documento.nb_archivo# = #Local.rs.de_NombrePDF#>
              <cfset #Local.documento.de_ruta# = #Local.rs.de_RutaPDF#>

          <cfset variables.RBR.setData(Local.documento)>
      <cfreturn variables.RBR>
  </cffunction>

  <!--- Jesus Reyes --->
    <cffunction name="cancelar" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="no">
        <cfargument name="id_Sucursal"          type="string" required="no">
        <cfargument name="id_Proveedor"         type="string" required="no">
        <cfargument name="id_Factura"           type="string" required="no">
        <cfargument name="de_Email"             type="string" required="no">
        <cfargument name="nu_FolioDocumento"    type="string" required="no">
        <cfargument name="de_Observaciones"     type="string" required="no" default="">
        <cfargument name="nb_Proveedor"         type="string" required="false" default="">
        <cfargument name="de_MotivoCancelacion" type="string" required="false" default="">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="cancelar"
            id_Usuario="#session.ID_USUARIO#"
            argumentcollection="#arguments#">

        <cfif arguments.de_Email NEQ ''>
            <!--- Enviar correo de notificacion al comprador --->
            <cfset correo = structNew()>
            <cfset correo.destinatarios = arrayNew(1)>

            <!---<cfset arrayAppend(correo.destinatarios, 'SistemaPetroil@gmail.com')>--->
            <cfset arrayAppend(correo.destinatarios, #arguments.de_Email#)>
            <cfset arrayAppend(correo.destinatarios, #session.DE_EMAIL#)>

            <cfset correo.asunto                      = 'Notificación de Cancelación de Factura'>
            <cfset correo.sn_plantilla                = "true">
            <cfset correo.dir_plantilla               = "templates/correos/Proveedores/templateMailCancelarFactura.html">
            <cfset correo.parametros                  = structNew()>
            <cfset correo.parametros.asunto           = 'Cancelaci&oacute;n de Factura.'>
            <cfset correo.parametros.de_Mensaje       = 'La factura del proveedor: <b>' & Arguments.nb_Proveedor & '</b> con el Folio: <b>' & Arguments.nu_FolioDocumento & '</b> ha sid&oacute; cancelada.'>
            <cfset correo.parametros.nb_Movimiento    = 'Cancel&oacute;'>
            <cfset correo.parametros.nb_Empleado      = UCase(session.NB_EMPLEADOCOMPLETO)>
            <cfset correo.parametros.de_Fecha         = DateFormat(Now(), 'dd/mm/yyyy') & ' ' & TimeFormat(Now(), "hh:mm:ss tt") >
            <cfset correo.parametros.de_Observaciones = #Arguments.de_MotivoCancelacion#>

            <cfset correo.imagenes=[
                {
                    dir="#session.AR_IMAGENREPORTE#",
                    disposicion='inline',
                    name="logo"
                },
                <!--- {
                    dir="assets/img/greenLeaf.jpg",
                    disposicion='inline',
                    name="footer"
                } --->
            ]>

            <cfif #arrayLen(correo.destinatarios)# GT 0>
                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                        method="sendMail"
                        argumentcollection="#correo#"
                        returnvariable="Local.rbr"/>

                <cfif Local.rbr.hasError()>
                    <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                    <cfreturn variables.RBR>
                <cfelse>
                    <cfset variables.RBR.setMessage("Se envi&oacute; notificaci&oacute;n al responsable. Operaci&oacute;n exitosa. ")>
                    <cfreturn variables.RBR>
                </cfif>
            </cfif>
        </cfif>

        <!---/**
        * Se realiza la actualizacion de estatus de la requisicionCMF si es que se cancela la factura
        * (si es que es una, lo verifica dentro del SP)
        */--->
        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                method="ActualizarEstatusCMF"
                id_Empresa="#arguments.id_Empresa#"
                id_Sucursal="#arguments.id_Sucursal#"
                id_Proveedor="#arguments.id_Proveedor#"
                id_Factura="#arguments.id_Factura#"
                id_estatus="1102">

        <cfset Variables.RBR.setMessage("Operaci&oacute;n exitosa")>

        <cfreturn variables.RBR>
    </cffunction>

  <!--- Jesus Reyes --->
    <cffunction name="FacturaEnviarRevision" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="string" required="no">
        <cfargument name="id_Sucursal"  type="string" required="no">
        <cfargument name="id_Proveedor" type="string" required="no">
        <cfargument name="id_Factura"   type="string" required="no">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="FacturaEnviarRevision"
            id_Usuario="#session.ID_USUARIO#"
            argumentcollection="#arguments#"
            returnvariable="local.rs">

        <cfset variables.RBR.setData(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="FacturasListadoExcel"    access="public"     returntype="Any">
      <cfargument name='id_Empresa'           type='string'  required='false'>
      <cfargument name='nb_Empresa'           type='string'  required='false'>
      <cfargument name='id_Sucursal'          type='string'  required='false'>
      <cfargument name='nb_Sucursal'          type='string'  required='false'>
      <cfargument name='id_Proveedor'         type='string'  required='false'>
      <cfargument name='nb_Proveedor'         type='string'  required='false'>
      <cfargument name='id_estatus'           type='string'  required='false'>
      <cfargument name='nb_estatus'           type='string'  required='false'>
      <cfargument name='de_Folio'             type='string'  required='false'>
      <!--- Fecha formato YYYY/mm/dd --->
      <cfargument name='fh_inicio'            type='string'  required='false'>
      <cfargument name='fh_fin'               type='string'  required='false'>
      <!--- Fecha formato dd/mm/YYYY --->
      <cfargument name='fh_inicio2'           type='string'  required='true'>
      <cfargument name='fh_fin2'              type='string'  required='true'>
      <cfargument name="cl_tipoCompra"        type="string"  required="false">
      <cfset arguments.id_Usuario    = "#session.ID_USUARIO#">

          <!--- consultamos los datos --->
          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="listar"
                argumentcollection="#arguments#"
                sn_Reporte="1"
                returnvariable="datos">

          <cfif #datos.recordcount# EQ 0>
              <cfset variables.RBR.setError('No existen registros para mostrar.')>
              <cfreturn Variables.RBR>
          </cfif>

      <cfset variables.RBR.setData(datos)>
      <cfreturn Variables.RBR>
  </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="FacturasListadoPDF"    access="public"     returntype="Any">
        <cfargument name="id_Empresa"    type="string" required="false">
        <cfargument name="nb_Empresa"    type="string" required="false">
        <cfargument name="id_Sucursal"   type="string" required="false">
        <cfargument name="nb_Sucursal"   type="string" required="false">
        <cfargument name="id_Proveedor"  type="string" required="false">
        <cfargument name="nb_Proveedor"  type="string" required="false">
        <cfargument name="id_estatus"    type="string" required="false">
        <cfargument name="nb_estatus"    type="string" required="false">
        <cfargument name="de_Folio"      type="string" required="false">
        <cfargument name="fh_inicio"     type="string" required="false">
        <cfargument name="fh_fin"        type="string" required="false">
        <cfargument name="fh_inicio2"    type="string" required="true">
        <cfargument name="fh_fin2"       type="string" required="true">
        <cfargument name="cl_tipoCompra" type="string" required="false">

        <cfset arguments.id_Usuario = "#session.ID_USUARIO#">

        <!--- Consultamos los datos --->
        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="listar"
            argumentcollection="#arguments#"
            sn_Reporte="1"
            returnvariable="datos">

        <cfif #datos.recordcount# EQ 0>
            <cfset variables.RBR.setError('No existen registros para mostrar.')>
            <cfreturn Variables.RBR>
        </cfif>

        <!--- Vamos por el logotipo de la empresa--->
        <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
            method="listar"
            id_Empresa="#arguments.id_Empresa#"
            nb_Empresa="#arguments.nb_Empresa#"
            returnvariable="empresa">

        <!--- Si no tiene imagen para los reportes nos traemos el logotipo --->
        <cfset ar_imagen = #empresa.ar_ImagenReporte#>
        <cfif #ar_imagen# EQ ''>
            <cfset ar_imagen = #empresa.ar_ImagenLogo#>
        </cfif>

        <!--- Continuamos con la elaboracion del reporte --->
        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="FacturasListadoPDF#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfsavecontent variable="DocumentodeEntrega">
            <cfinclude template="../../templates/reportes/Portal/FacturasListado.html">
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
  <cffunction name="ayudaFacturas" access="public" returntype="Any">
      <cfargument name="id_empresa"   type="string" required="no">
      <cfargument name="id_Sucursal"  type="string" required="no">
      <cfargument name="id_Proveedor" type="string" required="no">
          <cfif #arguments.id_empresa# EQ ''>
              <cfset #arguments.id_Empresa# = #session.ID_EMPRESA#>
          </cfif>

          <!--- <cfif #arguments.id_Sucursal# EQ ''>
              <cfset #arguments.id_Sucursal# = #SESSION.ID_SUCURSAL#>
          </cfif> --->

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="ayudaFacturas"
                id_SucursalSession="#SESSION.ID_SUCURSAL#"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

          <cfset variables.RBR.setQuery(Local.rs)>
      <cfreturn variables.RBR>
  </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="parseXML" access="public" returntype="Any">
      <cfargument name="de_ruta"         type="string" required="true"/>
      <cfargument name="nb_archivo"      type="string" required="true"/>
      <cfargument name="sn_bocket"       type="string" required="false" default="0"/>
      <cfargument name="id_Empresa"      type="string" required="true"/>
      <cfargument name="id_Sucursal"     type="string" required="true"/>
      <cfargument name="sn_SubirFactura" type="string" required="false" default="0"/>

      <cfif arguments.sn_bocket EQ 0>
        <cfset xmlFile = expandPath("/root/#arguments.de_Ruta##arguments.nb_Archivo#")>
        <cffile action="Read" file="#xmlFile#" variable="XMLContent">
      <cfelse>
        <!--- obtenemos el documento --->
        <cfset XMLContent = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#arguments.de_ruta##arguments.nb_archivo#">

        <cfset argsObtenerArchivoXML = structnew()/>
        <cfset argsObtenerArchivoXML.path = "#arguments.de_ruta##arguments.nb_archivo#"/>
        <cfset argsObtenerArchivoXML.getContent = true/>

        <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
            method="obtenerArchivo"
            argumentcollection="#argsObtenerArchivoXML#"
            returnvariable="RSExistsXML">

        <cfif RSExistsXML.ISOK EQ false>
            <cfset variables.rbr.seterror(#RSExistsXML.MSG#)>
            <cfreturn variables.rbr>
          <cfelse>
            <cfset XMLContent = #RSExistsXML.DATA.CONTENT#>
        </cfif>
      </cfif>

    <cfset xmlString = ''>


    <cfif isXML(XMLContent)>
      <cfset xmlString = XmlParse(XMLContent)>
    <cfelse>
        <!--- El Archivo XML esta dañado --->
        <cfset variables.rbr.seterror('El documento XML no se pudo leer o el archivo esta dañado. Favor de varificar.')>
        <cfreturn variables.rbr>
    </cfif>

    <cfif not len(XmlSearch( xmlString, "/cfdi:Comprobante[1]/cfdi:Complemento"))>
      <!---/**
        * Si no lo pudo leer el componente, intentamos que la base de datos lo lea
        */--->
        <cfinvoke component="#Application.RF.getPath('dao','DocumentosProductosProveedores')#"
            method="upR_Parse_XML_Proveedores"
            DE_XML = "#xmlString#"
            returnvariable="doc">

        <cfif doc.Documento.UUID NEQ nullValue()>
            <cfset xml = XmlParse(doc.Documento.de_XML)>
            <cfset xmlString_limpio = REReplace( xmlString, "^[^<]*", "", "all" )>
        <cfelse>
            <cfset variables.RBR.setError('El documento XML no se encuentra timbrado, ó su estructura no es valida.')>
            <cfreturn variables.RBR>
        </cfif>
    <cfelse>
        <cfset nodo = XmlChildPos(xmlString.Comprobante.Complemento,"CFDIRegistroFiscal",1)>

        <cfif nodo EQ 1 >
            <cfset ArrayDeleteAt(xmlString.Comprobante.Complemento.XmlChildren,nodo)>
        </cfif>

        <cfset xmlString_limpio = REReplace( xmlString, "^[^<]*", "", "all" )>
    </cfif>



    <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
        method="parseStringToXML"
        XML_CFDI="#XMLContent#"
        returnvariable="Local.datos">

    <!--- Validamos si el usuario tiene permiso para subir xml de meses anteriores --->
    <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
        method="validarAutorizacionPeriodosAnteriores"
        id_Usuario="#session.ID_USUARIO#"
        id_Ejercicio="#Local.datos.documento.Ejercicio#"
        id_Periodo="#Local.datos.documento.Periodo#"
        argumentcollection="#arguments#"
        returnvariable="Local.rs">

        <!--- 22 septiembre 2021 --->
        <cfif #Local.rs.sn_validacionXML# EQ 1 AND sn_SubirFactura EQ 1>

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
          method="SubirFacturasProveedores_Validar"
          <!--- id_Usuario    ="#session.ID_USUARIO#" --->
          id_Empresa    ="#arguments.id_Empresa#"
          id_Ejercicio  ="#Local.datos.documento.Ejercicio#" <!---año --->
          id_Periodo    ="#Local.datos.documento.Periodo#" <!---MEs --->
          nu_Dia        ="#Local.datos.documento.Dia#"
          <!--- id_Modulo     = 11 --->
          argumentcollection="#arguments#"
        >
        </cfif> 

    <cfset datos = structNew()>
    <cfset datos.documento = xmlParse(xmlString_limpio)>
    <cfset datos.sn_validacionXML = #Local.rs.sn_validacionXML#>
    <cfset variables.RBR.setData(datos)>

    <!--- Lo eliminamos porque ya no lo necesitamos de forma local --->
    <cfif arguments.sn_bocket EQ 0>
      <cfif FileExists(xmlFile)>
        <cffile action="delete" file="#xmlFile#">
      </cfif>
    </cfif>

    <cfreturn variables.RBR>
  </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="solicitarAutorizacion" access="public" returntype="Any">
      <cfargument name="id_Empresa"   type="string" required="no">
      <cfargument name="id_Sucursal"  type="string" required="no">

          <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
              method="solicitarAutorizacion"
              id_Usuario="#session.ID_USUARIO#"
              argumentcollection="#arguments#">

      <cfreturn variables.RBR>
  </cffunction>

  <!--- Jesus Reyes --->
<cffunction name="guardarConfiguracionPeriodosAutorizados" access="public" returntype="Any">
  <cfargument name="id_Usuario" type="string" required="no" default="">
    <cfargument name="id_Empresa" type="string" required="no" default="">
    <cfargument name="id_Sucursal" type="string" required="no" default="">
    <cfargument name="id_Ejercicio" type="string" required="no" default="">
    <cfargument name="fh_Fin" type="string" required="no" default="">
    <cfargument name="hr_Fin" type="string" required="no" default="">
    <cfargument name="mi_Fin" type="string" required="no" default="">
    <cfargument name="Periodos" type="array" required="no">

  <cfset local.stringParams = ''>
  <cfloop from="1" to="#arrayLen(arguments.Periodos)#" index="local.i">
      <cfset local.stringParams = local.stringParams & '['>
      <cfset local.stringParams = local.stringParams &       #Arguments.Periodos[local.i].id_Empresa#>
      <cfset local.stringParams = local.stringParams & ',' & #Arguments.Periodos[local.i].id_Ejercicio#>
      <cfset local.stringParams = local.stringParams & ',' & #Arguments.Periodos[local.i].nu_Mes#>
      <cfset local.stringParams = local.stringParams & ']'>
  </cfloop>

  <!--- <cfcontent type="text/html">,
	<cfdump var="#arguments#" label="va" abort="true">" --->

  <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
        method="guardarConfiguracionPeriodosAutorizados"
        parametros="#local.stringParams#"
        id_UsuarioRegistro="#session.ID_USUARIO#"
        argumentcollection="#arguments#">

  <cfreturn variables.RBR>
</cffunction>


<!--- Jesus Reyes --->
<cffunction name="obtenerConfiguracionPeriodosAutorizados" access="public" returntype="Any">
  <cfargument name = "id_Empresa"    type="string" required="no" default="">
  <cfargument name = "id_Sucursal"   type="string" required="no" default="">
  <cfargument name = "id_Ejercicio"  type="string" required="no" default="">
  <cfargument name = "id_Periodo"    type="string" required="no" default="">
  <cfset arguments.id_Usuario    = "#session.ID_USUARIO#">

    <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="obtenerConfiguracionPeriodosAutorizados"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

    <cfset variables.RBR.setData(Local.rs)>

  <cfreturn variables.RBR>
</cffunction>

<!--- Jesus Reyes --->
<cffunction name="cancelarConfiguracionPeriodosAutorizados" access="public" returntype="Any">
  <cfargument name="id_Autorizacion" type="string" required="no" default="">

    <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
        method="cancelarConfiguracionPeriodosAutorizados"
        id_UsuarioCancela="#session.ID_USUARIO#"
        argumentcollection="#arguments#">

  <cfreturn variables.RBR>
</cffunction>

<cffunction name="upL_ProveedoresFacturasPagos" access="public" returntype="Any">
  <cfargument name = "id_Empresa"           type="string" required="no" default="">
  <cfargument name = "id_SucursalDocumento" type="string" required="no" default="">
  <cfargument name = "id_Documento"         type="string" required="no" default="">
  <cfargument name = "id_Sucursal"          type="string" required="no" default="">
  <cfargument name = "id_Proveedor"         type="string" required="no" default="">
  <cfargument name = "id_Factura"           type="string" required="no" default="">

  <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="upL_ProveedoresFacturasPagos"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

  <cfset variables.RBR.setQuery(Local.rs)>

  <cfreturn variables.RBR>
</cffunction>

    <cffunction name="listarPP" access="public" returntype="Any">
        <cfargument name="id_empresa"    type="string" required="true">
        <cfargument name="id_Sucursal"   type="string" required="true">
        <cfargument name="id_Proveedor"  type="string" required="true">
        <cfargument name="id_Factura"    type="string" required="true">
        <cfargument name="id_PagoParcial"   type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="listarPP"
                argumentcollection="#arguments#"
                returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="agregarPP" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true">
        <cfargument name="id_Sucursal"    type="string" required="true">
        <cfargument name="id_Proveedor"   type="string" required="true">
        <cfargument name="id_Factura"     type="string" required="true">
        <cfargument name="im_Importe"     type="string" required="true">
        <cfargument name="fh_Pago"        type="string" required="true">
        <cfargument name="de_Comentarios" type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="agregarPP"
                argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="editarPP" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true">
        <cfargument name="id_Sucursal"    type="string" required="true">
        <cfargument name="id_Proveedor"   type="string" required="true">
        <cfargument name="id_Factura"     type="string" required="true">
        <cfargument name="id_PagoParcial" type="string" required="true">
        <cfargument name="im_Importe"     type="string" required="true">
        <cfargument name="fh_Pago"        type="string" required="true">
        <cfargument name="de_Comentarios" type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="editarPP"
                argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="cancelarPP" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="string" required="true">
        <cfargument name="id_Sucursal"          type="string" required="true">
        <cfargument name="id_Proveedor"         type="string" required="true">
        <cfargument name="id_Factura"           type="string" required="true">
        <cfargument name="id_PagoParcial"       type="string" required="true">
        <cfargument name="de_MotivoCancelacion" type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="cancelarPP"
                argumentcollection="#arguments#">

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EnviarPP" access="public" returntype="Any">
        <cfargument name="id_Empresa"     type="string" required="true">
        <cfargument name="id_Sucursal"    type="string" required="true">
        <cfargument name="id_Proveedor"   type="string" required="true">
        <cfargument name="id_Factura"     type="string" required="true">
        <cfargument name="id_PagoParcial" type="string" required="true">
        <cfargument name="id_Moneda"      type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
                method="EnviarPP"
                argumentcollection="#arguments#"
                id_Empleado="#session.ID_EMPLEADO#"
                returnvariable="Local.rs">

        <cfif local.rs.id_Estatus EQ 1124 OR local.rs.id_Estatus EQ 1121>
            <cfinvoke component="#Application.RF.getPath('bro','SolicitudesPago')#"
                method="solicitarAutorizacion"
                id_Empresa="#Local.rs.id_Empresa#"
                id_SolicitudPago="#Local.rs.id_SolicitudPago#"
                id_Estatus="#local.rs.id_Estatus#"
                de_comentarios="#local.rs.de_Descripcion#"
                nu_nivelAutorizacion="#2#"
                returnvariable="Local.sp">

            <cfif Local.rs.id_Estatus EQ 1124> <!--- Si ya esta autorizado, se generan los registros para su programacion --->
                <cfinvoke component="#Application.RF.getPath('bro','SolicitudesPago')#"
                    method="AutorizarSolicitud"
                    id_SolicitudPago="#Local.rs.id_SolicitudPago#"
                    id_Estatus="#local.rs.id_Estatus#"
                    de_comentarios="#local.rs.de_Descripcion#"
                    nu_nivelAutorizacion="#3#"
                    id_SolicitudPagoDetalle="#1#"
                    returnvariable="Local.au">
            </cfif>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getEstatusValidesXML" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="getEstatusValidesXML"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getInfoNotaCreditoByFac" access="public" returntype="Any">
        <cfargument name="id_Empresa"   type="string" required="true">
        <cfargument name="id_Sucursal"  type="string" required="true">
        <cfargument name="id_Proveedor" type="string" required="true">
        <cfargument name="id_Factura"   type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','ProveedoresFacturas')#"
            method="getInfoNotaCreditoByFac"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>
</cfcomponent>
