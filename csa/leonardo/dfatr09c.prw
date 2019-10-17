/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DFATR09   �Autor  � Reinaldo Caldas    � Data �  27/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Resumo de vendas por periodo                               ���
�������������������������������������������������������������������������͹��
���Uso       � Durapol Renovadora de Pneus LTDA.                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DFATR09()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Este relatorio tem a finalidade de demonstrar o total faturado dos clientes "
Private cDesc2      := "atendidos por seus motoristas, vendedores, indicadores em um periodo."
Private cDesc3      := "Resumo de Vendas por periodo"
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 132
Private tamanho     := "G"
Private nomeprog    := "DFATR09"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Resumo de Vendas por periodo"
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := " "
Private Cabec2      := " "
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DFATR09"
Private _cPerg     	:= "DFAT09"

Private cString 	:= "SF2"

dbSelectArea("SF2")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

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

aOrd := {"Por motorista","Por vendedor","Por indicador"}

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ImpRel   �Autor  � Reinaldo Caldas    � Data �  17/08/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para impressao do relatorio                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpRel()

LOCAL _cQry := cVend := ""
LOCAL _aTam    := _aEstrutura := {}
LOCAL nOrdem   := aReturn[8]
Local Titulo   := Titulo + ' - ' + aOrd[nOrdem]
LOCAL nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := 0
LOCAL nRdRecap := nRdPneu  := nRdRec  := nRdAsTec := nTtAsTec := nRdNovo  := nRdVlr := 0
LOCAL Cabec1   := "Periodo de " + DtoC(mv_par01) + " a " + DtoC(mv_par02)
LOCAL Cabec2   := " Cliente  Nome Cliente                                           Vlr.Recap                    Ref.  Rec.     Vlr.Ass.Tec.   Vlr.Mercantil  Vlr.Total        "
//"Cliente Nome Cliente                          Vlr.Recap.   Ref. Rec.  Vlr.Ass.Tec.  Vlr.Mercantil   Vlr.Total      "				  

ProcRegua(100)

_aTam := TamSX3("F2_FILIAL")
aAdd(_aEstrutura,{"TMP_FIL"     ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_CLIENTE")
aAdd(_aEstrutura,{"TMP_CLI"     ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("F2_LOJA")
aAdd(_aEstrutura,{"TMP_LOJA"    ,"C",_aTam[1],_aTam[2]})
_aTam := TamSX3("A1_NOME")
aAdd(_aEstrutura,{"TMP_NOME"    ,"C",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_VEND"    ,"C",6       ,0       })                                                            
_aTam := TamSX3("F2_VALFAT")
aAdd(_aEstrutura,{"TMP_VLFAT"   ,"N",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_VLSRV"   ,"N",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_VLASS"   ,"N",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_NOVO"    ,"N",_aTam[1],_aTam[2]})
aAdd(_aEstrutura,{"TMP_REF"     ,"N",4,0})
aAdd(_aEstrutura,{"TMP_REC"     ,"N",4,0})

cNomArq := CriaTrab(_aEstrutura,.T.)

dbUseArea(.T.,,cNomArq,"TMP")

dbSelectArea("TMP")
IndRegua("TMP",cNomArq,"TMP_VEND+Descend(Strzero(TMP_VLFAT,11,2))",,,"Selecionando Registros")

dbSetIndex(cNomArq+OrdbagExt())
GeraTRB(nOrdem)

dbSelectArea("TMP")
dbGotop()
//IF !Empty(TMP->TMP_VEND)
	cVend := TMP->TMP_VEND
	
	While ! Eof()
		IF lEnd
			@Prow()+1, 001 Psay "Cancelado pelo operador "
			Exit
		EndIF
		
		IncProc()
		
		IF nLin > 60
			Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
			nLin := 9
			SA3->(dbSetOrder(1))
			SA3->(dbSeek(xFilial("SA3")+TMP->TMP_VEND))
			@ nLin, 001 Psay IIF(nOrdem = 1,"Motorista : "+Alltrim(SA3->A3_NOME),;
			IIF(nOrdem = 2,"Vendedor : "+Alltrim(SA3->A3_NOME),"Indicador : "+Alltrim(SA3->A3_NOME)))
			nLin += 2
		EndIF
		IF cVend != TMP->TMP_VEND
			SA3->(dbSetOrder(1))
			SA3->(dbSeek(xFilial("SA3")+TMP->TMP_VEND))
			@ nLin, 001 Psay SA3->A3_NOME
			nLin ++
		EndIF
/*      10                                                  60             75              92   97   102            117            132                 
12345678901234567890123456789012345678901234567890123456789012345678901234567890182234567890123456789012345678901234567890
Cliente Nome Cliente                                         Vlr.Recap.    Vlr.Conserto    Ref. Rec.  Vlr.Ass.Tec.  Vlr.Mercantil   Vlr.Total      
xxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999.999.999.99 999.999.999.99  9999 9999 999.999.999.99 999.999.999.99 999.999.999.99
*/
	@ nLin, 001 Psay TMP->TMP_CLI
	@ nLin, 010 Psay Substr(TMP->TMP_NOME,1,40)
	@ nLin, 060 Psay TMP->TMP_VLSRV Picture "@E 999,999,999.99"
	@ nLin, 092	Psay TMP->TMP_REF   Picture "@E 9999"
	@ nLin, 097	Psay TMP->TMP_REC   Picture "@E 9999"
	@ nLin, 102	Psay TMP->TMP_VLASS Picture "@E 999,999,999.99"
	@ nLin, 117 Psay TMP->TMP_NOVO  Picture "@E 999,999,999.99"
	@ nLin, 132 Psay TMP->TMP_VLFAT Picture "@E 999,999,999.99"
		
	
		nLin ++
		
		nTotVlr  += TMP->TMP_VLFAT
		nTtPneu  += TMP->TMP_REF
		nTotRec  += TMP->TMP_REC 
		nTtAsTec += TMP->TMP_VLASS
		nTotNovo += TMP->TMP_NOVO
		nTtRecap += TMP->TMP_VLSRV
			
		cVend := TMP->TMP_VEND
		
		dbSelectArea("TMP")
		TMP->(dbSkip())
		
		IF cVend != TMP->TMP_VEND
			nLin ++
			
			nRdRecap += nTtRecap 
			nRdPneu  += nTtPneu
			nRdRec   += nTotRec
			nRdAsTec += nTtAsTec
			nRdNovo  += nTotNovo
			nRdVlr   += nTotVlr
			
			@ nLin, 001 Psay "SubTotal : "
			@ nLin, 042 Psay nTtRecap Picture "@E 999,999,999.99"
			@ nLin, 057	Psay nTtPneu  Picture "@E 9999"
			@ nLin, 062	Psay nTotRec  Picture "@E 9999"
			@ nLin, 067	Psay nTtAsTec Picture "@E 999,999,999.99"
			@ nLin, 082 Psay nTotNovo Picture "@E 999,999,999.99"
			@ nLin, 097 Psay nTotVlr  Picture "@E 999,999,999.99"
		
			nLin += 2
			
			nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := 0
		EndIF
	EndDo
	
	nLin ++
//EndIF

IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	@ nLin, 001 Psay "Total : "
	@ nLin, 042 Psay nRdRecap Picture "@E 999,999,999.99"
    @ nLin, 057	Psay nRdPneu  Picture "@9999"
	@ nLin, 062	Psay nRdRec   Picture "@9999"
	@ nLin, 067	Psay nRdAsTec Picture "@E 999,999,999.99"
	@ nLin, 082 Psay nRdNovo  Picture "@E 999,999,999.99"
	@ nLin, 097 Psay nRdVlr   Picture "@E 999,999,999.99"

	Roda(cbcont,cbtxt,"M")
EndIF

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

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


Static Function GeraTRB(nOrdem)

LOCAL _cQry := ""
LOCAL nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := 0

IF Select("TRB") > 0
	TRB->(dbCloseArea())
EndIF

_cQry := "select F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_VEND3, F2_VEND4, F2_VEND5 "
_cQry += " from " + RetSqlName("SF2")+ " SF2 "
_cQry += " where SF2.D_E_L_E_T_ = ' ' "
_cQry += " and F2_FILIAL = '" + xFilial("SF2") + "' "
_cQry += " and F2_EMISSAO >= '" + DtoS(mv_par01) + "' and F2_EMISSAO <= '" + DtoS(mv_par02) + "' "
IF nOrdem = 1
	_cQry += " and F2_VEND3 >= '" + mv_par03 + "' and F2_VEND3 <= '" + mv_par04 + "' "
	_cQry += " order by F2_CLIENTE||F2_VEND3 "
ElseIF nOrdem = 2
	_cQry += " and F2_VEND4 >= '" + mv_par05 + "' and F2_VEND4 <= '" + mv_par06 + "' "
	_cQry += " order by F2_CLIENTE||F2_VEND4 "
Else
	_cQry += " and F2_VEND5 >= '" + mv_par07 + "' and F2_VEND5 <= '" + mv_par08 + "' "
	_cQry += " order by F2_CLIENTE||F2_VEND5 "
EndIF

_cQry := ChangeQuery(_cQry)
memowrite("novo.sql",_cQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

While ! Eof()
	
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE)
	
	While !Eof() .and. TRB->F2_FILIAL+TRB->F2_DOC+TRB->F2_SERIE == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE
		
		IF SD2->D2_TES $ '594/902' //Nao considero os itens nao agregados
			//--Qtd.Reforma
			SD2->(dbSkip())
			Loop
		EndIF
		
		SF4->(dbSetOrder(1))
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
		SF2->( dbSetOrder(1) )
		SF2->( dbSeek(xFilial("SF2") + SD2->D2_DOC ) )
		
		SB1->(dbSetOrder(1))
		SB1->( dbSeek(xFilial("SB1") + SD2->D2_COD,.F.) )
		cGrupo  := AllTrim( Upper(SB1->B1_GRUPO) )
		
		//--Vlr.Recapagem		
		IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) $ "SERV/CI/SC" //Vlr.Recapagem			
			IF SF2->F2_TIPO = 'N'
				nTtRecap += SD2->D2_TOTAL
			EndIf	
		EndIF
		
		IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) == "SERV" //Total de reformas
			IF SF2->F2_TIPO = 'N'
				nTtPneu += SD2->D2_QUANT
			EndIF	
		EndIF
		
		//--Qtd.Recusado
		IF SF4->F4_DUPLIC = 'N' .and. Alltrim(cGrupo) == "SERV" //Total de reformas
			IF SF2->F2_TIPO = 'N'
				nTotRec += SD2->D2_QUANT
			EndIF	
		EndIF		
		//--Vlr.Assitencia Tecnica
		IF SF4->F4_DUPLIC = 'S' .and. Alltrim(cGrupo) == "ATEC" 
			IF SF2->F2_TIPO = 'N'
				nTtAsTec += SD2->D2_TOTAL
			EndIF	
		EndIF
		//--Vlr.Mercantil (Pneus novos)
		IF cGrupo $ "0001" .or. SD2->D2_TES = '503' // Grupo de Pneus novos
			IF SF2->F2_TIPO = 'N'
				nTotNovo += SD2->D2_TOTAL
			EndIF	
		EndIF
		//--Vlr.Total Faturado
		IF SF4->F4_DUPLIC = 'S' .and. ! cGrupo $ "CARC" //Total Faturado
			IF SF2->F2_TIPO = 'N'
				nTotVlr += SD2->D2_TOTAL
			EndIF	
		EndIF
		dbSelectArea("SD2")
		dbSkip()
	EndDo

	
	cCodCli := TRB->F2_CLIENTE+TRB->F2_LOJA
	cCodVen := IIF(nOrdem = 1,TRB->F2_VEND3,IIF(nOrdem = 2,TRB->F2_VEND4,TRB->F2_VEND5))
	
	dbSelectArea("TRB")
	TRB->(dbSkip())
	
	IF cCodCli != TRB->F2_CLIENTE+TRB->F2_LOJA
		
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial()+cCodCli))
		
		dbSelectArea("TMP")
		Reclock("TMP",.T.)
			TMP->TMP_FIL     := TRB->F2_FILIAL
			TMP->TMP_CLI     := Substr( cCodCli,1,6)
			TMP->TMP_NOME    := Alltrim(SA1->A1_NREDUZ)
			TMP->TMP_VEND    := cCodVen
			TMP->TMP_VLSRV   := nTtRecap
			TMP->TMP_REF     := nTtPneu
			TMP->TMP_REC     := nTotRec
			TMP->TMP_VLASS   := nTtAsTec
			TMP->TMP_NOVO    := nTotNovo
			TMP->TMP_VLFAT   := nTotVlr
		MsUnlock()
		
		nTotVlr  := nTtPneu  := nTotRec := nTtAsTec := nTotNovo := nTtRecap := 0
				
	EndIF
EndDo

dbSelectArea("TRB")
dbCloseArea()

Return
