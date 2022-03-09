#tag Class
Class WebServerRoute_MTC
	#tag Method, Flags = &h0
		Sub Constructor(urlPattern As String, method As String, handler As RouteHandlingDelegate, routeTag As Variant = Nil)
		  //
		  // urlPattern will be in the form
		  //
		  //  /api/v1/path/:id/action/:id2
		  //
		  
		  if not urlPattern.BeginsWith( "/" ) then
		    urlPattern = "/" + urlPattern
		  end if
		  
		  var parts() as string = urlPattern.Split( "/" )
		  if parts( parts.LastIndex ) = "" then
		    call parts.Pop
		  end if
		  
		  //
		  // Get the placeholders
		  //
		  for i as integer = 0 to parts.LastIndex
		    var item as string = parts( i )
		    
		    if item.BeginsWith( ":" ) then
		      item = item.Middle( 1 )
		      if PlaceHolders.IndexOf( item ) <> -1 then
		        raise new InvalidArgumentException
		      end if
		      
		      PlaceHolders.Add item
		      
		      item = "\E([^/]+)\Q"
		      parts( i ) = item
		    end if
		  next
		  
		  //
		  // Convert to a regex pattern
		  //
		  var rxPattern as string = "^\Q" + String.FromArray( parts, "/" ) + "\E/?$"
		  Matcher = new RegEx
		  Matcher.SearchPattern = rxPattern
		  
		  self.UrlPattern = urlPattern
		  self.Method = method
		  mHandler = handler
		  mRouteTag = routeTag
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 49662074686520676976656E2075726C2070617468206D6174636865732C20612044696374696F6E6172792069732072657475726E656420776974682076616C7565732E
		Function Match(urlPath As String, method As String) As WebServerRequest_MTC
		  if method <> self.Method then
		    return nil
		  end if
		  
		  if not urlPath.BeginsWith( "/" ) then
		    urlPath = "/" + urlPath
		  end if
		  
		  var match as RegExMatch = Matcher.Search( urlPath )
		  
		  if match is nil then
		    return nil
		  end if
		  
		  var params as new Dictionary
		  
		  for i as integer = 0 to PlaceHolders.LastIndex
		    var key as string = PlaceHolders( i )
		    var groupIndex as integer = i + 1
		    var value as string = match.SubExpressionString( groupIndex )
		    
		    params.Value( key ) = value
		  next
		  
		  var request as new WebServerRequest_MTC
		  request.Method = method
		  request.Parameters = params
		  request.RouteTag = self.RouteTag
		  request.URLPath = urlPath
		  
		  return request
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mHandler
			End Get
		#tag EndGetter
		Handler As M_WebServer.RouteHandlingDelegate
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Matcher As RegEx
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Method As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHandler As M_WebServer.RouteHandlingDelegate
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRouteTag As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PlaceHolders() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mRouteTag
			End Get
		#tag EndGetter
		RouteTag As Variant
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private UrlPattern As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
