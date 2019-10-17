#INCLUDE "protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWSEPU01   บAutor  ณ Ely/Jader          บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWORKFLOW PROCESSO SEPU                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function WSEPU01()

//-- Envia e-mail para o comercial
WEnvSEPU(1)                       
//-- Envia e-mail para a diretoria
WEnvSEPU(2)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWEnvSEPUE บAutor  ณ Ely/Jader          บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWORKFLOW PROCESSO SEPU                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function WEnvSEPU(nDestino)

LOCAL oLembrete, oHtml
LOCAL aAliasAnt       := GetArea()
LOCAL cEMailComercial := Alltrim(GetMv("MV_WSEPU01"))
LOCAL cEMailDiretor   := Alltrim(GetMv("MV_WSEPU02"))
LOCAL cPathWf         := Alltrim(GetMv("MV_WSEPU03"))
LOCAL nPrecoServico   := 0
LOCAL cMotivoProducao := '', cStatusProducao  := '' 
LOCAL cMotivoComercial:= '', cStatusComercial := '' 
LOCAL cMotivoDiretoria:= '', cStatusDiretoria := '' 

If nDestino == 1  // comercial
	cPathWf := cPathWf + "SEPUCOM.HTM"
ElseIf nDestino == 2  // diretoria
	cPathWf := cPathWf + "SEPUDIR.HTM"
Endif

CONOUT('SEPU Solicitacao Exame Pneus Usados '+If(nDestino==1,'Comercial','Diretoria')+' - Inicializado...')

// Inicializa a Classe TWFProcess
oLembrete := TWFProcess():New('SEPU01','SEPU Solicitacao Exame Pneus Usados')

// Abro as Tabelas Necessarias ao Processamente
ChkFile('SC2') // Ordem de Producao - ้ onde existem as informa็๕es do Laudo Exame Pneu
ChkFile('SE1') // Titulos a Receber - para gravacao da NCC
ChkFile('SA1') // tabela de clientes
ChkFile('SB1') // tabela de produtos
ChkFile('SD1') // tabela de itens notas fiscais entrada
ChkFile('SF1') // tabela cabe็alho de notas fiscais entrada
ChkFile('SZS') // tabela de motivos SEPU

SA1->(dbSetOrder(1))      
SC2->(dbSetOrder(1))                         
SB1->(dbSetOrder(1))
SE1->(dbSetOrder(1))
// Altera็ใo efetuada para compatibilizar a troca de s้rie da nota fiscal de entrada - Coleta (by Golo)
SD1->(dbSetOrder(1))
SF1->(dbSetOrder(1))
SZS->(dbSetOrder(1))

// Altera็ใo efetuada para compatibilizar a troca de s้rie da nota fiscal de entrada - Coleta (by Golo)
If ! SF1->(dbSeek(xFilial("SF1")+SC2->C2_NUMD1+SC2->C2_SERIED1+SC2->C2_FORNECE+SC2->C2_LOJA,.f.)) .Or. ! (SF1->F1_TIPO == "B")
	CONOUT('NAO ENCONTROU NOTA FISCAL ENTRADA COLETA ('+SC2->C2_NUM+'), OU COLETA ENCONTRADA NAO EH DO TIPO BENEFICIAMENTO ('+SF1->F1_TIPO+')')
	Return(.F.)
EndIf

If ! SA1->(dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.f.))
	CONOUT('NAO ACHOU CLIENTE '+SF1->F1_FORNECE+'-'+SF1->F1_LOJA)
	Return(.F.)
EndIf

If ( !SD1->( dbSeek(xFilial("SD1")+SC2->C2_NUMD1+SC2->C2_SERIED1+SC2->C2_FORNECE+SC2->C2_LOJA+SC2->C2_ITEMD1,.f.) ) .Or. ! ( SD1->D1_TIPO == "B" ) ) /////.Or. ! ( SC2->C2_PRODUTO == SD1->D1_COD ) )
	CONOUT('NAO ENCONTROU ITEM DA NOTA FISCAL ENTRADA COLETA ('+SC2->C2_NUM+'), OU COLETA ENCONTRADA NAO EH DO TIPO BENEFICIAMENTO ('+SF1->F1_TIPO+')')
	Return(.F.)
EndIf
                                         
cCodServExame := SD1->D1_SERVICO

//-- Se Email comercial nao estiver preenchido, nao executa WF
If Empty(cEMailComercial)
	ConOut('E-MAIL COMERCIAL NAO CADASTRADO')
	Return(.F.)
Endif

// valida dados digitados no email, verifica se o campo esta correto
If ! ( ('@' $ cEMailComercial) .and. (".COM" $ upper(cEMailComercial)) )
	ConOut('E-MAIL COMERCIAL INVALIDO')
	cEmailComercial := ''
Endif

//-- Se Email diretor nao estiver preenchido, nao executa WF
If Empty(cEMailDiretor)
	ConOut('E-MAIL DIRETOR NAO CADASTRADO')
	Return(.F.)
Endif

// valida dados digitados no email, verifica se o campo esta correto
If ! ( ('@' $ cEMailDiretor) .and. (".COM" $ upper(cEMailDiretor)) )
	ConOut('E-MAIL DIRETOR INVALIDO')
	Return(.F.)
Endif

// Crio uma nova tarefa para o processo
oLembrete:NewTask('500000',cPathWf)

// Usa o objeto HTML criado pelo processo acima
oHtml := oLembrete:oHtml

// Email usuario no para
oLembrete:cTo:=Rtrim(Lower(cEMailDiretor))

// Subject do Email
oLembrete:cSubject :='SEPU-' + SC2->C2_NUM +"-"+AllTrim(SA1->A1_NOME) + ' - Solicitacao Exame Pneus Usados' //Acrescentado por Fabricio - 09/11/2005

// Preenche Dados do Formulario - Folder CLIENTE
oHtml:ValByName( 'CLIENTE'   , SA1->A1_COD+"-"+AllTrim(SA1->A1_NOME) )
oHtml:ValByName( 'ENDERECO' , AllTrim(SA1->A1_END) )
oHtml:ValByName( 'CIDADE'   , AllTrim(SA1->A1_MUN) )
oHtml:ValByName( 'ESTADO'   , AllTrim(SA1->A1_EST) )
oHtml:ValByName( 'FONE'     , AllTrim(SA1->A1_TEL) )
oHtml:ValByName( 'ULTCOM'   , dToC(SA1->A1_ULTCOM) )
oHtml:ValByName( 'RISCO'    , SA1->A1_RISCO )

// Preenche Dados do Formulario - Folder FICHA INSPECAO
oHtml:ValByName( 'COLETAORIGINAL'     , SC2->C2_XCOLORI )
oHtml:ValByName( 'DATACOLETAORIGINAL' , SC2->C2_XDPRDOR )
oHtml:ValByName( 'NFFATURAORIGINAL'   , SC2->C2_XULTNF )
oHtml:ValByName( 'DATAFATURAORIGINAL' , SC2->C2_XDFATOR )
oHtml:ValByName( 'COLETAEXAME'        , SC2->C2_NUM+SC2->C2_ITEM )
oHtml:ValByName( 'DATACOLETAEXAME'    , SF1->F1_DTDIGIT )
oHtml:ValByName( 'DATAINSPECAOOP'     , SC2->C2_EMISSAO )

nPrecoServico := U_BuscaPrcVenda(SD1->D1_SERVICO,SD1->D1_FORNECE,SD1->D1_LOJA)

//ACRESCENTADO TESTE PARA O PREวO SUGERIDO - FABRICIO - 09/11/2005
If SC2->C2_XPRCORI>0
	nPrecoSugerido:= Round( ( SC2->C2_XPROFAF / SC2->C2_XPROFOR ) * SC2->C2_XPRCORI , 2 )
Else
	nPrecoSugerido:= Round( ( SC2->C2_XPROFAF / SC2->C2_XPROFOR ) * nPrecoServico , 2 )
EndiF

// Preenche Dados do Formulario - Folder FICHA PNEU
oHtml:ValByName( 'MEDIDA'          , SC2->C2_PRODUTO )
oHtml:ValByName( 'MARCA'           , SC2->C2_MARCAPN )
oHtml:ValByName( 'BANDA'           , SC2->C2_XBANDA )
oHtml:ValByName( 'SERIE'           , SC2->C2_SERIEPN )
oHtml:ValByName( 'FOGO'            , SC2->C2_NUMFOGO)
oHtml:ValByName( 'CODSERVORIGINAL' , SC2->C2_XSERVOR )
oHtml:ValByName( 'CODSERVEXAME'    , SD1->D1_SERVICO )
oHtml:ValByName( 'PRCTAB'          , nPrecoServico )
oHtml:ValByName( 'PROFORIGINAL'    , SC2->C2_XPROFOR )
oHtml:ValByName( 'PROFAFERIDA'     , SC2->C2_XPROFAF )
oHtml:ValByName( 'VALORSUGERIDO'   , nPrecoSugerido )
                
//-- Pesquisa Motivo SEPU colocado pela Producao
cMotivoProducao := RetMotivos(SC2->C2_XMREPRD,.F.)
cObservProducao := MSMM(SC2->C2_XCOBS1,,,,3)

//-- Preenche Dados do Formulario - Folder INSPECAO PRODUCAO
oHtml:ValByName( 'MOTIVOPRODUCAO'  , cMotivoProducao )
oHtml:ValByName( 'OBSPRODUCAO'     , cObservProducao )

//-- Pesquisa Motivo SEPU colocado pelo Comercial                                                
If Empty(SC2->C2_XMREFIN)
	cMotivoComercial := RetMotivos(SC2->C2_XMREPRD,.T.,"02")
	cObservComercial := cObservProducao
Else
	cMotivoComercial := RetMotivos(SC2->C2_XMREFIN,.F.)
	cObservComercial := MSMM(SC2->C2_XCOBS2,,,,3)
Endif

// Preenche Dados do Formulario - Folder INSPECAO COMERCIAL
oHtml:ValByName( 'MOTIVOCOMERCIAL'  ,cMotivoComercial )
oHtml:ValByName( 'OBSCOMERCIAL'     ,cObservComercial )

If nDestino == 2  // diretoria

	oHtml:ValByName( 'VALORCREDITO'    , nPrecoSugerido )
	

	//-- Pesquisa Motivo SEPU colocado pela Diretoria                                                
	
	If Empty(SC2->C2_XMREDIR)    
		If ! Empty(SC2->C2_XMREFIN)
			cMotivoDiretoria := RetMotivos(SC2->C2_XMREFIN,.T.)
			cObservDiretoria := cObservComercial
		Else
			cMotivoDiretoria := RetMotivos(SC2->C2_XMREPRD,.T.)
			cObservDiretoria := cObservProducao
		Endif
	Else
		cMotivoDiretoria := RetMotivos(SC2->C2_XMREDIR,.F.)
		cObservDiretoria := MSMM(SC2->C2_XCOBS3,,,,3)
	Endif
	                                 
	// Preenche Dados do Formulario - Folder INSPECAO PRODUCAO
	oHtml:ValByName( 'MOTIVODIRETORIA'  ,cMotivoDiretoria ) 
	oHtml:ValByName( 'OBSDIRETORIA'     ,cObservDiretoria )
	
Endif
 
If nDestino == 1
	oHtml:ValByName( 'DESTINO' , 'COMERCIAL' )
ElseIf nDestino == 2	
	oHtml:ValByName( 'DESTINO' , 'DIRETORIA' )
Endif	

//Funcao para validar o Time-Out ref. Resposta do Email
//oLembrete:bTimeOut := {{'U_SEPUTimeOut',4,6,30}}
oLembrete:bTimeOut := {{'U_SEPUTimeOut',30,6,30}}

// Funcao para leitura do retorno
oLembrete:bReturn := 'U_SEPURetLem()'

// Funcao para Startar o envio do Email WorkFlow
oLembrete:Start()

RestArea(aAliasAnt)

CONOUT('SEPU Solicitacao Exame Pneus Usados '+If(nDestino==1,'Comercial','Diretoria')+' - Finalizado...')

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEPURETLEMบAutor  ณ Ely/Jader          บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para leitura dos retornos emails ref lembretes       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION SEPURetLem(oLembrete)

LOCAL   oHtml
LOCAL   cStatusDiretoria := '', cStatusComercial := '', cObsDiretoria := '', cObsComercial := ''
LOCAL   nValorCredito    := 0, cColetaExame := '', cColetaOriginal := '', cMotivoDiretoria := '' , cMotivoComercial := ''
LOCAL   cParcela         := '' 
LOCAL   nDestino         := 0
LOCAL   cDestino         := '' 
LOCAL   cPadraoCom       := ''
LOCAL   cPadraoDir       := ''
LOCAL   lAprovado        := .F.
PRIVATE lMsHelpAuto      := .F.
PRIVATE lMsErroAuto      := .F.   
PRIVATE _aReg            := {}  
//PRIVATE aMemos           := {{"C2_XCOBS2","C2_XOBS2"},{"C2_XCOBS3","C2_XOBS3"}}
                                      
conout("Retorno do processo de SEPU - Iniciando...")

// Faz uso do objeto ohtml que pertence ao processo
oHtml := oLembrete:oHtml

cDestino := oHtml:RetByName('DESTINO')

If cDestino == "COMERCIAL"
	nDestino := 1
ElseIf cDestino == "DIRETORIA"
	nDestino := 2
Endif

//-- Busca valores pra atualizar tabelas.
cMotivoComercial := Substr(oHtml:RetByName('MOTIVOCOMERCIAL'),1,3)
cObsComercial    := oHtml:RetByName('OBSCOMERCIAL')
cColetaExame     := oHtml:RetByName('COLETAEXAME')
cColetaOriginal  := oHtml:RetByName('COLETAORIGINAL')

If nDestino == 2  // diretoria
	cMotivoDiretoria := Substr(oHtml:RetByName('MOTIVODIRETORIA'),1,3)
	cObsDiretoria    := oHtml:RetByName('OBSDIRETORIA')
	nValorCredito    := Val(oHtml:RetByName('VALORCREDITO'))
Endif
	
conout("Variaveis inicializadas...")
conout("Motivo Comercial: "+cMotivoComercial)
conout("Observ. Comercial: "+cObsComercial)
conout("Motivo Diretoria: "+cMotivoDiretoria)
conout("Observ. Diretoria: "+cObsDiretoria)

ChkFile("SC2")
ChkFile("SE1")
ChkFile("SA1")
ChkFile("SF1")
ChkFile("SZS")
//ChkFile("SYP")
//ChkFile("SXE")
//ChkFile("SXF")

dbSelectArea("SC2")
dbSetOrder(1)
If ( Empty(cColetaExame) .Or. ( ! dbSeek( xFilial("SC2")+cColetaExame,.f.) ) )
   Conout("Nao Encontrou Coleta de Exame relacionada a este email")
   Return(.f.)
EndIf      

If nDestino == 1 // comercial

	SZS->( dbSetOrder(1) )
	SZS->( dbSeek(xFilial("SZS")+cMotivoComercial,.F.) )
	
	cPadraoCom := MSMM(SC2->C2_XCOBS2,,,,3)

ElseIf nDestino == 2 // diretoria

	SZS->( dbSetOrder(1) )
	SZS->( dbSeek(xFilial("SZS")+cMotivoDiretoria,.F.) )
	
	If SZS->ZS_APROVA == "S"
		lAprovado := .T.
	Else	
		lAprovado := .F.
	Endif	

	cPadraoDir := MSMM(SC2->C2_XCOBS3,,,,3)

Endif
// Alterado para compatibilizar a troca da serie da nota fiscal de entrada - Coleta
SF1->( dbSetOrder(1) )
//SF1->( dbSeek(xFilial("SF1")+Substr(cColetaExame,1,6),.f. ) )
SF1->( dbSeek(xFilial("SF1")+SC2->C2_NUMD1+SC2->C2_SERIED1+SC2->C2_FORNECE+SC2->C2_LOJA,.f. ) )
SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,.f. ) )

If ! lAprovado
	nValorCredito := 0
Endif	

If nDestino == 1 // comercial

	dbSelectArea("SC2")
	RecLock("SC2",.F.)
	SC2->C2_XMREFIN := cMotivoComercial
	MsUnlock()
    //MSMM(SC2->C2_XCOBS2,80,,cObsComercial,1,,,"SC2","C2_XOBSC2")
    If Empty(cObsComercial)
    	cObsComercial := cPadraoCom
    Endif
    If Empty(SC2->C2_XCOBS2)
	    MSMM(,80,,cObsComercial,1,,,"SC2","C2_XCOBS2")
    Else
    	MSMM(SC2->C2_XCOBS2,80,,cObsComercial,1,,,"SC2","C2_XCOBS2")
    Endif	

ElseIf nDestino == 2 // diretoria

	dbSelectArea("SC2")
	RecLock("SC2",.F.)
    SC2->C2_XMREDIR := cMotivoDiretoria
    SC2->C2_XVALAPR := nValorCredito
    MsUnlock()
    If Empty(cObsDiretoria)
    	cObsDiretoria := cPadraoDir
    Endif
//    MSMM(SC2->C2_XCOBS3,80,,cObsDiretoria,1,,,"SC2","C2_XOBSC3")
    If Empty(SC2->C2_XCOBS3)
	    MSMM(,80,,cObsDiretoria,1,,,"SC2","C2_XCOBS3")
	Else
		MSMM(SC2->C2_XCOBS3,80,,cObsDiretoria,1,,,"SC2","C2_XCOBS3")
	Endif	    

EndIf

//-- Inclui NCC caso aprovado

If nDestino == 1 // comercial

	//-- Envia e-mail para a diretoria
	WEnvSEPU(2)	

ElseIf nDestino == 2 // diretoria

	SZS->( dbSetOrder(1) )
	SZS->( dbSeek(xFilial("SZS")+cMotivoDiretoria,.F.) )

   	ConOut("Motivo diretoria: "+cMotivoDiretoria+"  Tipo: "+SZS->ZS_TIPO)
	
	//If nValorCredito > 0 .And. ! Empty(SZS->ZS_TIPO) .And. SZS->ZS_TIPO <> "5" // Aprova
	If nValorCredito > 0 .And. lAprovado
	   
	    //-- gera numero da parcela com letra equivalente ao item da coleta
		cParcela := Chr( ( Asc("A") - 1 ) + Val(Substr(cColetaExame,7,2)) )
// Altera็ใo efetuada para compatibilizar a troca de s้rie da nota fiscal de entrada - Coleta
		
		dbSelectArea("SE1")
		dbSetOrder(2)
		MsSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+"SEP"+Substr(cColetaExame,1,6)+cParcela+"NCC")

		If ! Eof()

        	    	ConOut("O titulo SEP-"+Substr(cColetaExame,1,6)+"-"+cParcela+" ja existe. Nada foi feito.")

                Else	
			
			AAdd( _aReg, { "E1_FILIAL"  , xFilial("SE1")                  , NIL } )
			AAdd( _aReg, { "E1_PREFIXO" , "SEP"                           , NIL } )
			AAdd( _aReg, { "E1_NUM"     , Substr(cColetaExame,1,6)        , NIL } )
			AAdd( _aReg, { "E1_PARCELA" , cParcela                        , NIL } )
			AAdd( _aReg, { "E1_TIPO"    , "NCC"                           , NIL } )
			AAdd( _aReg, { "E1_NATUREZ" , "1300"                          , NIL } )
			AAdd( _aReg, { "E1_CLIENTE" , SF1->F1_FORNECE                 , NIL } )
			AAdd( _aReg, { "E1_LOJA"    , SF1->F1_LOJA                    , NIL } )
			AAdd( _aReg, { "E1_EMISSAO" , dDataBase                       , NIL } )
			AAdd( _aReg, { "E1_VENCTO"  , dDataBase                       , NIL } )
			AAdd( _aReg, { "E1_VENCREA" , DataValida(dDataBase,.T.)       , NIL } )
			AAdd( _aReg, { "E1_VALOR"   , nValorCredito                   , NIL } )
			AAdd( _aReg, { "E1_MOTDESC" , cMotivoDiretoria                , NIL } )
			AAdd( _aReg, { "E1_COLETA"  , Substr(cColetaOriginal,1,6)     , NIL } )
				
      		    MsExecAuto( {|x,y| Fina040(x,y)}, _aReg, 3 )
		
		    //-- Verifica se houve algum erro.
		    If lMsErroAuto
		    	ConOut("Houve um erro na criacao do titulo SEP-"+Substr(cColetaExame,1,6)+"-"+cParcela)
		    	//MostraErro()
		    	
		    EndIf

		EndIf
		
	Else
        
	  ConOut("SEPU recusado. Nada foi feito.")

	EndIf
    
	// Envio de email para o faturamento imprimir e enviar carta de SEPU para o cliente
    cAssunto  := "Impressao de Carta SEPU"
    cMensagem := "Favor emitir e enviar a carta do SEPU para a coleta "+cColetaExame+" "+If(lAprovado,"APROVADO","REPROVADO")+" para o cliente "+SA1->A1_NREDUZ
        
    EAviso(cAssunto,cMensagem)

Endif
	
// Finaliza o processo.
oLembrete:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEPUTimeOutบAutor  ณ Ely               บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida time-out no retorno do emails, caso o participante   บฑฑ
ฑฑบ          ณnao responta o sistema ira encrrar o processo (3 dias para  บฑฑ
ฑฑบ          ณvalidacao)                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SEPUTimeOut(oLembrete)

// Finaliza o processo.
oLembrete:Finish()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSEPUTimeOutบAutor  ณ Ely               บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJob para disparar emails workflow ref a lembrete            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION SEPUWFENV()

//Preparando Ambiente
PREPARE ENVIRONMENT EMPRESA "03" FILIAL "01" FUNNAME "DURAPOL"

ChkFile('SC2') // Ordem de Producao - ้ onde existem as informa็๕es do Laudo Exame Pneu
ChkFile('SE1') // Titulos a Receber - para gravacao da NCC
ChkFile('SA1') // tabela de clientes
ChkFile('SB1') // tabela de produtos
ChkFile('SD1') // tabela de itens notas fiscais entrada
ChkFile('SF1') // tabela de itens notas fiscais entrada
ChkFile('SZS')  // tabela de motivos SEPU

//Processa Rotina
U_WSEPU01()

RESET ENVIRONMENT

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMotivos บAutor  ณ Jader             บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retorno do combo de motivos de reprovacao      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetMotivos(cMotivo,lTodos,cFiltro)

Local aAliasAnt := GetArea()
Local aMotivos  := {}

If cMotivo == NIL
	cMotivo := ""
Endif	
If lTodos == NIL
	lTodos := .T.
Endif	
If cFiltro == NIL
	cFiltro := ""
Endif	

dbSelectArea("SZS")
dbSetOrder(1) 

If ! Empty(cMotivo)
	MsSeek(xFilial("SZS")+cMotivo)
	AAdd(aMotivos,SZS->ZS_COD+" - "+Alltrim(SZS->ZS_DESCR)+" - "+Alltrim(U_StatSEPU(SZS->ZS_TIPO)))
Endif

If lTodos
	
	MsSeek(xFilial("SZS"))
	
	While ! Eof() .And. SZS->ZS_FILIAL == xFilial("SZS")
		If ! Empty(cMotivo)
			If SZS->ZS_COD == cMotivo
				dbSkip()
				Loop
			Endif
		Endif		
		If ! Empty(cFiltro)
			If SZS->ZS_GRUPO <> cFiltro
				dbSkip()
				Loop
			Endif
		Endif		
		//AAdd(aMotivos,SZS->ZS_COD+" - "+Alltrim(SZS->ZS_DESCR)+" - "+Alltrim(U_StatSEPU(SZS->ZS_TIPO)))
		AAdd(aMotivos,SZS->ZS_COD+" - "+Alltrim(SZS->ZS_DESCR)+" - "+If(SZS->ZS_APROVA=="S","APROVADO","RECUSADO"))
		dbSkip()
	Enddo

Endif
	
RestArea(aAliasAnt)

Return(aMotivos)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัอออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetMotivos บAutor  ณ Jader             บ Data ณ  23/08/05   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯอออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para retorno do combo de motivos de reprovacao      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EAviso(cAssunto,cMensagem)
// Alterado para compatibilizar a troca da serie da nota de entrada - coleta
Local cEmailTo  := GetMV( xFilial(SC2)+"MV_WSEPU04" )
Local cEmailBcc := ""
Local lResult   := .F.
Local cError    := ""
Local cAccount	:= GetMV( "MV_WFMAIL" )
Local cPassword	:= GetMV( "MV_WFPASSW" )
Local cServer	:= GetMV( "MV_WFSMTP" )
Local cFrom		:= GetMV( "MV_WFMAIL" )
Local cAttach 	:= ""

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

If lResult
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	BCC     	cEmailBcc;
	SUBJECT 	cAssunto;
	BODY    	cMensagem;
	ATTACHMENT  cAttach  ;
	RESULT lResult
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		///Help(" ",1,"ATENCAO",,cError,4,5)
		Conout(cError)
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	//Help(" ",1,"ATENCAO",,cError,4,5)
	Conout(cError)
EndIf

Return(lResult)   

