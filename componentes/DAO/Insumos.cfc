

<cfcomponent extends="wiz/sucursales">

    <cffunction name="get_Insumos_AyudaFacturacion" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="numeric"  required="true"/>
        <cfargument name="nb_NombreInsumo"  type="string"   required="false" default=""/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                EXEC upL_Insumos_AyudaFacturacion
                    @id_Empresa             = #Arguments.id_Empresa#,
                    @nb_NombreInsumo        = <cfif Len(Arguments.nb_NombreInsumo) gt 0>'#Arguments.nb_NombreInsumo#'<cfelse>NULL</cfif>,
                    @id_Cliente     =   <cfif isDefined('Arguments.id_Cliente')  and isNumeric(Arguments.id_Cliente)>#Arguments.id_Cliente#<cfelse>NULL</cfif>
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>


    <cffunction name="nextID" access="public" returntype="string">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfquery name="Local.Insumos" datasource="#variables.cnx#" >
            exec upR_InsumosNextID
                                #arguments.id_Empresa#
        </cfquery>

        <cfreturn Local.Insumos.nextID />
    </cffunction>

    <cffunction name="existeInsumo" access="public" returntype="boolean">
        <cfargument name="id_empresa"            type="string" required="true"/>
        <cfargument name="id_Insumo"             type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"       type="string" required="true"/>


        <cfquery datasource="#variables.cnx#" name="Local.Insumos">
            exec upR_InsumosExist #Arguments.id_empresa#,#Arguments.id_Insumo#,'#Arguments.nb_NombreInsumo#'
        </cfquery>

        <cfreturn Local.Insumos.isExists/>
    </cffunction>


    <cffunction name="combo_impuestosTazas" access="public" returntype="query">
        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_ImpuestosTasas
            <cfif isDefined("session.ID_EMPRESA") AND session.ID_EMPRESA NEQ ''>#session.ID_EMPRESA#<cfelse>1</cfif>
        </cfquery>
    <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="SubFamiliaInsumo" access="public" returntype="Query">
        <cfargument name="id_Familia"     type="numeric" required="false"/>
        <cfargument name="id_Subfamilia"  type="numeric" required="false"/>
        <cfargument name="nb_Subfamilia"  type="string" required="false"/>
        <cfargument name="id_Empresa"     type="numeric" required="false"/>


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_SubFamiliasInsumos #Arguments.id_Familia#,#Arguments.id_Subfamilia#,'#Arguments.nb_Subfamilia#','#Arguments.id_Empresa#'
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="Marcas" access="public" returntype="Query">
        <cfargument name="id_marca"     type="numeric" required="false"/>
        <cfargument name="nb_marca"     type="string" required="false"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_Marcas #Arguments.id_marca#,'#Arguments.nb_marca#'
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="UnidadesMedida" access="public" returntype="Query">
        <cfargument name="id_UnidadMedida"     type="numeric" required="false"/>
        <cfargument name="nb_UnidadMedida"     type="string" required="false"/>
        <cfargument name="id_Empresa"           type="numeric" required="false"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_UnidadesMedida #Arguments.id_UnidadMedida#,'#Arguments.nb_UnidadMedida#',#Arguments.id_Empresa#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="agregar" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string" required="true"/>
        <cfargument name="id_Insumo"                type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="true"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="true"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="string" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_ActivoFijo"            type="string" required="false"/>
        <cfargument name="sn_CentroCosto"           type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true"/>
        <cfargument name="id_Taza"                  type="string" required="true"/>
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>

            <cfquery datasource="#variables.cnx#">
                exec upC_Insumos
                                        #Arguments.id_Empresa#,
                                        #Arguments.id_Insumo#,
                                        '#Arguments.nb_NombreInsumo#',
                                        '#Arguments.nb_NombreCortoInsumo#',
                                        #arguments.id_TipoAlmacen#,
                                         <cfif #Arguments.id_SubFamiliaInsumo# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaInsumo#</cfif>,
                                         <cfif #Arguments.id_SubFamiliaDinamica# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaDinamica#</cfif>,
                                         #Arguments.id_UnidadMedida#,
                <cfif isDefined("Arguments.id_Marca") AND ARGUMENTS.id_Marca   NEQ ''>'#arguments.id_Marca#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Requizitable") AND ARGUMENTS.sn_Requizitable   NEQ ''>
                    <cfif ARGUMENTS.sn_Requizitable EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_Seriado") AND ARGUMENTS.sn_Seriado   NEQ ''>
                    <cfif ARGUMENTS.sn_Seriado EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_ActivoFijo") AND ARGUMENTS.sn_ActivoFijo   NEQ ''>
                    <cfif ARGUMENTS.sn_ActivoFijo EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_CentroCosto") AND ARGUMENTS.sn_CentroCosto   NEQ ''>
                    <cfif ARGUMENTS.sn_CentroCosto EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_Transporte") AND ARGUMENTS.sn_Transporte   NEQ ''>
                    <cfif ARGUMENTS.sn_Transporte EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               #arguments.id_TipoRequisicion#,
               <cfif #sn_Arrendamiento# EQ 'YES'>1<cfelse>0</cfif>,
               #arguments.id_TipoDestino#,
               <cfif isDefined("arguments.id_ReferenciaContable")>
                    '#arguments.id_ReferenciaContable#'
                <cfelse>
                    NULL
               </cfif>,
               #id_Impuesto#,
               #id_Taza#,
                <cfif #Arguments.c_ClaveProdServ# EQ ''>NULL<cfelse>'#Arguments.c_ClaveProdServ#'</cfif>,
              #SESSION.ID_EMPLEADO#,
              #arguments.sn_InsumoActivo#,
              #arguments.sn_Relevante#

            </cfquery>
    </cffunction>

    <cffunction name="AgregarMultiplesInsumos" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string" required="true"/>
        <cfargument name="id_Insumo"                type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="true"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="true"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="numeric" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_ActivoFijo"            type="string" required="false"/>
        <cfargument name="sn_CentroCosto"           type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true"/>
        <cfargument name="id_Taza"                  type="string" required="true"/>
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>

        <cfstoredproc procedure="upC_Insumos" datasource="#variables.cnx#">

            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Empresa"            value="#arguments.id_Empresa#"              null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Insumo"             value="#arguments.id_Insumo#"               null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@nb_NombreInsumo"       value="#arguments.nb_NombreInsumo#"         null="#iif(Len(arguments.nb_NombreInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@nb_NombreCortoInsumo"  value="#arguments.nb_NombreCortoInsumo#"    null="#iif(Len(arguments.nb_NombreCortoInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoAlmacen"        value="#arguments.id_TipoAlmacen#"          null="#iif(isNumeric(arguments.id_TipoAlmacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_SubFamiliaInsumo"   value="#arguments.id_SubFamiliaInsumo#"     null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_SubFamiliaDinamica" value="#arguments.id_SubFamiliaDinamica#"   null="#iif(isNumeric(arguments.id_SubFamiliaDinamica),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_UnidadMedida"       value="#arguments.id_UnidadMedida#"         null="#iif(isNumeric(arguments.id_UnidadMedida),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Marca"              value="#arguments.id_Marca#"                null="#iif(isNumeric(arguments.id_Marca),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Requisitable"       value="#arguments.sn_Requizitable#"         null="#iif(isNumeric(arguments.sn_Requizitable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Seriado"            value="#arguments.sn_Seriado#"              null="#iif(isNumeric(arguments.sn_Seriado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_ActivoFijo"         value="#arguments.sn_ActivoFijo#"           null="#iif(isNumeric(arguments.sn_ActivoFijo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_CentroCosto"        value="#arguments.sn_CentroCosto#"          null="#iif(isNumeric(arguments.sn_CentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Transporte"         value="#arguments.sn_Transporte#"           null="#iif(isNumeric(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoRequisicion"    value="#arguments.id_TipoRequisicion#"      null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Arrendamiento"      value="#arguments.sn_Arrendamiento#"        null="#iif(isNumeric(arguments.sn_Arrendamiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoDestino"        value="#arguments.id_TipoDestino#"          null="#iif(isNumeric(arguments.id_TipoDestino),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@id_ReferenciaContable" value="#arguments.id_ReferenciaContable#"   null="#iif(Len(arguments.id_ReferenciaContable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Impuesto"           value="#arguments.id_Impuesto#"             null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Taza"               value="#arguments.id_Taza#"                 null="#iif(isNumeric(arguments.id_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@c_ClaveProdServ"       value="#arguments.c_ClaveProdServ#"         null="#iif(Len(arguments.c_ClaveProdServ),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Empleado"           value="#session.ID_EMPLEADO#"               null="#iif(isNumeric(session.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_InsumoActivo"       value="#arguments.sn_InsumoActivo#"         null="#iif(isNumeric(arguments.sn_InsumoActivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Relevante"          value="#arguments.sn_Relevante#"            null="#iif(isNumeric(arguments.sn_Relevante),false,true)#">
            <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@de_zona"        value="#arguments.de_zona#"     null="#iif(Len(arguments.de_zona),false,true)#"> --->
            <cfprocresult name="Local.rs" resultset="1">

        </cfstoredproc>

            <!--- <cfquery datasource="#variables.cnx#">
                exec upC_Insumos
                                        #Arguments.id_Empresa#,
                                        #Arguments.id_Insumo#,
                                        '#Arguments.nb_NombreInsumo#',
                                        '#Arguments.nb_NombreCortoInsumo#',
                                        #arguments.id_TipoAlmacen#,
                                        <cfif #Arguments.id_SubFamiliaInsumo# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaInsumo#</cfif>,
                                        <cfif #Arguments.id_SubFamiliaDinamica# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaDinamica#</cfif>,
                                        #Arguments.id_UnidadMedida#,
                <cfif isDefined("Arguments.id_Marca") AND ARGUMENTS.id_Marca   NEQ ''>'#arguments.id_Marca#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Requizitable") AND ARGUMENTS.sn_Requizitable   NEQ ''>
                    <cfif ARGUMENTS.sn_Requizitable EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_Seriado") AND ARGUMENTS.sn_Seriado   NEQ ''>
                    <cfif ARGUMENTS.sn_Seriado EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_ActivoFijo") AND ARGUMENTS.sn_ActivoFijo   NEQ ''>
                    <cfif ARGUMENTS.sn_ActivoFijo EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_CentroCosto") AND ARGUMENTS.sn_CentroCosto   NEQ ''>
                    <cfif ARGUMENTS.sn_CentroCosto EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_Transporte") AND ARGUMENTS.sn_Transporte   NEQ ''>
                    <cfif ARGUMENTS.sn_Transporte EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               #arguments.id_TipoRequisicion#,
               <cfif #sn_Arrendamiento# EQ 'YES'>1<cfelse>0</cfif>,
               #arguments.id_TipoDestino#,
               <cfif isDefined("arguments.id_ReferenciaContable")>
                    '#arguments.id_ReferenciaContable#'
                <cfelse>
                    NULL
               </cfif>,
               #id_Impuesto#,
               #id_Taza#,
                <cfif #Arguments.c_ClaveProdServ# EQ ''>NULL<cfelse>'#Arguments.c_ClaveProdServ#'</cfif>,
              #SESSION.ID_EMPLEADO#

            </cfquery> --->
    </cffunction>

    <cffunction name="listar" access="public" returntype="query">
        <cfargument name="id_insumo"            type="string"   required="false"/>
        <cfargument name="nb_insumo"            type="string"   required="false"/>
        <cfargument name="id_subfamilia"        type="string"   required="false"/>
        <cfargument name="id_Empresa"           type="numeric"  required="false"/>
        <cfargument name="sn_activo"            type="string"   required="false"/>
        <cfargument name="id_TipoRequisicion"   type="numeric"  required="false"/>
        <cfargument name="page"                 type="string"   required="false" default="1"/>
        <cfargument name="pageSize"             type="string"   required="false" default="10"/>
        <cfargument name="id_Familia"           type="string"   required="false"/>
        <cfargument name="sn_InsumoActivo"      type="string"   required="false"/>
        <cfargument name="sn_Relevante"   type="string"   required="false"/>

        <cfstoredproc procedure="upL_Insumos_listadoPaginado" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_insumo"            value="#arguments.id_insumo#"           null="#iif(isnumeric(arguments.id_insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_insumo"            value="#arguments.nb_insumo#"           null="#iif(len(arguments.nb_insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_subfamilia"        value="#arguments.id_subfamilia#"       null="#iif(isnumeric(arguments.id_subfamilia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"           value="#arguments.id_Empresa#"          null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_activo"            value="#arguments.sn_activo#"           null="#iif(isnumeric(arguments.sn_activo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@page"                 value="#arguments.page#"                null="#iif(isnumeric(arguments.page),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@pageSize"             value="#arguments.pageSize#"            null="#iif(isnumeric(arguments.pageSize),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_TipoRequisicion"   value="#arguments.id_TipoRequisicion#"  null="#iif(isnumeric(arguments.id_TipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Familia"           value="#arguments.id_Familia#"          null="#iif(isnumeric(arguments.id_Familia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_InsumoActivo"      value="#arguments.sn_InsumoActivo#"     null="#iif(isnumeric(arguments.sn_InsumoActivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Relevante"         value="#arguments.sn_Relevante#"        null="#iif(isnumeric(arguments.sn_Relevante),false,true)#">

            <cfprocresult name="Local.Insumos" resultset="1">
        </cfstoredproc>

        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="listarTodos" access="public" returntype="query">
        <cfargument name="id_Empresa"     type="numeric" required="false"/>
        <cfargument name="id_Insumo"      type="numeric" required="false"/>
        <cfargument name="nb_Insumo"      type="string" required="false"/>
        <cfargument name="id_SubFamilia"  type="numeric" required="false"/><!---
        <cfargument name="page"           type="string"     required="false">
        <cfargument name="pageSize"       type="string"     required="false">  --->
        <cfargument name="id_FamiliaInsumo" type="numeric" required="false"/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_Insumos
                <cfif isDefined("Arguments.id_insumo") and arguments.id_insumo NEQ ''>#Arguments.id_insumo#<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.nb_insumo") and arguments.nb_insumo NEQ ''>'#Arguments.nb_insumo#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.id_subfamilia") and arguments.id_subfamilia NEQ ''>#Arguments.id_subfamilia#<cfelse>NULL</cfif>,
                  #arguments.id_Empresa#,
                <cfif isDefined("Arguments.id_FamiliaInsumo") and arguments.id_FamiliaInsumo NEQ ''>#Arguments.id_FamiliaInsumo#<cfelse>NULL</cfif>
            </cfquery>

            <cfreturn Local.Insumos/>
    </cffunction>

    <!---
        Victor Sanchez
        30/12/2015
        Lista los insumos de tipo combustible
     --->
    <cffunction name="upL_InsumosProductosAyuda" access="public" returntype="query">
        <cfargument name="nb_insumo"      type="string" required="false"/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_InsumosProductosAyuda
                        #session.ID_EMPRESA#,
                        <cfif isDefined("nb_insumo") AND #nb_insumo# NEQ ''>'#nb_insumo#'<cfelse>NULL</cfif>
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

<!---
        Victor Sanchez
        09/12/2015
        Lee el insumo por su nombre
--->
    <cffunction name="upR_InsumoByName" access="public" returntype="query">
        <cfargument name="nb_insumo"      type="string" required="false"/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upR_InsumoByName '#nb_insumo#'
            </cfquery>

            <cfreturn Local.Insumos/>
    </cffunction>

<!--- Victor Sanchez
    23/09/2015
    Trae la unidad de medida de un insumo --->
    <cffunction name="obtenerUnidadMedidadeInsumo" access="public" returntype="query">
        <cfargument name="id_insumo"      type="string" required="true"/>
        <cfargument name="id_empresa"      type="string" required="true"/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upR_UnidadMedidaById_Insumo #arguments.id_empresa#,#arguments.id_insumo#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <!--- Victor Sanchez
          Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel2" access="public" returntype="query">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="yes"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_SubFamiliasDinamicasNivel2 #session.ID_EMPRESA#,#id_SubFamiliaInsumo#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <!--- Victor Sanchez
          Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel3" access="public" returntype="query">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_SubFamiliasDinamicasNivel3 #session.ID_EMPRESA#,#id_SubFamiliaDinamica#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <!--- Victor Sanchez
          Date: 23/07/2015 --->
    <cffunction name="SubFamiliasDinamicasNivel4" access="public" returntype="query">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_SubFamiliasDinamicasNivel4 #session.ID_EMPRESA#, #id_SubFamiliaDinamica#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <!--- Victor Sanchez
          Date: 23/07/2015
          saca el nivel de una subfamilia --->
    <cffunction name="sacarNivel" access="public" returntype="query">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upR_nivelSubFamilia #session.ID_EMPRESA#,#id_SubFamiliaDinamica#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

        <!--- Victor Sanchez
          Date: 23/07/2015
          saca el padre --->
    <cffunction name="sacarPadre" access="public" returntype="query">
        <cfargument name="id_SubFamiliaDinamica" type="string" required="yes"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upR_sacarPadre #session.ID_EMPRESA#,#id_SubFamiliaDinamica#
            </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <!--- julio cesar acosta lopez
          listar los insumos para la asignacion de los conceptos de gastos a cada insumo
          08/07/2015 --->
    <cffunction name="listarinsumosasignacionconceptogasto" access="public" returntype="query">
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="false"/>
        <cfargument name="id_FamiliaInsumo"         type="string" required="false"/>
        <cfargument name="nb_InsumoListado"         type="string" required="false"/>
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="page"                     type="numeric" required="true"/>
        <cfargument name="pageSize"                 type="numeric" required="true"/>

        <!--- <cfdump var="#arguments#"/><cfabort/> --->
        <cfquery datasource="#variables.cnx#" name="Local.Insumos">
            exec upL_Insumosparaasignacionconceptogasto
            <cfif isDefined("Arguments.id_SubFamiliaInsumo") AND arguments.id_SubFamiliaInsumo NEQ '' AND arguments.id_SubFamiliaInsumo NEQ 0 >'#Arguments.id_SubFamiliaInsumo#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_FamiliaInsumo") AND arguments.id_FamiliaInsumo NEQ '' >'#Arguments.id_FamiliaInsumo#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_InsumoListado") AND arguments.nb_InsumoListado NEQ ''>'#Arguments.nb_InsumoListado#'<cfelse>NULL</cfif>,
                                                       #arguments.id_Empresa#,
                                                       #arguments.page#,
                                                       #arguments.pageSize#
        </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="getNumeroInsumos" access="public" returntype="query">
        <cfargument name="id_Empresa"               type="numeric" required="true"/>
        <cfargument name="id_Sucursal"              type="numeric" required="true"/>
        <cfargument name="id_Almacen"               type="string" required="true"/>
        <cfargument name="id_BloqueoInventario"     type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_AlmacenesExistenciasBloqueoInventariosInsumosTotales
                                #arguments.id_Empresa#,
                                #arguments.id_Sucursal#,
                                #arguments.id_Almacen#,
                                #arguments.id_BloqueoInventario#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="DatosInsumo" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Sucursal"  type="numeric" required="true"/>
        <cfargument name="id_Almacen"   type="numeric" required="true"/>
                <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                    exec upL_InsumosDatosSalidaAlmacenAjuste
                                        #arguments.id_Empresa#,
                                        #arguments.id_Sucursal#,
                                        #arguments.id_Almacen#
                </cfquery>
            <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="getUltimoPrecioCompra" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="numeric" required="true"/>
        <cfargument name="id_Insumo"    type="numeric" required="true"/>
                <cfquery datasource="#variables.cnx#" name="Local.rs">
                    exec upL_InsumosUltimoPrecioCompraUltimoPrecio
                                        #arguments.id_Empresa#,
                                        #arguments.id_Insumo#
                </cfquery>
            <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="InsumosCombo" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string" required="true"/>
        <cfargument name="id_FamiliaProducto"   type="string" required="false"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_InsumosCombo
                                #arguments.id_Empresa#
            </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="listarInsumosCotizar" access="public" returntype="query">
        <cfargument name ="id_Empresa"      type="numeric" required="true">
        <cfargument name ="id_Proveedor"    type="numeric" required="true">
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_InsumosparaCotizar
                                    #arguments.id_Empresa#,
                                    #arguments.id_Proveedor#
            </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="listarInsumosparaAutorizarOrdenCompra" access="public" returntype="query">
        <cfargument name="id_Empresa"           type="numeric" required="true"/>
        <cfargument name="id_Cotizacion"        type="string" required="false"/>
        <cfargument name="id_OrdenCompra"       type="numeric" required="true"/>
        <cfargument name="sn_Genero"            type="string" required="false"/>

            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_InsumosparaAutorizarOrdenCompra
                                #arguments.id_Empresa#,
                    <cfif isDefined("Arguments.id_Cotizacion")    AND arguments.id_Cotizacion NEQ ''>#Arguments.id_Cotizacion#<cfelse>NULL</cfif>,
                                #arguments.id_OrdenCompra#,
                                #arguments.sn_Genero#
            </cfquery>

            <cfreturn Local.Insumos/>
    </cffunction>


    <cffunction name="editar" access="public" returntype="void">
        <cfargument name="id_Empresa"               type="string" required="true"/>
        <cfargument name="id_Insumo"                type="string" required="true"/>
        <cfargument name="nb_NombreInsumo"          type="string" required="true"/>
        <cfargument name="nb_NombreCortoInsumo"     type="string" required="true"/>
        <cfargument name="id_TipoAlmacen"           type="numeric" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"      type="string" required="true"/>
        <cfargument name="id_SubFamiliaDinamica"    type="string" required="true"/>
        <cfargument name="id_UnidadMedida"          type="string" required="true"/>
        <cfargument name="id_Marca"                 type="string" required="false"/>
        <cfargument name="sn_Requizitable"          type="string" required="false"/>
        <cfargument name="sn_Seriado"               type="string" required="false"/>
        <cfargument name="sn_ActivoFijo"            type="string" required="false"/>
        <cfargument name="sn_CentroCosto"           type="string" required="false"/>
        <cfargument name="id_TipoRequisicion"       type="string" required="true"/>
        <cfargument name="sn_Transporte"            type="string" required="false"/>
        <cfargument name="sn_InsumoActivo"          type="string" required="false"/>
        <cfargument name="sn_Arrendamiento"         type="string" required="true"/>
        <cfargument name="id_TipoDestino"           type="string" required="true"/>
        <cfargument name="id_ReferenciaContable"    type="string" required="false"/>
        <cfargument name="id_Impuesto"              type="string" required="true"/>
        <cfargument name="id_Taza"                  type="string" required="true"/>
        <cfargument name="c_ClaveProdServ"          type="string" required="false"/>
        <cfargument name="sn_Relevante"             type="string" required="false"/>
        <cfargument name="sn_AplicarTodasEmpresas"  type="string" required="false"/>

        <cfif arguments.id_SubFamiliaDinamica EQ '0'>
            <cfset arguments.id_SubFamiliaDinamica = nullValue()>
        </cfif>

        <cfif arguments.id_Marca EQ ''>
            <cfset arguments.id_Marca = nullValue()>
        </cfif>

        <cfstoredproc procedure="upU_Insumos" datasource="#variables.cnx#">

            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_empresa"                 value="#arguments.id_Empresa#"                  null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Insumo"                  value="#arguments.id_Insumo#"                   null="#iif(isNumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@nb_NombreInsumo"            value="#arguments.nb_NombreInsumo#"             null="#iif(Len(arguments.nb_NombreInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@nb_NombreCortoInsumo"       value="#arguments.nb_NombreCortoInsumo#"        null="#iif(Len(arguments.nb_NombreCortoInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoAlmacen"             value="#arguments.id_TipoAlmacen#"              null="#iif(isNumeric(arguments.id_TipoAlmacen),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_SubFamiliaInsumo"        value="#arguments.id_SubFamiliaInsumo#"         null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_SubFamiliaDinamica"      value="#arguments.id_SubFamiliaDinamica#"       null="#iif(isNumeric(arguments.id_SubFamiliaDinamica),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_UnidadMedida"            value="#arguments.id_UnidadMedida#"             null="#iif(isNumeric(arguments.id_UnidadMedida),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Marca"                   value="#arguments.id_Marca#"                    null="#iif(isNumeric(arguments.id_Marca),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Requisitable"            value="#arguments.sn_Requizitable#"             null="#iif(isNumeric(arguments.sn_Requizitable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Seriado"                 value="#arguments.sn_Seriado#"                  null="#iif(isNumeric(arguments.sn_Seriado),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_ActivoFijo"              value="#arguments.sn_ActivoFijo#"               null="#iif(isNumeric(arguments.sn_ActivoFijo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_CentroCosto"             value="#arguments.sn_CentroCosto#"              null="#iif(isNumeric(arguments.sn_CentroCosto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Transporte"              value="#arguments.sn_Transporte#"               null="#iif(isNumeric(arguments.sn_Transporte),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoRequisicion"         value="#arguments.id_TipoRequisicion#"          null="#iif(isNumeric(arguments.id_TipoRequisicion),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_InsumoActivo"            value="#arguments.sn_InsumoActivo#"             null="#iif(isNumeric(arguments.sn_InsumoActivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Arrendamiento"           value="#arguments.sn_Arrendamiento#"            null="#iif(isNumeric(arguments.sn_Arrendamiento),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_TipoDestino"             value="#arguments.id_TipoDestino#"              null="#iif(isNumeric(arguments.id_TipoDestino),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@id_ReferenciaContable"      value="#arguments.id_ReferenciaContable#"       null="#iif(Len(arguments.id_ReferenciaContable),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Impuesto"                value="#arguments.id_Impuesto#"                 null="#iif(isNumeric(arguments.id_Impuesto),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Taza"                    value="#arguments.id_Taza#"                     null="#iif(isNumeric(arguments.id_Taza),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@c_ClaveProdServ"            value="#arguments.c_ClaveProdServ#"             null="#iif(Len(arguments.c_ClaveProdServ),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@id_Empleado"                value="#session.ID_EMPLEADO#"                   null="#iif(isNumeric(session.ID_EMPLEADO),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_Relevante"               value="#arguments.sn_Relevante#"                null="#iif(isNumeric(arguments.sn_Relevante),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER"       dbvarname="@sn_AplicarTodasEmpresas"    value="#arguments.sn_AplicarTodasEmpresas#"     null="#iif(isNumeric(arguments.sn_AplicarTodasEmpresas),false,true)#">
            <!--- <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR"       dbvarname="@de_zona"        value="#arguments.de_zona#"     null="#iif(Len(arguments.de_zona),false,true)#"> --->
            <!--- <cfprocresult name="Local.rs" resultset="1"> --->

        </cfstoredproc>

        <!--- <cfreturn Local.rs/> --->

            <!--- <cfquery datasource="#variables.cnx#">
                        exec upU_Insumos
                                        #Arguments.id_Empresa#,
                                        #Arguments.id_Insumo#,
                                        '#Arguments.nb_NombreInsumo#',
                                        '#Arguments.nb_NombreCortoInsumo#',
                                        #arguments.id_TipoAlmacen#,
                                         <cfif #Arguments.id_SubFamiliaInsumo# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaInsumo#</cfif>,
                                         <cfif #Arguments.id_SubFamiliaDinamica# EQ '0'>NULL<cfelse>#Arguments.id_SubFamiliaDinamica#</cfif>,
                                         #Arguments.id_UnidadMedida#,
                <cfif isDefined("Arguments.id_Marca") AND ARGUMENTS.id_Marca   NEQ ''>'#arguments.id_Marca#'<cfelse>NULL</cfif>,
                <cfif isDefined("Arguments.sn_Requizitable") AND ARGUMENTS.sn_Requizitable   NEQ ''>
                        <cfif ARGUMENTS.sn_Requizitable EQ 'YES'>
                            1
                            <cfelse>
                            0
                        </cfif>
                    <cfelse>
                    0
                </cfif>,
                <cfif isDefined("Arguments.sn_Seriado") AND ARGUMENTS.sn_Seriado   NEQ ''>
                        <cfif ARGUMENTS.sn_Seriado EQ 'YES'>
                            1
                            <cfelse>
                            0
                        </cfif>
                    <cfelse>
                    0
                </cfif>,
               <cfif isDefined("Arguments.sn_ActivoFijo") AND ARGUMENTS.sn_ActivoFijo   NEQ ''>
                    <cfif ARGUMENTS.sn_ActivoFijo EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_CentroCosto") AND ARGUMENTS.sn_CentroCosto   NEQ ''>
                    <cfif ARGUMENTS.sn_CentroCosto EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               <cfif isDefined("Arguments.sn_Transporte") AND ARGUMENTS.sn_Transporte   NEQ ''>
                    <cfif ARGUMENTS.sn_Transporte EQ 'YES'>
                        1
                    <cfelse>
                        0
                    </cfif>
                  <cfelse>
                    0
               </cfif>,
               #arguments.id_TipoRequisicion#,
               <cfif isDefined("InsumoActivo")>
                    <cfif #InsumoActivo# EQ 'YES'>1<cfelse>0</cfif>
                <cfelse>
                0
               </cfif>,
               <cfif #sn_Arrendamiento# EQ 'YES'>1<cfelse>0</cfif>,
               #arguments.id_TipoDestino#,
               <cfif isDefined("arguments.id_ReferenciaContable")>
                    '#arguments.id_ReferenciaContable#'
                <cfelse>
                    NULL
               </cfif>,
               #id_Impuesto#,
               #id_Taza#,
               <cfif #Arguments.c_ClaveProdServ# EQ ''>NULL<cfelse>#Arguments.c_ClaveProdServ#</cfif>,
                #SESSION.ID_EMPLEADO#
            </cfquery> --->
    </cffunction>

    <!--- function para asignar los conceptos de gastos a los insumos
            julio cesar acosta lopez
            09/07/2015--->
    <cffunction name="AsignarConceptoGasto" access="public" returntype="void">
        <cfargument name="id_empresa"               type="string" required="true"/>
        <cfargument name="id_insumo"                type="string" required="true"/>
        <cfargument name="id_conceptogasto"         type="string" required="true"/>

            <cfquery datasource="#variables.cnx#">
                        exec upU_InsumosAsignacioconceptogasto
                                        '#Arguments.id_empresa#',
                                        '#Arguments.id_insumo#',
                                        '#Arguments.id_conceptogasto#'
            </cfquery>
    </cffunction>

    <cffunction name="listarInsumosAutoComplete" access="public" returntype="query">
       <cfargument name="id_Empresa"           type="numeric"      required="true"/>
       <cfargument name="id_TipoRequisicion" type="numeric" required="false">

        <cfquery name="Local.InsumosAutoComplete" datasource="#variables.cnx#" >
            exec upL_InsumosAutoComplete #arguments.id_Empresa#,
            <cfif isDefined("arguments.id_TipoRequisicion")>#arguments.id_TipoRequisicion#<cfelse>NULL</cfif>,
            #SESSION.ID_SUCURSAL#
        </cfquery>
        <cfreturn Local.InsumosAutoComplete/>
    </cffunction>


    <cffunction name="UltimoPrecioCompra" access="public" returntype="query">
       <cfargument name="id_Insumo"            type="string"       required="true"/>
       <cfargument name="id_Empresa"           type="numeric"      required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#">
            exec upL_InsumosUltimoPrecioCompraUltimoPrecio
                            #arguments.id_Empresa#,
                            #arguments.id_Insumo#

        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="listarInsumosAutoCompleteRegistroCompraCombustible" access="public" returntype="query">
       <cfargument name="id_Insumo"            type="string"       required="false"/>
       <cfargument name="nb_NombreInsumo"      type="string"       required="false"/>
       <cfargument name="id_Empresa"           type="numeric"      required="true"/>

        <cfquery name="Local.InsumosAutoComplete" datasource="#variables.cnx#" >

            exec upL_InsumosAutoCompleteRegistroCompraCombustible

            <cfif isDefined("Arguments.id_Insumo")    AND arguments.id_Insumo NEQ ''>#Arguments.id_Insumo#<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.nb_NombreInsumo")    AND arguments.nb_NombreInsumo NEQ ''>#Arguments.nb_NombreInsumo#<cfelse>NULL</cfif>,
                      #arguments.id_Empresa#

        </cfquery>
        <cfreturn Local.InsumosAutoComplete/>
    </cffunction>

    <cffunction name="buscarID" access="public" returntype="string">
        <cfargument name="id_Empresa"   type="numeric" required="false"/>
        <cfquery name="Local.Insumos" datasource="#variables.cnx#" >
            exec upR_InsumosNextID
                                #session.ID_EMPRESA#
        </cfquery>

        <cfreturn Local.Insumos.nextID />
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="void">
        <cfargument name="id_Empresa"   type="string" required="true"/>
        <cfargument name="id_insumo"    type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.Insumos">
            exec upD_Insumos
            #Arguments.id_Empresa#,
            #Arguments.id_insumo#
        </cfquery>
    </cffunction>


    <cffunction name="listarInsumosporIdCotizacion" access="public" returntype="query">
    <cfargument name="id_Cotizacion"   type="numeric"     required="true"/>
    <cfargument name="id_Empresa"      type="numeric"     required="true"/>

        <cfquery name="Local.Insumos" datasource="#variables.cnx#" >
            exec upL_CotizacionesDetalleparaInsumosPrecios
                               #arguments.id_Cotizacion#,
                               #arguments.id_Empresa#
        </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>


    <cffunction name="listarInsumosporOrdenCompra" access="public" returntype="query">
    <cfargument name="id_Empresa"          type="numeric"     required="true"/>
    <cfargument name="id_OrdenCompra"      type="numeric"     required="true"/>

        <cfquery name="Local.Insumos" datasource="#variables.cnx#" >
            exec upL_InsumosporIdOrdenDeCompras
                               #arguments.id_Empresa#,
                               #arguments.id_OrdenCompra#
        </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="listarInsumosbyIDorNB" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="numeric"      required="true"/>
        <cfargument name="id_Sucursal"  type="numeric"     required="true"/>
        <cfargument name="id_Almacen"   type="numeric"      required="true"/>
        <cfargument name="id_insumo"    type="string"       required="false" default="NULL"/>
        <cfargument name="nb_insumo"    type="string"       required="false" default="NULL"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            EXEC upL_InsumosAlmacenesExistencias
                <cfif isDefined("arguments.id_Empresa") AND arguments.id_insumo NEQ ''>#Arguments.id_Empresa#<cfelse>#session.ID_EMPRESA#</cfif>,
                <cfif isDefined("arguments.id_Sucursal") AND arguments.id_Sucursal NEQ ''>#Arguments.id_Sucursal#<cfelse>#SESSION.ID_SUCURSAL#</cfif>,
                <cfif isDefined("arguments.id_Almacen") AND arguments.id_Almacen NEQ ''>#Arguments.id_Almacen#<cfelse>#session.ID_ALMACEN#</cfif>,
                <cfif isDefined("arguments.id_insumo")  AND arguments.id_insumo NEQ ''>#Arguments.id_insumo#<cfelse>NULL</cfif>,
                <cfif isDefined("arguments.nb_insumo")  AND arguments.nb_insumo NEQ ''>'#Arguments.nb_insumo#'<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="AutocompleteInsumo" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="numeric"      required="true"/>
        <cfargument name="id_Sucursal"  type="numeric"     required="true"/>
        <cfargument name="id_Almacen"   type="numeric"      required="true"/>
        <cfargument name="id_insumo"    type="string"       required="false" default="NULL"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            EXEC upL_InsumosAlmacenesExistencias
                <cfif isDefined("arguments.id_Empresa") AND arguments.id_insumo NEQ ''>#Arguments.id_Empresa#<cfelse>#session.ID_EMPRESA#</cfif>,
                <cfif isDefined("arguments.id_Sucursal") AND arguments.id_Sucursal NEQ ''>#Arguments.id_Sucursal#<cfelse>#SESSION.ID_SUCURSAL#</cfif>,
                <cfif isDefined("arguments.id_Almacen") AND arguments.id_Almacen NEQ ''>#Arguments.id_Almacen#<cfelse>#session.ID_ALMACEN#</cfif>,
                <cfif isDefined("arguments.id_insumo")  AND arguments.id_insumo NEQ ''>#Arguments.id_insumo#<cfelse>NULL</cfif>
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarInsumosSolicitudCompra" access="public" returntype="query">
       <cfargument name="id_SolicitudCompra"    type="string"       required="false"/>
       <cfargument name="id_Insumo"             type="string"       required="false"/>
       <cfargument name="id_Empresa"            type="numeric"       required="true"/>

        <cfquery name="Local.SolicitudCompra" datasource="#variables.cnx#" >

           exec upL_SolicitudCompraDetalleparaSolicitudCompra
            <cfif isDefined("Arguments.id_SolicitudCompra")  AND arguments.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                    #arguments.id_Empresa#
        </cfquery>
        <cfreturn Local.SolicitudCompra/>
    </cffunction>

    <!--- funcion que devuelve los insumos de una solicitud de compra --->
    <cffunction name="getinsumossolicitudcompra" access="public" returntype="query">
       <cfargument name="id_SolicitudCompra"    type="string"       required="false"/>
       <cfargument name="id_Empresa"            type="numeric"       required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
           exec upL_SolicitudCompraDetallegetinsumos
            <cfif isDefined("Arguments.id_SolicitudCompra")  AND arguments.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>,
                    #arguments.id_Empresa#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>


    <!--- --->
    <cffunction name="getSolicitudCompraInsumosParaCotizacion" access="public" returntype="query">
       <cfargument name="id_Empresa"            type="numeric"       required="true"/>
       <cfargument name="id_SolicitudCompra"    type="numeric"       required="false"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
           EXECUTE upL_SolicitudCompraInsumosParaCotizacion
                    @id_Empresa         = #Arguments.id_Empresa#,
                    @id_SolicitudCompra = #Arguments.id_SolicitudCompra#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarInsumosSolicitudCompraDatos" access="public" returntype="query">
       <cfargument name="id_SolicitudCompra"    type="string"       required="false"/>
       <cfargument name="id_Empresa"             type="string"       required="false"/>

        <cfquery name="Local.SolicitudCompraDatos" datasource="#variables.cnx#" >

           exec upL_SolicitudCompraDatosparaCotizacion
                #arguments.id_Empresa#,
                <cfif isDefined("Arguments.id_SolicitudCompra")  AND arguments.id_SolicitudCompra NEQ ''>#Arguments.id_SolicitudCompra#<cfelse>NULL</cfif>


        </cfquery>
        <cfreturn Local.SolicitudCompraDatos/>
    </cffunction>

    <cffunction name="listarInsumosDetalleInsumosCotizar" access="public" returntype="query">
       <cfargument name="id_SolicitudCompra"    type="string"       required="false"/>
       <cfargument name="id_Insumo"             type="string"       required="false"/>

        <cfquery name="Local.DetalleInsumosCotizar" datasource="#variables.cnx#" >

           exec upL_SolicitudCompraDetalleparaDetalleInsumosCotizar

            <cfif isDefined("Arguments.id_Insumo")  AND arguments.id_Insumo NEQ ''>#Arguments.id_Insumo#<cfelse>NULL</cfif>

        </cfquery>
        <cfreturn Local.DetalleInsumosCotizar/>
    </cffunction>

    <cffunction name="getInsumosPorSolicitudCompra" access="public" returntype="query">
        <cfargument name="id_empresa"          type="string" required="true"/>
        <cfargument name="id_solicitudCompra"  type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            EXECUTE upL_insumosPorSolicitudCompra
                        #Arguments.id_empresa#,
                        #Arguments.id_solicitudCompra#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getInsumosPorSolicitudCompraAlmacen" access="public" returntype="query">
        <cfargument name="id_empresa"           type="string" required="true"/>
        <cfargument name="id_Sucursal"          type="string" required="false"/>
        <cfargument name="id_solicitudCompra"   type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            EXECUTE upL_insumosPorSolicitudCompraAlmacen
                        #Arguments.id_empresa#,
                        #Arguments.id_solicitudCompra#,
                        #Arguments.id_Sucursal#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>


    <cffunction name="listarByCotizacion" access="public" returntype="query">
        <cfargument name="id_empresa"          type="string" required="true"/>
        <cfargument name="id_cotizacion"  type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            /*exec upL_insumosPorCotizacion*/
            exec upR_Insumosbysolicitudcompra
            #Arguments.id_empresa#,#Arguments.id_cotizacion#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="listarByCotizacion_SC" access="public" returntype="query">
        <cfargument name="id_empresa"          type="string" required="true"/>
        <cfargument name="id_cotizacion"  type="string" required="true"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            /*exec upL_insumosPorCotizacion*/
            exec upR_Insumosbysolicitudcompra_SC
            #Arguments.id_empresa#,#Arguments.id_cotizacion#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 08/05/2015
          OBTIENE LOS INSUMOS PARA AUTOCOMPLETE POR PROVEEDOR --->
    <cffunction name="listarInsumosAutoCompleteByProveedor" access="public" returntype="query">
       <cfargument name="id_Empresa"           type="numeric"      required="true"/>
       <cfargument name="id_Proveedor"           type="numeric"      required="true"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_InsumosAutoCompleteByProveedor #arguments.id_Empresa#,#Arguments.id_Proveedor#
        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="tipoDestinoInsumos" access="public" returntype="query">
        <cfquery datasource="#variables.cnx#" name="Local.tiposDestino">
            exec upL_tipoDestinoInsumo
        </cfquery>
    <cfreturn Local.tiposDestino/>
    </cffunction>

    <!--- Jesus Reyes --->
    <cffunction name="InsumosMaterialesCombo" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string" required="true"/>
            <cfquery datasource="#variables.cnx#" name="Local.Insumos">
                exec upL_InsumosMaterialesCombo #arguments.id_Empresa#
            </cfquery>
        <cfreturn Local.Insumos/>
    </cffunction>

    <cffunction name="obtenerinsumos" access="public" returntype="query">
        <cfargument name="page"           type="string"     required="false">
        <cfargument name="pageSize"       type="string"     required="false">
        <cfargument name="id_familia"     type="string" required="false">
        <cfargument name="id_subfamilia"  type="string" required="false">
        <cfargument name="nb_insumo"      type="string" required="false">

            <cfquery datasource="#variables.cnx#" name="Local.rs">
                exec upL_insumosasignacionconceptosgastos
                    #session.ID_EMPRESA#,
                    #page#,
                    #pageSize#,
                    <cfif isDefined("Arguments.id_familia")  AND arguments.id_familia NEQ ''>#Arguments.id_familia#<cfelse>NULL</cfif>,
                    <cfif isDefined("Arguments.id_subfamilia")  AND arguments.id_subfamilia NEQ ''>#Arguments.id_subfamilia#<cfelse>NULL</cfif>,
                    <cfif isDefined("Arguments.nb_insumo")  AND arguments.nb_insumo NEQ ''>'#Arguments.nb_insumo#'<cfelse>NULL</cfif>
            </cfquery>

            <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="getInsumosPorFamilia" access="public" returntype="query">
        <cfargument name="id_FamiliaInsumo"    type="string" required="false" default="NULL">
        <cfargument name="id_SubFamiliaInsumo" type="string" required="false" default="NULL">
            <cfquery datasource="#variables.cnx#" name="Local.rs">
                exec upR_insumosPorFamilia
                    #session.ID_EMPRESA#,
                    #arguments.id_FamiliaInsumo#,
                    #arguments.id_SubFamiliaInsumo#
            </cfquery>

            <cfreturn Local.rs/>
    </cffunction>

    <!--- Juan Beltran
          Fecha: 08/05/2015
          OBTIENE LOS insumos con la combinacion Empresa, Sucursal, FamiliaInsumo
          de la tabla RequisicionesConfiguracionInsumos  --->
    <cffunction name="listarInsumosAutoCompleteByRequisicionesConfiguracionInsumos" access="public" returntype="query">
       <cfargument name="id_Empresa"           type="numeric"      required="true"/>
       <cfargument name="id_Sucusal"           type="numeric"      required="false"/>
       <cfargument name="id_TipoRequisicion"   type="numeric"      required="false"/>

        <cfquery name="Local.InsumosAutoCompleteByRequisicionesConfiguracionInsumos" datasource="#variables.cnx#" >
            exec upL_InsumosAutoCompleteByRequisicionesConfiguracionInsumos #session.ID_EMPRESA#,
            <cfif isDefined("arguments.id_TipoRequisicion")>#arguments.id_TipoRequisicion#<cfelse>NULL</cfif>,
            #SESSION.ID_SUCURSAL#
        </cfquery>
        <cfreturn Local.InsumosAutoCompleteByRequisicionesConfiguracionInsumos/>
    </cffunction>

    <cffunction name="upR_InsumosMM" access="public" returntype="string">
        <cfargument name="id_Empresa"             type="string"     required="true">
        <cfargument name="id_Sucursal"            type="string"     required="true">
        <cfargument name="id_Almacen"             type="string"     required="true">
        <cfargument name="id_Insumo"              type="string"     required="true">
        <cfargument name="nu_Cantidad"            type="string"     required="true">

            <cfquery datasource="#variables.cnx#" name="Local.rs">
                exec upR_InsumosMM
                    #Arguments.id_Empresa#,
                    #Arguments.id_Sucursal#,
                    #Arguments.id_Almacen#,
                    #Arguments.id_Insumo#,
                    #Arguments.nu_Cantidad#
            </cfquery>

            <cfreturn Local.rs.sn_PasoRango/>
    </cffunction>

    <cffunction name="getInsumosMultiEmpresa" access="public" returntype="query">
        <cfargument name="id_Empresa"          type="string"    required="true" default="">
        <cfargument name="id_FamiliaInsumo"    type="string"    required="false" default="">
        <cfargument name="id_SubFamiliaInsumo" type="string"    required="false" default="">

            <cfstoredproc procedure="upL_FiltrarInsumos" datasource="#variables.cnx#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"          value="#arguments.id_Empresa#"          null="#iif(isNumeric(arguments.id_Empresa),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"    value="#arguments.id_FamiliaInsumo#"    null="#iif(isNumeric(arguments.id_FamiliaInsumo),false,true)#">
                <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo" value="#arguments.id_SubFamiliaInsumo#" null="#iif(isNumeric(arguments.id_SubFamiliaInsumo),false,true)#">
                <cfprocresult name="Local.rs" resultset="1">
            </cfstoredproc>
            <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="catalogoInsumo" access="public" returntype="query">

        <cfstoredproc procedure="upL_CatalogoInsumos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"               value="#arguments.id_Empresa#"            null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"                value="#arguments.id_Insumo#"             null="#iif(isnumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Insumo"                value="#arguments.nb_Insumo#"             null="#iif(len(arguments.nb_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_ActivoFijo"            value="#arguments.sn_ActivoFijo#"         null="#iif(isnumeric(arguments.sn_ActivoFijo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamilia"            value="#arguments.id_SubFamilia#"         null="#iif(isNumeric(arguments.id_SubFamilia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Relevante"             value="#arguments.sn_Relevante#"          null="#iif(isNumeric(arguments.sn_Relevante),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_InsumoActivo"          value="#arguments.sn_InsumoActivo#"       null="#iif(isNumeric(arguments.sn_InsumoActivo),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>
        <cfreturn Local.rs/>
    </cffunction>

    <!--- Jesus Reyes--->
    <cffunction name="listarInsumosAutoCompleteSolicitudCompraAlmacen" access="public" returntype="query">
       <cfargument name="id_Empresa" type="string" required="false" default=""/>
       <cfargument name="id_Sucursal" type="string" required="false" default=""/>
       <cfargument name="id_Almacen" type="string" required="false" default=""/>
       <cfargument name="id_insumo"  type="string"   required="false"/>
       <cfargument name="nb_insumo"  type="string"   required="false"/>
       <cfargument name="page"       type="string"   required="false"/>
       <cfargument name="pageSize"   type="string"   required="false"/>

        <cfquery name="Local.rs" datasource="#variables.cnx#" >
            exec upL_InsumosAutoCompleteSolicitudCompraAlmacen
            #arguments.id_Empresa#,
            #arguments.id_Sucursal#,
            #arguments.id_Almacen#,
            <cfif isDefined("Arguments.id_insumo")>'#Arguments.id_insumo#'<cfelse>NULL</cfif>,
             <cfif isDefined("Arguments.nb_insumo")>'#Arguments.nb_insumo#'<cfelse>NULL</cfif>,
            #arguments.page#,
            #arguments.pageSize#
        </cfquery>
        <cfreturn Local.rs/>
    </cffunction>



    <cffunction name="ListarInsumosInactivos" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string"  required="false"/>
        <cfargument name="id_Sucursal"  type="string"  required="false"/>
        <cfargument name="id_Almacen"   type="string"  required="false"/>


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_ListarInsumosInactivos

            <cfif isDefined("Arguments.id_Empresa")>'#Arguments.id_Empresa#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Sucursal")>'#Arguments.id_Sucursal#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Almacen")>'#Arguments.id_Almacen#'<cfelse>NULL</cfif>

        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarInsumosActivos" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string"  required="false"/>
        <cfargument name="id_Sucursal"  type="string"  required="false"/>
        <cfargument name="id_Almacen"   type="string"  required="false"/>

        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_ListarInsumosActivos

            <cfif isDefined("Arguments.id_Empresa")>'#Arguments.id_Empresa#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Sucursal")>'#Arguments.id_Sucursal#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Almacen")>'#Arguments.id_Almacen#'<cfelse>NULL</cfif>

        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarDatosInsumosInactivos" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string"  required="false"/>
        <cfargument name="id_Sucursal"  type="string"  required="false"/>
        <cfargument name="id_Almacen"   type="string"  required="false"/>
        <cfargument name="id_Insumo"    type="string"  required="false"/>


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_ListarDatosInsumosInactivos

            <cfif isDefined("Arguments.id_Empresa")>'#Arguments.id_Empresa#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Sucursal")>'#Arguments.id_Sucursal#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Almacen")>'#Arguments.id_Almacen#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Insumo")>'#Arguments.id_Insumo#'<cfelse>NULL</cfif>

        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarDatosInsumosActivos" access="public" returntype="query">
        <cfargument name="id_Empresa"   type="string"  required="false"/>
        <cfargument name="id_Sucursal"  type="string"  required="false"/>
        <cfargument name="id_Almacen"   type="string"  required="false"/>
        <cfargument name="id_Insumo"    type="string"  required="false"/>


        <cfquery datasource="#variables.cnx#" name="Local.rs">
            exec upL_ListarDatosInsumosActivos

            <cfif isDefined("Arguments.id_Empresa")>'#Arguments.id_Empresa#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Sucursal")>'#Arguments.id_Sucursal#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Almacen")>'#Arguments.id_Almacen#'<cfelse>NULL</cfif>,
            <cfif isDefined("Arguments.id_Insumo")>'#Arguments.id_Insumo#'<cfelse>NULL</cfif>

        </cfquery>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="InsumosServicios" access="public" returntype="query">
        <cfargument name="id_Empresa" type="string" required="true">
        <cfargument name="id_Proveedor" type="string" required="false"/>

        <cfstoredproc procedure="upL_InsumosServicios" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"   value="#arguments.id_Empresa#"   null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Proveedor" value="#arguments.id_Proveedor#" null="#iif(isnumeric(arguments.id_Proveedor),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarExistGralbyInsumos" access="public" returntype="query">
        <cfargument name="id_Insumo" type="string" required="true">

        <cfstoredproc procedure="upL_InsumosExistenciasGral" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"   value="#arguments.id_Insumo#"   null="#iif(isnumeric(arguments.id_Insumo),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="ListarExistGralbyFamilia" access="public" returntype="query">
        <cfargument name="id_FamiliaInsumo"     type="string" required="true"/>
        <cfargument name="id_SubFamiliaInsumo"  type="string" required="false"/>

        <cfset arguments.id_Insumo = nullValue()>

        <cfstoredproc procedure="upL_InsumosExistenciasGral" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"            value="#arguments.id_Insumo#"            null="#iif(isnumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_FamiliaInsumo"     value="#arguments.id_FamiliaInsumo#"     null="#iif(isnumeric(arguments.id_FamiliaInsumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamiliaInsumo"  value="#arguments.id_SubFamiliaInsumo#"  null="#iif(isnumeric(arguments.id_SubFamiliaInsumo),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

    <cffunction name="obtenerHistorialMovimientos" access="public" returntype="query">
        <cfargument name="id_Empresa"       type="string"  required="false"/>
        <cfargument name="id_Insumo"        type="string"  required="false"/>
        <cfargument name="nb_Insumo"        type="string"  required="false"/>
        <cfargument name="id_SubFamilia"    type="string"  required="false"/>
        <cfargument name="sn_InsumoActivo"  type="string"  required="false"/>
        <cfargument name="sn_Relevante"     type="string"  required="false"/>

        <cfstoredproc procedure="upR_InsumosMovimientos" datasource="#variables.cnx#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Empresa"         value="#arguments.id_Empresa#"       null="#iif(isnumeric(arguments.id_Empresa),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_Insumo"          value="#arguments.id_Insumo#"        null="#iif(isnumeric(arguments.id_Insumo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_VARCHAR" dbvarname="@nb_Insumo"          value="#arguments.nb_Insumo#"        null="#iif(len(trim(arguments.nb_Insumo)),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@id_SubFamilia"      value="#arguments.id_SubFamilia#"    null="#iif(isnumeric(arguments.id_SubFamilia),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_InsumoActivo"    value="#arguments.sn_InsumoActivo#"  null="#iif(isnumeric(arguments.sn_InsumoActivo),false,true)#">
            <cfprocparam type="IN" cfsqltype="CF_SQL_INTEGER" dbvarname="@sn_Relevante"       value="#arguments.sn_Relevante#"     null="#iif(isnumeric(arguments.sn_Relevante),false,true)#">
            <cfprocresult name="Local.rs" resultset="1">
        </cfstoredproc>

        <cfreturn Local.rs/>
    </cffunction>

</cfcomponent>
