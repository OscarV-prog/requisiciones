<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <cffunction name="listado" access="public" returntype="Any">
        <cfargument name="id_Insumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"            type="string" required="false"/>
        <cfargument name="id_Almacen"           type="string" required="false"/>
        <cfargument name="id_Sucursal"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"     type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>

            <cfset arguments.id_Empresa = session.ID_EMPRESA>


            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="listado"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">


            <cfset variables.RBR.setQuery(Local.rs)>

            <cfreturn variables.RBR>
    </cffunction>

<!---  Juan Beltran --->
    <cffunction name="Excel" access="public" returntype="Any">
        <cfargument name="id_Insumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"            type="string" required="false"/>
        <cfargument name="id_Almacen"           type="string" required="false"/>
        <cfargument name="id_Sucursal"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"     type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>
        <cfargument name="sn_StockAlMinimo"     type="string" required="false"/>
        <cfargument name="datos"                type="array"  required="false"/>

            <cfset arguments.sn_StockAlMinimo = arguments.sn_StockAlMinimo ? 1 : 0>

            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="GeneraReporte"
                      argumentcollection="#arguments#"
                      returnvariable="local.rs">

            <cfset variables.RBR.setQuery(Local.rs)>

            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="reporteExcel" access="remote" returnformat="JSON">
        <cfargument name="id_Insumo"            type="string" required="false"/>
        <cfargument name="nb_Insumo"            type="string" required="false"/>
        <cfargument name="id_Almacen"           type="string" required="false"/>
        <cfargument name="id_Sucursal"          type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"     type="string" required="false"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>
        <cfargument name="datos"                type="array"  required="false"/>




            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="GeneraReporte"
                     <!---  id_Sucursal="#id_Sucursal#"
                      id_Almacen="#id_Almacen#"
                      id_Empresa="#session.ID_EMPRESA#" --->
                      argumentcollection="#arguments#"
                      returnvariable="local.respuesta">

                    <cfinvoke component="#Application.RF.getPath('dao','sucursales')#"
                      method="listar"
                      id_Sucursal="#id_Sucursal#"
                      id_Empresa="#session.ID_EMPRESA#"
                      returnvariable="sucursal">

                    <!--- <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                      method="listar"
                      id_Sucursal="#id_Sucursal#"
                      id_Almacen="#id_Almacen#"
                      id_Empresa="#session.ID_EMPRESA#"
                      returnvariable="almacen"> --->

        <cfset local.DatosReporte = structNew()>

        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="ReporteInventarios#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                            style="font-family: Arial ; color: sky-blue ; font-size: 12pt; font-weight: bold;"
                            />
            </poi:classes>

            <poi:sheets>
                <poi:sheet  name="Reporte"
                            freezerow="13"
                            orientation="landscape"
                            zoom="100%">

                    <!--- Define global column styles. --->
                    <poi:columns>
                        <poi:column style="width: 50px  ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 80px  ;"/>
                        <poi:column style="width: 300px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 120px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 100px ;"/>
                        <poi:column style="width: 200px ;"/>
                        <poi:column style="width: 220px ;"/>
                    </poi:columns>

                    <poi:row class=''></poi:row>

                    <poi:row>
                        <poi:cell value=""/>
                        <poi:cell value="Reporte de Inventario Fisico"  class="title"/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="Fecha: #dateFormat(now(),'dd/mm/yyyy')#" class="title" style="text-align: right;" colspan="1"/>
                    </poi:row>

                    <!--- <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row> --->

                    <poi:row class=''></poi:row>


                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="" style="text-align: right"/>
                        <poi:cell value="" style="text-align: right"/>
                    </poi:row>

                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>
                    <poi:row class=''></poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="Sucursal:" style="text-align: right;" class="title"/>
                        <poi:cell value="#sucursal.NB_SUCURSAL#" style="text-align: left;" class=""/>
                    </poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value=""/>
                        <poi:cell value="Almacen:" style="text-align: right;" class="title"/>
                        <poi:cell value="#nb_Almacen#" style="text-align: left;" class=""/>
                    </poi:row>


                    <poi:row class=''></poi:row>

                    <poi:row class=''>
                        <poi:cell value=""/>
                        <poi:cell value="EMPRESA" class="header fondo"/>
                        <poi:cell value="SUCURSAL" class="header fondo"/>
                        <poi:cell value="CLAVE" class="header fondo"/>
                        <poi:cell value="INSUMO" class="header fondo"/>
                        <poi:cell value="SERIE" class="header fondo"/>
                        <poi:cell value="UNIDAD MEDIDA" class="header fondo"/>
                        <poi:cell value="FAMILIA INSUMO" class="header fondo"/>
                        <poi:cell value="SUBFAMILIAINSUMO" class="header fondo"/>
                        <poi:cell value="CANTIDAD TEORICA" class="header fondo"/>
                        <poi:cell value="CANTIDAD DISPONIBLE " class="header fondo"/>
                        <poi:cell value="TRANSITO" class="header fondo"/>
                        <poi:cell value="MINIMO" class="header fondo"/>
                        <poi:cell value="MAXIMO" class="header fondo"/>
                        <poi:cell value="ABAJO DE MINIMO" class="header fondo"/>
                        <poi:cell value="ARRIBA DE MAXIMO" class="header fondo"/>
                        <poi:cell value="PRECIO PROMEDIO COMPRA" class="header fondo"/>
                        <poi:cell value="ESTIMADO DE INVENTARIO" class="header fondo"/>
                    </poi:row>



                        <cfloop query="local.respuesta" >
                            <poi:row>
                                <poi:cell value=""                      class=""/>
                                <poi:cell value="#Local.respuesta.NB_EMPRESA#"      class="" style="text-align:center;" />
                                <poi:cell value="#Local.respuesta.NB_SUCURSAL#"     class="" style="text-align:center;" />
                                <poi:cell value="#Local.respuesta.ID_INSUMO#"   class="" style="text-align:center;" />
                                <poi:cell value="#Local.respuesta.NB_NOMBREINSUMO#"     class=""/>
                                <poi:cell value="#Local.respuesta.DE_SERIEINSUMO#"  class="" style="text-align:center;"/>
                                <poi:cell value="#Local.respuesta.NB_UNIDADMEDIDA#"     class=""/>
                                <poi:cell value="#Local.respuesta.NB_FAMILIAINSUMO#"    class=""/>
                                <poi:cell value="#Local.respuesta.NB_SUBFAMILIAINSUMO#"     class=""/>
                                <poi:cell value="#Local.respuesta.NU_EXISTENCIA#"   class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_DISPONIBLE#"   class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_TRANSITO#"     class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_STOCKMINIMO#"      class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_STOCKMAXIMO#"      class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_ABAJOMINIMO#"      class="" style="text-align:right;" />
                                <poi:cell value="#Local.respuesta.NU_ARRIBAMAXIMO#"     class="" style="text-align:right;" />
                                <poi:cell value="#LSCurrencyFormat(Local.respuesta.IM_PRECIOULTIMO, "local")#"      class="" style="text-align:right;"/>
                                <poi:cell value="#LSCurrencyFormat(Local.respuesta.IM_TOTAL,"local")#"      class="" style="text-align:right;" />
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
                  nu_colWidth="3"
                  nu_rowHeight="6">

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc listado para la pantalla de valuacion de inventarios 15-12-2015 --->
    <cffunction name="valuacioninventarios" access="public" returntype="Any">
        <cfargument name="empresa"                  type="struct"  required="false"/>
        <cfargument name="sucursal"                  type="struct"  required="false"/>
        <cfargument name="almacen"                   type="struct"  required="false"/>
        <cfargument name="nb_NombreInsumo"           type="string"  required="false"/>
        <cfargument name="FamiliaInsumo"             type="struct"  required="false"/>
        <cfargument name="SubFamiliaInsumo"          type="struct"  required="false"/>
        <cfargument name="page"                      type="numeric" required="false"/>
        <cfargument name="pageSize"                  type="numeric" required="false"/>
        <cfargument name="fh_registro"               type="string"  required="false"/>
        <cfargument name="sn_Cierre"                 type="string"  required="false"/>

        <cfif isDefined("arguments.empresa")>
          <cfset arguments.id_Empresa = arguments.empresa.ID_EMPRESA>
      </cfif>

        <cfif isDefined("arguments.sucursal")>
            <cfset arguments.id_Sucursal = arguments.sucursal.ID_SUCURSAL>
        </cfif>

        <cfif isDefined("almacen")>
            <cfset arguments.id_almacen = arguments.almacen.ID_ALMACEN>
        </cfif>

        <!--- <cfif isDefined("insumo")>
            <cfset arguments.id_insumo = arguments.insumo.ID_INSUMO>
        </cfif> --->

        <cfif isDefined("FamiliaInsumo")>
            <cfset arguments.id_FamiliaInsumo = arguments.FamiliaInsumo.ID_FAMILIAINSUMO>
        </cfif>

        <cfif isDefined("SubFamiliaInsumo")>
            <cfset arguments.id_SubFamiliaInsumo = arguments.SubFamiliaInsumo.ID_SUBFAMILIAINSUMO>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                  method="valuacioninventarios"
                  argumentcollection="#arguments#"
                  returnvariable="Local.rs">


        <cfset variables.RBR.setQuery(Local.rs)>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- jc generacion de pdf para la pantalla de valuacion de inventarios 15-12-2015 --->
    <cffunction name="generarpdfvi"    access="public"     returntype="Any">
        <cfargument name="sucursal"                  type="struct"  required="false"/>
        <cfargument name="almacen"                   type="struct"  required="false"/>
        <cfargument name="insumo"                    type="struct"  required="false"/>
        <cfargument name="FamiliaInsumo"             type="struct"  required="false"/>
        <cfargument name="SubFamiliaInsumo"          type="struct"  required="false"/>

        <cfset local.DatosReporte = structNew()>
        <cfset arguments.id_Empresa = session.ID_EMPRESA>

        <cfif isDefined("arguments.sucursal")>
            <cfset local.DatosReporte.nb_sucursal = arguments.sucursal.NB_SUCURSAL>
            <cfset arguments.id_sucursal = arguments.sucursal.ID_SUCURSAL>
        <cfelse>
            <cfset local.DatosReporte.nb_sucursal = 'Todas'>
        </cfif>

        <cfif isDefined("arguments.almacen")>
            <cfset local.DatosReporte.nb_almacen = arguments.almacen.NB_ALMACEN>
            <cfset arguments.id_almacen = arguments.almacen.ID_ALMACEN>
        <cfelse>
            <cfset local.DatosReporte.nb_almacen = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.insumo")>
            <cfset local.DatosReporte.nb_insumo = arguments.insumo.NB_NOMBREINSUMO>
            <cfset arguments.id_insumo = arguments.insumo.ID_INSUMO>
        <cfelse>
            <cfset local.DatosReporte.nb_insumo = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.FamiliaInsumo")>
            <cfset arguments.id_FamiliaInsumo = arguments.FamiliaInsumo.ID_FAMILIAINSUMO>
            <cfset local.DatosReporte.NB_FAMILIAINSUMO = arguments.FamiliaInsumo.NB_FAMILIAINSUMO>
        <cfelse>
            <cfset local.DatosReporte.NB_FAMILIAINSUMO = 'Todas'>
        </cfif>

        <cfif isDefined("arguments.SubFamiliaInsumo")>
            <cfset arguments.id_SubFamiliaInsumo          = arguments.SubFamiliaInsumo.ID_SUBFAMILIAINSUMO>
            <cfset local.DatosReporte.NB_SUBFAMILIAINSUMO = arguments.SubFamiliaInsumo.NB_SUBFAMILIAINSUMO>
        <cfelse>
            <cfset local.DatosReporte.NB_SUBFAMILIAINSUMO = 'Todas'>
        </cfif>

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="datareporte"
                    argumentcollection="#arguments#"
                    returnvariable="Local.data">

        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para generar el pdf.')>
            <cfreturn variables.RBR>
        </cfif>


        <cfset var Local.infoReport={
            de_directorio="Reportes",
            nb_archivo="Valuaciondeinventarios#dateFormat(now(),'dd-mm-yyyy')#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="valuaciondeinventarios">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/valuaciondeinventarios.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#valuaciondeinventarios#"
                  pdf="#local.infoReport.nb_archivo#"
                  debug="no"
                  path="#expandPath('../#local.infoReport.de_directorio#/')#">

        <cfset Local.infoReport.nb_archivo=Local.infoReport.nb_archivo&'.pdf'>
        <cfset variables.RBR.setData(Local.infoReport)>

        <cfreturn Variables.RBR>
    </cffunction>

    <!--- jc generacion de excel para la pantalla de valuacion de inventarios 15-12-2015 --->
    <cffunction name="generarexcelvi"    access="public"     returntype="Any">
        <cfargument name="empresa"                  type="struct"  required="false"/>
        <cfargument name="sucursal"                  type="struct"  required="false"/>
        <cfargument name="almacen"                   type="struct"  required="false"/>
        <cfargument name="nb_NombreInsumo"           type="string"  required="false"/>
        <cfargument name="FamiliaInsumo"             type="struct"  required="false"/>
        <cfargument name="SubFamiliaInsumo"          type="struct"  required="false"/>
        <cfargument name="fecha"                    type="string"  required="false"/>

        <cfset local.DatosReporte = structNew()>
        <cfif isDefined("arguments.empresa")>
            <cfset arguments.id_Empresa = arguments.empresa.ID_EMPRESA>
        </cfif>

        <cfif isDefined("arguments.sucursal")>
            <cfset local.DatosReporte.nb_sucursal = arguments.sucursal.NB_SUCURSAL>
            <cfset arguments.id_sucursal = arguments.sucursal.ID_SUCURSAL>
        <cfelse>
            <cfset local.DatosReporte.nb_sucursal = 'Todas'>
        </cfif>

        <cfif isDefined("arguments.almacen")>
            <cfset local.DatosReporte.nb_almacen = arguments.almacen.NB_ALMACEN>
            <cfset arguments.id_almacen = arguments.almacen.ID_ALMACEN>
        <cfelse>
            <cfset local.DatosReporte.nb_almacen = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.nb_NombreInsumo")>
            <cfset local.DatosReporte.nb_NombreInsumo = arguments.nb_NombreInsumo>
        <cfelse>
            <cfset local.DatosReporte.nb_NombreInsumo = 'Todos'>
        </cfif>

        <cfif isDefined("arguments.FamiliaInsumo")>
            <cfset arguments.id_FamiliaInsumo = arguments.FamiliaInsumo.ID_FAMILIAINSUMO>
            <cfset local.DatosReporte.NB_FAMILIAINSUMO = arguments.FamiliaInsumo.NB_FAMILIAINSUMO>
        <cfelse>
            <cfset local.DatosReporte.NB_FAMILIAINSUMO = 'Todas'>
        </cfif>

        <cfif isDefined("arguments.SubFamiliaInsumo")>
            <cfset arguments.id_SubFamiliaInsumo          = arguments.SubFamiliaInsumo.ID_SUBFAMILIAINSUMO>
            <cfset local.DatosReporte.NB_SUBFAMILIAINSUMO = arguments.SubFamiliaInsumo.NB_SUBFAMILIAINSUMO>
        <cfelse>
            <cfset local.DatosReporte.NB_SUBFAMILIAINSUMO = 'Todas'>
        </cfif>

        <cfif isDefined("arguments.fecha")>
            <cfset arguments.fh_registro  = arguments.fecha>
            <cfset local.DatosReporte.FH_REGISTRO = arguments.fecha>
        <cfelse>
            <cfset local.DatosReporte.FH_REGISTRO = 'Todas'>
        </cfif>

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="datareporte"
                    argumentcollection="#arguments#"
                    returnvariable="resultado">
        <cfset variables.RBR.setData(resultado)>
        <cfreturn Variables.RBR>
        <!---
        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="datareporte"
                    argumentcollection="#arguments#"
                    returnvariable="Local.data">

        <!--- <cfdump var="#local.data#" /><cfabort /> --->
        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para generar el excel.')>
            <cfreturn variables.RBR>
        </cfif>

            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="Valuaciondeinventarios#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
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
                style="font-family: Arial ; font-size: 11pt ; color: black ; white-space: nowrap ;">


                <!--- Define style classes. --->
                <poi:classes>
                        <poi:class
                            name="title"
                            style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                            />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                        <poi:class
                            name="fondo"
                            style="border-bottom:2px;  background-color: GREY_50_PERCENT;"
                        />

                        <poi:class
                            name="familia"
                            style="border-bottom:2px;  background-color: GREY_40_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="subFamilia"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-bottom:2px; border-left:2px; border-rigth:2px;"
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
                        freezerow="13"
                        orientation="landscape"
                        zoom="100%">

                        <!--- Define global column styles. --->
                        <poi:columns>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 90px ;"/>
                            <poi:column style="width: 300px ;"/>
                            <poi:column style="width: 150px ; "/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 150px ;"/>
                        </poi:columns>

                        <poi:row class=''>
                        </poi:row>

                        <!--- Title row. --->
                        <poi:row>
                            <poi:cell value=''/>
                            <poi:cell value="Valuación de inventarios"colspan="2"  class="title"/>
                            <poi:cell value=''/>
                            <poi:cell value=''/>
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
                            <poi:cell value="Sucursal:" class="negrita"/>
                            <poi:cell value="#local.DatosReporte.nb_sucursal#" class=""/>
                            <poi:cell value=''/>
                            <poi:cell value="Familia Insumo:" class="negrita"/>
                            <poi:cell value="#local.DatosReporte.nb_FamiliaInsumo#" class=""/>
                        </poi:row>
                        <poi:row class=''>
                            <poi:cell value=''/>
                            <poi:cell value="Almacén:" class="negrita"/>
                            <poi:cell value="#local.DatosReporte.nb_almacen#" class=""/>
                            <poi:cell value=''/>
                            <poi:cell value="SubFamilia Insumo:" class="negrita"/>
                            <poi:cell value="#local.DatosReporte.nb_SubFamiliaInsumo#" class=""/>
                        </poi:row>
                        <poi:row class=''>
                            <poi:cell value=''/>
                            <poi:cell value="Insumo:" class="negrita"/>
                            <poi:cell value="#local.DatosReporte.nb_insumo#" class=""/>
                        </poi:row>

                        <poi:row class=''>
                        </poi:row>
                        <!--- Header row. --->
                        <poi:row >
                            <poi:cell value=''/>
                            <poi:cell value="Clave"                     class="header fondo borders"/>
                            <poi:cell value="Insumo"                    class="header fondo borders"/>
                            <!--- <poi:cell value="Sucursal"                    class="header fondo borders"/>
                            <poi:cell value="Almacén"                      class="header fondo borders"/> --->
                            <poi:cell value="Existencia teórica"       class="header fondo borders"/>
                            <poi:cell value="Precio unitario Promedio"  class="header fondo borders"/>
                            <poi:cell value="Importe existencia"        class="header fondo borders"/>
                        </poi:row>

                        <cfoutput query="local.data" group="id_FamiliaInsumo">
                            <poi:row>
                                <poi:cell value="" />
                                <poi:cell value="#nb_FamiliaInsumo#" class="Contenido familia borders"/>
                                <poi:cell value="" class="Contenido familia borders"/>
                                <poi:cell value="" class="Contenido familia borders"/>
                                <poi:cell value="" class="Contenido familia borders"/>
                                <poi:cell value="" class="Contenido familia borders"/>
                            </poi:row>
                            <cfoutput group="id_SubFamiliaInsumo">
                                <poi:row>
                                    <poi:cell value="" />
                                    <poi:cell value="#nb_SubFamiliaInsumo#" class="Contenido SubFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                </poi:row>
                                <cfoutput group="id_Insumo">
                                    <poi:row>
                                        <poi:cell value="" />
                                        <poi:cell value="#local.data.id_insumo#"                                class="Contenido borders"/>
                                        <poi:cell value="#local.data.nb_nombreinsumo#"                          class="Contenido borders"/>
                                        <!--- <poi:cell value="#local.data.nb_sucursal#"                                class="Contenido borders"/>
                                        <poi:cell value="#local.data.nb_almacen#"                               class="Contenido borders"/> --->
                                        <poi:cell value="#local.data.nu_existencia#"                            class="Contenido borders"/>
                                        <poi:cell value="#LsCurrencyFormat(local.data.im_PrecioPromedio)#"      style="text-align:right" class="Contenido borders"/>
                                        <poi:cell value="#LsCurrencyFormat(local.data.im_importeexistencia)#"   style="text-align:right" class="Contenido borders"/>
                                    </poi:row>
                                </cfoutput>
                                <poi:row>
                                    <poi:cell value="" />
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="" class="Contenido subFamilia borders"/>
                                    <poi:cell value="Total SubFamilia" style="text-align:right" class="Contenido subFamilia borders"/>
                                    <poi:cell value="#LsCurrencyFormat(local.data.im_existenciaSubFamilia)#" style="text-align:right" class="Contenido subFamilia borders"/>
                                </poi:row>
                            </cfoutput>
                            <poi:row>
                                <poi:cell value="" />
                                <poi:cell value="" class="Contenido Familia borders"/>
                                <poi:cell value="" class="Contenido Familia borders"/>
                                <poi:cell value="" class="Contenido Familia borders"/>
                                <poi:cell value="Total Familia : #nb_FamiliaInsumo#" style="text-align:right" class="Contenido Familia borders"/>
                                <poi:cell value="#LsCurrencyFormat(local.data.im_existenciaFamilia)#" style="text-align:right" class="Contenido Familia borders"/>
                            </poi:row>
                            <poi:row>
                                <poi:cell value="" />
                                <poi:cell value="" class="Contenido borders"/>
                                <poi:cell value="" class="Contenido borders"/>
                                <poi:cell value="" class="Contenido borders"/>
                                <poi:cell value="" class="Contenido borders"/>
                                <poi:cell value="" class="Contenido borders"/>
                            </poi:row>
                        </cfoutput>
                        <poi:row>
                            <poi:cell value="" />
                            <poi:cell value="" class="Contenido fondo borders"/>
                            <poi:cell value="" class="Contenido fondo borders"/>
                            <poi:cell value="" class="Contenido fondo borders"/>
                            <poi:cell value="Gran Total : " style="text-align:right" class="Contenido fondo borders negrita"/>
                            <poi:cell value="#LsCurrencyFormat(local.data.im_total)#" style="text-align:right" class="Contenido fondo borders"/>
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
                      nu_colWidth="2.7">

        <cfset variables.RBR.setData(Local.infoReport)>
        <cfreturn Variables.RBR>
          --->
    </cffunction>

    <!---
        Victor Sanchez
        19/01/2016
        Obtiene el precio promedio de almacenes existencias
     --->
    <cffunction name="upR_PrecioPromedio_AlmacenesExistencias" access="public" returntype="Any">
        <cfargument name="id_Empresa"       type="numeric" required="true"/>
        <cfargument name="id_Sucursal"      type="numeric" required="true"/>
        <cfargument name="id_Almacen"       type="numeric" required="true"/>
        <cfargument name="id_Insumo"        type="numeric" required="true"/>

            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="upR_PrecioPromedio_AlmacenesExistencias"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">


            <cfset variables.RBR.setQuery(Local.rs)>

            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AgregarLevantamientoInicial" access="public" returntype="Any">
        <cfargument name="Insumos"         type="array"  required="true">
        <cfargument name="id_Empresa"      type="string" required="true">
        <cfargument name="id_Sucursal"     type="string" required="true">
        <cfargument name="id_Almacen"      type="string" required="true">
        <cfargument name="id_Proveedor"    type="string" required="false">
        <cfargument name="id_Consignacion" type="string" required="false">

        <cfif "#arguments.id_Consignacion#" EQ nullValue()>
            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                method="EliminarInventarioLevantamientoInicial"
                id_Empresa="#arguments.id_Empresa#"
                id_Sucursal="#arguments.id_Sucursal#"
                id_Almacen="#arguments.id_Almacen#">

        <cfelse>
            <!--- Validamos que el almacen enviado sea de consignacion --->
            <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
                method="ValidacionConsignacion"
                id_Empresa="#arguments.id_Empresa#"
                id_Sucursal="#arguments.id_Sucursal#"
                id_Almacen="#arguments.id_Almacen#"
                returnvariable="local.AlmC">
        </cfif>

        <cfset arguments.im_TotalMN = 0>
        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.i">
            <cfset arguments.im_TotalMN = arguments.im_TotalMN + (arguments.Insumos[local.i].IM_PRECIOPROMEDIO * arguments.Insumos[local.i].NU_CANTIDAD)>
        </cfloop>

        <cfset arguments.id_TipoMovimiento = 4>
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
                  method="Agregar"
                  id_Empresa="#arguments.id_Empresa#"
                  id_Sucursal="#arguments.id_Sucursal#"
                  id_Almacen="#arguments.id_Almacen#"
                  id_TipoMovimiento=#arguments.id_TipoMovimiento#
                  im_Total="#arguments.im_TotalMN#"
                  returnvariable="local.InvMovData">

        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.ii">
            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
                    method="Agregar"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Sucursal="#arguments.id_Sucursal#"
                    id_Almacen="#arguments.id_Almacen#"
                    id_Movimiento="#local.InvMovData.id_Movimiento#"
                    id_TipoMovimiento=#arguments.id_TipoMovimiento#
                    id_Insumo="#arguments.Insumos[local.ii].ID_INSUMO#"
                    nu_Cantidad="#arguments.Insumos[local.ii].NU_CANTIDAD#"
                    im_Total="#arguments.Insumos[local.ii].IM_PRECIOPROMEDIO#"
                    id_TipoCosteo="2"
                    returnvariable="Local.InvMovDetData">

            <cfif NOT arguments.Insumos[local.ii].keyExists('IM_COSTO')>
                <cfset arguments.Insumos[local.ii].IM_COSTO = arguments.Insumos[local.ii].IM_PRECIOPROMEDIO>
            </cfif>
            <cfif NOT arguments.Insumos[local.ii].keyExists('IM_IMPORTE')>
                <cfset arguments.Insumos[local.ii].IM_IMPORTE = (arguments.Insumos[local.ii].IM_PRECIOPROMEDIO * arguments.Insumos[local.ii].NU_CANTIDAD)>
            </cfif>

            <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalleImportes')#"
                    method="Agregar"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Sucursal="#arguments.id_Sucursal#"
                    id_Almacen="#arguments.id_Almacen#"
                    id_Movimiento="#local.InvMovData.id_Movimiento#"
                    nd_MovimientoDetalle="#local.InvMovDetData.nd_MovimientoDetalle#"
                    nu_Cantidad = "#arguments.Insumos[local.ii].NU_CANTIDAD#"
                    im_PrecioPromedio = "#arguments.Insumos[local.ii].IM_PRECIOPROMEDIO#"
                    im_PrecioUnitario="#arguments.Insumos[local.ii].IM_COSTO#"
                    im_PrecioTotal="#arguments.Insumos[local.ii].IM_IMPORTE#"
                    im_PrecioUnitarioMN="#arguments.Insumos[local.ii].IM_COSTO#"
                    nu_SaldoInventario="#arguments.Insumos[local.ii].NU_CANTIDAD#"
                    returnvariable="Local.rbr">
        </cfloop>

        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.iii">
            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="AgregarLevantamientoInicial"
                    id_Empresa="#arguments.id_Empresa#"
                    id_Sucursal="#arguments.id_Sucursal#"
                    id_Almacen="#arguments.id_Almacen#"
                    id_Insumo = "#arguments.Insumos[local.iii].ID_INSUMO#"
                    nu_Cantidad = "#arguments.Insumos[local.iii].NU_CANTIDAD#"
                    im_PrecioPromedio = "#arguments.Insumos[local.iii].IM_PRECIOPROMEDIO#"
                    returnvariable="Local.rbr">
        </cfloop>

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
            method="GuardarLevantamientoInicial"
            id_Empresa="#arguments.id_Empresa#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#arguments.id_Almacen#"
            id_Movimiento="#local.InvMovData.id_Movimiento#"
            id_Proveedor="#arguments.id_Proveedor#"
            id_Consignacion="#arguments.id_Consignacion#"
            id_Usuario="#session.ID_USUARIO#">

        <cfset variables.RBR.setQuery(local.InvMovData)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="ListadoLevantamientoInicial" access="remote" returntypr="any">
        <cfargument name='id_Empresa'     type='string' required='yes'>
        <cfargument name='id_Sucursal'    type='string' required='yes'>
        <cfargument name='id_Almacen'     type='string' required='yes'>
        <!--- <cfargument name="nu_porcentaje" type="string" required="true">

        <cfset arguments.id_empresa = #session.ID_EMPRESA#>--->

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="ListadoLevantamientoInicial"
                    argumentcollection="#arguments#"
                    returnvariable="local.RS"/>

        <cfset local.Data = structNew()>
        <cfset local.Data = local.RS>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="existenciasFisica" access="public" returntype="Any">
        <cfargument name="id_Plaza"  type="string"  required="false"/>


            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                      method="existenciasFisica"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">


            <cfset variables.RBR.setQuery(Local.rs)>

            <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="generarexcel"    access="public"     returntype="Any">
        <cfargument name="id_Plaza"  type="string"  required="false"/>
        <cfargument name="plazatxt"  type="string"  required="false"/>

        <cfset local.DatosReporte = structNew()>

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="existenciasFisica"
                    argumentcollection="#arguments#"
                    returnvariable="Local.data">

        <cfset rowIndex = 0 />
        <cfset index = 0 />
        <cfset cols = [] />
        <cfset rows = [] />

        <cfset metadata = getMetaData(Local.data)>
        <cfloop from="1" to="#metadata.len()#" index="index">
          <cfset cols[index] = metadata[index].name />
        </cfloop>
        <cfset myList = ArrayToList(cols, ",")/>
        <cfset myList = #ReplaceList(myList, "_,-", " ")#/>
        <cfset columnas = listToArray(myList, ",",false,true)/>

        <cfloop from="1" to="#Local.data.recordCount#" index="rowIndex">
          <cfset column =[]/>
          <cfloop from="1" to="#arrayLen(cols)#" index="index">
              <cfset column[index] = Local.data["#cols[index]#"][rowIndex] />
          </cfloop>
          <cfset arrayAppend(rows, column) />
        </cfloop>

        <cfset Local.datos = structNew()>
        <cfset Local.datos.Encabezados = columnas>
        <cfset Local.datos.Rows = rows>
        <cfset variables.RBR.setData(datos)>
        <cfreturn Variables.RBR>

        <!--- <cfset metadata = getMetaData(Local.data) />
        <cfset rowIndex = 0 />
        <cfset index = 0 />
        <cfset cols = [] />

        <cfloop from="1" to="#metadata.len()#" index="index">
            <cfset cols[index] = metadata[index].name />
        </cfloop>
        <cfset myList = ArrayToList(cols, ",")/>
        <cfset myList = #ReplaceList(myList, "_,-", " ")#/>
        <cfset columnas = listToArray(myList, ",",false,true)/> --->

        <!--- GENERAR ROWS DINAMICO --->
        <!--- Recorremos todos los registros que nos arroja el resulset info.PRINCIPAL, a la par recorremos las columnas
        que se retornan, donde exista el match hacemos append al arreglo de rows para tener los resultados el mismo orden
        del retorno de base de datos, si se agrega un nuevo concepto, cae naturalmente --->
        <!--- <cfset rows = [] />
        <cfloop from="1" to="#Local.data.recordCount#" index="rowIndex">
            <cfset column =[]/>
            <cfloop from="1" to="#arrayLen(cols)#" index="index">
                <cfset column[index] = Local.data["#cols[index]#"][rowIndex] />
            </cfloop>
            <cfset arrayAppend(rows, column) />
        </cfloop>

        <cfif local.data.recordcount eq 0>
            <cfset variables.RBR.setError('No hay información para generar el excel.')>
            <cfreturn variables.RBR>
        </cfif>

            <cfset var Local.infoReport={
                de_directorio="Reportes",
                nb_archivo="existenciasFisica#dateFormat(now(),'dd-mm-yyyy')#.xlsx"
            }>

            <cfimport taglib="/lib/tags/poi/" prefix="poi" />

            <cfif NOT directoryExists(ExpandPath('../#local.infoReport.de_directorio#/'))>
                <cfset directoryCreate(ExpandPath('../#local.infoReport.de_directorio#/'))>
            </cfif>

            <poi:document
                name="REQUEST.ExcelData"
                file="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                style="font-family: Arial ; font-size: 11pt ; color: black ; white-space: nowrap ;">


                <!--- Define style classes. --->
                <poi:classes>
                        <poi:class
                            name="title"
                            style="font-family: Arial ; color: black ; font-size: 12pt ; text-align: left; font-weight: bold;"
                            />
                        <poi:class
                            name="negrita"
                            style="font-family: Arial ; color: black ;font-weight: bold;text-align:right;"
                            />
                        <poi:class
                            name="fondo"
                            style="border-bottom:2px;  background-color: GREY_50_PERCENT;"
                        />

                        <poi:class
                            name="familia"
                            style="border-bottom:2px;  background-color: GREY_40_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="subFamilia"
                            style="border-bottom:2px;  background-color: GREY_25_PERCENT; font-weight: bold;"
                        />

                        <poi:class
                            name="Total"
                            style="color: red; text-align: right ;"
                        />

                        <poi:class
                            name="borders"
                            style="border-bottom:2px; border-left:2px; border-rigth:2px;"
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
                        freezerow="8"
                        orientation="landscape"
                        zoom="80%">

                        <!--- Define global column styles. --->
                        <poi:columns>
                            <poi:column style="width: 100px ;"/>
                            <poi:column style="width: 350px ;"/>
                            <poi:column style="width: 150px ; "/>
                            <poi:column style="width: 150px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <poi:column style="width: 200px ;"/>
                            <cfloop index="item" from="6" to="#ArrayLen(columnas)#">
                                <poi:column style="width: 110px ;"/>
                            </cfloop>
                            <poi:column style="width: 135px ;"/>
                        </poi:columns>

                        <poi:row class=''>
                        </poi:row>

                        <poi:row>
                            <poi:cell value="#session.NB_RAZONSOCIAL#" class="title" style="text-align: left;"/>
                            <poi:cell index="9" value="#dateFormat(now(),'dd/mm/yyyy')#" class="negrita" style="text-align: right;"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value="Sucursal #session.NB_SUCURSAL#" style="text-align:left"/>
                        </poi:row>

                        <poi:row class=''>
                            <poi:cell value="#session.NB_DIRECCION#" style="text-align:left"/>
                        </poi:row>
                        <poi:row class=''></poi:row>

                        <poi:row class=''>
                            <poi:cell colspan="9" value='Existencia Fisica #arguments.plazatxt#' style="text-align:center; font-size: 12px;font-weight: bold"/>
                        </poi:row>
                        <poi:row class=''></poi:row>

                        <poi:row rowHeight="1">
                                <cfloop index="item" from="1" to="#ArrayLen(columnas)#">

                                    <cfif item NEQ 7>
                                        <poi:cell value="#columnas[item]#" class="header fondo borders" style="text-align:center"/>
                                    </cfif>
                                </cfloop>
                                <poi:cell value="#columnas[7]#" class="header fondo borders" style="text-align:center"/>
                            </poi:row>
                            <!--- Informacion --->
                            <cfloop index="x" from="1" to="#ArrayLen(rows)#">
                                <poi:row>
                                    <poi:cell value="#rows[x][1]#" type="numeric"          numberformat="0" style="text-align:left" class="Contenido borders"/>
                                    <poi:cell value="#rows[x][2]#" style="text-align:left" class="Contenido borders"/>
                                    <poi:cell value="#rows[x][3]#" style="text-align:left" class="Contenido borders"/>
                                    <poi:cell value="#rows[x][4]#" style="text-align:left" class="Contenido borders"/>
                                    <poi:cell value="#rows[x][5]#" style="text-align:left" class="Contenido borders"/>
                                    <poi:cell value="#rows[x][6]#" style="text-align:left" class="Contenido borders"/>
                                    <cfloop index="i" from="8" to="#ArrayLen(rows[x])#">
                                        <poi:cell value="#rows[x][i]#" type="numeric" numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>
                                    </cfloop>
                                    <poi:cell value="#rows[x][7]#"     type="numeric"   numberformat="##,####0.00" style="text-align:right" class="Contenido borders"/>

                                </poi:row>
                            </cfloop>


                    </poi:sheet>
                </poi:sheets>

            </poi:document> --->

            <!--- <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                      method="addImage"
                      nb_excelFile="#ExpandPath( '../#local.infoReport.de_directorio#/#local.infoReport.nb_archivo#')#"
                      src_image="#SERVER.ar_ImagenReporteBinary[session.ID_EMPRESA]#"
                      nb_sheet="Reporte"
                      nu_startRow="4"
                      nu_startCol="2"
                      nu_colWidth=".7">
         --->

    </cffunction>

    <cffunction name="ListadoMM" access="remote" returntypr="any">
        <cfargument name='id_Empresa'               type='string' required='yes'>
        <cfargument name='id_Sucursal'              type='string' required='yes'>
        <cfargument name='id_SubFamiliaInsumo'      type='string' required='no'>
        <cfargument name='id_FamiliaInsumo'         type='string' required='no'>

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="ListadoMM"
                    argumentcollection="#arguments#"
                    returnvariable="local.RS"/>

        <cfset local.Data = structNew()>
        <cfset local.Data = local.RS>
        <cfset variables.RBR.setData(local.Data)>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="AgregarMM" access="public" returntype="Any">
        <cfargument name='id_Empresa'     type='string' required='yes'>
        <cfargument name='id_Sucursal'    type='string' required='yes'>
        <cfargument name='Insumos'        type='array'  required='yes'>

        <cfloop from="1" to="#arrayLen(arguments.Insumos)#" index="local.i">
            <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
                    method="AgregarMM"
                    id_Empresa      = "#arguments.id_Empresa#"
                    id_Sucursal     = "#arguments.id_Sucursal#"
                    id_Insumo       = "#arguments.Insumos[local.i].ID_INSUMO#"
                    nu_StockMinimo  = "#arguments.Insumos[local.i].NU_STOCKMINIMOE#"
                    nu_StockMaximo  = "#arguments.Insumos[local.i].NU_STOCKMAXIMOE#"
                    id_Almacen      = "#arguments.id_Almacen#"
                    returnvariable  = "Local.rbr">
        </cfloop>
        <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Adrian Garcia Silva --->
    <cffunction name="notificacionStockMinimo" access="public" returntype="any">

        <cfset arguments.id_Empresa = session.ID_EMPRESA >
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL >

        <cfinvoke   component="#Application.RF.getPath('DAO','AlmacenesExistencias')#"
                    method="notificacionStockMinimo"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs" />

        <cfset variables.RBR.setQuery(Local.rs) >
        <cfreturn variables.RBR >
    </cffunction>

    <cffunction name="getCostoPromedio" access="public" returntype="any">
        <cfargument name='id_Insumo'      type='string' required='yes'>
        <cfargument name='id_Empresa'   type='string' required='yes'>
        <cfset arguments.id_Sucursal = SESSION.ID_SUCURSAL>

        <cfinvoke   component="#Application.RF.getPath('DAO','AlmacenesExistencias')#"
                    method="getCostoPromedio"
                    argumentcollection="#arguments#"
                    returnvariable="Local.rs" />

        <cfset variables.RBR.setQuery(Local.rs) >
        <cfreturn variables.RBR >
    </cffunction>

    <cffunction name="GenerarCartaEntrega" access="public" returntype="any">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="yes">
        <cfargument name="id_Almacen"    type="string" required="yes">
        <cfargument name="id_Movimiento" type="string" required="yes">
        <cfargument name="Insumos"       type="array"  required="yes">

        <cfinvoke component="#Application.RF.getPath('DAO','AlmacenesExistencias')#"
            method="GetLevantamientoInicialMovimiento"
            id_Empresa="#arguments.id_Empresa#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#arguments.id_Almacen#"
            id_Movimiento="#arguments.id_Movimiento#"
            returnvariable="Local.rs" />

        <cfif Local.rs.recordCount EQ 0>
            <cfset variables.RBR.setError('No se encontró información para generar el PDF<br>Favor de revisar')>
            <cfreturn variables.RBR>
        </cfif>

        <cfset data = structNew()>
        <cfset data.ID_EMPRESA = Local.rs.id_Empresa>
        <cfset data.NB_EMPRESA = local.rs.nb_Empresa>

        <cfset data.ID_SUCURSAL = Local.rs.id_Sucursal>
        <cfset data.NB_SUCURSAL = local.rs.nb_Sucursal>

        <cfset data.ID_ALMACEN = Local.rs.id_Almacen>
        <cfset data.NB_ALMACEN = local.rs.nb_Almacen>

        <cfset data.ID_LEVANTAMIENTO = Local.rs.fl_Movimiento>
        <cfset data.Insumos = Local.rs>

        <cfset var Local.infoCarta={
            de_directorio="Reportes",
            nb_archivo="LevantamientoInicial_#data.NB_EMPRESA#-#data.NB_SUCURSAL#-#data.NB_ALMACEN#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="LevantamientoInicial">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/LevantamientoInicialCarta.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
            method="generatePDFNoDownload"
            content="#LevantamientoInicial#"
            pdf="#local.infoCarta.nb_archivo#"
            debug="no"
            path="#expandPath('../#local.infoCarta.de_directorio#/')#">

        <cfset Local.infoCarta.nb_archivo = Local.infoCarta.nb_archivo&'.pdf'>
        <cfset Local.infoCarta.ar_archivoPDF = LevantamientoInicial>

        <cfset variables.RBR.setData(Local.infoCarta) >
        <cfreturn variables.RBR >
    </cffunction>

    <cffunction name="GenerarCartaEntregaAceptacion" access="public" returntype="any">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="yes">
        <cfargument name="id_Almacen"    type="string" required="yes">
        <cfargument name="id_Movimiento" type="string" required="yes">
        <cfargument name="Insumos"       type="array"  required="yes">

        <cfinvoke component="#Application.RF.getPath('DAO','AlmacenesExistencias')#"
            method="GetLevantamientoInicialMovimiento"
            id_Empresa="#arguments.id_Empresa#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#arguments.id_Almacen#"
            id_Movimiento="#arguments.id_Movimiento#"
            returnvariable="Local.rs" />

        <cfif Local.rs.recordCount EQ 0>
            <cfset variables.RBR.setError('No se encontró información para generar el PDF<br>Favor de revisar')>
            <cfreturn variables.RBR>
        </cfif>

        <cfset data = structNew()>
        <cfset data.ID_EMPRESA = Local.rs.id_Empresa>
        <cfset data.NB_EMPRESA = local.rs.nb_Empresa>

        <cfset data.ID_SUCURSAL = Local.rs.id_Sucursal>
        <cfset data.NB_SUCURSAL = local.rs.nb_Sucursal>

        <cfset data.ID_ALMACEN = Local.rs.id_Almacen>
        <cfset data.NB_ALMACEN = local.rs.nb_Almacen>

        <cfset data.NB_PROVEEDOR = Local.rs.NB_PROVEEDOR>
        <cfset data.NB_PROVEEDORDIRECCION = Local.rs.NB_PROVEEDORDIRECCION>
        <cfset data.NU_TELEFONOPROVEEDOR = Local.rs.NU_TELEFONOPROVEEDOR>

        <cfset data.ID_LEVANTAMIENTO = Local.rs.fl_Movimiento>
        <cfset data.Insumos = Local.rs>

        <cfset var Local.infoCarta={
            de_directorio="Reportes",
            nb_archivo="LI_CartaAceptación_#data.NB_EMPRESA#-#data.NB_SUCURSAL#-#data.NB_ALMACEN#"
        }>

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="LevantamientoInicial">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/LevantamientoInicialCartaAceptacion.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
            method="generatePDFNoDownload"
            content="#LevantamientoInicial#"
            pdf="#local.infoCarta.nb_archivo#"
            debug="no"
            path="#expandPath('../#local.infoCarta.de_directorio#/')#">

        <cfset Local.infoCarta.nb_archivo = Local.infoCarta.nb_archivo&'.pdf'>
        <cfset Local.infoCarta.ar_archivoPDF = LevantamientoInicial>

        <cfset variables.RBR.setData(Local.infoCarta) >
        <cfreturn variables.RBR >
    </cffunction>

    <cffunction name="ListarMovimientosLevantamientoInicial" access="remote" returntypr="any">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="false">
        <cfargument name="id_Almacen"    type="string" required="false">
        <cfargument name="fl_Movimiento" type="string" required="false">
        <cfargument name="sn_Carta"      type="string" required="false">
        <cfargument name="fh_Inicio"     type="string" required="yes">
        <cfargument name="fh_Fin"        type="string" required="yes">
        <cfargument name="page"          type="string" required="false">
        <cfargument name="pageSize"      type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
            method="ListarMovimientosLevantamientoInicial"
            argumentcollection="#arguments#"
            returnvariable="local.rs"/>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GetLevantamientoInicialMovimiento" access="remote" returntypr="any">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="false">
        <cfargument name="id_Almacen"    type="string" required="false">
        <cfargument name="id_Movimiento" type="string" required="false">
        <cfargument name="fl_Movimiento" type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
            method="GetLevantamientoInicialMovimiento"
            argumentcollection="#arguments#"
            returnvariable="local.rs"/>

        <cfset variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GuardarCarta" access="remote" returntypr="any">
        <cfargument name="id_Empresa"       type="string" required="true">
        <cfargument name="id_Sucursal"      type="string" required="true">
        <cfargument name="id_Almacen"       type="string" required="true">
        <cfargument name="id_Levantamiento" type="string" required="true">
        <cfargument name="ar_Carta"         type="array"  required="true">
        <cfargument name="nb_Archivo"       type="string" required="true">
        <cfargument name="de_Ruta"          type="string" required="true">

        <cfset pdfFile = expandPath("/root/#arguments.de_Ruta##arguments.nb_Archivo#")>
        <cffile action="Read" file="#pdfFile#" variable="PDFContent">

        <cfset pathLocalPDF = "/root/#arguments.de_Ruta##arguments.nb_Archivo#">
        <cfset pathDestino = "Documentos/Consignacion/CartaLevantamiento/#arguments.id_Empresa#/">

        <cfset argsSubirArchivoPDF = structnew()>
        <cfset argsSubirArchivoPDF.fileField = pathLocalPDF>
        <cfset argsSubirArchivoPDF.nb_archivo = arguments.nb_Archivo>
        <cfset argsSubirArchivoPDF.de_PathDestino = pathDestino>
        <cfset argsSubirArchivoPDF.rename = false>

        <cfinvoke component="#Application.RF.getPath('cfc','Documentos')#"
            method="subirArchivoGoogle"
            argumentcollection="#argsSubirArchivoPDF#"
            returnvariable="RSFileUploadPDF">

        <cfif FileExists(pathLocalPDF)>
            <cffile action="delete" file="#pathLocalPDF#">
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','AlmacenesExistencias')#"
            method="ActualizarRutaCarta"
            id_Empresa="#arguments.id_Empresa#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#arguments.id_Almacen#"
            id_Levantamiento="#arguments.id_Levantamiento#"
            nb_Archivo="#arguments.nb_Archivo#"
            de_Ruta="#pathDestino#"
            returnvariable="local.rs"/>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GenerarTraspasoConsignacion" access="remote" returntypr="any">
        <cfargument name="id_Empresa"        type="string" required="yes">
        <cfargument name="id_Sucursal"       type="string" required="false">
        <cfargument name="id_Almacen"        type="string" required="false">
        <cfargument name="id_Departamento"   type="string" required="false">
        <cfargument name="insumos"           type="array" required="false">
        <cfargument name="id_Requisicion"    type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
            method="getAlmacenConsignacion"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#session.ID_SUCURSAL#"
            returnvariable="local.Almacen"/>

        <!--- Se Genera el traspaso ---> <!--- Session - Almacen Ref --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosTraspasos')#"
            method="registrarTraspaso"
            fh_requerida="#dateFormat(now(), 'yyyymmdd')#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_almacenOrigen="#local.Almacen.id_Almacen#"
            id_departamento="#arguments.id_Departamento#"
            de_Observaciones="Traspaso por Consignación - Movimiento Automatico"
            detalle="#arguments.insumos#"
            returnvariable="Local.traspaso"/>

        <!--- Guardamos la información del traspaso que generamos --->
        <cfset Local.traspaso = Local.traspaso.getData()>

        <!--- Obtenemos la informacion del detalle del traspaso --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasosDetalle')#"
            method="getByTraspaso"
            id_empresa="#session.ID_EMPRESA#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.Detalle">

        <!--- Generamos un nuevo arreglo de los detalles para enviar a la salida --->
        <cfset TraspasoDetalle = structNew()>
        <cfset TraspasoDetalle.Salida = structNew()>
        <cfloop query="#Local.Detalle#">
            <cfset arrayAppend(TraspasoDetalle.Salida, {
                nd_inventarioTraspasoDetalle="#Local.Detalle.nd_InventarioTraspasoDetalle#",
                id_insumo="#Local.Detalle.id_Insumo#",
                nb_insumo="#Local.Detalle.nb_NombreInsumo#",
                nu_cantidad="#Local.Detalle.nu_CantidadSolicitada#",
                nu_cantidadSurtida="#Local.Detalle.nu_CantidadSurtida#",
                nu_cantidadEnviada="#Local.Detalle.nu_CantidadEnviada#",
                nu_cantidadPendienteEnviar="#Local.Detalle.nu_cantidadPendienteEnviar#",
                nu_cantidadTraspasar="#Local.Detalle.nu_CantidadSolicitada#",
                SN_SURTIDA="0",
                SN_ENVIADOCOMPLETO="0",
                nu_cantidadExistente="#Local.Detalle.nu_cantidadExistente#",
                NB_UNIDADMEDIDA="#Local.Detalle.nb_UnidadMedida#",
                SN_INSUMOSERIADO="#Local.Detalle.sn_InsumoSeriado#",
                series="",
                index="#0#",
                sn_error="#false#"
            })>
        </cfloop>

        <!--- Autorizamos en Automatico el traspaso ---> <!--- Session - Almacen Consignacion --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosTraspasos')#"
            method="changeStatus"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            sn_autoriza="#true#"
            de_Comentarios=""/>

        <!--- Realizamos la salida del inventarios de consginacion ---> <!--- Session - Almacen Consignacion --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
            method="creaMovimientoSalidaPorTraspaso"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            id_UsuarioRecibio="#session.ID_USUARIO#"
            de_Recibio="#session.NB_EMPLEADOCOMPLETO# - #session.NB_USUARIO#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_sucursalDestino="#Local.traspaso.ID_SUCURSALORIGEN#"
            id_almacenOrigen="#session.ID_ALMACEN#"
            id_almacenDestino="#local.Almacen.id_Almacen#"
            detalles="#TraspasoDetalle.Salida#"
            de_Comentarios="Traspaso por Consignación - Salida en Automático"
            id_Requisicion="#arguments.id_Requisicion#"
            id_TipoMovimiento="62" <!--- Tipo: Salida Traspaso Consignacion --->
            returnvariable="local.Salida"/>

        <cfif local.Salida.hasError()>
            <cfset Variables.RBR.setError(local.Salida.getMessage())>
            <cfreturn variables.RBR>
        </cfif>

        <!--- Obtenemos la informacion del detalle del traspaso --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="getByTraspaso"
            id_empresa="#session.ID_EMPRESA#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.Mov">

        <cfset EntradaMov.id_Movimiento = local.Mov.ID_MOVIMIENTO>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
            method="getByMovimientoEntradasTraspaso"
            id_Empresa="#session.ID_EMPRESA#"
            id_SucursalDestino="#session.ID_SUCURSAL#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_AlmacenDestino="#session.ID_ALMACEN#"
            id_almacenOrigen="#local.Almacen.id_Almacen#"
            id_movimiento="#EntradaMov.id_Movimiento#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.DetalleMov">

        <cfset TraspasoDetalle.Entrada = structNew()>
        <cfloop query="#local.DetalleMov#">
            <cfset arrayAppend(TraspasoDetalle.Entrada, {
                id_Insumo="#local.DetalleMov.ID_INSUMO#",
                nu_cantidadPendiente="#local.DetalleMov.NU_CANTIDADPENDIENTE#",
                ID_SUCURSALPROVENIENTE="#local.DetalleMov.ID_SUCURSALPROVENIENTE#",
                ID_ALMACENPROVENIENTE="#local.DetalleMov.ID_ALMACENPROVENIENTE#",
                ND_MOVIMIENTODETALLE="#local.DetalleMov.ND_MOVIMIENTODETALLE#",
                NU_CANTIDADREGISTRO="#local.DetalleMov.NU_CANTIDADPENDIENTE#",
                ND_INVENTARIOTRASPASODETALLE="#local.DetalleMov.ND_INVENTARIOTRASPASODETALLE#",
                seriesSeleccionadas=[]
            })>
        </cfloop>

        <!--- Session - Almacen Ref --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
            method="creaMovimientoEntradaPorTraspaso"
            id_inventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            id_movimiento="#EntradaMov.id_Movimiento#"
            id_sucursalOrigen="#Local.traspaso.ID_SUCURSALORIGEN#"
            id_almacenOrigen="#local.Almacen.id_Almacen#"
            detalles="#TraspasoDetalle.Entrada#"
            id_TipoMovimiento="61" <!--- Tipo: Entrada Traspaso Consignacion --->
            returnvariable="Local.Entrada"/>

        <cfif local.Entrada.hasError()>
            <cfset Variables.RBR.setError(local.Entrada.getMessage())>
            <cfreturn variables.RBR>
        </cfif>

        <cfset variables.RBR = Local.Entrada>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="GenerarTraspasoConsignacionPorCancelacion" access="remote" returntypr="any">
        <cfargument name="id_Empresa"    type="string" required="yes">
        <cfargument name="id_Sucursal"   type="string" required="false">
        <cfargument name="id_Almacen"    type="string" required="false">
        <cfargument name="id_Movimiento" type="string" required="false">

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="MovimientoConConsignacion"
            id_Empresa="#arguments.id_Empresa#"
            id_Sucursal="#arguments.id_Sucursal#"
            id_Almacen="#arguments.id_Almacen#"
            id_Movimiento="#arguments.id_Movimiento#"
            returnvariable="local.Requisicion"/>

        <cfif local.Requisicion.RecordCount EQ 0>
            <cfreturn variables.RBR>
        </cfif>

        <cfscript>
            an_array = [];

            local.Requisicion.each(function(row){
                an_array.append(row);
            });
        </cfscript>

        <cfinvoke component="#Application.RF.getPath('dao','Almacenes')#"
            method="getAlmacenConsignacion"
            id_Empresa="#session.ID_EMPRESA#"
            id_Sucursal="#session.ID_SUCURSAL#"
            returnvariable="local.Almacen"/>

        <!--- Se Genera el traspaso ---> <!--- Session - Almacen Ref --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosTraspasos')#"
            method="registrarTraspaso"
            fh_requerida="#dateFormat(now(), 'yyyymmdd')#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_almacenOrigen="#arguments.id_Almacen#"
            id_departamento="#local.Requisicion.ID_DEPARTAMENTO#"
            de_Observaciones="Traspaso por Consignación - Movimiento Automatico"
            detalle="#an_array#"
            id_sucursalDestino="#session.ID_SUCURSAL#"
            id_almacenDestino="#local.Almacen.id_Almacen#"
            returnvariable="Local.traspaso"/>

        <!--- Guardamos la información del traspaso que generamos --->
        <cfset Local.traspaso = Local.traspaso.getData()>

        <!--- Obtenemos la informacion del detalle del traspaso --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosTraspasosDetalle')#"
            method="getByTraspaso"
            id_empresa="#session.ID_EMPRESA#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.Detalle">

        <!--- Generamos un nuevo arreglo de los detalles para enviar a la salida --->
        <cfset TraspasoDetalle = structNew()>
        <cfset TraspasoDetalle.Salida = structNew()>
        <cfloop query="#Local.Detalle#">
            <cfset arrayAppend(TraspasoDetalle.Salida, {
                nd_inventarioTraspasoDetalle="#Local.Detalle.nd_InventarioTraspasoDetalle#",
                id_insumo="#Local.Detalle.id_Insumo#",
                nb_insumo="#Local.Detalle.nb_NombreInsumo#",
                nu_cantidad="#Local.Detalle.nu_CantidadSolicitada#",
                nu_cantidadSurtida="#Local.Detalle.nu_CantidadSurtida#",
                nu_cantidadEnviada="#Local.Detalle.nu_CantidadEnviada#",
                nu_cantidadPendienteEnviar="#Local.Detalle.nu_cantidadPendienteEnviar#",
                nu_cantidadTraspasar="#Local.Detalle.nu_CantidadSolicitada#",
                SN_SURTIDA="0",
                SN_ENVIADOCOMPLETO="0",
                nu_cantidadExistente="#Local.Detalle.nu_cantidadExistente#",
                NB_UNIDADMEDIDA="#Local.Detalle.nb_UnidadMedida#",
                SN_INSUMOSERIADO="#Local.Detalle.sn_InsumoSeriado#",
                series="",
                index="#0#",
                sn_error="#false#"
            })>
        </cfloop>

        <!--- Autorizamos en Automatico el traspaso ---> <!--- Session - Almacen Consignacion --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosTraspasos')#"
            method="changeStatus"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            sn_autoriza="#true#"
            de_Comentarios=""/>

        <!--- Realizamos la salida del inventarios de consginacion ---> <!--- Session - Almacen Consignacion --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
            method="creaMovimientoSalidaPorTraspaso"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            id_UsuarioRecibio="#session.ID_USUARIO#"
            de_Recibio="#session.NB_EMPLEADOCOMPLETO# - #session.NB_USUARIO#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_sucursalDestino="#Local.traspaso.ID_SUCURSALORIGEN#"
            id_almacenOrigen="#local.Almacen.id_Almacen#"
            id_almacenDestino="#arguments.id_Almacen#"
            detalles="#TraspasoDetalle.Salida#"
            de_Comentarios="Traspaso por Consignación - Salida en Automático"
            id_Requisicion="#local.Requisicion.ID_REQUISICION#"
            id_TipoMovimiento="62" <!--- Tipo: Salida Traspaso Consignacion --->
            returnvariable="local.Salida"/>

        <cfif local.Salida.hasError()>
            <cfset Variables.RBR.setError(local.Salida.getMessage())>
            <cfreturn variables.RBR>
        </cfif>

        <!--- Obtenemos la informacion del detalle del traspaso --->
        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientos')#"
            method="getByTraspaso"
            id_empresa="#session.ID_EMPRESA#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.Mov">

        <cfset EntradaMov.id_Movimiento = local.Mov.ID_MOVIMIENTO>

        <cfinvoke component="#Application.RF.getPath('dao','InventariosMovimientosDetalle')#"
            method="getByMovimientoEntradasTraspaso"
            id_Empresa="#session.ID_EMPRESA#"
            id_SucursalDestino="#session.ID_SUCURSAL#"
            id_sucursalOrigen="#session.ID_SUCURSAL#"
            id_AlmacenDestino="#local.Almacen.id_Almacen#"
            id_almacenOrigen="#arguments.id_Almacen#"
            id_movimiento="#EntradaMov.id_Movimiento#"
            id_InventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            returnvariable="Local.DetalleMov">

        <cfset TraspasoDetalle.Entrada = structNew()>
        <cfloop query="#local.DetalleMov#">
            <cfset arrayAppend(TraspasoDetalle.Entrada, {
                id_Insumo="#local.DetalleMov.ID_INSUMO#",
                nu_cantidadPendiente="#local.DetalleMov.NU_CANTIDADPENDIENTE#",
                ID_SUCURSALPROVENIENTE="#local.DetalleMov.ID_SUCURSALPROVENIENTE#",
                ID_ALMACENPROVENIENTE="#local.DetalleMov.ID_ALMACENPROVENIENTE#",
                ND_MOVIMIENTODETALLE="#local.DetalleMov.ND_MOVIMIENTODETALLE#",
                NU_CANTIDADREGISTRO="#local.DetalleMov.NU_CANTIDADPENDIENTE#",
                ND_INVENTARIOTRASPASODETALLE="#local.DetalleMov.ND_INVENTARIOTRASPASODETALLE#",
                seriesSeleccionadas=[]
            })>
        </cfloop>

        <!--- Session - Almacen Ref --->
        <cfinvoke component="#Application.RF.getPath('bro','InventariosMovimientos')#"
            method="creaMovimientoEntradaPorTraspaso"
            id_inventarioTraspaso="#Local.traspaso.id_InventarioTraspaso#"
            id_movimiento="#EntradaMov.id_Movimiento#"
            id_sucursalOrigen="#Local.traspaso.ID_SUCURSALORIGEN#"
            id_almacenOrigen="#arguments.id_Almacen#"
            detalles="#TraspasoDetalle.Entrada#"
            id_TipoMovimiento="61" <!--- Tipo: Entrada Traspaso Consignacion --->
            id_sucursalDestino="#session.ID_SUCURSAL#"
            id_almacenDestino="#local.Almacen.id_Almacen#"
            returnvariable="Local.Entrada"/>

        <cfif local.Entrada.hasError()>
            <cfset Variables.RBR.setError(local.Entrada.getMessage())>
            <cfreturn variables.RBR>
        </cfif>

        <cfset variables.RBR = Local.Entrada>
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>
