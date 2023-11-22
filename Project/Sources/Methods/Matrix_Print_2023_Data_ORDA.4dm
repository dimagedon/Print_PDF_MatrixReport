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


If (btnTrace)
	TRACE:C157
End if 


If (True:C214)  // generate data
	
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
	
	
	ARRAY TEXT:C222($aProductCode; 3)
	$aProductCode{1}:="C"
	$aProductCode{2}:="D"
	$aProductCode{3}:="E-27"
	
	$stamp:=String:C10(Milliseconds:C459)
	
	$dStart:=Current date:C33-Day number:C114(Current date:C33)+2
	$dStart:=Add to date:C393($dStart; 0; 0; -7)
	$Weeks:=90
	
	var $c : Collection
	$c:=New collection:C1472
	
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
				
				
				$c.push(New object:C1471("Code"; $PrCode; "Location"; $location; \
					"Season_Beg"; $dForm; "Season_End"; $dUntil; \
					"isChanged"; $isMod; "Status"; $status; \
					"FlexLevel"; $Level; "Stamp"; $stamp))
				
			End for 
			
			
		End for 
		
	End for 
	
	$count1:=$c.count()
	$c2:=$c.distinct("Location")
	
	var $myData_col; $c2; $c3; $location_Data_col : Collection
	
	$dBeg:=Current date:C33
	$myData_col:=$c.query("Season_Beg > :1"; $dBeg)
	$count2:=$myData_col.count()
	
	$c2:=$c.distinct("Location")
	
	$PU:=$c2.first()
	$location_Data_col:=$myData_col.query("Location = :1"; $PU)
	$c3:=$location_Data_col.distinct("Code")
	
End if 

