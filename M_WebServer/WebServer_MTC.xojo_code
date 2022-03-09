#tag Class
Class WebServer_MTC
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  var socket as new M_WebServer.WebServerSocket
		  socket.Server = self
		  RaiseEvent ConfigureSocket( socket )
		  return socket
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(port As Integer = kStandardPort)
		  self.Port = port
		  
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 436F6E6669677572652074686520736F636B6574206265666F72652069742773206163746976617465642E0A0A466F722073656375726520736F636B6574732C207365742053534C456E61626C65642C2053534C436F6E6E656374696F6E547970652C20616E642074686520436572746966696361746546696C652C206174206C656173742E
		Event ConfigureSocket(socket As M_WebServer.WebServerSocket)
	#tag EndHook


	#tag Property, Flags = &h0
		Routes() As WebServerRoute_MTC
	#tag EndProperty


	#tag Constant, Name = kMethodDelete, Type = String, Dynamic = False, Default = \"DELETE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMethodFetch, Type = String, Dynamic = False, Default = \"FETCH", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMethodGet, Type = String, Dynamic = False, Default = \"GET", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMethodHead, Type = String, Dynamic = False, Default = \"HEAD", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMethodPost, Type = String, Dynamic = False, Default = \"POST", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kMethodPut, Type = String, Dynamic = False, Default = \"PUT", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kSecurePort, Type = Double, Dynamic = False, Default = \"443", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kStandardPort, Type = Double, Dynamic = False, Default = \"80", Scope = Public
	#tag EndConstant


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
			InitialValue=""
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
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
