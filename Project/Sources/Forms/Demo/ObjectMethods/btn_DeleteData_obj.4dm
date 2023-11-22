
If (Form event code:C388=On Clicked:K2:4)
	
	If (btnTrace)
		TRACE:C157
	End if 
	
	UNLOAD RECORD:C212([Test_Prices:1])
	READ WRITE:C146([Test_Prices:1])
	ALL RECORDS:C47([Test_Prices:1])
	DELETE SELECTION:C66([Test_Prices:1])
	
	OBJECT SET ENABLED:C1123(btn_CreateData; True:C214)
	OBJECT SET ENABLED:C1123(btn_Print_wData; False:C215)
End if 
