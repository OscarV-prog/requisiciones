<cfcomponent>
<cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_Requisicion"          type="string" required="false"/>
        <cfargument name="fh_Inicio"               type="string" required="false"/>
        <cfargument name="fh_Final"                type="string" required="false"/>
        <cfargument name="nu_tipoFecha"            type="string" required="false"/>
        <cfargument name="id_EstatusAutorizacion"  type="string" required="false"/>
        <cfargument name="id_EstatusSurtido"       type="string" required="false"/>
        <cfargument name="id_SolicitadoCompras"    type="string" required="false"/>
        <cfargument name="id_OrdenDeCompra"        type="string" required="false"/>
        <cfargument name="id_SolicitudCompra"      type="string" required="false"/>
        <cfargument name="id_Empleado"             type="string" required="false"/>
        <cfargument name="id_EmpresaEmpleado"             type="string" required="false"/>


        <!--- se obtiene el id del usuario de la session para listar solo las requisiones que esten asignadas al usuario logueado --->
        <cfset  arguments.id_UsuarioAutoriza= session.ID_USUARIO>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>
        <!--- <cfset arguments.id_almacen = session.ID_ALMACEN> --->

        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                    method="listar"
                    argumentcollection="#arguments#"
                    returnvariable="Local.Requisicion">

        <cfset variables.RBR.setQuery(Local.Requisicion)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Editar"  access="public" returntype="Any">
        <cfargument name="Requisiciones" type="array" required="true"/>

        <cfif NOT variables.RBR.hasError()>
            <!--- <cfoutput>bro</cfoutput>
            <cfdump var="#arguments#"><cfabort> --->

            <cfloop from="1" to="#arrayLen(arguments.Requisiciones)#" index="local.j">

                    <cfif arguments.Requisiciones[local.j].Identificador EQ 'Autorizar'>

                            <cfset local.Argumentos_Requisicion= structNew()>
                            <cfset local.Argumentos_Requisicion.id_Empresa = arguments.Requisiciones[local.j].id_Empresa>
                            <cfset local.Argumentos_Requisicion.id_Requisicion = arguments.Requisiciones[local.j].id_Requisicion>
                            <cfset local.Argumentos_Requisicion.id_EstatusAutorizacion = "3">
                            <cfset local.Argumentos_Requisicion.de_Observaciones = arguments.Requisiciones[local.j].de_Observaciones>

                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                                        method="Editar"
                                        argumentcollection="#Argumentos_Requisicion#">

                                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>


                        <cfelseif arguments.Requisiciones[local.j].Identificador EQ 'Rechazar'>
                            <cfset local.Argumentos_Requisicion= structNew()>
                            <cfset local.Argumentos_Requisicion.id_Empresa = arguments.Requisiciones[local.j].id_Empresa>
                            <cfset local.Argumentos_Requisicion.id_Requisicion = arguments.Requisiciones[local.j].id_Requisicion>
                            <cfset local.Argumentos_Requisicion.id_EstatusAutorizacion = "4">
                            <cfset local.Argumentos_Requisicion.de_Observaciones = arguments.Requisiciones[local.j].de_Observaciones>

                            <!--- <cfoutput>rechazar bro</cfoutput>
                            <cfdump var="#local.Argumentos_Requisicion#"><cfabort>  --->

                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                                        method="Editar"
                                        argumentcollection="#Argumentos_Requisicion#">

                                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                    </cfif>

                </cfloop>
            <cfelse>
                <cfset variables.RBR.setError('Ocurrio un error.')>
        </cfif>

            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="EditardesdeDetalleRequisicion"  access="public" returntype="Any">
        <cfargument name="id_Empresa"          type="numeric"    required="true"/>
        <cfargument name="id_Requisicion"      type="numeric"    required="true"/>
        <cfargument name="Identificador"       type="string"     required="true"/>
        <cfargument name="de_Observaciones"    type="string"     required="true"/>

        <cfif NOT variables.RBR.hasError()>
        <!---   <cfoutput>bro</cfoutput>
            <cfdump var="#arguments#"><cfabort> --->
            <cfif arguments.Identificador EQ 'Rechazar'>

                            <cfset local.Argumentos_Requisicion= structNew()>
                            <cfset local.Argumentos_Requisicion.id_Empresa = arguments.id_Empresa>
                            <cfset local.Argumentos_Requisicion.id_Requisicion = arguments.id_Requisicion>
                            <cfset local.Argumentos_Requisicion.id_EstatusAutorizacion = "4">
                            <cfset local.Argumentos_Requisicion.de_Observaciones = arguments.de_Observaciones>

                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                                        method="Editar"
                                        argumentcollection="#Argumentos_Requisicion#">

                                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>

                    <cfelseif arguments.Identificador EQ 'Autorizar'>
                            <cfset local.Argumentos_Requisicion= structNew()>
                            <cfset local.Argumentos_Requisicion.id_Empresa = arguments.id_Empresa>
                            <cfset local.Argumentos_Requisicion.id_Requisicion = arguments.id_Requisicion>
                            <cfset local.Argumentos_Requisicion.id_EstatusAutorizacion = "3">
                            <cfset local.Argumentos_Requisicion.de_Observaciones = arguments.de_Observaciones>

                            <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                                        method="Editar"
                                        argumentcollection="#Argumentos_Requisicion#">

                                        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
            </cfif>


            <cfelse>
                <cfset variables.RBR.setError('Ocurrio un error.')>
        </cfif>

            <cfreturn variables.RBR>
    </cffunction>



    <cffunction name="listarStatus" access="public" returntype="Any">
        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                    method="listarStatus"
                <!---  argumentcollection="#arguments#" --->
                    returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="generarExcel" access="remote" returnformat="JSON">
        <cfargument name="id_Empresa"               type="string" required="false" default=""/>
        <cfargument name="id_Sucursal"                type="string" required="false" default=""/>
        <!--- <cfargument name="id_Almacen"                 type="string" required="false" default=""/> --->
        <cfargument name="id_Requisicion"             type="string" required="false" default=""/>
        <cfargument name="id_EstatusSurtido"          type="string" required="false" default=""/>
        <cfargument name="id_EstatusAutorizacion"     type="string" required="false" default=""/>
        <cfargument name="sn_SolicitadoCompras"       type="string" required="false" default=""/>
        <cfargument name="fh_Inicio"                  type="string" required="false" default=""/>
        <cfargument name="fh_Fin"                     type="string" required="false" default=""/>
        <cfargument name="nu_tipoFecha"               type="string" required="false" default=""/>
        <cfargument name="id_EmpresaEmpleado"         type="string" required="false" default=""/>
        <cfargument name="id_Empleado"                type="string" required="false" default=""/>

        <cfinvoke   component="#Application.RF.getPath('dao','RequisicionesConsultasServicios')#"
                    method="generarExcel"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs"/>

        <cfif #Local.rs.recordcount# EQ 0>
            <cfset variables.RBR.setError('No se Encontro Registro para Imprimir el Reporte.')>
            <cfreturn Variables.RBR>
        </cfif>


        <!--- Se cambia a js --->
        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>



        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="RequisicionesDetalleConsultaAlmacenReporte#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                <poi:class name="filtros" style="text-align:right;color:black;font-weight:bold"/>
                <poi:class name="gris" style="background-color: LIGHT_CORNFLOWER_BLUE;"/>
            </poi:classes>

            <poi:sheets>
                <poi:sheet name="Reporte"
                            freezerow="9"
                            orientation="landscape"
                            zoom="100%">
                        <poi:columns>
                            <poi:column style="width: 50px  ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 120px ;"/>
                        </poi:columns>
                    <poi:row class=''></poi:row>

                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Reporte Requisicion Consulta Almacen"  class="title"/>
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
                            <poi:cell value=""/>
                            <poi:cell value="Sucursal:" class="filtros"/>
                            <poi:cell value="#session.NB_SUCURSAL#"/>
                            <poi:cell value="Almacen:" class="filtros"/>
                            <poi:cell value="#session.NB_ALMACEN#"/>
                    </poi:row>
                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Folio de Requisicion:" class="filtros"/>
                        <poi:cell value="#id_Requisicion#"/>
                        <poi:cell value=""/>
                        <poi:cell value="Orden De Compra:" class="filtros"/>
                        <poi:cell value="#id_OrdenCompra#"/>
                        <poi:cell value="Solicitud De Compra:" class="filtros"/>
                        <poi:cell value="#id_SolicitudCompra#"/>
                    </poi:row>
                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Solicitado a Compras:" class="filtros"/>
                        <poi:cell value="#nb_SolicitadoCompras#"/>
                        <poi:cell value=""/>
                        <poi:cell value="Estatus Autorizacion:" class="filtros"/>
                        <poi:cell value="#nb_EstatusAutorizacion#"/>

                        <poi:cell value="Estatus Surtido:" class="filtros"/>
                        <poi:cell value="#nb_EstatusSurtido#"/>
                    </poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="De:" class="filtros"/>
                        <poi:cell value="#dateFormat(#fh_inicio#,'dd/mm/yyyy ')#"/>
                        <poi:cell value="A:" class="filtros"/>
                        <poi:cell value="#dateFormat(#fh_Fin#,'dd/mm/yyyy ')#"/>
                        <poi:cell value=""/>
                        <poi:cell value="Empleado:" class="filtros"/>
                        <poi:cell value="#nb_NombreEmpleado#"/>
                    </poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="EMPRESA" class="header fondo left top bottom"/>
                        <poi:cell value="SUCURSAL" class="header fondo left top bottom"/>
                        <poi:cell value="FECHA DE EXPEDICION" class="header fondo left top bottom"/>
                        <poi:cell value="FOLIO DE REQUISICION" class="header fondo top bottom left"/>
                        <poi:cell value="EMPLEADO" class="header fondo top bottom left"/>
                        <poi:cell value="AREA" class="header fondo top bottom left"/>
                        <poi:cell value="ESTATUS AUTORIZACION" class="header fondo top bottom left"/>
                        <poi:cell value="INSUMO" class="header fondo top bottom left"/>
                        <poi:cell value="CANTIDAD REQUISITADA" class="header fondo top bottom left"/>
                        <poi:cell value="CANTIDAD SOLICITADA A COMPRAR" class="header fondo top bottom left"/>
                        <poi:cell value="CANTIDAD SURTIDA" class="header fondo top bottom left"/>
                        <poi:cell value="CANTIDAD PENDIENTE" class="header fondo top bottom left"/>
                        <poi:cell value="EXISTENCIA" class="header fondo top bottom left"/>
                        <poi:cell value="FOLIO ORDEN COMPRA" class="header fondo top bottom left"/>
                        <poi:cell value="FECHA DE ENTREGA" class="header fondo top bottom left"/>
                        <poi:cell value="GRUPO CENTRO COSTO" class="header fondo top bottom left"/>
                        <poi:cell value="GRUPO DE COSTO" class="header fondo top bottom left right"/>
                    </poi:row>
                    <cfloop query="Local.rs">
                        <poi:row>
                            <poi:cell value=""/>
                            <poi:cell value="#Local.rs.NB_EMPRESA#" class="Contenido left "/>
                            <poi:cell value="#Local.rs.NB_SUCURSAL#" class="Contenido left "/>
                            <poi:cell value="#Local.rs.FH_EXPEDICION#" class="Contenido left" style="text-align: center;"/>
                            <poi:cell value="#Local.rs.ID_REQUISICION#" class="Contenido left" style="text-align: center;"/>
                            <poi:cell value="#Local.rs.NB_NOMBREEMPLEADO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.NB_DEPARTAMENTO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.DE_ESTATUSAUTORIZACIONREQUISICION#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.NB_NOMBREINSUMO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.NU_CANTIDAD#" class = "Contenido left right" style="text-align: right;"/>
                            <poi:cell value="#Local.rs.NU_SOLICITADACOMPRA#" class = "Contenido left right" style="text-align: right;"/>
                            <poi:cell value="#Local.rs.NU_CANTIDADSURTIDA#" class = "Contenido left right" style="text-align: right;"/>
                            <poi:cell value="#Local.rs.NU_CANTIDADPENDIENTE#" class = "Contenido left right" style="text-align: right;"/>
                            <poi:cell value="#Local.rs.NU_EXISTENCIA#"class = "Contenido left right"  style="text-align: right;"/>
                            <poi:cell value="#Local.rs.ID_ORDENDECOMPRA#"class = "Contenido left right"  style="text-align: center;"/>
                            <poi:cell value="#Local.rs.FH_ENTREGAPROBABLE#"class = "Contenido left right"  style="text-align: center;"/>
                            <poi:cell value="#Local.rs.NB_GRUPOCENTROCOSTO#" class="Contenido left"/>
                            <poi:cell value="#Local.rs.NB_CENTROCOSTO#" class="Contenido left right"/>
                        </poi:row>
                    </cfloop>
                </poi:sheet>
            </poi:sheets>
        </poi:document>

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>
</cfcomponent>
