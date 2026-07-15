<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <!--- Autor: Julio Acosta --->
    <!--- Modificacion: Rey David Dominguez
          Fecha: 13/03/2015
          Se removio el nu_telefono de los argumentos --->
    <!--- Modificacion: Rey David Dominguez
          Fecha: 07/05/2015
          Se agrego Id_departamento y fh_requerida quedo por default del dia --->
    <cffunction name="agregar"            access="public" returntype="Any">
        <cfargument name="id_Empresa"               type="numeric" required="false" >
        <cfargument name="id_SolicitudCompra"       type="numeric" required="false"/>
        <cfargument name="id_DepartamentoSolicita"          type="string"  required="true">
        <cfargument name="de_Comentarios"           type="string"  required="false"/>
        <cfargument name="envioCorreosi"            type="string"  required="false"/>
        <cfargument name="envioCorreono"            type="string"  required="false"/>
        <cfargument name="insumos"                  type="array"   required="true"/>
        <cfargument name="Contactos"                type="array"   required="true"/>
        <cfargument name="tiporequisicion"          type="string"  required="false"/>
        <cfargument name="nombre"                   type="string"  required="false"/>
        <cfargument name="ruta"                     type="string"  required="false"/>
        <cfargument name="adjuntarArchivo"          type="string"  required="false"/>

        <cfif NOT isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>


        <!--- se valida si vienen solicitud de compra, si no vienen significa que se esta haciendo una cotizacion que no viene de
        ninguna solicitud de compra, por ende se toma la sucursal de la session --->
        <cfif not isDefined("arguments.id_solicitudcompra") OR arguments.id_solicitudcompra EQ ''>
            <cfset arguments.id_SucursalSolicita = SESSION.ID_SUCURSAL>
        <cfelse>
            <!--- funcion que va por la sucursal que genero la solicitud de compra a la cual se le esta haciendo cotización--->
            <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#"
                      method="getsucursalsolicitudcompra"
                      id_Empresa = "#Arguments.id_empresa#"
                      id_solicitudcompra ="#arguments.id_SolicitudCompra#"
                      returnvariable="Local.sucursal">

            <cfset arguments.id_SucursalSolicita = local.sucursal.id_sucursal>
        </cfif>

        <cfset arguments.id_Usuario = session.ID_USUARIO>
        <cfset Arguments.fh_Requerida = dateFormat(now(),'yyyymmdd')>

            <cfif NOT variables.RBR.hasError()>
                <cfloop array="#arguments.Contactos#" index="contactoProveedor">
                    <cfset local.Identificador = structNew()>
                    <cfset arguments.id_Proveedor = contactoProveedor.id_Proveedor>
                    <cfset arguments.id_ProveedorContacto = contactoProveedor.id_Contacto>

                    <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                              method="agregarCotizacion"
                              argumentcollection="#arguments#"
                              returnvariable="Local.id_Cotizacion">

                     <cfset local.Identificador.id_Cotizacion = local.id_Cotizacion>
                     <cfset arguments.id_Cotizacion = local.id_Cotizacion>
                    <cfloop from="1" to="#arrayLen(arguments.insumos)#" index="local.i">
                        <cfset Local.detalle={
                            id_Empresa = Arguments.id_Empresa,
                            <!---id_sucursal = SESSION.ID_SUCURSAL,---><!--- No es necesaria la sucursal en el detalle...! --->
                            id_Cotizacion= local.id_Cotizacion
                        }>

                        <cfif StructKeyExists( Arguments.insumos[local.i], "Identificador")>
                            <cfif arguments.insumos[local.i].Identificador EQ 1>
                               <cfinvoke component="#Application.RF.getPath('dao','Insumos')#"
                                  method="obtenerUnidadMedidadeInsumo"
                                  id_Empresa = "#Arguments.id_Empresa#"
                                  id_insumo = "#Arguments.insumos[local.i].id_Insumo#"
                                  returnvariable="nb_unidadMedida">

                                <cfset Local.detalle.id_Insumo = arguments.insumos[local.i].id_Insumo>
                                <cfset Local.detalle.nu_Cantidad = arguments.insumos[local.i].nu_Cantidad>
                                 <cfset arguments.insumos[local.i].nb_UnidadMedida = nb_unidadMedida.NB_UNIDADMEDIDA>
                                <cfif structKeyExists(arguments.insumos[Local.i], "id_Moneda") AND arguments.insumos[local.i].id_Moneda NEQ 'null'>
                                    <cfset Local.detalle.id_Moneda = arguments.insumos[local.i].id_Moneda>
                                    <cfset Local.detalle.im_TipoCambio = arguments.insumos[local.i].im_TipoCambio>
                                </cfif>
                                <cfif  structKeyExists(arguments.insumos[Local.i], "im_ultimoPrecioCompraConvert")>
                                    <cfset Local.detalle.im_precioUnitario = arguments.insumos[local.i].im_ultimoPrecioCompraConvert>
                                    <cfset Local.detalle.im_totalInsumo = arguments.insumos[local.i].im_ultimoPrecioCompraConvert*arguments.insumos[local.i].nu_Cantidad>
                                </cfif>


                                <cfinvoke component="#Application.RF.getPath('dao','CotizacionesDetalle')#"
                                          method="AgregarCotizacionDetalle"
                                          argumentcollection="#Local.detalle#"
                                          id_SolicitudCompra = "#arguments.id_SolicitudCompra#">

                                <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                            </cfif>
                        </cfif>
                    </cfloop>
                </cfloop>


                <cfif arguments.envioCorreosi EQ 'YES'>
                    <cfset local.DatosCotiz = structNew()>
                    <cfset local.destinatarios = arrayNew(1)>

                    <cfloop array="#arguments.Contactos#" index="contactoProveedor">
                        <cfif contactoProveedor.DE_EMAIL NEQ ''>
                            <cfset arrayAppend(Local.destinatarios, contactoProveedor.DE_EMAIL)>
                        </cfif>
                    </cfloop>

                    <cfinvoke   component="#Application.RF.getPath('dao','Cotizaciones')#"
                                method="listarInformacionUsuario"
                                id_Empresa="#Arguments.id_Empresa#"
                                id_Cotizacion ="#Local.id_Cotizacion#"
                                returnvariable="local.InfoCoti">

                    <cfinvoke component="#Application.RF.getPath('dao','Empresas')#"
                                method="upR_EmpresaById"
                                id_Empresa="#Arguments.id_Empresa#"
                                returnvariable="Local.Empresa">
                    <cfset storageUrl = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/">
                    <cfset local.DatosCotiz.ar_ImagenReporte = storageUrl&Local.Empresa.ar_ImagenReporte>
                    <cfset local.DatosCotiz.id_Cotizacion = local.InfoCoti.id_Cotizacion>
                    <cfset local.DatosCotiz.nb_Empleado = local.InfoCoti.nb_Empleado>
                    <cfset local.DatosCotiz.fh_Envio = local.InfoCoti.fh_Envio>
                    <cfset local.DatosCotiz.de_Email = local.InfoCoti.de_Email>
                    <cfset local.DatosCotiz.de_Comentario = local.InfoCoti.de_Comentario>

                    <!---<cfset crearReporte(local.DatosCotiz,arguments.insumos)>--->

                     <cfinvoke
                        method="crearReporte"
                        DatosCotiz="#local.DatosCotiz#"
                        Insumos="#arguments.insumos#"
                        returnvariable="rbrREPORTE">

                    <cfif rbrREPORTE.hasError()>
                        <cfset errorMessage = "Error al generar el reporte " & rbrReporte.getMessage() />
                        <cfthrow type="warning" message="#errorMessage#">
                    </cfif>

                    <cfset Local.archivos=[{
                        dir="Reportes/ReportesCotizacion.pdf",
                        name='reporte',
                        sn_deleteFile= "no"
                    }]>
                                        
                    <cfset Local.imagenes=[
                        {
                            dir="#storageUrl##Local.Empresa.ar_ImagenReporte#",
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

                    <!--- Preparar parámetros base --->
                    <cfset Local.mailParams = {
                        destinatarios = local.destinatarios,
                        asunto = "Solicitud de Cotización Insumos",
                        imagenes = Local.imagenes,
                        archivos = Local.archivos,
                        parametros = Local.DatosCotiz,
                        sn_plantilla = "YES",
                        dir_plantilla = "templates/correos/Compras/templateMailCotizacion.html",
                        sn_CopiaOculta = "true"
                    }>

                    <!--- Agregar archivos del servidor si aplica --->
                    <cfif arguments.adjuntarArchivo EQ 'YES' AND Len(Trim(arguments.ruta)) GT 0 AND Len(Trim(arguments.nombre)) GT 0>
                        <cfset Local.mailParams.archivos_server = [{
                            dir = arguments.ruta,
                            name = arguments.nombre,
                            sn_deleteFile = "no"
                        }]>
                    </cfif>

                    <!--- Enviar correo --->
                    <cfinvoke 
                        component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                        method="sendMail"
                        argumentCollection="#Local.mailParams#"
                        returnvariable="Local.rbr"
                    />


                    <!--- <cfif arguments.adjuntarArchivo EQ 'YES'>

                            <cfif Len(Trim(arguments.ruta)) GT 0 AND Len(Trim(arguments.nombre)) GT 0>
                                <cfset Local.archivosReq = [{
                                    dir = "#arguments.ruta#",
                                    name = "#arguments.nombre#",
                                    sn_deleteFile = "no"
                                }]>

                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#local.destinatarios#"
                                asunto="Solicitud de Cotizacion Insumos"
                                imagenes="#Local.imagenes#"
                                archivos="#Local.archivos#"
                                archivos_server="#Local.archivosReq#"
                                parametros="#Local.DatosCotiz#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailCotizacion.html"
                                returnvariable="Local.rbr"
                                sn_CopiaOculta="true"
                                />

                            <cfelse>
                                <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                                method="sendMail"
                                destinatarios="#local.destinatarios#"
                                asunto="Solicitud de Cotizacion Insumos"
                                imagenes="#Local.imagenes#"
                                archivos="#Local.archivos#"
                                parametros="#Local.DatosCotiz#"
                                sn_plantilla="YES"
                                dir_plantilla="templates/correos/Compras/templateMailCotizacion.html"
                                returnvariable="Local.rbr"
                                sn_CopiaOculta="true"
                                />
                            </cfif>

                    <cfelse>
                            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                            method="sendMail"
                            destinatarios="#local.destinatarios#"
                            asunto="Solicitud de Cotizacion Insumos"
                            imagenes="#Local.imagenes#"
                            archivos="#Local.archivos#"
                            parametros="#Local.DatosCotiz#"
                            sn_plantilla="YES"
                            dir_plantilla="templates/correos/Compras/templateMailCotizacion.html"
                            returnvariable="Local.rbr"
                            sn_CopiaOculta="true"
                            />
                    </cfif> --->

                    <cfif Local.rbr.hasError()>
                        <cfset Variables.RBR.setError(Local.rbr.getMessage())>
                    </cfif>

                </cfif>
            </cfif>

            <cfset variables.RBR.setData(Local.Identificador)>

            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="DatosCotiz"         type="struct" required="true">
        <cfargument name="insumos"            type="array"  required="true">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReportesCotizacion"
        }>
       
        <cfsavecontent variable="reporteCotizacion">
            <cfinclude template="../../templates/reportes/Compras/reporteCotizacionInsumo.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteCotizacion#"
                  pdf="ReportesCotizacion"
                  debug="no"
                  path="#expandPath('/root/Reportes/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <!--- Modificacion: Rey David Dominguez
          Fecha: 09/02/2015
          Se simplifico la funcion para el guardado --->
    <cffunction name="Editarsn_Elegida"            access="public" returntype="Any">
        <cfargument name="id_Cotizacion"         type="numeric" required="true"/>
        <cfargument name="de_Observaciones"      type="String" required="false"/>
        <cfargument name="sn_Edicion"            type="String" required="false"/>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfset arguments.sn_CotizacionElegida = Arguments.sn_Edicion?1:0>
        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="Editarsn_Elegida"
                  argumentcollection="#arguments#">

            <!--- <cfif NOT variables.RBR.hasError()>
                <cfif isDefined(arguments.sn_Edicion) AND arguments.sn_Edicion NEQ ''>
                    <cfelseif arguments.sn_Edicion EQ TRUE>
                        <cfset arguments.sn_CotizacionElegida = 1>
                        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                                  method="Editarsn_Elegida"
                                  argumentcollection="#arguments#">

                        <cfelseif arguments.sn_Edicion EQ FALSE>
                            <cfset arguments.sn_CotizacionElegida = 0>
                            <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                                      method="Editarsn_Elegida"
                                      argumentcollection="#arguments#">
                </cfif>
            </cfif> --->

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar" access="public" returntype="Any">
       <cfargument name="id_SolicitudCompra"      type="string"       required="false"/>
       <cfargument name="fh_Inicio"               type="string"       required="false"/>
       <cfargument name="fh_Final"                type="string"       required="false"/>
       <cfargument name="id_Proveedor"            type="string"       required="false"/>

        <!--- se obtiene el id del usuario de la session para listar solo las requisiones que esten asignadas al usuario logueado --->
        <cfset  arguments.id_Empresa= session.ID_EMPRESA>
        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.Cotizaciones">

        <cfset variables.RBR.setQuery(Local.Cotizaciones)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarCotizacionesparaAutorizarOrdenCompra" access="public" returntype="Any">
        <cfargument name="id_OrdenCompra"      type="string"       required="false"/>

        <!--- se obtiene el id del usuario de la session para listar solo las requisiones que esten asignadas al usuario logueado --->
        <cfset  arguments.id_Empresa= session.ID_EMPRESA>

      <!---    <cfoutput>BRO</cfoutput>
       <cfdump var="#session.ID_EMPRESAOPERADORA#"><cfabort> --->

            <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                      method="listarCotizacionesparaAutorizarOrdenCompra"
                      argumentcollection="#arguments#"
                      returnvariable="Local.Cotizaciones">

                      <cfset variables.RBR.setQuery(Local.Cotizaciones)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ObtenerImpuestos" access="public" returntype="Any">
    <cfargument name="id_Cotizacion"  type="numeric"  required="true"/>
        <cfset  arguments.id_Empresa= session.ID_EMPRESA>

            <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                      method="ObtenerImpuestos"
                      argumentcollection="#arguments#"
                      returnvariable="Local.CotizacionImpuestos">

                      <cfset variables.RBR.setQuery(Local.CotizacionImpuestos)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarSolicitudesCompras"  access="public"  returntype="Any">
        <cfargument name="fh_inicio"    type="string" required="false">
        <cfargument name="fh_fin"       type="string" required="false">
        <cfargument name="id_Empresa"   type="numeric" required="false">

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke   component="#Application.RF.getPath('dao','Cotizaciones')#"
                    method="listarSolicitudesCompras"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs">

        <cfset variables.RBR.setData(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarBySolicitudCompra" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name="id_SolicitudCompra"   type="numeric" required="true"/>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="listarBySolicitudCompra"
                  id_empresa="#Arguments.id_Empresa#"
                  id_solicitudCompra="#Arguments.id_SolicitudCompra#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="updateNameFile" access="public" returntype="Any">
        <cfargument name="id_Empresa"      type="numeric" required="false">
        <cfargument name="id_Cotizacion"   type="numeric" required="true"/>
        <cfargument name="nb_archivo"      type="string"  required="true"/>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfset Local.cotizacion=structNew()>
        <cfset Local.cotizacion.id_empresa = Arguments.id_empresa>
        <cfset Local.cotizacion.id_Cotizacion = Arguments.id_Cotizacion >

        <cfif Arguments.nb_archivo NEQ ''>
            <cfset Local.cotizacion.nb_archivo = Arguments.nb_archivo >
        </cfif>
        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="updateNameFile"
                  argumentcollection="#Local.cotizacion#">


        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="numeric" required="false">
        <cfargument name="id_Cotizacion"    type="numeric" required="true"/>

        <cfif not isDefined("Arguments.id_Empresa")>
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','CotizacionesImpuestos')#"
                  method="eliminarByCotizacion"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_Cotizacion="#Arguments.id_Cotizacion#">

        <cfinvoke component="#Application.RF.getPath('dao','CotizacionesDetalle')#"
                  method="eliminarByCotizacion"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_Cotizacion="#Arguments.id_Cotizacion#">

        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="eliminar"
                  id_Empresa="#Arguments.id_Empresa#"
                  id_Cotizacion="#Arguments.id_Cotizacion#">


        <cfreturn variables.RBR>
    </cffunction>

    <!--- funcion que devuelve los insumos a los que se les puede hacer orden de compra correspodiente a una  cotizacion, esto es pata la pantalla de cotizaciones
        05-11-2015--->
    <cffunction name="getinsumosrestantes" access="public" returntype="Any">
        <cfargument name='id_cotizacion'    type='numeric' required='true'>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="getinsumosrestantes"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <!--- funcion que verifica si la cotizacion tiene ordenes de compras--->
        <!--- <cfinvoke component="#Application.RF.getPath('dao','SolicitudesCompra')#" --->
            <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  <!--- method="getordenescomprabysolicitudcompra" --->
                  method="getordenescomprabycotizacion"
                  argumentcollection="#arguments#"
                  returnvariable="Local.ordenescompras">

        <!--- funcion que devuelve los insumos que ya estan dentro de una oc en esta cotizacion --->
        <cfinvoke component="#Application.RF.getPath('dao','OrdenesdeCompra')#"
                  method="getinsumosexistentesenordenescomprabycotizacion"
                  id_empresa ="#session.ID_EMPRESA#"
                  id_cotizacion ="#arguments.id_cotizacion#"
                  returnvariable="Local.insumosexistenordenescompra">

        <!--- devuelve los insumos de una cotización en especifico--->
        <cfinvoke component="#Application.RF.getPath('dao','CotizacionesDetalle')#"
                  method="getinsumoscotizacion"
                  argumentcollection="#arguments#"
                  id_empresa ="#session.ID_EMPRESA#"
                  returnvariable="Local.insumoscotizacion">

        <cfset  local.data = structNew()>

        <cfset local.data.infoinsumos = local.rs>
        <cfset local.data.infocompras = local.ordenescompras>
        <cfset local.data.insumoscoti = local.insumoscotizacion>
        <cfset local.data.insumosexisteoc = local.insumosexistenordenescompra>

        <!--- <cfset variables.RBR.setQuery(Local.rs)> --->
        <cfset variables.RBR.setData(local.data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EditarDetalleInsumos" access="public" returntype="Any">
        <cfargument name="id_Empresa"           type="numeric" required="false">
        <cfargument name='id_Cotizacion'        type='numeric' required='true'>
        <cfargument name='id_CotizacionDetalle' type='numeric' required='true'>
        <cfargument name='camposDetalle'        type='array' required='true'>
        <cfif not isDefined("Arguments.id_Empresa") >
            <cfset Arguments.id_Empresa = session.ID_EMPRESA>
        </cfif>

    <cfloop from="1" to="#arrayLen(arguments.camposDetalle)#" index="local.i">

        <cfinvoke component="#Application.RF.getPath('dao','Cotizaciones')#"
                  method="EditarDetalleInsumos"
                    id_Empresa           = "#Arguments.id_empresa#"
                    id_Cotizacion        = "#arguments.id_Cotizacion#"
                    id_CotizacionDetalle = "#arguments.id_CotizacionDetalle#"
                    id_CampoDetalle      = "#arguments.camposDetalle[local.i].ID_CAMPODETALLE#"
                    nb_CampoDetalle      = "#arguments.camposDetalle[local.i].NB_CAMPODETALLE#"
                    de_ValorCampoDetalle = '#arguments.camposDetalle[local.i].DE_VALORCAMPODETALLE#'
                >


      </cfloop>
    <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getComparativaCotizaciones" access="public" returntype="Any">
        <cfargument name='id_Empresa'          type='numeric' required='true'>
        <cfargument name='id_SolicitudCompra'  type='numeric' required='true'>
        <cfinvoke component="#Application.RF.getPath('dao', 'Cotizaciones')#"
                  method="getComparativaCotizaciones"
                  argumentcollection="#Arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>

    </cffunction>

    <cffunction name="GenerarPDF"    access="public"     returntype="Any">
        <cfargument name='id_solicitudCompra' type='numeric' required='false'/>
        <cfargument name='fh_registroSC'      type='string'  required='false'/>
        <cfargument name='id_requisicion'     type='numeric' required='false'/>
        <cfargument name='fh_requisicion'     type='string'  required='false'/>
        <cfargument name='comentarios'        type='string'  required='false'/>
        <cfargument name='comparativa'        type='array'   required='false'/>
        <cfargument name='titulos'            type='array'   required='false'/>
        <cfargument name='encabezados'        type='array'   required='false'/>
        <cfargument name='nb_empresa'         type='string'  required='false'/>
        <cfargument name='nb_sucursal'        type='string'  required='false'/>

        <cfset Local.fnc = createObject("component","#Application.RF.getPath('cfc','Funciones')#")>
        <cfset local.Datos = structNew()>
        
        <cfif arguments.id_requisicion == 0 >
            <cfset local.Datos.id_requisicion = '-'>
        <cfelse>
            <cfset local.Datos.id_requisicion = arguments.id_requisicion>
        </cfif>

        <cfif not isDefined("Arguments.fh_requisicion") >
            <cfset local.Datos.fh_requisicion = "-">
        <cfelse>
            <cfset local.Datos.fh_requisicion = arguments.fh_requisicion>
        </cfif>

        <cfset local.Datos.id_solicitudCompra = arguments.id_solicitudCompra>
        <cfset local.Datos.fh_registroSC = arguments.fh_registroSC>
        <cfset local.Datos.comentarios = arguments.comentarios>
        <cfset local.Datos.nb_empresa = arguments.nb_empresa>
        <cfset local.Datos.nb_sucursal = arguments.nb_sucursal>
        <cfset local.Datos.folioSolicitudCompra = 
            "#arguments.id_solicitudCompra#-#arguments.nb_empresa#-#arguments.nb_sucursal#"
        >
        
        
        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="CotizacionesOrdenDeCompra#arguments.id_solicitudCompra#-#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfsavecontent variable="cotizacionesOrdenDeCompra">
            <cfinclude template="../../templates/reportes/Compras/cotizacionesOrdenDeCompraTemplate.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#CotizacionesOrdenDeCompra#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset Local.infoReport.ar_archivoPDF=##CotizacionesOrdenDeCompra##>
        
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>                         

    </cffunction>

    <cffunction name="reporteCotizacion" access="public" returntype="any">

        <cfargument name='id_Empresa'         type='string' required='false'>
        <cfargument name='id_Cotizacion'      type='string' required='false'>


        <!--- Nos traemos los datos de la cotizacion --->
        <cfinvoke
            component="#Application.RF.getPath('dao','Insumos')#"
            method="listarByCotizacion_SC"
            argumentcollection="#arguments#"
            returnvariable="Local.cotizacion">

        <!--- Nos traemos la imagen de la empresa de donde es la remision  anteriomente se estaba tomando la imagen de la empresa session --->
        <cfinvoke
            component="#Application.RF.getPath('dao','Empresas')#"
            method="listar"
            id_empresa="#Arguments.id_empresa#"
            returnvariable="Local.imgEmpresa">

        <cfset arguments.cotizacion = Local.cotizacion>
        <!--- <cfset arguments.cotizacionDetalle = Local.cotizacionDetalle> --->
        <cfset arguments.imagenCotizacion = "https://storage.googleapis.com/#Application.RENV.getProperty('SIPP_STORAGE_BUCKET')#/#Local.imgEmpresa.ar_ImagenLogo#">

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="cotizacion#Arguments.cotizacion.id_cotizacion#"
        }>
        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteCotizacion">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteCotizacionesImp.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke
            component="#Application.RF.getPath('cfc','javaLoader')#"
            method="generatePDFNoDownload"
            content="#reporteCotizacion#"
            pdf="#local.infoReport.nb_archivo#"
            debug="no"
            path="#expandPath('/root/Reportes/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset Local.infoReport.ar_archivoPDF=#reporteCotizacion#>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>

    </cffunction>

</cfcomponent>
