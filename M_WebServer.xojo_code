#tag Module
Protected Module M_WebServer
	#tag DelegateDeclaration, Flags = &h1
		Protected Delegate Function RouteHandlingDelegate(request As WebServerRequest_MTC) As WebServerResponse_MTC
	#tag EndDelegateDeclaration


	#tag Enum, Name = WebStatusCodes_MTC, Type = Integer, Flags = &h0
		Unknown = 0
		  OK = 200
		  Created = 201
		  Accepted = 202
		  NonAuthoritativeInformation = 203
		  NoContent = 204
		  BadRequest = 400
		  Unauthorized = 401
		  PaymentRequired = 402
		  AccessDenied = 403
		ResourceNotFound = 404
	#tag EndEnum


End Module
#tag EndModule
