/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DFATR10   ºAutor  ³ Reinaldo Caldas    º Data ³  27/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Resumo de vendas Motorista/Vend/Indicacao(Desmembra novos) º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol Renovadora de Pneus LTDA.                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DFATR10()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cDesc1      := "Este relatorio ira demonstrar o resumo de vendas dos motoristas, vendedores e "
Private cDesc2      := "indicadores, sendo que para cada função ira ser realizada uma quebra com seus "
Private cDesc3      := "subtotais. Resumo de vendas por vendedor "
Private lEnd        := .F.
Private tamanho     := "P"
Private nomeprog    := "DFATR10"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
PRIVATE limite       := 78
Private titulo      := "Resumo de Vendas"
Private nLin        := 80
Private Cabec1      := " "
Private Cabec2      := " "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private imprime     := .T.
Private m_pag      	:= 01
Private wnrel      	:= "DFATR10"
Private _cPerg     	:= "DFAT10"
Private cString 	:= "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Da  Data ?"        ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"02","Ate Data ?"        ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"03","Do  Motorista ?"   ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(_aRegs,{_cPerg,"04","Ate Motorista ?"   ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(_aRegs,{_cPerg,"05","Do  Vendedor ?"    ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch5","C", 6,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(_aRegs,{_cPerg,"06","Ate Vendedor ?"    ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch6","C", 6,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(_aRegs,{_cPerg,"07","Do  Indicador ?"   ,"Do Vendedor"    ,"Do Vendedor"    ,"mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(_aRegs,{_cPerg,"08","Ate indicador ?"   ,"Ate Vendedor"   ,"Ate Vendedor"   ,"mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})

ValidPerg(_aRegs,_cPerg)

Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| ImpRel() } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ImpRel   ºAutor  ³ Reinaldo Caldas    º Data ³  17/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do relatorio                         º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpRel()
LOCAL cabec1   :=" Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02)
LOCAL cabec2   := " Codigo    Nome                            Valor       Servico         Mercantil  "
LOCAL _aTam    := _aEstrutura := {}
LOCAL nTotVlr  := nTotNovo := nTotGer := 0

ProcRegua(100)

_aEstrutura := {}

_aTam := TamSX3("A3_NOME")
aAdd(_aEstrutura,{"TMP_NOME"    ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_VEND3")
aAdd(_aEstrutura,{"TMP_VEND"    ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_VALFAT")
aAdd(_aEstrutura,{"TMP_ORDEM"   ,"C",1       , 0      }) //Ordem
aAdd(_aEstrutura,{"TMP_VLFAT"   ,"N",_aTam[1],_aTam[2]}) //Vendas
aAdd(_aEstrutura,{"TMP_SERV"    ,"N",_aTam[1],_aTam[2]}) //Servico
aAdd(_aEstrutura,{"TMP_NOVO"    ,"N",_aTam[1],_aTam[2]}) //Mercantil/Novo

cNomArq := CriaTrab(_aEstrutura,.T.)

dbUseArea(.T.,,cNomArq,"TMP",.T.,.F.)

dbSelectArea("TMP")
IndRegua("TMP",cNomArq,"TMP_ORDEM+Descend(Strzero(TMP_VLFAT,11,2))",,,"Selecionando Registros") //+TMP_VEND+
dbSetIndex(cNomArq+OrdbagExt())
GeraTRB(1,mv_par03,mv_par04)

GeraTRB(2,mv_par05,mv_par06)

GeraTRB(3,mv_par07,mv_par08)

dbSelectArea("TMP")
dbGotop()
dbSetOrder(1)

cOrdem    := TMP->TMP_ORDEM
cOrdemAnt := TMP->TMP_ORDEM

While ! Eof()
	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
  	IF nLin > 60
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
		nLin := 9
		IF cOrdem = "1" 
			@ nLin, 001 Psay "Por motorista  "
			nLin := nLin + 2
		ElseIF cOrdem = "2" 
			@ nLin, 001 Psay "Por vendedor   "
			nLin := nLin + 2
		ElseIF cOrdem = "3" 
			@ nLin, 001 Psay "Por indicador  "
			nLin := nLin + 2
		EndIF
	EndIF
	
	IF cOrdem = "1" .and. cOrdemAnt != TMP->TMP_ORDEM
		@ nLin, 001 Psay "Por motorista  "
		nLin := nLin + 2
	ElseIF cOrdem = "2" .and. cOrdemAnt != TMP->TMP_ORDEM
		@ nLin, 001 Psay "Por vendedor   "
		nLin := nLin + 2
	ElseIF cOrdem = "3" .and. cOrdemAnt != TMP->TMP_ORDEM
		@ nLin, 001 Psay "Por indicador  "
		nLin := nLin + 2
	EndIF
	
	@ nLin, 001 Psay TMP->TMP_VEND
	@ nLin, 010 Psay Substr(TMP->TMP_NOME,1,25)
	@ nLin, 035 Psay TMP->TMP_VLFAT  Picture "@E 99,999,999.99"
	@ nLin, 050 Psay TMP->TMP_SERV   Picture "@E 99,999,999.99"
	@ nLin, 065 Psay TMP->TMP_NOVO   Picture "@E 99,999,999.99"
	
	nLin ++
	
	nTotGer  += TMP->TMP_VLFAT
	nTotVlr  += TMP->TMP_SERV
	nTotNovo += TMP->TMP_NOVO
	
	cOrdemAnt := TMP->TMP_ORDEM
	
	dbSelectArea("TMP")
	TMP->(dbSkip())
	IF cOrdemAnt != TMP->TMP_ORDEM
		cOrdem := TMP->TMP_ORDEM
		nLin ++
		@ nLin, 001 Psay "SubTotal : "
		@ nLin, 035 Psay nTotGer  Picture "@E 99,999,999.99"
		@ nLin, 050 Psay nTotVlr  Picture "@E 99,999,999.99"
		@ nLin, 065 Psay nTotNovo Picture "@E 99,999,999.99"
		nTotGer  := nTotVlr  := nTotNovo := 0
		nLin += 2
	EndIF
EndDo

nLin ++

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	Roda(cbcont,cbtxt,"P")
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPgEject(.F.)

dbSelectArea("TMP")
dbCloseArea()
fErase(cNomArq+GetDBExtension())
fErase(cNomArq+OrdbagExt())

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
EndiF

MS_FLUSH()

Return

Static Function GeraTRB (cOpc,cParam1,cParam2)

LOCAL _cQry := cCod := ""
LOCAL nTotVlr  := nTotGer  := nTotNovo := 0

IF Select("TRB") > 0
	TRB->(dbCloseArea())
EndIF


_cQry := "select F2_FILIAL, F2_DOC, F2_SERIE, F2_VEND3, F2_VEND4, F2_VEND5 "
_cQry += " from " + RetSqlName("SF2")+ " SF2 "
_cQry += " where SF2.D_E_L_E_T_ = ' ' "
_cQry += " and F2_FILIAL = '" + xFilial("SF2") + "' "
_cQry += " and F2_EMISSAO >= '" + DtoS(mv_par01) + "' and F2_EMISSAO <= '" + DtoS(mv_par02) + "' "
_cQry += " and F2_TIPO = 'N' "
IF cOpc = 1
	_cQry += " and F2_VEND3 >= '" + cParam1 + "' and F2_VEND3 <= '" + cParam2 + "' "
	_cQry += " order by F2_VEND3 "
ElseIF cOpc = 2
	_cQry += " and F2_VEND4 >= '" + cParam1 + "' and F2_VEND4 <= '" + cParam2 + "' "
	_cQry += " order by F2_VEND4 "
Else
	_cQry += " and F2_VEND5 >= '" + cParam1 + "' and F2_VEND5 <= '" + cParam2 + "' "
	_cQry += " order by F2_VEND5 "
EndIF
memowrite("teste.sql",_cQry)
_cQry := ChangeQuery(_cQry)

dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

cCod := IIF (cOpc = 1,TRB->F2_VEND3,IIF(cOpc = 2,TRB->F2_VEND4,TRB->F2_VEND5))

While ! Eof()
	
	IF cOpc = 1 .and. cCod == TRB->F2_VEND3
		cCod := TRB->F2_VEND3
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
		
		While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE		
			
			IF SD2->D2_TES $ '594/902/903'  //Nao considero os itens nao agregados
				SD2->( dbSkip() )
				Loop
			EndIF
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )
			
			//--Vlr.Total Faturado
			IF SF4->F4_DUPLIC = 'S' .and. ! cGrupo $ "CARC" //Total Faturado
				nTotGer += SD2->D2_TOTAL
			EndIF

					
			//--Total Vendas Servico incluindo consertos
			IF SF4->F4_DUPLIC = 'S' .and. cGrupo $ "SERV/CI/SC" //Total SERVICO
				nTotVlr += SD2->D2_TOTAL
			EndIF
				
		
			IF cGrupo $ "0001" .or. SD2->D2_TES = '503' // Grupo de Pneus novos
				nTotNovo += SD2->D2_TOTAL
			EndIF
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
	EndIF
	IF cOpc = 2 .and. cCod == TRB->F2_VEND4
		cCod := TRB->F2_VEND4
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
		
		While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
			
			IF SD2->D2_TES $ '594/902/903'  //Nao considero os itens nao agregados
				SD2->( dbSkip() )
				Loop
			EndIF
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )
			
			//--Vlr.Total Faturado
			IF SF4->F4_DUPLIC = 'S' .and. ! cGrupo $ "CARC" //Total Faturado
				nTotGer += SD2->D2_TOTAL
			EndIF

					
			//--Total Vendas Servico incluindo consertos
			IF SF4->F4_DUPLIC = 'S' .and. cGrupo $ "SERV/CI/SC" //Total SERVICO
				nTotVlr += SD2->D2_TOTAL
			EndIF
								
			IF cGrupo $ "0001" .or. SD2->D2_TES = '503' // Grupo de Pneus novos
				nTotNovo += SD2->D2_TOTAL
			EndIF
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
	EndIF
	IF cOpc = 3 .and. cCod == TRB->F2_VEND5
		cCod := TRB->F2_VEND5
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
		
		While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
			
			IF SD2->D2_TES $ '594/902/903'  //Nao considero os itens nao agregados
				SD2->( dbSkip() )
				Loop
			EndIF
			
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
			SB1->(dbSetOrder(1))
			SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
			cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )
			
			//--Vlr.Total Faturado
			IF SF4->F4_DUPLIC = 'S' .and. ! cGrupo $ "CARC" //Total Faturado
				nTotGer += SD2->D2_TOTAL
			EndIF
					
			//--Total Vendas Servico incluindo consertos
			IF SF4->F4_DUPLIC = 'S' .and. cGrupo $ "SERV/CI/SC" //Total SERVICO
				nTotVlr += SD2->D2_TOTAL 
			EndIF
			
			IF cGrupo $ "0001" .or. SD2->D2_TES = '503' // Grupo de Pneus novos
				nTotNovo += SD2->D2_TOTAL				
			EndIF
			
			
			dbSelectArea("SD2")
			dbSkip()
		EndDo
	EndIF
	
   	cCod := IIF (cOpc = 1,TRB->F2_VEND3,IIF(cOpc = 2,TRB->F2_VEND4,TRB->F2_VEND5))
	
	dbSelectArea("TRB")
	TRB->(dbSkip())
	
	IF cOpc = 1 .and. cCod != TRB->F2_VEND3
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3")+cCod)
		dbSelectArea("TMP")
		Reclock("TMP",.T.)
			TMP->TMP_VEND    := cCod
			TMP->TMP_NOME    := Alltrim(SA3->A3_NOME)
			TMP->TMP_ORDEM   := "1"
			TMP->TMP_VLFAT   := nTotGer
			TMP->TMP_SERV    := nTotVlr
			TMP->TMP_NOVO    := nTotNovo
		MsUnlock()
		nTotVlr  := nTotGer  := nTotNovo := 0
		cCod := TRB->F2_VEND3
	EndIF
	IF cOpc = 2 .and. cCod != TRB->F2_VEND4
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3")+cCod)
		dbSelectArea("TMP")
		Reclock("TMP",.T.)
			TMP->TMP_VEND    := cCod
			TMP->TMP_NOME    := Alltrim(SA3->A3_NOME)
			TMP->TMP_ORDEM   := "2"
			TMP->TMP_VLFAT   := nTotGer
			TMP->TMP_SERV    := nTotVlr
			TMP->TMP_NOVO    := nTotNovo
		MsUnlock()
		nTotVlr  := nTotGer  := nTotNovo := 0
		cCod := TRB->F2_VEND4
	EndIF
	IF cOpc = 3 .and. cCod != TRB->F2_VEND5
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3")+cCod)
		dbSelectArea("TMP")
		Reclock("TMP",.T.)
			TMP->TMP_VEND    := cCod
			TMP->TMP_NOME    := Alltrim(SA3->A3_NOME)
			TMP->TMP_ORDEM   := "3"
			TMP->TMP_VLFAT   := nTotGer
			TMP->TMP_SERV    := nTotVlr
			TMP->TMP_NOVO    := nTotNovo
		MsUnlock()
		nTotVlr  := nTotGer  := nTotNovo := 0
		cCod := TRB->F2_VEND5
	EndIF
EndDo

dbSelectArea("TRB")
TRB->(dbCloseArea())

Return
