#tag Class
Protected Class ServerTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AddRouteTest()
		  var server as new WebServer_MTC
		  
		  server.Routes.Add new WebServerRoute_MTC( "a/:b/c", WebServer_MTC.kMethodGet, nil, nil )
		  Assert.Pass
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateServerTest()
		  var s as new WebServer_MTC
		  Assert.IsTrue s isa object
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimpleRequestTest()
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kPort, Type = Double, Dynamic = False, Default = \"8082", Scope = Private
	#tag EndConstant


End Class
#tag EndClass
