#Include 'rwmake.ch'                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDMPAGAR ºAutor  ³Marcio Domingos     º Data ³  19/01/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Valida o valor das movimentacoes financeiras a pagar usando º±±
±±º          ³os seguintes criterios:                                     º±±
±±º          ³* o valor da movimentacao deve estar disponivel no caixa da º±±
±±º          ³loja;                                                       º±±
±±º          ³* o valor da movimentacao nao pode ser maior que o limite deº±±
±±º          ³compra diario (SLJ->LJ_LIMCOM);                             º±±
±±º          ³* o valor acumulado das movimentacoes no mes nao pode ser   º±±
±±º          ³maior que o limite mensal (SLJ->LJ_LIMMES);                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nao se aplica                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³Esta rotina e chamada atraves da validacao do usuario do    º±±
±±º          ³campo E5_VALOR.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                      	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMarcio Dom³07/02/06³Alteracao no tratamento da devolucao de troca no   º±±
±±º          ³        ³SE5, a expressao 'DEV.\TROCA" foi substituida pelo º±±
±±º          ³        ³parametro MV_NATDEV								  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³13797 - Della Via Pneus                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VldMPagar(_nValor)

Local _aArea	:= GetArea()
Local _nTotMes
Local _dDataIni
Local _dDataFim     

If cRecPag # 'P'
	Return .T.
Endif	

DbSelectArea("SLJ")
DbSetOrder(1)                     
DbGoTop()
If !DbSeek(xFilial("SLJ")+StrZero(Val(SM0->M0_CODFIL),6))
	MsgBox("Nao foram definidos os limites Mensais e de Compras para esta filial !")
	RestArea(_aArea)
	Return .F.
Endif	

If _nValor > SLJ->LJ_LIMCOM
	MsgBox("Valor superior ao limite de compra !")
	RestArea(_aArea)
	Return .F.
Endif	                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Calcula Saldo de Valores em Dinheiro no Caixa
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
dbSelectArea("SE5")
dbSetOrder(1)
dbGoTop()
private nTotDin:= 0
if dbSeek(xfilial("SE5")+DTOS(dDataBase)+SLF->LF_COD,.T.)
	do While E5_FILIAL==xFilial("SE5") .and. E5_DATA==dDataBase .and. E5_BANCO==SLF->LF_COD
		If E5_RECPAG=="R" .and. E5_TIPODOC=="LJ" .and. Trim(E5_TIPO)=="R$" //Venda em Dinheiro
			nTotDin+= E5_VALOR
		elseif E5_RECPAG=="R" .and. E5_MOEDA=="R$" .and. EMPTY(E5_TIPO) .and. EMPTY(E5_TIPODOC) // Lancamentos a Receber
			nTotDin+= E5_VALOR					
		elseif E5_RECPAG=="R" .and. E5_TIPODOC=="TR" .and. Trim(E5_MOEDA)=="TC" .and. Trim(E5_NATUREZ)=="FUNDO CX" // Fundo de Caixa
			nTotDin+= E5_VALOR		
		Elseif E5_RECPAG=="R" .and. E5_TIPODOC=="VL" .and. E5_MOEDA=="R$" //Recebimento de Titulos
			nTotDin+= E5_VALOR		
		elseif (E5_RECPAG=="P" .and. E5_MOEDA=="R$" .and. EMPTY(E5_TIPO) .and. EMPTY(E5_TIPODOC)) .or.;
			   (E5_RECPAG=="P" .and. E5_MOEDA=="R$" .and. E5_TIPODOC=="TR" .and. Trim(E5_NATUREZ)=="SANGRIA") //Despesas e sangrias
			nTotDin-= E5_VALOR
//elseif E5_RECPAG=="P" .and. TRIM(E5_TIPO)=="R$" .and. E5_TIPODOC=="LJ" .and. Trim(E5_NATUREZ)=="DEV./TROCA" //Troca
		elseif E5_RECPAG=="P" .and. TRIM(E5_TIPO)=="R$" .and. E5_TIPODOC=="LJ" .and. Trim(E5_NATUREZ)==&(Trim(GetMv("MV_NATDEV"))) // "DEV./TROCA" //Troca
			If SF1->(dbSeek(xFilial("SF1")+SE5->E5_NUMERO+SE5->E5_PREFIXO+SE5->E5_CLIFOR+SE5->E5_LOJA))
				nTotDin-= E5_VALOR
			EndIf
		EndIf
		dbSkip()
	Enddo
EndIf

If _nValor > nTotDin 
	MsgBox("Valor indisponivel no caixa !")
	RestArea(_aArea)
	Return .F.
Endif

// Verifica se o Tipo de despesa abate ou nao do saldo
DbSelectArea("SED")
DbSetOrder(1)

If Empty(M->E5_NATUREZ)
	MsgBox("Natureza nao informada !")
	RestArea(_aArea)
	Return .F.
Endif	
	
If DbSeek(xFilial("SED")+M->E5_NATUREZ)
	If SED->ED_ABSALDO <> 'S'
		Return .T. // se a natureza nao abate nao calcula o saldo mensal
	Endif                 
Else
	MsgBox("Natureza nao encontrada !")
	RestArea(_aArea)
	Return .F.
Endif

_dDataIni	:= FirstDay(dDatabase)
_dDataFim	:= LastDay(dDatabase)

DbSelectArea("SE5")
DbSetOrder(1)                          
DbGotop()
DbSeek(xFilial("SE5")+Dtos(_dDataIni),.T.)

_nTotMes := 0
Do While 	SE5->E5_MSFIL	==	SM0->M0_CODFIL			.And.;
			SE5->E5_DATA	>= 	_dDataIni				.And.;
			SE5->E5_DATA 	<= 	_dDataFim				.And. !Eof()

	If SE5->E5_BANCO # SLF->LF_COD	.Or. 	SE5->E5_RECPAG # 'P' .Or. SE5->E5_NATUREZ = 'SANGRIA'
		DbSkip()
		Loop			                                        
	Endif
	
	
	If Empty(M->E5_NATUREZ)
		MsgBox("Natureza nao informada !")
		RestArea(_aArea)
		Return .F.
	Endif	

	DbSelectArea("SED")
	DbSetOrder(1)
	
	If DbSeek(xFilial("SED")+SE5->E5_NATUREZ)
		If SED->ED_ABSALDO <> 'S'
			DbSelectArea("SE5")
			DbSkip()
			loop
		Endif
	Else                       
		DbSelectArea("SE5")
		DbSkip()
		loop
	Endif		
	
	_nTotMes += SE5->E5_VALOR

	DbSelectArea("SE5")
	Dbskip()
	
Enddo                             

_nTotMes += _nValor

If _nTotMes > SLJ->LJ_LIMMES
	MsgBox("Valor total de compras no mes superior ao limite mensal ")		
	RestArea(_aArea)
	Return .F.      
Endif

RestArea(_aArea)
Return .T.	
	