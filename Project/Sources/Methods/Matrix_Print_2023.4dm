//%attributes = {"executedOnServer":true}
// ----------------------------------------------------
// User name (OS): Dimas
// Date and time: 15.11.2023
// ----------------------------------------------------
// Method: Matrix_Print_2023
// Description
//  Matrix_Print_2023_Data
//use FORM LOAD("print_template")
//
// ----------------------------------------------------
//  15.11.2023 DS

C_DATE:C307($dBeg; $date)
C_BOOLEAN:C305($error)
C_LONGINT:C283($hpaper; $wpaper; $bestWidth; $bestHeight)
C_LONGINT:C283($W; $H; $LH; $HH; $CW; $posX0; $posY0; $posX; $posY)
C_LONGINT:C283($size; $style; $color; $align; $alignV)
C_LONGINT:C283($ArrSize; $i; $r; $n; $p)
C_TEXT:C284($font; $TitleLeft; $TitleRight; $footer; $text)
C_TEXT:C284($PU; $PUName)
C_TEXT:C284($Folder; $file; $documentpath)
C_TEXT:C284($foregroundColor; $backgroundColor)


ARRAY TEXT:C222(a_RegCode; 5)
ARRAY TEXT:C222(a_RegName; 5)

a_RegCode{1}:="LAS"
a_RegName{1}:="Las Vegas"
a_RegCode{2}:="SFO"
a_RegName{2}:="San Francisco"
a_RegCode{3}:="LAX"
a_RegName{3}:="Los Angeles"
a_RegCode{4}:="NYC"
a_RegName{4}:="New York"
a_RegCode{5}:="BOS"
a_RegName{5}:="Boston"

If (btnTrace)
	TRACE:C157
End if 


QUERY:C277([Test_Prices:1]; [Test_Prices:1]Season_End:5>Current date:C33)

QUERY SELECTION:C341([Test_Prices:1]; [Test_Prices:1]Code:2="B"; *)
QUERY SELECTION:C341([Test_Prices:1];  | ; [Test_Prices:1]Code:2="C"; *)
QUERY SELECTION:C341([Test_Prices:1];  | ; [Test_Prices:1]Code:2="E-27")


CREATE SET:C116([Test_Prices:1]; "SetFLX")

ORDER BY:C49([Test_Prices:1]; [Test_Prices:1]Location:3; [Test_Prices:1]Code:2; [Test_Prices:1]Season_Beg:4; >)

ARRAY TEXT:C222(aLocations; 0)
DISTINCT VALUES:C339([Test_Prices:1]Location:3; aLocations)
SORT ARRAY:C229(aLocations; >)


If (Day number:C114(Current date:C33)=Sunday:K10:19)
	$dBeg:=Current date:C33+1
Else 
	$dBeg:=Current date:C33-Day number:C114(Current date:C33)+2
End if 
USE SET:C118("SetFLX")

// pdf settings
$file:="RatesMatrix-"+G_TimeStamp+".pdf"

If (Application type:C494=4D Server:K5:6)
	$Folder:=Get 4D folder:C485(HTML Root folder:K5:20)+"pdfdocs"
Else 
	$Folder:=System folder:C487(Documents folder:K41:18)+"pdfdocs"
End if 


If (Test path name:C476($Folder)#Is a folder:K24:2)
	CREATE FOLDER:C475($Folder)
End if 
$Folder:=$Folder+Folder separator:K24:12
$documentpath:=$Folder+$file


SET PRINT OPTION:C733(Orientation option:K47:2; 2)
SET PRINT OPTION:C733(Destination option:K47:7; 3; $documentpath)
SET CURRENT PRINTER:C787(Generic PDF driver:K47:15)


If (OK=1)
	OPEN PRINTING JOB:C995
	
	If (OK=1)
		
		//open template form
		FORM LOAD:C1103("print_template")
		GET PRINTABLE AREA:C703($hpaper; $wpaper)
		
		
		$W:=28  //29
		$H:=14
		$LH:=14
		$HH:=18
		$CW:=28  //29
		$posX0:=20
		$posY0:=20
		
		//$font:="Arial"
		//$font:="Courier"
		//$font:="Segoe UI"
		//$font:="Monaco"
		$font:="Times New Roman"
		
		$size:=8
		
		$style:=Bold:K14:2
		$style:=Plain:K14:1
		$foregroundColor:="Black"
		$backgroundColor:="White"
		$align:=Align center:K42:3
		//$alignV:=Align center
		
		
		$TitleLeft:="Your Company Flex Rates Plan"
		$TitleRight:="Valid for all bookings from "+Replace string:C233(String:C10($dBeg; Internal date long:K1:5); ","; "")+" to "+Replace string:C233(String:C10($dBeg+6; Internal date long:K1:5); ","; "")
		
		$footer:="Changes from prior week are displayed in RED"+Char:C90(13)
		$footer:=$footer+"RQ - On Request; NA - Not Available"
		
		print_text_noBorder:=$TitleLeft
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; 12)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		$posX:=$posX0
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
		
		
		print_text_noBorder:=$TitleRight
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; 12)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		$posX:=$wpaper-$bestWidth-30
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
		$posY0:=$posY0+$bestHeight+6
		
		
		For ($n; 1; Size of array:C274(aLocations))
			
			
			$PU:=aLocations{$n}
			USE SET:C118("SetFLX")
			QUERY SELECTION:C341([Test_Prices:1]; [Test_Prices:1]Location:3=$PU)
			CREATE SET:C116([Test_Prices:1]; "SetPU")
			ARRAY TEXT:C222(aCode; 0)
			DISTINCT VALUES:C339([Test_Prices:1]Code:2; aCode)
			SORT ARRAY:C229(aCode; >)
			
			$ArrSize:=Size of array:C274(aCode)
			
			ARRAY TEXT:C222(aLevel; 0)  // Flex level
			ARRAY TEXT:C222(aStatus; 0)  // Status
			ARRAY BOOLEAN:C223(aIsModidified; 0)  // modified
			
			// print header pro station
			
			$i:=Find in array:C230(a_RegCode; $PU)
			
			If ($i>0)
				If (a_RegName{$i}#"")
					$PUName:=a_RegName{$i}
				End if 
			Else 
				$PUName:=$PU
			End if 
			
			$posY:=$posY0
			$posX:=$posX0
			print_text:="Pick-Up Location: "+$PUName  //+(Char(32)*150)+"Changes from prior week are displayed in RED"
			//$color:=-(White+(256*Dark blue))
			$foregroundColor:="White"
			$backgroundColor:="DarkBlue"
			OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
			OBJECT SET FONT:C164(print_text; $font)
			OBJECT SET FONT SIZE:C165(print_text; 12)
			OBJECT SET FONT STYLE:C166(print_text; Bold:K14:2)
			OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; Align left:K42:2)
			// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
			$error:=Print object:C1095(print_text; $posX; $posY; 760; $HH)
			
			$posY0:=$posY0+$HH+8
			
			$foregroundColor:="Black"
			$backgroundColor:="White"
			// print station
			$posY:=$posY0
			$posX:=$posX0
			print_text:=$PU
			OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
			OBJECT SET FONT:C164(print_text; $font)
			OBJECT SET FONT SIZE:C165(print_text; $size)
			OBJECT SET FONT STYLE:C166(print_text; $style)
			OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
			// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
			$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
			
			// print product code
			$posY:=$posY+$HH
			For ($r; 1; Size of array:C274(aCode))
				//$posY:=$posY+$LH
				$posX:=$posX0
				print_text:=aCode{$r}
				OBJECT SET RGB COLORS:C628(print_text; $foregroundColor)
				OBJECT SET FONT:C164(print_text; $font)
				OBJECT SET FONT SIZE:C165(print_text; $size)
				OBJECT SET FONT STYLE:C166(print_text; $style)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
				// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
				$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
				$posY:=$posY+$LH
			End for 
			
			$posX0:=$posX0+$CW
			$posY:=$posY0
			
			$date:=$dBeg
			For ($i; 1; 78)
				USE SET:C118("SetPU")
				QUERY SELECTION:C341([Test_Prices:1]; [Test_Prices:1]Season_Beg:4=$date)
				
				ARRAY TEXT:C222(aLevel; $ArrSize)
				ARRAY TEXT:C222(aStatus; $ArrSize)
				ARRAY BOOLEAN:C223(aIsModidified; $ArrSize)
				
				$foregroundColor:="Black"
				$backgroundColor:="White"
				$style:=Plain:K14:1
				
				If (Records in selection:C76([Test_Prices:1])>0)
					
					SELECTION TO ARRAY:C260([Test_Prices:1]FlexLevel:6; aLevel; [Test_Prices:1]Status:7; aStatus; [Test_Prices:1]isChanged:8; aIsModidified)
					
					
					Case of 
						: ($i=1)
							$posX:=$posX0
							
						: (Mod:C98(($i-1); 26)=0)  // ($i=27) | ($i=53)
							
							// print station
							$posY0:=$posY0+($LH*4)+12
							$posY:=$posY0
							$posX:=$posX0-$CW
							print_text:=$PU
							OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
							OBJECT SET FONT:C164(print_text; $font)
							OBJECT SET FONT SIZE:C165(print_text; $size)
							OBJECT SET FONT STYLE:C166(print_text; $style)
							OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
							// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
							$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
							
							// print product code
							$posY:=$posY+$HH
							For ($r; 1; Size of array:C274(aCode))
								//$posY:=$posY+$LH
								$posX:=$posX0-$CW
								print_text:=aCode{$r}
								OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
								OBJECT SET FONT:C164(print_text; $font)
								OBJECT SET FONT SIZE:C165(print_text; $size)
								OBJECT SET FONT STYLE:C166(print_text; $style)
								OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
								// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
								$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
								$posY:=$posY+$LH
							End for 
							
							//$posX0:=$posX0+$CW
							$posY:=$posY0
							
							$posX:=$posX0
							
						Else 
							$posX:=$posX+$CW
							
					End case 
					
					$posY:=$posY0
					
					// print CELL Date
					ARRAY TEXT:C222(aMonthName; 12)  // month name
					aMonthName{1}:="JAN"
					aMonthName{2}:="FEB"
					aMonthName{3}:="MAR"
					aMonthName{4}:="APR"
					aMonthName{5}:="MAY"
					aMonthName{6}:="JUN"
					aMonthName{7}:="JUL"
					aMonthName{8}:="AUG"
					aMonthName{9}:="SEP"
					aMonthName{10}:="OCT"
					aMonthName{11}:="NOV"
					aMonthName{12}:="DEC"
					
					//C_TEXT($MonthName;$Day;$Year)
					//$MonthName:=aMonthName{Month of($date)}
					//$Day:=String(Day of($date);"00")
					//$Year:=String(Year of($date))
					
					If ((Month of:C24($date)>0) & (Month of:C24($date)<13))
						print_text:=String:C10(Day of:C23($date); "00")+" "+aMonthName{Month of:C24($date)}+Char:C90(13)+String:C10(Year of:C25($date))
					Else 
						print_text:=String:C10(Day of:C23($date); "00")+" "+String:C10(Month of:C24($date); "00")+Char:C90(13)+String:C10(Year of:C25($date))
					End if 
					
					
					$size:=7
					OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
					OBJECT SET FONT:C164(print_text; $font)
					OBJECT SET FONT SIZE:C165(print_text; $size)
					OBJECT SET FONT STYLE:C166(print_text; $style)
					OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
					//OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
					$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
					
					$size:=8
					$posY:=$posY+$HH
					
					//$posY:=$posY0
					For ($r; 1; Size of array:C274(aCode))
						//$posY:=$posY+$LH
						Case of 
							: (aStatus{$r}="RQ")
								$text:="RQ "+aLevel{$r}
							: (aStatus{$r}="NA")
								$text:="NA"
							Else 
								$text:=aLevel{$r}
						End case 
						
						print_text:=$text
						
						
						If (aIsModidified{$r})  //| (aLevel{$r}="A4")  // flex level changed
							//$color:=-(Red)
							$foregroundColor:="Red"
							$backgroundColor:="Yellow"
							$style:=Bold:K14:2
						Else 
							$foregroundColor:="Black"
							$backgroundColor:="White"
							$style:=Plain:K14:1
						End if 
						
						// print CELL FlexLevel
						
						//$align:=Center
						
						
						//OBJECT SET ALIGNMENT(print_text;$align)
						OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
						OBJECT SET FONT:C164(print_text; $font)
						OBJECT SET FONT SIZE:C165(print_text; $size)
						OBJECT SET FONT STYLE:C166(print_text; $style)
						OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
						//OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
						$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
						
						$posY:=$posY+$LH
						
					End for 
					
				End if 
				
				$date:=Add to date:C393($date; 0; 0; 7)
				
				ARRAY TEXT:C222(aLevel; 0)
				ARRAY TEXT:C222(aStatus; 0)
				ARRAY BOOLEAN:C223(aIsModidified; 0)
				
				
			End for 
			// loop cells
			
			If ($n=2) | ($n=4)
				
				$foregroundColor:="Black"
				$backgroundColor:="White"
				
				print_text_noBorder:=$footer
				OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
				OBJECT SET FONT:C164(print_text_noBorder; $font)
				OBJECT SET FONT SIZE:C165(print_text_noBorder; 8)
				OBJECT SET FONT STYLE:C166(print_text_noBorder; Plain:K14:1)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
				
				OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
				
				
				$posX:=$wpaper-$bestWidth-30
				$posY:=$posY+$HH
				$error:=Print object:C1095(print_text_noBorder; $posX; $posY; $bestWidth; $bestHeight+2)
				
				PAGE BREAK:C6
				
				
				// page header 
				$posX0:=20
				$posY0:=20
				
				print_text_noBorder:=$TitleLeft
				OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
				OBJECT SET FONT:C164(print_text_noBorder; $font)
				OBJECT SET FONT SIZE:C165(print_text_noBorder; 12)
				OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
				
				OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
				
				$posX:=$posX0
				$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
				
				
				print_text_noBorder:=$TitleRight
				OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
				OBJECT SET FONT:C164(print_text_noBorder; $font)
				OBJECT SET FONT SIZE:C165(print_text_noBorder; 12)
				OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
				
				OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
				
				$posX:=$wpaper-$bestWidth-30
				$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
				$posY0:=$posY0+$bestHeight+6
				
			Else 
				$posX0:=$posX0-$CW
				$posY0:=$posY+$LH+10
			End if 
			
			
			
		End for 
		// loop locations
		
		$foregroundColor:="Black"
		$backgroundColor:="White"
		print_text_noBorder:=$footer
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; 8)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Plain:K14:1)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		
		$posX:=$wpaper-$bestWidth-30
		$posY:=$posY+$HH
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY; $bestWidth; $bestHeight+2)
		
		
	End if 
	// OPEN PRINTING JOB
	//close printing job and send to printer
	CLOSE PRINTING JOB:C996
	
	DELAY PROCESS:C323(Current process:C322; 90)
	
	
	va_Path:=$documentpath
	
End if 

CLEAR SET:C117("SetFLX")
CLEAR SET:C117("SetPU")
ARRAY TEXT:C222(a_RegCode; 0)
ARRAY TEXT:C222(a_RegName; 0)
ARRAY TEXT:C222(aLevel; 0)
ARRAY TEXT:C222(aStatus; 0)
ARRAY BOOLEAN:C223(aIsModidified; 0)

If (Not:C34(Application type:C494=4D Server:K5:6))
	SHOW ON DISK:C922($documentpath)
End if 

