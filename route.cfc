<cfcomponent>
  <cffunction name="init" access="public" returntype="void">
		<cfargument name="pattern" type="string" required="yes">

    <cfset var param = "" />

    <cfset variables.params = structNew() />
    <cfset variables.pattern = arguments.pattern />

    <cfloop list="#structKeyList(arguments)#" index="param">
      <cfif not listFindNoCase("pattern", param)>
        <cfset structInsert(variables.params, param, arguments[param], true) />
      </cfif>
    </cfloop>
  </cffunction>

  <cffunction name="match" access="public" returntype="boolean">
    <cfargument name="url" type="string" required="yes">

    <cfset var i = 1 />
    <cfset var expected = "" />
    <cfset var found = "" />

    <cfif listLen(variables.pattern, '/') NEQ listLen(arguments.url, '/')>
      <cfreturn false />
    </cfif>

    <cfloop list="#variables.pattern#" index="expected" delimiters="/">
      <cfset found = listGetAt(url, i, '/') /> 

      <cfif found NEQ expected>
        <cfif find(":", expected) EQ 1>
          <cfset variables.params[right(expected, len(expected) - 1)] = found />
        <cfelse>
          <cfreturn false />
        </cfif>
      </cfif>

      <cfset i = i + 1 />
    </cfloop>

    <cfreturn structKeyExists(params, 'controller') AND structKeyExists(params, 'action') />
  </cffunction>

  <cffunction name="getParams" access="public" returntype="struct">
    <cfreturn variables.params />
  </cffunction>
</cfcomponent>
