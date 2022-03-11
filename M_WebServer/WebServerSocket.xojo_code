#tag Class
Protected Class WebServerSocket
Inherits SSLSocket
	#tag Event
		Sub Connected()
		  ProcessTimer = new Timer
		  ProcessTimer.RunMode = Timer.RunModes.Off
		  ProcessTimer.Period = 10
		  
		  AddHandler ProcessTimer.Action, WeakAddressOf ProcessTimer_Action
		  
		  Request = new WebServerRequest_MTC
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  AddToBuffer self.ReadAll
		  ProcessTimer.RunMode = Timer.RunModes.Single
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub AddToBuffer(s As String)
		  if s <> "" then
		    Buffer.Add s
		    BufferBytes = BufferBytes + s.Bytes
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearBuffer()
		  Buffer.RemoveAll
		  BufferBytes = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if ProcessTimer isa object then
		    ProcessTimer.RunMode = Timer.RunModes.Off
		    RemoveHandler ProcessTimer.Action, WeakAddressOf ProcessTimer_Action
		    ProcessTimer = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FlushBuffer() As String
		  var s as string
		  
		  select case Buffer.Count
		  case 0
		    //
		    // Nothing to do
		    //
		    
		  case 1
		    s = Buffer( 0 )
		    
		  case else
		    s = String.FromArray( Buffer, "" )
		    
		  end select
		  
		  ClearBuffer
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ParseHeaders(rawHeaders As String)
		  //
		  // Will parse directly into Request
		  //
		  
		  var lines() as string = rawHeaders.Trim.SplitBytes( EndOfLine.Windows )
		  
		  if lines.Count = 0 then
		    return
		  end if
		  
		  var requestLine as string = lines( 0 ).Trim
		  var requestLineParts() as string = requestLine.Split( " " )
		  if requestLineParts.Count <> 3 then
		    return
		  end if
		  
		  Request.Method = requestLineParts( 0 )
		  Request.URLPath = requestLineParts( 1 )
		  Request.Protocol = requestLineParts( 2 )
		  
		  //
		  // Get the rest of the headers
		  //
		  var headers as new Dictionary
		  
		  for i as integer =  1 to lines.LastIndex
		    var line as string = lines( i ).Trim
		    
		    if line = "" then
		      continue
		    end if
		    
		    var pos as integer = line.IndexOf( ":" )
		    #pragma warning "Handle pos = -1"
		    
		    var key as string = line.MiddleBytes( 0, pos )
		    var value as string = line.MiddleBytes( pos + 1 )
		    headers.Value( key ) = value
		  next
		  
		  Request.Headers = headers
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessTimer_Action(sender As Timer)
		  #pragma unused sender
		  
		  if IsConnected = false then
		    //
		    // Nothing to do
		    //
		    return
		  end if
		  
		  const kEOL as string = &u0D + &u0A
		  const kHeaderDivider as string = kEOL + kEOL
		  const kNoContentLengthHeader as integer = -999
		  
		  if BufferBytes = 0 then
		    //
		    // DataAvailable will start the timer again
		    //
		    return
		  end if
		  
		  var content as string = FlushBuffer
		  
		  if Request.Headers is nil then
		    //
		    // See if we have the header
		    //
		    var headerBreakPos as integer = content.IndexOfBytes( kHeaderDivider )
		    if headerBreakPos = -1 then
		      //
		      // No header yet
		      //
		      AddToBuffer content
		      return
		    end if
		    
		    var rawHeaders as string = content.MiddleBytes( 0, headerBreakPos )
		    content = content.MiddleBytes( headerBreakPos + 2 )
		    
		    ParseHeaders( rawHeaders )
		    
		    var headers as Dictionary = Request.Headers
		    if headers is nil then
		      //
		      // Should have been headers
		      //
		      #pragma warning "Return the appropriate response"
		      return
		    end if
		    
		    ContentLength = headers.Lookup( "Content-Length", kNoContentLengthHeader ).IntegerValue
		    
		    if ContentLength = kNoContentLengthHeader then
		      #pragma warning "Return the appropriate response"
		      return
		    end if
		  end if
		  
		  if ContentLength <> -1 and content.Bytes = ContentLength then
		    //
		    // We've gotten the entire request
		    //
		    var server as WebServer_MTC = self.Server
		    if server is nil then
		      //
		      // We did this for naught
		      //
		      self.Close
		      return
		    end if
		    
		    Request.Body = content
		    
		  else
		    //
		    // We haven't gotten all the content yet
		    //
		    AddToBuffer content
		    
		  end if
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Buffer() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private BufferBytes As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ContentLength As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerWR As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ProcessTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As WebServerRequest_MTC
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if mServerWR is nil then
			    return nil
			  else
			    return M_WebServer.WebServer_MTC( mServerWR.Value )
			  end if
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if mServerWR isa object then
			    //
			    // Can only be set once
			    //
			    if mServerWR.Value <> value then
			      raise new UnsupportedOperationException( "The server is already assigned" )
			    end if
			    
			  elseif value isa object then
			    mServerWR = new WeakRef( value )
			    
			  end if
			  
			End Set
		#tag EndSetter
		Server As M_WebServer.WebServer_MTC
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
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
			Name="SSLConnectionType"
			Visible=true
			Group="Behavior"
			InitialValue="3"
			Type="SSLConnectionTypes"
			EditorType="Enum"
			#tag EnumValues
				"1 - SSLv23"
				"3 - TLSv1"
				"4 - TLSv11"
				"5 - TLSv12"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLEnabled"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnected"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnecting"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesAvailable"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesLeftToSend"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
