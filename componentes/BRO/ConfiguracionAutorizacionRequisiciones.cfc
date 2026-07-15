<cfcomponent>
    <cfprocessingdirective pageencoding="utf-8">
    <cfset variables.RBR = createObject("component","#Application.RF.getPath('rrt','RedBussinesRule')#").init("")>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 22/01/2015
          Guarda la configuracion de autorizacion y notificaciones para la sucursal y departamento especificados --->
    <cffunction name="Configurarant"            access="public" returntype="Any">
        <cfargument name="empleadosAutorizan"    type="array"   required="true"/>

        <!--- Se crea el objeto de acceso al dao, para evitar saturar la memoria durante el loop --->
        <cfset Local.daoConfAut = Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')>
        <cfset Local.daoConfNotif = Application.RF.getPath('dao','ConfiguracionNotificacionesRegistroRequisiciones')>

        <cfset Local.configuracion =structNew() >
        <!--- Empleados que autorizan --->
        <cfloop array="#Arguments.empleadosAutorizan#" index="Local.autoriza">
            <cfset structClear(Local.configuracion)>

            <cfset Local.configuracion.id_Empresa=session.ID_EMPRESA>
            <cfset Local.configuracion.id_Sucursal=Local.autoriza.id_sucursal>
            <cfset Local.configuracion.id_departamento=Local.autoriza.id_departamento>
            <cfset Local.configuracion.id_puesto=Local.autoriza.id_puesto>
            <cfset Local.configuracion.id_empresaEmpleado=Local.autoriza.id_empresaEmpleado>
            <cfset Local.configuracion.id_Empleado=Local.autoriza.id_Empleado>
            <cfset Local.configuracion.nu_rangoInicioImporte=Local.autoriza.nu_rangoInicioImporte>
            <cfset Local.configuracion.nu_rangoFinalImporte=Local.autoriza.nu_rangoFinalImporte>

            <cfinvoke component="#Local.daoConfAut#"
                      method="RSAgregar"
                      argumentcollection="#Local.configuracion#">
        </cfloop>
        <!--- Fin Empleados que autorizan --->
        <cfreturn variables.RBR>
    </cffunction>


     <cffunction name="Configurar"            access="public" returntype="Any">
        <cfargument name="id_configuracionautorizacionrequisicion"   type="numeric" required="true"/>
        <cfargument name="id_tipodivision"   type="string" required="true"/>
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_puesto"         type="string" required="true"/>
        <cfargument name="id_empleado"       type="string" required="true"/>
        <cfargument name="id_Nivel"          type="string" required="false"/>
        <cfargument name="sn_JefeImediato"   type="string" required="false"/>
        <cfargument name="sn_Activo"         type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"   type="string" required="false"/>


        <!--- Revisamos que el registro que se intenta guardar no este repetido --->
        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
            method="CheckRepetidos"
            argumentcollection="#arguments#"
            returnvariable="Local.rs">

        <cfif (arguments.sn_Activo EQ 0) OR (Local.rs.Result EQ 1 AND arguments.sn_Activo EQ 1)>
            <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                    method="Configurar"
                    argumentcollection="#arguments#"
                    returnvariable="RequisEnd">

            <!---/**
                * La informacion que RequisEnd nos regresa es un listado de las Requisiciones
                * estas requisiciones es necesario actualizar sus estatus
                * y continuar con el flujo de estas
                */--->
            <cfif RequisEnd.RecordCount GT 0>
                <cfset AutRequi = structNew()>
                <cfloop query="#RequisEnd#">
                    <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                        method="getById"
                        id_Empresa = "#RequisEnd.id_Empresa#"
                        id_Requisicion = "#RequisEnd.id_Requisicion#"
                        returnvariable="infoRq">

                    <cfset AutRequi.id_Empresa = RequisEnd.id_Empresa>
                    <cfset AutRequi.id_Requisicion = RequisEnd.id_Requisicion>
                    <cfset AutRequi.Identificador = 'Autorizar'>
                    <cfset AutRequi.de_Observaciones = 'Requisicion Autorizada al Eliminar Autorizador pendiente'>
                    <cfset AutRequi.id_usuarioSolicita = infoRq.id_UsuarioSolicita>
                    <cfset AutRequi.id_tipoRequisicion = infoRq.id_TipoRequisicion>
                    <cfset AutRequi.fh_registroRequisicion = infoRq.fh_Expedicion>
                    <cfset AutRequi.nb_empleado = infoRq.nb_empleado>
                    <cfset AutRequi.nb_sucursal = infoRq.nb_Sucursal>
                    <cfset AutRequi.nb_departamento = infoRq.nb_Departamento>
                    <cfset AutRequi.fh_fechaRequerida = nullValue()>
                    <cfset AutRequi.de_tipoRequisicion = infoRq.de_TipoRequisicion>
                    <cfset AutRequi.id_RequisicionUsuarioAutoriza = RequisEnd.id_RequisicionUsuarioAutoriza>
                    <cfset AutRequi.id_SucursalSolicita = infoRq.id_SucursalSolicita>
                    <cfset AutRequi.id_TipoDivision = infoRq.id_TipoDivision>
                    <cfset AutRequi.id_Nivel = RequisEnd.id_Nivel>
                    <cfset AutRequi.nb_RazonSocial = infoRq.nb_RazonSocial>

                    <cfinvoke component="#Application.RF.getPath('bro','AutorizaciondeRequisicion')#"
                        method="EditardesdeDetalleRequisicion"
                        argumentcollection="#AutRequi#">
                </cfloop>
            </cfif>
        </cfif>

        <cfset Variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getConfiguracionPorDepartamento" access="public" returntype="Any">
        <cfargument name="id_sucursal"           type="numeric" required="true"/>
        <cfargument name="id_departamento"       type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="getConfiguracionPorDepartamento"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(Local.rs)>
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="getByEmpleado" access="public" returntype="Any">
        <cfargument name="id_sucursal"  type="numeric" required="true"/>
        <cfargument name="id_empleado"  type="numeric" required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="getByEmpleado"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(Local.rs)>
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="listar" access="public" returntype="Any">
        <cfargument name="id_sucursal"      type="string" required="false">
        <cfargument name="id_puesto"        type="string" required="false">
        <cfargument name="id_empleado"      type="string" required="false">
        <cfargument name="id_tipodivision"  type="string" required="false">

        <cfset Local.args={id_empresa= session.ID_EMPRESA}>
        <cfif Arguments.id_sucursal NEQ ''>
            <cfset Local.args.id_sucursal=Arguments.id_sucursal>
        </cfif>
        <cfif Arguments.id_puesto NEQ '' AND Arguments.id_puesto NEQ '0'>
            <cfset Local.args.id_puesto=Arguments.id_puesto>
        </cfif>
        <cfif Arguments.id_empleado NEQ '' AND Arguments.id_empleado NEQ '0'>
            <cfset Local.args.id_empleado=Arguments.id_empleado>
        </cfif>
        <cfif Arguments.id_tipodivision NEQ ''>
            <cfset Local.args.id_tipodivision=Arguments.id_tipodivision>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="listar"
                      argumentcollection="#Local.args#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(Local.rs)>
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="eliminar" access="public" returntype="Any">
        <cfargument name="id_sucursal"      type="string" required="true">
        <cfargument name="id_puesto"        type="string" required="true">
        <cfargument name="id_empleado"      type="string" required="true">
        <cfargument name="id_tipodivision"  type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                      method="snEmpleadoRequisicionesAutorizar"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_empleado="#Arguments.id_empleado#"
                      id_tipodivision="#Arguments.id_tipodivision#"
                      returnvariable="Local.sn_pendientesPorAut">

        <cfif Local.sn_pendientesPorAut>
            <cfset Variables.RBR.setData({sn_RequsicionPendiente=true})>
            <cfset Variables.RBR.setError("Este empleado tiene requisiciones pendientes de autorizacion.<br>Es necesario cambiar el estado de la requisición o reasignarlas a otro usuario.<br><br>Presione <b>""Aceptar""</b> si desea asignarlas a otro empleado o <b>""Cancelar""</b> para salir.")>
            <cfreturn Variables.RBR>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="eliminar"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#Arguments#">
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 04/03/2015
          Actualiza la informacion del numero de orden --->
    <cffunction name="actualizar"            access="public" returntype="Any">
        <cfargument name="empleadosAutorizan"    type="array"   required="true"/>

        <!--- Se crea el objeto de acceso al dao, para evitar saturar la memoria durante el loop --->
        <cfset Local.daoConfAut = Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')>

        <cfset Local.configuracion =structNew() >
        <!--- Empleados que autorizan --->
        <cfloop array="#Arguments.empleadosAutorizan#" index="Local.autoriza">
            <cfset structClear(Local.configuracion)>
            <cfset Local.configuracion.id_Empresa=Local.autoriza.id_Empresa>
            <cfset Local.configuracion.id_Sucursal=Local.autoriza.id_sucursal>
            <cfset Local.configuracion.id_departamento=Local.autoriza.id_departamento>
            <cfset Local.configuracion.id_puesto=Local.autoriza.id_puesto>
            <cfset Local.configuracion.id_empresaEmpleado=Local.autoriza.id_empresaEmpleado>
            <cfset Local.configuracion.id_Empleado=Local.autoriza.id_Empleado>
            <cfset Local.configuracion.nu_rangoInicioImporte=Local.autoriza.nu_rangoInicioImporte>
            <cfset Local.configuracion.nu_rangoFinalImporte=Local.autoriza.nu_rangoFinalImporte>

            <cfinvoke component="#Local.daoConfAut#"
                      method="RSEditar"
                      argumentcollection="#Local.configuracion#">
        </cfloop>
        <!--- Fin Empleados que autorizan --->
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 06/03/2015
          Obtiene los empleados configurados para autorizar en el departamento especificado --->
    <cffunction name="getEmpleadosByDepartamento" access="public" returntype="Any">
        <cfargument name="id_departamento"  type="string"   required="true"/>
        <cfargument name="id_empleado"      type="string"   required="true"/>

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="getEmpleadosByDepartamento"
                      id_empresa="#session.ID_EMPRESA#"
                      id_departamento="#arguments.id_departamento#"
                      id_empleado="#Arguments.id_empleado#"
                      returnvariable="Local.rs">

        <cfset Variables.RBR.setQuery(Local.rs)>
        <!--- Fin empleados a los que se notifica --->
        <cfreturn variables.RBR>
    </cffunction>

    <!--- Autor: REY DAVID DOMINGUEZ
          Fecha: 06/03/2015
          Reasigna las requisiciones pendientes por autorizar al nuevo empleado y
          Elimina el empleado de la configuracion de autorizacion de requisiciones --->
    <cffunction name="borrarEmpleado_reasignarRequisiciones" access="public" returntype="Any">
        <cfargument name="id_sucursal"              type="string" required="true">
        <cfargument name="id_puesto"                type="string" required="true">
        <cfargument name="id_empresaEmpleado"       type="string" required="true">
        <cfargument name="id_empleado"              type="string" required="true">
        <cfargument name="id_departamento"          type="string" required="true">
        <cfargument name="id_empresaEmpleadoNuevo"  type="string" required="true">
        <cfargument name="id_empleadoNuevo"         type="string" required="true">

        <cfinvoke component="#Application.RF.getPath('dao','Empleados')#"
                      method="getEmpleadoByID"
                      id_empresa="#Arguments.id_empresaEmpleadoNuevo#"
                      id_empleado="#Arguments.id_empleadoNuevo#"
                      returnvariable="Local.empleado">

        <!--- Si el empleado no tiene correo, no se crea ni se envia el correo --->
        <cfif Local.empleado.de_email NEQ ''>
            <cfset Local.destinatarios=[Local.empleado.de_email]>

            <cfinvoke component="#Application.RF.getPath('dao','Requisiciones')#"
                          method="getRequisicionAutorizarByEmpleado"
                          id_Empresa="#session.ID_EMPRESA#"
                          id_empleado="#Arguments.id_empleado#"
                          id_Departamento="#Arguments.id_departamento#"
                          returnvariable="Local.requisiciones">

            <!--- Obtener el nombre del empleado al que pertenecian las requisiciones  --->
            <cfset Local.nb_empleadoOld=Local.requisiciones.nb_empleadoOld>
            <cfset Local.requisicionesArray=arrayNew(1)>
            <cfloop query="Local.requisiciones">
                <cfinvoke component="#Application.RF.getPath('dao','RequisicionesDetalle')#"
                          method="listado"
                          id_Empresa="#Local.requisiciones.id_empresa#"
                          id_requisicion="#Local.requisiciones.id_requisicion#"
                          returnvariable="Local.detalle">

                <cfset arrayAppend(Local.requisicionesArray, {
                    id_requisicion= Local.requisiciones.id_requisicion,
                    id_TipoRequisicion= Local.requisiciones.id_TipoRequisicion,
                    nb_proveedor= Local.requisiciones.nb_proveedor,
                    nb_empleado=Local.requisiciones.nb_empleado,
                    nb_sucursal= Local.requisiciones.nb_sucursal,
                    nb_departamento= Local.requisiciones.nb_departamento,
                    de_clasificacion= Local.requisiciones.de_clasificacion,
                    fh_expedicion= Local.requisiciones.fh_expedicion,
                    im_precioTotal= Local.requisiciones.im_precioTotal,
                    detalle= Local.detalle
                })>
            </cfloop>
        </cfif>

        <cfinvoke component="#Application.RF.getPath('dao','RequisicionesUsuariosAutorizan')#"
                      method="cambiarUsuario"
                      id_Empresa="#session.ID_EMPRESA#"
                      id_empresaEmpleado="#Arguments.id_empresaEmpleado#"
                      id_empleado="#Arguments.id_empleado#"
                      id_empresaEmpleadoNuevo="#Arguments.id_empresaEmpleadoNuevo#"
                      id_empleadoNuevo="#Arguments.id_empleadoNuevo#">

        <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="eliminar"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#Arguments#">

        <!--- si no hay destinatarios no se crea ni se manda el correo --->
        <cfif isDefined("Local.destinatarios")>
            <cfset crearReporte(Local.nb_empleadoOld,Local.requisicionesArray)>

            <cfset Local.imagenes=[
                        {
                            dir="#session.AR_IMAGENREPORTE#",
                            disposicion='inline',
                            name="logo"
                        },
                        {
                            dir="assets/img/greenLeaf.jpg",
                            disposicion='inline',
                            name="footer"
                        }
                    ]>

            <cfset Local.archivos=[{
                        dir="Reportes/requisicionReasignada_#Local.nb_empleadoOld#.pdf",
                        name='reporte',
                        sn_deleteFile= "yes"
                    }]>

            <cfset Local.parametros={
                nb_empleadoOld= Local.nb_empleadoOld,
                requisiciones= Local.requisicionesArray
            }>

            <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
                              method="sendMail"
                              destinatarios="#Local.destinatarios#"
                              asunto="Reasignación de requisiciones pendientes por autorizar de #Local.nb_empleadoOld#"
                              imagenes="#Local.imagenes#"
                              archivos="#Local.archivos#"
                              parametros="#Local.parametros#"
                              sn_plantilla="YES"
                              dir_plantilla="templates/correos/AlmacenesEInventarios/templateMailRequisicionReasignacion.html"
                              returnvariable="Local.rbr"/>
        </cfif>

        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="crearReporte" access="public" returntype="any">
        <cfargument name="nb_empleadoOld" type="string" required="true">
        <cfargument name="requisiciones"  type="array"  required="true">

        <!--- <cfdump var="#serializeJSON(arguments)#"><cfabort /> --->
        <cfsavecontent variable="reporteAutorizacionRequisicionReasignada">
            <cfinclude template="../../templates/reportes/AlmacenesEInventarios/reporteRequisicionReasignacion.html">
        </cfsavecontent>

        <!--- Se hace el invoke del metodo que genera el PDF --->
        <cfinvoke component="#Application.RF.getPath('cfc','javaLoader')#"
                  method="generatePDFNoDownload"
                  content="#reporteAutorizacionRequisicionReasignada#"
                  pdf="requisicionReasignada_#Arguments.nb_empleadoOld#"
                  debug="no"
                  path="#expandPath('/root/Reportes/')#">

        <cfreturn Variables.RBR>
    </cffunction>

    <!--- Omar Ibarra, 01/06/2017, Obtener nivel por empresa, sucursal y tipo de division--->
    <cffunction name="ObtenerNivelConfAutorizacionRequisicion" access="public" returntype="Any">
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_tipoDivision"   type="string" required="false"/>

            <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                      method="ObtenerNivelConfAutorizacionRequisicion"
                      id_Empresa="#session.ID_EMPRESA#"
                      argumentcollection="#arguments#"
                      returnvariable="Local.rs">
        <cfset Variables.RBR.setQuery(Local.rs)>
        <cfreturn variables.RBR>
    </cffunction>

    <cffunction name="Editar" access="public" returntype="Any">
        <cfargument name="id_configuracionautorizacionrequisicion"   type="numeric" required="true"/>
        <cfargument name="id_tipodivision"   type="string" required="true"/>
        <cfargument name="id_sucursal"       type="string" required="false"/>
        <cfargument name="id_puesto"         type="string" required="true"/>
        <cfargument name="id_empleado"       type="string" required="true"/>
        <cfargument name="id_Nivel"          type="string" required="false"/>
        <cfargument name="sn_JefeImediato"   type="string" required="false"/>
        <cfargument name="sn_Activo"         type="string" required="true"/>
        <cfargument name="sn_EnvioCorreo"    type="string" required="false"/>

            <cfinvoke component="#Application.RF.getPath('dao','ConfiguracionAutorizacionRequisiciones')#"
                method="Editar"
                argumentcollection="#arguments#">
            <cfset variables.RBR.setMessage("Operaci&oacute;n exitosa.")>   
          <cfreturn variables.RBR>
      </cffunction>
</cfcomponent>
