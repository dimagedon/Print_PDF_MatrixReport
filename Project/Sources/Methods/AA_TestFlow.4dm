//%attributes = {}

// ----------------------------------------------------
// User name (OS): Dimitri
// Date and time: 05.02.10, 17:17:23
//  20/08/2010 DS
// ----------------------------------------------------
// Method: G_TimeStamp
// Description
// 
//
// Parameters
// ----------------------------------------------------
//  08/10/18 DS
C_BOOLEAN:C305($1)
C_TEXT:C284($0; $M; $D)

$M:=String:C10(Month of:C24(Current date:C33))
If (Length:C16($M)<2)
	$M:="0"+$M
End if 
$D:=String:C10(Day of:C23(Current date:C33))
If (Length:C16($D)<2)
	$D:="0"+$D
End if 

If (Count parameters:C259=0)  //  2019-10-02T00:00:00 DS - stay compatible
	$0:=String:C10(Year of:C25(Current date:C33))+$M+$D+Replace string:C233(String:C10(Current time:C178); ":"; "")
Else 
	//  2019-09-10T00:00:00 DS
	$0:=String:C10(Year of:C25(Current date:C33))+"-"+$M+"-"+$D+"T"+String:C10(Current time:C178)
End if 




//  22.11.2023 DS TEST