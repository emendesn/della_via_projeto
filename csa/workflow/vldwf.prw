#include 'ap5mail.ch'
#include 'tbiconn.ch'

user function vldwf                      

Prepare environment empresa '01' filial '01'      

oProcess:= TWFProcess():New( "000001", "vldwf" )
oProcess:NewVersion(.T.)
oProcess:NewTask( "Validacao", "\WORKFLOW.HTM" )
oHtml   := oProcess:oHTML
oHtml:ValByName( "data", DTOS(ddatabase))
oHtml:ValByName( "server" , GETMV("MV_WFSMTP"))
oProcess:cSubject	:= "Validacao de workflow"
oProcess:cTo		:= "workflow1@dellavia.com.br"
oProcess:bReturn  := "U_VLDWFRET()"
oProcess:nEncodeMime:= 0  
oProcess:Start()	

return
                             
User function vldwfret(oProcess)

_cObs := oProcess:oHtml:RetByName("OBS")
conout("*************************************************************")
conout(":: Processo de retorno OK - Valida��o do workflow :: ")
conout(_cObs)

Return
