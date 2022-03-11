#tag Class
Class WebServerRequest_MTC
	#tag Property, Flags = &h0
		Body As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Method As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Parameters As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Protocol As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RouteTag As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		URLPath As String
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
		#tag ViewProperty
			Name="Method"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="URLPath"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
