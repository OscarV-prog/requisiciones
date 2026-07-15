<cfcomponent>
  <cfset Variables.ctrl=createObject("component","#Application.RF.getPath('rrt','RedResult')#").init("")>

  <cffunction name="GenerarTimbresH2H" access="remote" returnformat="JSON">
      <cftransaction>
          <cftry>
            <!--- Variables para los resultados --->
            <cfset Local.BRO_Pagos = {} />
            <cfset Local.BRO_Facturacion = {} />
            <cfset Local.Messages = [] />
            <cfset Local.Errors = [] />

            <!--- Ejecuta el primer método --->
            <cfinvoke
                component="#Application.RF.getPath('bro','PagosReferenciados')#"
                method="GenerarTimbresH2H"
                argumentcollection="#arguments#"
                returnvariable="Local.BRO_Pagos" />

            <!--- Procesa el resultado del primer método --->
            <cfif Local.BRO_Pagos.hasError()>
                <cfset ArrayAppend(Local.Errors, "Pagos: " & Local.BRO_Pagos.getMessage()) />
            <cfelse>
                <cfset ArrayAppend(Local.Messages, "Pagos: " & Local.BRO_Pagos.getMessage()) />
            </cfif>

            <!--- Ejecuta el segundo método --->
            <cfinvoke
                component="#Application.RF.getPath('bro','documentosclientes')#"
                method="GenerarTimbres_FacturacionAutomatica_Pemex"
                returnvariable="Local.BRO_Facturacion" />

            <!--- Procesa el resultado del segundo método --->
            <cfif Local.BRO_Facturacion.hasError()>
                <cfset ArrayAppend(Local.Errors, "Facturación: " & Local.BRO_Facturacion.getMessage()) />
            <cfelse>
                <cfset ArrayAppend(Local.Messages, "Facturación: " & Local.BRO_Facturacion.getMessage()) />
            </cfif>

            <!--- Respuesta final dependiendo de los resultados --->
            <cfif ArrayLen(Local.Errors) GT 0>
                <cfset Variables.ctrl.setError( ArrayToList(Local.Errors, ", ") ) />
            <cfelse>
                <cfset Variables.ctrl.setMessage( ArrayToList(Local.Messages, ", ") ) />
            </cfif>
          <cfcatch type="any">
            <cfset Variables.ctrl.setCatch(cfcatch) />
          </cfcatch>
        </cftry>
      </cftransaction>

      <cfreturn Variables.ctrl.toStruct() />
  </cffunction>


  <!--- Jesus Reyes --->
  <cffunction name="ObtenerTimbres" access="remote" returnformat="JSON">
    <cftry>
      <cfinvoke component="#Application.RF.getPath('bro','ComprobacionTimbresCorporativo')#"
        method="ObtenerTimbres"
        argumentcollection="#arguments#"
        returnvariable="Local.BRO"/>

      <cfif Local.BRO.hasError()>
          <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
        <cfelse>
          <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
          <cfset variables.ctrl.setJson(Local.BRO.getData())>
      </cfif>

      <cfcatch type="any">
        <cfset variables.ctrl.setCatch(cfcatch)>
      </cfcatch>
    </cftry>

    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Jesus Reyes --->
  <cffunction name="revisionTimbres" access="remote" returnformat="JSON">
    <cftry>
      <cfinvoke component="#Application.RF.getPath('bro','ComprobacionTimbresCorporativo')#"
        method="revisionTimbres"
        argumentcollection="#arguments#"
        returnvariable="Local.BRO"/>

      <cfif Local.BRO.hasError()>
          <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
        <cfelse>
          <cfset Variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
      </cfif>

      <cfcatch type="any">
        <cfset variables.ctrl.setCatch(cfcatch)>
      </cfcatch>
    </cftry>

    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Jose Miguel ? --->
    <cffunction name="CancelarTimbradoRemision" access="remote" returnformat="JSON">
        <cftry>
      <cfinvoke component="#Application.RF.getPath('bro','Remisiones')#"
        method="CancelarTimbradoRemision"
        argumentcollection="#arguments#"
        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset Variables.ctrl.setMessage("Operación exitosa")>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

  <!--- Jose Miguel --->
    <cffunction name="ConsultarCancelacionesEnProceso" access="remote" returnformat="JSON">
        <cftry>
      <cfinvoke component="#Application.RF.getPath('bro','Facturacion')#"
        method="ConsultarCancelacionesEnProceso"
        argumentcollection="#arguments#"
        returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
            <cfelse>
                <cfset Variables.ctrl.setMessage("Operación exitosa")>
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
        <cfreturn Variables.ctrl.toStruct()/>
    </cffunction>

    <!--- Juan Beltran --->
    <!--- envia Correo a los Almacenistas si tienen Facturas de compra de combustibles por registrar --->
  <cffunction name="CorreoPorFacturasDeCompraSinRegistrar" access="remote" returnformat="JSON">
        <cftry>
           <cfinvoke component="#Application.RF.getPath('bro','FacturasDeCompraSinRegistrar')#"
                      method="EnviarCorreo"
                      returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
                    <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                    <cfset variables.ctrl.rollback()>
                <cfelse>
                    <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                    <!--- <cfset Variables.ctrl.setJson(Local.BRO.getData())> --->
            </cfif>

            <cfcatch type="any">
                <cfset Variables.ctrl.setCatch(cfcatch)>
                <cfset variables.ctrl.rollback()>
            </cfcatch>
        </cftry>

        <cfreturn Variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Omar Ibarra R. --->
  <!--- Envío de correo con clientes pendientes de facturar(vale de retiro) y cuentan con saldo vencido --->
  <cffunction name="ClientesVencidosValesRetiro" access="remote" returnformat="JSON">
    <cftry>
        <cfinvoke component="#Application.RF.getPath('bro','OrdenesDeSuministro')#"
          method="ClientesVencidosValesRetiro"
          returnvariable="Local.BRO"/>

        <cfif Local.BRO.hasError()>
          <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
          <cfset variables.ctrl.rollback()>
        <cfelse>
          <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
        </cfif>

        <cfcatch type="any">
          <cfset Variables.ctrl.setCatch(cfcatch)>
          <cfset variables.ctrl.rollback()>
        </cfcatch>
    </cftry>
    <cfreturn Variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Juan Beltran --->
  <!--- envia Correo a los Almacenistas si tienen Facturas de compra de combustibles por registrar --->
  <cffunction name="CorreoConfiguracionFleteNoValido" access="remote" returnformat="JSON">
      <cftry>
         <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionFletesNoValida')#"
                    method="EnviarCorreo"
                    returnvariable="Local.BRO"/>

          <cfif Local.BRO.hasError()>
                  <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
                  <cfset variables.ctrl.rollback()>
              <cfelse>
                  <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
                  <!--- <cfset Variables.ctrl.setJson(Local.BRO.getData())> --->
          </cfif>

          <cfcatch type="any">
              <cfset Variables.ctrl.setCatch(cfcatch)>
              <cfset variables.ctrl.rollback()>
          </cfcatch>
      </cftry>

      <cfreturn Variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Adrian Garcia Silva 10/01/2025 --->
  <!--- Recordatorio al requisitante de que su requisicion ya puede ser entregada --->
  <cffunction name="RecordatorioRequisicion" access="public" returntype="Any">
    <cftransaction>
        <cftry>
            <!--- facturas filiales de ventas comercializacion --->
            <cfinvoke component="#Application.RF.getPath('bro','DetalleRequisicionConsultaAlmacen')#"
              method="RecordatorioEntregaRequisicion"
              returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
              <cfset local.ErrorMessage = 'Error'>
              <cfset Variables.ctrl.setError(local.ErrorMessage)>
            <cfelse>
              <cfset Variables.ctrl.setMessage("Operación exitosa")>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
    </cftransaction>
    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <!--- Rodolfo Bustamante Osuna 10/10/2025 --->
  <!--- Recordatorio al encargado de actualizar los registros del catalogo INPC --->
<cffunction name="RecordatorioActualizacionINPC" access="public" returntype="struct" output="false">
    <cfargument name="force" type="boolean" required="false" default="false">
    <cfset var Local = {}>
    <cfset var R = { ISOK=false, MSG="" }>

    <cfscript>
        setLocale("es_MX");
        Local.hoy       = now();
        Local.diaH       = day(Local.hoy);
        Local.mesNombre = lCase( LSDateFormat(Local.hoy, "mmmm") );
        Local.anio      = year(Local.hoy);

        req    = getPageContext().getRequest();

          scheme = trim(req.getHeader("x-forwarded-proto"));
          if (!len(scheme)) scheme = req.getScheme();
          scheme = listFirst(scheme, ",");

          hostHdr = trim(req.getHeader("x-forwarded-host"));
          if (len(hostHdr)) {
            host = listFirst(hostHdr, ",");
          } else {
            port = req.getServerPort();
            host = req.getServerName() & ((port EQ 80 OR port EQ 443) ? "" : ":" & port);
          }

          ctx = req.getContextPath();

          baseUrl = scheme & "://" & host & ctx;

          Local.urlSIPP = baseUrl & "/index.cfm" & "##/INPC";
    </cfscript>

           <cfinvoke component="#Application.RF.getPath('dao','INPC')#"
          method="getDestinatariosINPC"
          returnvariable="Local.Movimientos">

<cfscript>
dao  = createObject("component", Application.RF.getPath("dao","INPC"));
resp = dao.getDestinatariosINPC();

if (isStruct(resp) && structKeyExists(resp, "List") && isQuery(resp["List"])) {
    q = resp["List"];
} else {
    writeDump(var=resp, label="Respuesta del DAO (no encontré 'List')"); abort;
}

local.dia    = "";
local.emails = [];

for (i = 1; i <= q.recordCount; i++) {
    nb  = q.nb_parametro[i];
    val = toString(q.de_valor[i]);

    if (nb == "fhNotificacionINPC") {
        local.dia = trim(val);

    } else if (nb == "de_EmailsNotificacionINPC") {
        val = replace(val, chr(13) & chr(10), ",", "all");

        tmp = listToArray(val, ",;");

        for (e in tmp) {
            e = trim(e);
            if (len(e)) arrayAppend(local.emails, e);
        }
    }
}

</cfscript>
    <cfif NOT arguments.force AND val(Local.diaH) NEQ val(local.dia)>
        <cfset R.ISOK = true>
        <cfset R.MSG  = "No es día #local.dia#; no se envía notificación de INPC.">
        <cfreturn R>
    </cfif>

    <cfset Local.destinatarios = local.emails>

    <cfif structKeyExists(url, "testEmail") AND len(trim(url.testEmail))>
        <cfset Local.destinatarios = [ trim(url.testEmail) ]>
    </cfif>

    <cfset Local.parametros = { nu_Dia=Local.dia, nb_Mes=Local.mesNombre, nu_Anio=Local.anio }>
    <cfset Local.imagenes   = [ { dir="assets/img/greenLeaf.jpg", disposicion="inline", name="footer", isLocal=true } ]>

    <cfinvoke component="#Application.RF.getPath('bro','ConfiguracionCorreo')#"
    method="sendMail"
    destinatarios="#Local.destinatarios#"
    asunto="Actualización mensual de INPC"
    imagenes="#[ { dir='assets/img/greenLeaf.jpg', disposicion='inline', name='footer', isLocal=true } ]#"
    parametros="#{ nu_Dia=Local.dia, nb_Mes=Local.mesNombre, nu_Anio=Local.anio, base_url=Local.urlSIPP }#"
    sn_plantilla="YES"
    dir_plantilla="templates/correos/INPC/templateRecordatorioINPC.html"
    returnvariable="Local.rbr" />

    <cfif isDefined("Local.rbr") AND Local.rbr.hasError()>
        <cfset R.ISOK = false>
        <cfset R.MSG  = "Error al enviar: " & Local.rbr.getMessage()>
    <cfelse>
        <cfset R.ISOK = true>
        <cfset R.MSG  = "Notificación de INPC enviada a: " & ArrayToList(Local.destinatarios)>
    </cfif>

    <cfreturn R>
</cffunction>





  <!--- Victor Martinez 11/07/2025 --->
  <!--- Actualizar a sn_Activo = 0 a los CC que no se han utilizado en alguna requisiciones de obra en proceso --->
  <cffunction name="ActualizarCentroCostoObrasProceso" access="public" returntype="Any">
    <cftransaction>
        <cftry>
            <!--- facturas filiales de ventas comercializacion --->
            <cfinvoke component="#Application.RF.getPath('bro','SeguimientoObrasProceso')#"
              method="ActualizarCentroCostoObrasProceso"
              returnvariable="Local.BRO"/>

            <cfif Local.BRO.hasError()>
              <cfset local.ErrorMessage = 'Error'>
              <cfset Variables.ctrl.setError(local.ErrorMessage)>
            <cfelse>
              <cfset Variables.ctrl.setMessage("Operación exitosa")>
            </cfif>

            <cfcatch type="any">
                <cfset variables.ctrl.setCatch(cfcatch)>
            </cfcatch>
        </cftry>
    </cftransaction>
    <cfreturn variables.ctrl.toStruct()/>
  </cffunction>

  <!--- envia Correo a los responsables de que el cliente tenga litros disponibles en la programacion de autoconsumo --->
  <cffunction name="CorreoLitrosDisponiblesAutoconsumo" access="remote" returnformat="JSON">
    <cftry>
      <cfinvoke component="#Application.RF.getPath('bro','ProgramacionPedidosAutoconsumo')#"
        method="CorreoLitrosDisponiblesAutoconsumo"
        returnvariable="Local.BRO"/>

      <cfif Local.BRO.hasError()>
        <cfset Variables.ctrl.setError(Local.BRO.getMessage())>
        <cfset variables.ctrl.rollback()>
      <cfelse>
        <cfset variables.ctrl.setMessage("Operaci&oacute;n exitosa")>
      </cfif>

      <cfcatch type="any">
        <cfset Variables.ctrl.setCatch(cfcatch)>
        <cfset variables.ctrl.rollback()>
      </cfcatch>
    </cftry>

    <cfreturn Variables.ctrl.toStruct()/>
  </cffunction>

</cfcomponent>
