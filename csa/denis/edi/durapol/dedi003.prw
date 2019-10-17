#include "DellaVia.ch"

User Function DEDI003(aLog,cTitulo)
	Default aLog           := {}
	Default cTitulo        := ""

	Private cString        := "SB1"
	Private aOrd           := {}
	Private cDesc1         := "Imprime Log gerado por uma atualização via EDI"
	Private cDesc2         := "Recebe um vetor com os dados e um texto com o titulo"
	Private cDesc3         := cTitulo
	Private tamanho        := "M"
	Private nomeprog       := "DEDI003"
	Private lAbortPrint    := .F.
	Private nTipo          := 15
	Private aReturn        := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "EDI003"
	Private titulo         := cTitulo
	Private Li             := 80
	Private Cabec1         := ""
	Private Cabec2         := ""
	Private m_pag          := 01
	Private wnrel          := "DEDI003"
	Private lImp           := .F.
	Private aTipo          := {"Critica","Alerta","Atualização"}
	Private aImp           := aClone(aLog)

	// Carrega - Cria parametros
	cPerg    := PADR(cPerg,6)
	aRegs    := {}
	
	aAdd(aRegs,{cPerg,"01","Imprime            ?"," "," ","mv_ch1","N", 01,0,0,"C","","mv_par01","Criticas","","","","","Alertas","","","","","Alterações","","","","","Tudo","","","","","","","","",""   ,"","","",""          })

	dbSelectArea("SX1")
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				FieldPut(j,aRegs[i,j])
			Next
			MsUnlock()
			dbCommit()
		Endif 
	Next
	Pergunte(cPerg,.F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	Processa({|| RunReport() },Titulo,,.t.)
Return nil


Static Function RunReport()
	Cabec2:=""
	Cabec1:=" Tipo          Descrição                                                                                     Linha  Arquivo"
	        * XXXXXXXXXXX   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  999,999  XXXXXXXXXXXXXXX
    	    *01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	        *          1         2         3         4         5         6         7         8         9        10        11        12        13

	ProcRegua(Len(aImp))

	For k=1 to Len(aImp)
		IncProc(AllTrim(Titulo))
		
		if mv_par01 <> 4 .and. mv_par01 <> aImp[k,1]
			Loop
		Endif

		lImp:=.t.
		if li>55
			LI:=Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.f.)
			LI+=2
		endif
	
		@ LI,001 PSAY aTipo[aImp[k,1]]
		@ LI,015 PSAY Substr(aImp[k,2],1,90)
		@ LI,107 PSAY aImp[k,3] PICTURE "@E 999,999"
		@ LI,116 PSAY Substr(aImp[k,4],1,15)
		LI++
	Next k

	If aReturn[5]==1
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return nil