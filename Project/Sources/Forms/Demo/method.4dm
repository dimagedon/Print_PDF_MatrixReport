
C_BOOLEAN:C305(btnTrace)


Case of 
	: (Form event code:C388=On Load:K2:1)
		btnTrace:=False:C215
		
		If (Records in table:C83([Test_Prices:1])<100)
			OBJECT SET ENABLED:C1123(btn_CreateData; True:C214)
			OBJECT SET ENABLED:C1123(btn_Print_wData; False:C215)
			
		Else 
			OBJECT SET ENABLED:C1123(btn_CreateData; False:C215)
			OBJECT SET ENABLED:C1123(btn_DeleteData; True:C214)
			OBJECT SET ENABLED:C1123(btn_Print_wData; True:C214)
			
		End if 
		
		
	Else 
		
End case 
