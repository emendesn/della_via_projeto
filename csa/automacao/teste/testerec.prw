#INCLUDE "RWMAKE.CH"    
#INCLUDE "TBICONN.CH"
User Function TesteRec()      

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" TABLES "SUA"
DbSelectArea("SUA")

Begin Transaction
	RecLock("SUA",.T.)           
	SUA->UA_FILIAL := "91"
	MsUnlock()   

	FkCommit()
	
	TesteRec2()  

	RecLock("SUA",.T.)           
	SUA->UA_FILIAL := "93"
	MsUnlock()  
End Transaction	

Return .T.

Static Function TesteRec2()

RecLock("SUA",.T.)           
SUA->UA_FILIAL := "92"
MsUnlock() 

Return


