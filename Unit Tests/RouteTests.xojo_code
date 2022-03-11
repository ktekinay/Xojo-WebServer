#tag Class
Protected Class RouteTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub BasicTest()
		  self.StopTestOnFail = true
		  
		  var urlPattern as string = "1/:2/3/:4/5/"
		  
		  var r as new WebServerRoute_MTC( urlPattern, WebServer_MTC.kMethodGet, nil, "tag" )
		  
		  var url as string = "/1/2/3/4/5"
		  var request as new WebServerRequest_MTC
		  request.Method = WebServer_MTC.kMethodGet
		  request.URLPath = url
		  
		  Assert.IsTrue r.Match( request)
		  
		  var params as Dictionary = request.Parameters
		  Assert.IsTrue params isa object, "Returned a Dictionary"
		  
		  Assert.IsFalse params.HasKey( "1" )
		  Assert.IsTrue params.HasKey( "2" )
		  Assert.IsFalse params.HasKey( "3" )
		  Assert.IsTrue params.HasKey( "4" )
		  Assert.IsFalse params.HasKey( "5" )
		  
		  Assert.AreEqual 2, params.KeyCount, "Dictionary key count"
		  Assert.AreEqual 2, params.Value( "2" ).IntegerValue
		  Assert.AreEqual 4, params.Value( "4" ).IntegerValue
		  
		  Assert.AreEqual url, request.URLPath
		  Assert.AreEqual WebServer_MTC.kMethodGet, request.Method
		  Assert.AreEqual "tag", request.RouteTag.StringValue
		  
		  request.URLPath = "x/y/z"
		  Assert.IsFalse r.Match( request ), "Wrong pattern"
		  
		  request.URLPath = url
		  request.Method = WebServer_MTC.kMethodPost
		  Assert.IsFalse r.Match( request ), "Wrong method"
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
