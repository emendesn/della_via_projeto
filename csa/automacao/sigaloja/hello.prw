#INCLUDE "TBICONN.CH"

User Function HELLO()

	Local cStartPath := Upper(GetSrvProfString("STARTPATH",""))
	Local cArquivo   := cStartPath+"HELLO.LOG"
	Local nHandle  	 := 0

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SM0"
	cTexto  := "Hello ... Gravado em, Data: " + dtos(date()) + " Hora: " + time()				           		 	               

	If  File(cArquivo)
		nHandle := FErase ( cArquivo )
	Endif
	nHandle := FCreate( cArquivo )

	If nHandle <> -1
   		FWrite(nHandle,cTexto,Len(cTexto))
   		FClose(nHandle)
	Endif   

Return ()

