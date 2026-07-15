<cfcomponent>
    <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

    <cffunction name="listar" access="remote" returnformat="JSON">
    <cfargument name="id_TipoRequisicion"       type="string" required="false"/>
    <cfargument name="fh_Inicio"                type="string" required="true"/>
    <cfargument name="fh_Fin"                   type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="listar"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="listarDetalle" access="remote" returnformat="JSON">
    <cfargument name="id_TipoRequisicion"       type="string" required="false"/>
    <cfargument name="fh_Inicio"                type="string" required="true"/>
    <cfargument name="fh_Fin"                   type="string" required="true"/>

        <cftransaction>
            <cftry>
                <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="listarDetalle"
                          argumentcollection="#arguments#"
                          returnvariable="Local.BRO"/>              

                <cfif Local.BRO.hasError()>
                        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                        <cfset variables.ctrl.rollback()>
                    <cfelse>
                        <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                        <cfset variables.ctrl.setQuery(Local.BRO.getQuery())>
                </cfif>

                <cfcatch type="any">
                    <cfset variables.ctrl.setCatch(cfcatch)>
                    <cfset variables.ctrl.rollback()>
                </cfcatch>
            </cftry>            
        </cftransaction>

        <cfreturn variables.ctrl.toStruct()/>
    </cffunction>


    <cffunction name="generarPDF" access="remote" returnformat="JSON">
        <cfargument name='fh_Inicio'        type='string'  required='true'>
        <cfargument name='fh_Fin'           type='string'  required='true'>
        <cfargument name='Requisiciones'    type='array'  required='true'>
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>
            

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="generarPDF"
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
        </cftransaction>

            <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="generarExcel" access="remote" returnformat="JSON">
        <cfargument name='fh_Inicio'            type='string'  required='true'>
        <cfargument name='fh_Fin'               type='string'  required='true'>
        <cfargument name='id_TipoRequisicion'   type='string'  required='false'>
        <cfargument name='Requisiciones'        type='array'  required='false'>
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>

            
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="generarExcel"
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
        </cftransaction>

            <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>
    
    <cffunction name="generarPDFDetalle" access="remote" returnformat="JSON">
        <cfargument name='fh_Inicio'        type='string'  required='true'>
        <cfargument name='fh_Fin'           type='string'  required='true'>
        <cfargument name='Requisiciones'    type='array'  required='true'>
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>
            

        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="generarPDFDetalle"
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
        </cftransaction>

            <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <cffunction name="generarExcelDetalle" access="remote" returnformat="JSON">
        <cfargument name='fh_Inicio'            type='string'  required='true'>
        <cfargument name='fh_Fin'               type='string'  required='true'>
        <cfargument name='id_TipoRequisicion'   type='string'  required='false'>
        <cfargument name='Requisiciones'        type='array'  required='false'>
        <cfargument name='tiporequisicion'  type='string'  required='false'>
        <cfargument name='importeTotal'  type='string'  required='false'>

            
        <cftransaction>
            <cftry>
               <cfinvoke component="#Application.RF.getPath('bro','ReporteOrdenesdeCompraporTipodeRequisicion')#"
                          method="generarExcelDetalle"
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
        </cftransaction>

            <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>
</cfcomponent>