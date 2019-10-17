#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁRFINM99   ╨Autor  ЁJaime Wikanski      ╨ Data Ё  02/06/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRotina de importacao de movimentacoes de cartoes de credito ╨╠╠
╠╠╨          Ёfornecidos pelas operadoras de cartao de credito e pelo     ╨╠╠
╠╠╨          ЁSITEF                                                       ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё C&C - Casa e Construcao                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function RFINM99()

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local nOpca     		:= 0                              
Local aSays     		:= {}
Local aButtons  		:= {}
Local cCadastro  		:= OemToAnsi("Importacao de Movimentacao de Cartao de Credito")
Local aArea				:= GetArea()                              
Local cPerg				:= "FINM99"
Local lPerg				:= .F.
Local nX					:= 0
Local aCampos			:= {}
Local cArqTmp			:= ""
Local cArqTrab			:= ""
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
Local cOrigem			:=	Nil
Local cLog				:=	""
Private aList			:= {}
Private aTotProc		:= {0,0,0}
Private nTotNProc		:= 0
Private cEOL			:= Chr(13)+Chr(10)
Private cQuery			:= ""
Private cChavePA5		:=	""
//Private dCorte       :=Ctod("01/03/05") //Rodrigo 25/01/05
Private dCorte       :=Ctod("05/02/05") //Rodrigo 25/01/05

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

//здддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Parametros utilizados                            Ё
//Ё mv_par01 - Administradora  Visanet/Amex/Redecard Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддды
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta os parametros da rotina                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
ValidPerg(cPerg)
Pergunte(cPerg,.f.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta tela principal                                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
AADD(aSays,OemToAnsi("Este programa importarА os as movimentacoes de cartoes de credito e debito fornecidos"	))
AADD(aSays,OemToAnsi("pelas Operadoras ou pelo SITEF"																				))
AADD(aSays,OemToAnsi(""								 																						))
AADD(aSays,OemToAnsi("Clique no botao parБmetros para selecionar a operadora que serА processada pela rotina."	))
AADD(aSays,OemToAnsi("Clique no botao visualizar para abrir os arquivos de log existentes"							))
AADD(aSays,OemToAnsi(""								 																						))
AADD(aButtons, { 1,.T.					,{|o| (nOpca := 1,o:oWnd:End())							 							}})
AADD(aButtons, { 2,.T.					,{|o| o:oWnd:End()																		}})
AADD(aButtons, { 5,.T.					,{|o| (lPerg := Pergunte(cPerg,.T.))												}})
AADD(aButtons, { 15,.T.				,{|o| VerLog()																					}})
FormBatch( cCadastro, aSays, aButtons )

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se cancelou o processamento                                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nOpca == 0
	RestArea(aArea)
	Return
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se abriu a tela de parametros                                    Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lPerg == .F.
	If !Pergunte(cPerg,.T.)
		RestArea(aArea)
		Return
	Endif
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
	If MV_PAR01 == 4
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartao TECBAN                                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Aadd(aCampos,{"RV","C",50,0})
		cIndTB := CriaTrab(,.f.)
	Endif
	cArqTmp 	:= CriaTrab(aCampos,.T.)
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif	
	dbUseArea(.T.,,cArqTmp,"TRB")
	If MV_PAR01 == 4
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Cartao TECBAN                                                             Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		IndRegua("TRB",cIndTB,"RV",,,OemToAnsi("Selecionando Registros..."))
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Appenda o arquivo texto para um arquivo DBF                               Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If  mv_par01 == 1 //Utilziar otimizaГЦo VISA
		Processa({|| APPendVisa(Alltrim(aList[nX,6])+Alltrim(aList[nX,2]))},"Importando Arquivo "+Alltrim(aList[nX,2])+"...")
	Else
		MsAguarde({||AppendArq(Alltrim(aList[nX,6])+Alltrim(aList[nX,2]))},OemtoAnsi("Movimentacoes de Cartao de Credito"),"Importando Arquivo "+Alltrim(aList[nX,2])+"...")
	Endif
	DbSelectArea("TRB")
	DbGoTop()
	Do Case
		Case mv_par01 == 1
			cAdm	:=	"CX"             
			cOrigem	:=	Nil
		Case 	mv_par01 == 2
			cAdm	:=	"CA"
			cOrigem	:=	Nil
		Case 	mv_par01 == 3
			cAdm	:=	"CE"
			cOrigem	:=	Nil
			If Upper(RetCpoCart(TRB->TEXTO,5,",")) == "MOVIMENTACAO DIARIA - CARTOES DE DEBITO"
				cOrigem	:=	"REDECARDEB"
			ElseIf Substr(TRB->TEXTO,20,30) == "EXTRATO DE MOVIMENTO DE VENDAS"
				cOrigem	:=	"REDECARVEN"
			ElseIf Substr(TRB->TEXTO,20,34) == "EXTRATO DE MOVIMENTACAO FINANCEIRA"
				cOrigem	:=	"REDECARFIN"
			Endif
		Case 	mv_par01 == 4
			cAdm		:=	"TB"
			cOrigem	:=	Nil
			While !Eof() .And. !Substr(TRB->TEXTO,1,2) == "C0" //Rodrigo 27/01/05
         	dbSkip()
   		EndDo
		Case 	mv_par01 == 5 //Rodrigo 26/01/05
			cAdm		:=	"SI"
			cOrigem	:=	Nil
			While !Eof() .And. Substr(Alltrim(RetCpoCart(TRB->TEXTO,7,";")),1,4) == "CANC"
         	dbSkip()
   		EndDo
	EndCase
	nRecPA5	:=	U_CtrlDupl(Alltrim(aList[nX,6])+Alltrim(aList[nX,2]),cAdm,TRB->TEXTO,cOrigem,@cLog)
	If nRecPA5	>	0
		cChavePA5	:=	PA5->PA5_ORIGEM+PA5->PA5_LOTE+Dtos(PA5->PA5_DTPROC)
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Processa as informacoes de acordo com o tipo de arquivo                   Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If MV_PAR01 == 1
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Cartao Visa                                                               Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			Processa({|| lRenomeia := ImpVisa(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
		ElseIf MV_PAR01 == 2
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Cartao Amex                                                               Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			Processa({|| lRenomeia := ImpAmex(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
		ElseIf MV_PAR01 == 3
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Cartao Redecard                                                           Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			DbSelectArea("TRB")
			DbGoTop()
			If Upper(RetCpoCart(TRB->TEXTO,5,",")) == "MOVIMENTACAO DIARIA - CARTOES DE DEBITO"
				Processa({|| lRenomeia := ImpRCard(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
			ElseIf Substr(TRB->TEXTO,20,30) == "EXTRATO DE MOVIMENTO DE VENDAS"
				Processa({|| lRenomeia := ImpRCrd1(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
			ElseIf Substr(TRB->TEXTO,20,34) == "EXTRATO DE MOVIMENTACAO FINANCEIRA"
				Processa({|| lRenomeia := ImpRCrd2(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
			Endif
		ElseIf MV_PAR01 == 4
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Cartao TECBAN                                                             Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			Processa({|| lRenomeia := ImpTecBan(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
		ElseIf MV_PAR01 == 5
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Movimentacao SITEF                                                        Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			Processa({|| lRenomeia := ImpSITEF(Alltrim(aList[nX,2]), @cAdm )},"Arquivo: "+Alltrim(aList[nX,2]))
		Endif
	
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
			//Grava flag no PA5
		 	DbSelectArea('PA5')
		 	dbGoTo(nRecPA5)
		 	RecLock('PA5',.F.)
		 	PA5_VALOR	:=	1
		 	MsUnLock()
		Endif
	Else
		GravaLog(Alltrim(Alltrim(aList[nX,2])),"Problemas de duplicidade", cLog )
	Endif			
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Finaliza o arquivo temporario gerado                                      Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea()
		FErase(cArqTmp+".DBF")
		If MV_PAR01 == 4
			FErase(cIndTB+".CDX")
		ENdif
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
╠╠ЁFuncao    Ё SELEAR   Ё Autor Ё Jaime Wikanski         Ё Data Ё          Ё╠╠
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
If MV_PAR01 == 1
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos VISA                                                          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRVISA",,"\Interface\Operadoras\visa\")
ElseIf MV_PAR01 == 2
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos AMEX                                                          Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRAMEX",,"\Interface\Operadoras\amex\")
ElseIf MV_PAR01 == 3
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos Redecard                                                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRRCRD",,"\Interface\Operadoras\redecard\")
ElseIf MV_PAR01 == 4
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos TecBan                                                        Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRTB",,"\Interface\Operadoras\tecban\")
ElseIf MV_PAR01 == 5
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos SITEF                                                         Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRSITE",,"\Interface\sitef\")
ElseIf MV_PAR01 == 6
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Arquivos POS                                                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cDirArq	:= GetMV("MV_DIRPPOS",,"\Interface\POS\")
Endif

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
   DEFINE SBUTTON FROM   33,206 	TYPE 4   ACTION (AEval(aList,{|x| x[1]:=!x[1]}),oListBox:Refresh())       			ENABLE OF oDlg

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
╠╠ЁFun┤┘o    Ё ImpVisa  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao Visa                             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpVisa(cArquivo, cAdm)            

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local dEmissao 	:= CTOD("")
Local cProduto 	:= ""
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local cChVlLq  	:= ""
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local nTotParcs	:= 0
Local cAdm			:= "CX"
Local aMaqs			:= {}
Local aRegRV		:= {}
Local aRegCV		:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local nRecProv		:= 0
Local nRecLiq		:= 0
Local cCartao		:= ""
Local cMot			:=	""
Local	nArredDesc	:=	0
Local	nRecAju		:=	0
Local	nRecAju1		:=	0
Local aAjuste		:=	{0,0,0,0}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a VISA                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If SubStr(TRB->TEXTO,01,01) == "0"
	If SubStr(TRB->TEXTO,46,07) <> "VISANET"
      U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da VISANET. A posicao 46 da primeira linha do arquivo, deve conter o conteudo VISANET. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return
	EndIf
Else
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora VISANET no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return
Endif

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Formato do arquivo:                                                    Ё
	//Ё 0 Header                                                               Ё
	//Ё 1 RO                                                                   Ё
	//Ё 2 CV - Somente para os casos de Ajuste                                 Ё
	//Ё 9 Trailler                                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,1) $ "0/9"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro de aluguel da maquineta										Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,1) <> "2" .And. !cSituaca $ "12"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	IF !DbSeek(xFilial("PAB")+cAdm+Space(1)+SubStr(TRB->TEXTO,2,10),.f.)
   	If aScan(aMaqs, cAdm+SubStr(TRB->TEXTO,2,10)) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+SubStr(TRB->TEXTO,2,10)+" da administradora VISANET nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+SubStr(TRB->TEXTO,2,10))
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Formato do arquivo:                                                    Ё
	//Ё 0 Header                                                               Ё
	//Ё 1 RO                                                                   Ё
	//Ё 2 CV - Somente para os casos de Ajuste                                 Ё
	//Ё 9 Trailler                                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,1) $ "0/9"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Tipos de RO: 			                                                   Ё
	//Ё 07 - Ajuste																				Ё
	//Ё 12 - Aluguel POS																			Ё
	//Ё 13 - Capurado																				Ё
	//Ё 14 - Liquidacao																			Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*  Rodrigo 25/02/05
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro de aluguel da maquineta										Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,1) == "1" .And. SubStr(TRB->TEXTO,37,2) $ "12/24"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
*/
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a maquineta esta cadastrada											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	DbSeek(xFilial("PAB")+cAdm+Space(1)+SubStr(TRB->TEXTO,2,10),.f.)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,1) == "1"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif Left(TRB->TEXTO,1) == "2"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
	Else
		DbSelectArea("TRB")
		DbSkip()
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Left(TRB->TEXTO,1) $ "1/9" .or. TRB->(EOF())) .and. Len(aRegRV) > 0
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicializa variaveis de trabalho													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		   dCredito 	:= Ctod(SubStr(cTexto,49,02)+"/"+SubStr(cTexto,47,02)+"/"+SubStr(cTexto,45,02))
		   dCredOri 	:= Ctod(SubStr(cTexto,49,02)+"/"+SubStr(cTexto,47,02)+"/"+SubStr(cTexto,45,02))
		   cProduto 	:= SubStr(cTexto,142,1)
		   cSituaca 	:= SubStr(cTexto,37,2)
			cParcela 	:= Iif(Empty(SubStr(cTexto,19,2)) .or. SubStr(cTexto,19,2) == "00","01",SubStr(cTexto,19,2))
			cTotParcs	:= Iif(Empty(SubStr(cTexto,22,2)) .or. SubStr(cTexto,22,2) == "00","01",SubStr(cTexto,22,2))
		   cSinal   	:= If(Left(cTexto,1) == "1",SubStr(cTexto,57,1),SubStr(cTexto,46,1))
		   cRvAtu   	:= PADR(PAB->PAB_ADM+Left(SubStr(cTexto,12,7),9),10)
         nVlrBrut 	:= Abs(Val(SubStr(cTexto,058,13))/100)
         nVlrLiq  	:= Abs(Val(SubStr(cTexto,100,13))/100)
         nVlrDesc 	:= Abs(Val(SubStr(cTexto,072,13))/100)
         nVlrReje 	:= Abs(Val(SubStr(cTexto,086,13))/100)
         cChVlLq		:= StrZero((nVlrLiq  * If(SubStr(cTexto,57,1)=="+",1,-1))*100,17)
         cOper			:= ""                                             
         cMot			:=	""
			dEmissao 	:=Ctod(SubStr(cTexto,43,2)+"/"+SubStr(cTexto,41,2)+"/"+SubStr(cTexto,39,2))
			//Tipos de ajuste:
				//VAJ212  = Desconta no SE5 (aluguel de pos, por exemplo )
				//VAJ114  = AceleraГЦo de parcelas (baixa todas as parcelas pendentes)
				//VAJ27- = Desconto de pagamento (desconto da aceleraГЦo por exemplo)
				//VAJ27+ = Paga no SE5 (estorno de desconto)
			If cSituaca	==	'12'
//				cMot   	:=	'VAJ12' Rodrigo 29/03/05
				cMot   	:=	'VAJ212'
			ElseIf cSituaca	==	'14' .And. SubStr(cTexto,21,1)$'Aa'
//				cMot   	:=	'VAJ14' Rodrigo 29/03/05			
				cMot   	:=	'VAJ114'			
			ElseIf cSituaca	==	'07' .And. SubStr(cTexto,57,1)=="-"
//				cMot   	:=	'VAJ07-' Rodrigo 29/03/05			
				cMot   	:=	'VAJ27-'			
			ElseIf cSituaca	==	'07' .And. SubStr(cTexto,57,1)=="+"
//				cMot   	:=	'VAJ07+' Rodrigo 29/03/05			
				cMot   	:=	'VAJ27+'			
			Endif	
				                                                           
				
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se eh liquidacao ou Provisao ou Ajuste								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
/*			If (cSituaca $ "07/12") .or. Substr(cTexto,150,1) == "C" .Or.; //Rodrigo Artur 17/01/05
			If (cSituaca $ "07/12") .and. !Substr(cTexto,150,1) == "D" .Or. Substr(cTexto,150,1) == "C" .Or.;
				(cSituaca == "14" .And. Substr(cTexto,150,1) == "D" .and. (Empty(cParcela) .or. cParcela == "01"))//Rodrigo 25/02/05
*/
			If ((cSituaca $ "07/12") .and. !Substr(cTexto,150,1) == "D" .Or. Substr(cTexto,150,1) == "C".Or.;
				(cSituaca == "14" .And. Substr(cTexto,150,1) == "D" .and. (Empty(cParcela) .or. cParcela == "01")));
				.and. dEmissao >= dCorte

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza as variaveis com os valores informados								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cSituaca $ "07/12"  .Or. (cSituaca	==	'14' .And. SubStr(cTexto,21,1)$'Aa' )
					cOper := "A"
				ElseIf Substr(cTexto,150,1) == "C"
					If Year(ddatabase)==2005 .and. (month(dEmissao) - Val(cParcela)) >= 2 //Rodrigo 25/02/05 
						cOper := "L"
				   Else
   					DbSelectArea("TRB")
      				DbSkip()
      				Loop
   				EndIf
				ElseIf Substr(cTexto,150,1) == "D" .and. (Empty(cParcela) .or. cParcela == "01")
					cOper	:= "P"
				Endif
									
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava a liquidacao                        										Ё
				//Ё Somente grava se o resumo nao existir   											Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		      DbSelectArea("PBB")
		      DbSetOrder(1)
				If DbSeek(xFilial("PBB")+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
			      aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
			 	Else
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cDescEst :=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,2,10)),"PAB_LOJA")
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)
		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= SubStr(cTexto,2,10)
		         PBB->PBB_NRV    	:= cRvAtu
					If cOper == "A"
			         PBB->PBB_VLBRUT 	:= nVlrBrut * If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLLIQ  	:= nVlrLiq  * If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLDESC 	:= nVlrDesc * If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLREJE 	:= nVlrReje * If(SubStr(cTexto,57,1)=="+",1,-1)
			         If PBB_VLBRUT == 0
			         	PBB_VLBRUT	:=	PBB_VLLIQ
			         Endif
			         If PBB_VLDESC==0 .And. PBB_VLBRUT<>PBB_VLLIQ
			         	PBB_VLDESC	:= PBB_VLBRUT-PBB_VLLIQ
			         Endif		
					Else
			         PBB->PBB_VLBRUT 	:= nVlrBrut //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLLIQ  	:= nVlrLiq  //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLDESC 	:= nVlrDesc //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLREJE 	:= nVlrReje //* If(SubStr(cTexto,57,1)=="+",1,-1)
					Endif
		         PBB->PBB_CHVLLQ 	:= cChVlLq
		         PBB->PBB_EMISS  	:= Ctod(SubStr(cTexto,43,2)+"/"+SubStr(cTexto,41,2)+"/"+SubStr(cTexto,39,2))
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
		         //PBB->PBB_CREDIT 	:= Iif(cProduto == "E",DataValida(dCredito+1),dCredito)
	         	PBB->PBB_CREDIT 	:= DataValida(dCredito)
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= Iif(cProduto == "E","D","C")
		         PBB->PBB_TPOPER 	:= cOper
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
					PBB->PBB_MOT		:=	cMot
					PBB->PBB_IDPA5		:=	cChavePA5
	         	If !Empty(cMot)
		         	PBB->PBB_DTAJU  	:= dCredito
					Endif
					nRecProv 			:= PBB->(Recno())
		         MsUnlock()        
					DbCommit()
    /*
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gera o registro de liquidacao para vendas a debito                     Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cOper == "P" .and. cProduto == "E"					
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						cIdent 	:= RetIdPBB(cIdent)
		
			         RecLock("PBB",.T.)
			         PBB->PBB_FILIAL 	:= xFilial("PBB")
			         PBB->PBB_CODADM 	:= cAdm
			         PBB->PBB_CODMAQ 	:= SubStr(cTexto,2,10)
			         PBB->PBB_NRV    	:= cRvAtu
			         PBB->PBB_VLBRUT 	:= nVlrBrut //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLLIQ  	:= nVlrLiq  //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLDESC 	:= nVlrDesc //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_VLREJE 	:= nVlrReje //* If(SubStr(cTexto,57,1)=="+",1,-1)
			         PBB->PBB_CHVLLQ 	:= cChVlLq
			         PBB->PBB_EMISS  	:= Ctod(SubStr(cTexto,43,2)+"/"+SubStr(cTexto,41,2)+"/"+SubStr(cTexto,39,2))
			         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
			         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
			         PBB->PBB_ARQUIV 	:= cArquivo
//			         PBB->PBB_CREDIT 	:= Iif(cProduto == "E",DataValida(dCredito+1),dCredito)
			         PBB->PBB_CREDIT 	:= DataValida(dCredito)
			         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
			         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
			         PBB->PBB_SITUAC 	:= cSituaca
			         PBB->PBB_TPCART 	:= Iif(cProduto == "E","D","C")
			         PBB->PBB_TPOPER 	:= "L"
			         PBB->PBB_IDENT  	:= cIdent
			         PBB->PBB_ESTAB		:= Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,2,10)),"PAB_LOJA")
						nRecLiq := PBB->(Recno())
			         MsUnlock()
	   			Endif
    */
			      aTotProc[1]++
			      
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava os CVs se existirem                         							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					nArredDesc	:=	0
					nRecAju		:=	0
					nRecAju1		:=	0
					For nY := 1 to Len(aRegCV)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Alimenta variavel de uso          													Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
						cTexto 		:= aRegCV[nY,1]
					   cSinal   	:= If(Left(cTexto,1) == "1",SubStr(cTexto,57,1),SubStr(cTexto,46,1))
						cCartao		:= Iif(Substr(SubStr(cTexto,19,19),17,3) == "000",SubStr(cTexto,19,16),SubStr(cTexto,19,19))
					   cRvAtu   	:= PAB->PAB_ADM+Left(SubStr(cTexto,12,7),10)
			         cNCV			:= SubStr(cTexto,140,6)
						If Len(Alltrim(cNCV)) == 5
							cNCV := "0"+Alltrim(cNCV)
						Endif
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Posiciona no PBB de Provisao                            					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

						DbSelectArea("PBB")
						DbGoTo(nRecProv)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Grava o arquivo de comprovantes de venda                					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				      DbSelectArea("PBC")
				      DbSetOrder(1)
						cDescEst :=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,2,10)),"PAB_LOJA")
		   	      RecLock("PBC",.T.)
						cIdentPBC	:= StrZero(Recno(),20)
			         PBC->PBC_FILIAL 	:= xFilial("PBC")
			         PBC->PBC_CODADM 	:= cAdm
			         PBC->PBC_CODMAQ 	:= SubStr(cTexto,2,10)
			         PBC->PBC_NRV    	:= PBB->PBB_NRV
			         PBC->PBC_CARTAO 	:= cCartao
			         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
			         PBC->PBC_NCV    	:= cNCV
			         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
			         PBC->PBC_PARCEL 	:= Iif(Empty(SubStr(cTexto,060,2)) .or. SubStr(cTexto,060,2) == "00","01",SubStr(cTexto,060,2))
			         PBC->PBC_TOTPAR 	:= Iif(Empty(SubStr(cTexto,062,2)) .or. SubStr(cTexto,062,2) == "00","01",SubStr(cTexto,062,2))
				      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,44,02)+"/"+SubStr(cTexto,042,02)+"/"+SubStr(cTexto,38,04))
				      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
				      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
				      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,47,13))/100)
			         PBC->PBC_TOTCOM 	:= (Abs(Val(SubStr(cTexto,47,13))/100)) * Iif(cOper == "P",Iif(Empty(SubStr(cTexto,062,2)) .or. SubStr(cTexto,062,2) == "00",1,Val(SubStr(cTexto,062,2))) ,1)
				      PBC->PBC_CAPTUR 	:= ""
				      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
				      PBC->PBC_DESCRI 	:= If(PBB->PBB_SITUAC=="07","Ajuste",If(cSituaca=="14","Liquidacao","Venda"))
						PBC->PBC_TPCART 	:= Iif(cProduto == "E","D","C")
			         PBC->PBC_TPOPER 	:= cOper
			         PBC->PBC_PRODUT 	:= cProduto
			         PBC->PBC_IDPBC  	:= cIdentPBC     
			         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
			         PBC->PBC_ESTAB	 	:= cDescEst
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Assumo que no Lay-Out do Visa exista um resumo por movimento. Ё
				      //Ё pois nao existe Vlr Liquido no movimento - uso a Tx do resumo.Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				      If PBC->PBC_VLBRUT <> PBB->PBB_VLBRUT
				         PBC->PBC_VLDESC := Abs(Round(PBC->PBC_VLBRUT * (PBB->PBB_VLDESC / PBB->PBB_VLBRUT),2))
				         PBC->PBC_VLLIQ  := Abs(PBC->PBC_VLBRUT - PBC->PBC_VLDESC)
				         PBC->PBC_CHVLLQ := StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
						Else
				         PBC->PBC_VLDESC := Abs(PBB->PBB_VLDESC)
				         PBC->PBC_VLLIQ  := Abs(PBB->PBB_VLLIQ)
				         PBC->PBC_CHVLLQ := StrZero(Abs(PBB->PBB_VLLIQ)*100,17)
						EndIf 
						nArredDesc		  +=  PBC->PBC_VLDESC

						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
				      //Ё mente o valor das parcelas para gravar no SE1.                Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If PBC->(FieldPos('PBC_DESCTO')) >0
				         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)* Iif(cOper == "P",Val(PBC->PBC_TOTPAR) ,1)
				      Endif 
						//Guarda o primeiro registro caso deva acertar arredodnamento de desconto.
   					If nY == 1
							nRecAju	:=	PBC->(Recno())
						Endif

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Grava a liquidacao para as vendas a debito              					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
/*
						If cOper == "P" .and. cProduto == "E"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Posiciona no PBB de Provisao                            					Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							DbSelectArea("PBB")
							DbGoTo(nRecLiq)
//							DbGoTo(nRecProv)
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Atualiza as variaveis com os valores informados								Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							cCartao		:= Iif(Substr(SubStr(cTexto,19,19),17,3) == "000",SubStr(cTexto,19,16),SubStr(cTexto,19,19))
							cDescEst 	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,2,10)),"PAB_LOJA")
						 	DbSelectArea("PBC")
					      DbSetOrder(1)
			   	      RecLock("PBC",.T.)
							cIdentPBC	:= StrZero(Recno(),20)
				         PBC->PBC_FILIAL 	:= xFilial("PBC")
				         PBC->PBC_CODADM 	:= cAdm
				         PBC->PBC_CODMAQ 	:= SubStr(cTexto,2,10)
				         PBC->PBC_NRV    	:= PBB->PBB_NRV
				         PBC->PBC_CARTAO 	:= cCartao
				         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
				         PBC->PBC_NCV    	:= cNCV
				         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
				         PBC->PBC_PARCEL 	:= Iif(Empty(SubStr(cTexto,060,2)) .or. SubStr(cTexto,060,2) == "00","01",SubStr(cTexto,060,2))
				         PBC->PBC_TOTPAR 	:= Iif(Empty(SubStr(cTexto,062,2)) .or. SubStr(cTexto,062,2) == "00","01",SubStr(cTexto,062,2))
					      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,44,02)+"/"+SubStr(cTexto,042,02)+"/"+SubStr(cTexto,38,04))
					      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
					      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
					      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,47,13))/100)
				         PBC->PBC_TOTCOM 	:= (Abs(Val(SubStr(cTexto,47,13))/100)) * Iif(cOper == "P",Iif(Empty(SubStr(cTexto,062,2)) .or. SubStr(cTexto,062,2) == "00",1,Val(SubStr(cTexto,062,2))) ,1)
					      PBC->PBC_CAPTUR 	:= ""
					      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
					      PBC->PBC_DESCRI 	:= If(PBB->PBB_SITUAC=="07","Ajuste",If(cSituaca=="14","Liquidacao","Venda"))
							PBC->PBC_TPCART 	:= Iif(cProduto == "E","D","C")
				         PBC->PBC_TPOPER 	:= "L"
				         PBC->PBC_PRODUT 	:= cProduto
				         PBC->PBC_IDPBC  	:= cIdentPBC     
				         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
				         PBC->PBC_ESTAB	 	:= cDescEst
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Assumo que no Lay-Out do Visa exista um resumo por movimento. Ё
					      //Ё pois nao existe Vlr Liquido no movimento - uso a Tx do resumo.Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					      If PBC->PBC_VLBRUT <> PBB->PBB_VLBRUT
					         PBC->PBC_VLDESC := Abs(Round(PBC->PBC_VLBRUT * (PBB->PBB_VLDESC / PBB->PBB_VLBRUT),2))
					         PBC->PBC_VLLIQ  := Abs(PBC->PBC_VLBRUT - PBC->PBC_VLDESC)
					         PBC->PBC_CHVLLQ := StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
							Else
					         PBC->PBC_VLDESC := Abs(PBB->PBB_VLDESC)
					         PBC->PBC_VLLIQ  := Abs(PBB->PBB_VLLIQ)
					         PBC->PBC_CHVLLQ := StrZero(Abs(PBB->PBB_VLLIQ)*100,17)
							EndIf   
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
					      //Ё mente o valor das parcelas para gravar no SE1.                Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If PBC->(FieldPos('PBC_DESCTO')) >0
					         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)* Iif(cOper == "P",Val(PBC->PBC_TOTPAR) ,1)
					      Endif 
	   					If nY == 1
								nRecAju1	:=	PBC->(Recno())
							Endif
						Endif
      */
						dbSelectArea("PBC")
			       	MsUnlock()
						MsUnlockAll()
						DbCommitAll()
				      aTotProc[2]++
					Next nY 
					//Acerta o arredondamento distribuido do RV no primeiro registro do CV
					If nRecAju > 0 .And. nArredDesc <> PBB->PBB_VLDESC 
//						aAjuste	:=	{0,0,0,0}
						DbSelectArea("PBC")
						DbGoTo(nRecAju)
						RecLock('PBC',.F.)
				      If PBC->PBC_VLBRUT <> PBB->PBB_VLBRUT
				         PBC->PBC_VLDESC += (PBB->PBB_VLDESC-nArredDesc)
				         PBC->PBC_VLLIQ  := Abs(PBC->PBC_VLBRUT - PBC->PBC_VLDESC)
				         PBC->PBC_CHVLLQ := StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
						Else
				         PBC->PBC_VLDESC += (PBB->PBB_VLDESC-nArredDesc)
				         PBC->PBC_VLLIQ  := Abs(PBB->PBB_VLLIQ)
				         PBC->PBC_CHVLLQ := StrZero(Abs(PBB->PBB_VLLIQ)*100,17)
						EndIf   
						If PBC->(FieldPos('PBC_DESCTO')) >0
				         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)* Iif(cOper == "P",Val(PBC->PBC_TOTPAR) ,1)
				      Endif 
						MsUnLock()
/*
  			         aAjuste[1]	:=	PBC->PBC_VLDESC  
						aAjuste[2]	:=	PBC->PBC_VLLIQ
				      aAjuste[3]	:=	PBC->PBC_CHVLLQ
						aAjuste[4]	:=	PBC->PBC_DESCTO
						If cOper == "P" .and. cProduto == "E"
							DbSelectArea("PBC")
							DbGoTo(nRecAju1)
							RecLock('PBC',.F.)
				         PBC->PBC_VLDESC := aAjuste[1]
				         PBC->PBC_VLLIQ  := aAjuste[2]
				         PBC->PBC_CHVLLQ := aAjuste[3]
				         PBC->PBC_DESCTO := aAjuste[4]
							MsUnLock()
						Endif
*/
					Endif
	
					DbSelectArea("PBB")
					MsUnlockAll()
					DbCommitAll()
					DbSelectArea("PBC")
					MsUnlockAll()
					DbCommitAll()
				Endif
			Else
				GravaLog(Alltrim(cArquivo),"Liberacao para agenda financeira", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" - parcela "+cParcela+"/"+cTotParcs+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao.")
				nTotNProc++
			Endif			
		Next nX
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV := {}
	   aRegCV := {}
	Endif

	DbSelectArea("TRB")
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
╠╠ЁFun┤┘o    Ё ImpAmex  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao Amex                             Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpAmex(cArquivo, cAdm )            

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local cProduto 	:= "" 
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrParc 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local cAdm			:= "CA"
Local aMaqs			:= {}
Local aRVs			:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local aRegRV		:= {}
Local aRegCV		:= {}
Local aRegPG		:= {}
Local cTexto		:= {}
Local cCartao		:= ""
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local nVlrDescT	:=	0
/* Rodrigo 29/03/05
Local aMotivos		:=	{{'AAJ001','ADJ0010027'},;
							 {'AAJ002','ADJ0010055'},;
							 {'AAJ003','ADJ0010056'},;
							 {'AAJ004','ADJ0020002'},;
							 {'AAJ005','ADJ0040001'},;
							 {'AAJ006','ADJ0170001'},;
							 {'AAJ007','ADJ0230002'},;
							 {'AAJ008','ADJ0280001'},;
							 {'AAJ009','ADJ1090001'},;
							 {'AAJ010','CBK0020001'},; //"DEBITO AUTORIZADO PELO ESTABELECIMENTO"
							 {'AAJ011','CBK0140001'},; //"DEBITO POR DESPESA NAO COMPROVADA"
							 {'AAJ012','CBK0010001'},; //"DEBITO POR DESPESA PROCESSADA EM DUPLICIDADE"
							 {'AAJ013','CBK0050001'}; //"REGULARIZACAO DE CREDITO EFETUADO INDEVIDAMENTE"							 
							 }
*/							 
Local aMotivos		:=	{{'AAJ201','ADJ0010027'},;
							 {'AAJ202','ADJ0010055'},;
							 {'AAJ203','ADJ0010056'},;
							 {'AAJ104','ADJ0020002'},;
							 {'AAJ105','ADJ0040001'},;
							 {'AAJ106','ADJ0170001'},;
							 {'AAJ107','ADJ0230002'},;
							 {'AAJ208','ADJ0280001'},;
							 {'AAJ109','ADJ1090001'},;
							 {'AAJ110','CBK0020001'},; //"DEBITO AUTORIZADO PELO ESTABELECIMENTO"
							 {'AAJ111','CBK0140001'},; //"DEBITO POR DESPESA NAO COMPROVADA"
							 {'AAJ112','CBK0010001'},; //"DEBITO POR DESPESA PROCESSADA EM DUPLICIDADE"
							 {'AAJ113','CBK0050001'}; //"REGULARIZACAO DE CREDITO EFETUADO INDEVIDAMENTE"							 
							 }

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a AMEX                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If SubStr(TRB->TEXTO,12,08) == "00010101"
   If SubStr(TRB->TEXTO,72,09) <> "DAILY EPA" .And. ;
      SubStr(TRB->TEXTO,67,12) <> "RECOVERY EPA" .And. ;
      SubStr(TRB->TEXTO,72,13) <> "DAILY OLD EPA"
      U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da AMEX. A posicao 78 da primeira linha do arquivo, deve conter o conteudo EPA. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return
	EndIf
Else
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora VISANET no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return
Endif
//nTaxa := SAE->AE_TAXA

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !SubStr(TRB->TEXTO,45,1) $ "3/4/5"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
   
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a maquineta/estabelecimento esta cadastrada						Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	If !DbSeek(xFilial("PAB")+cAdm+Space(1)+Alltrim(RetCpoCart(TRB->TEXTO,1)),.f.)
   	If aScan(aMaqs, cAdm+Alltrim(RetCpoCart(TRB->TEXTO,1))) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+Alltrim(RetCpoCart(TRB->TEXTO,1))+" da administradora AMEX nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+Alltrim(RetCpoCart(TRB->TEXTO,1)))
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Formato do arquivo:                                                    Ё
	//Ё 0 Header                                                               Ё
	//Ё 1 Liquidacao                                                           Ё
	//Ё 3 Resumo de venda                                                      Ё
	//Ё 4 Comprovante de venda                                                 Ё
	//Ё 5 Ajuste                                                               Ё
	//Ё 9 Trailler                                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Alltrim(RetCpoCart(TRB->TEXTO,6)) $ "0/9"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a maquineta esta cadastrada											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	DbSeek(xFilial("PAB")+cAdm+Space(1)+Alltrim(RetCpoCart(TRB->TEXTO,1)),.f.)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Alltrim(RetCpoCart(TRB->TEXTO,6)) == "1"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o Registro de Pagamento											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
	   aRegPG := {}
		Aadd(aRegPG, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif Alltrim(RetCpoCart(TRB->TEXTO,6)) == "3"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif Alltrim(RetCpoCart(TRB->TEXTO,6)) == "4"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o CV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif Alltrim(RetCpoCart(TRB->TEXTO,6)) == "5"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
	Else
		DbSelectArea("TRB")
		DbSkip()
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Alltrim(RetCpoCart(TRB->TEXTO,6)) $ "319" .or. TRB->(EOF())) .and. Len(aRegRV) > 0
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicializa variaveis de trabalho													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		   dCredito 	:= STOD(Alltrim(RetCpoCart(cTexto,2)))
		   dCredOri 	:= STOD(Alltrim(RetCpoCart(cTexto,2)))
		   cProduto 	:= Space(1)
		   cSituaca 	:= IIf(Alltrim(RetCpoCart(cTexto,6)) == "5","03",;
		   					Iif(Alltrim(RetCpoCart(aRegPG[1,1],20)) <> "F",;
		   						"02",;
		   						"01"))
			cParcela 	:= ""
			cTotParcs	:= ""
	      cMot	:=	""
	  		If Alltrim(RetCpoCart(cTexto,6)) == "5"
			   cSinal   	:= "-"
	         nVlrBrut 	:= (Val(Alltrim(RetCpoCart(cTexto,09)))/100)
	         nVlrLiq  	:= (Val(Alltrim(RetCpoCart(cTexto,13)))/100)
				nPosMot		:=	Ascan(aMotivos,{|x| x[2]==RetCpoCart(cTexto,15)})
	         nVlrDesc 	:=	0
				If nPosMot > 0 
		         cMot		:=	aMotivos[nPosMot][1]
		      Else
			     	cMot		:= Substr(RetCpoCart(cTexto,15),4,6)
		      Endif   
				dDataEmi		:=	CTod('')
			Else                       
				dDataEmi		:=	STOD(Alltrim(RetCpoCart(cTexto,8)))
			   cSinal   	:= "+"
			   cRvAtu   	:= PAB->PAB_ADM+Left(Alltrim(RetCpoCart(cTexto,9)),9)
	         nVlrBrut 	:= Abs(Val(Alltrim(RetCpoCart(cTexto,11)))/100)
	         nVlrLiq  	:= Abs(Val(Alltrim(RetCpoCart(cTexto,15)))/100)
	         nVlrDesc 	:= Abs(Val(Alltrim(RetCpoCart(cTexto,12)))/100)
	         nVlrReje 	:= 0.00
			Endif	
	      cChVlLq		:= StrZero(nVlrLiq*100,17)
         cOper			:= ""
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Pesquisa a quantidade de parcelas do RV											Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			For nY := 1 to Len(aRegCV)	
				If Val(cTotParcs) < Val(Alltrim(RetCpoCart(aRegCV[nY,1],15)))
					cTotParcs := Alltrim(RetCpoCart(aRegCV[nY,1],15))
				Endif
				If Val(cParcela) < Val(Alltrim(RetCpoCart(aRegCV[nY,1],16)))
					cParcela := Alltrim(RetCpoCart(aRegCV[nY,1],16))
				Endif
			Next nY
			cParcela 	:= Iif(Empty(cParcela),"01",StrZero(Val(cParcela),2))			
			cTotParcs 	:= Iif(Empty(cTotParcs),"01",StrZero(Val(cTotParcs),2))			
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se eh liquidacao ou Provisao ou Ajuste								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			If (cSituaca == "03") .or. (cSituaca == "02".and. dDataEmi >=dCorte) .or. ;
				(cSituaca == "01".and. dDataEmi >=dCorte .and. (Empty(cParcela) .or. Val(cParcela) == 1)); //Rodrigo 25/02/05

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza as variaveis com os valores informados								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cSituaca == "03"
					cOper := "A"
				ElseIf cSituaca == "02"
					cOper := "L"
				Else
					cOper	:= "P"
				Endif
									
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava a liquidacao                        										Ё
				//Ё Somente grava se o resumo nao existir   											Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		      DbSelectArea("PBB")
		      DbSetOrder(1) //PBB_FILIAL+PBB_CODADM+PBB_CODMAQ+PBB_NRV+DTOS(PBB_CREDIT)+PBB_PARCEL+PBB_TOTPAR+PBB_TPOPER+PBB_CHVLLQ
				If DbSeek(xFilial("PBB")+cAdm+Left(Alltrim(RetCpoCart(cTexto,1)),10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
			      aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+xFilial("PBB")+cAdm+Left(Alltrim(RetCpoCart(cTexto,1)),10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
			 	Else
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cDescEst		:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(RetCpoCart(cTexto,1)),"PAB_LOJA")
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)
		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= Alltrim(RetCpoCart(cTexto,1))
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_VLBRUT 	:= nVlrBrut
		         PBB->PBB_VLLIQ  	:= nVlrLiq
		         PBB->PBB_VLDESC 	:= nVlrDesc
		         PBB->PBB_VLREJE 	:= nVlrReje
		         PBB->PBB_CHVLLQ 	:= cChVlLq
		         PBB->PBB_EMISS  	:= dDataEmi
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
//		         PBB->PBB_CREDIT 	:= dCredito
		         PBB->PBB_CREDIT 	:= dCredito
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= "C"
		         PBB->PBB_TPOPER 	:= cOper
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
					PBB->PBB_MOT    	:=	cMot	
					PBB->PBB_IDPA5		:=	cChavePA5
	         	If !Empty(cMot)
		         	PBB->PBB_DTAJU  	:= dCredito
					Endif
		         MsUnlock()
					DbCommit()
			      aTotProc[1]++
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Calcula a taxa administrativa             										Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			      nTaxa := (PBB->PBB_VLDESC * 100) / (PBB->PBB_VLBRUT)
					      
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava os CVs se existirem                         							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cSituaca <> '03'
						For nY := 1 to Len(aRegCV) 
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Atualiza as variaveis com os valores informados								Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Alimenta variavel de uso          													Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
							cTexto 		:= aRegCV[nY,1]
							cCartao		:= Substr(Alltrim(RetCpoCart(cTexto,11)),1,15)+Iif(Substr(Alltrim(RetCpoCart(cTexto,11)),16,4) <> "****",Substr(Alltrim(RetCpoCart(cTexto,11)),16,4),"")
							If Val(Alltrim(RetCpoCart(cTexto,13))) > 0
								nVlrBrut 	:= Abs(Val(Alltrim(RetCpoCart(cTexto,13)))/100)
							Else
					         nVlrBrut 	:= Abs(Val(Alltrim(RetCpoCart(cTexto,12)))/100)
					  		Endif
				         nVlrDesc 	:= Abs((nVlrBrut * (nTaxa/100)))
	
				         nVlrDescT	:=	Abs(Val(Alltrim(RetCpoCart(cTexto,12)))/100) * (nTaxa/100)
	
				         nVlrLiq  	:= nVlrBrut - nVlrDesc                                 
//				         cNCV			:= Iif(Alltrim(Str(Val(Alltrim(RetCpoCart(cTexto,19))))) == "0","",Alltrim(Str(Val(Alltrim(RetCpoCart(cTexto,19))))))Rodrigo 08/01/05
 				         cNCV			:= Iif(Alltrim(Str(Val(Alltrim(RetCpoCart(cTexto,19))))) == "0",Alltrim(Str(Val(Alltrim(RetCpoCart(cTexto,9))))),Alltrim(Str(Val(Alltrim(RetCpoCart(cTexto,19))))))
							/*
							If Alltrim(cNCV) == 5
								cNCV := "0"+Alltrim(cNCV)
							Endif
							*/	
	
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Grava o arquivo de comprovantes de venda                					Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(RetCpoCart(cTexto,1)),"PAB_LOJA")
					      DbSelectArea("PBC")
					      DbSetOrder(1)
			   	      RecLock("PBC",.T.)
							cIdentPBC	:= StrZero(Recno(),20)
				         PBC->PBC_FILIAL 	:= xFilial("PBC")
				         PBC->PBC_CODADM 	:= cAdm
				         PBC->PBC_CODMAQ 	:= Alltrim(RetCpoCart(cTexto,1))
				         PBC->PBC_NRV    	:= PBB->PBB_NRV
				         PBC->PBC_CARTAO 	:= cCartao
				         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
				         PBC->PBC_NCV    	:= cNCV
				         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
				         PBC->PBC_PARCEL 	:= Iif(Empty(Alltrim(RetCpoCart(cTexto,16))) .or. Val(RetCpoCart(cTexto,16)) == 0,"01",StrZero(Val(RetCpoCart(cTexto,16)),2))
				         PBC->PBC_TOTPAR 	:= Iif(Empty(Alltrim(RetCpoCart(cTexto,15))) .or. Val(RetCpoCart(cTexto,15)) == 0,"01",StrZero(Val(RetCpoCart(cTexto,15)),2))
					      PBC->PBC_EMISS  	:= STOD(Alltrim(RetCpoCart(cTexto,8)))
					      PBC->PBC_TIPO   	:= "C"
					      PBC->PBC_CREDIT 	:= STOD(Alltrim(RetCpoCart(cTexto,2)))
					      PBC->PBC_VLBRUT 	:= nVlrBrut
				         PBC->PBC_VLDESC 	:= nVlrDesc
				         PBC->PBC_VLLIQ  	:= nVlrLiq
				         PBC->PBC_TOTCOM 	:= Abs(Val(Alltrim(RetCpoCart(cTexto,12)))/100)
					      PBC->PBC_CAPTUR 	:= ""
					      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
					      PBC->PBC_DESCRI 	:= If(PBB->PBB_SITUAC=="01","Venda",If(cSituaca=="02","Liquidacao","Ajuste"))
							PBC->PBC_TPCART 	:= "C"
				         PBC->PBC_TPOPER 	:= cOper
				         PBC->PBC_PRODUT 	:= cProduto
				         PBC->PBC_IDPBC  	:= cIdentPBC     
				         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
				         PBC->PBC_CHVLLQ 	:= StrZero(PBB->PBB_VLLIQ*100,17)
				         PBC->PBC_ESTAB	 	:= cDescEst
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
					      //Ё mente o valor das parcelas para gravar no SE1.                Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If PBC->(FieldPos('PBC_DESCTO')) >0
	//				         PBC->PBC_DESCTO := Abs(nVlrDesc)*Val(PBC->PBC_TOTPAR)
					         PBC->PBC_DESCTO := Abs(nVlrDescT)
					      Endif 
					      MsUnlock()
							DbCommit()
					      aTotProc[2]++
						Next nY 
					Endif
					DbSelectArea("PBB")
					MsUnlockAll()
					DbCommitAll()
					DbSelectArea("PBC")
					MsUnlockAll()
					DbCommitAll()
				Endif
			Else
				GravaLog(Alltrim(cArquivo),"Liberacao para agenda financeira", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" - parcela "+cParcela+"/"+cTotParcs+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao.")
				nTotNProc++
			Endif			
		Next nX
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV := {}
	   aRegCV := {}
	Endif
	DbSelectArea("TRB")
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
╠╠ЁFun┤┘o    ЁImpRCard  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao REDECARD                         Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpRCard(cArquivo, cAdm)            
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local dEmissao 	:= CTOD("")
Local cProduto 	:= ""
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local cChVlLq  	:= ""
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local nTotParcs	:= 0
Local cAdm			:= "CE"
Local cAdm1			:= "CC"
Local aMaqs			:= {}
Local aRegRV		:= {}
Local aRegCV		:= {}
Local aRegCC		:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local cTipoArq		:= ""
Local cEstab		:= ""
Local cCartao		:= ""
Local nRegProv		:= 0
Local nRegLiq		:= 0
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a REDECARD                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If RetCpoCart(TRB->TEXTO,1,",") == "0"
	If Upper(RetCpoCart(TRB->TEXTO,6,",")) <> "REDECARD"
      U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.f.)
	EndIf
Else
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf

If Upper(RetCpoCart(TRB->TEXTO,5,",")) == "MOVIMENTACAO DIARIA - CARTOES DE DEBITO"
	cTipoArq := "D"
Else
	U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf
                   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora REDECARD no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return(.f.)
Endif
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm1,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora CONSTRUCARD no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return(.f.)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !RetCpoCart(TRB->TEXTO,1,",") $ "1/5" .and. cTipoArq == "D"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cEstab := Alltrim(Str(Val(RetCpoCart(TRB->TEXTO,2,","))))
	DbSelectArea("PAB")
	DbSetOrder(2)
	IF !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
   	If aScan(aMaqs, cAdm+cEstab) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+cEstab+" da administradora REDECARD nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+cEstab)
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   /*
   If !RetCpoCart(TRB->TEXTO,1,",") $ "1/5" .and. cTipoArq == "D"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
   */

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (RetCpoCart(TRB->TEXTO,1,",") == "1" .and. cTipoArq == "D")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif (RetCpoCart(TRB->TEXTO,1,",") == "5" .and. cTipoArq == "D")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		If RetCpoCart(TRB->TEXTO,12,",") == "01"
			If Substr(RetCpoCart(TRB->TEXTO,8,","),1,5) <> "53104"
				Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
			Else
				Aadd(aRegCC, {TRB->TEXTO, TRB->(Recno())})
			Endif
		Endif
		DbSelectArea("TRB")
		DbSkip()
	Else
		DbSelectArea("TRB")
		DbSkip()
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (RetCpoCart(TRB->TEXTO,1,",") $ "1/2" .or. TRB->(EOF())) .and. Len(aRegRV) > 0 .and. (Len(aRegCV) > 0 .or. Len(aRegCC) > 0)
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a maquineta esta cadastrada											Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cEstab := Alltrim(Str(Val(RetCpoCart(cTexto,2,","))))
			DbSelectArea("PAB")
			DbSetOrder(2)
			DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Processa arquivo de cartoes de debito												Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If cTipoArq == "D"
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Inicializa variaveis de trabalho													Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			   dCredito 	:= Ctod(SubStr(RetCpoCart(cTexto,3,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),05,04))
			   dCredOri 	:= Ctod(SubStr(RetCpoCart(cTexto,3,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),05,04))
			   dEmissao 	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
			   cProduto 	:= RetCpoCart(cTexto,10,",")
			   cSituaca 	:= "P"
			   cSinal   	:= "+"
			   cRvAtu   	:= PAB->PAB_ADM+Alltrim(RetCpoCart(cTexto,5,","))
	         nVlrBrut 	:= Val(RetCpoCart(cTexto,7,","))/100
	         nVlrLiq  	:= Val(RetCpoCart(cTexto,9,","))/100
	         nVlrDesc 	:= Val(RetCpoCart(cTexto,8,","))/100
	         nVlrReje 	:= 0.00
	         cChVlLq		:= StrZero(nVlrLiq*100,17)
	         cOper			:= ""
				cParcela 	:= "01"
				cTotParcs	:= "01"     
			Endif

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Atualiza as variaveis com os valores informados								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cOper	:= "P"
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se o resumo ja encontra-se cadastrado  								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	      DbSelectArea("PBB")
	      DbSetOrder(1) //PBB_FILIAL+PBB_CODADM+PBB_CODMAQ+PBB_NRV+DTOS(PBB_CREDIT)+PBB_PARCEL+PBB_TOTPAR+PBB_TPOPER+PBB_CHVLLQ
//			If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Substr(cRvAtu,1,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
			If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Padr(cRvAtu,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
		      aTotProc[3]++
				GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
		 	ElseIf  dEmissao < dCorte //Rodrigo 25/02/05
		      aTotProc[3]++
				GravaLog(Alltrim(cArquivo), "Data anterior a data corte", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
		 	Else                                                            
		 		If Len(aRegCV) > 0
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)

		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= cEstab
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_EMISS  	:= dEmissao
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
		         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
		         PBB->PBB_CREDIT 	:= DataValida(dCredito)
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
		         PBB->PBB_TPOPER 	:= cOper
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
					PBB->PBB_IDPA5		:=	cChavePA5
		         MsUnlock()
					DbCommit()
					nRegProv	:= PBB->(Recno())
				Endif
										
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava registro de provisao quando houver liquidacao							Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cOper == "P" .and. Len(aRegCV) > 0
					cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)

		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= cEstab
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_EMISS  	:= dEmissao
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
		         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
		         PBB->PBB_CREDIT 	:= DataValida(dCredito)
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
		         PBB->PBB_TPOPER 	:= "L"
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
					PBB->PBB_IDPA5		:=	cChavePA5
		         MsUnlock()
					DbCommit()
					nRegLiq	:= PBB->(Recno())
				Endif	
		      aTotProc[1]++
		      
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava os CVs se existirem                         							Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				For nY := 1 to Len(aRegCV)
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//					cIdentPBC 	:= RetIdPBC(cIdentPBC)
					cTexto 		:= aRegCV[nY,1]

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   cSinal   	:= "+"
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(RetCpoCart(cTexto,5,","))
					cCartao		:= Substr(Alltrim(RetCpoCart(cTexto,8,",")),1,15)+Iif(Substr(Alltrim(RetCpoCart(cTexto,8,",")),16,4) <> "****",Substr(Alltrim(RetCpoCart(cTexto,8,",")),16,4),"")
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona no PBB de Provisao                            					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("PBB")
					DbGoTo(nRegProv)

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava o arquivo de comprovantes de venda                					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			      DbSelectArea("PBC")
			      DbSetOrder(1)
	   	      RecLock("PBC",.T.)
					cIdentPBC	:= StrZero(Recno(),20)

		         PBC->PBC_FILIAL 	:= xFilial("PBC")
		         PBC->PBC_CODADM 	:= cAdm
		         PBC->PBC_CODMAQ 	:= cEstab
		         PBC->PBC_NRV    	:= PBB->PBB_NRV
		         PBC->PBC_CARTAO 	:= cCartao
		         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
		         PBC->PBC_NCV    	:= Alltrim(Str(Val(RetCpoCart(cTexto,10,","))))
		         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
		         PBC->PBC_PARCEL 	:= "01"
		         PBC->PBC_TOTPAR 	:= "01"
			      PBC->PBC_EMISS  	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
			      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
			      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
			      PBC->PBC_VLBRUT 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
		         PBC->PBC_TOTCOM 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
		         PBC->PBC_VLDESC 	:= Abs(Val(RetCpoCart(cTexto,6,","))/100)
		         PBC->PBC_VLLIQ  	:= Abs(Val(RetCpoCart(cTexto,7,","))/100)
		         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
			      PBC->PBC_CAPTUR 	:= ""
			      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
			      PBC->PBC_DESCRI 	:= "Venda"
					PBC->PBC_TPCART 	:= PBB->PBB_TPCART
		         PBC->PBC_TPOPER 	:= cOper
		         PBC->PBC_PRODUT 	:= cProduto
		         PBC->PBC_IDPBC  	:= cIdentPBC     
		         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
		         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB  
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
			      //Ё mente o valor das parcelas para gravar no SE1.                Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If PBC->(FieldPos('PBC_DESCTO')) >0
			         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
			      Endif 

			      MsUnlock()
					DbCommit()
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza o PBB                                     							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nRegProv > 0
						DbSelectArea("PBB")
						DbGoTo(nRegProv)
						RecLock("PBB",.F.)
			         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
			         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
			         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
			         PBB->PBB_VLREJE 	:= 0.00
			         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
			         MsUnlock()
						DbCommit()
			   	Endif

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava a liquidacao quando houver provisao               					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cOper == "P"
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Posiciona no PBB de Liquidacao                          					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectArea("PBB")
						DbGoTo(nRegLiq)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//						cIdentPBC 	:= RetIdPBC(cIdentPBC)
				      DbSelectArea("PBC")
				      DbSetOrder(1)
		   	      RecLock("PBC",.T.)
						cIdentPBC	:= StrZero(Recno(),20)
			         PBC->PBC_FILIAL 	:= xFilial("PBC")
			         PBC->PBC_CODADM 	:= cAdm
			         PBC->PBC_CODMAQ 	:= cEstab
			         PBC->PBC_NRV    	:= PBB->PBB_NRV
			         PBC->PBC_CARTAO 	:= cCartao
			         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
			         PBC->PBC_NCV    	:= Alltrim(Str(Val(RetCpoCart(cTexto,10,","))))
			         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
			         PBC->PBC_PARCEL 	:= "01"
			         PBC->PBC_TOTPAR 	:= "01"
				      PBC->PBC_EMISS  	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
				      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
				      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
				      PBC->PBC_VLBRUT 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
			         PBC->PBC_TOTCOM 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
			         PBC->PBC_VLDESC 	:= Abs(Val(RetCpoCart(cTexto,6,","))/100)
			         PBC->PBC_VLLIQ  	:= Abs(Val(RetCpoCart(cTexto,7,","))/100)
			         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
				      PBC->PBC_CAPTUR 	:= ""
				      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
				      PBC->PBC_DESCRI 	:= "Venda"
						PBC->PBC_TPCART 	:= PBB->PBB_TPCART
			         PBC->PBC_TPOPER 	:= "L"
			         PBC->PBC_PRODUT 	:= cProduto
			         PBC->PBC_IDPBC  	:= cIdentPBC     
			         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
			         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
				      //Ё mente o valor das parcelas para gravar no SE1.                Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If PBC->(FieldPos('PBC_DESCTO')) >0
				         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
				      Endif 

				      MsUnlock()
						DbCommit()
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza o PBB                                     							Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If nRegLiq > 0
							DbSelectArea("PBB")
							DbGoTo(nRegLiq)
							RecLock("PBB",.F.)
				         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
				         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
				         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
				         PBB->PBB_VLREJE 	:= 0.00
				         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
				         MsUnlock()
							DbCommit()
				   	Endif
					Endif
			      aTotProc[2]++
				Next nY 

				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava os dados do cartao Contrucard se existirem								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Len(aRegCC) > 0
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Alimenta variavel de uso          													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
					cTexto 		:= aRegRV[nX,1]
//				   cRvAtu   	:= "C"+Alltrim(RetCpoCart(cTexto,5,","))
					cRvAtu   	:=	PAB->PAB_ADM+Alltrim(RetCpoCart(cTexto,5,","))
				   dCredito 	:= Ctod(SubStr(RetCpoCart(cTexto,3,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),05,04))
				   dCredOri 	:= Ctod(SubStr(RetCpoCart(cTexto,3,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,3,","),05,04))
				   dEmissao 	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
				   cProduto 	:= RetCpoCart(cTexto,10,",")
				   cSituaca 	:= "P"
				   cSinal   	:= "+"
		         nVlrBrut 	:= Val(RetCpoCart(cTexto,7,","))/100
		         nVlrLiq  	:= Val(RetCpoCart(cTexto,9,","))/100
		         nVlrDesc 	:= Val(RetCpoCart(cTexto,8,","))/100
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= "P"
					cParcela 	:= "01"
					cTotParcs	:= "01"     
							
					cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)

		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm1
		         PBB->PBB_CODMAQ 	:= cEstab
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_EMISS  	:= dEmissao
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
		         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
		         PBB->PBB_CREDIT 	:= DataValida(dCredito)
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
		         PBB->PBB_TPOPER 	:= cOper
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
  					PBB->PBB_IDPA5		:=	cChavePA5
					MsUnlock()
					DbCommit()
					nRegProv	:= PBB->(Recno())
					
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava registro de provisao quando houver liquidacao							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cOper == "P"
						cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
		      	   RecLock("PBB",.T.)
						cIdent 	:= StrZero(Recno(),15)
   	
			         PBB->PBB_FILIAL 	:= xFilial("PBB")
			         PBB->PBB_CODADM 	:= cAdm1
			         PBB->PBB_CODMAQ 	:= cEstab
			         PBB->PBB_NRV    	:= cRvAtu
			         PBB->PBB_EMISS  	:= dEmissao
			         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
			         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
			         PBB->PBB_ARQUIV 	:= cArquivo
			         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
			         PBB->PBB_CREDIT 	:= DataValida(dCredito)
			         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
			         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
			         PBB->PBB_SITUAC 	:= cSituaca
			         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
			         PBB->PBB_TPOPER 	:= "L"
			         PBB->PBB_IDENT  	:= cIdent
			         PBB->PBB_ESTAB		:= cDescEst
	  					PBB->PBB_IDPA5		:=	cChavePA5
			         MsUnlock()
						DbCommit()
						nRegLiq	:= PBB->(Recno())
					Endif	
			      aTotProc[1]++
			      
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava os CVs se existirem                         							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nY := 1 to Len(aRegCC)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Posiciona no PBB de Provisao                            					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectArea("PBB")
						DbGoTo(nRegProv)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//						cIdentPBC 	:= RetIdPBC(cIdentPBC)
						cTexto 		:= aRegCC[nY,1]
						
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Inicializa variaveis de trabalho													Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					   cSinal   	:= "+"
					   cRvAtu   	:= "C"+Alltrim(RetCpoCart(cTexto,5,","))
						cCartao		:= Substr(Alltrim(RetCpoCart(cTexto,8,",")),1,15)+Iif(Substr(Alltrim(RetCpoCart(cTexto,8,",")),16,4) <> "****",Substr(Alltrim(RetCpoCart(cTexto,8,",")),16,4),"")

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Grava o arquivo de comprovantes de venda                					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				      DbSelectArea("PBC")
				      DbSetOrder(1)
		   	      RecLock("PBC",.T.)
						cIdentPBC	:= StrZero(Recno(),20)
			         PBC->PBC_FILIAL 	:= xFilial("PBC")
			         PBC->PBC_CODADM 	:= cAdm1
			         PBC->PBC_CODMAQ 	:= cEstab
			         PBC->PBC_NRV    	:= PBB->PBB_NRV
			         PBC->PBC_CARTAO 	:= cCartao
			         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
			         PBC->PBC_NCV    	:= Alltrim(Str(Val(RetCpoCart(cTexto,10,","))))
			         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
			         PBC->PBC_PARCEL 	:= "01"
			         PBC->PBC_TOTPAR 	:= "01"
				      PBC->PBC_EMISS  	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
				      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
				      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
				      PBC->PBC_VLBRUT 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
			         PBC->PBC_TOTCOM 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
			         PBC->PBC_VLDESC 	:= Abs(Val(RetCpoCart(cTexto,6,","))/100)
			         PBC->PBC_VLLIQ  	:= Abs(Val(RetCpoCart(cTexto,7,","))/100)
			         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
				      PBC->PBC_CAPTUR 	:= ""
				      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
				      PBC->PBC_DESCRI 	:= "Venda"
						PBC->PBC_TPCART 	:= PBB->PBB_TPCART
			         PBC->PBC_TPOPER 	:= cOper
			         PBC->PBC_PRODUT 	:= cProduto
			         PBC->PBC_IDPBC  	:= cIdentPBC     
			         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
			         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
				      //Ё mente o valor das parcelas para gravar no SE1.                Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If PBC->(FieldPos('PBC_DESCTO')) >0
				         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
				      Endif 
				      MsUnlock()
						DbCommit()
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza o PBB                                     							Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If nRegProv > 0
							DbSelectArea("PBB")
							DbGoTo(nRegProv)
							RecLock("PBB",.F.)
				         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
				         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
				         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
				         PBB->PBB_VLREJE 	:= 0.00
				         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
				         MsUnlock()
							DbCommit()
				   	Endif

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Grava a liquidacao quando houver provisao               					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If cOper == "P"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Posiciona no PBB de Liquidacao                          					Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							DbSelectArea("PBB")
							DbGoTo(nRegLiq)
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Atualiza as variaveis com os valores informados								Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	//						cIdentPBC 	:= RetIdPBC(cIdentPBC)
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Grava o arquivo de comprovantes de venda                					Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					      DbSelectArea("PBC")
					      DbSetOrder(1)
			   	      RecLock("PBC",.T.)
							cIdentPBC	:= StrZero(Recno(),20)

				         PBC->PBC_FILIAL 	:= xFilial("PBC")
				         PBC->PBC_CODADM 	:= cAdm1
				         PBC->PBC_CODMAQ 	:= cEstab
				         PBC->PBC_NRV    	:= PBB->PBB_NRV
				         PBC->PBC_CARTAO 	:= cCartao
				         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
				         PBC->PBC_NCV    	:= Alltrim(Str(Val(RetCpoCart(cTexto,10,","))))
				         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
				         PBC->PBC_PARCEL 	:= "01"
				         PBC->PBC_TOTPAR 	:= "01"
					      PBC->PBC_EMISS  	:= Ctod(SubStr(RetCpoCart(cTexto,4,","),01,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),03,02)+"/"+SubStr(RetCpoCart(cTexto,4,","),05,04))
					      PBC->PBC_TIPO   	:= If(SubStr(cTexto,46,1)=="+","C","D")
					      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
					      PBC->PBC_VLBRUT 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
				         PBC->PBC_TOTCOM 	:= Abs(Val(RetCpoCart(cTexto,5,","))/100)
				         PBC->PBC_VLDESC 	:= Abs(Val(RetCpoCart(cTexto,6,","))/100)
				         PBC->PBC_VLLIQ  	:= Abs(Val(RetCpoCart(cTexto,7,","))/100)
				         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
					      PBC->PBC_CAPTUR 	:= ""
					      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
					      PBC->PBC_DESCRI 	:= "Venda"
							PBC->PBC_TPCART 	:= PBB->PBB_TPCART
				         PBC->PBC_TPOPER 	:= "L"
				         PBC->PBC_PRODUT 	:= cProduto
				         PBC->PBC_IDPBC  	:= cIdentPBC     
				         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
				         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
							//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
					      //Ё mente o valor das parcelas para gravar no SE1.                Ё
							//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If PBC->(FieldPos('PBC_DESCTO')) >0
					         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
					      Endif 
					      MsUnlock()
							DbCommit()
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Atualiza o PBB                                     							Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If nRegLiq > 0
								DbSelectArea("PBB")
								DbGoTo(nRegLiq)
								RecLock("PBB",.F.)
					         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
					         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
					         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
					         PBB->PBB_VLREJE 	:= 0.00
					         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
					         MsUnlock()
								DbCommit()
					   	Endif
						Endif                                      
				      aTotProc[2]++
					Next nY 
				Endif	

				DbSelectArea("PBB")
				MsUnlockAll()
				DbCommitAll()
				DbSelectArea("PBC")
				MsUnlockAll()
				DbCommitAll()
			Endif
		Next nX
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV 	:= {}
	   aRegCV 	:= {}
	   aRegCC 	:= {}
	   nRegProv	:= 0
	   nRegLiq	:= 0
	Endif
		

	DbSelectArea("TRB")
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza Controle de Transacao               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//End Transaction

Return (.t.)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁImpRCrd1  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao REDECARD - Vendas a credito      Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpRCrd1(cArquivo, cAdm)            
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local dEmissao 	:= CTOD("")
Local cProduto 	:= ""
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local cChVlLq  	:= ""
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local nTotParcs	:= 0
Local cAdm			:= "CE"
Local aMaqs			:= {}
Local aRegRV		:= {}
Local aRegCV		:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local cTipoArq		:= ""
Local cEstab		:= ""
Local cCartao		:= ""
Local nRegProv		:= 0.00
Local dDataAj		:=	Ctod('')
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a REDECARD                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If Substr(TRB->TEXTO,1,3) == "002"
	If Upper(Substr(TRB->TEXTO,12,8)) <> "REDECARD"
      U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.f.)
	EndIf
Else
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf

If Upper(Substr(TRB->TEXTO,20,30)) == "EXTRATO DE MOVIMENTO DE VENDAS"
	cTipoArq := "C"
Else
	U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf
dDataAj 	:= Ctod(SubStr(TRB->TEXTO,004,02)+"/"+SubStr(TRB->TEXTO,006,02)+"/"+SubStr(TRB->TEXTO,008,04))
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora REDECARD no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return(.f.)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !Substr(TRB->TEXTO,1,3) $ "006/007/008/009/010/012/" .and. cTipoArq == "C"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cEstab := Alltrim(Str(Val(Substr(TRB->TEXTO,4,9))))
	DbSelectArea("PAB")
	DbSetOrder(2)
	IF !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
   	If aScan(aMaqs, cAdm+cEstab) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+cEstab+" da administradora REDECARD nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+cEstab)
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   /*
   If !Substr(TRB->TEXTO,1,3) $ "006/007/008/010/012" .and. cTipoArq == "C"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
	*/

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Substr(TRB->TEXTO,1,3) $ "006/009/010" .and. cTipoArq == "C")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
   Elseif (Substr(TRB->TEXTO,1,3) $ "008/012" .and. cTipoArq == "C")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
	Else
		DbSelectArea("TRB")
		DbSkip()
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Substr(TRB->TEXTO,1,3) $ "006/009/010" .or. TRB->(EOF())) .and. Len(aRegRV) > 0
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a maquineta esta cadastrada											Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cEstab := Alltrim(Str(Val(Substr(cTexto,4,9))))
			DbSelectArea("PAB")
			DbSetOrder(2)
			DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
		
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Processa arquivo de cartoes de debito												Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If cTipoArq == "C"
				aParcelas	:=	{}          
				cMot			:=	""
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Cartao de Credito Rotativo      													Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Substr(cTexto,1,3) == "006"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= Ctod(SubStr(cTexto,130,02)+"/"+SubStr(cTexto,132,02)+"/"+SubStr(cTexto,134,04))
				   dCredOri 	:= Ctod(SubStr(cTexto,130,02)+"/"+SubStr(cTexto,132,02)+"/"+SubStr(cTexto,134,04))
				   dEmissao 	:= Ctod(SubStr(cTexto,042,02)+"/"+SubStr(cTexto,044,02)+"/"+SubStr(cTexto,046,04))
				   cProduto 	:= SubStr(cTexto,138,01)
				   cSituaca 	:= "P"
				   cSinal   	:= "+"
//				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,013,009))
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,014,008))
		         nVlrBrut 	:= Val(SubStr(cTexto,055,15))/100
		         nVlrLiq  	:= Val(SubStr(cTexto,115,15))/100
		         nVlrDesc 	:= Val(SubStr(cTexto,100,15))/100
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""             
					cParcela 	:= "01"
					cTotParcs	:= "01"     
					Aadd(aParcelas,{nVlrBrut,dCredOri})
				ElseIf Substr(cTexto,1,3) == "007"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Ajustes (NET)                   													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= Ctod(SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,02)+"/"+SubStr(cTexto,026,04))
				   dCredOri 	:= Ctod(SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,02)+"/"+SubStr(cTexto,026,04))
				   dEmissao 	:= Ctod(SubStr(cTexto,092,02)+"/"+SubStr(cTexto,094,02)+"/"+SubStr(cTexto,096,04))
				   cProduto 	:= ""
				   cSituaca 	:= "A"
				   cSinal   	:= "+"
//				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,013,009))
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,014,008))
		         nVlrBrut 	:= Val(SubStr(cTexto,030,15))/100
		         nVlrLiq  	:= Val(SubStr(cTexto,030,15))/100
		         nVlrDesc 	:= 0.00
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""
					cParcela 	:= "01"
					cTotParcs	:= "01"     
					Aadd(aParcelas,{nVlrBrut,dCredOri})
				ElseIf Substr(cTexto,1,3) == "010"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Cartao de Credito Parcelado     													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= Ctod(SubStr(cTexto,130,02)+"/"+SubStr(cTexto,132,02)+"/"+SubStr(cTexto,134,04))
				   dCredOri 	:= Ctod(SubStr(cTexto,130,02)+"/"+SubStr(cTexto,132,02)+"/"+SubStr(cTexto,134,04))
				   dEmissao 	:= Ctod(SubStr(cTexto,042,02)+"/"+SubStr(cTexto,044,02)+"/"+SubStr(cTexto,046,04))
				   cProduto 	:= SubStr(cTexto,138,01)
				   cSituaca 	:= "P"
				   cSinal   	:= "+"
//				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,013,009))
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,014,008))
		         nVlrBrut 	:= Val(SubStr(cTexto,055,15))/100
		         nVlrLiq  	:= Val(SubStr(cTexto,115,15))/100
		         nVlrDesc 	:= Val(SubStr(cTexto,100,15))/100
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""
					cParcela 	:= "01"
					cTotParcs	:= "01"     
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Pesquisa o total de parcelas    													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nY := 1 to Len(aRegCV)
						If Val(Substr(aRegCV[nY,1],86,2)) > Val(cTotParcs)
							cTotParcs	:= StrZero(Val(Substr(aRegCV[nY,1],86,2)),2)
						Endif
					Next nY                      
					Aadd(aParcelas,{nVlrBrut,dCredOri})
				ElseIf Substr(cTexto,1,3) == "009"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Desagendamento de parcelas      													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= dDataAj
				   dEmissao 	:= Ctod(SubStr(cTexto,135,02)+"/"+SubStr(cTexto,133,02)+"/"+SubStr(cTexto,129,04))
				   cProduto 	:= ""
				   cSituaca 	:= "A"
//				   cSinal   	:= "-"
//				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,013,009))
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,014,008))
		         nVlrDesc 	:= 0.00
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""
					cParcela 	:= "01"
					cTotParcs	:= "01"     
				   dCredOri 	:= Ctod(SubStr(cTexto,043,02)+"/"+SubStr(cTexto,041,02)+"/"+SubStr(cTexto,037,04))
		         nVlrBrut 	:= (Val(SubStr(cTexto,045,15))/100)
		         nVlrLiq  	:= (Val(SubStr(cTexto,045,15))/100)
					If nVlrBrut > 0									
						Aadd(aParcelas,{nVlrBrut,dCredOri})
					Endif                                  
				   dCredOri 	:= Ctod(SubStr(cTexto,066,02)+"/"+SubStr(cTexto,064,02)+"/"+SubStr(cTexto,060,04))
		         nVlrBrut 	:= Val(SubStr(cTexto,068,15))/100
					If nVlrBrut > 0									
						Aadd(aParcelas,{nVlrBrut,dCredOri})
					Endif                                  
				   dCredOri 	:= Ctod(SubStr(cTexto,089,02)+"/"+SubStr(cTexto,087,02)+"/"+SubStr(cTexto,083,04))
		         nVlrBrut 	:= Val(SubStr(cTexto,091,15))/100
					If nVlrBrut > 0									
						Aadd(aParcelas,{nVlrBrut,dCredOri})
					Endif                                  
				   dCredOri 	:= Ctod(SubStr(cTexto,112,02)+"/"+SubStr(cTexto,110,02)+"/"+SubStr(cTexto,106,04))
		         nVlrBrut 	:= Val(SubStr(cTexto,114,15))/100
					If nVlrBrut > 0									
						Aadd(aParcelas,{nVlrBrut,dCredOri})
					Endif    
//					cMot	:=	'RDA00'+SubStr(cTexto,149,01) //Motivo desagendamento redecard - Rodrigo 29/03/05
//					cMot	:=	'RDA10'+SubStr(cTexto,149,01) //Motivo desagendamento redecard - Rodrigo 12/04/05
					cMot	:=	'RDA100'
					//Quando ha varias parcelas, a que parcela refere-se?
				Endif
			Endif

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se eh liquidacao ou Provisao ou Ajuste								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			If (cSituaca $ "PA")
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza as variaveis com os valores informados								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cSituaca == "A"
					cOper := "A"
				ElseIf cSituaca == "L"
					cOper := "L"
				ElseIf cSituaca == "P"
					cOper	:= "P"
				Endif
									
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica se o resumo ja encontra-se cadastrado  								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		      DbSelectArea("PBB")
		      DbSetOrder(1) //PBB_FILIAL+PBB_CODADM+PBB_CODMAQ+PBB_NRV+DTOS(PBB_CREDIT)+PBB_PARCEL+PBB_TOTPAR+PBB_TPOPER+PBB_CHVLLQ
//				If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Substr(cRvAtu,1,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
				If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Padr(cRvAtu,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
			      aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
		 		ElseIf  dEmissao < dCorte //Rodrigo 25/02/05
		      	aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Data anterior a data corte", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
			 	Else
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nPa:= 1 To Len(aParcelas)	
						cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")

		      	   RecLock("PBB",.T.)
						cIdent 	:= StrZero(Recno(),15)
   	
			         PBB->PBB_FILIAL 	:= xFilial("PBB")
			         PBB->PBB_CODADM 	:= cAdm
			         PBB->PBB_CODMAQ 	:= cEstab
			         PBB->PBB_NRV    	:= cRvAtu
			         PBB->PBB_EMISS  	:= dEmissao
			         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
			         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
			         PBB->PBB_ARQUIV 	:= cArquivo
			         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
			         PBB->PBB_CREDIT 	:= DataValida(aParcelas[nPa][2])
			         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
			         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
			         PBB->PBB_SITUAC 	:= cSituaca
			         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
			         PBB->PBB_TPOPER 	:= cOper
			         PBB->PBB_IDENT  	:= cIdent
			         PBB->PBB_ESTAB		:= cDescEst
			         PBB->PBB_VLBRUT 	:= aParcelas[nPa][1]
			         PBB->PBB_VLLIQ  	:= aParcelas[nPa][1]   
			         PBB->PBB_MOT		:=	cMot                         
	  					PBB->PBB_IDPA5		:=	cChavePA5
			         If !Empty(cMot)
			         	PBB->PBB_DTAJU	:=	dDataAj
			         Endif
			         MsUnlock()
						DbCommit()
					Next
		         nRegProv := PBB->(Recno())
			      aTotProc[1]++
			      
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava os CVs se existirem                         							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nY := 1 to Len(aRegCV)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza asd variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	  //				cIdentPBC := RetIdPBC(cIdentPBC)

						cTexto 		:= aRegCV[nY,1]
						If cTipoArq == "C"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Cartao de Credito rotativo      													Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If Substr(cTexto,1,3) == "008"
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Inicializa variaveis de trabalho													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							   cSinal   	:= "+"
//							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,13,9))
							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,14,8))
								cCartao		:= Alltrim(Substr(cTexto,68,16))
							 	If Substr(cCartao,1,2) == "00"
							 		cCartao := Substr(cCartao,3,14)
							 	Endif
							 	
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Grava o arquivo de comprovantes de venda                					Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						      DbSelectArea("PBC")
						      DbSetOrder(1)
				   	      RecLock("PBC",.T.)
								cIdentPBC	:= StrZero(Recno(),20)

					         PBC->PBC_FILIAL 	:= xFilial("PBC")
					         PBC->PBC_CODADM 	:= cAdm
					         PBC->PBC_CODMAQ 	:= cEstab
					         PBC->PBC_NRV    	:= PBB->PBB_NRV
					         PBC->PBC_CARTAO 	:= cCartao
					         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
					         PBC->PBC_NCV    	:= Alltrim(Str(Val(Substr(cTexto,88,12))))
					         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
					         PBC->PBC_PARCEL 	:= "01"
					         PBC->PBC_TOTPAR 	:= "01"
						      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,02)+"/"+SubStr(cTexto,026,04))
						      PBC->PBC_TIPO   	:= "C"
						      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
						      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,038,15))/100)
					         PBC->PBC_TOTCOM 	:= Abs(Val(SubStr(cTexto,038,15))/100)
					         PBC->PBC_VLDESC 	:= Abs(Val(SubStr(cTexto,111,15))/100)
					         PBC->PBC_VLLIQ  	:= Abs(Val(SubStr(cTexto,038,15))/100) - Abs(Val(SubStr(cTexto,111,15))/100)
					         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
						      PBC->PBC_CAPTUR 	:= ""
						      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
						      PBC->PBC_DESCRI 	:= "Venda"
								PBC->PBC_TPCART 	:= PBB->PBB_TPCART
					         PBC->PBC_TPOPER 	:= cOper
					         PBC->PBC_PRODUT 	:= cProduto
					         PBC->PBC_IDPBC  	:= cIdentPBC     
					         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
					         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
						      //Ё mente o valor das parcelas para gravar no SE1.                Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If PBC->(FieldPos('PBC_DESCTO')) >0
						         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
						      Endif 
							ElseIf Substr(cTexto,1,3) == "007"
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Ajustes (NET)                     													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Inicializa variaveis de trabalho													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							   cSinal   	:= "+"
//							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,13,9))
							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,14,8))
								cCartao		:= Alltrim(Substr(cTexto,76,16))
							 	If Substr(cCartao,1,2) == "00"
							 		cCartao := Substr(cCartao,3,14)
							 	Endif
										
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Grava o arquivo de comprovantes de venda                					Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						      DbSelectArea("PBC")
						      DbSetOrder(1)
				   	      RecLock("PBC",.T.)
								cIdentPBC	:= StrZero(Recno(),20)

					         PBC->PBC_FILIAL 	:= xFilial("PBC")
					         PBC->PBC_CODADM 	:= cAdm
					         PBC->PBC_CODMAQ 	:= cEstab
					         PBC->PBC_NRV    	:= PBB->PBB_NRV
					         PBC->PBC_CARTAO 	:= cCartao
					         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
					         PBC->PBC_NCV    	:= Alltrim(Str(Val(Substr(cTexto,138,12))))
					         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
					         PBC->PBC_PARCEL 	:= "01"
					         PBC->PBC_TOTPAR 	:= "01"
						      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,092,02)+"/"+SubStr(cTexto,094,02)+"/"+SubStr(cTexto,096,04))
						      PBC->PBC_TIPO   	:= "C"
						      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
						      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,030,15))/100)
					         PBC->PBC_TOTCOM 	:= Abs(Val(SubStr(cTexto,030,15))/100)
					         PBC->PBC_VLDESC 	:= 0.00
					         PBC->PBC_VLLIQ  	:= Abs(Val(SubStr(cTexto,030,15)/100))
					         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
						      PBC->PBC_CAPTUR 	:= ""
						      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
						      PBC->PBC_DESCRI 	:= "AJUSTE RV "+PAB->PAB_ADM+Alltrim(Substr(cTexto,100,9))
								PBC->PBC_TPCART 	:= PBB->PBB_TPCART
					         PBC->PBC_TPOPER 	:= cOper
					         PBC->PBC_PRODUT 	:= cProduto
					         PBC->PBC_IDPBC  	:= cIdentPBC     
					         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
					         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
						      //Ё mente o valor das parcelas para gravar no SE1.                Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If PBC->(FieldPos('PBC_DESCTO')) >0
						         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
						      Endif 
							ElseIf Substr(cTexto,1,3) == "012"
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Cartao de Credito Parcelado     													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Inicializa variaveis de trabalho													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							   cSinal   	:= "+"
//							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,13,9))
							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,14,8))
								cCartao		:= Alltrim(Substr(cTexto,68,16))
							 	If Substr(cCartao,1,2) == "00"
							 		cCartao := Substr(cCartao,3,14)
							 	Endif
																		
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Grava o arquivo de comprovantes de venda                					Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						      DbSelectArea("PBC")
						      DbSetOrder(1)
				   	      RecLock("PBC",.T.)
								cIdentPBC	:= StrZero(Recno(),20)
		
					         PBC->PBC_FILIAL 	:= xFilial("PBC")
					         PBC->PBC_CODADM 	:= cAdm
					         PBC->PBC_CODMAQ 	:= cEstab
					         PBC->PBC_NRV    	:= PBB->PBB_NRV
					         PBC->PBC_CARTAO 	:= cCartao
					         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
					         PBC->PBC_NCV    	:= Alltrim(Str(Val(Substr(cTexto,88,12))))
					         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
					         PBC->PBC_PARCEL 	:= "01"
					         PBC->PBC_TOTPAR 	:= StrZero(Val(SubStr(cTexto,086,02)),2)
						      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,02)+"/"+SubStr(cTexto,026,04))
						      PBC->PBC_TIPO   	:= "C"
						      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
						      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,038,15))/100) / Val(SubStr(cTexto,086,02))
					         PBC->PBC_TOTCOM 	:= Abs(Val(SubStr(cTexto,038,15))/100) //* Val(SubStr(cTexto,086,02))
					         PBC->PBC_VLDESC 	:= Abs(Val(SubStr(cTexto,113,15))/100) / Val(SubStr(cTexto,086,02))
					         PBC->PBC_VLLIQ  	:= PBC->PBC_VLBRUT - PBC->PBC_VLDESC
					         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
						      PBC->PBC_CAPTUR 	:= ""
						      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
						      PBC->PBC_DESCRI 	:= "Venda"
								PBC->PBC_TPCART 	:= PBB->PBB_TPCART
					         PBC->PBC_TPOPER 	:= cOper
					         PBC->PBC_PRODUT 	:= cProduto
					         PBC->PBC_IDPBC  	:= cIdentPBC     
					         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
					         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
						      //Ё mente o valor das parcelas para gravar no SE1.                Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If PBC->(FieldPos('PBC_DESCTO')) >0
						         PBC->PBC_DESCTO := Abs(Val(SubStr(cTexto,113,15))/100)
						      Endif 
							Endif
					      MsUnlock()        
							DbCommit()
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Atualiza o PBB                                          					Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					      If nRegProv > 0
					      	DbSelectArea("PBB")
					      	DbGoTo(nRegProv)
					      	RecLock("PBB",.F.)
					         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
					         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
					         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
					         PBB->PBB_VLREJE 	:= 0.00
					         PBB->PBB_CHVLLQ 	:= StrZero(PBB->PBB_VLLIQ*100,17)
		         			MsUnlock()
								DbCommit()
		         		Endif
		         		
					      aTotProc[2]++
					  	Endif
					Next nY 
					DbSelectArea("PBB")
					MsUnlockAll()
					DbCommitAll()
					DbSelectArea("PBC")
					MsUnlockAll()
					DbCommitAll()
				Endif
			Else
				GravaLog(Alltrim(cArquivo),"Liberacao para agenda financeira", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" - parcela "+cParcela+"/"+cTotParcs+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao.")
				nTotNProc++
			Endif			
		Next nX
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV := {}
	   aRegCV := {}
	Endif

	DbSelectArea("TRB")
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza Controle de Transacao               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//End Transaction

Return(.t.)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁImpRCrd2  Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao REDECARD - Mov Financeiro        Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpRCrd2(cArquivo, cAdm)            
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local dEmissao 	:= CTOD("")
Local cProduto 	:= ""
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local cChVlLq  	:= ""
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local nTotParcs	:= 0
Local cAdm			:= "CE"
Local aMaqs			:= {}
Local aRegRV		:= {}
Local aRegCV		:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local cTipoArq		:= ""
Local cEstab		:= ""
Local cCartao		:= ""
Local cMot			:=	""
Local dDataAj		:=	CtoD('')
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a REDECARD                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If Substr(TRB->TEXTO,1,3) == "030"
	If Upper(Substr(TRB->TEXTO,12,8)) <> "REDECARD"
      U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
		Return(.f.)
	EndIf
Else
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf

If Upper(Substr(TRB->TEXTO,20,34)) == "EXTRATO DE MOVIMENTACAO FINANCEIRA"
	cTipoArq := "C"
Else
	U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario da REDECARD. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf
dDataAj 	:= Ctod(SubStr(TRB->TEXTO,004,02)+"/"+SubStr(TRB->TEXTO,006,02)+"/"+SubStr(TRB->TEXTO,008,04))
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora REDECARD no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return(.f.)
Endif

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !Substr(TRB->TEXTO,1,3) $ "034/038" .and. cTipoArq == "C"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cEstab := Alltrim(Str(Val(Substr(TRB->TEXTO,4,9))))
	DbSelectArea("PAB")
	DbSetOrder(2)
	IF !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
   	If aScan(aMaqs, cAdm+cEstab) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+cEstab+" da administradora REDECARD nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+cEstab)
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   /*
   If !Substr(TRB->TEXTO,1,3) $ "034/038" .and. cTipoArq == "C"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
   */

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Substr(TRB->TEXTO,1,3) $ "034/038" .and. cTipoArq == "C")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
/*
   ElseIf (Substr(TRB->TEXTO,1,3) $ "038" .and. cTipoArq == "C")
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o CV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
		DbSelectArea("TRB")
		DbSkip()
*/
	Else
		DbSelectArea("TRB")
		DbSkip()
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (Substr(TRB->TEXTO,1,3) $ "034/038" .or. TRB->(EOF())) .and. Len(aRegRV) > 0
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se a maquineta esta cadastrada											Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			cEstab := Alltrim(Str(Val(Substr(cTexto,4,9))))
			DbSelectArea("PAB")
			DbSetOrder(2)
			DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
			cMot		:=	""
			cRvOri	:=	""
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Processa arquivo de cartoes de debito												Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If cTipoArq == "C"
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Creditos normais                													Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If Substr(cTexto,1,3) == "034"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= Ctod(SubStr(cTexto,020,02)+"/"+SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,04))
				   dCredOri 	:= Ctod(SubStr(cTexto,020,02)+"/"+SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,04))
//				   dEmissao 	:= Ctod(SubStr(cTexto,064,02)+"/"+SubStr(cTexto,066,02)+"/"+SubStr(cTexto,068,04))
				   dEmissao 	:= Ctod(SubStr(cTexto,080,02)+"/"+SubStr(cTexto,082,02)+"/"+SubStr(cTexto,084,04))
				   cProduto 	:= SubStr(cTexto,088,01)
				   cSituaca 	:= "L"
				   cSinal   	:= "+"
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,072,008))
		         nVlrBrut 	:= Val(SubStr(cTexto,090,15))/100
		         nVlrLiq  	:= Val(SubStr(cTexto,028,15))/100
		         nVlrDesc 	:= Val(SubStr(cTexto,105,15))/100
//					nTotParcs	:= ((nVlrBrut - nVlrDesc)/nVlrLiq)
//		         nVlrBrut 	:= nVlrBrut/nTotParcs
//		         nVlrDesc 	:= nVlrDesc/nTotParcs 
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""
					cParcela 	:= Iif(Empty(SubStr(cTexto,120,2)),"01",StrZero(Val(SubStr(cTexto,120,2)),2))
					cTotParcs	:= Strzero(nTotParcs,2)
				ElseIf Substr(cTexto,1,3) == "038"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Ajustes                         													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Inicializa variaveis de trabalho													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				   dCredito 	:= Ctod(SubStr(cTexto,020,02)+"/"+SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,04))
				   dCredOri 	:= Ctod(SubStr(cTexto,020,02)+"/"+SubStr(cTexto,022,02)+"/"+SubStr(cTexto,024,04))
				   dEmissao 	:= Ctod(SubStr(cTexto,072,02)+"/"+SubStr(cTexto,074,02)+"/"+SubStr(cTexto,076,04))
				   cProduto 	:= ""
				   cSituaca 	:= "A"
				   cSinal   	:= Iif(SubStr(cTexto,043,01)=="C","+","-")
				   cRvAtu   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,128,008))
		         nVlrBrut 	:= Val(SubStr(cTexto,028,15))/100 * Iif(cSinal=="-",-1,1)
		         nVlrLiq  	:= Val(SubStr(cTexto,028,15))/100 * Iif(cSinal=="-",-1,1)
		         nVlrDesc 	:= 0.00
		         nVlrReje 	:= 0.00
		         cChVlLq		:= StrZero(nVlrLiq*100,17)
		         cOper			:= ""
					cParcela 	:= "01"
					cTotParcs	:= "01"     
				   cRvOri   	:= PAB->PAB_ADM+Alltrim(SubStr(cTexto,064,008))
					If SubStr(cTexto,095,02) $"06/09/10/11/14/16/17/18/22/23/25/26/27/38/39/57/67/71/72/73/74/75/76/77/78/79/87/99"
						cMot			:=	"RAJ1"+SubStr(cTexto,095,02)
					Else
						cMot			:=	"RAJ2"+SubStr(cTexto,095,02)
				   Endif
				Endif                                                     
				
			Endif

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Verifica se eh liquidacao ou Provisao ou Ajuste								Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			If (cSituaca $ "LAP")
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza as variaveis com os valores informados								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cSituaca == "A"
					cOper := "A"
				ElseIf cSituaca == "L"
					cOper := "L"
				ElseIf cSituaca == "P"
					cOper	:= "P"
				Endif
									
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Verifica se o resumo ja encontra-se cadastrado  								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		      DbSelectArea("PBB")
		      DbSetOrder(1) //PBB_FILIAL+PBB_CODADM+PBB_CODMAQ+PBB_NRV+DTOS(PBB_CREDIT)+PBB_PARCEL+PBB_TOTPAR+PBB_TPOPER+PBB_CHVLLQ
//				If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Substr(cRvAtu,1,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
				If DbSeek(xFilial("PBB")+cAdm+Substr(cEstab,1,10)+Padr(cRvAtu,10)+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq,.F.)
			      aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
 			 	ElseIf  dEmissao < dCorte //Rodrigo 25/02/05
		     		 aTotProc[3]++
					GravaLog(Alltrim(cArquivo), "Data anterior a data corte", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
			 	Else
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
		         RecLock("PBB",.T.)

					cIdent 	:= StrZero(Recno(),15)

		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= cEstab
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_VLBRUT 	:= nVlrBrut
		         PBB->PBB_VLLIQ  	:= nVlrLiq 
		         PBB->PBB_VLDESC 	:= nVlrDesc
		         PBB->PBB_VLREJE 	:= nVlrReje
		         PBB->PBB_CHVLLQ 	:= cChVlLq
		         PBB->PBB_EMISS  	:= dEmissao
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
		         //PBB->PBB_CREDIT 	:= Iif(cTipoArq == "D",DataValida(dCredito+1),dCredito)
		         PBB->PBB_CREDIT 	:= DataValida(dCredito)
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= Iif(cTipoArq == "D","D","C")
		         PBB->PBB_TPOPER 	:= cOper
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
		         PBB->PBB_NRVORI 	:= cRvOri
		         PBB->PBB_MOT    	:= cMot 
  					PBB->PBB_IDPA5		:=	cChavePA5
		         If !Empty(cMot)
		         	PBB->PBB_DTAJU	:=	dDataAj
		         Endif	
		         MsUnlock()
					DbCommit()
			      aTotProc[1]++
			      
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava os CVs se existirem                         							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					For nY := 1 to Len(aRegCV)
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//						cIdentPBC := RetIdPBC(cIdentPBC)

						cTexto := aRegCV[nY,1]
						If cTipoArq == "C"
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Ajuste                          													Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If Substr(cTexto,1,3) == "038"
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Inicializa variaveis de trabalho													Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							   cSinal   	:= Iif(SubStr(cTexto,043,01)=="C","+","-")
							   cRvAtu   	:= PAB->PAB_ADM+Alltrim(Substr(cTexto,128,8))
								cCartao		:= Alltrim(Substr(cTexto,97,16))
										
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Grava o arquivo de comprovantes de venda                					Ё
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						      DbSelectArea("PBC")
						      DbSetOrder(1)
				   	      RecLock("PBC",.T.)
								cIdentPBC	:= StrZero(Recno(),20)
		
					         PBC->PBC_FILIAL 	:= xFilial("PBC")
					         PBC->PBC_CODADM 	:= cAdm
					         PBC->PBC_CODMAQ 	:= cEstab
					         PBC->PBC_NRV    	:= PBB->PBB_NRV
					         PBC->PBC_CARTAO 	:= cCartao
					         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
					         PBC->PBC_NCV    	:= Alltrim(Str(Val(Substr(cTexto,136,12))))
					         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
					         PBC->PBC_PARCEL 	:= "01"
					         PBC->PBC_TOTPAR 	:= "01"
						      PBC->PBC_EMISS  	:= Ctod(SubStr(cTexto,072,02)+"/"+SubStr(cTexto,074,02)+"/"+SubStr(cTexto,076,04))
						      PBC->PBC_TIPO   	:= "C"
						      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
						      PBC->PBC_VLBRUT 	:= Val(SubStr(cTexto,028,15))/100 * Iif(cSinal == "-",-1,1)
					         PBC->PBC_TOTCOM 	:= Val(SubStr(cTexto,028,15))/100
					         PBC->PBC_VLDESC 	:= 0.00
					         PBC->PBC_VLLIQ  	:= Val(SubStr(cTexto,028,15))/100 * Iif(cSinal == "-",-1,1)
					         PBC->PBC_CHVLLQ 	:= StrZero((PBC->PBC_VLBRUT - PBC->PBC_VLDESC)*100,17)
						      PBC->PBC_CAPTUR 	:= ""
						      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
						      PBC->PBC_DESCRI 	:= "Ajuste RV "+PAB->PAB_ADM+Alltrim(Substr(cTexto,64,8))
								PBC->PBC_TPCART 	:= PBB->PBB_TPCART
					         PBC->PBC_TPOPER 	:= cOper
					         PBC->PBC_PRODUT 	:= cProduto
					         PBC->PBC_IDPBC  	:= cIdentPBC     
					         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
					         PBC->PBC_ESTAB	 	:= PBB->PBB_ESTAB
								//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
						      //Ё mente o valor das parcelas para gravar no SE1.                Ё
								//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
								If PBC->(FieldPos('PBC_DESCTO')) >0
						         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
						      Endif 
							Endif
					      MsUnlock()
							DbCommit()
					      aTotProc[2]++
					  	Endif
					Next nY 
					DbSelectArea("PBB")
					MsUnlockAll()
					DbCommitAll()
					DbSelectArea("PBC")
					MsUnlockAll()
					DbCommitAll()
				Endif
//			Else
//				GravaLog(Alltrim(cArquivo),"Liberacao para agenda financeira", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" - parcela "+cParcela+"/"+cTotParcs+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao.")
				nTotNProc++
			Endif			
		Next nX
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV := {}
	   aRegCV := {}
	Endif

	DbSelectArea("TRB")
EndDo

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Finaliza Controle de Transacao               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//End Transaction

Return(.t.)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    ЁImpTecBan Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados do cartao TecBan                           Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpTecBan(cArquivo, cAdm)            

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de variaveis                                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local dCredito 	:= CTOD("")
Local cProduto 	:= ""
Local cSituaca 	:= ""
Local cSinal   	:= ""
Local cRvAtu   	:= ""
Local nVlrBrut 	:= 0.00
Local nVlrLiq  	:= 0.00
Local nVlrDesc 	:= 0.00
Local nVlrReje 	:= 0.00
Local cChVlLq  	:= ""
Local nTaxa			:= 0.00
Local nTotRegs		:= 0
Local nTotParcs	:= 0
Local cAdm			:= "TB"
Local cRvAnt		:= ""
Local aMaqs			:= {}
Local aResumo		:= {}
Local aRegRV		:= {}
Local aRegCV		:= {}
Local nRetExec		:= 0
Local lTemLog		:= .F.
Local cTotParcs	:= ""
Local cParcela		:= ""
Local nX				:= 0
Local nY				:= 0
Local nZ				:= 0
Local nW				:= 0
Local cTexto		:= ""
Local cIdent		:= "000000000000000"
Local cIdentPBC	:= "00000000000000000000"
Local nRegProv		:= 0
Local nRegLiq		:= 0
Local cMot        :=""   //Rodrigo 31/03/05
//Local lAju        :=.F.  //Rodrigo 31/03/05

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a TecBan                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If SubStr(TRB->TEXTO,01,01) == "A0"
   U_Aviso("O arquivo que esta sendo importado nao esta no formato correto ou esta corrompido ou nao pertence a operadora TECBAN. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se a operadora esta cadastrada                                Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("SAE")
DbSetOrder(1)
If !DbSeek(xFilial("SAE")+cAdm,.F.)
	U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora VISANET no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo CX",{"Ok"},,"Atencao:")
	Return
Endif

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !Left(TRB->TEXTO,2) $ "C1"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	IF !DbSeek(xFilial("PAB")+cAdm+Space(1)+SubStr(TRB->TEXTO,3,15),.f.)
   	If aScan(aMaqs, cAdm+SubStr(TRB->TEXTO,3,15)) == 0
			GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+SubStr(TRB->TEXTO,3,15)+" da administradora TECBAN nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
			Aadd(aMaqs, cAdm+SubStr(TRB->TEXTO,4,15))
			nTotNProc++
		Endif                                                  
		lTemLog := .T.
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Gera os resumos de venda virtuais                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
DbSetOrder(0)
dbGotop()        
nTotRegs := RecCount()
cRvAtu	:= "000000000"
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   /*
   If !Left(TRB->TEXTO,2) $ "C1/C2"
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf
   */
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Exclui os registros de transacao pendente										Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,2) $ "C1" .and. (Substr(TRB->TEXTO,37,1) $ "2/4" .or. !Substr(TRB->TEXTO,38,1) $ "1")
   	DbSelectArea("TRB")
   	RecLock("TRB",.F.)
   	DbDelete()       
   	MsUnlock()
   	DbSkip()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Exclui o complemento do registro           										Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   	DbSelectArea("TRB")
   	RecLock("TRB",.F.)
   	DbDelete()
   	MsUnlock()
   	DbSkip()
		Loop
	Endif
	If !Left(TRB->TEXTO,2) $ "C1/C2"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Exclui o complemento do registro           										Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   	DbSelectArea("TRB")
   	RecLock("TRB",.F.)
   	DbDelete()
   	MsUnlock()
   	DbSkip()
		Loop
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a maquineta esta cadastrada											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	DbSeek(xFilial("PAB")+cAdm+Space(1)+SubStr(TRB->TEXTO,3,15),.f.)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se eh ajuste                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cOper := Substr(TRB->TEXTO,39,6)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se ja existe um resumo para essa loja/dia							Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	dEmissao 	:= CTOD(Substr(TRB->TEXTO,26,2)+"/"+Substr(TRB->TEXTO,24,2)+"/"+Iif(Month(dDataBase) == 1 .and. Val(Substr(TRB->TEXTO,24,2)) == 12, Alltrim(Str(Year(dDatabase)-1)), Alltrim(Str(Year(dDatabase)))))
//	nPosArray 	:= Ascan(aResumo,{|x| Alltrim(x[1]) == Alltrim(SubStr(TRB->TEXTO,3,15)) .and. x[2] == dEmissao}) Rodrigo 04/04/05
	nPosArray 	:= Ascan(aResumo,{|x| Alltrim(x[1]) == Alltrim(SubStr(TRB->TEXTO,3,15)) .and. x[2] == dEmissao .and. x[3] == cOper})
	If nPosArray == 0
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Retorna o proximo numero de RV sequencial         							Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		cRvAtu := RetNrvTB(cRvAtu)													  					   
		Aadd(aResumo, {	Alltrim(SubStr(TRB->TEXTO,3,15)),;
							   dEmissao,;
                			cOper,;
                			cRvAtu})//Rodrigo 04/04/05
  		nPosArray := Len(aResumo)
  	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Atualiza o arquivo texto                											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If Left(TRB->TEXTO,2) $ "C1"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		DbSelectArea("TRB")
		RecLock("TRB",.F.)
//		TRB->RV	 	:= "T"+aResumo[nPosArray,3]+aResumo[nPosArray,1]+DTOS(aResumo[nPosArray,2]) Rodrigo 04/04/05
		TRB->RV	 	:= "T"+aResumo[nPosArray,4]+aResumo[nPosArray,1]+DTOS(aResumo[nPosArray,2])+aResumo[nPosArray,3]
		MsUnlock()
		DbSelectArea("TRB")
		DbSkip()
		RecLock("TRB",.F.)
//		TRB->RV	 	:= "T"+aResumo[nPosArray,3]+aResumo[nPosArray,1]+DTOS(aResumo[nPosArray,2]) Rodrigo 04/04/05
		TRB->RV	 	:= "T"+aResumo[nPosArray,4]+aResumo[nPosArray,1]+DTOS(aResumo[nPosArray,2])+aResumo[nPosArray,3]
		MsUnlock()
	Endif
	DbSelectArea("TRB")
	DbSkip()
Enddo

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
DbSetOrder(1)
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora o registro trailler                                             Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If !Left(TRB->TEXTO,2) $ "C1/C2" .or. Empty(TRB->RV)
   	DbSelectArea("TRB")
      DbSkip()
      Loop
   EndIf

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a maquineta esta cadastrada											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PAB")
	DbSetOrder(2)
	DbSeek(xFilial("PAB")+cAdm+Space(1)+SubStr(TRB->TEXTO,3,15),.f.)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava dados nos arrays                  											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If TRB->RV <> cRvAnt .and. Left(TRB->TEXTO,2) == "C1" //Rodrigo 04/04/05 
//   If TRB->RV <> cRvAnt .and. Left(TRB->TEXTO,2) == "C1" .Or. lAju ==.T.
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegRV, {TRB->TEXTO, TRB->(Recno()), TRB->RV})
		cRvAnt 	:= TRB->RV
	Endif               
   If TRB->RV == cRvAnt .and. Left(TRB->TEXTO,2) == "C1"
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava no array o RV				     													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		Aadd(aRegCV, {TRB->TEXTO, TRB->(Recno())})
		cRvAnt := TRB->RV
		DbSelectArea("TRB")
		DbSkip()
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Grava o complemento do CV		   													Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
		aRegCV[Len(aRegCV),1] :=  Substr(aRegCV[Len(aRegCV),1],1,80) + Substr(TRB->TEXTO,1,80)
		cRvAnt := TRB->RV
		DbSelectArea("TRB")
		DbSkip()
	Endif               
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Processa a geracao dos registros        											Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (TRB->RV <> cRvAnt .or. TRB->(EOF())) .and. Len(aRegRV) > 0
		For nX := 1 to Len(aRegRV)
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Alimenta variavel de uso          													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
			cTexto := aRegRV[nX,1]

			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Inicializa variaveis de trabalho													Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			dEmissao 	:= CTOD(Substr(cTexto,26,2)+"/"+Substr(cTexto,24,2)+"/"+Iif(Month(dDataBase) == 1 .and. Val(Substr(cTexto,24,2)) == 12, Alltrim(Str(Year(dDatabase)-1)), Alltrim(Str(Year(dDatabase)))))
		   dCredito 	:= CTOD(Substr(cTexto,26,2)+"/"+Substr(cTexto,24,2)+"/"+Iif(Month(dDataBase) == 1 .and. Val(Substr(cTexto,24,2)) == 12, Alltrim(Str(Year(dDatabase)-1)), Alltrim(Str(Year(dDatabase)))))
		   dCredOri 	:= CTOD(Substr(cTexto,26,2)+"/"+Substr(cTexto,24,2)+"/"+Iif(Month(dDataBase) == 1 .and. Val(Substr(cTexto,24,2)) == 12, Alltrim(Str(Year(dDatabase)-1)), Alltrim(Str(Year(dDatabase))))		   )
		   cProduto 	:= ""
		   cSituaca 	:= ""
			cParcela 	:= "01"
			cTotParcs	:= "01"
		   cSinal   	:= "+"
		   cRvAtu   	:= Substr(aRegRV[nX,3],1,10)
         nVlrBrut 	:= 0.00
         nVlrLiq  	:= 0.00
         nVlrDesc 	:= 0.00
         nVlrReje 	:= 0.00
         cChVlLq		:= ""
//        cOper		:= "P" Rodrigo 31/03/05
			cOper       := Iif(Substr(cTexto,39,6)=="200020","A", "P")
				
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Grava a liquidacao                        										Ё
			//Ё Somente grava se o resumo nao existir   											Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	      DbSelectArea("PBB")
	      DbSetOrder(1)
			If DbSeek(xFilial("PBB")+cAdm+SubStr(cTexto,3,15)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper,.F.)
		      aTotProc[3]++
				GravaLog(Alltrim(cArquivo), "Resumo ja existente", "Linha "+StrZero(aRegRV[nX,2],6)+": R.V. "+Alltrim(cRvAtu)+" da adm. "+Alltrim(cAdm)+" no valor de R$ "+Alltrim(Transform(nVlrBrut,"@E 9,999,999.99"))+" ignorado no processo de importacao pois o mesmo jА existe. Chave de localizacao: "+cAdm+SubStr(cTexto,2,10)+cRvAtu+DtoS(dCredito)+cParcela+cTotParcs+cOper+cChVlLq)
		 	Else
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Atualiza as variaveis com os valores informados								Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,3,15)),"PAB_LOJA")
	         RecLock("PBB",.T.)
				cIdent 	:= StrZero(Recno(),15)
	
	         PBB->PBB_FILIAL 	:= xFilial("PBB")
	         PBB->PBB_CODADM 	:= cAdm
	         PBB->PBB_CODMAQ 	:= SubStr(cTexto,3,15)
	         PBB->PBB_NRV    	:= cRvAtu
//	         PBB->PBB_VLBRUT 	:= nVlrBrut //* If(SubStr(cTexto,57,1)=="+",1,-1) Rodrigo 04/04/05
//	         PBB->PBB_VLLIQ  	:= nVlrLiq  //* If(SubStr(cTexto,57,1)=="+",1,-1)
//	         PBB->PBB_VLDESC 	:= nVlrDesc //* If(SubStr(cTexto,57,1)=="+",1,-1)
//	         PBB->PBB_VLREJE 	:= nVlrReje //* If(SubStr(cTexto,57,1)=="+",1,-1)
	         PBB->PBB_VLBRUT 	:= Iif(cOper=="A", nVlrBrut*(-1),nVlrBrut)  
	         PBB->PBB_VLLIQ  	:= Iif(cOper=="A", nVlrBrut*(-1),nVlrBrut)
	         PBB->PBB_VLDESC 	:= Iif(cOper=="A", 0,nVlrDesc)
	         PBB->PBB_VLREJE 	:= Iif(cOper=="A", 0,nVlrReje)
	         PBB->PBB_CHVLLQ 	:= cChVlLq
	         PBB->PBB_EMISS  	:= dEmissao
	         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
	         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
	         PBB->PBB_ARQUIV 	:= cArquivo
	         PBB->PBB_CREDIT 	:= dEmissao+1  
	         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
	         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
	         PBB->PBB_SITUAC 	:= cSituaca
	         PBB->PBB_TPCART 	:= "D"
	         PBB->PBB_TPOPER 	:= cOper
	         PBB->PBB_IDENT  	:= cIdent
	         PBB->PBB_ESTAB		:= cDescEst
				PBB->PBB_IDPA5		:=	cChavePA5
				//Rodrigo 31/03/05
				If cOper =="A"
					PBB->PBB_DTAJU :=dEmissao+1
					PBB->PBB_MOT   :="TAJ101"
				EndIf
				
				nRecProv := PBB->(Recno())
	         MsUnlock()
				DbCommit()
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Gera o registro de liquidacao para vendas a debito                     Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If cOper == "P"
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,3,15)),"PAB_LOJA")	
		         RecLock("PBB",.T.)
					cIdent 	:= StrZero(Recno(),15)

		         PBB->PBB_FILIAL 	:= xFilial("PBB")
		         PBB->PBB_CODADM 	:= cAdm
		         PBB->PBB_CODMAQ 	:= SubStr(cTexto,3,15)
		         PBB->PBB_NRV    	:= cRvAtu
		         PBB->PBB_VLBRUT 	:= nVlrBrut //* If(SubStr(cTexto,57,1)=="+",1,-1)
		         PBB->PBB_VLLIQ  	:= nVlrLiq  //* If(SubStr(cTexto,57,1)=="+",1,-1)
		         PBB->PBB_VLDESC 	:= nVlrDesc //* If(SubStr(cTexto,57,1)=="+",1,-1)
		         PBB->PBB_VLREJE 	:= nVlrReje //* If(SubStr(cTexto,57,1)=="+",1,-1)
		         PBB->PBB_CHVLLQ 	:= cChVlLq
		         PBB->PBB_EMISS  	:= dEmissao
		         PBB->PBB_IMPORT 	:= CriaVar("PBB_IMPORT")
		         PBB->PBB_USUARI 	:= CriaVar("PBB_USUARI")
		         PBB->PBB_ARQUIV 	:= cArquivo
	         	PBB->PBB_CREDIT 	:= DataValida(dEmissao+1) //Rodrigo 27/01/05
		         PBB->PBB_PARCEL 	:= Iif(Empty(cParcela) .or. cParcela == "00","01",cParcela)
		         PBB->PBB_TOTPAR 	:= Iif(Empty(cTotParcs) .or. cTotParcs == "00","01",cTotParcs)
		         PBB->PBB_SITUAC 	:= cSituaca
		         PBB->PBB_TPCART 	:= "D"
		         PBB->PBB_TPOPER 	:= "L"
		         PBB->PBB_IDENT  	:= cIdent
		         PBB->PBB_ESTAB		:= cDescEst
  					PBB->PBB_IDPA5		:=	cChavePA5
					nRecLiq := PBB->(Recno())
		         MsUnlock()
					DbCommit()
   			Endif

		      aTotProc[1]++
		      
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Grava os CVs se existirem                         							Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				For nY := 1 to Len(aRegCV)
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza as variaveis com os valores informados								Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Alimenta variavel de uso          													Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
					cTexto 		:= aRegCV[nY,1]
				   cSinal   	:= "+"
					cCartao		:= Substr(cTexto,56,19)
					If Substr(cCartao,17,3) == "000"
						cCartao := Substr(cCartao,1,16)
					Endif
				   cRvAtu   	:= PAB->PAB_ADM+Left(SubStr(cTexto,12,7),10)

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Posiciona no PBB de Provisao                            					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					DbSelectArea("PBB")
					DbGoTo(nRecProv)
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava o arquivo de comprovantes de venda                					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			      DbSelectArea("PBC")
			      DbSetOrder(1) 
			      cDescEst	:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,3,15)),"PAB_LOJA")
	   	      RecLock("PBC",.T.)
					cIdentPBC	:= StrZero(Recno(),20)

		         PBC->PBC_FILIAL 	:= xFilial("PBC")
		         PBC->PBC_CODADM 	:= cAdm
		         PBC->PBC_CODMAQ 	:= SubStr(cTexto,3,15)
		         PBC->PBC_NRV    	:= PBB->PBB_NRV
		         PBC->PBC_CARTAO 	:= cCartao
		         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
		         PBC->PBC_NCV    	:= Alltrim(Str(Val(SubStr(cTexto,18,6))))
		         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
		         PBC->PBC_PARCEL 	:= "01"
		         PBC->PBC_TOTPAR 	:= "01"
			      PBC->PBC_EMISS  	:= PBB->PBB_EMISS
			      PBC->PBC_TIPO   	:= "D"
			      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
			      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,45,11))/100)
//		         PBC->PBC_VLDESC 	:= Abs(Val(SubStr(cTexto,80+62,6))/100) Rodrigo 04/04/05
		         PBC->PBC_VLDESC 	:= Iif(PBB->PBB_TPOPER=="A", 0 ,Abs(Val(SubStr(cTexto,80+62,6))/100))
		         PBC->PBC_VLLIQ  	:= Abs(PBC->PBC_VLBRUT - PBC->PBC_VLDESC)
		         PBC->PBC_CHVLLQ 	:= StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
		         PBC->PBC_TOTCOM 	:= PBC->PBC_VLBRUT
			      PBC->PBC_CAPTUR 	:= ""
			      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
			      PBC->PBC_DESCRI 	:= "Venda"
					PBC->PBC_TPCART 	:= "D"
		         PBC->PBC_TPOPER 	:= PBB->PBB_TPOPER
		         PBC->PBC_PRODUT 	:= ""
		         PBC->PBC_IDPBC  	:= cIdentPBC     
		         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
		         PBC->PBC_ESTAB	 	:= cDescEst
					//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
			      //Ё mente o valor das parcelas para gravar no SE1.                Ё
					//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If PBC->(FieldPos('PBC_DESCTO')) >0
			         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
			      Endif 
      			MsUnlock()
					DbCommit()
      			
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Atualiza o PBB                                     							Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If nRecProv > 0
						DbSelectArea("PBB")
						DbGoTo(nRecProv)
						RecLock("PBB",.F.)
//			         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT Rodrigo 04/04/05
//			         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
//			         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
//			         PBB->PBB_VLREJE 	:= 0.00
			         PBB->PBB_VLBRUT 	+= Iif (PBC->PBC_TPOPER=="A", PBC->PBC_VLBRUT *(-1), PBC->PBC_VLBRUT)
			         PBB->PBB_VLLIQ  	+= Iif (PBC->PBC_TPOPER=="A", PBC->PBC_VLLIQ  *(-1), PBC->PBC_VLLIQ)
			         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
			         PBB->PBB_VLREJE 	:= 0.00
			         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
			         MsUnlock()
						DbCommit()
			   	Endif

					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Grava a liquidacao para as vendas a debito              					Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If cOper == "P"
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Posiciona no PBB de Provisao                            					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						DbSelectArea("PBB")
						DbGoTo(nRecLiq)

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza as variaveis com os valores informados								Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Grava o arquivo de comprovantes de venda                					Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				      DbSelectArea("PBC")
				      DbSetOrder(1)
						cDescEst		:=	Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+Alltrim(SubStr(cTexto,3,15)),"PAB_LOJA")

		   	      RecLock("PBC",.T.)
						cIdentPBC	:= StrZero(Recno(),20)
			         PBC->PBC_FILIAL 	:= xFilial("PBC")
			         PBC->PBC_CODADM 	:= cAdm
			         PBC->PBC_CODMAQ 	:= SubStr(cTexto,3,15)
			         PBC->PBC_NRV    	:= PBB->PBB_NRV
			         PBC->PBC_CARTAO 	:= cCartao
			         PBC->PBC_CART1  	:= SubStr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
			         PBC->PBC_NCV    	:= Alltrim(Str(Val(SubStr(cTexto,18,6))))
			         PBC->PBC_NCV    	:= Iif(Len(Alltrim(PBC->PBC_NCV))==5,"0"+Alltrim(PBC->PBC_NCV),Alltrim(PBC->PBC_NCV))
			         PBC->PBC_PARCEL 	:= "01"
			         PBC->PBC_TOTPAR 	:= "01"
				      PBC->PBC_EMISS  	:= PBB->PBB_EMISS
				      PBC->PBC_TIPO   	:= "D"
				      PBC->PBC_CREDIT 	:= PBB->PBB_CREDIT
				      PBC->PBC_VLBRUT 	:= Abs(Val(SubStr(cTexto,45,11))/100)
			         PBC->PBC_VLDESC 	:= Abs(Val(SubStr(cTexto,80+62,6))/100)
			         PBC->PBC_VLLIQ  	:= Abs(PBC->PBC_VLBRUT - PBC->PBC_VLDESC)
			         PBC->PBC_CHVLLQ 	:= StrZero(Abs((PBC->PBC_VLBRUT - PBC->PBC_VLDESC))*100,17)
			         PBC->PBC_TOTCOM 	:= PBC->PBC_VLBRUT
				      PBC->PBC_CAPTUR 	:= ""
				      PBC->PBC_SITUAC 	:= PBB->PBB_SITUAC
				      PBC->PBC_DESCRI 	:= "Liquidacao"
						PBC->PBC_TPCART 	:= "D"
			         PBC->PBC_TPOPER 	:= PBB->PBB_TPOPER
			         PBC->PBC_PRODUT 	:= ""
			         PBC->PBC_IDPBC  	:= cIdentPBC     
			         PBC->PBC_IDENT  	:= PBB->PBB_IDENT
			         PBC->PBC_ESTAB	 	:= cDescEst
						//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Gravar o desconto total no PBC, para poder determinar correta-Ё
				      //Ё mente o valor das parcelas para gravar no SE1.                Ё
						//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If PBC->(FieldPos('PBC_DESCTO')) >0
				         PBC->PBC_DESCTO := Abs(PBC->PBC_VLDESC)
				      Endif 
	      			MsUnlock()
						DbCommit()
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Atualiza o PBB                                     							Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If nRecLiq > 0
							DbSelectArea("PBB")
							DbGoTo(nRecLiq)
							RecLock("PBB",.F.)
				         PBB->PBB_VLBRUT 	+= PBC->PBC_VLBRUT
				         PBB->PBB_VLLIQ  	+= PBC->PBC_VLLIQ
				         PBB->PBB_VLDESC 	+= PBC->PBC_VLDESC
				         PBB->PBB_VLREJE 	:= 0.00
				         PBB->PBB_CHVLLQ 	:= StrZero(PBC->PBC_VLLIQ*100,17)
				         MsUnlock()
							DbCommit()
				   	Endif
					Endif
					dbSelectArea("PBC")
		       	MsUnlock()
					MsUnlockAll()
					DbCommitAll()
			      aTotProc[2]++
				Next nY 
				DbSelectArea("PBB")
				MsUnlockAll()
				DbCommitAll()
				DbSelectArea("PBC")
				MsUnlockAll()
				DbCommitAll()
			Endif
		Next nX
	
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Reinicializa os array com os registros  											Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	   aRegRV := {}
	   aRegCV := {}
	Endif
		
	DbSelectArea("TRB")
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
╠╠ЁFun┤┘o    Ё ImpSitef Ё Autor Ё Jaime Wikanski        Ё Data Ё          Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁImporta os dados da movimentacao do SITEF                   Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function ImpSitef(cArquivo)            

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
Local dDtTran		:= CTOD("")
Local aMaqs			:= {}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Adiciona no array as administradoras                                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Aadd(aAdm, {"VISANET"		,"CX"})
Aadd(aAdm, {"VISA"		   ,"CX"}) //Rodrigo 30/03/05
Aadd(aAdm, {"ELECTRON"		,"CX"}) //Rodrigo 30/03/05
Aadd(aAdm, {"MASTERCARD"	,"CE"})
Aadd(aAdm, {"AMEX"			,"CA"})
Aadd(aAdm, {"BCO24HORAS"	,"TB"})
Aadd(aAdm, {"DINERS"			,"CE"})
Aadd(aAdm, {"DINERS CLUB"	,"CE"})//Rodrigo 30/03/05
Aadd(aAdm, {"REDESHOP"		,"CE"})

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida se o arquivo pertence a VISA                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()
If SubStr(TRB->TEXTO,01,08) <> "00000000"
	U_Aviso("Inconsistencia","O arquivo "+Alltrim(cArquivo)+" nao e originario do SITEF. Esse arquivo serА ignorado.",{"Ok"},,"Atencao:")
	Return(.f.)
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicia Controle de Transacao                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддды
//Begin Transaction

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Valida primeiro se os registros estao corretos                         Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Validando registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora cartao C&C                                                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//	If Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";"))) == "CLUB" Rodrigo 01/04/05 
	If Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";"))) $ "CLUB/CLUB CARD" 
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a administradora existe no array                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nPosArr := Ascan(aAdm,{|x| Alltrim(x[1]) == UPPER(Alltrim(RetCpoCart(TRB->TEXTO,15,";")))})//Rodrigo 30/03/05	
	If nPosArr == 0
   	If aScan(aAdmLog, Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";")))) == 0
			GravaLog(Alltrim(cArquivo),"Operadora Inexistente","Operadora "+RetCpoCart(TRB->TEXTO,15,";")+" nao identificada.")
			Aadd(aAdmLog, Alltrim(RetCpoCart(TRB->TEXTO,15,";")))
			nTotNProc++
			lTemLog := .T.
		Endif             
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif               
	cAdm := aAdm[nPosArr,2]
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a operadora esta cadastrada                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("SAE")
	DbSetOrder(1)
	If !DbSeek(xFilial("SAE")+cAdm,.F.)
		U_Aviso("Inconsistencia","Nao foi possivel localizar a administradora "+aAdm[nPosArr,1]+" no cadastro de Administradoras Financeiras. A mesma deve estar cadastrada com o cСdigo "+aAdm[nPosArr,2],{"Ok"},,"Atencao:")
		Return(.F.)
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Posiciona no cadastro de estabelecimentos                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If cAdm == "CE"
//		cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),9,7) Rodrigo 29/03/05
		cEstab := Substr(Alltrim(Str(Val(RetCpoCart(TRB->TEXTO,2,";")))),9,7)
		DbSelectArea("PAB")
		DbSetOrder(2)
		If !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
			cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),8,8)
			If !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
		   	If aScan(aMaqs, cAdm+cEstab) == 0
					GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+cEstab+" da administradora "+Alltrim(SAE->AE_DESC)+" nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
					Aadd(aMaqs, cAdm+cEstab)
					nTotNProc++
				Endif
				lTemLog := .T.
			Endif                                                  
		Endif
	Else
		If Alltrim(cAdm) = "TB"
			cEstab := Alltrim(RetCpoCart(TRB->TEXTO,2,";"))
		ElseIf Len(Alltrim(RetCpoCart(TRB->TEXTO,2,";"))) == 15
			cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),2,10)
		Else
			cEstab := Alltrim(RetCpoCart(TRB->TEXTO,2,";"))
		Endif
		DbSelectArea("PAB")
		DbSetOrder(2)
		If !DbSeek(xFilial("PAB")+cAdm+Space(1)+cEstab,.f.)
	   	If aScan(aMaqs, cAdm+cEstab) == 0
				GravaLog(Alltrim(cArquivo),"Estabelecimento nao localizado", "Estabelecimento "+cEstab+" da administradora "+Alltrim(SAE->AE_DESC)+" nao localizada. Cadastre o Estabelecimento no Cadastro de Estabelecimentos e reprocesse a importacao do arquivo.")
				Aadd(aMaqs, cAdm+cEstab)
				nTotNProc++
			Endif
			lTemLog := .T.
		Endif
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
Enddo
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Grava o Logs se encontrou alguma inconsistencia                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lTemLog
	Return(.F.)
Endif   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processa a importacao                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DbSelectArea("TRB")
dbGotop()        
nTotRegs := RecCount()
ProcRegua(nTotRegs)
While !Eof()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Incrementa a regua de processamento                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   IncProc("Processamento registro "+Alltrim(Str(TRB->(Recno())))+" de "+Alltrim(Str(nTotRegs))+"...")
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Ignora cartao C&C                                                      Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//	If Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";"))) == "CLUB" .or. Upper(Alltrim(RetCpoCart(TRB->TEXTO,5,";"))) == "RESUMOVD"  Rodrigo 30/09/04
//	If Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";"))) == "CLUB" .or. Upper(Alltrim(RetCpoCart(TRB->TEXTO,7,";"))) == "RESUMOVD"  Rodrigo 01/04/05
	If Upper(Alltrim(RetCpoCart(TRB->TEXTO,15,";"))) $ "CLUB/CLUB CARD" .or. Upper(Alltrim(RetCpoCart(TRB->TEXTO,7,";"))) == "RESUMOVD" 

		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Alimenta variavel de uso          													Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
	cTexto 		:= TRB->TEXTO
	//cEstab		:= PADR(Alltrim(RetCpoCart(cTexto,2,";")),15)
	cNsuSit		:= PADR(Alltrim(RetCpoCart(cTexto,3,";")),6)
	cNsu			:= PADR(Alltrim(RetCpoCart(cTexto,5,";")),9)
	cCartao		:= PADR(Alltrim(RetCpoCart(cTexto,11,";")),19)
//	cEstado		:= Iif(Alltrim(RetCpoCart(cTexto,6,";")) == "EFETUADA","E","N")
	cEstado		:= Iif(Alltrim(RetCpoCart(cTexto,6,";"))$"EFET/EFETUADA","E","N")
	dDtTran		:= CTOD(RetCpoCart(cTexto,9,";")+"/"+Alltrim(Str(Year(dDataBase))))
	       
	If cEstado = "N"
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se a administradora existe no array                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nPosArr 	:= Ascan(aAdm,{|x| Alltrim(x[1]) == Upper(Alltrim(RetCpoCart(cTexto,15,";")))})	
	cAdm 		:= PADR(aAdm[nPosArr,2],3)
	cAdm		:= Iif(Substr(cCartao,1,5) == "53104" .and. cAdm == "CE", "CC", cAdm)
	cNsu		:= Iif(Alltrim(cAdm) $ "CE/CC/TB", Alltrim(Str(Val(cNsu))),cNsu)

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Retorna o estabelecimento                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Alltrim(cAdm) == "CE"
		cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),9,7)
		DbSelectArea("PAB")
		DbSetOrder(2)
		If !DbSeek(xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,.f.)
			cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),8,8)
		Endif
	Else
		If Alltrim(cAdm) = "TB"
			cEstab := Alltrim(RetCpoCart(TRB->TEXTO,2,";"))
		ElseIf Len(Alltrim(RetCpoCart(TRB->TEXTO,2,";"))) == 15
			cEstab := Substr(Alltrim(RetCpoCart(TRB->TEXTO,2,";")),2,10)
		Else
			cEstab := Alltrim(RetCpoCart(TRB->TEXTO,2,";"))
		Endif
	Endif

	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se houve cancelamento            										Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If Substr(Alltrim(RetCpoCart(cTexto,7,";")),1,4) == "CANC"
		DbSelectArea("PBD")
		DbSetOrder(9)	//PBD_FILIAL+PBD_ADM+PBD_ESTAB+PBD_CARTAO+PBD_PDV+DTOS(PBD_DTTRAN)+PBD_TOTPAR+Str(PBD_VLCOM,13,2)
		DbSeek(xFilial("PBD")+cAdm+PADR(cEstab,15)+cCartao+PADR(ALLTRIM(RetCpoCart(cTexto,4,";")),8)+DTOS(dDtTran)+PADR(ALLTRIM(RetCpoCart(cTexto,13,";")),2),.F.)
		While !EOF() .and. PBD->(PBD_FILIAL+PBD_ADM+PBD_ESTAB+PBD_CARTAO+PBD_PDV+DTOS(PBD_DTTRAN)+PBD_TOTPAR) == xFilial("PBD")+cAdm+PADR(cEstab,15)+cCartao+PADR(ALLTRIM(RetCpoCart(cTexto,4,";")),8)+DTOS(dDtTran)+PADR(ALLTRIM(RetCpoCart(cTexto,13,";")),2)
			If PBD->PBD_VLCOM == Val(StrTran(StrTran(RetCpoCart(cTexto,12,";"),",",""),".",""))/100
				DbSelectArea("PBD")
				RecLock("PBD",.F.)
				DbDelete()
				MsUnlock()
		      aTotProc[1]--
				Exit
			Endif  
			DbSelectArea("PBD")
			DbSkip()
		Enddo
		DbSelectArea("TRB")
		DbSkip()
		Loop
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Grava as movimentacoes do SITEF           										Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	DbSelectArea("PBD")
 	DbSetOrder(1)
	If DbSeek(xFilial("PBD")+cAdm+PADR(cEstab,15)+cNsuSit+cNsu+cCartao+cEstado+DTOS(dDtTran),.F.)
      aTotProc[3]++
 	Else
  		RecLock("PBD",.T.)
    	PBD->PBD_FILIAL 	:= xFilial("PBD")
		PBD->PBD_ADM   	:= Iif(Alltrim(cAdm) == "CE" .and. Substr(cCartao,1,5) == '53104','CC', cAdm)
		PBD->PBD_ESTAB 	:= cEstab
		PBD->PBD_NSUSIT	:= cNsuSit
		PBD->PBD_PDV   	:= Alltrim(RetCpoCart(cTexto,4,";"))
	//		PBD->PBD_NSU   	:= cNsu Rodrigo 30/09/04
		PBD->PBD_NSU   	:= Iif(Len(Alltrim(cNsu))==5,"0"+Alltrim(cNsu),Alltrim(cNsu))
		PBD->PBD_ESTADO	:= cEstado
		PBD->PBD_CODTRA	:= Alltrim(RetCpoCart(cTexto,7,";"))
		PBD->PBD_CODRES	:= Alltrim(RetCpoCart(cTexto,8,";"))
		PBD->PBD_DTTRAN	:= dDtTran
		PBD->PBD_HRTRAN	:= Alltrim(RetCpoCart(cTexto,10,";"))
		PBD->PBD_CARTAO	:= cCartao
  		PBD->PBD_CART1  	:= Substr(cCartao,1,6)+Repl("*",Len(Alltrim(cCartao))-10)+SubStr(Alltrim(cCartao),Len(Alltrim(cCartao))-3,4)
		PBD->PBD_VLCOM 	:= Val(StrTran(StrTran(RetCpoCart(cTexto,12,";"),",",""),".",""))/100
		PBD->PBD_TOTPAR	:= Alltrim(RetCpoCart(cTexto,13,";"))
		PBD->PBD_CODAUT	:= Alltrim(RetCpoCart(cTexto,14,";"))
		PBD->PBD_NRCANC  	:= Alltrim(RetCpoCart(cTexto,17,";"))
     	PBD->PBD_ARQUIV 	:= cArquivo
      PBD->PBD_CODEST 	:= Posicione("PAB",2,xFilial("PAB")+Alltrim(cAdm)+Space(1)+cEstab,"PAB_LOJA")
     	MsUnlock()
      aTotProc[1]++
	Endif	      
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
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial() +"ZR")
		RecLock("SX5",.F.)
		_cIdent         :=	SOMA1(SX5->X5_DESCRI,15,.F.)
		SX5->X5_DESCRI  :=	_cIdent 
	   MsUnLock()
	Else	
		RecLock("SX5",.T.)
	      _cIdent           := "000000000000001"   
	     	SX5->X5_FILIAL  := xFilial("SX5")
	     	SX5->X5_TABELA  := "ZR"
	     	SX5->X5_CHAVE   := "000001"
	     	SX5->X5_DESCRI  :=_cIdent
	  	MsUnLock()
	EndIf
	DbSelectArea("PBB")
	DbSetOrder(5)
	While DbSeek(xFilial("PBB")+cIdent,.F.)
		cIdent := Soma1(cIdent,15)
	Enddo
Endif
Return cIdent

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
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial() +"ZS")
		RecLock("SX5",.F.)
			cIdentPBC       := SOMA1(SX5->X5_DESCRI,20,.F.)
			SX5->X5_DESCRI  := cIdentPBC 
	    MsUnLock()
	Else	
		RecLock("SX5",.T.)
	      cIdentPBC       := "00000000000000000001"   
	     	SX5->X5_FILIAL  := xFilial("SX5")
	     	SX5->X5_TABELA  := "ZS"
	     	SX5->X5_CHAVE   := "000001"
	     	SX5->X5_DESCRI  :=cIdentPBC
	  	MsUnLock()
	EndIf

	DbSelectArea("PBC")
	DbSetOrder(9)
	While DbSeek(xFilial("PBC")+cIdentPBC,.F.)
		cIdentPBC := Soma1(cIdentPBC,20)
	Enddo
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
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Fun┤└o    ЁValidPerg ╨ Autor Ё                    ╨ Data Ё             ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descri┤└o Ё Verifica a existencia das perguntas criando-as caso seja   ╨╠╠
╠╠╨          Ё necessario (caso nao existam).                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function ValidPerg(cPerg)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aArea  	:= GetArea()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

Aadd(aRegs,{cPerg,"01","Administradora     ?","mv_ch1","N",01,0,0,"C","","mv_par01","Visanet" ,"","","Amex","","","Redecard","","","TecBan","","","Sitef","","","","","","",""})

For i := 1 To Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
   EndIf
Next

RestArea(aArea)

Return


Static Function AppendVisa(cArquivo)
Local nHdl		:=	Fopen(cArquivo)
Local nBytes	:=	252 //250 Chars + CHR(13)+CHR(10)
Local cTexto	:=	''
Local nRead		:=	1
Local nRegs		:=	Int(FSeek(nHdl,0,2)/252)
ProcRegua(nRegs)
FSeek(nHdl,0,0)
nRead		:=	FREAD(nHdl, @cTexto, nBytes)
While nRead >0
	IncProc()
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica se eh liquidacao ou Provisao ou Ajuste								Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды                    	
	If Substr(cTexto,1,1)$'09'
		RecLock('TRB',.T.)
		TRB->TEXTO := cTexto
		MsUnLock()   
	ElseIf Substr(cTexto,1,1) == '1' //RV                  
		cParcela 	:= Iif(Empty(SubStr(cTexto,19,2)) .or. SubStr(cTexto,19,2) == "00","01",SubStr(cTexto,19,2))
		If SubStr(cTexto,37,2) $ "07/12" .or. Substr(cTexto,150,1) == "C" .or.;
			(SubStr(cTexto,37,2) == "14"  .And. Substr(cTexto,150,1) == "D" .and. (Empty(cParcela) .or. cParcela == "01"))
			RecLock('TRB',.T.)
			TRB->TEXTO := cTexto
			MsUnLock()
			lGravaCV	:=	.T.
		Else
			lGravaCV	:=	.F.
		Endif		
	ElseIf Substr(cTexto,1,1) == '2' .And. lGravaCV //RV
		RecLock('TRB',.T.)
		TRB->TEXTO := cTexto
		MsUnLock()
	Endif		                             
	nRead		:=	FREAD(nHdl, @cTexto, nBytes)
Enddo
fClose(nHdl)	                              
Return
