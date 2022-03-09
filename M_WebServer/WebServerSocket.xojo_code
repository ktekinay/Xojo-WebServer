#tag Class
Protected Class WebServerSocket
Inherits SSLSocket
	#tag Event
		Sub Connected()
		  ProcessTimer = new Timer
		  ProcessTimer.RunMode = Timer.RunModes.Off
		  ProcessTimer.Period = 10
		  
		  AddHandler ProcessTimer.Action, WeakAddressOf ProcessTimer_Action
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  AddToBuffer self.ReadAll
		  ProcessTimer.RunMode = Timer.RunModes.Single
		  ProcessTimer.Reset
		  
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
		  var s as string = String.FromArray( Buffer, "" )
		  ClearBuffer
		  return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessTimer_Action(sender As Timer)
		  if BufferBytes = 0 then
		    sender.RunMode = Timer.RunModes.Single
		    return
		  end if
		  
		  var content as string = FlushBuffer
		  
		  if Headers is nil then
		    
		  end if
		  
		  if ContentLength <> -1 and content.Bytes = ContentLength then
		    //
		    // We've gotten the request
		    //
		    
		  else
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
		Private Headers() As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mServerWR As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ProcessTimer As Timer
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
