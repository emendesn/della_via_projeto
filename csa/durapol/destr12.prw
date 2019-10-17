#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR12     บ Autor ณ AP6 IDE            บ Data ณ  10/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DESTR12


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao Movimento Estoque x Custo Gerencial (BI)"
Local cPict          := ""
Local titulo       := "Relacao Analitico Movimento Estoque x Custo BI Gerencial"
Local nLin         := 80

Local Cabec1       := "OP        Produto OP        Materia Prima                                           Dt.Movim Qtd.Movim  Custo Unit. Custo Total Tipo Grupo Servico"
Local Cabec2       := ""
Local imprime      := .T.       
Local aPergunta := {}
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "DESTR12" 
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "DEST12"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DESTR12" 

Private cString := "SD3"

dbSelectArea("SD3")
dbSetOrder(1)

AAdd(aPergunta,{cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"03","Analitico?"        ,"Analitico"      ,"Analitico"      ,"mv_ch3","N", 1,0,0,"C","","mv_par03","Sim",""   ,""   ,"","","Nao","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"04","Do  Grupo ?"       ,"Da  Data"       ,"Da  Data"       ,"mv_ch4","C", 4,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"05","Ate Grupo ?"       ,"Ate Data"       ,"Ate Data"       ,"mv_ch5","C", 4,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"06","Somente Zerados?"  ,"Analitico"      ,"Analitico"      ,"mv_ch6","N", 1,0,0,"C","","mv_par06","Sim",""   ,""   ,"","","Nao","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aPergunta,cPerg)

pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  10/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem     
Local aArqTrab := {}       
Local cArqTrab := "" 

If Mv_Par03 == 2 // sintetico

	AAdd(aArqTrab,{"CARCACA","C",15,0}) // Emissao
	AAdd(aArqTrab,{"PRODUTO","C",15,0}) // Faturamento
	AAdd(aArqTrab,{"CUSTOUN","N",17,2}) // Assistencia Tecnica
	
	cArqTrab := CriaTrab(aArqTrab,.T.)
	dbUseArea(.t.,,cArqTrab,"TRB",)
	
	dbSelectArea("TRB")
	IndRegua("TRB",cArqTrab,"CARCACA+PRODUTO",,,"Criando Arquivo de Trabalho...")

EndIf	                                           

If Mv_Par03 == 1
   Titulo := Alltrim(titulo) + " (   Analitico   )"
EndIf

SB1->( dbSetOrder(1) )
SC2->( dbSetOrder(1) )

dbSelectArea("SD3")
dbSetOrder(6)
dbSeek(xFilial("SD3")+DtoS(Mv_Par01),.T.)
SetRegua(RecCount())

While !EOF() .And. xFilial("SD3") == SD3->D3_FILIAL .And. SD3->D3_EMISSAO <= Mv_Par02

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   SC2->( dbSeek(xFilial("SC2") + SD3->D3_OP,.F.) )
   SB1->( dbSeek(xFilial("SB1") + SD3->D3_COD,.F.) )
                   
   If SD3->D3_GRUPO < Mv_Par04 .Or. SD3->D3_GRUPO > Mv_Par05
      SD3->( dbSkip() )
      Loop             
   EndIf

   If Mv_Par03 == 1
	   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif                        
   EndIf
	   
   If SD3->D3_ESTORNO == "S"
      dbSkip()
      Loop
   EndIf
   
   If SD3->D3_TM != "502"
      dbSkip()
      Loop
   EndIf

   
/*
OP        Produto OP        Materia Prima                                           Dt.Movim Qtd.Movim  Custo Unit. Custo Total Tipo Grupo Servico        
XXXXXXXXX XXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXX-ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ 99/99/99   9999,99  999,999.99   999,999.99 XX   XXXX  XXXXXXXXXXXXXXX
1         11                29                                                      85         96       105          118        129  134   140                    
*/
         
   nCustoGerencial := 0
   
   If SB1->B1_GRUPO == "BAND"
   	  If SG1->( dbSeek(xFilial("SG1") + SC2->C2_PRODUTO                   + SD3->D3_COD,.F.) )   
   	  	Do while .not.eof("SG1") .and.  SC2->C2_PRODUTO = SG1->G1_COD .AND. SD3->D3_COD = SG1->G1_COMP 
   			IF SD3->D3_EMISSAO >= SG1->G1_INI .AND. SD3->D3_EMISSAO <= SG1->G1_FIM 
				nCustoGerencial := SG1->G1_XCSBI
				EXIT
			ENDIF
			SG1->( dbSkip() )
		Enddo  
      EndIf                          
   Else
      nCustoGerencial := SB1->B1_CUSTD
   EndIf
   
   If Mv_Par06 == 1 .And. nCustoGerencial > 0
      dbSelectArea("SD3")
      SD3->( dbSkip() )
      Loop
   EndIf
   
   If Mv_Par03 == 2
      dbSelectArea("TRB")
      If ! dbSeek(SC2->C2_PRODUTO+SD3->D3_COD,.F.)
         RecLock("TRB",.T.)
      Else 
         RecLock("TRB",.F.)
      EndIf
      TRB->CARCACA := SC2->C2_PRODUTO
      TRB->PRODUTO := SD3->D3_COD
      TRB->CUSTOUN := nCustoGerencial
      MsUnlock()
   EndIf
   
   If Mv_Par03 == 1
	   @nLin,001 PSAY SC2->C2_NUM+"-"+SC2->C2_ITEM
	   @nLin,011 PSAY SC2->C2_PRODUTO	   
	   @nLin,029 PSAY SD3->D3_COD+"-"+Substr(SB1->B1_DESC,1,40)
	   @nLin,085 PSAY SD3->D3_EMISSAO
	   @nLin,096 PSAY SD3->D3_QUANT PICTURE "@E 9999.99"
	   @nLin,105 PSAY nCustoGerencial PICTURE "@E 999,999.99"
	   @nLin,118 PSAY SD3->D3_QUANT * nCustoGerencial PICTURE "@E 999,999.99"   
	   @nLin,129 PSAY SB1->B1_TIPO
	   @nLin,134 PSAY SB1->B1_GRUPO
	   @nLin,140 PSAY SD3->D3_X_PROD
       nLin++
   EndIf

   dbSelectArea("SD3")
   dbSkip() // Avanca o ponteiro do registro no arquivo
   
EndDo                                          
                                                           
If Mv_Par03 == 2

   Titulo := Alltrim(titulo) + " (   Sintetico   )"
   Cabec1 := "Carcaca         Produto                                                   Tipo Grupo  Custo Gerencial"
   nLin   := 99

   dbSelectArea("TRB")
   dbGotop()
   While !Eof()

	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif                        

/*
Carcaca         Produto                                                   Tipo Grupo  Custo Gerencial
XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  xx   xxxx        999,999.99
1               17                                                        75   80          92
*/                                
       SB1->( dbSeek(xFilial("SB1") + TRB->PRODUTO,.F.))
	   
	   @nLin,001 PSAY TRB->CARCACA
	   @nLin,017 PSAY TRB->PRODUTO+"-"+Substr(SB1->B1_DESC,1,40)
	   @nLin,075 PSAY SB1->B1_TIPO
	   @nLin,080 PSAY SB1->B1_GRUPO
	   @nLin,092 PSAY TRB->CUSTOUN PICTURE "@E 999,999.99"
	   nLin++
	   
       TRB->( dbSkip() )
       
   EndDo

dbSelectArea("TRB")
dbCloseArea("TRB")
FErase(cArqTRaB+OrdBagExt())

EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
