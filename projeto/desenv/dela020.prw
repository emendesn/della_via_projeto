#INCLUDE "protheus.ch"
#DEFINE _FORMATEF	"CC;CD"     //Formas de pagamento que utilizam opera็ใo TEF para valida็ใo
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020A  บAutor  ณNorbert Waage Junior   บ Data ณ  02/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da apolice do sinistro no campo LR_SINISTR          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Verdadeiro se confirmou                                       บฑฑ
ฑฑบ          ณ Falso caso contrario                                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pela validacao do campo LR_SINISTR           บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบEdison    ณ18/01/06ณ      ณ- Retirada do IndRegua para utilizacao de      บฑฑ
ฑฑบMaricate  ณ        ณ      ณ  indice padrao da tabela SE1.                 บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariaveis utilizadas na tela de sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private oKm		:=	NIL
Private nKm		:=	aCols[N][nPosKm]
Private nResiduo:=	aCols[N][nPosRes]
Private nPerCli	:=	aCols[N][nPosPerCl]
Private cLacre	:=	aCols[N][nPosLacre]
Private cCodMot	:=	aCols[N][nPosCotMo]
Private cExamin	:=	aCols[N][nPosExam]
Private cCertif	:=	aCols[N][nPosCert]
Private cMotivo	:=	GetAdvFVal("PAA","PAA_DESC",xFilial("PAA")+cCodMot,1,"")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o preenchimento do campo Sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(M->LR_SINISTR)
	aCols[N][nPosItApo] := Space(TamSx3("LR_APOIT")[1])
	P_DelA015A(aCols[N][nPosPrUn],.T.)
	RestArea(aArea)
	Return .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o numero da apolice informadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !(lRet:= _VldApol(xFilial("PA8")+M->(LR_SINISTR+LQ_CLIENTE+LQ_LOJA)+aCols[N][nPosItApo],1))
	aCols[N][nPosItApo] := Space(TamSx3("LR_APOIT")[1])
	RestArea(aArea)
	Return lRet
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValidacao de quantidade informada para sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_QUANT" })] > 1
	ApMsgAlert("O sinistro se aplica a apenas uma unidade","Quantidade excedida")
	RestArea(aArea)
	Return .F.
EndIf
                                                                                             
lRet := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู	
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 205,600 PIXEL TITLE "Sinistro" of oMainWnd

//ฺฤฤฤฤฤฤฟ
//ณLabelsณ
//ภฤฤฤฤฤฤู
@ 3,5 TO 75,296 LABEL "" OF oDlg1 PIXEL

//ฺฤฤฤฤฤฤฟ
//ณBotoesณ
//ภฤฤฤฤฤฤู
Define SButton From 80,230 Type 1 Enable of oDlg1 Action (IIf(_GrvTela(),(oDlg1:End(),lRet := .T.),.F.))
Define SButton From 80,270 Type 2 Enable of oDlg1 Action (oDlg1:End())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Kilometragemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@11,10 SAY "Kilometragem" SIZE 40,7 PIXEL OF oDlg1
@10,50 MSGET oKm Var nKm Size 50, 7 PICTURE "999999" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Lacreณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
@26,10 SAY  "Lacre" SIZE 40,7 PIXEL OF oDlg1
@25,50 MSGET cLacre Size 50, 7 PICTURE "@ 9999999" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Cod. Motivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@41,10 SAY  "Cod. Motivo" SIZE 40,7 PIXEL OF oDlg1
@40,50 MSGET cCodMot F3 "PAA" Valid _VldMot(cCodMot) Size 53, 7 PICTURE "@ 9999999" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Examinador ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@56,10 SAY  "Examinador" SIZE 40,7 PIXEL OF oDlg1
@56,50 MSGET cExamin Size 53, 7 PICTURE "@!" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Residuoณ                                                         
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
@11,150 SAY  "Resํduo" SIZE 40,7 PIXEL OF oDlg1
@10,190 MSGET nResiduo Size 50, 7 PICTURE "@E 9,999.99" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo % Clienteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@26,150 SAY  "%Bonif. Cliente" SIZE 40,7 PIXEL OF oDlg1
@25,190 MSGET nPerCli Valid (nPerCli >= 0 .And. nPerCli <= 100) Size 50, 7 PICTURE "@E 999.99" PIXEL OF oDlg1    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Desc. Motivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@41,150 SAY  "Motivo" SIZE 40,7 PIXEL OF oDlg1
@40,190 MSGET cMotivo When .F. Size 96, 7 PICTURE "@!" PIXEL OF oDlg1  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCampo Certificadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@56,150 SAY  "Certificado"   SIZE 40,7 PIXEL OF oDlg1
@56,190 MSGET cCertif  Size 53, 7 PICTURE "@!" PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFoca o botao 'Ok'ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oKm:SetFocus()

ACTIVATE MSDIALOG oDlg1 CENTERED 
                        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe houve erros, limpa os camposณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRet
	aCols[N][nPosApo] 	:= Space(TamSx3("LR_SINISTR")[1])
	aCols[N][nPosItApo]	:= Space(TamSx3("LR_APOIT")[1])
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza GetDadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oGetVA:oBrowse:Refresh()

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020B  บAutor  ณNorbert Waage Junior   บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณmBrowse para consulta de seguros                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo menu do Sigaloja                           บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelA020B()

Private cCadastro := "Cadastro de seguros"

Private _nMesSeg := GetMv("FS_DEL010")

Private aLegenda :=	{{"BR_VERDE"		, "Segurado"	},;
					{ "BR_VERMELHO"  	, "Sinistrado"	},;
					{ "BR_AZUL"      	, "Devolvido"	},;
					{ "BR_AMARELO"   	, OemtoAnsi("Or็ado")},;
					{ "BR_PRETO"		, "Vencido"		}}
					
Private aRotina :=	{{"Pesquisar","AxPesqui",0,1},;
					{"Visualizar","AxVisual",0,2},;
					{"Aviso Sinistro","P_DELR007()",0,2},;
					{"Etiqueta","U_DVLOJF08(PA8->PA8_LOJSN, PA8->PA8_APOLIC, PA8->PA8_ITEM)",0,2},;
					{"Legenda","BrwLegenda(cCadastro,'Legenda',aLegenda)",0,4}}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefinicao legendaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020C  บAutor  ณNorbert Waage Junior   บ Data ณ  09/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFiltro para selecao do motivo de sinistro                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro caso o registro possa ser exibido                   บฑฑ
ฑฑบ          ณFalso caso contrario                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na montagem do F3 para a tabela PAA             บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelA020C()

Local cGrupo 	:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PRODUTO"})],1,"")
Local cTpProd	:= GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cGrupo,1,"")

Return PAA->PAA_TIPOPR == cTpProd

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020D  บAutor  ณNorbert Waage Junior   บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava informacoes do sinistro apos a conclusao da venda        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo ponto de entrada LJ7002                    บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona SE1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("SE1")
DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
DbSeek(xFilial("SE1")+SL1->L1_SERIE+SL1->L1_DOC)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGrava campo historicoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
While !Eof() .And.;
	SE1->E1_FILIAL	==	xFilial("SE1")	.And.;
	SE1->E1_PREFIXO	==	SL1->L1_SERIE	.And.;
	SE1->E1_NUM		==	SL1->L1_DOC
	
	RecLock("SE1",.F.)
	SE1->E1_HIST	:=	"CF" + SL1->L1_DOC + "/" +SL1->L1_SERIE
	MsUnLock()
	
	DbSkip()                                                   
	
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre tabela de segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre os itens da venda                                 ณ
//ณObs.: Ao inves de percorrer o SL2, percorro o aCols, pois oณ
//ณcampo L2_VLRITEM pode ter seu valor alterado antes da      ณ
//ณgravacao, quando usa-se uma NCC, por exemplo.              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aCols)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLinha valida e sinistradaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !aCols[nX][Len(aCols[nX])] .And. !Empty(aCols[nX][nPosApo])

		If PA8->(DbSeek(xFilial("PA8") + aCols[nX][nPosApo] + SL1->L1_CLIENTE + SL1->L1_LOJA + aCols[nX][nPosItApo]))
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณPercentual de bonificacaoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nPerc	:=	aCols[nX][nPosPerCl] / 100 
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValor do produto menor ou igual ao valor seguradoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If aCols[nX][nPosVlrIt] <= PA8->PA8_VPROSG
			
				nPerCli	:=	aCols[nX][nPosVlrIt] * (1 - nPerc)
				nPerSeg	:=	(aCols[nX][nPosVlrIt] * nPerc) + ((PA8->PA8_VPROSG - aCols[nX][nPosVlrIt] ) * nperc)
				nPerCorr:=	((PA8->PA8_VPROSG - aCols[nX][nPosVlrIt] ) * nperc)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValor do produto superior ao valor seguradoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			Else 

				nPerCli	:=	aCols[nX][nPosVlrIt] * (1 - nPerc)
				nPerSeg	:=	PA8->PA8_VPROSG * nPerc
				nPerCorr:=	(aCols[nX][nPosVlrIt] - PA8->PA8_VPROSG) * nPerc

			EndIf           

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณGrava campos do PA8 - Segurosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020E  บAutor  ณNorbert Waage Junior   บ Data ณ  14/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณAtualiza campos e exclui registros das tabelas vinculadas      บฑฑ
ฑฑบ          ณna exclusao da venda.                                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ_cFilial - Numero da filial                                    บฑฑ
ฑฑบ          ณ_cNum    - Numero do orcamento de venda do seguro              บฑฑ
ฑฑบ          ณ_cDoc    - Numero do documento(E1_NUM)                         บฑฑ
ฑฑบ          ณ_cSerie  - Serie do documento                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo ponto de entrada LJ140DEL                  บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona tabela de segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(7) //PA8_FILIAL+PA8_LOJSN+PA8_ORCSN
DbSeek(xFilial("PA8") + _cFilial + _cNum)

While !Eof() .And.;
	PA8->PA8_FILIAL	==	xFilial("PA8")	.And.;
	PA8->PA8_LOJSN	==	_cFilial 		.And.;
	PA8->PA8_ORCSN	==	_cNum
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณArmazena registros a serem atualizadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AAdd(aRecnos,PA8->(Recno()))
	nRegs++
	
	DbSkip()                    
	
End	 	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza itens do PA8 - Segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExclui titulos gerados pelos sinistrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbselectArea("SE1")
DbSetOrder(1) //E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

If DbSeek(xFilial("SE1")+_cSerie+_cDoc)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre SE1 - Contas a receber - Armazenando titulosณ
	//ณgerados pelas rotinas customizadas                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExclui todos os titulos armazenados via msExecAutoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020F  บAutor  ณNorbert Waage Junior   บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณVerifica se as apolices da venda atual sao validas             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet(.T.) - Permite a gravacao                                 บฑฑ
ฑฑบ          ณlRet(.F.) - Impede a gravacao                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณChamada na confirmacao final da venda                          บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DelA020F()

Local aArea		:=	GetArea()
Local aAreaPA8	:=	PA8->(GetArea())
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
Local lRet		:=	.T.
Local nLenCols	:=	Len(aCols)
Local nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona PA8 - Segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(6) //PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre aColsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to nLenCols

	If !Empty(aCols[nX][nPosApo]) .And. !ATail(aCols[nX])

		If	PA8->(DbSeek(xFilial("PA8") + aCols[nX][nPosApo] + M->(LQ_CLIENTE + LQ_LOJA) + aCols[nX][nPosItApo]))
			
			If !Empty(PA8->PA8_DTSN)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณApolice jah utlizada em outra vendaณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ApMsgAlert("A ap๓lice utilizada nesta venda jแ foi sinistrada, verifique","Inconsist๊ncia")
				lRet := .F. 
				nX := nLenCols+1
				
			EndIf

		Else
            
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณApolice excluida ou informada de forma erradaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ApMsgAlert("A ap๓lice utilizada nesta venda nใo exite, verifique","Inconsist๊ncia")
			lRet	:=	.F.
			nX := nLenCols+1

		EndIf

	EndIf

Next nX

RestArea(aAreaPA8)
RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020G  บAutor  ณNorbert Waage Junior   บ Data ณ  09/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula e gera titulos no contas a pagar para o uso de sinistroบฑฑ
ฑฑบ          ณ, gerando titulos contra a corretora e contra a seguradora     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณChamada pelo ponto de entrada LJ7002                           บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre a Cols, calculando diferenca de precos e percentuaisณ
//ณa ser pagos em cada titulo                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe ha necessidade de gerar titulosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nTotDif > 0 

	cChave := xFilial('SE1')+SF2->F2_PREFIXO+SF2->F2_DOC
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณBusca o numero/letra da ultima parcela para o tipo FIณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SE1")
	dbSetOrder(1) // E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	If dbSeek(cChave)
		
		While !SE1->(Eof()) .And. (Alltrim(cChave) == Alltrim(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM)))
			
			If AllTrim(SE1->E1_TIPO) == "FI"
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณArmazena os dados do titulo para copia-los para a proximaณ
				//ณparcela                                                  ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta array com as informacoes do tituloณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta ExecAutoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	msExecAuto({|x,y| Fina040(x,y)}, aVetor, 3)
	aVetor	:=	{}

	If lmsErroAuto
		MostraErro()
	Else

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem loja da corretoraณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cLojCorr := Alltrim(SubStr(cCliCorr,AT("/",cCliCorr)+1,Len(cCliCorr)))
		cLojCorr += Space(TamSx3("A1_LOJA")[1] - Len(cLojCorr))

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณObtem codigo da corretoraณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณBusca o numero/letra da ultima parcela para o tipo NCCณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMonta array com as informacoes da nccณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณExecuta ExecAutoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020H  บAutor  ณNorbert Waage Junior   บ Data ณ  16/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula e gera parcelas referente a sinistros, cobrando segu-  บฑฑ
ฑฑบ          ณradora e corretora.                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada no botao 'Calcula Sinistro'                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula valores do seguroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_CalcVSeg(@nTotCorr,@nTotSeg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณZera aPgtos caso existam parcelas a serem inseridasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (Len(aPgtos)) == 1 .And. Empty(aPgtos[1][1]) .And. ((nTotSeg + nTotCorr) > 0 )
	aPgtos := {}
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura do array aPgtos                                    ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ [1] - Data de pagamento das parcelas                         ณ
//ณ [2] - Valor da parcelas                                      ณ
//ณ [3] - Forma de Pagamento                                     ณ
//ณ [4] - Codigo da Administradora financeira                    ณ
//ณ [5] - Coluna Customizada pelo ponto de entrada LJ7012        ณ	
//ณ [6] - Moeda(Localizacoes)                                    ณ
//ณ [7] - Data de emissao(Localizacoes)                          ณ		
//| [8] - Sequencia para controle de m๚ltiplas transa็๕ies		 |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aLin  := {CtoD(""), 0, Space(2), {}, NIL, NIL, NIL, IIf(lVisuSint, Space(TamSX3("L4_FORMAID")[1]), Space(1))}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula linha da seguradoraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula linha da corretoraณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena parcelas do pagamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_OrdParcs()
       
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecalcula totais e trocoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nVlrParcelas > nVlrAux
	nValTot := nVlrParcelas
Else
	nValTot := nVlrAux
EndIf

Lj7T_Total(2, nValTot)
LJ7AjustaTroco()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ajusta os valores de PIS/COFINS caso Haja                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7PisCof()		
                
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta o flag para controle de parcelas geradas por sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_lDelA020 := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza objeto que contem as parcelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPgtos:setArray(aPgtos)
oPgtos:Refresh()  
                      
If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	
        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza forma de pagamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020I  บAutor  ณNorbert Waage Junior   บ Data ณ  16/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณCalcula e gera parcelas referente a sinistros, cobrando segu-  บฑฑ
ฑฑบ          ณradora e corretora.                                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnOp - 1 = Condicao negociada, 2 = Form. Pagamentos             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelos botoes Cond. Negociada e Cond. Pagamento  บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama tela de cond. negociada especifica da DellaViaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ChkPsw(35) //Verifica permissao de acesso a a condicao negociada
		If !_TelaCond(@aDadosCNeg,aTipoJuros)
			Return Nil
		EndIf
	Else
		Return Nil
	EndIf

Else

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChama tela de formas de pagamento espec. da DellaViaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If _TelaForPG(@cCond)
	
		If !Empty(M->LQ_CONDPG)
		
			cCond := M->LQ_CONDPG 
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณSe nao for um recebimento e se o valor de acrescimo foiณ
			//ณalterado, recalcula os itens                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
            // Eder - Busca preco de tabela, acrescimo e desconto, mesmo que nao tenha alterado o percentual de acrescimo
			If !lRecebe //.AND. (nVAcreAtu != GetAdvFVal("SE4","E4_ACRESDV",xFilial("SE4")+cCond,1,0))
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza precos de acordo com a codicao selecionadaณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			    nNatu := N
				
				For nX := 1 to Len(aCols)
					
					N := nX
					aCols[N][nPosVrUnit] := P_Dela015A(,.F.,cCond)
									
				Next
	
				N := nNatu
				
			EndIf
		
			P_LjRodape(M->LQ_CONDPG)
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณValida alteracao de formaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If !Empty( Trim(SL1->L1_FILRES+SL1->L1_ORCRES) ) .And. cCond != SL1->L1_CONDPG
				Aviso( 'Aten็ใo', 'Nใo ้ permitida a altera็ใo das formas de pagamento de um or็amento gerado com reserva.',{'Ok'} )
				Return Nil
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza variaveis e telaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			M->LQ_TIPOJUR := 0
			oDescCondPg:cCaption := GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+cCond,1,"")
			oDescCondPg:nClrText := 255
			oDescCondPg:Refresh()

		EndIf
	 
	Else
	   
		Return Nil

	EndIf

Endif	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณZera array aPgtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Lj7ZeraPgtos()

M->LQ_CONDPG := cCond

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAcrescenta ao aPgtos as parcelas referentes a sinistrosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRecebe
	P_DelA020H()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica permissao do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If LjProfile(9) 

	If nOp == 1	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCondicao negociadaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Lj7R_Rodape("")
		M->LQ_CONDPG:= cDescCondPg:= cCondSE4:= Space(TamSX3("LQ_CONDPG")[1])
		aRet := P_Lj7CondPg(1, "CN", aDadosCNeg[1], Nil, aDadosCNeg[1][8], Nil, Nil, Nil)

	Else
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณForm. Pagamentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aRet := P_Lj7CondPg( 2, cCond )

	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAcrescenta ao aPgtos os dados resultantes de condicao negociadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(aRet) > 0
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณZera aPgtos caso existam parcelas a serem inseridasณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณOrdena formas de pagamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_OrdParcs()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
oPgtos:SetArray( aPgtos )
oPgtos:Refresh()

If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	

oGetVA:Refresh()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAjusta o flag para controle de parcelas geradas por sinistroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_lDelA020 := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Ajusta dadoss da venda ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LJ7AjustaTroco()
Lj7PisCof()			    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNotifica o usuario sobre o uso de duplicatasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_NotifDP(1)

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020J  บAutor  ณNorbert Waage Junior   บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGrava ou le informacoes na tabela de condicoes de pagamento,SL4บฑฑ
ฑฑบ          ณpara tratar parcelas referentes ao sinistro                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcFil - Filial selecionada                                      บฑฑ
ฑฑบ          ณcOrc - Numero do orcamento                                     บฑฑ
ฑฑบ          ณlGrava - .T. na gravacao do orcamento/venda para gravar na SL4 บฑฑ
ฑฑบ          ณ       - .F. na finalizacao da venda, para atualizar o aPgtos  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada na confirmacao e na abertura da venda/orcamentoบฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre as parcelasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aPgtos)
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe houver informacoes adicionaisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If SL4->(DbSeek(cFil + cOrc + cOrigem + StrZero(nX,nSzSeq)))

		If lGrava .And. !Empty(aPgtos[nX][5])
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณArmazena o tipo da administradora no campo L4_OBS.    ณ
			//ณEste campo nao eh utilizado quando se utiliza uma ad- ณ
			//ณministradora.                                         ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			RecLock("SL4",.F.)
			SL4->L4_OBS	:= aPgtos[nX][5]
			MsUnLock()
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณSe for leitura da SL4ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ElseIf !lGrava .And. !Empty(SL4->L4_OBS)
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza aPgtosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aPgtos[nX][5] := AllTrim(SL4->L4_OBS)
		
		EndIf
		
	EndIf	
	
Next nX

RestArea(aAreaSL4)
RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDelA020K  บAutor  ณNorbert Waage Junior   บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณVerifica se o botao calcula sinistro foi acionado e se os valo-บฑฑ
ฑฑบ          ณres foram gerados corretamente.                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณcMsg - Vazia se tudo estiver ok, ou mensagem de erro.          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada na confirmacao da venda                        บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se existe SINISTRO no Apagtos e Atualiza a coluna 5 (Observacao)ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nPosCorr == 0 .AND. nPosSeg == 0 
	For _nX := 1 To Len(aPgtos)
		If Alltrim(aPgtos[_nX][3]) == "CT"  
			nPosCorr	:= _nX
		ElseIf Alltrim(aPgtos[_nX][3]) == "SG"
	   		nPosSeg		:= _nX		
		Endif
	Next       
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLe valores do aPgtosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVlrCorr	:= Iif(nPosCorr !=0,aPgtos[nPosCorr][2],0)
nVlrSeg		:= Iif(nPosSeg  !=0,aPgtos[nPosSeg ][2],0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCalcula os valores de seguro e corretora para comparar comณ
//ณas parcelas                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
P_CalcVSeg(@nTotCorr,@nTotSeg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCompara se os valores coincidemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If (nTotCorr != nVlrCorr) .Or. (nTotSeg != nVlrSeg)

	cMsg :=	"Os valores das parcelas de sinistro nใo estใo de acordo com o percentual de bonifica็ใo definido."+;
			" Execute o cแlculo do sinistro novamente."

EndIf
	
Return cMsg

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLj7CondPg บAutor  ณAndre Veiga*        บ Data ณ  12/08/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o browse  com as parcelas para o pagamento            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณvoid Lj7CondPg( ExpN1, ExpC2, ExpA3, ExpL4 )                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณExpN1 - Tipo da condicao                                    บฑฑ
ฑฑบ          ณ        1 - Chamada por um botao da tela de negociacao      บฑฑ
ฑฑบ          ณ        2 - Chamada por uma condicao de pagamento (SE4)     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpC2 - Forma de pagto. Ex. "R$" / "CH" (Se ExpN1 == 1)     บฑฑ
ฑฑบ          ณ        ou                                                  บฑฑ
ฑฑบ          ณ        Codigo da condicao de pagamento (Se ExpN1 == 2)     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpA3 - Dados para o calculo da condicao de pagamento se    บฑฑ
ฑฑบ          ณ        ExpC2 == "CN" (Condicao Negociada)                  บฑฑ
ฑฑบ          ณ        [1] - Tipo Juros (1)-Simples                        บฑฑ
ฑฑบ          ณ                         (2)-Composto                       บฑฑ
ฑฑบ          ณ                         (3)-Price                          บฑฑ
ฑฑบ          ณ        [2] - Data de Entrada                               บฑฑ
ฑฑบ          ณ        [3] - Valor da Entrada                              บฑฑ
ฑฑบ          ณ        [4] - Taxa de Juros                                 บฑฑ
ฑฑบ          ณ        [5] - Quantidade de parcelas                        บฑฑ
ฑฑบ          ณ        [6] - Intervalo                                     บฑฑ
ฑฑบ          ณ        [7] - Calcula juntos na 1a parcela (.T. ou .F.)     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณExpL4 - .T. - Atualiza ListBox                              บฑฑ
ฑฑบ          ณ        .F. - Apenas faz o calculo (para atualizacao das    บฑฑ
ฑฑบ          ณ              variaveis).                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณLoja701                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ* A rotina abaixo foi baseada na Lj7CondPg original, poremณ
//ณcontempla apenas pagamentos do tipo Cond. Negociada e     ณ
//ณCond. Pagamento.                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica quanto ja foi pago                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If cPaisLoc == "BRA"
   aEval( aPgtos, { |x| nVlrPago+=x[2] } )
Else 
   aEval( aPgtos, {|x| nVlrPago+=Round(xMoeda(x[2],x[_MOEDA],nMoedaCor,dDatabase,nDecimais+1,,nTxMoeda),nDecimais)})
EndIf      

//Comentada a soma do valor do Iss
nVlrPago := nVlrPago + nNCCUsada + LJPCCRet()	// Considera a NCC selecionada

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta as parcelas de acordo com o Botao selecionado          ณ
//ณ ou com a condicao de pagamento (SE4) escolhida               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atribui os valores ref. ao calculo de juros                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Alltrim(cCondicao) == "CN"
	If !Empty(aCondNeg)	// Identifica que foi a escolha de uma NCC
		M->LQ_JUROS 	:= aCondNeg[4]
		M->LQ_TIPOJUR 	:= If(ValType(aCondNeg[1])=="C",Val(Substr(aCondNeg[1],1,1)),aCondNeg[1])
	Endif
Else
	M->LQ_JUROS 	:= Posicione("SE4",1,xFilial("SE4")+cCondicao,"E4_ACRSFIN")
	M->LQ_TIPOJUR 	:= If(M->LQ_JUROS>0,1,0) 	// Quando for calculado via SE4 (formas de pagamento) sera sempre Juros Simples
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Chama a funcao para calculo das parcelas, e tira o frete e a NCC Usada   ณ
//ณ para nao entrar no calculo de juros                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nSobraNCC := If(nNCCUsada-(LJ7T_SubTotal(2)-(LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 )))>0, (LJ7T_SubTotal(2)-(LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ))), nNCCUsada)
If cPaisLoc == "BRA"

	nValParc	:= ( Lj7T_Subtotal( 2 ) - (LJPCCRet()+ iIf( LJ220AbISS(), MaFisRet(,'NF_VALISS'), 0 ))) - LJ7T_DescV( 2 ) - nVlrPago
	nValICMSSol := Iif( MaFisFound("NF"), MAFisRet(, "NF_VALSOL"), 0 )
	aRetPgto    := Lj7CalcPgt(Iif(nValParc >= 0 ,nValParc ,0) , cCondicao, aCondNeg, nVlrFSD,,,, nValICMSSol)

Else
	
	nValParc	:= Lj7T_Total(2)-nVlrPago
	aRetPgto	:= Lj7CalcPgt(Iif(nValParc >= 0 ,nValParc ,0) , cCondicao, aCondNeg, nVlrFSD,,, nMoedaCor)
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o acerto do total na tela de Venda e nas parcelas                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(aRetPgto) > 0
	nVlrAux := 0
	For nX := 1 to Len(aRetPgto)		   
		aAdd( aRet, { aRetPgto[nX][1], aRetPgto[nX][2], aRetPgto[nx][3],{},NIL,;
		                IIf(cPaisLoc!="BRA",aRetPgto[nX][_MOEDA],NIL),IIf(cPaisLoc!="BRA",aRetPgto[nX][_EMISSAO],NIL),;
		                If(Alltrim(aRetPgto[nx][3])$_FORMATEF,"1",Space(01)) } )
		nVlrAux += aRetPgto[nX][2]
	Next nX
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz o recalculo do vencimento das parcelas no caso de uso de Dia Fixo    ณ
	//ณ para vencimento das parcelas.                                            ณ		
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlimenta o array de acrescimo. Avalia se o desconto foi concedido antesณ
//ณou depois do acrescimo.                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If M->LQ_JUROS > 0
	aAcrescimo[1] := nNCCUsada + nVlrAux - Lj7T_SubTotal(2) + Iif(aDesconto[1]==1,aDesconto[3],0) 	// Valor do acrescimo
	aAcrescimo[2] := M->LQ_JUROS															// Percentual do acrescimo
Else
	aAcrescimo[1] := 0								// Valor do acrescimo
	aAcrescimo[2] := 0								// Percentual do acrescimo
Endif
	
Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldApol  บAutor  ณNorbert Waage Junior   บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao da apolice                                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Chave de pesquisa na tabela PA8                               บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Verdadeiro se a apolice for valida                            บฑฑ
ฑฑบ          ณ Falso caso contrario                                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina executada na validacao da apolice do campo M->LR_SINISTRบฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldApol(cChave)

Local lRet		:= .T.
Local aArea		:=	GetArea()
Local nPosIt	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT" })
Local nMesSeg	:=	GetMv("FS_DEL010")	//Quantidade de meses da garantia

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona tabela de Segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM

cChave := RTrim(cChave)

If DbSeek(cChave) 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o item da apolice nao foi especificadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Empty(aCols[N][nPosIt])
		
		lRet := .F.
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPercorre tabela de seguros, em busca de uma apolice valida.ณ
		//ณVerifica-se:                                               ณ
		//ณ-Status (Orcado ou Faturado)                               ณ
		//ณ-Data do Sinistro (Ja sinistrada ou nใo)                   ณ
		//ณ-Validade                                                  ณ
		//ณ-Existencia da apolice+item                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		cMsgErr := "A ap๓lice informada jแ foi sinistrada, nใo estแ na validade ou estแ com status de 'Or็amento'"
	EndIf

Else    

	lRet := .F.
	cMsgErr := "Ap๓lice nใo encontrada"      
	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMostra erroณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
If !lRet
	ApMsgAlert(cMsgErr,"Sinistro")
	aCols[N][nPosIt] := Space(TamSx3("LR_APOIT")[1])
Else
	oGetVA:oBrowse:Refresh()
EndIf

RestArea(aArea)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_GrvTela  บAutor  ณNorbert Waage Junior   บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGravacao dos campos da tela de sinistro                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                                  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro se os campos estiverem preenchidos corretamente     บฑฑ
ฑฑบ          ณFalso caso contrario                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina executada na confirmacao da tela de sinistro            บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona tabela de segurosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("PA8")
DbSetOrder(6)	//PA8_FILIAL+PA8_APOLIC+PA8_CODCLI+PA8_LOJCLI+PA8_ITEM    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe os campos obrigatorios foram preenchidosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cLacre) .Or. Empty(cCodMot) .Or. nKm == 0 .Or. nResiduo == 0
	lRet := .F.
	ApMsgStop("Preencha todos os campos antes de prosseguir","Sinistro")
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida o motivo selecionadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	lRet :=  _VldMot(cCodMot)	
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida a Kilometragemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet .And. DbSeek(xFilial("PA8")+M->(LR_SINISTR+LQ_CLIENTE+LQ_LOJA)+aCols[N][nPosItApo])

	If (nKm - PA8->PA8_KMSG) > GetMv("FS_DEL009")
		lRet := .F.
		ApMsgStop("A kilometragem informada ้ superior เ kilometragem coberta pela ap๓lice selecionada","Nใo permitido")
	ElseIf nKm < PA8->PA8_KMSG
		lRet := .F.
		ApMsgStop("A kilometragem informada ้ inferior เ kilometragem cadastrada na ap๓lice selecionada","Nใo permitido")
	EndIf

EndIf

If lRet

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGrava informacoes no aColsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_VldMot   บAutor  ณNorbert Waage Junior   บ Data ณ  10/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFiltro para selecao do motivo de sinistro                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcMot - Motivo selecionado                                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro caso o motivo possa ser utilizado                   บฑฑ
ฑฑบ          ณFalso caso contrario                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na selecao do motivo de sinistro                บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _VldMot(cMot)

Local lRet 		:= ExistCpo("PAA",cMot)
Local aMotivo	:= GetAdvFVal("PAA",{"PAA_TIPOPR","PAA_DESC"},xFilial("PAA")+cMot,1,{"",""})
Local cGrupo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o motivo pertence ao grupo do produto selecionadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	cGrupo	:= GetAdvFVal("SB1","B1_GRUPO",xFilial("SB1")+aCols[N][aScan(aHeader,{|x| Alltrim(x[2]) == "LR_PRODUTO"})],1,"")
	lRet 	:= (GetAdvFVal("SBM","BM_TIPOPRD",xFilial("SBM")+cGrupo,1,"") == aMotivo[1])	
Else
	cMotivo	:= ""
	Return lRet
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAtualiza descricao do motivoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet
	cMotivo := aMotivo[2]
Else
	ApMsgAlert("O motivo informado nใo pode ser utilizado para o produto a ser sinistrado","C๓digo invแlido")
	cMotivo	:= ""
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_ExistSin บAutor  ณNorbert Waage Junior   บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณVerifica a existencia do sinistro no aCols                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcSinistro - Apolice a ser pesquisada                           บฑฑ
ฑฑบ          ณcItem     - Item da apolice a ser pesquisada                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณVerdadeiro caso a apolice nao esteja no aCols                  บฑฑ
ฑฑบ          ณFalso caso ja exista a apolice no aCols                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada na validacao da apolice                         บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _ExistSin(cSinistro,cItem)

Local nX
Local nLen	:= Len(aCols)
Local lRet	:=	.T.
Local nPosItApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_APOIT"   })
Local nPosApo	:=	aScan(aHeader,{|x| Alltrim(x[2]) == "LR_SINISTR" })
             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre aColsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to nLen
	If (nX != N) .And. (aCols[nX][nPosApo]+aCols[nX][nPosItApo] == cSinistro+cItem)
		lRet := .F.
		nX := nLen + 1
	EndIf
Next nX

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TelaCond บAutor  ณNorbert Waage Junior   บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta e exibe tela para selecao de condicao negociada          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณaDadosCNeg - Array que contem os campos a serem exibidos       บฑฑ
ฑฑบ          ณaTipoJuros - tem da apolice a ser pesquisada                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet (.T.) - Usuario confirmou a tela                          บฑฑ
ฑฑบ          ณ     (.F.) - Usuario cancelou a tela                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo bocao Condic.Negociada                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _TelaCond(aDadosCNeg,aTipoJuros)

Local lRet := .F.
Local oDlg1	:=	NIL

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria a telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 270,380 PIXEL TITLE "Condi็ใo Negociada" of oMainWnd

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos camposณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento do dia fixoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SL1->(FieldPos("L1_DIAFIXO")) > 0
	@ 115, 010 CHECKBOX aDadosCNeg[2][8] VAR aDadosCNeg[1][8] PROMPT "Dia Fixo" SIZE 100,07  WHEN (Subst(aDadosCNeg[1,1],1,1)$"12") PIXEL OF oDlg1;
	ON CHANGE (If (aDadosCNeg[1][8],aDadosCNeg[1][6]:=Day(dDataBase),aDadosCNeg[1][6] := 30), aDadosCNeg[2][6]:Refresh(), oIntDVenc:Refresh())	
EndIf

//ฺฤฤฤฤฤฤฟ
//ณBotoesณ
//ภฤฤฤฤฤฤู
DEFINE SBUTTON FROM 120,120 TYPE 1 ENABLE OF oDlg1 ACTION (oDlg1:End(), lRet := .T.)
DEFINE SBUTTON FROM 120,150 TYPE 2 ENABLE OF oDlg1 ACTION (oDlg1:End())    

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_TelaForPGบAutor  ณNorbert Waage Junior   บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta e exibe tela para selecao da forma de pagamento          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณcCond - Condicao de pagamento a ser manipulada                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet (.T.) - Usuario confirmou a tela                          บฑฑ
ฑฑบ          ณ     (.F.) - Usuario cancelou a tela                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo bocao Condic.Pagamento                     บฑฑ
ฑฑฬออออออออออฯอออัออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista      ณ Data   ณBops  ณManutencao Efetuada                        บฑฑ
ฑฑฬออออออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ              ณ        ณ      ณ                                           บฑฑ
ฑฑฬออออออออออัอออฯออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _TelaForPG(cCond)

Local aArea		:=	GetArea()
Local oCond		:=	NIL
Local lRet		:= .F.
Local oDlg1		:=	NIL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializa variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLe validacao do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cVldLQCondPg := GetAdvFVal("SX3","X3_VLDUSER","LQ_CONDPG",2,)

If Empty(cVldLQCondPg)
	cVldLQCondPg := ".T."
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg1 FROM 0,0 TO 110,210 PIXEL TITLE "Condi็ใo de Pagamento" of oMainWnd

@ 10, 005 SAY "Condi็ใo de Pgto.:" PIXEL OF oDlg1

@ 10, 060 MSGET oCond VAR M->LQ_CONDPG F3 Posicione("SX3",2,"LQ_CONDPG ","X3_F3");
Valid (  (!Empty(M->LQ_CONDPG) .And. ExistCpo("SE4",M->LQ_CONDPG)) .And. &(cVldLQCondPg)) ;
Size 35,10 PIXEL OF oDlg1

//ฺฤฤฤฤฤฤฟ
//ณBotoesณ
//ภฤฤฤฤฤฤู
DEFINE SBUTTON FROM 30,45 TYPE 1 ENABLE OF oDlg1 ACTION (Iif(!Empty(M->LQ_CONDPG),(oDlg1:End(), _cD020CPG:=cCond:=M->LQ_CONDPG, _lCPGCN :=.f., lRet := .T.),.F.))
DEFINE SBUTTON FROM 30,75 TYPE 2 ENABLE OF oDlg1 ACTION (oDlg1:End())    

ACTIVATE MSDIALOG oDlg1 CENTERED 

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDL020TelaAdmบAutorณPaulo Benedet          บ Data ณ  28/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณMonta e exibe tela para selecao da seguradora/corretora        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณnElem - Numero da linha do array aPgtos                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณCod Adm + " - " + Nome Adm                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina chamada pelo ponto de entrada LJ7021                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ13797 - Della Via Pneus                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//Valor do tกtulo:
@ 01.0, 02.0 SAY "Valor do tํtulo:" SIZE 10,1 FONT aFontes[1] OF oDlgAdm
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณd20RecChq บAutor  ณPaulo Benedet          บ Data ณ  25/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tela de valores recebidos                                     บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo botao condicao de pagto da tela 'definir  บฑฑ
ฑฑบ          ณ pagtos' da venda assistida (somente recebto titulos)          บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aNwHead, {"Data", "L4_DATA", "", 8,;
	0, "M->L4_DATA >= dDataBase", "€€€€€€€€€€€€€", "D",;
	"", "V", "", ""})

aAdd(aNwHead, {"Valor", "L4_VALOR", "@E 99,999,999.99", 12,;
	2, "Positivo()", "€€€€€€€€€€€€€", "N",;
	"", "V", "", ""})

aAdd(aNwHead, {"Forma", "L4_FORMA", "", 1,;
	0, "Pertence('12')", "€€€€€€€€€€€€€", "C",;
	"", "V", "1=Cheque;2=Dinheiro", "'1'"})

nUsado  := Len(aNwHead)
npData  := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_DATA"})
npValor := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_VALOR"})
npForma := aScan(aNwHead, {|x| rTrim(x[2]) == "L4_FORMA"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aCols ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Exibe Tela ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
While lTela
	Define msDialog poDlg Title "Informe as datas e valores" from 177,182 to 430,583 Pixel
		@ 001,004 to 105,200 Label "" Pixel of poDlg
		
		@ 078,008 Say "Valor do tํtulo:" Size 038,008 Pixel of poDlg
		@ 078,162 Say poValTit Var cValTit Right Size 033,008 Pixel of poDlg
		@ 092,008 Say "Valor lan็ado:" Size 036,008 Pixel of poDlg
		@ 092,162 Say poValInf Var cValInf Right Size 033,008 Pixel of poDlg
		
		Define sButton from 112,168 Type 1 Enable of poDlg Action(IIf(poNwGd:TudoOk(), (lTela := .F., poDlg:End()), .F.))
		
		poNwGd := msNewGetDados():New(008, 008, 068, 196, nTipo, "P_d20VLin(poNwGd:nAt)", "P_d20VLin()",,,,, "P_d20VCpo()",, "P_d20VDel(poNwGd:nAt)", poDlg, aNwHead, aNwCols)
	Activate msDialog poDlg Centered
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza aPgtos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
M->LQ_CONDPG := "CN"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Estrutura do array aPgtos                                    ณ
//ณฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤณ
//ณ [1] - Data de pagamento das parcelas                         ณ
//ณ [2] - Valor da parcelas                                      ณ
//ณ [3] - Forma de Pagamento                                     ณ
//ณ [4] - Codigo da Administradora financeira                    ณ
//ณ [5] - Coluna Customizada pelo ponto de entrada LJ7012        ณ
//ณ [6] - Moeda(Localizacoes)                                    ณ
//ณ [7] - Data de emissao(Localizacoes)                          ณ
//| [8] - Sequencia para controle de m๚ltiplas transa็๕ies		 |
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
                      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza aPgtosSint ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If SL4->(FieldPos("L4_FORMAID")) > 0
	aPgtosSint := Lj7MontPgt(aPgtos)
	oPgtosSint:SetArray(Lj7MontPgt(aPgtos))
	oPgtosSint:Refresh()
EndIf	

oGetVA:Refresh()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ d20VCpo  บAutor  ณPaulo Benedet          บ Data ณ  25/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualizar valores a receber                                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T.                                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Validacao do campo na getdados de valores a receber           บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function d20VCpo()
Local nTotLin := Len(poNwGd:aCols) // total de linhas
Local npValor := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_VALOR"}) // posicao da coluna valor
Local nTotLan := 0 // valor total lancado
Local i //for next

If "L4_VALOR" $ __ReadVar
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza total de cheques ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ d20VLin  บAutor  ณPaulo Benedet          บ Data ณ  25/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validar linhas                                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nLin - Numero da linha                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T. - linha correta                                           บฑฑ
ฑฑบ          ณ .F. - linha incorreta                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Validacao da linha na getdados de valores a receber           บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ valida campo vazio ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ valida duas linhas dinheiro ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For j := 1 to nTotLin
				If j <> i
					If !aTail(poNwGd:aCols[j])
						If poNwGd:aCols[j][npForma] == "2"
							msgAlert("Jแ existe dinheiro informado!", "Aviso")
							lRet := .F.
							Exit
						EndIf
					EndIf
				EndIf
			Next j
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ valida dinheiro a prazo ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If poNwGd:aCols[i][npData] <> dDataBase
				msgAlert("Dinheiro somente เ vista!", "Aviso")
				lRet := .F.
			EndIf
		EndIf
		
		If !lRet
			Exit
		EndIf
		
		nTotLan += poNwGd:aCols[i][npValor]
	EndIf
Next i

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ valida valor total digitado ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lRet .And. ValType(nLin) == "U"
	If Lj7T_Total(2) <> nTotLan
		msgAlert("Valor a receber nใo bate com o valor do tํtulo!", "Aviso")
		lRet := .F.
	EndIf
EndIf

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ d20VDel  บAutor  ณPaulo Benedet          บ Data ณ  25/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Atualizar valor total das parcelas                            บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ nLin - Numero da linha                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ .T.                                                           บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Validacao da delecao da linha na getdados de valores a receberบฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function d20VDel(nLin)
Local nTotLin := Len(poNwGd:aCols) // total de linhas
Local npValor := aScan(poNwGd:aHeader, {|x| rTrim(x[2]) == "L4_VALOR"}) // posicao da coluna valor
Local nTotLan := 0 // valor total lancado
Local i //for next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Atualiza total de cheques ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to nTotLin
	If !aTail(poNwGd:aCols[i])
		nTotLan += poNwGd:aCols[i][npValor]
	EndIf
Next i

poValInf:cTitle := Transform(nTotLan, "@E 99,999,999.99")
poValInf:Refresh()

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณd20RecTit บAutor  ณPaulo Benedet          บ Data ณ  25/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Efetuar liquidacao dos titulos                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ aTitRec - Array com os titulos recebidos                      บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina chamada pelo ponto de entrada LjRecComp                บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava cheques recebidos ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava informacoes no titulo pago ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCURGRVTIT บAutor  ณAndre Schwartz      บ Data ณ  24/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada do lojxrec na impressใo do cumpom fiscal  บฑฑ
ฑฑบ          ณ Utilizado para gerar outro titulo a receber caso o         บฑฑ
ฑฑบ          ณ seja feito em Cheque ou cartใo                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvTit(aNewTit)
Private lMsErroAuto := .F.

msExecAuto({|x, y| FinA040(x, y)}, aNewTit, 3)

If !lMSErroAuto
	If (__lSx8)
		ConfirmSX8()
	EndIf
Else
	MsgInfo("Nใo foi possํvel gerar os Tํtulos a Receber.")
	RollBackSx8()
	DisarmTransaction()
	MostraErro()
EndIF

Return(!lMSErroAuto)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ ProcNumLiq   บAutor  ณPaulo Benedet         บ Data ณ 08/06/06 บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Procura proximo numero de liquidacao                          บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha                                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ cNumLiq - Numero da liquidacao                                บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada pelo ponto de entrada LJRECCOMP              บฑฑ
ฑฑฬออออออออออุออออออออัออออออัอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณ Data   ณBops  ณManutencao Efetuada                            บฑฑ
ฑฑฬออออออออออุออออออออุออออออุอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                               บฑฑ
ฑฑฬออออออออออุออออออออฯออออออฯอออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Della Via Pneus                                               บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
