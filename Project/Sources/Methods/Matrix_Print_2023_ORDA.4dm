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
//  23.11.2023 DS

If (False:C215)
	Matrix_Print_2023_ORDA
	Matrix_Print_2023
	Matrix_Print_2023_Data
	Matrix_Print_2023_Data_ORDA
	
	
	//todo: test todo
	//mark: test mark
	//fixme:test fixme
	//MARK:-SettingsA
	
End if 

C_DATE:C307($dBeg; $date)
C_BOOLEAN:C305($error)
C_LONGINT:C283($hpaper; $wpaper; $bestWidth; $bestHeight)
C_LONGINT:C283($W; $H; $LH; $HH; $CW; $posX0; $posY0; $posX; $posY)
C_LONGINT:C283($size; $style; $color; $align)
C_LONGINT:C283($ArrSize; $i; $r; $n; $p)
C_TEXT:C284($font; $TitleLeft; $TitleRight; $footer; $text)
C_TEXT:C284($PU; $PUName)
C_TEXT:C284($Folder; $file; $documentpath)
C_TEXT:C284($foregroundColor; $backgroundColor)

C_LONGINT:C283($sizeA; $sizeB; $Weeks; $iTemp; $count1; $sizeTitle; $sizeDates; $count)
C_TEXT:C284($LevelA; $LevelB; $stamp; $location; $PrCode; $status; $Level; $L1; $L2)
C_TEXT:C284($output; $code)
C_OBJECT:C1216($myPrice)
C_BOOLEAN:C305($isMod)
C_DATE:C307($dStart; $dForm; $dUntil)

var $daiily_Data_col : Collection
var $c; $c2 : Collection
var $myData_col; $Locations_col : Collection
var $location_Data_col; $code_distinct_col : Collection

If (btnTrace)
	TRACE:C157
End if 



//MARK:-Settings
If (True:C214)  // settings
	
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
	
End if 

//MARK:-generate data
If (True:C214)  // generate data see Matrix_Print_2023_Data_ORDA
	
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
	
	$output:=JSON Stringify:C1217($c.orderBy("Location, Season_Beg, Code"); *)
	
	SET TEXT TO PASTEBOARD:C523($output)
	
End if 






If (Day number:C114(Current date:C33)=Sunday:K10:19)
	$dBeg:=Current date:C33+1
Else 
	$dBeg:=Current date:C33-Day number:C114(Current date:C33)+2
End if 

$myData_col:=$c.query("Season_Beg >= :1"; $dBeg)

$Locations_col:=$myData_col.distinct("Location").sort()  // aLocations

//MARK:- pdf printing settings
If (True:C214)  // pdf settings
	
	$file:="RatesMatrix-"+G_TimeStamp()+".pdf"
	
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
	
End if 

//MARK:-start printing
If (OK=1)  // start printing
	OPEN PRINTING JOB:C995
	
	If (OK=1)
		
		//open template form
		FORM LOAD:C1103("print_template")
		GET PRINTABLE AREA:C703($hpaper; $wpaper)
		
		$TitleLeft:="Your Company Flex Rates Plan"
		$TitleRight:="Valid for all bookings from "+Replace string:C233(String:C10($dBeg; Internal date long:K1:5); ","; "")+" to "+Replace string:C233(String:C10($dBeg+6; Internal date long:K1:5); ","; "")
		
		$footer:="Changes from prior week are displayed in RED"+Char:C90(13)
		$footer:=$footer+"RQ - On Request; NA - Not Available"
		
		
		$W:=28  // cell width
		$H:=14  // cell height
		$LH:=14
		$HH:=18  // header cell height
		$CW:=28  // cell horizontal shifting
		$posX0:=20
		$posY0:=20
		
		
		$font:="Times New Roman"
		
		$size:=8  // font size
		$sizeTitle:=12  // font size : title row font size 
		$sizeDates:=7  // font size : dates row
		
		$style:=Bold:K14:2
		$style:=Plain:K14:1
		$foregroundColor:="Black"
		$backgroundColor:="White"
		$align:=Align center:K42:3
		
		
		
		
		
		//MARK:- Page header : Left
		
		print_text_noBorder:=$TitleLeft
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; $sizeTitle)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		$posX:=$posX0
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
		
		//MARK:- Page header : Right
		print_text_noBorder:=$TitleRight
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; $sizeTitle)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		$posX:=$wpaper-$bestWidth-30
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
		$posY0:=$posY0+$bestHeight+6
		$n:=0
		For each ($PU; $Locations_col)
			$n:=$n+1
			
			
			$location_Data_col:=$myData_col.query("Location = :1"; $PU)
			$code_distinct_col:=$location_Data_col.distinct("Code").sort()
			
			
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
			
			//MARK:- Table Header : per Station
			print_text:="Pick-Up Location: "+$PUName  //+(Char(32)*150)+"Changes from prior week are displayed in RED"
			
			$foregroundColor:="White"
			$backgroundColor:="DarkBlue"
			OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
			OBJECT SET FONT:C164(print_text; $font)
			OBJECT SET FONT SIZE:C165(print_text; $sizeTitle)
			OBJECT SET FONT STYLE:C166(print_text; Bold:K14:2)
			OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; Align left:K42:2)
			
			$error:=Print object:C1095(print_text; $posX; $posY; 760; $HH)
			
			
			$posY0:=$posY0+$HH+$size
			
			$foregroundColor:="Black"
			$backgroundColor:="White"
			// print station
			$posY:=$posY0
			$posX:=$posX0
			
			//MARK:- Table Row1 :  Station Code
			print_text:=$PU
			OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
			OBJECT SET FONT:C164(print_text; $font)
			OBJECT SET FONT SIZE:C165(print_text; $size)
			OBJECT SET FONT STYLE:C166(print_text; $style)
			OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
			
			$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
			
			
			//MARK:- Table Col1 :  Print all Product Codes
			$posY:=$posY+$HH
			For each ($code; $code_distinct_col)
				
				$posX:=$posX0
				
				print_text:=$code
				OBJECT SET RGB COLORS:C628(print_text; $foregroundColor)
				OBJECT SET FONT:C164(print_text; $font)
				OBJECT SET FONT SIZE:C165(print_text; $size)
				OBJECT SET FONT STYLE:C166(print_text; $style)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
				
				$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
				$posY:=$posY+$LH
				
				//End for 
				
				
			End for each 
			
			$posX0:=$posX0+$CW
			$posY:=$posY0
			
			//MARK:- Table Cells
			$date:=$dBeg
			For ($i; 1; 78)
				
				
				
				$daiily_Data_col:=$location_Data_col.query("Season_Beg = :1"; $date).orderBy("Code")
				$count:=$daiily_Data_col.count()
				
				
				$foregroundColor:="Black"
				$backgroundColor:="White"
				$style:=Plain:K14:1
				
				//If (Records in selection([Test_Prices])>0)
				If ($count>0)
					
					Case of 
						: ($i=1)
							$posX:=$posX0
							
						: (Mod:C98(($i-1); 26)=0)  // ($i=27) | ($i=53)
							
							// print station
							$posY0:=$posY0+($LH*4)+$sizeTitle
							$posY:=$posY0
							$posX:=$posX0-$CW
							print_text:=$PU
							OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
							OBJECT SET FONT:C164(print_text; $font)
							OBJECT SET FONT SIZE:C165(print_text; $size)
							OBJECT SET FONT STYLE:C166(print_text; $style)
							OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
							
							$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
							
							// print product code
							$posY:=$posY+$HH
							For each ($code; $code_distinct_col)
								
								$posX:=$posX0-$CW
								print_text:=$code
								
								OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
								OBJECT SET FONT:C164(print_text; $font)
								OBJECT SET FONT SIZE:C165(print_text; $size)
								OBJECT SET FONT STYLE:C166(print_text; $style)
								OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
								
								$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
								$posY:=$posY+$LH
								
								//End for 
								
							End for each 
							
							//$posX0:=$posX0+$CW
							$posY:=$posY0
							
							$posX:=$posX0
							
						Else 
							$posX:=$posX+$CW
							
					End case 
					
					$posY:=$posY0
					
					//MARK:- CELL : Date
					If ((Month of:C24($date)>0) & (Month of:C24($date)<13))
						print_text:=String:C10(Day of:C23($date); "00")+" "+aMonthName{Month of:C24($date)}+Char:C90(13)+String:C10(Year of:C25($date))
					Else 
						print_text:=String:C10(Day of:C23($date); "00")+" "+String:C10(Month of:C24($date); "00")+Char:C90(13)+String:C10(Year of:C25($date))
					End if 
					
					
					
					OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
					OBJECT SET FONT:C164(print_text; $font)
					OBJECT SET FONT SIZE:C165(print_text; $sizeDates)
					OBJECT SET FONT STYLE:C166(print_text; $style)
					OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
					
					$error:=Print object:C1095(print_text; $posX; $posY; $W; $HH)
					
					
					$posY:=$posY+$HH
					
					//MARK:- column with  dailly status per ProductCode
					For each ($myPrice; $daiily_Data_col)
						
						Case of 
							: ($myPrice.Status="RQ")
								$text:="RQ "+$myPrice.FlexLevel
							: ($myPrice.Status="NA")
								$text:="NA"
							Else 
								$text:=$myPrice.FlexLevel
						End case 
						
						
						print_text:=$text
						
						
						If ($myPrice.isChanged=True:C214)  //| (aLevel{$r}="A4")  // flex level changed
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
						
						OBJECT SET RGB COLORS:C628(print_text; $foregroundColor; $backgroundColor)
						OBJECT SET FONT:C164(print_text; $font)
						OBJECT SET FONT SIZE:C165(print_text; $size)
						OBJECT SET FONT STYLE:C166(print_text; $style)
						OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text; $align)
						
						$error:=Print object:C1095(print_text; $posX; $posY; $W; $H)
						
						$posY:=$posY+$LH
						
						
						
					End for each 
					
				End if 
				
				$date:=Add to date:C393($date; 0; 0; 7)
				
				
			End for 
			// loop cells
			
			If ($n=2) | ($n=4)
				
				$foregroundColor:="Black"
				$backgroundColor:="White"
				
				print_text_noBorder:=$footer
				OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
				OBJECT SET FONT:C164(print_text_noBorder; $font)
				OBJECT SET FONT SIZE:C165(print_text_noBorder; $size)
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
				OBJECT SET FONT SIZE:C165(print_text_noBorder; $sizeTitle)
				OBJECT SET FONT STYLE:C166(print_text_noBorder; Bold:K14:2)
				OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
				
				OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
				
				$posX:=$posX0
				$error:=Print object:C1095(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
				
				
				print_text_noBorder:=$TitleRight
				OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
				OBJECT SET FONT:C164(print_text_noBorder; $font)
				OBJECT SET FONT SIZE:C165(print_text_noBorder; $sizeTitle)
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
			
			
			// End for 
			// 
		End for each 
		//loop locations
		
		$foregroundColor:="Black"
		$backgroundColor:="White"
		print_text_noBorder:=$footer
		OBJECT SET RGB COLORS:C628(print_text_noBorder; $foregroundColor; $backgroundColor)
		OBJECT SET FONT:C164(print_text_noBorder; $font)
		OBJECT SET FONT SIZE:C165(print_text_noBorder; $size)
		OBJECT SET FONT STYLE:C166(print_text_noBorder; Plain:K14:1)
		OBJECT SET HORIZONTAL ALIGNMENT:C706(print_text_noBorder; Align left:K42:2)
		
		OBJECT GET BEST SIZE:C717(print_text_noBorder; $bestWidth; $bestHeight)
		
		
		$posX:=$wpaper-$bestWidth-30
		$posY:=$posY+$HH
		$error:=Print object:C1095(print_text_noBorder; $posX; $posY; $bestWidth; $bestHeight+2)
		
		
		
	End if 
	
	//MARK:-close printing job and send to printer
	CLOSE PRINTING JOB:C996
	
	DELAY PROCESS:C323(Current process:C322; 90)
	
	
	va_Path:=$documentpath
	
End if 

ARRAY TEXT:C222(a_RegCode; 0)
ARRAY TEXT:C222(a_RegName; 0)


If (Not:C34(Application type:C494=4D Server:K5:6))
	SHOW ON DISK:C922($documentpath)
End if 

