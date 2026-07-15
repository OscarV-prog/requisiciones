<cfcomponent>
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <!--- 
        Autor: Mario Mejia
        Fecha: 05/06/2015
        Comentario: Funcion que realiza el registro del numero de serie de varios insumos
     --->
    <cffunction name="agregarInsumos" access="remote" returntype="any">
        <cfargument name="insumos" type="array" required="true">

        <!--- iteramos sobre los insumos --->
        <cfloop from ="1"  to="#arrayLen(arguments.insumos)#"  index="Local.i">
            <!--- obtenemos el next id para la tabla --->
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="getNextID"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_insumo="#arguments.insumos[local.i].id_insumo#"
                        returnvariable="Local.nextIdSerieInsumo">

            <!--- verificamos si la serie ya esta registrada --->
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="existeSerie"
                        de_serieInsumo="#arguments.insumos[local.i].de_serieInsumo#"
                        returnvariable="Local.sn_existe">

            <!--- Si esta registrada marcamos error y salimos --->
            <cfif Local.sn_existe>
                <cfset variables.RBR.setError('La serie '&#arguments.insumos[i].de_serieInsumo#&' del insumo '&#arguments.insumos[i].nb_nombreInsumo#&' ya esta registrada.')>
                <cfreturn variables.RBR>
            </cfif>

            
            <cfif  NOT structKeyExists(arguments.insumos[i],"DE_ETIQUETA")>

                <cfset arguments.insumos[i].DE_ETIQUETA =''>
            </cfif>

            <!--- Procedemos a guardar --->
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="RSAgregar"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_insumo="#arguments.insumos[local.i].id_insumo#"
                        id_AlmacenExistenciaSerieInsumo="#Local.nextIdSerieInsumo#"
                        de_serieInsumo="#arguments.insumos[i].de_serieInsumo#"
                        de_etiqueta="#arguments.insumos[i].DE_ETIQUETA#"
                        >

            <!--- se hace un recorrido para insertar en la tabla AlmacenesExistenciasCamposDetalle --->
            <cfloop from="1" to="#arrayLen(arguments.insumos[local.i].CAMPOS)#" index="local.j">
                <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasCamposDetalle')#"
                        method="Agregar"
                        id_empresa          ="#session.ID_EMPRESA#"
                        id_sucursal         ="#SESSION.ID_SUCURSAL#"
                        id_almacen          ="#session.ID_ALMACEN#"
                        id_insumo           ="#arguments.insumos[local.i].id_insumo#"
                        id_AlmacenExistenciaSerieInsumo ="#Local.nextIdSerieInsumo#"
                        id_Campodetalle     ="#arguments.insumos[local.i].CAMPOS[local.j].id_Campodetalle#"
                        nb_Campodetalle     ="#arguments.insumos[local.i].CAMPOS[local.j].nb_Campodetalle#"
                        de_valorCampodetalle="#arguments.insumos[local.i].CAMPOS[local.j].de_valorCampodetalle#">
            </cfloop>
        </cfloop>

        <cfreturn variables.RBR>
    </cffunction>

    <!--- julio cesar acosta lopez 0X 
            08/06/2015
            funcion que lista las series en existencias--->
    <cffunction name="listarseries" access="remote" returntype="any">
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="listarseries"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        returnvariable="local.rs">

        <cfset variables.RBR.setQuery(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor:    Mario Mejia     30/07/2015
          Procedimiento que nos manda las series de un insumo en particular --->
    <cffunction name="listarSeriesByIdInsumo" access="remote" returntype="any">
        <cfargument name="id_insumo" type="numeric" required="true">
        <cfargument name="id_requisicion" type="numeric" required="false"><!--- Este dato sirve para traer el id_grupoCentroCosto dada una requisicion --->

        <cfif isDefined("arguments.id_requisicion")>
            <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="listarSeriesByIdInsumo"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_insumo ="#arguments.id_insumo#"
                        id_requisicion="#arguments.id_requisicion#"
                        sn_AlmacenFisico="#arguments.sn_AlmacenFisico#"
                        returnvariable="local.rs">
            <cfelse>
                <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="listarSeriesByIdInsumo"
                        id_empresa="#session.ID_EMPRESA#"
                        id_sucursal="#SESSION.ID_SUCURSAL#"
                        id_almacen="#session.ID_ALMACEN#"
                        id_insumo ="#arguments.id_insumo#"
                        sn_AlmacenFisico="#arguments.sn_AlmacenFisico#"
                        returnvariable="local.rs">
        </cfif>

        <cfset variables.RBR.setQuery(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

<!--- Victor Sanchez --->
    <cffunction name="listar_seriesByOrdenCompraAndId_Insumos" access="remote" returntype="any">
        <cfargument name="id_insumo" type="string" required="true">
        <cfargument name="id_ordencompra" type="string" required="true"><!--- Este dato sirve para traer el id_grupoCentroCosto dada una requisicion --->
        <cfargument name="factura"  type="string" required="false">
        <cfset args = structNew()>
        <cfif isDefined("arguments.factura0")>
            <cfset args.factura = arguments.factura>
        </cfif>
        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                        method="listar_seriesByOrdenCompraAndId_Insumos"
                        id_ordencompra="#arguments.id_ordencompra#"
                        id_insumo ="#arguments.id_insumo#"
                        argumentcollection="#args#"
                        returnvariable="local.rs">
        
        <cfset variables.RBR.setQuery(local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 10/07/2015
          Busca si la serie esta registrada --->
    <cffunction name="existsSerieInsumo" access="remote" returntype="any">
        <cfargument name="id_insumo"      type="string" required="true">
        <cfargument name="de_serieInsumo" type="string" required="true">

        <cfinvoke   component="#Application.RF.getPath('dao','AlmacenesExistenciasSeriesInsumos')#"
                    method="existsSerieInsumo"
                    id_empresa="#session.ID_EMPRESA#"
                    id_sucursal="#SESSION.ID_SUCURSAL#"
                    id_almacen="#session.ID_ALMACEN#"
                    id_insumo="#Arguments.id_insumo#"
                    de_serieInsumo="#Arguments.de_serieInsumo#"
                    returnvariable="local.rs">
                    
        <cfset variables.RBR.setData({sn_exists=local.rs.sn_existe EQ 1})>
        <cfreturn variables.RBR>
    </cffunction>

</cfcomponent>