#include "Dellavia.ch"
#include "Dellavia.ch"

User Function UPDR430()
	Private Titulo      	:= "ACERTA TABELAS DO PROTHEUS R4"
	Private aSays       	:= {}
	Private aButtons    	:= {}
	Private cPerg           := "UPD430"   
	Private aRegs           := {}  

	aAdd(aRegs,{cPerg,"01","Nome da Tabela?"," "," ","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })
	aAdd(aRegs,{cPerg,"02","Operação      ?"," "," ","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","",""          })

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
	
	aAdd(aSays,"Esta rotina acerta tabela do Protheus antes do Update")
	
	aAdd(aButtons,{ 5,.T.,{|o| Pergunte(cPerg,.T.)                   }})
	aAdd(aButtons,{ 1,.T.,{|o| Processa({|| Corrige() },Titulo,,.t.)  }})
	aAdd(aButtons,{ 2,.T.,{|o| FechaBatch()                          }})

	FormBatch(Titulo,aSays,aButtons)
Return nil

Static Function Corrige()

	Local vReg   := ""
	Local vItem  := 0
	//FechaBatch()
	vProc		 := 0        
	vExec		 := ""
	Do Case       
		Case upper(mv_par02) = "CRIA"
			dbSelectArea(mv_par01)
			dbCloseArea()              
		Case upper(mv_par02) = "ACERTA" .and. upper(mv_par01) = "MAK" 
			cSql := "UPDATE "+RetSqlName("MAK")
			cSql += "   SET MAK_ITEM   = '999' "  
			cSql += " WHERE D_E_L_E_T_ = '' "
			cSql += "   AND MAK_FILIAL = '"+xFilial("MAK")+"' "
			cSql += "   AND MAK_ITEM   = '' "
			nUpdt := 0
			nUpdt := TcSqlExec(cSql)
			If nUpdt < 0
				MsgBox(TcSqlError(),"MAK","STOP")
			Else	
				dbSelectArea("MAK")
				dbSetOrder(1)
				vReg  := Mak_Filial+Mak_CodCli+Mak_Loja+Mak_Contra
				vItem := 500
				dbSkip()
				Do While .not.eof()
					if  vReg <>  Mak_Filial+Mak_CodCli+Mak_Loja+Mak_Contra
						vReg  := Mak_Filial+Mak_CodCli+Mak_Loja+Mak_Contra
						vItem := 500
						dbSkip()
						loop
					endif   
					vItem := vItem + 1
					if val(Mak_Item) = 999
						if RecLock("MAK",.F.)      
							MAK->Mak_Item  := strzero(vItem,3)
							MsUnlock()
							vProc ++
						endif
					endif    
					dbSkip()
				Enddo
				dbCloseArea()
				cSql := "UPDATE "+RetSqlName("MAK")
				cSql += "   SET MAK_ITEM   = '' "  
				cSql += " WHERE D_E_L_E_T_ = '' "
				cSql += "   AND MAK_FILIAL = '"+xFilial("MAK")+"'"
				cSql += "   AND MAK_ITEM   = '999' "
				nUpdt := 0
				nUpdt := TcSqlExec(cSql) 
			Endif
		Otherwise
			msgbox("Nome da tabela não informada ou incorreto","Update","Info")
	Endcase
	msgbox(AllTrim(mv_par01)+" "+alltrim(str(vProc,10,0))+":= registro(s) corrigido(s)","Update","Info")
Return nil     