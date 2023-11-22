//%attributes = {"executedOnServer":true}

// ----------------------------------------------------
// User name (OS): Dimas
// Date and time: 03/08/16, 12:36:28
// ----------------------------------------------------
// Method: Matrix_Print_2023_Data
// Description
// 
//
// Parameters
// ----------------------------------------------------
//  8/8/2016 DS
//  15.11.2023 DS

If (False:C215)
	
	//[Test_Prices]Code
	//[Test_Prices]FlexLevel  // A1-A8;F1-F8
	//[Test_Prices]isChanged
	//[Test_Prices]Location  // PU location
	//[Test_Prices]Season_Beg
	//[Test_Prices]Season_End
	//[Test_Prices]Status  // NA;RQ;
	
	
	aLevel{$p}:=[Test_Prices:1]FlexLevel:6  // A1-A8;F1-F8
	aStatus{$p}:=[Test_Prices:1]Status:7  // NA;RQ;
	aIsModidified{$p}:=[Test_Prices:1]isChanged:8
	
End if 

If (btnTrace)
	TRACE:C157
End if 


$LevelA:="ABCDEFGH"
$sizeA:=Length:C16($LevelA)
$LevelB:="12345678"
$sizeB:=Length:C16($LevelB)

ARRAY TEXT:C222($aLocations; 5)
$aLocations{1}:="LAS"
$aLocations{2}:="SFO"
$aLocations{3}:="LAX"
$aLocations{4}:="NYC"
$aLocations{5}:="BOS"

ARRAY TEXT:C222($aProductCode; 6)
$aProductCode{1}:="A"
$aProductCode{2}:="B"
$aProductCode{3}:="C"
$aProductCode{4}:="D"
$aProductCode{5}:="E-21"
$aProductCode{6}:="E-27"


$stamp:=String:C10(Milliseconds:C459)

$dStart:=Current date:C33-Day number:C114(Current date:C33)+2
$dStart:=Add to date:C393($dStart; 0; 0; -7)
$Weeks:=90

For ($n; 1; Size of array:C274($aLocations))
	$location:=$aLocations{$n}
	$dForm:=$dStart
	
	For ($w; 1; $Weeks)
		$dForm:=Add to date:C393($dForm; 0; 0; 7)
		$dUntil:=Add to date:C393($dForm; 0; 0; 6)
		
		For ($p; 1; Size of array:C274($aProductCode))
			$PrCode:=$aProductCode{$p}
			
			$iTemp:=Random:C100%100
			Case of 
				: ($iTemp>80)
					$status:="NA"
				: ($iTemp>60)
					$status:="RQ"
				Else 
					$status:=""
			End case 
			
			$iTemp:=Random:C100%100
			If ($iTemp>70)
				$isMod:=True:C214
			Else 
				$isMod:=False:C215
			End if 
			
			$iTemp:=(Random:C100%$sizeA)+1
			$L1:=$LevelA[[$iTemp]]
			$iTemp:=(Random:C100%$sizeB)+1
			$L2:=$LevelB[[$iTemp]]
			$Level:=$L1+$L2
			
			CREATE RECORD:C68([Test_Prices:1])
			[Test_Prices:1]Code:2:=$PrCode
			[Test_Prices:1]Location:3:=$location
			[Test_Prices:1]Season_Beg:4:=$dForm
			[Test_Prices:1]Season_End:5:=$dUntil
			
			[Test_Prices:1]isChanged:8:=$isMod
			[Test_Prices:1]Status:7:=$status
			
			[Test_Prices:1]FlexLevel:6:=$Level
			[Test_Prices:1]Stamp:9:=$stamp
			
			SAVE RECORD:C53([Test_Prices:1])
			
		End for 
		
		
	End for 
	
End for 

QUERY:C277([Test_Prices:1]; [Test_Prices:1]Stamp:9=$stamp)
