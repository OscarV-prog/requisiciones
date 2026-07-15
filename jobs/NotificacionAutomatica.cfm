<cfsetting enablecfoutputonly="true">
<!--- Invoke / job's work --->
<cfinvoke component="#Application.RF.getPath('cfc','Jobs')#"
  method="RecordatorioRequisicion"
  returnvariable="Local.BRO"/>

<cfif Local.BRO.ISOK>
  <cfset local.statusCode = 200 />
  <cfset DATA =   {
    "error": false,
    "message":  Local.BRO.MSG & " #DateFormat(NOW(),'dd-MM-YYYY')#",
    "data": "#DateTimeFormat(NOW(),'dd-MM-YYYY hh:nn:ss')#"
  }/>
<cfelse>
  <cfset local.statusCode = 500 />
  <cfset DATA =   {
    "error": true,
    "message": Local.BRO.MSG,
    "data": "#DateTimeFormat(NOW(),'dd-MM-YYYY hh:nn:ss')#"
  }/>
</cfif>

<!--- Set headers and output --->
<cfheader statuscode="#statusCode#">
<cfheader value="application/json" name="Content-Type">

<cfoutput>#serializeJSON(DATA)#</cfoutput>