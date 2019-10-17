#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁRFINM98   ╨Autor  ЁJaime Wikanski      ╨ Data Ё  02/06/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRotina de importacao de movimentacoes da planilha POS       ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function RFINM98()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local nOpca     		:= 0                              
Local aSays     		:= {}
Local aButtons  		:= {}
Local cCadastro  		:= OemToAnsi("Importacao de Movimentacao da planilha POS")
Local aArea				:= GetArea()                              
Local nX					:= 0
Local aCampos			:= {}
Local cArqTmp			:= ""
Local cArqLog			:= Upper(CriaTrab(,.F.)+".TXT")
Local cDirLog			:= GetMV("MV_DIRLGC",,"\Interface\Logs\")
Local cLog				:= ""
Local cAdm				:= ""
Local cArqAnt			:= ""
Local cMotAnt			:= ""
Local xArqs				:= {}
Local cNewArq			:= ""
Local lRenomeia		:= .T.
Local cArqLog			:= ""
Local cIndLog			:= ""
Local aEstru			:= {}
Local nHdl				:= 0			
Local cIndTB			:= ""
Private aList			:= {}
Private aTotProc		:= {0,0,0}
Private nTotNProc		:= 0
Private cEOL			:= Chr(13)+Chr(10)
Private cQuery			:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria o arquivo temporario com os logs de registro              			Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Select("LOG") > 0
	DbSelectArea("LOG")   
	DbCloseArea()
Endif	
Aadd(aEstru,{"ARQUIVO"	,"C",15,0})
Aadd(aEstru,{"MOTIVO"	,"C",50,0})
Aadd(aEstru,{"MSG"		,"C",200,0})
cArqLog 	:= CriaTrab(aEstru,.T.)
cIndLog 	:= CriaTrab(,.F.)
dbUseArea( .T.,, cArqLog, "LOG", .F., .F. )
IndRegua("LOG",cIndLog,"ARQUIVO+MSG",,,OemToAnsi("Selecionando Registros..."))
DbCommit()
DbSelectArea("LOG")
DbClearIndex()
DbSetIndex(cIndLog+OrdBagExt())
DbSetOrder(1)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё бpaga os arquivos de log gerados na maquina do usuario                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
xArqs := Directory("C:\L*.TXT")        
For nX := 1 to Len(xArqs)
	FErase("C:\"+xArqs[nX,1])	
Next nX

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta tela principal                                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AADD(aSays,OemToAnsi("Este programa importara os as movimentacoes das administradoras constantes no arquivo"	))
AADD(aSays,OemToAnsi("em formato CSV originario da planilha POS"																))
AADD(aSays,OemToAnsi(""								 																						))
AADD(aSays,OemToAnsi("Clique no botao visualizar para abrir os arquivos de log existentes"							))
AADD(aSays,OemToAnsi(""								 																						))
AADD(aButtons, { 1,.T.					,{|o| (nOpca := 1,o:oWnd:End())							 							}})
AADD(aButtons, { 2,.T.					,{|o| o:oWnd:End()																		}})
AADD(aButtons, { 15,.T.					,{|o| VerLog()																					}})
FormBatch( cCadastro, aSays, aButtons )

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se cancelou o processamento                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nOpca == 0
	RestArea(aArea)
	Return
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                     Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nOpca == 1
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se existiam arquivos de importacao disponiveis                   Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If SeleArq(.T.) == .F.                                      
		RestArea(aArea)
		Return
	Endif
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa cada umn dos arquivos selecionados                               Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nX := 1 to Len(aList)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se o arquivo foi selecionado                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If aList[nX,1] == .F.
		Loop
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monta arquivo de trabalho.                                   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	aCampos	:= {}
	Aadd(aCampos,{"TEXTO","C",250,0})
	cArqTmp 	:= CriaTrab(aCampos,.T.)
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif	
	dbUseArea(.T.,,cArqTmp,"TRB")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Appenda o arquivo texto para um arquivo DBF                               Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	MsAguarde({||AppendArq(Alltrim(aList[nX,6])+Alltrim(aList[nX,2]))},OemtoAnsi("Movimentacoes de Cartao de Credito"),"Importando Arquivo "+Alltrim(aList[nX,2])+"...")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa as informacoes de acordo com o tipo de arquivo                   Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Movimentacao SITEF                                                        Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Processa({|| lRenomeia := ImpPOS(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Renomeia o arquivo                                                        Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If lRenomeia
		If AT(".",Alltrim(aList[nX,2])) <= 0
			cNewArq	:= Alltrim(aList[nX,2])
		Else
			cNewArq	:= Substr(Alltrim(aList[nX,2]),1,AT(".",Alltrim(aList[nX,2]))-1)+".PRC"
		Endif
		COPY FILE (Alltrim(aList[nX,6])+Alltrim(aList[nX,2])) TO (Alltrim(aList[nX,6])+cNewArq)
	 	FERASE(Alltrim(aList[nX,6])+Alltrim(aList[nX,2]))
	Endif
			
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Finaliza o arquivo temporario gerado                                      Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
		FErase(cArqTmp+".DBF")
	Endif	
Next nX

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Exibe mensagem de resumo no final do processamento                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If LOG->(RecCount()) == 0
   U_Aviso("Resumo do Processamento","Total de Reg. Ignorados: "+StrZero(aTotProc[3],6)+cEOL+"Total de inconsistencias: "+StrZero(nTotNProc,6)+cEOL+"Total de RVs importados: "+StrZero(aTotProc[1],6)+cEOL+"Total de CVs importados: "+StrZero(aTotProc[2],6)+cEOL+"",{"Ok"},,"Atencao:")
Else
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Cria o arquivo de log                                                  Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cArqLog 	:= StrTran(cArqLog,"SC","L"+cAdm)
	nHdl 		:= FCreate(cDirLog+cArqLog)
	If nHdl == -1
		U_Aviso("Inconsistencia","nao foi possivel criar o arquivo de log.",{"Ok"},,"Atencao:")
	Else
		DbSelectArea("LOG")
		DbSetOrder(1)
		DbGoTop()
		While !EOF()
			If cArqAnt <> LOG->ARQUIVO
				FWrite(nHdl, Repl("-",200)+cEOL)
				FWrite(nHdl, "Arquivo: "+LOG->ARQUIVO+cEOL)
				FWrite(nHdl, Repl("-",200)+cEOL)
				FWrite(nHdl, ""+cEOL)
				FWrite(nHdl, Space(5)+"Motivo: "+LOG->MOTIVO+cEOL)
				FWrite(nHdl, ""+cEOL)
			Else
				If cMotAnt <> LOG->MOTIVO
					FWrite(nHdl, ""+cEOL)
					FWrite(nHdl, Space(5)+"Motivo: "+LOG->MOTIVO+cEOL)
					FWrite(nHdl, ""+cEOL)
				Endif			
			Endif			
			FWrite(nHdl, Space(10)+"- "+LOG->MSG+cEOL)
			cArqAnt 	:= LOG->ARQUIVO
			cMotAnt 	:= LOG->MOTIVO
			DbSelectArea("LOG")
			DbSkip()
		Enddo
		FClose(nHdl)
	Endif		
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Exibe mensagem ao usuario                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If U_Aviso("Resumo do Processamento","Total de Reg. Ignorados: "+StrZero(aTotProc[3],6)+cEOL+"Total de inconsistencias: "+StrZero(nTotNProc,6)+cEOL+"Total de RVs importados: "+StrZero(aTotProc[1],6)+cEOL+"Total de CVs importados: "+StrZero(aTotProc[2],6)+cEOL+"",{"Ok","Log"},,"Atencao:") == 2
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Faz a chamada do aplicativo associado                                  Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		U_VisualTxt(cDirLog+cArqLog)
   Endif
   
   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Copia o arquivo de log para o diretorio                             Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   //If File("C:\"+cArqLog) 
   //   COPY FILE ("C:\"+cArqLog) TO (cDirLog+cArqLog)
      //FERASE("C:\"+cArqLog)
   //Endif                 
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁFinaliza os arquivoas temporarios                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("LOG")   
DbCloseArea()
Ferase(cArqLog+".DBF")
Ferase(cIndLog+OrdBagExt())

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Restaura a area dos arquivos                                              Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RestArea(aArea)

Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    ЁAPPENDARQ Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao ЁAppenda o arquivo texto em formato Codebase                  Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function AppendArq(cArquivo)
DbSelectArea("TRB")
Append From (cArquivo) SDF
Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    Ё SELEARQ  Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Pesquisa os arquivos disponiveis para inportacao            Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function SeleArq(lExibe)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local lReturn			:= .T.
Local nI       		:= 0
Local xArqs   			:= {}
Local cTitulo  		:= OemToAnsi("Arquivos de interface disponiveis")
Local nOpc     		:= 0
Local oOk      		:= LoadBitMap(GetResources(),"LBOK")
Local oNo      		:= LoadBitMap(GetResources(),"LBNO")
Local aTitulo  		:= {" ", "Arquivo", "Tamanho", "Data", "Hora" }
Local oListBox
Local oSay
Local oDlg
Local cType				:=	"Todos os Arquivos|*.*"
Local cDirArq			:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica o diretorio padrao de cada arquivo de acordo com o parametro  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cDirArq	:= GetMV("MV_DIRPPOS",,"\Interface\POS\")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Captura os arquivos disponiveis no diretorio de interface              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
xArqs := Directory(cDirArq+"*.*")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se encontrou algum arquivo                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Len(xArqs) == 0
	While Len(xArqs) == 0
		cDirArq := StrTran(cGetFile(cType, OemToAnsi("Selecione o diretorio de interface"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY),"\SERVIDOR","")
		If Empty(cDirArq)
			Return
		Endif
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Captura os arquivos disponiveis no diretorio de interface              Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		xArqs := Directory(cDirArq+"*.*")
  	Enddo
Endif	

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pesquisa os arquivos no diretorio de retorno                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aList := {}
For ni:= 1 to Len(xArqs)
	If AT(".PRC",Alltrim(xArqs[ni,1])) > 0 .or. AT(".ZIP",Alltrim(xArqs[ni,1])) > 0
		Loop
	Endif
	Aadd( aList, { .t., xArqs[ni,1], xArqs[ni,2], xArqs[ni,3], xArqs[ni,4], cDirArq } )
Next

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a tela de selecao                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Len(aList) > 0 .and. lExibe == .T.
   DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 To 19,60 OF oMainWnd 
  
	   @ .5,.7 LISTBOX oListBox VAR cListBox Fields ;
            HEADER  aTitulo[1],;
	            		OemtoAnsi(aTitulo[2]),;
	            		OemtoAnsi(aTitulo[3]),;
	            		OemtoAnsi(aTitulo[4]),;
	            		OemtoAnsi(aTitulo[5]) ;
          SIZE 195,62 ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL

   oListBox:SetArray(aList)
   oListBox:bLine := { || {	If(aList[oListBox:nAt,1],oOk,oNo),;
		   							aList[oListBox:nAt,2],;
		   							aList[oListBox:nAt,3],;
		   							aList[oListBox:nAt,4],;
		   							aList[oListBox:nAt,5]}}

   DEFINE SBUTTON FROM    4,206 	TYPE 1  	ACTION (nOpc := 1,oDlg:End())  						     	ENABLE OF oDlg 
   DEFINE SBUTTON FROM 18.5,206 	TYPE 2  	ACTION (lReturn := .F.,nOpc := 0,oDlg:End())    	 	ENABLE OF oDlg
   //DEFINE SBUTTON FROM   33,206 	TYPE 14  ACTION (nOpc := 2,oDlg:End())       							ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
Endif


If Len(aList) <= 0 .or. Ascan(aList,{|x| x[1] == .T.}) <= 0 .and. nOpc == 1
    U_Aviso("Atencao !", "Nao existem arquivos disponМveis para importacao no diretСrio "+cDirArq,{"Ok"})
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Seleciona o arquivo                                                 Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   lReturn := .F.
EndIf			

Return(lReturn)

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбддддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFuncao    Ё VerLog   Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддаддддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤ao Ё Visualiza os arquivos de Log existentes                     Ё╠╠
╠╠юддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function VerLog()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local lReturn			:= .T.
Local nI       		:= 0
Local xArqs   			:= {}
Local cTitulo  		:= OemToAnsi("Arquivos de Log disponiveis")
Local nOpc     		:= 0
Local oOk      		:= LoadBitMap(GetResources(),"CLR_GREEN")
Local oNo      		:= LoadBitMap(GetResources(),"CLR_GREEN")
Local aTitulo  		:= {" ", "Arquivo", "Tamanho", "Data", "Hora" }
Local oListBox
Local oSay
Local oDlg
Local cType				:=	"Todos os Arquivos|*.*"
Local cDirArq			:= GetMV("MV_DIRLGC",,"\Interface\Logs\")
Local nRetExec			:= 0
Local cArqLog			:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Captura os arquivos disponiveis no diretorio de interface              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
xArqs := Directory(cDirArq+"L*.TXT")

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se encontrou algum arquivo                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Len(xArqs) == 0
	While Len(xArqs) == 0
		cDirArq := StrTran(cGetFile(cType, OemToAnsi("Selecione o diretorio de Logs"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY),"\SERVIDOR","")
		If Empty(cDirArq)
			Return
		Endif
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Captura os arquivos disponiveis no diretorio de interface              Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		xArqs := Directory(cDirArq+"L*.TXT")
  	Enddo
Endif	

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pesquisa os arquivos no diretorio de retorno                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aList := {}
For ni:= 1 to Len(xArqs)
	Aadd( aList, { .t., xArqs[ni,1], xArqs[ni,2], xArqs[ni,3], xArqs[ni,4], cDirArq } )
Next
aSort(aList,,,{|x,y| x[4] >= y[4] .and. x[5] >= y[5]})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a tela de selecao                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Len(aList) > 0
   DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 To 19,60 OF oMainWnd 
  
   @ .5,.7 LISTBOX oListBox VAR cListBox Fields ;
            HEADER   OemtoAnsi(aTitulo[2]),;
	            		OemtoAnsi(aTitulo[3]),;
	            		OemtoAnsi(aTitulo[4]),;
	            		OemtoAnsi(aTitulo[5]) ;
          SIZE 195,62 //ON DBLCLICK (aList[oListBox:nAt,1] := !aList[oListBox:nAt,1],oListBox:Refresh()) //NOSCROLL

   oListBox:SetArray(aList)
   oListBox:bLine := { || {	aList[oListBox:nAt,2],;
		   							aList[oListBox:nAt,3],;
		   							aList[oListBox:nAt,4],;
		   							aList[oListBox:nAt,5]}}

   DEFINE SBUTTON FROM    4,206 	TYPE 15 	ACTION (cArqLog := aList[oListBox:nAt,2], nOpc := 1,oDlg:End())	ENABLE OF oDlg 
   DEFINE SBUTTON FROM 18.5,206 	TYPE 2  	ACTION (lReturn := .F.,nOpc := 0,oDlg:End())    	 					ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
Endif

If Len(aList) <= 0 .and. nOpc == 1
    U_Aviso("Atencao !", "Nao existem arquivos de Log disponМveis para consulta no diretСrio "+cDirArq,{"Ok"})
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Seleciona o arquivo                                                 Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   lReturn := .F.
ElseIf nOpc == 1   
	U_VisualTXT(cDirArq+cArqLog)
EndIf			

Return(lReturn)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё ImpPOS   Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados da planilha POS                            Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpPOS(cArquivo)            

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local cTexto		:= ""          
Local cAdm			:= ""
	Local aAdm			:= {}
Local aAdmLog		:= {}
Local nPosArr		:= 0
Local lTemLog		:= .F.
Local cEstab		:= ""
Local cNsuSit		:= ""
Local cNsu			:= ""
Local cCartao		:= ""
Local cEstado		:= ""
Local nValCom		:= 0.00
Local cParcelas	:= ""
Local dDtTran		:= CTOD("")
Local aMaqs			:= {}
Local aColunas		:= {2,3,5,6,11,12,14,15,17,18,20,21,23,24,25,27,28,29,31,32,33}
Local nX				:= 0
Local lVazio		:= .T.
Local cLoja			:= ""
Local nCol1			:= 0
Local nCol2			:= 0
Local nCol3			:= 0
Local cSigla		:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Adiciona no array as administradoras                                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Aadd(aAdm, {"V"	,"CX","5/6/14/15/23/24/25"})
Aadd(aAdm, {"R"	,"CE","2/3/11/12/17/18/27/28/29"})
Aadd(aAdm, {"A" 	,"CA","20/21/31/32/33"})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a POS                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGoTo(3)
If Substr(RetCpoCart(TRB->TEXTO,2,";"),1,8) <> "PLANILHA"
	U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da planilha POS. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se a loja existe cadastrada                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGoTo(1)                               
cLoja 	:= StrZero(Val(RetCpoCart(TRB->TEXTO,1,";")),3)
If cLoja =="121" .Or.cLoja =="995" //Rodrigo 06/10
	cloja :="119"
EndIf
dDtTran	:= CTOD(RetCpoCart(TRB->TEXTO,2,";"))
If Empty(cLoja)
	U_Aviso("Inconsistencia","NЦo foi identificado o preenchimento da loja na planilha POS referente ao arquivo "+Alltrim(cArquivo)+". Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.F.)
Else
	DbSelectArea("PAB")
	DbSetOrder(3)
	If !DbSeek(xFilial("PAB")+"V"+cLoja,.F.)
		U_Aviso("Inconsistencia","NЦo foi localizado um estabelecimento para a operadora VISA da loja especificada na planilha POS referente ao arquivo "+Alltrim(cArquivo)+". Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.F.)
	Endif
	If !DbSeek(xFilial("PAB")+"R"+cLoja,.F.)
		U_Aviso("Inconsistencia","NЦo foi localizado um estabelecimento para a operadora REDECARD da loja especificada na planilha POS referente ao arquivo "+Alltrim(cArquivo)+". Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.F.)
	Endif	
	If !DbSeek(xFilial("PAB")+"A"+cLoja,.F.)
		U_Aviso("Inconsistencia","NЦo foi localizado um estabelecimento para a operadora AMEX da loja especificada na planilha POS referente ao arquivo "+Alltrim(cArquivo)+". Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.F.)
	Endif	
EndIf
If Empty(dDtTran)
	U_Aviso("Inconsistencia","NЦo foi identificado o preenchimento da data de referencia na planilha POS referente ao arquivo "+Alltrim(cArquivo)+". Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.F.)
Endif
//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGoto(9)        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta variavel de uso          													Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
	cTexto 		:= TRB->TEXTO

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Le as colunas                                                          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	For nX := 1 to 9
		If nX == 1
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Redeshop                                                         Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 2
			nCol2		:= 3
			nCol3		:= 0
			cAdm		:= "CE "		
			cSigla	:= "R"
		ElseIf nX == 2
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Visa Eletron                                                     Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 5
			nCol2		:= 6
			nCol3		:= 0
			cAdm		:= "CX "		
			cSigla	:= "V"
		ElseIf nX == 3
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Construcard                                                      Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 11
			nCol2		:= 12
			nCol3		:= 0
			cAdm		:= "CC "		
			cSigla	:= "R"
		ElseIf nX == 4
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Visa - Rotativo                                                  Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 14
			nCol2		:= 15
			nCol3		:= 0
			cAdm		:= "CX "		
			cSigla	:= "V"
		ElseIf nX == 5
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Redecard - Rotativo                                              Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 17
			nCol2		:= 18
			nCol3		:= 0
			cAdm		:= "CE "		
			cSigla	:= "R"
		ElseIf nX == 6
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Amex - Rotativo                                                  Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 20
			nCol2		:= 21
			nCol3		:= 0
			cAdm		:= "CA "		
			cSigla	:= "A"
		ElseIf nX == 7
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Visa Parcelado                                                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 23
			nCol2		:= 25
			nCol3		:= 24
			cAdm		:= "CX "		
			cSigla	:= "V"
		ElseIf nX == 8
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Redecard Parcelado                                               Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 27
			nCol2		:= 29
			nCol3		:= 28
			cAdm		:= "CE "		
			cSigla	:= "R"
		ElseIf nX == 9
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava Amex parcelado                                                   Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			nCol1		:= 31
			nCol2		:= 33
			nCol3		:= 32
			cAdm		:= "CA "		
			cSigla	:= "A"
		Endif
		If !Empty(RetCpoCart(TRB->TEXTO,nCol1,";")) .and. !Empty(RetCpoCart(TRB->TEXTO,nCol2,";")) .and. Val(StrTran(Alltrim(RetCpoCart(cTexto,nCol2,";")),",",".")) > 0 .and. Iif(nX >= 7, !Empty(RetCpoCart(TRB->TEXTO,nCol3,";")),.t.)
			DbSelectArea("PAB")
			DbSetOrder(3)
			DbSeek(xFilial("PAB")+cSigla+cLoja,.F.)
			cNsuSit		:= Space(6)
			cNsu			:= PADR(Alltrim(RetCpoCart(cTexto,nCol1,";")),9)
			cNsu			:= PADR(Iif(Len(Alltrim(cNsu)) == 5, "0"+Alltrim(cNSU),cNsu),9)
			cCartao		:= PADR("POS",19)
			cEstado		:= "E"
			nValCom		:= Val(StrTran(Alltrim(RetCpoCart(cTexto,nCol2,";")),",","."))
			cParcelas	:= Iif(nX < 7, "01", StrZero(Val(RetCpoCart(cTexto,nCol3,";")),2))
		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava as movimentacoes do SITEF           										Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("PBD")
		 	DbSetOrder(1)
			If DbSeek(xFilial("PBD")+cAdm+PADR(PAB->PAB_COD,15)+cNsuSit+cNsu+cCartao+cEstado+DTOS(dDtTran),.F.)
		      aTotProc[3]++
		 	Else
		  		RecLock("PBD",.T.)
		    	PBD->PBD_FILIAL 	:= xFilial("PBD")
				PBD->PBD_ADM   	:= cAdm
				PBD->PBD_ESTAB 	:= PAB->PAB_COD                   	
				PBD->PBD_NSU   	:= cNsu
				PBD->PBD_ESTADO	:= cEstado
				PBD->PBD_DTTRAN	:= dDtTran
				PBD->PBD_CARTAO	:= cCartao
				PBD->PBD_VLCOM 	:= nValCom
				PBD->PBD_TOTPAR	:= cParcelas
		     	PBD->PBD_ARQUIV 	:= cArquivo
		      PBD->PBD_CODEST 	:= cLoja
		     	MsUnlock()
		      aTotProc[1]++
			Endif	      
		Endif
	Next nX
	DbSelectArea("TRB")
	DbSkip()
EndDo
//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza Controle de Transacao               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//End Transaction

Return(.T.)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁGravaLog  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁGrava o arquivo de log                                      Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function GravaLog(cArquivo,cMotivo,cMsg)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea		:= GetArea()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o arquivo de log                                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("LOG")
DbSetOrder(1)
RecLock("LOG",.T.)
LOG->ARQUIVO	:= cArquivo
LOG->MOTIVO		:= cMotivo
LOG->MSG			:= cMsg
MsUnlock()
MsUnlockAll()
DbCommitAll()
RestArea(aArea)
Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁRetIdPBB  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁRetorna o identificador do PBB                              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function RetIdPBB(cIdent)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""              
Local cQuery		:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se o identificador existe                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cIdent := Soma1(cIdent,15)
DbSelectArea("PBB")
DbSetOrder(5)
If DbSeek(xFilial("PBB")+cIdent,.F.)
	#IFDEF TOP
		cQuery := " SELECT ISNULL(MAX(PBB_IDENT),'000000000000000') AS PBB_IDENT"
		cQuery += " FROM "+RetSqlName("PBB")+" PBB (INDEX="+RetSqlName("PBB")+"5 NOLOCK)"
		cQuery += " WHERE PBB_FILIAL = '"+xFilial("PBB")+"'"						
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
		TcQuery cQuery New Alias "Qry"
		cIdent := Soma1(Qry->PBB_IDENT,15)
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
	#ELSE	
		DbSelectArea("PBB")
		DbSetOrder(5)
		DbSeek(xFilial("PBB")+"Z",.T.)
		DbSkip(-1)
		cIdent := Soma1(PBB->PBB_IDENT,15)
	#ENDIF 					
	DbSelectArea("PBB")
	DbSetOrder(5)
	While DbSeek(xFilial("PBB")+cIdent,.F.)
		cIdent := Soma1(cIdent,15)
	Enddo
Endif
Return(cIdent)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁRetIdPBC  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁRetorna o identificador do PBC                              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function RetIdPBC(cIdentPBC)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""              
Local cQuery		:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se o identificador existe                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cIdentPBC := Soma1(cIdentPBC,20)
DbSelectArea("PBC")
DbSetOrder(9)
If DbSeek(xFilial("PBC")+cIdentPBC,.T.)
	#IFDEF TOP
		cQuery := " SELECT ISNULL(MAX(PBC_IDPBC),'00000000000000000000') AS PBC_IDPBC"
		cQuery += " FROM "+RetSqlName("PBC")+" PBC (INDEX="+RetSqlName("PBC")+"9 NOLOCK)"
		cQuery += " WHERE PBC_FILIAL = '"+xFilial("PBC")+"'"						
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
		TcQuery cQuery New Alias "Qry"
		cIdentPBC := Soma1(Qry->PBC_IDPBC,20)
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
	#ELSE	
		DbSelectArea("PBC")
		DbSetOrder(9)
		DbSeek(xFilial("PBC")+"Z",.T.)
		DbSkip(-1)
		cIdentPBC := Soma1(PBC->PBC_IDPBC,20)
	#ENDIF 					
	DbSelectArea("PBC")
	DbSetOrder(9)
	While DbSeek(xFilial("PBC")+cIdentPBC,.F.)
		cIdentPBC := Soma1(cIdentPBC,20)
	Enddo
         //cIdentPBC	:= GetSX8Num("PBB","PBB_IDENT",9)
	//ConfirmSX8()                                        
Endif
Return(cIdentPBC)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁRetNrvTb  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁRetorna o numero do Nrv do tecBan                           Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function RetNrvTb(cRvAtu)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""              
Local cQuery		:= ""

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se o identificador existe                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cRvAtu := Soma1(cRvAtu,09)
DbSelectArea("PBB")
DbSetOrder(8)
If DbSeek(xFilial("PBB")+"TB"+"T"+cRvAtu,.T.)
	#IFDEF TOP
		cQuery := " SELECT ISNULL(MAX(SUBSTRING(PBB_NRV,2,9)),'000000000') AS PBB_NRV"
		cQuery += " FROM "+RetSqlName("PBB")+" PBB (INDEX="+RetSqlName("PBB")+"8 NOLOCK)"
		cQuery += " WHERE PBB_FILIAL = '"+xFilial("PBB")+"'"						
		cQuery += " AND PBB_CODADM = 'TB'"						
		cQuery += " AND D_E_L_E_T_ <> '*'"
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
		TcQuery cQuery New Alias "Qry"
		cRvAtu := Soma1(Qry->PBB_NRV,9)
		If Select("Qry") > 0
			DbSelectArea("Qry")
			DbCloseArea()
		Endif
	#ELSE	
		DbSelectArea("PBB")
		DbSetOrder(8)
		DbSeek(xFilial("PBB")+"TB"+"TZ",.T.)
		DbSkip(-1)
		cRvAtu := Soma1(Substr(PBB->PBB_NRV,2,9),9)
	#ENDIF 					
	DbSelectArea("PBB")
	DbSetOrder(8)
	While DbSeek(xFilial("PBB")+cRvAtu,.F.)
		cRvAtu := Soma1(cRvAtu,9)
	Enddo
Endif
Return(cRvAtu)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁRetCpoCartЁ Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁRetorna o campo no layout AMEX                              Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function RetCpoCart(cString,nPos,cSepArq)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cReturn		:= ""
Local nX				:= 0
Local nCont			:= 0
Local nPosSep		:= 0
Local nPosSepAnt	:= -1
Local cSep			:= Iif(cSepArq == Nil, ",", cSepArq)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Pesquisa os separadores na string                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
For nX := 1 to Len(cString)
	If Substr(cString,nX,1) == cSep .or. nX == Len(cString)
		nCont++         
		If nPosSepAnt == -1
			nPosSepAnt := 0
		Else
			nPosSepAnt := nPosSep
		Endif
		nPosSep := nX   
	Endif           
	If nPos == nCont
		cReturn := Substr(cString,nPosSepAnt+1,nPosSep-(nPosSepAnt+1))
		Exit
	Endif
Next nX
cReturn := StrTran(cReturn,'"','')

Return(cReturn)