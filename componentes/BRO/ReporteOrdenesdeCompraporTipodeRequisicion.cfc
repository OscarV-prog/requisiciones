<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listar" access="public" returntype="Any">
    <cfargument name="id_TipoRequisicion"   type="string" required="false"/>
    <cfargument name="fh_Inicio"            type="string" required="true"/>
    <cfargument name="fh_Fin"               type="string" required="true"/>
    
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                  method="listar"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listarDetalle" access="public" returntype="Any">
    <cfargument name="id_TipoRequisicion"   type="string" required="false"/>
    <cfargument name="fh_Inicio"            type="string" required="true"/>
    <cfargument name="fh_Fin"               type="string" required="true"/>
    
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfinvoke component="#Application.RF.getPath('dao','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                  method="listarDetalle"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">

        <cfset variables.RBR.setQuery(Local.rs)>
        
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GenerarPDF"    access="public"     returntype="Any">
        <cfargument name="fh_Inicio"            type="string"   required="true">
        <cfargument name="fh_Fin"               type="string"   required="true">
        <cfargument name="Requisiciones"        type="array"    required="true">
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>

        <cfset local.DatosReporte = structNew()>

        <cfif #tiporequisicion# EQ 'Seleccionar'>
            <cfset local.de_Req = 'Todas'>
        <cfelse>
            <cfset local.de_Req = '#tiporequisicion#'>
        </cfif>
        

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="OrdenesComprasporTipodeRequisicion#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfset local.DatosReporte.fh_Inicio = arguments.fh_Inicio>
        <cfset local.DatosReporte.fh_Fin = arguments.fh_Fin>
        <cfset local.DatosReporte.de_Requisiciones = local.de_Req>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteOrdenesCompraporTipodeRequisicion">
            <cfinclude template="../../templates/reportes/Compras/ReporteporTipodeRequisicionTemplate.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteOrdenesCompraporTipodeRequisicion#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>                         
    </cffunction>

    <cffunction name="GenerarPDFDetalle"    access="public"     returntype="Any">
        <cfargument name="fh_Inicio"            type="string"   required="true">
        <cfargument name="fh_Fin"               type="string"   required="true">
        <cfargument name="Requisiciones"        type="array"    required="true">
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>

        <cfset local.DatosReporte = structNew()>

        <cfif #tiporequisicion# EQ 'Seleccionar'>
            <cfset local.de_Req = 'Todas'>
        <cfelse>
            <cfset local.de_Req = '#tiporequisicion#'>
        </cfif>
        

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="OrdenesComprasporTipodeRequisicion#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <cfset local.DatosReporte.fh_Inicio = arguments.fh_Inicio>
        <cfset local.DatosReporte.fh_Fin = arguments.fh_Fin>
        <cfset local.DatosReporte.de_Requisiciones = local.de_Req>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteOrdenesCompraporTipodeRequisicion">
            <cfinclude template="../../templates/reportes/Compras/ReporteporTipodeRequisicionTemplateDetalle.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteOrdenesCompraporTipodeRequisicion#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>                         
    </cffunction>

    <cffunction name="generarExcel"    access="public"     returntype="Any">
        <cfargument name='fh_Inicio'            type='string'  required='true'>
        <cfargument name='fh_Fin'               type='string'  required='true'>
        <cfargument name='id_TipoRequisicion'   type='string'  required='false'>
        <cfargument name='Requisiciones'        type='array'   required='false'>
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>





        <cfif #tiporequisicion# EQ 'Seleccionar'>
            <cfset local.nb_req = 'Todas'>
        <cfelse>
            <cfset local.nb_req = '#tiporequisicion#'>
        </cfif>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        
        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="OrdenesComprasporTipodeRequisicion#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                    name="header" 
                    style="font-family: Arial ; color: black ; font-size: 10pt; font-weight: bold;" 
                    />

                <poi:class
                    name="fondo"
                    style="background-color: GREY_25_PERCENT; "
                />

                <poi:class
                    name="Total"
                    style="color: black; text-align: right; font-family: Arial; font-size: 11pt;"
                />

                <poi:class
                    name="Contenido"
                    style="font-family: Arial ; color: black ; font-size: 10pt;"
                />

                <poi:class
                    name="derecha"
                    style="text-align:right;"
                />

                <poi:class name="left" style="border-left:2px solid black"/>
                <poi:class name="right" style="border-right:2px solid black"/>
                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                <poi:class name="top" style="border-top:2px solid black"/>
                <poi:class name="filtros" style="text-align:right;color:blue;font-weight:bold"/>

                <poi:class 
                    name="logo" 
                    <!--- style='background-image: url("../img/logo_petroil.png");background-repeat: no-repeat;height: 400px;' --->
                    style='background-image: url("..\img\logo_petroil.png");'
                    />

            </poi:classes>
                
            <!--- Define Sheets. --->
            <poi:sheets>            
                <poi:sheet 
                    name="Reporte"
                    freezerow="11"
                    orientation="landscape"
                    zoom="100%">
                
                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                    </poi:columns>
                    
                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Reporte de Compras por Tipo de Requisici#chr(243)#n"   class="title"/>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                    </poi:row>
                    
                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value='' class="logo">
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value='Tipo Requisici#chr(243)#n:' class="filtros"/>
                        <poi:cell value='#nb_req#'/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value='De:' class="filtros"/>
                        <poi:cell value='#fh_Inicio#'/>
                        <poi:cell value='A:' class="filtros"/>
                        <poi:cell value='#fh_Fin#'/>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>
                    
                    <!--- Header row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value='Sucursal' class="header fondo left bottom top"/>
                        <poi:cell value="Tipo de Requisici#chr(243)#n" class="header fondo bottom top"/>
                        <poi:cell value="SubTotal"  class="header fondo bottom top"/>
                        <poi:cell value="IVA"  class="header fondo bottom top"/>
                        <poi:cell value="Total"  class="header right fondo bottom top"/>
                    </poi:row>
                    <!--- Output the people. --->
                    <cfset tipoRequisicion = arrayNew(1)>
                    <cfset deTipoRequisicion = Requisiciones[1]['DE_TIPOREQUISICION']>
                    <cfset IM_SUBTOTALROW = arrayNew(1)>
                    <cfset IM_IVAROW = arrayNew(1)>
                    <cfset IM_TOTALROW = arrayNew(1)>
                    <cfset arrayAppend(tipoRequisicion, Requisiciones[1]['DE_TIPOREQUISICION'])>
                    <cfloop from="1" to="#arrayLen(arguments.Requisiciones)#"  index="i">
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="#Requisiciones[i]['NB_SUCURSAL']#" class="left Contenido bottom" />
                            <poi:cell value="#Requisiciones[i]['DE_TIPOREQUISICION']#" class="Contenido bottom" />
                            <cfif deTipoRequisicion NEQ Requisiciones[i]['DE_TIPOREQUISICION']>
                                <cfif NOT ArrayContains(tipoRequisicion,  Requisiciones[i]['DE_TIPOREQUISICION'])>
                                    <cfset arrayAppend(tipoRequisicion, Requisiciones[i]['DE_TIPOREQUISICION'])>
                                </cfif>
                                <cfset deTipoRequisicion = Requisiciones[i]['DE_TIPOREQUISICION']>
                            </cfif>
                            <poi:cell value="#Requisiciones[i]['IM_SUBTOTAL']#"  class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_SUBTOTALROW#deTipoRequisicion#_#i#"/>
                            <cfset IM_SUBTOTALROW[i] = '@IM_SUBTOTALROW#deTipoRequisicion#_#i#'>
                            <poi:cell value="#Requisiciones[i]['IM_IVA']#"  class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_IVAROW#deTipoRequisicion#_#i#"/>
                            <cfset IM_IVAROW[i] = '@IM_IVAROW#deTipoRequisicion#_#i#'>
                            <poi:cell value="#Requisiciones[i]['IM_TOTAL']#"  class="Total bottom right" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IM_TOTALROW#deTipoRequisicion#_#i#"/>
                            <cfset IM_TOTALROW[i] = '@IM_TOTALROW#deTipoRequisicion#_#i#'>
                        </poi:row>
                    </cfloop>

                    <poi:row class=''>
                    </poi:row>

                    <cfset SubTotal = ''>
                    <cfset Iva = ''>
                    <cfset Total = ''>

                    
                    <cfloop from="1" to="#arrayLen(tipoRequisicion)#"  index="i">
                        <poi:row class='fondo header'>
                            <cfset SubTotal = ''>
                            <cfset Iva = ''>
                            <cfset Total = ''>
                            <cfloop from="1" to="#arrayLen(IM_SUBTOTALROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_SUBTOTALROW[b]#)>
                                    <cfset SubTotal = SubTotal & IM_SUBTOTALROW[b] &'+'>
                                </cfif>
                            </cfloop>
                            <cfloop from="1" to="#arrayLen(IM_IVAROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_IVAROW[b]#)>
                                    <cfset Iva = Iva & IM_IVAROW[b]&'+'>
                                </cfif>
                            </cfloop>
                            <cfloop from="1" to="#arrayLen(IM_TOTALROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_TOTALROW[b]#)>
                                    <cfset Total = Total & IM_TOTALROW[b]&'+'>
                                </cfif>
                            </cfloop>
                            <cfset SubTotal=reReplace(SubTotal, '\+$', "", "ALL")>
                            <cfset Iva=reReplace(Iva, '\+$', "", "ALL")>
                            <cfset Total=reReplace(Total, '\+$', "", "ALL")>
                            <poi:cell value="" index="2"/>
                            <poi:cell value="Total de #tipoRequisicion[i]#:" style="text-align:right;" />
                            <poi:cell value="SUM(#SubTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="SubTotaLF_#i#"/>
                            <poi:cell value="SUM(#Iva#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IVAF_#i#"/>
                            <poi:cell value="SUM(#Total#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="TotalF_#i#"/>
                        </poi:row>
                        <poi:row>
                        </poi:row>  
                    </cfloop>

                    <poi:row class='fondo header'>
                        <poi:cell value="" index="2"/>
                        <poi:cell value="Total:" style="text-align:right;" />
                        <poi:cell value="SUM(@SubTotaLF_1:@SubTotaLF_#arrayLen(tipoRequisicion)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="SubTotaLF_#i#"/>
                        <poi:cell value="SUM(@IVAF_1:@IVAF_#arrayLen(tipoRequisicion)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IVAF_#i#"/>
                        <poi:cell value="SUM(@TotaLF_1:@TotaLF_#arrayLen(tipoRequisicion)#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="TotalF_#i#"/>
                    </poi:row>

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

    <cffunction name="generarExcelDetalle"    access="public"     returntype="Any">
        <cfargument name='fh_Inicio'            type='string'  required='true'>
        <cfargument name='fh_Fin'               type='string'  required='true'>
        <cfargument name='id_TipoRequisicion'   type='string'  required='false'>
        <cfargument name='Requisiciones'        type='array'   required='false'>
        <cfargument name='tiporequisicion'      type='string'  required='false'>
        <cfargument name='importeTotal'         type='string'  required='false'>


        <cfif #tiporequisicion# EQ 'Seleccionar'>
            <cfset local.nb_req = 'Todas'>
        <cfelse>
            <cfset local.nb_req = '#tiporequisicion#'>
        </cfif>

        <cfset arguments.id_Empresa = session.ID_EMPRESA>
        
        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="OrdenesComprasporTipodeRequisicion#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                    name="header" 
                    style="font-family: Arial ; color: black ; font-size: 10pt; font-weight: bold;" 
                    />
                <poi:class 
                    name="header2" 
                    style="font-family: Arial ; color: white ; background-color:black; font-size: 10pt; font-weight: bold;" 
                    />

                <poi:class
                    name="fondo"
                    style="background-color: GREY_25_PERCENT; "
                />

                <poi:class
                    name="Total"
                    style="color: black; text-align: right; font-family: Arial; font-size: 10pt;"
                />

                <poi:class
                    name="Contenido"
                    style="font-family: Arial ; color: black ; font-size: 10pt;"
                />

                <poi:class
                    name="derecha"
                    style="text-align:right;"
                />

                <poi:class name="left" style="border-left:2px solid black"/>
                <poi:class name="right" style="border-right:2px solid black"/>
                <poi:class name="bottom" style="border-bottom:2px solid black"/>
                <poi:class name="top" style="border-top:2px solid black"/>
                <poi:class name="filtros" style="text-align:right;color:blue;font-weight:bold"/>

                <poi:class 
                    name="logo" 
                    <!--- style='background-image: url("../img/logo_petroil.png");background-repeat: no-repeat;height: 400px;' --->
                    style='background-image: url("..\img\logo_petroil.png");'
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
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 150px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 250px ;"/>
                    </poi:columns>
                    
                    <poi:row class=''>
                    </poi:row>

                    <!--- Title row. --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Reporte de Compras por Tipo de Requisici#chr(243)#n"   class="title"/>
                        <poi:cell value=''/>
                        <poi:cell value=''/>
                        <poi:cell value="#dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;"/>
                    </poi:row>
                    
                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value='' class="logo">
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value='Tipo Requisici#chr(243)#n:' class="filtros"/>
                        <poi:cell value='#nb_req#'/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=''/>
                        <poi:cell value='De:' class="filtros"/>
                        <poi:cell value='#fh_Inicio#'/>
                        <poi:cell value='A:' class="filtros"/>
                        <poi:cell value='#fh_Fin#'/>
                    </poi:row>

                    <poi:row class=''>
                    </poi:row>

                    <!--- <poi:row class='header2'>
                        <poi:cell index="2" colspan="11" value='Sucursal: #Requisiciones[1]['NB_SUCURSAL']#' />
                    </poi:row>
                    <poi:row class='header2'>
                        <poi:cell index="2" colspan="11" value='Tipo de Requisici#chr(243)#n: #Requisiciones[1]['DE_TIPOREQUISICION']#' />
                    </poi:row> --->
                    <poi:row>
                        <poi:cell value=''/>
                        <poi:cell value="Fecha OC"        class="header fondo bottom top"/>
                        <poi:cell value="Folio OC"        class="header fondo bottom top"/>
                        <poi:cell value="Insumo"          class="header fondo bottom top"/>
                        <poi:cell value="Cantidad"        class="header fondo bottom top"/>
                        <poi:cell value="Precio Unitario" class="header fondo bottom top"/>
                        <poi:cell value="SubTotal"        class="header fondo bottom top"/>
                        <poi:cell value="IVA"             class="header fondo bottom top"/>
                        <poi:cell value="Total"           class="header fondo bottom top"/>
                        <poi:cell value="Empleado"        class="header right fondo bottom top"/>
                        <poi:cell value="Puesto"          class="header fondo bottom top"/>
                        <poi:cell value="Centro Costo"    class="header right fondo bottom top"/>                       
                    </poi:row>
                    

                    <!--- Output the people. --->
                    <!--- <cfset SubTotalTotal = ''>
                    <cfset IvaTotal = ''>
                    <cfset TotalTotal = ''>
                    <cfset index = 1>
                    <cfset tipoRequisicion = arrayNew(1)>
                    <cfset deTipoRequisicion = Requisiciones[1]['DE_TIPOREQUISICION']>
                    <cfset sucursal = Requisiciones[1]['NB_SUCURSAL']>
                    <cfset IM_SUBTOTALROW = arrayNew(1)>
                    <cfset IM_IVAROW = arrayNew(1)>
                    <cfset IM_TOTALROW = arrayNew(1)>
                    <cfset arrayAppend(tipoRequisicion, Requisiciones[1]['DE_TIPOREQUISICION'])> --->
                    <cfloop from="1" to="#arrayLen(arguments.Requisiciones)#"  index="i">
                        <!--- Header row. --->
                        <!--- <cfif sucursal NEQ Requisiciones[i]['NB_SUCURSAL']>
                            <cfset SubTotal = ''>
                            <cfset Iva = ''>
                            <cfset Total = ''>
                            <cfloop from="1" to="#arrayLen(tipoRequisicion)#"  index="b">
                                <poi:row class='fondo header'>
                                    <cfset SubTotal = ''>
                                    <cfset Iva = ''>
                                    <cfset Total = ''>
                                    <cfloop from="1" to="#arrayLen(IM_SUBTOTALROW)#"  index="c">
                                        <cfif Find(#tipoRequisicion[b]#, #IM_SUBTOTALROW[c]#)>
                                            <cfset SubTotal = SubTotal & IM_SUBTOTALROW[c] &'+'>
                                        </cfif>
                                    </cfloop>
                                    <cfloop from="1" to="#arrayLen(IM_IVAROW)#"  index="c">
                                        <cfif Find(#tipoRequisicion[b]#, #IM_IVAROW[c]#)>
                                            <cfset Iva = Iva & IM_IVAROW[c]&'+'>
                                        </cfif>
                                    </cfloop>
                                    <cfloop from="1" to="#arrayLen(IM_TOTALROW)#"  index="c">
                                        <cfif Find(#tipoRequisicion[b]#, #IM_TOTALROW[c]#)>
                                            <cfset Total = Total & IM_TOTALROW[c]&'+'>
                                        </cfif>
                                    </cfloop>
                                    <cfset SubTotal=reReplace(SubTotal, '\+$', "", "ALL")>
                                    <cfset Iva=reReplace(Iva, '\+$', "", "ALL")>
                                    <cfset Total=reReplace(Total, '\+$', "", "ALL")>
                                    <poi:cell value="Total de #tipoRequisicion[b]# #Requisiciones[i]['NB_SUCURSAL']#:" index="2" colspan="5" style="text-align:right;" />
                                    <poi:cell value="SUM(#SubTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="SubTotaF_#i#_#b#"/>
                                    <cfset SubTotalTotal = SubTotalTotal & '@SubTotaF_#i#_#b#+'>
                                    <poi:cell value="SUM(#Iva#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IVAF_#i#_#b#"/>
                                    <cfset IvaTotal = IvaTotal & '@IVAF_#i#_#b#+'>
                                    <poi:cell value="SUM(#Total#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="TotalF_#i#_#b#"/>
                                    <cfset TotalTotal = TotalTotal & '@TotaLF_#i#_#b#+'>
                                    <poi:cell value="" colspan="3"/>
                                </poi:row>
                                <poi:row>
                                </poi:row>  
                            </cfloop>
                            <cfset arrayClear(IM_SUBTOTALROW)>
                            <cfset arrayClear(IM_IVAROW)>
                            <cfset arrayClear(IM_TOTALROW)>
                            <cfset index = 1>
                            <poi:row class='header2'>
                                <poi:cell index="2" colspan="11" value='Sucursal: #Requisiciones[i]['NB_SUCURSAL']#' />
                            </poi:row>
                            <poi:row class='header2'>
                                <poi:cell index="2" colspan="11" value='Tipo de Requisici#chr(243)#n: #Requisiciones[i]['DE_TIPOREQUISICION']#' />
                            </poi:row>
                            <cfset deTipoRequisicion = Requisiciones[i]['DE_TIPOREQUISICION']>
                            <poi:row>
                                <poi:cell value=''/>
                                <poi:cell value="Fecha OC"        class="header fondo bottom top"/>
                                <poi:cell value="Folio OC"        class="header fondo bottom top"/>
                                <poi:cell value="Insumo"          class="header fondo bottom top"/>
                                <poi:cell value="Cantidad"        class="header fondo bottom top"/>
                                <poi:cell value="Precio Unitario" class="header fondo bottom top"/>
                                <poi:cell value="SubTotal"        class="header fondo bottom top"/>
                                <poi:cell value="IVA"             class="header fondo bottom top"/>
                                <poi:cell value="Total"           class="header fondo bottom top"/>
                                <poi:cell value="Empleado"        class="header right fondo bottom top"/>
                                <poi:cell value="Puesto"          class="header fondo bottom top"/>
                                <poi:cell value="Centro Costo"    class="header right fondo bottom top"/>
                            </poi:row>
                            
                            <cfset sucursal = Requisiciones[i]['NB_SUCURSAL']>
                        </cfif>
                        <cfif deTipoRequisicion NEQ Requisiciones[i]['DE_TIPOREQUISICION']>
                            <poi:row class='header2'>
                                <poi:cell index="2" colspan="11" value='Tipo de Requisici#chr(243)#n: #Requisiciones[i]['DE_TIPOREQUISICION']#' />
                            </poi:row>
                            <cfif NOT ArrayContains(tipoRequisicion,  Requisiciones[i]['DE_TIPOREQUISICION'])>
                                <cfset arrayAppend(tipoRequisicion, Requisiciones[i]['DE_TIPOREQUISICION'])>
                            </cfif>
                            <cfset deTipoRequisicion = Requisiciones[i]['DE_TIPOREQUISICION']>
                        </cfif> --->
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="#Requisiciones[i]['FH_REGISTROORDENCOMPRA']#"  class="Contenido bottom" style="text-align: center"/>
                            <poi:cell value="#Requisiciones[i]['ID_ORDENDECOMPRA']#"        class="Contenido bottom" style="text-align: center"/>
                            <poi:cell value="#Requisiciones[i]['NB_NOMBREINSUMO']#"         class="Contenido bottom" style="text-align: left;"/>
                            <poi:cell value="#Requisiciones[i]['NU_CANTIDAD']#"             class="Contenido bottom" type="numeric" numberformat="##,####0.00" style="text-align: right;"/>
                            <poi:cell value="#Requisiciones[i]['IM_PRECIOUNITARIO']#"       class="Contenido bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                            <poi:cell value="#Requisiciones[i]['IM_SUBTOTAL']#"             class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                            <!--- <cfset IM_SUBTOTALROW[index] = '@IM_SUBTOTALROW#deTipoRequisicion#_#i#'> --->
                            <poi:cell value="#Requisiciones[i]['IM_IVA']#"                  class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                            <!--- <cfset IM_IVAROW[index] = '@IM_IVAROW#deTipoRequisicion#_#i#'> --->
                            <poi:cell value="#Requisiciones[i]['IM_TOTAL']#"                class="Total bottom" type="numeric" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;"/>
                            <!--- <cfset IM_TOTALROW[index] = '@IM_TOTALROW#deTipoRequisicion#_#i#'> --->
                            <poi:cell value="#Requisiciones[i]['NB_EMPLEADO']#"             class="Contenido bottom right" />
                            <poi:cell value="#Requisiciones[i]['NB_PUESTO']#"               class="Contenido bottom" />
                            <poi:cell value="#Requisiciones[i]['NB_CENTROCOSTO']#"          class="Contenido bottom right" />
                        </poi:row>
                        <!--- <cfset index = index + 1> --->
                    </cfloop>
<!--- 
                    <poi:row class=''>
                    </poi:row>

                    <cfset SubTotal = ''>
                    <cfset Iva = ''>
                    <cfset Total = ''>

                    
                    <cfloop from="1" to="#arrayLen(tipoRequisicion)#"  index="i">
                        <poi:row class='fondo header'>
                            <cfset SubTotal = ''>
                            <cfset Iva = ''>
                            <cfset Total = ''>
                            <cfloop from="1" to="#arrayLen(IM_SUBTOTALROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_SUBTOTALROW[b]#)>
                                    <cfset SubTotal = SubTotal & IM_SUBTOTALROW[b] &'+'>
                                </cfif>
                            </cfloop>
                            <cfloop from="1" to="#arrayLen(IM_IVAROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_IVAROW[b]#)>
                                    <cfset Iva = Iva & IM_IVAROW[b]&'+'>
                                </cfif>
                            </cfloop>
                            <cfloop from="1" to="#arrayLen(IM_TOTALROW)#"  index="b">
                                <cfif Find(#tipoRequisicion[i]#, #IM_TOTALROW[b]#)>
                                    <cfset Total = Total & IM_TOTALROW[b]&'+'>
                                </cfif>
                            </cfloop>
                            <cfset SubTotal=reReplace(SubTotal, '\+$', "", "ALL")>
                            <cfset Iva=reReplace(Iva, '\+$', "", "ALL")>
                            <cfset Total=reReplace(Total, '\+$', "", "ALL")>
                            <poi:cell value="Total de #tipoRequisicion[i]# #Requisiciones[i]['NB_SUCURSAL']#:" index="2" colspan="5" style="text-align:right;" />
                            <poi:cell value="SUM(#SubTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="SubTotaLF_#i#"/>
                            <cfset SubTotalTotal = SubTotalTotal & '@SubTotaLF_#i#+'>
                            <poi:cell value="SUM(#Iva#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IVAF_#i#"/>
                            <cfset IvaTotal = IvaTotal & '@IVAF_#i#+'>
                            <poi:cell value="SUM(#Total#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="TotalF_#i#"/>
                            <cfset TotalTotal = TotalTotal & '@TotaLF_#i#+'>
                            <poi:cell value="" colspan="3"/>
                        </poi:row>
                        <poi:row>
                        </poi:row>  
                    </cfloop>
                    <cfset SubTotalTotal=reReplace(SubTotalTotal, '\+$', "", "ALL")>
                    <cfset IvaTotal=reReplace(IvaTotal, '\+$', "", "ALL")>
                    <cfset TotalTotal=reReplace(TotalTotal, '\+$', "", "ALL")>
                    <poi:row class='fondo header'>
                        <poi:cell value="Totales:" index="2" colspan="5" style="text-align:right;" />
                        <poi:cell value="SUM(#SubTotalTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="SubTotaLF_#i#"/>
                        <poi:cell value="SUM(#IvaTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="IVAF_#i#"/>
                        <poi:cell value="SUM(#TotalTotal#)" type="formula" numberformat="($##,####0.00);($##,####0.00)" style="text-align: right;" alias="TotalF_#i#"/>
                        <poi:cell value="" colspan="3"/>
                    </poi:row> --->
                        
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
</cfcomponent>