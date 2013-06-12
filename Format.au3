
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("DriveFormat", 253, 73, 192, 124)
$Combo1 = GUICtrlCreateCombo("Combo1", 8, 8, 169, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$Button1 = GUICtrlCreateButton("&Format", 168, 40, 73, 25)
$Button2 = GUICtrlCreateButton("Refresh", 184, 8, 57, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

	ListDrives()
   
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		 Case $Button1
			FormatClick()
		 Case $Button2
			ListDrives()	  
		 Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func ListDrives()
   _GUICtrlComboBox_ResetContent($Combo1)
   ; Add files
   $arDrvList = DriveGetDrive('ALL') ; Get list of removable Drives.

   For $i = 1 To $arDrvList[0]
	  If $arDrvList[$i] = 'a:' Then ContinueLoop ; except floppy Drive.
	  If $arDrvList[$i] = 'c:' Then ContinueLoop ; except floppy Drive.
	  If $arDrvList[$i] = 'd:' Then ContinueLoop ; except floppy Drive.
	  GUICtrlSetData($Combo1,$arDrvList[$i])
   Next
   ; ----------------------------------------------------
EndFunc

Func FormatClick()
   $DriveToFormat = GUICtrlRead($Combo1) 
   if $DriveToFormat = "" Then
	  MsgBox(16, "Error","Please Choose A Drive To Format")
	  Return
   EndIf
   
   $Result = MsgBox(36, "Confirmation","Please Confirm you want to format " & $DriveToFormat & " in exFAT (Mac & PC Compatible)")
   If $Result = 6 Then
	  FormatDrive($DriveToFormat)
   EndIf
EndFunc

Func FormatDrive($Drive)
   BlockInput(0)
   Run("CMD")
   #WinWaitActive("C:\WINDOWS\system32\CMD.exe")
   Sleep(1000)
   Send("runas /user:" & @ComputerName & "\itadmin cmd{ENTER}")
   Sleep(1000)
   Send("l0calADMIN{ENTER}")
   WinWaitActive("cmd (running as " &@ComputerName & "\itadmin")
   Send("FORMAT " & $Drive & " /FS:exFat /q{enter}")
   Sleep(1000)
   Send(DriveGetLabel($Drive) & "{enter}")
   Sleep(1000)
   Send("y{enter}")
   Sleep(1000)
   Send("Camp{enter}")
   Sleep(1500)
   Send("exit{enter}")
   Send("exit{enter}")
   BlockInput(0)
   MsgBox(64, "Done","All Done!")
EndFunc