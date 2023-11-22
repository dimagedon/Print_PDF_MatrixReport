//%attributes = {"executedOnServer":true}

//// ----------------------------------------------------
//// User name (OS): Dimas
//// Date and time: 03/08/16, 12:36:28
//// ----------------------------------------------------
//// Method: FlexRates_Print
//// Description
//// 
////
//// Parameters
//// ----------------------------------------------------
////  8/8/2016 DS
//C_DATE($dBeg; $date)
//C_BOOLEAN($error)

//C_LONGINT($hpaper; $wpaper; $bestWidth; $bestHeight)
//C_LONGINT($W; $H; $LH; $HH; $CW; $posX0; $posY0; $posX; $posY)
//C_LONGINT($size; $style; $color; $align)
//C_LONGINT($ArrSize; $i; $r; $n; $p)

//C_TEXT($font; $TitleLeft; $TitleRight; $footer; $text)
//C_TEXT($PU; $PUName)

//C_TEXT($Folder; $file; $documentpath)
//C_TEXT($printersetup; $curprinter)


////$Folder:=Get 4D folder(HTML Root Folder)+"pdfdocs"+Folder separator
//$file:="BestTimeRV-FlexRates-"+Substring(G_TimeStamp; 1; 8)+".pdf"

//If (Application type=4D Server)
////$Folder:=Get 4D folder(HTML Root folder)+"pdfdocs"

//$Folder:=G_WebFolder+"pdfdocs"  //  2021-12-09T00:00:00 DS
//Else 
//$Folder:=Get 4D folder+"pdfdocs"
//End if 


//If (Test path name($Folder)#Is a folder)
//CREATE FOLDER($Folder)
//End if 
//$Folder:=$Folder+Folder separator

//$documentpath:=$Folder+$file


//$printersetup:=WWW_PickP(va_Tag; 0; "PDF_Setup=")

//If ($printersetup="")
//C_LONGINT($orientation)
//$curprinter:=Get current printer
//GET PRINT OPTION(Orientation option; $orientation)
////OPTION =2(Orientation option): returns 1(Portrait)or 2(Landscape). 
////If a different orientation option is used, value1 is set to 0.

//If ($orientation#2)
//SET PRINT OPTION(Orientation option; 2)
////SET PRINT OPTION("PDFOptions:UseAutosave";1)  //native call
//End if 


//If ($curprinter#_o_PDFCreator Printer name)


//ARRAY TEXT(a_names; 0)  // $sttPrinterName
//ARRAY TEXT(a_values; 0)  // $sttPrinterDesc
//PRINTERS LIST(a_names; a_values)
//If (Find in array(a_names; _o_PDFCreator Printer name)>0)
//SET CURRENT PRINTER(_o_PDFCreator Printer name)
//End if 
//End if 
//ARRAY TEXT(a_names; 0)  // $sttPrinterName
//ARRAY TEXT(a_values; 0)  // $sttPrinterDesc


//SET PRINT OPTION(Destination option; 3; $documentpath)

//SET PRINT OPTION("PDFOptions:UseAutosave"; 1)  //native call
//SET PRINT OPTION("PDFOptions:UseAutosaveDirectory"; 1)  //native call
////SET PRINT OPTION("PDFOptions:AutosaveDirectory";$path)  //native call

//SET PRINT OPTION("PDFOptions:PDFUseSecurity"; 1)
//SET PRINT OPTION("PDFOptions:PDFOwnerPass"; 1)
//SET PRINT OPTION("PDFOptions:PDFHighEncryption"; 1)
//SET PRINT OPTION("PDFOptions:PDFDisallowModifyContents"; 1)
//SET PRINT OPTION("PDFOptions:PDFOwnerPasswordString"; "master")
//OK:=1
//End if 



//// QUOTE_aInit 
//ARRAY TEXT(QUOTE_a_PrPTyp; 0)  // pick-up location
//ARRAY TEXT(QUOTE_a_PrPC; 0)  // product code
//ARRAY TEXT(QUOTE_a_PrPD; 0)  // Flex level
//ARRAY TEXT(QUOTE_a_MiSel; 0)  // Status
//ARRAY BOOLEAN(ARRVISIBLE; 0)  // modified

//ARRAY TEXT(a_RegWeb; 0)
//ARRAY TEXT(a_Reg4D; 0)

//vi_Lingo:=1
//WWW_PopLoad  //fill lists - see WWW_Array_Init

//QUERY([Product_Prices:14]; [Product_Prices:14]Price_Type:2="V"; *)
//QUERY([Product_Prices:14];  & ; [Product_Prices:14]FlexLevel:68#""; *)
//QUERY([Product_Prices:14];  & ; [Product_Prices:14]Sell_Curr_Code:46="FLX"; *)
//QUERY([Product_Prices:14];  & ; [Product_Prices:14]End_Season:4>Current date; *)
//QUERY([Product_Prices:14])

//QUERY SELECTION([Product_Prices:14]; [Product_Prices:14]Calc_Code:1="B-21"; *)
//QUERY SELECTION([Product_Prices:14];  | ; [Product_Prices:14]Calc_Code:1="D-22"; *)
//QUERY SELECTION([Product_Prices:14];  | ; [Product_Prices:14]Calc_Code:1="E-23")

//CREATE SET([Product_Prices:14]; "SetFLX")

//ORDER BY([Product_Prices:14]; [Product_Prices:14]Price_Type_1:33; [Product_Prices:14]Calc_Code:1; [Product_Prices:14]Beg_Season:3; >)

//ARRAY TEXT(QUOTE_a_PrPTyp; 0)
//DISTINCT VALUES([Product_Prices:14]Price_Type_1:33; QUOTE_a_PrPTyp)
//SORT ARRAY(QUOTE_a_PrPTyp; >)

//If (Day number(Current date)=Sunday)
//$dBeg:=Current date+1
//Else 
//$dBeg:=Current date-Day number(Current date)+2
//End if 

//USE SET("SetFLX")

////begin print job
//// PRINT SETTINGS
//If (OK=1)
//OPEN PRINTING JOB
//If (OK=1)

////open template form
//FORM LOAD("print_template")
//GET PRINTABLE AREA($hpaper; $wpaper)



//$W:=29
//$H:=14
//$LH:=14
//$HH:=18
//$CW:=29
//$posX0:=20
//$posY0:=20

////$font:="Arial"
////$font:="Courier"
////$font:="Segoe UI"
////$font:="Monaco"
//$font:="Times New Roman"

//$size:=8

//$style:=Bold
//$style:=Plain
//$color:=-(Black)
//$align:=Align center
////$alignV:=Align center

//$TitleLeft:="Best Time RV Flex Rates Plan"
//$TitleRight:="Valid for all bookings from "+Replace string(String($dBeg; Internal date long); ","; "")+" to "+Replace string(String($dBeg+6; Internal date long); ","; "")

//$footer:="Changes from prior week are displayed in RED"+Char(13)
//$footer:=$footer+"RQ - On Request; NA - Not Available"

//print_text_noBorder:=$TitleLeft
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 12)
//OBJECT SET FONT STYLE(print_text_noBorder; Bold)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)

//$posX:=$posX0
//$error:=Print object(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)


//print_text_noBorder:=$TitleRight
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 12)
//OBJECT SET FONT STYLE(print_text_noBorder; Bold)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)

//$posX:=$wpaper-$bestWidth-30
//$error:=Print object(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
//$posY0:=$posY0+$bestHeight+6

//For ($n; 1; Size of array(QUOTE_a_PrPTyp))


//$PU:=QUOTE_a_PrPTyp{$n}
//USE SET("SetFLX")
//QUERY SELECTION([Product_Prices:14]; [Product_Prices:14]Price_Type_1:33=$PU)
//CREATE SET([Product_Prices:14]; "SetPU")

//DISTINCT VALUES([Product_Prices:14]Calc_Code:1; QUOTE_a_PrPC)
//SORT ARRAY(QUOTE_a_PrPC; >)

//$ArrSize:=Size of array(QUOTE_a_PrPC)

//ARRAY TEXT(QUOTE_a_PrPD; 0)  // Flex level
//ARRAY TEXT(QUOTE_a_MiSel; 0)  // Status
//ARRAY BOOLEAN(ARRVISIBLE; 0)  // modified

//// print header pro station

//$i:=Find in array(a_Reg4D; $PU)

//If ($i>0)
//If (a_RegWeb{$i}#"")
//$PUName:=a_RegWeb{$i}
//End if 
//Else 
//$PUName:=$PU
//End if 

//$posY:=$posY0
//$posX:=$posX0
//print_text:="Pick-Up Location: "+$PUName  //+(Char(32)*150)+"Changes from prior week are displayed in RED"
//$color:=-(White+(256*Dark blue))
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; 12)
//OBJECT SET FONT STYLE(print_text; Bold)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; Align left)
//// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; 786; $HH)

//$posY0:=$posY0+$HH+8

//$color:=-(Black)
//// print station
//$posY:=$posY0
//$posX:=$posX0
//print_text:=$PU
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
//// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $HH)

//// print product code
//$posY:=$posY+$HH
//For ($r; 1; Size of array(QUOTE_a_PrPC))
////$posY:=$posY+$LH
//$posX:=$posX0
//print_text:=QUOTE_a_PrPC{$r}
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
//// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $H)
//$posY:=$posY+$LH
//End for 

//$posX0:=$posX0+$CW
//$posY:=$posY0

//$date:=$dBeg
//For ($i; 1; 78)
//USE SET("SetPU")
//QUERY SELECTION([Product_Prices:14]; [Product_Prices:14]Beg_Season:3=$date)

//ARRAY TEXT(QUOTE_a_PrPD; $ArrSize)
//ARRAY TEXT(QUOTE_a_MiSel; $ArrSize)
//ARRAY BOOLEAN(ARRVISIBLE; $ArrSize)

//$color:=-(Black)
//$style:=Plain

//If (Records in selection([Product_Prices:14])>0)

//While (Not(End selection([Product_Prices:14])))

//$p:=Find in array(QUOTE_a_PrPC; [Product_Prices:14]Calc_Code:1)

//If ($p>0)
//QUOTE_a_PrPD{$p}:=[Product_Prices:14]FlexLevel:68
//QUOTE_a_MiSel{$p}:=[Product_Prices:14]Status:72
//ARRVISIBLE{$p}:=[Product_Prices:14]FSH:59
//Else 
//// error
//End if 

//NEXT RECORD([Product_Prices:14])
//End while 

//Case of 
//: ($i=1)
//$posX:=$posX0

//: (Mod(($i-1); 26)=0)  // ($i=27) | ($i=53)

//// print station
//$posY0:=$posY0+($LH*4)+12
//$posY:=$posY0
//$posX:=$posX0-$CW
//print_text:=$PU
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
//// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $HH)

//// print product code
//$posY:=$posY+$HH
//For ($r; 1; Size of array(QUOTE_a_PrPC))
////$posY:=$posY+$LH
//$posX:=$posX0-$CW
//print_text:=QUOTE_a_PrPC{$r}
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
//// OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $H)
//$posY:=$posY+$LH
//End for 

////$posX0:=$posX0+$CW
//$posY:=$posY0

//$posX:=$posX0

//Else 
//$posX:=$posX+$CW

//End case 

//$posY:=$posY0

//// print CELL Date
//ARRAY TEXT(QUOTE_a_PrPRem; 12)  // month name
//QUOTE_a_PrPRem{1}:="JAN"
//QUOTE_a_PrPRem{2}:="FEB"
//QUOTE_a_PrPRem{3}:="MAR"
//QUOTE_a_PrPRem{4}:="APR"
//QUOTE_a_PrPRem{5}:="MAY"
//QUOTE_a_PrPRem{6}:="JUN"
//QUOTE_a_PrPRem{7}:="JUL"
//QUOTE_a_PrPRem{8}:="AUG"
//QUOTE_a_PrPRem{9}:="SEP"
//QUOTE_a_PrPRem{10}:="OCT"
//QUOTE_a_PrPRem{11}:="NOV"
//QUOTE_a_PrPRem{12}:="DEC"

////C_TEXT($MonthName;$Day;$Year)
////$MonthName:=QUOTE_a_PrPRem{Month of($date)}
////$Day:=String(Day of($date);"00")
////$Year:=String(Year of($date))

//If ((Month of($date)>0) & (Month of($date)<13))
//print_text:=String(Day of($date); "00")+" "+QUOTE_a_PrPRem{Month of($date)}+Char(13)+String(Year of($date))
//Else 
//print_text:=String(Day of($date); "00")+" "+String(Month of($date); "00")+Char(13)+String(Year of($date))
//End if 


//$size:=7
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
////OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $HH)

//$size:=8
//$posY:=$posY+$HH

////$posY:=$posY0
//For ($r; 1; Size of array(QUOTE_a_PrPC))
////$posY:=$posY+$LH
//Case of 
//: (QUOTE_a_MiSel{$r}="RQ")
//$text:="RQ "+QUOTE_a_PrPD{$r}
//: (QUOTE_a_MiSel{$r}="NA")
//$text:="NA"
//Else 
//$text:=QUOTE_a_PrPD{$r}
//End case 

//print_text:=$text


//If (ARRVISIBLE{$p}) | (QUOTE_a_PrPD{$r}="A4")  // flex level changed
//$color:=-(Red)
//$style:=Bold+Underline
//Else 
//$color:=-(Black)
//$style:=Plain
//End if 

//// print CELL FlexLevel

////$align:=Center


////OBJECT SET ALIGNMENT(print_text;$align)
//_O_OBJECT SET COLOR(print_text; $color)
//OBJECT SET FONT(print_text; $font)
//OBJECT SET FONT SIZE(print_text; $size)
//OBJECT SET FONT STYLE(print_text; $style)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text; $align)
////OBJECT SET VERTICAL ALIGNMENT(print_text;$alignV)
//$error:=Print object(print_text; $posX; $posY; $W; $H)

//$posY:=$posY+$LH

//End for 

//End if 

//$date:=Add to date($date; 0; 0; 7)

//ARRAY TEXT(QUOTE_a_PrPD; 0)
//ARRAY TEXT(QUOTE_a_MiSel; 0)
//ARRAY BOOLEAN(ARRVISIBLE; 0)


//End for 

//If ($n=2) | ($n=4)

//print_text_noBorder:=$footer
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 8)
//OBJECT SET FONT STYLE(print_text_noBorder; Plain)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)


//$posX:=$wpaper-$bestWidth-30
//$posY:=$posY+$HH
//$error:=Print object(print_text_noBorder; $posX; $posY; $bestWidth; $bestHeight+2)

//PAGE BREAK


//// page header 
//$posX0:=20
//$posY0:=20

//print_text_noBorder:=$TitleLeft
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 12)
//OBJECT SET FONT STYLE(print_text_noBorder; Bold)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)

//$posX:=$posX0
//$error:=Print object(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)


//print_text_noBorder:=$TitleRight
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 12)
//OBJECT SET FONT STYLE(print_text_noBorder; Bold)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)

//$posX:=$wpaper-$bestWidth-30
//$error:=Print object(print_text_noBorder; $posX; $posY0; $bestWidth; $bestHeight+2)
//$posY0:=$posY0+$bestHeight+6

//Else 
//$posX0:=$posX0-$CW
//$posY0:=$posY+$LH+10
//End if 


//End for 

//print_text_noBorder:=$footer
//_O_OBJECT SET COLOR(print_text_noBorder; $color)
//OBJECT SET FONT(print_text_noBorder; $font)
//OBJECT SET FONT SIZE(print_text_noBorder; 8)
//OBJECT SET FONT STYLE(print_text_noBorder; Plain)
//OBJECT SET HORIZONTAL ALIGNMENT(print_text_noBorder; Align left)

//OBJECT GET BEST SIZE(print_text_noBorder; $bestWidth; $bestHeight)


//$posX:=$wpaper-$bestWidth-30
//$posY:=$posY+$HH
//$error:=Print object(print_text_noBorder; $posX; $posY; $bestWidth; $bestHeight+2)

//End if 

////close printing job and send to printer
//CLOSE PRINTING JOB

//DELAY PROCESS(Current process; 90)


//SET PRINT OPTION("PDFOptions:Reset standard options"; 1)
//SET PRINT OPTION(Destination option; 1)
////do not stop or close the pdf printer
////SET PRINT OPTION("PDFInfo:CloseRunningSession";1)
////DELAY PROCESS(Current process;280)
//SET CURRENT PRINTER($curprinter)  //dont use set current printer

//va_Path:=$documentpath

//End if 

//CLEAR SET("SetFLX")
//CLEAR SET("SetPU")


//ARRAY TEXT(a_RegWeb; 0)
//ARRAY TEXT(a_Reg4D; 0)
//ARRAY TEXT(QUOTE_a_PrPTyp; 0)
//ARRAY TEXT(QUOTE_a_PrPD; 0)  // Flex level
//ARRAY TEXT(QUOTE_a_MiSel; 0)  // Status
//ARRAY BOOLEAN(ARRVISIBLE; 0)  // modified
//ARRAY TEXT(QUOTE_a_PrPRem; 0)  // month name


//If (Application type=4D Server)
//G_Protocol(14; 5; "Flexrates weekly pdf created"; $documentpath)
//Else 
//SHOW ON DISK($documentpath)
//End if 
