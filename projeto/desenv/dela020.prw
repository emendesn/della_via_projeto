#INCLUDE "protheus.ch"
#DEFINE _FORMATEF	"CC;CD"     //Formas de pagamento que utilizam opera��o TEF para valida��o
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020A  �Autor  �Norbert Waage Junior   � Data �  02/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Validacao da apolice do sinistro no campo LR_SINISTR          ���
����������������������������������������������������������������������������͹��
���Parametros� Nao se aplica                                                 ���
����������������������������������������������������������������������������͹��
���Retorno   � Verdadeiro se confirmou                                       ���
���          � Falso caso contrario                                          ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pela validacao do campo LR_SINISTR           ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���Edison    �18/01/06�      �- Retirada do IndRegua para utilizacao de      ���
���Maricate  �        �      �  indice padrao da tabela SE1.                 ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020A()

Local aArea		:=	GetArea()
Local cMsgErr	:=	""
Local oDlg1		:=	NIL
Local oButCanc	:=	NIL
Local oButConf	:=	NIL
Local lRet		:=	.F.

Local nPosKm	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_KMATU"   })
Local nPosRes	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_RESIDUO" })
Local nPosLacre	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_LACRE"   })
Local nPosPerCl	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })
Local nPosCotMo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_CODMOT"  })
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local nPosExam	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_EXAMIN"  })
Local nPosCert	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_CERTIF"  })
Local nPosPrUn	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VRUNIT"  })

//����������������������������������������Ŀ
//�Variaveis utilizadas na tela de sinistro�
//������������������������������������������
Private oKm		:=	NIL
Private nKm		:=	aCols[N][nPosKm]
Private nResiduo:=	aCols[N][nPosRes]
Private nPerCli	:=	aCols[N][nPosPerCl]
Private cLacre	:=	aCols[N][nPosLacre]
Private cCodMot	:=	aCols[N][nPosCotMo]
Private cExamin	:=	aCols[N][nPosExam]
Private cCertif	:=	aCols[N][nPosCert]
Private cMotivo	:=	GetAdvFVal("PAA","PAA_DESC",xFilial("PAA")+cCodMot,1,"")

//����������������������������������������Ŀ
//�Valida o preenchimento do campo Sinistro�
//������������������������������������������
If Empty(M->LR_SINISTR)
	aCols[N][nPosItApo] := Space(TamSx3("LR_APOIT")[1])
	P_DelA015A(aCols[N][nPosPrUn],.T.)
	RestArea(aArea)
	Return .T.
EndIf

//������������������������������������Ŀ
//�Valida o numero da apolice informada�
//��������������������������������������
If !(lRet:= _VldApol(xFilial("PA8")+M->(LR_SINISTR+LQ_CLIENTE+LQ_LOJA)+aCols[N][nPosItApo],1))
	aCols[N][nPosItApo] := Space(TamSx3("LR_APOIT")[1])
	RestArea(aArea)
	Return lRet
EndIf

//�����������������������������������������������Ŀ
//�Validacao de quantidade informada para sinistro�
//�������������������������������������������������
If aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_QUANT" })] > 1
	ApMsgAlert("O sinistro se aplica a apenas uma unidade","Quantidade excedida")
	RestArea(aArea)
	Return .F.
EndIf
                                                                                             
lRet := .F.

//�����������Ŀ
//�Define tela�
//�������������	
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 205,600 PIXEL TITLE "Sinistro" of oMainWnd

//������Ŀ
//�Labels�
//��������
@ 3,5 TO 75,296 LABEL "" OF oDlg1 PIXEL

//������Ŀ
//�Botoes�
//��������
Define SButton From 80,230 Type 1 Enable of oDlg1 Action (IIf(_GrvTela(),(oDlg1:End(),lRet := .T.),.F.))
Define SButton From 80,270 Type 2 Enable of oDlg1 Action (oDlg1:End())

//������������������Ŀ
//�Campo Kilometragem�
//��������������������
@11,10 SAY "Kilometragem" SIZE 40,7 PIXEL OF oDlg1
@10,50 MSGET oKm Var nKm Size 50, 7 PICTURE "999999" PIXEL OF oDlg1

//�����������Ŀ
//�Campo Lacre�
//�������������
@26,10 SAY  "Lacre" SIZE 40,7 PIXEL OF oDlg1
@25,50 MSGET cLacre Size 50, 7 PICTURE "@ 9999999" PIXEL OF oDlg1

//�����������������Ŀ
//�Campo Cod. Motivo�
//�������������������
@41,10 SAY  "Cod. Motivo" SIZE 40,7 PIXEL OF oDlg1
@40,50 MSGET cCodMot F3 "PAA" Valid _VldMot(cCodMot) Size 53, 7 PICTURE "@ 9999999" PIXEL OF oDlg1

//�����������������Ŀ
//�Campo Examinador �
//�������������������
@56,10 SAY  "Examinador" SIZE 40,7 PIXEL OF oDlg1
@56,50 MSGET cExamin Size 53, 7 PICTURE "@!" PIXEL OF oDlg1

//�������������Ŀ
//�Campo Residuo�                                                         
//���������������
@11,150 SAY  "Res�duo" SIZE 40,7 PIXEL OF oDlg1
@10,190 MSGET nResiduo Size 50, 7 PICTURE "@E 9,999.99" PIXEL OF oDlg1

//���������������Ŀ
//�Campo % Cliente�
//�����������������
@26,150 SAY  "%Bonif. Cliente" SIZE 40,7 PIXEL OF oDlg1
@25,190 MSGET nPerCli Valid (nPerCli >= 0 .And. nPerCli <= 100) Size 50, 7 PICTURE "@E 999.99" PIXEL OF oDlg1    

//������������������Ŀ
//�Campo Desc. Motivo�
//��������������������
@41,150 SAY  "Motivo" SIZE 40,7 PIXEL OF oDlg1
@40,190 MSGET cMotivo When .F. Size 96, 7 PICTURE "@!" PIXEL OF oDlg1  

//�����������������Ŀ
//�Campo Certificado�
//�������������������
@56,150 SAY  "Certificado"   SIZE 40,7 PIXEL OF oDlg1
@56,190 MSGET cCertif  Size 53, 7 PICTURE "@!" PIXEL OF oDlg1

//�����������������Ŀ
//�Foca o botao 'Ok'�
//�������������������
oKm:SetFocus()

ACTIVATE MSDIALOG oDlg1 CENTERED 
                        
//�������������������������������Ŀ
//�Se houve erros, limpa os campos�
//���������������������������������
If !lRet
	aCols[N][nPosApo] 	:= Space(TamSx3("LR_SINISTR")[1])
	aCols[N][nPosItApo]	:= Space(TamSx3("LR_APOIT")[1])
EndIf

//�����������������Ŀ
//�Atualiza GetDados�
//�������������������
oGetVA:oBrowse:Refresh()

RestArea(aArea)

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020B  �Autor  �Norbert Waage Junior   � Data �  08/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �mBrowse para consulta de seguros                               ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo menu do Sigaloja                           ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020B()

Private cCadastro := "Cadastro de seguros"

Private _nMesSeg := GetMv("FS_DEL010")

Private aLegenda :=	{{"BR_VERDE"		, "Segurado"	},;
					{ "BR_VERMELHO"  	, "Sinistrado"	},;
					{ "BR_AZUL"      	, "Devolvido"	},;
					{ "BR_AMARELO"   	, OemtoAnsi("Or�ado")},;
					{ "BR_PRETO"		, "Vencido"		}}
					
Private aRotina :=	{{"Pesquisar","AxPesqui",0,1},;
					{"Visualizar","AxVisual",0,2},;
					{"Aviso Sinistro","P_DELR007()",0,2},;
					{"Etiqueta","U_DVLOJF08(PA8->PA8_LOJSN, PA8->PA8_APOLIC, PA8->PA8_ITEM)",0,2},;
					{"Legenda","BrwLegenda(cCadastro,'Legenda',aLegenda)",0,4}}

//�����������������Ŀ
//�Definicao legenda�
//�������������������
Private aCores	:=	{{"!Empty(PA8->PA8_DTSN)", 'BR_VERMELHO'},;
					 {"!Empty(PA8->PA8_DTSG).And.(dDatabase - PA8->PA8_DTSG > (_nMesSeg * 30))", 'BR_PRETO'},;
					 {"Empty(PA8->PA8_NFSG)", 'BR_AMARELO'},;
					 {"!Empty(PA8->PA8_DEVOL)", 'BR_AZUL'},;
					 {"!Empty(PA8->PA8_NFSG).And.Empty(PA8->PA8_DTSN)", 'BR_VERDE'}}


dbSelectArea("PA8")
dbSetOrder(1)
mBrowse( 6,1,22,75,"PA8",,,,,,aCores)
                   
Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020C  �Autor  �Norbert Waage Junior   � Data �  09/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Filtro para selecao do motivo de sinistro                      ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro caso o registro possa ser exibido                   ���
���          �Falso caso contrario                                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na montagem do F3 para a tabela PAA             ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020C()

Local cGrupo 	:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PRODUTO"})],1,"")
Local cTpProd	:= GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cGrupo,1,"")

Return PAA->PAA_TIPOPR == cTpProd

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020D  �Autor  �Norbert Waage Junior   � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Grava informacoes do sinistro apos a conclusao da venda        ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo ponto de entrada LJ7002                    ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020D()

Local aArea		:=	GetArea()   
Local aAreaPA8	:=	PA8->(GetArea()) 
Local aAreaSE1	:=	SE1->(GetArea())
Local nPerc		:=	0 
Local nPerCli	:=	0
Local nPerSeg	:=	0
Local nPerCorr	:=	0
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosVlrIt	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VLRITEM" })
Local nPosPerCl	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })
Local nX

//�������������Ŀ
//�Posiciona SE1�
//���������������
DbSelectArea("SE1")
DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
DbSeek(xFilial("SE1")+SL1->L1_SERIE+SL1->L1_DOC)

//���������������������Ŀ
//�Grava campo historico�
//�����������������������
While !Eof() .And.;
	SE1->E1_FILIAL	==	xFilial("SE1")	.And.;
	SE1->E1_PREFIXO	==	SL1->L1_SERIE	.And.;
	SE1->E1_NUM		==	SL1->L1_DOC
	
	RecLock("SE1",.F.)
	SE1->E1_HIST	:=	"CF" + SL1->L1_DOC + "/" +SL1->L1_SERIE
	MsUnLock()
	
	DbSkip()                                                   
	
End

//����������������������Ŀ
//�Abre tabela de seguros�
//������������������������
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM    

//�����������������������������������������������������������Ŀ
//�Percorre os itens da venda                                 �
//�Obs.: Ao inves de percorrer o SL2, percorro o aCols, pois o�
//�campo L2_VLRITEM pode ter seu valor alterado antes da      �
//�gravacao, quando usa-se uma NCC, por exemplo.              �
//�������������������������������������������������������������
For nX := 1 to Len(aCols)
	
	//�������������������������Ŀ
	//�Linha valida e sinistrada�
	//���������������������������
	If !aCols[nX][Len(aCols[nX])] .And. !Empty(aCols[nX][nPosApo])

		If PA8->(DbSeek(xFilial("PA8") + aCols[nX][nPosApo] + SL1->L1_CLIENTE + SL1->L1_LOJA + aCols[nX][nPosItApo]))
			
			//�������������������������Ŀ
			//�Percentual de bonificacao�
			//���������������������������
			nPerc	:=	aCols[nX][nPosPerCl] / 100 
			
			//�������������������������������������������������Ŀ
			//�Valor do produto menor ou igual ao valor segurado�
			//���������������������������������������������������
			If aCols[nX][nPosVlrIt] <= PA8->PA8_VPROSG
			
				nPerCli	:=	aCols[nX][nPosVlrIt] * (1 - nPerc)
				nPerSeg	:=	(aCols[nX][nPosVlrIt] * nPerc) + ((PA8->PA8_VPROSG - aCols[nX][nPosVlrIt] ) * nperc)
				nPerCorr:=	((PA8->PA8_VPROSG - aCols[nX][nPosVlrIt] ) * nperc)

			//�������������������������������������������Ŀ
			//�Valor do produto superior ao valor segurado�
			//���������������������������������������������			
			Else 

				nPerCli	:=	aCols[nX][nPosVlrIt] * (1 - nPerc)
				nPerSeg	:=	PA8->PA8_VPROSG * nPerc
				nPerCorr:=	(aCols[nX][nPosVlrIt] - PA8->PA8_VPROSG) * nPerc

			EndIf           

			//�����������������������������Ŀ
			//�Grava campos do PA8 - Seguros�
			//�������������������������������
			RecLock("PA8",.F.)

			PA8->PA8_LOJSN	:= SL1->L1_FILIAL				
			PA8->PA8_ORCSN	:= SL1->L1_NUM
			PA8->PA8_NFSN	:= SL1->L1_DOC 
			PA8->PA8_SRSN	:= SL1->L1_SERIE
			PA8->PA8_DTSN	:= dDataBase 
			PA8->PA8_CPROSN	:= gdFieldGet("LR_PRODUTO", nX)
			PA8->PA8_VPROSN	:= gdFieldGet("LR_VLRITEM", nX)
			PA8->PA8_KMSN	:= gdFieldGet("LR_KMATU"  , nX)
			PA8->PA8_RESID	:= gdFieldGet("LR_RESIDUO", nX)
			PA8->PA8_LACRE	:= gdFieldGet("LR_LACRE"  , nX)
			PA8->PA8_CODMOT	:= gdFieldGet("LR_CODMOT" , nX)
			PA8->PA8_PERC	:= gdFieldGet("LR_PERCLI" , nX)
			PA8->PA8_EXAMIN	:= gdFieldGet("LR_EXAMIN" , nX)
			PA8->PA8_CERTIF	:= gdFieldGet("LR_CERTIF" , nX)
			PA8->PA8_VLRCLI	:= nPerCli
			PA8->PA8_VLRSEG	:= nPerSeg
			PA8->PA8_VLRCOR	:= nPerCorr  
			
			PA8->(MsUnLock())

		EndIf

	EndIf
	
Next nX

RestArea(aAreaSE1)
RestArea(aAreaPA8)
RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020E  �Autor  �Norbert Waage Junior   � Data �  14/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Atualiza campos e exclui registros das tabelas vinculadas      ���
���          �na exclusao da venda.                                          ���
����������������������������������������������������������������������������͹��
���Parametros�_cFilial - Numero da filial                                    ���
���          �_cNum    - Numero do orcamento de venda do seguro              ���
���          �_cDoc    - Numero do documento(E1_NUM)                         ���
���          �_cSerie  - Serie do documento                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo ponto de entrada LJ140DEL                  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020E(_cFilial,_cNum,_cDoc,_cSerie)

Local aArea		:=	GetArea()
Local aAreaPA8	:=	PA8->(GetArea())  
Local aAreaSE1	:=	SE1->(GetArea())
Local aRecnos	:=	{}
Local aVetor	:=	{}
Local nRegs		:=	0
Local nX

Private lMsErroAuto := .F.

//���������������������������Ŀ
//�Posiciona tabela de seguros�
//�����������������������������
DbSelectArea("PA8")
DbSetOrder(7) //PA8_FILIAL+PA8_LOJSN+PA8_ORCSN
DbSeek(xFilial("PA8") + _cFilial + _cNum)

While !Eof() .And.;
	PA8->PA8_FILIAL	==	xFilial("PA8")	.And.;
	PA8->PA8_LOJSN	==	_cFilial 		.And.;
	PA8->PA8_ORCSN	==	_cNum
	
	//��������������������������������������Ŀ
	//�Armazena registros a serem atualizados�
	//����������������������������������������
	AAdd(aRecnos,PA8->(Recno()))
	nRegs++
	
	DbSkip()                    
	
End	 	

//�������������������������������Ŀ
//�Atualiza itens do PA8 - Seguros�
//���������������������������������
For nX := 1 to nRegs

	DbGoTo(aRecnos[nX])
	
 	RecLock("PA8",.F.)

	PA8->PA8_LOJSN	:= ""
	PA8->PA8_ORCSN	:= ""
	PA8->PA8_NFSN	:= ""
	PA8->PA8_SRSN	:= ""
	PA8->PA8_DTSN	:= CtoD("  /  /  ")
	PA8->PA8_CPROSN	:= ""
	PA8->PA8_VPROSN	:= 0
	PA8->PA8_KMSN	:= 0
	PA8->PA8_RESID	:= 0
	PA8->PA8_LACRE	:= ""
	PA8->PA8_CODMOT	:= ""
	PA8->PA8_PERC	:= 0
	PA8->PA8_VLRCLI	:= 0
	PA8->PA8_VLRSEG	:= 0 	
	PA8->PA8_VLRCOR	:= 0
	PA8->PA8_EXAMIN	:= ""	//Incluido 14/08/06 - Regiane
	PA8->PA8_CERTIF	:= ""	//Incluido 14/08/06 - Regiane
 	
 	MsunLock()
	
Next nX    

//��������������������������������������Ŀ
//�Exclui titulos gerados pelos sinistros�
//����������������������������������������
DbselectArea("SE1")
DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

If DbSeek(xFilial("SE1")+_cSerie+_cDoc)
	
	//�����������������������������������������������������Ŀ
	//�Percorre SE1 - Contas a receber - Armazenando titulos�
	//�gerados pelas rotinas customizadas                   �
	//�������������������������������������������������������
	While !Eof() .And.;
		SE1->E1_FILIAL	==	xFilial("SE1")	.And.;
		SE1->E1_PREFIXO	==	_cSerie			.And.;
		SE1->E1_NUM		==	_cDoc	

		If	SE1->E1_SINISTR == "S"
			
			AADD(aVetor,{{"E1_PREFIXO"	,SE1->E1_PREFIXO	,nil},;
						{"E1_NUM"		,SE1->E1_NUM		,nil},;
						{"E1_PARCELA"	,SE1->E1_PARCELA	,nil},;
						{"E1_TIPO"		,SE1->E1_TIPO		,nil}})  

		EndIf

		SE1->(DbSkip())
		
	End

	//��������������������������������������������������Ŀ
	//�Exclui todos os titulos armazenados via msExecAuto�
	//����������������������������������������������������
	For nX := 1 to len(aVetor)

		MSExecAuto({|x,y| FINA040(x,y)},aVetor[nX],5)  

		If LMsErroAuto
			MostraErro()
			Break
		Endif

	Next nX

EndIf

RestArea(aAreaSE1)
RestArea(aAreaPA8)
RestArea(aArea)

Return Nil                       

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020F  �Autor  �Norbert Waage Junior   � Data �  08/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Verifica se as apolices da venda atual sao validas             ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet(.T.) - Permite a gravacao                                 ���
���          �lRet(.F.) - Impede a gravacao                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Chamada na confirmacao final da venda                          ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020F()

Local aArea		:=	GetArea()
Local aAreaPA8	:=	PA8->(GetArea())
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local lRet		:=	.T.
Local nLenCols	:=	Len(aCols)
Local nX

//�����������������������Ŀ
//�Posiciona PA8 - Seguros�
//�������������������������
DbSelectArea("PA8")
DbSetOrder(6) //PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

//��������������Ŀ
//�Percorre aCols�
//����������������
For nX := 1 to nLenCols

	If !Empty(aCols[nX][nPosApo]) .And. !ATail(aCols[nX])

		If	PA8->(DbSeek(xFilial("PA8") + aCols[nX][nPosApo] + M->(LQ_CLIENTE + LQ_LOJA) + aCols[nX][nPosItApo]))
			
			If !Empty(PA8->PA8_DTSN)
			
				//�����������������������������������Ŀ
				//�Apolice jah utlizada em outra venda�
				//�������������������������������������
				ApMsgAlert("A ap�lice utilizada nesta venda j� foi sinistrada, verifique","Inconsist�ncia")
				lRet := .F. 
				nX := nLenCols+1
				
			EndIf

		Else
            
			//���������������������������������������������Ŀ
			//�Apolice excluida ou informada de forma errada�
			//�����������������������������������������������
			ApMsgAlert("A ap�lice utilizada nesta venda n�o exite, verifique","Inconsist�ncia")
			lRet	:=	.F.
			nX := nLenCols+1

		EndIf

	EndIf

Next nX

RestArea(aAreaPA8)
RestArea(aArea)

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020G  �Autor  �Norbert Waage Junior   � Data �  09/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Calcula e gera titulos no contas a pagar para o uso de sinistro���
���          �, gerando titulos contra a corretora e contra a seguradora     ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Chamada pelo ponto de entrada LJ7002                           ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020G()

Local aArea		:=	GetArea()
Local aAreaPA8	:=	PA8->(GetArea())
Local aAreaSE1	:=	SE1->(GetArea())
Local aVetor	:=	{}
Local nDif		:=	0
Local nPerc		:=	0
Local nTotDif	:=	0  
Local nX		:=	0
Local cChave	:=	""
Local cCliCorr	:=	GetMv("FS_DEL019")	//Codigo/Loja da corretora
Local cLojCorr	:=	""
Local cCliSeg	:=	""
Local cLojSeg	:=	""
Local cNomSeg	:=	""
Local cArq		:=	""
Local cParcela	:= 	GetMv("MV_1DUP") //Letra ou numero da primeira parcela
Local dEmiss,dVencto,dVencRea := CtoD("  /  /  ")
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosVlrIt	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VLRITEM" })
Local nPosPerCl	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })

Private lmsErroAuto	:= .F. // variavel do execauto

DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM    

//�������������������������������������������������������������Ŀ
//�Percorre a Cols, calculando diferenca de precos e percentuais�
//�a ser pagos em cada titulo                                   �
//���������������������������������������������������������������
For nX := 1 to Len(aCols)

	If !aCols[nX][Len(aCols[nX])] .And. !Empty(aCols[nX][nPosApo])

		If PA8->(DbSeek(xFilial("PA8") + aCols[nX][nPosApo] + SL1->L1_CLIENTE + SL1->L1_LOJA + aCols[nX][nPosItApo]))
		
			nDif 	:= Abs(PA8->PA8_VPROSG - aCols[nX][nPosVlrIt])
			nPerc	:= (aCols[nX][nPosPerCl] / 100)
			
			If nDif > 0
				nTotDif  += (PA8->PA8_VPROSG * nPerc) - (aCols[nX][nPosVlrIt] * nPerc)
			EndIf

        EndIf

	EndIf

Next nX

//����������������������������������Ŀ
//�Se ha necessidade de gerar titulos�
//������������������������������������
If nTotDif > 0 

	cChave := xFilial('SE1')+SF2->F2_PREFIXO+SF2->F2_DOC
	
	//�����������������������������������������������������Ŀ
	//�Busca o numero/letra da ultima parcela para o tipo FI�
	//�������������������������������������������������������
	dbSelectArea("SE1")
	dbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If dbSeek(cChave)
		
		While !SE1->(Eof()) .And. (Alltrim(cChave) == Alltrim(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)))
			
			If AllTrim(SE1->E1_TIPO) == "FI"
				//���������������������������������������������������������Ŀ
				//�Armazena os dados do titulo para copia-los para a proxima�
				//�parcela                                                  �
				//�����������������������������������������������������������
		       	cParcela := SE1->E1_PARCELA
		       	cCliSeg	 := SE1->E1_CLIENTE
		       	cLojSeg  := SE1->E1_LOJA
		       	cNomSeg	 := SE1->E1_NOMCLI
		       	dEmiss	 := SE1->E1_EMISSAO
		       	dVencto  := SE1->E1_VENCTO
		       	dVencReA := SE1->E1_VENCREA
		  	EndIf
		       	
	       	SE1->(DbSkip())
		
		End                       
		
		cParcela := Soma1(cParcela)
		
	EndIf
	
	SE1->(DbSetOrder(1)) 
	
	//����������������������������������������Ŀ
	//�Monta array com as informacoes do titulo�
	//������������������������������������������
	aAdd(aVetor, {"E1_FILIAL" , xFilial("SE1")	  	  					, Nil}) //"#"})
	aAdd(aVetor, {"E1_PREFIXO", SL1->L1_SERIE	  	  					, Nil}) //"#"})
	aAdd(aVetor, {"E1_NUM"    , SL1->L1_DOC		  	   					, Nil}) //"#"})
	aAdd(aVetor, {"E1_PARCELA", cParcela	   	   	   					, Nil}) //"#"})
	aAdd(aVetor, {"E1_TIPO"   , "FI"			   	   					, Nil}) //"#"})
	aAdd(aVetor, {"E1_PORTADO", SL1->L1_OPERADO					 		, Nil})
	aAdd(aVetor, {"E1_NATUREZ", GetMV("MV_NATCRED")	   					, Nil})
	aAdd(aVetor, {"E1_CLIENTE", cCliSeg	   	   							, Nil})
	aAdd(aVetor, {"E1_LOJA"   , cLojSeg	  	   							, Nil})
	aAdd(aVetor, {"E1_NOMCLI" , cNomSeg			  						, Nil})
	aAdd(aVetor, {"E1_EMISSAO", dEmiss					 				, Nil})
	aAdd(aVetor, {"E1_VENCTO" , dVencto			   		  				, Nil})
	aAdd(aVetor, {"E1_VENCREA", dVencRea								, Nil})
	aAdd(aVetor, {"E1_VALOR"  , nTotDif									, Nil})
	aAdd(aVetor, {"E1_HIST"   , "CF" + SL1->L1_DOC + "/" +SL1->L1_SERIE, Nil})
	aAdd(aVetor, {"E1_ORIGEM" , "FINA040"				  				, Nil})
	aAdd(aVetor, {"E1_SINISTR", "S"						  				, Nil})	
	//aAdd(aVetor, {"INDEX"     , 1					   					, Nil})
    
	//����������������Ŀ
	//�Executa ExecAuto�
	//������������������
	msExecAuto({|x,y| Fina040(x,y)}, aVetor, 3)
	aVetor	:=	{}

	If lmsErroAuto
		MostraErro()
	Else

		//�����������������������Ŀ
		//�Obtem loja da corretora�
		//�������������������������
		cLojCorr := Alltrim(SubStr(cCliCorr,AT("/",cCliCorr)+1,Len(cCliCorr)))
		cLojCorr += Space(TamSx3("A1_LOJA")[1] - Len(cLojCorr))

		//�������������������������Ŀ
		//�Obtem codigo da corretora�
		//���������������������������
		cCliCorr := Alltrim(SubStr(cCliCorr,1,AT("/",cCliCorr)-1))
		cCliCorr += Space(TamSx3("A1_COD")[1] - Len(cCliCorr))
		
		// Eder - Nova Regra : Busca corretora no PA9
		PA8->(dbSetOrder(7))
		PA9->(dbSetOrder(1))
		_aArA1 := SA1->(GetArea())
		SA1->(dbSetOrder(1))
		
		If PA8->(dbSeek(xFilial("PA8")+SL1->L1_FILIAL+SL1->L1_NUM))
			If PA9->(dbSeek(xFilial("PA9")+PA8->PA8_CODSEG)) .AND. !EMPTY(PA9->PA9_CODADM) .and. SA1->(dbSeek(xFilial("SA1")+PA9->PA9_CODADM))
				cCliCorr := PA9->PA9_CODADM
				cLojCorr := SA1->A1_LOJA
			Endif
			SA1->(RestArea(_aArA1))
		Endif
		// Fim Eder
				
		cParcela	:= 	GetMv("MV_1DUP")                                        

		cChave := xFilial('SE1')+SF2->F2_PREFIXO+SF2->F2_DOC
		
		//������������������������������������������������������Ŀ
		//�Busca o numero/letra da ultima parcela para o tipo NCC�
		//��������������������������������������������������������
		dbSelectArea("SE1")
		dbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		If dbSeek(cChave)
			
			While !SE1->(Eof()) .And. (Alltrim(cChave) == Alltrim(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)))
				
				If AllTrim(SE1->E1_TIPO) == "NCC"
			       	cParcela := SE1->E1_PARCELA
			 	EndIf
		       	
		       	SE1->(DbSkip())
			End                       
			
			cParcela := Soma1(cParcela)
		EndIf

		//�������������������������������������Ŀ
		//�Monta array com as informacoes da ncc�
		//���������������������������������������
		aAdd(aVetor, {"E1_FILIAL" , xFilial("SE1")	  		 				, Nil})
		aAdd(aVetor, {"E1_PREFIXO", SL1->L1_SERIE	  		 				, NIL})
		aAdd(aVetor, {"E1_NUM"    , SL1->L1_DOC 	  		 				, NIL})
		aAdd(aVetor, {"E1_PARCELA", cParcela	   	   		 				, NIL})
		aAdd(aVetor, {"E1_TIPO"   , "NCC"			   		 				, NIL})
		aAdd(aVetor, {"E1_NATUREZ", GetMV("MV_NATCRED") 		 			, Nil})
		aAdd(aVetor, {"E1_PORTADO", SL1->L1_OPERADO					 		, Nil})
		aAdd(aVetor, {"E1_CLIENTE", cCliCorr  		 		  				, Nil})
		aAdd(aVetor, {"E1_LOJA"   , cLojCorr	   			  				, Nil})
		aAdd(aVetor, {"E1_NOMCLI" , GetAdvFVal("SA1","A1_NOME",;
					xFilial("SA1")+cCliCorr+cLojCorr,1,"")					, Nil})
		aAdd(aVetor, {"E1_EMISSAO", dDataBase		  		  				, Nil})
		aAdd(aVetor, {"E1_VENCTO" , dDataBase + 30	   		  				, Nil})
		aAdd(aVetor, {"E1_VENCREA", DataValida(dDataBase + 30)				, Nil})
		aAdd(aVetor, {"E1_VALOR"  , nTotDif				 	  				, Nil})
		aAdd(aVetor, {"E1_HIST"   , "CF" + SL1->L1_DOC + "/" +SL1->L1_SERIE, Nil})
		aAdd(aVetor, {"E1_ORIGEM" , "FINA040"				  				, Nil})
		aAdd(aVetor, {"E1_SINISTR", "S"						  				, Nil})	
//		aAdd(aVetor, {"INDEX"     , 1										, Nil})
	
		//����������������Ŀ
		//�Executa ExecAuto�
		//������������������
		msExecAuto({|x,y| Fina040(x,y)}, aVetor, 3)
		aVetor := {}

		If lmsErroAuto
			MostraErro()
		EndIf
	
	EndIf

EndIf

RestArea(aAreaPA8)
RestArea(aAreaSE1)
RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020H  �Autor  �Norbert Waage Junior   � Data �  16/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Calcula e gera parcelas referente a sinistros, cobrando segu-  ���
���          �radora e corretora.                                            ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada no botao 'Calcula Sinistro'                     ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020H()

Local aArea		:= 	GetArea()
Local aLin 		:=	{}
Local aLin2		:=	{}
Local nLenCols	:=	Len(aCols)
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosVlTot	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VLRITEM" })
Local nPosVlUni	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VRUNIT"  })
Local nPerCli	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })
Local nDif		:=	0
Local nPerc		:=	0
Local nTotSeg	:=	0 
Local nTotCorr	:=	0 
Local nValTot   :=  0
Local nVlrParcelas	:= 0
Local nVlrAux		:=	Lj7T_Total( 2 )
Local nX
Local _lTemServ		:= .F.

// Eder - refresh na tela de formas de pagamentos
If ! P_NAPILHA("P_DELA020I")
	Lj7R_Rodape("")
Endif

//oDescCondPg:cCaption := ""
//oDescCondPg:Refresh()

//�������������������������Ŀ
//�Calcula valores do seguro�
//���������������������������
P_CalcVSeg(@nTotCorr,@nTotSeg)

//���������������������������������������������������Ŀ
//�Zera aPgtos caso existam parcelas a serem inseridas�
//�����������������������������������������������������
If (Len(aPgtos)) == 1 .And. Empty(aPgtos[1][1]) .And. ((nTotSeg + nTotCorr) > 0 )
	aPgtos := {}
EndIf

//��������������������������������������������������������������Ŀ
//� Estrutura do array aPgtos                                    �
//��������������������������������������������������������������ĳ
//� [1] - Data de pagamento das parcelas                         �
//� [2] - Valor da parcelas                                      �
//� [3] - Forma de Pagamento                                     �
//� [4] - Codigo da Administradora financeira                    �
//� [5] - Coluna Customizada pelo ponto de entrada LJ7012        �	
//� [6] - Moeda(Localizacoes)                                    �
//� [7] - Data de emissao(Localizacoes)                          �		
//| [8] - Sequencia para controle de m�ltiplas transa��ies		 |
//����������������������������������������������������������������
aLin  := {CtoD(""), 0, Space(2), {}, NIL, NIL, NIL, IIf(lVisuSint, Space(TamSX3("L4_FORMAID")[1]), Space(1))}

//���������������������������Ŀ
//�Calcula linha da seguradora�
//�����������������������������
If nTotSeg > 0
	 
	aLin2 		:= aClone(aLin)
	aLin2[1]	:= dDataBase
	aLin2[2]	:= nTotSeg
	aLin2[3]	:= "SG" //"FI"
	aLin2[5]	:= "S"
	nVlrParcelas += nTotSeg
	
	AAdd(aPgtos,aLin2)
	_lTemServ 		:= .T.
	M->LQ_CONDPG	:="CN"
EndIf

//��������������������������Ŀ
//�Calcula linha da corretora�
//����������������������������
If nTotCorr > 0
   
	aLin2 		:= aClone(aLin)
	aLin2[1]	:= dDataBase
	aLin2[2]	:= nTotCorr
	aLin2[3]	:= "CT" //"FI" 
	aLin2[5] 	:= "C"  
	nVlrParcelas += nTotCorr
	
	AAdd(aPgtos,aLin2)
	_lTemServ 		:= .T.
	M->LQ_CONDPG	:= "CN"
EndIf

//����������������������������Ŀ
//�Ordena parcelas do pagamento�
//������������������������������
P_OrdParcs()
       
//������������������������Ŀ
//�Recalcula totais e troco�
//��������������������������
If nVlrParcelas > nVlrAux
	nValTot := nVlrParcelas
Else
	nValTot := nVlrAux
EndIf

Lj7T_Total(2, nValTot)
LJ7AjustaTroco()

//��������������������������������������������������������������Ŀ
//� Ajusta os valores de PIS/COFINS caso Haja                    �
//����������������������������������������������������������������
Lj7PisCof()		
                
//������������������������������������������������������������Ŀ
//�Ajusta o flag para controle de parcelas geradas por sinistro�
//��������������������������������������������������������������
_lDelA020 := .T.

//��������������������������������������Ŀ
//�Atualiza objeto que contem as parcelas�
//����������������������������������������
oPgtos:setArray(aPgtos)
oPgtos:Refresh()  
                      
If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	
        
//���������������������������Ŀ
//�Atualiza forma de pagamento�
//�����������������������������
If Empty(M->LQ_CONDPG) .Or. AllTrim(M->LQ_CONDPG) == "CN"
	If !_lTemServ
		If !Empty(_cD020CPG)
			M->LQ_CONDPG	:=	_cD020CPG
		Else
			M->LQ_CONDPG	:=	GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,Space(TamSX3("E4_CODIGO")[1]))
		EndIf
	Endif	
EndIf


oGetVA:Refresh()

RestArea(aArea)

Return Nil                            

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020I  �Autor  �Norbert Waage Junior   � Data �  16/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Calcula e gera parcelas referente a sinistros, cobrando segu-  ���
���          �radora e corretora.                                            ���
����������������������������������������������������������������������������͹��
���Parametros�nOp - 1 = Condicao negociada, 2 = Form. Pagamentos             ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelos botoes Cond. Negociada e Cond. Pagamento  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DelA020I(nOp) 

Local aArea			:= GetArea()
Local aRet 	   		:= {}
Local aTipoJuros	:= { "1 - Simples", "2 - Composto", "3 - Tabela Price" }	// Variavel para o combo box da condicao negociada
Local aDadosCNeg	:= { { aTipoJuros[1], dDatabase, 0, M->LQ_JUROS, 1, 30, .T., .F. }, Array(8) }	 // Variavel para os objetos da tela da condicao negociada
Local nVlrAux		:=	0   
Local nVlrParcelas	:=	0
Local nX			:=	0
Local nPosVrUnit	:=	aScan(aHeader	,{|x| AllTrim(x[2]) == "LR_VRUNIT" })
Local cCond			:=	M->LQ_CONDPG
Local nVAcreAtu		:= 	0			//Armazena acrescimo atual
Local nMoeda		:=	1
Local nNAtu,_nY

nVAcreAtu	:= GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+_cD020CPG,1,0) 

If lRecebe
	P_d20RecChq()
	Return
EndIf

If nOp == 1

	//����������������������������������������������������Ŀ
	//�Chama tela de cond. negociada especifica da DellaVia�
	//������������������������������������������������������
	If ChkPsw(35) //Verifica permissao de acesso a a condicao negociada
		If !_TelaCond(@aDadosCNeg,aTipoJuros)
			Return Nil
		EndIf
	Else
		Return Nil
	EndIf

Else

	//����������������������������������������������������Ŀ
	//�Chama tela de formas de pagamento espec. da DellaVia�
	//������������������������������������������������������
	If _TelaForPG(@cCond)
	
		If !Empty(M->LQ_CONDPG)
		
			cCond := M->LQ_CONDPG 
	
			//�������������������������������������������������������Ŀ
			//�Se nao for um recebimento e se o valor de acrescimo foi�
			//�alterado, recalcula os itens                           �
			//���������������������������������������������������������
            // Eder - Busca preco de tabela, acrescimo e desconto, mesmo que nao tenha alterado o percentual de acrescimo
			If !lRecebe //.AND. (nVAcreAtu != GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCond,1,0))
			
				//���������������������������������������������������Ŀ
				//�Atualiza precos de acordo com a codicao selecionada�
				//�����������������������������������������������������
			    nNatu := N
				
				For nX := 1 to Len(aCols)
					
					N := nX
					aCols[N][nPosVrUnit] := P_Dela015A(,.F.,cCond)
									
				Next
	
				N := nNatu
				
			EndIf
		
			P_LjRodape(M->LQ_CONDPG)
	
			//�������������������������Ŀ
			//�Valida alteracao de forma�
			//���������������������������
			If !Empty( Trim(SL1->L1_FILRES+SL1->L1_ORCRES) ) .And. cCond != SL1->L1_CONDPG
				Aviso( 'Aten��o', 'N�o � permitida a altera��o das formas de pagamento de um or�amento gerado com reserva.',{'Ok'} )
				Return Nil
			EndIf
			
			//�������������������������Ŀ
			//�Atualiza variaveis e tela�
			//���������������������������
			M->LQ_TIPOJUR := 0
			oDescCondPg:cCaption := GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+cCond,1,"")
			oDescCondPg:nClrText := 255
			oDescCondPg:Refresh()

		EndIf
	 
	Else
	   
		Return Nil

	EndIf

Endif	

//�����������������Ŀ
//�Zera array aPgtos�
//�������������������
Lj7ZeraPgtos()

M->LQ_CONDPG := cCond

//�������������������������������������������������������Ŀ
//�Acrescenta ao aPgtos as parcelas referentes a sinistros�
//���������������������������������������������������������
If !lRecebe
	P_DelA020H()
EndIf

//�����������������������������Ŀ
//�Verifica permissao do usuario�
//�������������������������������
If LjProfile(9) 

	If nOp == 1	
	
		//������������������Ŀ
		//�Condicao negociada�
		//��������������������
		Lj7R_Rodape("")
		M->LQ_CONDPG:= cDescCondPg:= cCondSE4:= Space(TamSX3("LQ_CONDPG")[1])
		aRet := P_Lj7CondPg(1, "CN", aDadosCNeg[1], Nil, aDadosCNeg[1][8], Nil, Nil, Nil)

	Else
	
		//���������������Ŀ
		//�Form. Pagamento�
		//�����������������
		aRet := P_Lj7CondPg( 2, cCond )

	EndIf
	
	//���������������������������������������������������������������Ŀ
	//�Acrescenta ao aPgtos os dados resultantes de condicao negociada�
	//�����������������������������������������������������������������
	If Len(aRet) > 0
	
		//���������������������������������������������������Ŀ
		//�Zera aPgtos caso existam parcelas a serem inseridas�
		//�����������������������������������������������������
		If (Len(aPgtos)) == 1 .And. Empty(aPgtos[1][1])
			aPgtos := {}
		EndIf
	
		nVlrAux := Lj7T_Total( 2 )
	
		For nX := 1 to Len(aRet)
            
			If aRet[nX][2] != 0
			
				aAdd( aPgtos, { aRet[nX][1], aRet[nX][2], aRet[nX][3],{},NIL,IIf(cPaisLoc!="BRA",nMoedaCor,NIL),;
				                IIf(cPaisLoc!="BRA",aRet[nX][1],NIL),If(lVisuSint,SL4->L4_FORMAID,Space(01)) } )
				nVlrParcelas += aRet[nX][2]
			
			EndIf

		Next nX
	
		Lj7T_Total( 2, If(nVlrParcelas>nVlrAux,nVlrParcelas,nVlrAux) )
		
	Endif

EndIf

//��������������������������Ŀ
//�Ordena formas de pagamento�
//����������������������������
P_OrdParcs()

//�������������Ŀ
//�Atualiza tela�
//���������������
oPgtos:SetArray( aPgtos )
oPgtos:Refresh()

If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	

oGetVA:Refresh()

//������������������������������������������������������������Ŀ
//�Ajusta o flag para controle de parcelas geradas por sinistro�
//��������������������������������������������������������������
_lDelA020 := .T.

//������������������������Ŀ
//� Ajusta dadoss da venda �
//��������������������������
LJ7AjustaTroco()
Lj7PisCof()			    

//��������������������������������������������Ŀ
//�Notifica o usuario sobre o uso de duplicatas�
//����������������������������������������������
P_NotifDP(1)

RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020J  �Autor  �Norbert Waage Junior   � Data �  26/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Grava ou le informacoes na tabela de condicoes de pagamento,SL4���
���          �para tratar parcelas referentes ao sinistro                    ���
����������������������������������������������������������������������������͹��
���Parametros�cFil - Filial selecionada                                      ���
���          �cOrc - Numero do orcamento                                     ���
���          �lGrava - .T. na gravacao do orcamento/venda para gravar na SL4 ���
���          �       - .F. na finalizacao da venda, para atualizar o aPgtos  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada na confirmacao e na abertura da venda/orcamento���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA020J(cFil,cOrc,lGrava)

Local aArea		:=	GetArea()
Local aAreaSL4	:=	SL4->(GetArea())
Local cOrigem	:=	Space(TamSX3("L4_ORIGEM")[1])	//Origem preenchida no loja
Local nSzSeq	:=	TamSx3("L4_SEQ")[1]
Local nX

Default lGrava := .T.

DbSelectArea("SL4")
DbSetOrder(4)	//L4_FILIAL+L4_NUM+L4_ORIGEM+L4_SEQ

//��������������������Ŀ
//�Percorre as parcelas�
//����������������������
For nX := 1 to Len(aPgtos)
		
	//��������������������������������Ŀ
	//�Se houver informacoes adicionais�
	//����������������������������������
	If SL4->(DbSeek(cFil + cOrc + cOrigem + StrZero(nX,nSzSeq)))

		If lGrava .And. !Empty(aPgtos[nX][5])
	
			//������������������������������������������������������Ŀ
			//�Armazena o tipo da administradora no campo L4_OBS.    �
			//�Este campo nao eh utilizado quando se utiliza uma ad- �
			//�ministradora.                                         �
			//��������������������������������������������������������
			RecLock("SL4",.F.)
			SL4->L4_OBS	:= aPgtos[nX][5]
			MsUnLock()
		
		//���������������������Ŀ
		//�Se for leitura da SL4�
		//�����������������������
		ElseIf !lGrava .And. !Empty(SL4->L4_OBS)
		
			//���������������Ŀ
			//�Atualiza aPgtos�
			//�����������������
			aPgtos[nX][5] := AllTrim(SL4->L4_OBS)
		
		EndIf
		
	EndIf	
	
Next nX

RestArea(aAreaSL4)
RestArea(aArea)

Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA020K  �Autor  �Norbert Waage Junior   � Data �  26/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Verifica se o botao calcula sinistro foi acionado e se os valo-���
���          �res foram gerados corretamente.                                ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �cMsg - Vazia se tudo estiver ok, ou mensagem de erro.          ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada na confirmacao da venda                        ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA020K()

Local cMsg			:= ""
Local nTotCorr		:= 0
Local nTotSeg		:= 0 
Local nPosCorr		:= aScan(aPgtos,{|x| x[5] == "C"})
Local nPosSeg		:= aScan(aPgtos,{|x| x[5] == "S"})
Local _nX			:= 0 
Local nVlrCorr		:= 0
Local nVlrSeg		:= 0

//�������������������������������������������������������������������������Ŀ
//�Verifica se existe SINISTRO no Apagtos e Atualiza a coluna 5 (Observacao)�
//���������������������������������������������������������������������������
If nPosCorr == 0 .AND. nPosSeg == 0 
	For _nX := 1 To Len(aPgtos)
		If Alltrim(aPgtos[_nX][3]) == "CT"  
			nPosCorr	:= _nX
		ElseIf Alltrim(aPgtos[_nX][3]) == "SG"
	   		nPosSeg		:= _nX		
		Endif
	Next       
Endif

//��������������������Ŀ
//�Le valores do aPgtos�
//����������������������
nVlrCorr	:= Iif(nPosCorr !=0,aPgtos[nPosCorr][2],0)
nVlrSeg		:= Iif(nPosSeg  !=0,aPgtos[nPosSeg ][2],0)

//����������������������������������������������������������Ŀ
//�Calcula os valores de seguro e corretora para comparar com�
//�as parcelas                                               �
//������������������������������������������������������������
P_CalcVSeg(@nTotCorr,@nTotSeg)

//�������������������������������Ŀ
//�Compara se os valores coincidem�
//���������������������������������
If (nTotCorr != nVlrCorr) .Or. (nTotSeg != nVlrSeg)

	cMsg :=	"Os valores das parcelas de sinistro n�o est�o de acordo com o percentual de bonifica��o definido."+;
			" Execute o c�lculo do sinistro novamente."

EndIf
	
Return cMsg

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Lj7CondPg �Autor  �Andre Veiga*        � Data �  12/08/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o browse  com as parcelas para o pagamento            ���
�������������������������������������������������������������������������͹��
���Sintaxe   �void Lj7CondPg( ExpN1, ExpC2, ExpA3, ExpL4 )                ���
�������������������������������������������������������������������������͹��
���Parametros�ExpN1 - Tipo da condicao                                    ���
���          �        1 - Chamada por um botao da tela de negociacao      ���
���          �        2 - Chamada por uma condicao de pagamento (SE4)     ���
���          �                                                            ���
���          �ExpC2 - Forma de pagto. Ex. "R$" / "CH" (Se ExpN1 == 1)     ���
���          �        ou                                                  ���
���          �        Codigo da condicao de pagamento (Se ExpN1 == 2)     ���
���          �                                                            ���
���          �ExpA3 - Dados para o calculo da condicao de pagamento se    ���
���          �        ExpC2 == "CN" (Condicao Negociada)                  ���
���          �        [1] - Tipo Juros (1)-Simples                        ���
���          �                         (2)-Composto                       ���
���          �                         (3)-Price                          ���
���          �        [2] - Data de Entrada                               ���
���          �        [3] - Valor da Entrada                              ���
���          �        [4] - Taxa de Juros                                 ���
���          �        [5] - Quantidade de parcelas                        ���
���          �        [6] - Intervalo                                     ���
���          �        [7] - Calcula juntos na 1a parcela (.T. ou .F.)     ���
���          �                                                            ���
���          �ExpL4 - .T. - Atualiza ListBox                              ���
���          �        .F. - Apenas faz o calculo (para atualizacao das    ���
���          �              variaveis).                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Loja701                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//����������������������������������������������������������Ŀ
//�* A rotina abaixo foi baseada na Lj7CondPg original, porem�
//�contempla apenas pagamentos do tipo Cond. Negociada e     �
//�Cond. Pagamento.                                          �
//������������������������������������������������������������
Project Function Lj7CondPg(nTipo   , cCondicao , aCondNeg, lAtuList,;
                           lDiaFixo, cFormTroca, cFormaId, nFormValor)

Local nVlrPago			:= 0
Local nPosForma			:= 0
Local nVlrFSD			:= Lj7CalcFrete()
Local aRetPgto			:= {}
Local aRet				:= {}
Local aParcelas 		:= {}
Local aE4 				:= {}
Local aParcDiaFixo		:= {}
Local nSobraNCC			:= 0
Local nX
Local nVlrParc          := 0          
Local cLj7015           := ""
Local nValICMSSol       := 0
Local nValor            := 0
Local dDataHj
Local nPos				:= 0
Local cSimbMoeda		:= SuperGetMV("MV_SIMB"+Ltrim(Str(nMoedaCor)))	//Simbolo da moeda
Local nVlrAux 			:= 0
Local nValParc			:= 0
Local cCondPad			:= SuperGetMV( "MV_CONDPAD" )	// Condicao de pagamento padrao
Local nOpc				:= 0
Local lTefPendCS		:= .F.

Default aCondNeg 		:= {}
Default lAtuList        := .T.        
Default lDiaFixo		:= .F.
Default cFormTroca		:= ""
Default cFormaId		:= If(lVisuSint,Space(TamSX3("L4_FORMAID")[1]),Space(01))
Default nFormValor		:= 0

If ( Len(aCondNeg) >= 7 ) .and.  ( aCondNeg[4] < 0 )
	MsgStop("O campo Taxa Juros deve ter valor positivo.")
	Return(NIL)
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica quanto ja foi pago                                  �
//����������������������������������������������������������������
If cPaisLoc == "BRA"
   aEval( aPgtos, { |x| nVlrPago+=x[2] } )
Else 
   aEval( aPgtos, {|x| nVlrPago+=Round(xMoeda(x[2],x[_MOEDA],nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)})
EndIf      

//Comentada a soma do valor do Iss
nVlrPago := nVlrPago + nNCCUsada + LJPCCRet()	// Considera a NCC selecionada

//��������������������������������������������������������������Ŀ
//� Monta as parcelas de acordo com o Botao selecionado          �
//� ou com a condicao de pagamento (SE4) escolhida               �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Atribui os valores ref. ao calculo de juros                  �
//����������������������������������������������������������������
If Alltrim(cCondicao) == "CN"
	If !Empty(aCondNeg)	// Identifica que foi a escolha de uma NCC
		M->LQ_JUROS 	:= aCondNeg[4]
		M->LQ_TIPOJUR 	:= If(ValType(aCondNeg[1])=="C",Val(Substr(aCondNeg[1],1,1)),aCondNeg[1])
	Endif
Else
	M->LQ_JUROS 	:= Posicione("SE4",1,xFilial("SE4")+cCondicao,"E4_ACRSFIN")
	M->LQ_TIPOJUR 	:= If(M->LQ_JUROS>0,1,0) 	// Quando for calculado via SE4 (formas de pagamento) sera sempre Juros Simples
Endif

//��������������������������������������������������������������������������Ŀ
//� Chama a funcao para calculo das parcelas, e tira o frete e a NCC Usada   �
//� para nao entrar no calculo de juros                                      �
//����������������������������������������������������������������������������
nSobraNCC := If(nNCCUsada-(LJ7T_SubTotal(2)-(LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 )))>0, (LJ7T_SubTotal(2)-(LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ))), nNCCUsada)
If cPaisLoc == "BRA"

	nValParc	:= ( Lj7T_Subtotal( 2 ) - (LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ))) - LJ7T_DescV( 2 ) - nVlrPago
	nValICMSSol := Iif( MaFisFound("NF"), MAFisRet(, "NF_VALSOL"), 0 )
	aRetPgto    := Lj7CalcPgt(Iif(nValParc >= 0 ,nValParc ,0) , cCondicao, aCondNeg, nVlrFSD,,,, nValICMSSol)

Else
	
	nValParc	:= Lj7T_Total(2)-nVlrPago
	aRetPgto	:= Lj7CalcPgt(Iif(nValParc >= 0 ,nValParc ,0) , cCondicao, aCondNeg, nVlrFSD,,, nMoedaCor)
	
EndIf

//��������������������������������������������������������������������������Ŀ
//� Faz o acerto do total na tela de Venda e nas parcelas                    �
//����������������������������������������������������������������������������
If Len(aRetPgto) > 0
	nVlrAux := 0
	For nX := 1 to Len(aRetPgto)		   
		aAdd( aRet, { aRetPgto[nX][1], aRetPgto[nX][2], aRetPgto[nx][3],{},NIL,;
		                IIf(cPaisLoc!="BRA",aRetPgto[nX][_MOEDA],NIL),IIf(cPaisLoc!="BRA",aRetPgto[nX][_EMISSAO],NIL),;
		                If(Alltrim(aRetPgto[nx][3])$_FORMATEF,"1",Space(01)) } )
		nVlrAux += aRetPgto[nX][2]
	Next nX
	//��������������������������������������������������������������������������Ŀ
	//� Faz o recalculo do vencimento das parcelas no caso de uso de Dia Fixo    �
	//� para vencimento das parcelas.                                            �		
	//����������������������������������������������������������������������������
	If lDiaFixo    
		dDataHj := dDataBase
		dDataBase := aCondNeg[2]
		aE4 := {,Str(aCondNeg[5])+',0,'+Str(aCondNeg[6]), "3"," "," "," "}
		aParcDiaFixo := AvalCond( Lj7T_Subtotal( 2 ) , , , , "0",,aE4,"0",aE4,,{0,aCondNeg[6]} ) 
		For nX := 1 to Len(aRet)
			aRet[nX][1] := aParcDiaFixo[nX][1]
			If Month(aRet[nX][1]) == 2 .and. aCondNeg[6] == 31 .and. !AnoBissexto( Year(aRet[nX][1]) )
				aRet[nX][1] := Ctod('01/03/'+ Str(Year(aRet[nX][1])))
			EndIf				
		Next nX
		dDataBase := dDataHj
	EndIf
	
	Lj7T_Total(2, (nVlrAux + nVlrPago + LJPCCRet() + If(LJ220AbISS(), MaFisRet(NIL, 'NF_VALISS'), 0)))
Endif

//�����������������������������������������������������������������������Ŀ
//�Alimenta o array de acrescimo. Avalia se o desconto foi concedido antes�
//�ou depois do acrescimo.                                                �
//�������������������������������������������������������������������������
If M->LQ_JUROS > 0
	aAcrescimo[1] := nNCCUsada + nVlrAux - Lj7T_SubTotal(2) + Iif(aDesconto[1]==1,aDesconto[3],0) 	// Valor do acrescimo
	aAcrescimo[2] := M->LQ_JUROS															// Percentual do acrescimo
Else
	aAcrescimo[1] := 0								// Valor do acrescimo
	aAcrescimo[2] := 0								// Percentual do acrescimo
Endif
	
Return aRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_VldApol  �Autor  �Norbert Waage Junior   � Data �  03/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao � Validacao da apolice                                          ���
����������������������������������������������������������������������������͹��
���Parametros� Chave de pesquisa na tabela PA8                               ���
����������������������������������������������������������������������������͹��
���Retorno   � Verdadeiro se a apolice for valida                            ���
���          � Falso caso contrario                                          ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina executada na validacao da apolice do campo M->LR_SINISTR���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _VldApol(cChave)

Local lRet		:= .T.
Local aArea		:=	GetArea()
Local nPosIt	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT" })
Local nMesSeg	:=	GetMv("FS_DEL010")	//Quantidade de meses da garantia

//���������������������������Ŀ
//�Posiciona tabela de Seguros�
//�����������������������������
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

cChave := RTrim(cChave)

If DbSeek(cChave) 

	//�����������������������������������������Ŀ
	//�Se o item da apolice nao foi especificado�
	//�������������������������������������������
	If Empty(aCols[N][nPosIt])
		
		lRet := .F.
		
		//�����������������������������������������������������������Ŀ
		//�Percorre tabela de seguros, em busca de uma apolice valida.�
		//�Verifica-se:                                               �
		//�-Status (Orcado ou Faturado)                               �
		//�-Data do Sinistro (Ja sinistrada ou n�o)                   �
		//�-Validade                                                  �
		//�-Existencia da apolice+item                                �
		//�������������������������������������������������������������
		While !Eof() .And. (PA8->(PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI) == cChave) .And. !lRet
			
			aCols[N][nPosIt] := Iif(lRet := !Empty(PA8->PA8_NFSG) .And. Empty(PA8->PA8_DTSN) .And.;
			(dDatabase - PA8->PA8_DTSG <= (nMesSeg * 30)) .And. _ExistSin(PA8->PA8_APOLIC,PA8->PA8_ITEM);
			,PA8->PA8_ITEM,"")
			
			DbSkip()
			
		End
	
	Else
	
		lRet := !Empty(PA8->PA8_NFSG) .And. Empty(PA8->PA8_DTSN) .And.;
				(dDatabase - PA8->PA8_DTSG <= (nMesSeg * 30)) .And. _ExistSin(PA8->PA8_APOLIC,PA8->PA8_ITEM)
		
	EndIf
    
	If !lRet
		cMsgErr := "A ap�lice informada j� foi sinistrada, n�o est� na validade ou est� com status de 'Or�amento'"
	EndIf

Else    

	lRet := .F.
	cMsgErr := "Ap�lice n�o encontrada"      
	
EndIf

//�����������Ŀ
//�Mostra erro�
//�������������
If !lRet
	ApMsgAlert(cMsgErr,"Sinistro")
	aCols[N][nPosIt] := Space(TamSx3("LR_APOIT")[1])
Else
	oGetVA:oBrowse:Refresh()
EndIf

RestArea(aArea)

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_GrvTela  �Autor  �Norbert Waage Junior   � Data �  03/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Gravacao dos campos da tela de sinistro                        ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro se os campos estiverem preenchidos corretamente     ���
���          �Falso caso contrario                                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina executada na confirmacao da tela de sinistro            ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _GrvTela()

Local lRet := .T.
Local aArea	:=	GetArea()
Local nPosKm	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_KMATU"   })
Local nPosRes	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_RESIDUO" })
Local nPosLacre	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_LACRE"   })
Local nPosPerCl	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PERCLI"  })
Local nPosCotMo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_CODMOT"  })
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosExam	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_EXAMIN"  })
Local nPosCert	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_CERTIF" })
Local nPosPrUn	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_VRUNIT"})

//���������������������������Ŀ
//�Posiciona tabela de seguros�
//�����������������������������
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM    

//�������������������������������������������Ŀ
//�Se os campos obrigatorios foram preenchidos�
//���������������������������������������������
If Empty(cLacre) .Or. Empty(cCodMot) .Or. nKm == 0 .Or. nResiduo == 0
	lRet := .F.
	ApMsgStop("Preencha todos os campos antes de prosseguir","Sinistro")
Endif

//���������������������������Ŀ
//�Valida o motivo selecionado�
//�����������������������������
If lRet
	lRet :=  _VldMot(cCodMot)	
EndIf

//���������������������Ŀ
//�Valida a Kilometragem�
//�����������������������
If lRet .And. DbSeek(xFilial("PA8")+M->(LR_SINISTR+LQ_CLIENTE+LQ_LOJA)+aCols[N][nPosItApo])

	If (nKm - PA8->PA8_KMSG) > GetMv("FS_DEL009")
		lRet := .F.
		ApMsgStop("A kilometragem informada � superior � kilometragem coberta pela ap�lice selecionada","N�o permitido")
	ElseIf nKm < PA8->PA8_KMSG
		lRet := .F.
		ApMsgStop("A kilometragem informada � inferior � kilometragem cadastrada na ap�lice selecionada","N�o permitido")
	EndIf

EndIf

If lRet

	//��������������������������Ŀ
	//�Grava informacoes no aCols�
	//����������������������������
	aCols[N][nPosKm]	:=	nKm
	aCols[N][nPosRes]	:=	nResiduo
	aCols[N][nPosPerCl]	:=	nPerCli
	aCols[N][nPosLacre]	:=	cLacre
	aCols[N][nPosCotMo]	:=	cCodMot
	aCols[N][nPosExam]	:=	cExamin
	aCols[N][nPosCert]	:=	cCertif

EndIf

RestArea(aArea)

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_VldMot   �Autor  �Norbert Waage Junior   � Data �  10/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Filtro para selecao do motivo de sinistro                      ���
����������������������������������������������������������������������������͹��
���Parametros�cMot - Motivo selecionado                                      ���
����������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro caso o motivo possa ser utilizado                   ���
���          �Falso caso contrario                                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na selecao do motivo de sinistro                ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _VldMot(cMot)

Local lRet 		:= ExistCpo("PAA",cMot)
Local aMotivo	:= GetAdvFVal("PAA",{"PAA_TIPOPR","PAA_DESC"},xFilial("PAA")+cMot,1,{"",""})
Local cGrupo

//�������������������������������������������������������������Ŀ
//�Verifica se o motivo pertence ao grupo do produto selecionado�
//���������������������������������������������������������������
If lRet
	cGrupo	:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PRODUTO"})],1,"")
	lRet 	:= (GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cGrupo,1,"") == aMotivo[1])	
Else
	cMotivo	:= ""
	Return lRet
EndIf

//����������������������������Ŀ
//�Atualiza descricao do motivo�
//������������������������������
If lRet
	cMotivo := aMotivo[2]
Else
	ApMsgAlert("O motivo informado n�o pode ser utilizado para o produto a ser sinistrado","C�digo inv�lido")
	cMotivo	:= ""
EndIf

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_ExistSin �Autor  �Norbert Waage Junior   � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Verifica a existencia do sinistro no aCols                     ���
����������������������������������������������������������������������������͹��
���Parametros�cSinistro - Apolice a ser pesquisada                           ���
���          �cItem     - Item da apolice a ser pesquisada                   ���
����������������������������������������������������������������������������͹��
���Retorno   �Verdadeiro caso a apolice nao esteja no aCols                  ���
���          �Falso caso ja exista a apolice no aCols                        ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada na validacao da apolice                         ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _ExistSin(cSinistro,cItem)

Local nX
Local nLen	:= Len(aCols)
Local lRet	:=	.T.
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
             
//��������������Ŀ
//�Percorre aCols�
//����������������
For nX := 1 to nLen
	If (nX != N) .And. (aCols[nX][nPosApo]+aCols[nX][nPosItApo] == cSinistro+cItem)
		lRet := .F.
		nX := nLen + 1
	EndIf
Next nX

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_TelaCond �Autor  �Norbert Waage Junior   � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Monta e exibe tela para selecao de condicao negociada          ���
����������������������������������������������������������������������������͹��
���Parametros�aDadosCNeg - Array que contem os campos a serem exibidos       ���
���          �aTipoJuros - tem da apolice a ser pesquisada                   ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet (.T.) - Usuario confirmou a tela                          ���
���          �     (.F.) - Usuario cancelou a tela                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo bocao Condic.Negociada                     ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _TelaCond(aDadosCNeg,aTipoJuros)

Local lRet := .F.
Local oDlg1	:=	NIL

//�����������Ŀ
//�Cria a tela�
//�������������
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 270,380 PIXEL TITLE "Condi��o Negociada" of oMainWnd

//������������������Ŀ
//�Criacao dos campos�
//��������������������
@ 010, 010 SAY "Tipo Juros" PIXEL OF oDlg1
@ 010, 070 MSCOMBOBOX aDadosCNeg[2][1] VAR aDadosCNeg[1][1] ITEMS aTipoJuros SIZE 60,07 PIXEL OF oDlg1
aDadosCNeg[2][1]:cSx1Hlp := "LQ_TIPOJUR"
aDadosCNeg[2][1]:bChange := { || M->LQ_TIPOJUR := Val(Subst(aDadosCNeg[1][1],1,1)) }

@ 025, 010 SAY "Primeira Parcela" PIXEL OF oDlg1
@ 025, 070 MSGET aDadosCNeg[2][2] VAR aDadosCNeg[1][2] SIZE 45,07 PIXEL OF oDlg1
aDadosCNeg[2][2]:cSx1Hlp := "LJ701DTPAR"

@ 040, 010 SAY "Entrada" PIXEL OF oDlg1 
@ 040, 070 MSGET aDadosCNeg[2][3] VAR aDadosCNeg[1][3] VALID aDadosCNeg[1][3]>=0 SIZE 60,07 PICTURE PesqPict("SL1","L1_VLRTOT") PIXEL OF oDlg1
aDadosCNeg[2][3]:cSx1Hlp := "LQ_ENTRADA"
               
@ 055, 010 SAY "Taxa de Juros" PIXEL OF oDlg1
@ 055, 070 MSGET aDadosCNeg[2][4] VAR aDadosCNeg[1][4] SIZE 20,07 PICTURE "@E 999.99" PIXEL OF oDlg1
aDadosCNeg[2][4]:cSx1Hlp := "LQ_JUROS"

@ 070, 010 SAY "Parcelas" PIXEL OF oDlg1
@ 070, 070 MSGET aDadosCNeg[2][5] VAR aDadosCNeg[1][5] VALID aDadosCNeg[1][5]>0 SIZE 13,07 PICTURE "99" PIXEL OF oDlg1
aDadosCNeg[2][5]:cSx1Hlp := "LQ_PARCELA"

@ 085, 010 SAY oIntDVenc VAR If(aDadosCNeg[1][8],"Dia Vencimiento","Intervalo") PIXEL OF oDlg1 
@ 085, 070 MSGET aDadosCNeg[2][6] VAR aDadosCNeg[1][6] SIZE 13,07 PICTURE "99" PIXEL OF oDlg1
aDadosCNeg[2][6]:cSx1Hlp := "LQ_INTERV"

@ 100, 010 CHECKBOX aDadosCNeg[2][7] VAR aDadosCNeg[1][7] PROMPT "Calcula juros na 1a parcela ?" SIZE 100,07  WHEN (Subst(aDadosCNeg[1,1],1,1)$"12") PIXEL OF oDlg1

//����������������������Ŀ
//�Tratamento do dia fixo�
//������������������������
If SL1->(FieldPos("L1_DIAFIXO")) > 0
	@ 115, 010 CHECKBOX aDadosCNeg[2][8] VAR aDadosCNeg[1][8] PROMPT "Dia Fixo" SIZE 100,07  WHEN (Subst(aDadosCNeg[1,1],1,1)$"12") PIXEL OF oDlg1;
	ON CHANGE (If (aDadosCNeg[1][8],aDadosCNeg[1][6]:=Day(dDataBase),aDadosCNeg[1][6] := 30), aDadosCNeg[2][6]:Refresh(), oIntDVenc:Refresh())	
EndIf

//������Ŀ
//�Botoes�
//��������
DEFINE SBUTTON FROM 120,120 TYPE 1 ENABLE OF oDlg1 ACTION (oDlg1:End(), lRet := .T.)
DEFINE SBUTTON FROM 120,150 TYPE 2 ENABLE OF oDlg1 ACTION (oDlg1:End())    

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �_TelaForPG�Autor  �Norbert Waage Junior   � Data �  13/06/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Monta e exibe tela para selecao da forma de pagamento          ���
����������������������������������������������������������������������������͹��
���Parametros�cCond - Condicao de pagamento a ser manipulada                 ���
����������������������������������������������������������������������������͹��
���Retorno   �lRet (.T.) - Usuario confirmou a tela                          ���
���          �     (.F.) - Usuario cancelou a tela                           ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo bocao Condic.Pagamento                     ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function _TelaForPG(cCond)

Local aArea		:=	GetArea()
Local oCond		:=	NIL
Local lRet		:= .F.
Local oDlg1		:=	NIL

//��������������������Ŀ
//�Inicializa variaveis�
//����������������������
If Empty(M->LQ_CONDPG) .Or. AllTrim(M->LQ_CONDPG) == "CN"

	If !Empty(_cD020CPG)
		M->LQ_CONDPG	:=	_cD020CPG
	Else
		M->LQ_CONDPG	:=	GetAdvFVal("PAF","PAF_CONDPG",xFilial("PAF")+cFilAnt+M->LQ_TIPOVND,1,Space(TamSX3("E4_CODIGO")[1]))
	EndIf

EndIf

oDescCondPg:cCaption :=	GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+cCond,1,"")
oDescCondPg:nClrText :=	255
oDescCondPg:Refresh()


//�����������������������Ŀ
//�Le validacao do usuario�
//�������������������������
cVldLQCondPg := GetAdvFVal("SX3","X3_VLDUSER","LQ_CONDPG",2,)

If Empty(cVldLQCondPg)
	cVldLQCondPg := ".T."
EndIf

//�����������Ŀ
//�Define tela�
//�������������
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 110,210 PIXEL TITLE "Condi��o de Pagamento" of oMainWnd

@ 10, 005 SAY "Condi��o de Pgto.:" PIXEL OF oDlg1

@ 10, 060 MSGET oCond VAR M->LQ_CONDPG F3 Posicione("SX3",2,"LQ_CONDPG ","X3_F3");
Valid (  (!Empty(M->LQ_CONDPG) .And. ExistCpo("SE4",M->LQ_CONDPG)) .And. &(cVldLQCondPg)) ;
Size 35,10 PIXEL OF oDlg1

//������Ŀ
//�Botoes�
//��������
DEFINE SBUTTON FROM 30,45 TYPE 1 ENABLE OF oDlg1 ACTION (Iif(!Empty(M->LQ_CONDPG),(oDlg1:End(), _cD020CPG:=cCond:=M->LQ_CONDPG, _lCPGCN :=.f., lRet := .T.),.F.))
DEFINE SBUTTON FROM 30,75 TYPE 2 ENABLE OF oDlg1 ACTION (oDlg1:End())    

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DL020TelaAdm�Autor�Paulo Benedet          � Data �  28/05/07   ���
����������������������������������������������������������������������������͹��
���Descricao �Monta e exibe tela para selecao da seguradora/corretora        ���
����������������������������������������������������������������������������͹��
���Parametros�nElem - Numero da linha do array aPgtos                        ���
����������������������������������������������������������������������������͹��
���Retorno   �Cod Adm + " - " + Nome Adm                                     ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina chamada pelo ponto de entrada LJ7021                    ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DL020TelaAdm(nElem)
Local aArea    := GetArea()
Local aAreaSAE := SAE->(GetArea())
Local cDadAdm  := ""
Local aDadAdm  := {}
Local cTitulo  := IIf(AllTrim(aPgtos[nElem][5]) == "C", "Corretora", "Seguradora")
Local oDlgAdm

// Carrega seguradoras / corretoras
dbSelectArea("SAE")
dbSetOrder(1) // AE_FILIAL+AE_COD
dbSeek(xFilial("SAE"))

While !EOF() .And. SAE->AE_FILIAL == xFilial("SAE")
	If SAE->AE_TIPOFIN == rTrim(aPgtos[nElem][5])
		aAdd(aDadAdm, SAE->AE_COD + " - " + Capital(SAE->AE_DESC))
	EndIf
	
	dbSkip()
End

// Interface para selecao
DEFINE MSDIALOG oDlgAdm FROM 12, 20 TO 27, 60 TITLE cTitulo

@ 00.3 , 01 TO 6,18.9 OF oDlgAdm

//Valor do t�tulo:
@ 01.0, 02.0 SAY "Valor do t�tulo:" SIZE 10,1 FONT aFontes[1] OF oDlgAdm
@ 01.0, 06.0 SAY aPgtos[nElem][2] Picture "@E 99,999.99" SIZE 10,1 RIGHT COLOR CLR_HRED FONT aFontes[1] OF oDlgAdm

// Data:
@ 02.0, 02.0 SAY "Data:" SIZE 4,1 FONT aFontes[1] OF oDlgAdm
@ 02.0, 04.0 SAY aPgtos[nElem][1] SIZE 8,1 COLOR CLR_HRED FONT aFontes[1] OF oDlgAdm

// Parc.:
@ 02.0, 08.0 SAY "Parcelas:" SIZE 5,1 FONT aFontes[1] OF oDlgAdm
@ 02.0, 11.4 SAY nElem Picture "99" SIZE 1,1 RIGHT COLOR CLR_HRED FONT aFontes[1] OF oDlgAdm

//Administradora:
@ 04.0, 02.0 SAY cTitulo + ":" OF oDlgAdm
@ 04.0, 07.5 MSCOMBOBOX cDadAdm ITEMS aDadAdm SIZE 80,40 OF oDlgAdm

DEFINE SBUTTON oBt1 FROM 100, 121.1 TYPE 1 Action oDlgAdm:End() ENABLE OF oDlgAdm

ACTIVATE MSDIALOG oDlgAdm CENTERED

RestArea(aAreaSAE)
RestArea(aArea)

Return(cDadAdm)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �d20RecChq �Autor  �Paulo Benedet          � Data �  25/07/08   ���
����������������������������������������������������������������������������͹��
���Descricao � Tela de valores recebidos                                     ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo botao condicao de pagto da tela 'definir  ���
���          � pagtos' da venda assistida (somente recebto titulos)          ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function d20RecChq()
Local aNwHead := {} // aHeader
Local aNwCols := {} // aCols
Local npData  := 0 // posicao da coluna data
Local npValor := 0 // posicao da coluna valor
Local npForma := 0 // posicao da coluna forma
Local nUsado  := 0 // numero de colunas
Local cValTit := Transform(Lj7T_Total(2), "@E 99,999,999.99") // valor do titulo
Local cValInf := "0,00" // valor total dos cheques
Local nTipo   := GD_INSERT + GD_DELETE + GD_UPDATE // tipo da getdados
Local lTela   := .T. // indica exibicao da tela de cheques
Local nTotLin := 0
Local cForma  := ""
Local i // for next

Private poDlg, poValTit, poValInf, poNwGd // variaveis da tela

//���������������Ŀ
//� Monta aHeader �
//�����������������
aAdd(aNwHead, {"Data", "L4_DATA", "", 8,;
	0, "M->L4_DATA >= dDataBase", "���������������", "D",;
	"", "V", "", ""})

aAdd(aNwHead, {"Valor", "L4_VALOR", "@E 99,999,999.99", 12,;
	2, "Positivo()", "���������������", "N",;
	"", "V", "", ""})

aAdd(aNwHead, {"Forma", "L4_FORMA", "", 1,;
	0, "Pertence('12')", "���������������", "C",;
	"", "V", "1=Cheque;2=Dinheiro", "'1'"})

nUsado  := Len(aNwHead)
npData  := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_DATA"})
npValor := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_VALOR"})
npForma := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_FORMA"})

//�������������Ŀ
//� Monta aCols �
//���������������
aNwCols := {Array(nUsado + 1)}
aNwCols[1][nUsado + 1] := .F.

For i := 1 to nUsado
	If Empty(aNwHead[i][12])
		If aNwHead[i][8] == "C"
			aNwCols[1][i] := Space(aNwHead[i][4])
		ElseIf aNwHead[i][8] == "D"
			aNwCols[1][i] := CtoD("")
		ElseIf aNwHead[i][8] == "N"
			aNwCols[1][i] := 0
		EndIf
	Else
		aNwCols[1][i] := &(aNwHead[i][12])
	EndIf
Next i

//������������Ŀ
//� Exibe Tela �
//��������������
While lTela
	Define msDialog poDlg Title "Informe as datas e valores" from 177,182 to 430,583 Pixel
		@ 001,004 to 105,200 Label "" Pixel of poDlg
		
		@ 078,008 Say "Valor do t�tulo:" Size 038,008 Pixel of poDlg
		@ 078,162 Say poValTit Var cValTit Right Size 033,008 Pixel of poDlg
		@ 092,008 Say "Valor lan�ado:" Size 036,008 Pixel of poDlg
		@ 092,162 Say poValInf Var cValInf Right Size 033,008 Pixel of poDlg
		
		Define sButton from 112,168 Type 1 Enable of poDlg Action(IIf(poNwGd:TudoOk(), (lTela := .F., poDlg:End()), .F.))
		
		poNwGd := msNewGetDados():New(008, 008, 068, 196, nTipo, "P_d20VLin(poNwGd:nAt)", "P_d20VLin()",,,,, "P_d20VCpo()",, "P_d20VDel(poNwGd:nAt)", poDlg, aNwHead, aNwCols)
	Activate msDialog poDlg Centered
End

//�����������������Ŀ
//� Atualiza aPgtos �
//�������������������
M->LQ_CONDPG := "CN"

//��������������������������������������������������������������Ŀ
//� Estrutura do array aPgtos                                    �
//��������������������������������������������������������������ĳ
//� [1] - Data de pagamento das parcelas                         �
//� [2] - Valor da parcelas                                      �
//� [3] - Forma de Pagamento                                     �
//� [4] - Codigo da Administradora financeira                    �
//� [5] - Coluna Customizada pelo ponto de entrada LJ7012        �
//� [6] - Moeda(Localizacoes)                                    �
//� [7] - Data de emissao(Localizacoes)                          �
//| [8] - Sequencia para controle de m�ltiplas transa��ies		 |
//����������������������������������������������������������������
aPgtos  := {}
nTotLin := Len(poNwGd:aCols)

For i := 1 to nTotLin
	If !aTail(poNwGd:aCols[i])
		If poNwGd:aCols[i][npForma] == "1"
			cForma := "CH"
		Else
			cForma := "R$"
		EndIf
		
		aAdd(aPgtos, {poNwGd:aCols[i][npData],;
			poNwGd:aCols[i][npValor],;
			cForma,;
			{},;
			Nil,;
			Nil,;
			Nil,;
			IIf(lVisuSint, Space(TamSX3("L4_FORMAID")[1]), Space(1))})
	EndIf
Next i

oPgtos:setArray(aPgtos)
oPgtos:Refresh()  
                      
//���������������������Ŀ
//� Atualiza aPgtosSint �
//�����������������������
If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	

oGetVA:Refresh()

Return



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � d20VCpo  �Autor  �Paulo Benedet          � Data �  25/07/08   ���
����������������������������������������������������������������������������͹��
���Descricao � Atualizar valores a receber                                   ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � .T.                                                           ���
����������������������������������������������������������������������������͹��
���Aplicacao � Validacao do campo na getdados de valores a receber           ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function d20VCpo()
Local nTotLin := Len(poNwGd:aCols) // total de linhas
Local npValor := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_VALOR"}) // posicao da coluna valor
Local nTotLan := 0 // valor total lancado
Local i //for next

If "L4_VALOR" $ __ReadVar
	//���������������������������Ŀ
	//� Atualiza total de cheques �
	//�����������������������������
	For i := 1 to nTotLin
		If !aTail(poNwGd:aCols[i])
			If i == poNwGd:nAt
				nTotLan += M->L4_VALOR
			Else
				nTotLan += poNwGd:aCols[i][npValor]
			EndIf
		EndIf
	Next i
	
	poValInf:cTitle := Transform(nTotLan, "@E 99,999,999.99")
	poValInf:Refresh()
EndIf

Return(.T.)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � d20VLin  �Autor  �Paulo Benedet          � Data �  25/07/08   ���
����������������������������������������������������������������������������͹��
���Descricao � Validar linhas                                                ���
����������������������������������������������������������������������������͹��
���Parametros� nLin - Numero da linha                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � .T. - linha correta                                           ���
���          � .F. - linha incorreta                                         ���
����������������������������������������������������������������������������͹��
���Aplicacao � Validacao da linha na getdados de valores a receber           ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function d20VLin(nLin)
Local nTotLin := 0 // total de linhas
Local npData  := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_DATA"})  // posicao da coluna data
Local npForma := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_FORMA"}) // posicao da coluna forma
Local npValor := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_VALOR"}) // posicao da coluna valor
Local nUsado  := Len(poNwGd:aHeader) - 1 // total de colunas
Local nTotLan := 0 // valor total lancado
Local lRet    := .T. // retorno
Local i, j //for next

If ValType(nLin) == "U" // tudook
	nIni    := 1
	nTotLin := Len(poNwGd:aCols)
Else // linok
	nIni    := nLin
	nTotLin := nLin
EndIf

For i := nIni to nTotLin
	If !aTail(poNwGd:aCols[i])
		//��������������������Ŀ
		//� valida campo vazio �
		//����������������������
		For j := 1 to nUsado
			If Empty(poNwGd:aCols[i][j])
				msgAlert("Existem campos vazios!", "Aviso")
				lRet := .F.
				Exit
			EndIf
		Next j
		
		If !lRet
			Exit
		EndIf
		
		If poNwGd:aCols[i][npForma] == "2" // dinheiro
			//�����������������������������Ŀ
			//� valida duas linhas dinheiro �
			//�������������������������������
			For j := 1 to nTotLin
				If j <> i
					If !aTail(poNwGd:aCols[j])
						If poNwGd:aCols[j][npForma] == "2"
							msgAlert("J� existe dinheiro informado!", "Aviso")
							lRet := .F.
							Exit
						EndIf
					EndIf
				EndIf
			Next j
			
			//�������������������������Ŀ
			//� valida dinheiro a prazo �
			//���������������������������
			If poNwGd:aCols[i][npData] <> dDataBase
				msgAlert("Dinheiro somente � vista!", "Aviso")
				lRet := .F.
			EndIf
		EndIf
		
		If !lRet
			Exit
		EndIf
		
		nTotLan += poNwGd:aCols[i][npValor]
	EndIf
Next i

//�����������������������������Ŀ
//� valida valor total digitado �
//�������������������������������
If lRet .And. ValType(nLin) == "U"
	If Lj7T_Total(2) <> nTotLan
		msgAlert("Valor a receber n�o bate com o valor do t�tulo!", "Aviso")
		lRet := .F.
	EndIf
EndIf

Return(lRet)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � d20VDel  �Autor  �Paulo Benedet          � Data �  25/07/08   ���
����������������������������������������������������������������������������͹��
���Descricao � Atualizar valor total das parcelas                            ���
����������������������������������������������������������������������������͹��
���Parametros� nLin - Numero da linha                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � .T.                                                           ���
����������������������������������������������������������������������������͹��
���Aplicacao � Validacao da delecao da linha na getdados de valores a receber���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function d20VDel(nLin)
Local nTotLin := Len(poNwGd:aCols) // total de linhas
Local npValor := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_VALOR"}) // posicao da coluna valor
Local nTotLan := 0 // valor total lancado
Local i //for next

//���������������������������Ŀ
//� Atualiza total de cheques �
//�����������������������������
For i := 1 to nTotLin
	If !aTail(poNwGd:aCols[i])
		nTotLan += poNwGd:aCols[i][npValor]
	EndIf
Next i

poValInf:cTitle := Transform(nTotLan, "@E 99,999,999.99")
poValInf:Refresh()

Return(.T.)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �d20RecTit �Autor  �Paulo Benedet          � Data �  25/07/08   ���
����������������������������������������������������������������������������͹��
���Descricao � Efetuar liquidacao dos titulos                                ���
����������������������������������������������������������������������������͹��
���Parametros� aTitRec - Array com os titulos recebidos                      ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina chamada pelo ponto de entrada LjRecComp                ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus                                                ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function d20RecTit(aTitRec)
Local aArea    := GetArea()
Local aAreaSA6 := SA6->(GetArea())
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local aAreaSEF := SEF->(GetArea())

Local nTotTit  := Len(aTitRec) // total de titulos pagos
Local aNewTit  := {} // array com os novos titulos
Local cParChq  := "" // proxima parcela do cheque
Local nTotPag  := Len(aPgtos) // total de parcelas no pagamento
Local nTamPar  := TamSX3("E1_PARCELA")[1] // Tamanho do campo "E1_PARCELA"
Local nTamTit  := TamSX3("E1_NUM")[1] // Tamanho do campo "E1_NUM"
Local nTamPrf  := TamSX3("E1_PREFIXO")[1] // Tamanho do campo "E1_PREFIXO"
Local cNumLiq  := "" // Numero da liquidacao
Local cSQL     := "" // consulta sql
Local aBaixa   := {} // array com os dados da baixa
Local i // for next

Private lMsErroAuto := .F. // retorno do execauto

// Posiciona no caixa
dbSelectArea("SA6")
dbSetOrder(1) // A6_FILIAL+A6_COD+A6_AGENCIA+A6_NUMCON
dbSeek(xFilial("SA6") + xNumCaixa())

Begin Transaction

// Percorre parcelas de pagamento
For i := 1 to nTotPag
	
	//�������������������������Ŀ
	//� Grava cheques recebidos �
	//���������������������������
	If AllTrim(aPgtos[i][03]) == "CH"
		// Pega numero de liquidacao
		If Empty(cNumLiq)
			cNumLiq := ProcNumLiq()
		EndIf
		
		// Pega proxima parcela
		cSQL := "   select E1_PARCELA"
		cSQL += "     from " + RetSQLName("SE1")
		cSQL += "    where D_E_L_E_T_ <> '*'"
		cSQL += "      and E1_FILIAL  = '" + xFilial("SE1") + "'"
		cSQL += "      and E1_PREFIXO = '" + Left(GetNewPar("FS_PREFREC", "REC"), nTamPrf) + "'"
		cSQL += "      and E1_NUM     = '" + Left(aPgtos[i][04][07], nTamTit) + "'"
		cSQL += "      and E1_TIPO    = 'CH'"
		cSQL += " order by E1_PARCELA desc"
		cSQL := ChangeQuery(cSQL)
		
		dbUseArea(.T., "TOPCONN", tcGenQry(,, cSQL), "TMPE1PAR", .F., .T.)
		
		If EOF()
			cParChq := GetMV("MV_1DUP")
		Else
			cParChq := Soma1(TMPE1PAR->E1_PARCELA, nTamPar)
		EndIf
		
		dbCloseArea()
		
		// Posiciona no titulo original para buscar informacoes fixas
		dbSelectArea("SE1")
		dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		dbSeek(xFilial("SE1") + aTitRec[1][02] + aTitRec[1][03] + aTitRec[1][04])
		
		// Altera cheque no SEF
		dbSelectArea("SEF")
		dbSetOrder(1) //EF_FILIAL+EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM
		If dbSeek(xFilial("SEF") + aPgtos[i][04][04] + aPgtos[i][04][05] + aPgtos[i][04][06] + aPgtos[i][04][07])
			RecLock("SEF", .F.)
			SEF->EF_PREFIXO := Left(GetNewPar("FS_PREFREC", "REC"), nTamPrf)
			SEF->EF_TITULO  := Left(aPgtos[i][04][07], nTamTit)
			SEF->EF_PARCELA := cParChq
			SEF->EF_TIPO    := aPgtos[i][03]
			SEF->EF_CLIENTE := SE1->E1_CLIENTE
			SEF->EF_LOJACLI := SE1->E1_LOJA
			SEF->EF_EMITENT := SE1->E1_NOMCLI
			SEF->EF_VALORBX := aPgtos[i][04][01]
			SEF->EF_USADOBX := "S"
			msUnlock()
		EndIf
		
		// Gera titulo de liquidacao
		aNewTit := {{"E1_PREFIXO", Left(GetNewPar("FS_PREFREC", "REC"), nTamPrf), Nil},;
					{"E1_NUM"    , Left(aPgtos[i][04][07], nTamTit)             , Nil},;
					{"E1_PARCELA", cParChq                                      , Nil},;
					{"E1_TIPO"   , aPgtos[i][3]                                 , Nil},;
					{"E1_NATUREZ", &(SuperGetMV("MV_NATRECE"))                  , Nil},;
					{"E1_CLIENTE", SE1->E1_CLIENTE                              , Nil},;
					{"E1_LOJA"   , SE1->E1_LOJA                                 , Nil},;
					{"E1_EMISSAO", dDataBase                                    , Nil},;
					{"E1_VENCTO" , aPgtos[i][1]                                 , Nil},;
					{"E1_VENCREA", DataValida(aPgtos[i][01])                    , Nil},;
					{"E1_VALOR"  , aPgtos[i][04][01]                            , Nil}}
		
		If GrvTit(aNewTit)
			// Coloca dados do portador e liquidacao no titulo gerado
			RecLock("SE1", .F.)
			SE1->E1_BCOCHQ  := aPgtos[i][04][04]
			SE1->E1_AGECHQ  := aPgtos[i][04][05]
			SE1->E1_CTACHQ  := aPgtos[i][04][06]
			SE1->E1_NUMLIQ  := cNumLiq
			SE1->E1_EMITCHQ := SE1->E1_NOMCLI
			SE1->E1_PORTADO := SA6->A6_COD
			SE1->E1_AGEDEP  := SA6->A6_AGENCIA
			SE1->E1_CONTA   := SA6->A6_NUMCON
			SE1->E1_CXATEND := SA6->A6_COD
			msUnlock()
			
			// Baixa o cheque se ele for a vista
			If aPgtos[i][1] == dDataBase
				AADD( aBaixa, { "E1_PREFIXO"	, SE1->E1_PREFIXO				, Nil })
				AADD( aBaixa, { "E1_NUM"     	, SE1->E1_NUM					, Nil })
				AADD( aBaixa, { "E1_PARCELA" 	, SE1->E1_PARCELA				, Nil })
				AADD( aBaixa, { "E1_TIPO"    	, SE1->E1_TIPO					, Nil })
				AADD( aBaixa, { "E1_CLIENTE"	, SE1->E1_CLIENTE				, Nil })
				AADD( aBaixa, { "E1_LOJA"    	, SE1->E1_LOJA					, Nil })
				AADD( aBaixa, { "AUTMOTBX"  	, "PAR"							, Nil })
				AADD( aBaixa, { "AUTBANCO"  	, SE1->E1_PORTADO				, Nil })
				AADD( aBaixa, { "AUTAGENCIA"	, SE1->E1_AGEDEP				, Nil })
				AADD( aBaixa, { "AUTCONTA"  	, SE1->E1_CONTA					, Nil })
				AADD( aBaixa, { "AUTDTBAIXA"	, dDataBase						, Nil })
				AADD( aBaixa, { "AUTHIST"   	, "Baixa Automatica Recebimento", Nil })
				AADD( aBaixa, { "AUTDESCONT"	, 0								, Nil })
				AADD( aBaixa, { "AUTMULTA"	 	, 0								, Nil })
				AADD( aBaixa, { "AUTJUROS" 		, 0								, Nil })
				AADD( aBaixa, { "AUTOUTGAS" 	, 0								, Nil })
				AADD( aBaixa, { "AUTVLRPG"  	, 0								, Nil })
				AADD( aBaixa, { "AUTVLRME"  	, 0								, Nil })
				AADD( aBaixa, { "AUTCHEQUE"  	, ""							, Nil })
				AADD( aBaixa, { "AUTVALREC"  	, SE1->E1_VALOR					, Nil })
				
				msExecAuto({|x,y|FINA070(x,y)},aBaixa,3)
				
				If lMsErroAuto
					MostraErro()
					DisarmTransaction()
				EndIf
			EndIf
		EndIf
	EndIf
Next i

If !Empty(cNumLiq)
	//����������������������������������Ŀ
	//� Grava informacoes no titulo pago �
	//������������������������������������
	For i := 1 to nTotTit
		If aTitRec[i][01] // Titulo pago
			
			// Posiciona sobre titulo pago
			dbSelectArea("SE1")
			dbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			If dbSeek(xFilial("SE1") + aTitRec[i][02] + aTitRec[i][03] + aTitRec[i][04])
				RecLock("SE1", .F.)
				SE1->E1_TIPOLIQ := "CH"
				msUnlock()
			EndIf
			
			// Grava dados de liquidacao
			dbSelectArea("SE5")
			dbSetOrder(7) //E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ
			dbSeek(xFilial("SE5") + aTitRec[i][02] + aTitRec[i][03] + aTitRec[i][04] + aTitRec[i][11])
			
			While !EOF() .And. SE5->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO) == xFilial("SE5") + aTitRec[i][02] + aTitRec[i][03] + aTitRec[i][04] + aTitRec[i][11]
				// Nao gravar dados de liquidacao na forma dinheiro
				If SE5->E5_MOEDA == "R$"
					dbSkip()
					Loop
				EndIf
				
				RecLock("SE5", .F.)
				SE5->E5_MOTBX   := "LIQ"
				SE5->E5_DOCUMEN := cNumLiq
				msUnlock()
				
				dbSkip()
			EndDo
		EndIf
	Next i
EndIf

End Transaction

RestArea(aAreaSA6)
RestArea(aAreaSE1)
RestArea(aAreaSE5)
RestArea(aAreaSEF)
RestArea(aArea)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CURGRVTIT �Autor  �Andre Schwartz      � Data �  24/02/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada do lojxrec na impress�o do cumpom fiscal  ���
���          � Utilizado para gerar outro titulo a receber caso o         ���
���          � seja feito em Cheque ou cart�o                             ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvTit(aNewTit)
Private lMsErroAuto := .F.

msExecAuto({|x, y| FinA040(x, y)}, aNewTit, 3)

If !lMSErroAuto
	If (__lSx8)
		ConfirmSX8()
	EndIf
Else
	MsgInfo("N�o foi poss�vel gerar os T�tulos a Receber.")
	RollBackSx8()
	DisarmTransaction()
	MostraErro()
EndIF

Return(!lMSErroAuto)



/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ProcNumLiq   �Autor  �Paulo Benedet         � Data � 08/06/06 ���
����������������������������������������������������������������������������͹��
���Descricao � Procura proximo numero de liquidacao                          ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � cNumLiq - Numero da liquidacao                                ���
����������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada pelo ponto de entrada LJRECCOMP              ���
����������������������������������������������������������������������������͹��
���Analista  � Data   �Bops  �Manutencao Efetuada                            ���
����������������������������������������������������������������������������͹��
���          �        �      �                                               ���
����������������������������������������������������������������������������͹��
���Uso       � Della Via Pneus                                               ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function ProcNumLiq()
Local aArea    := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cNumLiq1 := "" // numero da liquidacao obtido pelo parametro
Local cNumLiq  := "" // numero da liquidacao obtido pela base

// Procura numero da liquidacao
cNumLiq1 := GetMV("MV_NUMLIQ")
cNumLiq1 := Soma1(cNumLiq1)
cNumLiq  := cNumLiq1

// Procura se liquidacao existe no ctas receber
dbSelectArea("SE1")
dbSetOrder(15) //E1_FILIAL+E1_NUMLIQ
dbSeek(xFilial("SE1") + cNumLiq)

While !EOF() .And. SE1->E1_FILIAL == xFilial("SE1")
	cNumLiq := SE1->E1_NUMLIQ
	dbSkip()
EndDo

If cNumLiq <> cNumLiq1
	cNumLiq := Soma1(cNumLiq)
EndIf

// Grava liquidacao no parametro
PutMV("MV_NUMLIQ", cNumLiq)

RestArea(aAreaSE1)
RestArea(aArea)

Return(cNumLiq)
