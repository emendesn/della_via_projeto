#include "DellaVia.ch"

User Function TSTFTP()
	Local aDir := {}
	FTPDisconnect()
	if !FTPConnect("192.1.1.4",21,"anonymous","siga@")
		msgbox("Não foi possivél conectar no FTP","FTP","STOP")
		Return nil
	Endif
	FTPDirChange("seguros")
	aDir := FTPDirectory("*.*","D")
	FTPDisconnect()
	cMsg := ""
	For k=1 to Len(aDir)
		cMsg += aDir[k,1] + chr(10) + chr(13)
	Next k
	msgbox(cMsg)
Return nil