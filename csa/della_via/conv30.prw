#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Converte  � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Programa de Conversao de Base                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
�������������������������������������������������������������������������Ĵ��
��� Data     �              Alteracao                                     ���
�������������������������������������������������������������������������Ĵ��
���03.12.04  � Inclusao do DePara - Versao 2.0                            ���
���19.12.04  � Alteracao para tratar arquivo com delimitador Versao 3.0   ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function Converte() 

SetPrvt("aRadio,aRadConf,nRadio,nRadConf,lEnd,lContinua,lAbortPrint,cArqTxt,cArq,aCampo,cArqInd,cInd,cCampo,nDe,nAte,nTam,lProc")
SetPrvt("aHeader,aCols,aRotina,nI,nJ,cLinhaOk,cTudoOk,cCadastro,nOpc,nOpcao,cTexto,cSTexto,oProc,cGrp,cDelim1,cDelim2,cYesNo,lOpen")

//Inicia Variaveis
aRadio    	:= {"Conversao","Configuracao"}
aRadConf   	:= {"Configuracao Conversao","Configuracao DePara"}
aCampo	    := {}
aHeader		:= {}
aCols		:= {}
aRotina		:= {}
lEnd        := .F.
lContinua   := .T.
lProc		:= .T.
lOpen		:= .T.
lAbortPrint := .F.
nRadio  	:= 1
nRadConf	:= 1
nDe			:= 0
nAte		:= 0
nTam		:= 0
nI			:= 0
nJ			:= 0
nOpc		:= 0
nOpcao		:= 0
cCampo		:= ''
cInd	 	:= ''
cArqInd  	:= ''
cLinhaOk	:= ''
cTudoOk		:= '' 
cCadastro	:= '' 
cTexto		:= ''
cSTexto		:= ''
cYesNo		:= 'N'
cArqTxt  	:= Space(24)
cArq     	:= Space(3)
cGrp		:= Space(4)
cDelim1		:= Space(1)
cDelim2		:= Space(1)
oProc		:= Nil
                   
//Montagem da tela
@ 0,0 TO 130,200 DIALOG oDlg TITLE "Conversao de Tabelas Ver.3.0"
@ 10,10 TO 35,90 
@ 15,15 RADIO aRadio VAR nRadio  
@ 45,10 BMPBUTTON TYPE 01 ACTION ContProc()
@ 45,45 BMPBUTTON TYPE 02 ACTION Close(oDlg)

ACTIVATE DIALOG oDlg CENTER 

//Deleta Arquivos Temporarios
If File(cArqInd + OrdBagExt())     
	//Fecha Arquivo 
	dbSelectArea('CONV')
	dbCloseArea('CONV')
	Ferase (cArqInd+OrdBagExt())
	
	dbSelectArea('DEPA')
	dbCloseArea('DEPA')
	Ferase (cArqInd+OrdBagExt())
	
Endif

Return 

//Fim da Rotina  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � ContProc � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ContProc()

If lOpen

	//Verificar se Existe Arquivo
	If !File("\CONVERTE.DBF")
		CriaTabe()
	Endif
	
	//Abertura de arquivo Configuracao
	dbUseArea(.T.,,"\CONVERTE","CONV")

	//Cria Indice Temporario
	//Nome do Indice
	cArqInd := CriaTrab(Nil,.F.)

	//Chave do Indice
	cInd := "CNV_ARQ + CNV_CAMPO"

	//Criacao do Indice
	IndRegua("CONV",cArqInd,cInd,,,"Selecionando Registros")	

	//Verificar se Existe Arquivo
	If !File("\DEPARA.DBF")
		CriaTabe()
	Endif

	//Abertura de arquivo DePara
	dbUseArea(.T.,,"\DEPARA","DEPA")

	//Cria Indice Temporario
	//Nome do Indice
	cArqInd := CriaTrab(Nil,.F.)

	//Chave do Indice
	cInd := "DE_GRP + DE_DE"

	//Criacao do Indice
	IndRegua("DEPA",cArqInd,cInd,,,"Selecionando Registros")	
	
	lOpen := .F.

Endif	

If nRadio == 1
	@ 0,0 TO 190,250 DIALOG oDlg1 TITLE "Conversao de Tabelas"
	@ 15,12 Say "Nome do Arquivo Fonte"
	@ 15,72 Get cArqTxt Picture "@!" Valid fGetPath()
	@ 28,12 Say "Nome Tabela Destino"
	@ 28,72 Get cArq Picture "@!" Valid ! Empty(cArq)
	@ 41,12 Say "Arquivo Delimitado ?"
	@ 41,72 Get cYesNo Picture "@!" Valid cYesNo $"SN"
	
	@ 60,18 BMPBUTTON TYPE 01 ACTION OkDelim()
	@ 60,65 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER 
Else
	OKConf()
Endif

Return

//Fim da Rotina	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �  OKDelim � Autor � Jose Carlos Gouveia   � Data � 19.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Verificacao do Delimitador                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKDelim()

Close(oDlg1)

If cYesNo =="S"

	@ 0,0 TO 150,250 DIALOG oDlg1 TITLE "Delimitador de Arquivo"
	@ 15,12 Say "Delimitador do Campo"
	@ 15,72 Get cDelim1 Valid !Empty(cDelim1)
	@ 28,12 Say "Delimitador de Dados"
	@ 28,72 Get cDelim2
	
	@ 45,18 BMPBUTTON TYPE 01 ACTION OkProcDelim()
	@ 45,65 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

	ACTIVATE DIALOG oDlg1 CENTER 
	           
Else

	OkProc()

Endif		

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �  OKConf  � Autor � Jose Carlos Gouveia   � Data � 03.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Configuracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKConf()

//Montagem da tela
@ 0,0 TO 130,215 DIALOG oDlg1 TITLE "Configuracao"
@ 10,10 TO 35,100 
@ 15,15 RADIO aRadConf VAR nRadConf  
@ 45,10 BMPBUTTON TYPE 01 ACTION Conv()
@ 45,45 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER 

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �   Conv   � Autor � Jose Carlos Gouveia   � Data � 03.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Configuracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function Conv()

Close(oDlg1)

cArq	:= Space(3)
cGrp	:= Space(4)
cYesNo 	:= "N"

If nRadConf	== 1
	@ 0,0 TO 150,250 DIALOG oDlg1 TITLE "Configuracao da Conversao"
	@ 15,12 Say "Nome da Tabela"
	@ 15,72 Get cArq Picture "@!" Valid !Empty(cArq)
	@ 28,12 Say "Arquivo Delimitado ?"
	@ 28,72 Get cYesNo Picture "@!" Valid cYesNo $"SN"
	
	@ 58,18 BMPBUTTON TYPE 01 ACTION OkConv()
	@ 58,65 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER 	
Else
	@ 0,0 TO 150,250 DIALOG oDlg1 TITLE "Configuracao do Depara"
	@ 28,12 Say "Nome do Grupo"
	@ 28,62 Get cGrp Picture "@!" Valid !Empty(cGrp)
	
	@ 58,18 BMPBUTTON TYPE 01 ACTION OkDe()
	@ 58,65 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER 	
Endif
	
Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �  OKProc  � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Conversao                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKProc()
	
Close(oDlg1)
	
//Abertura de Arquivo Texto
FT_FUSE(cArqTxt)
FT_FGOTOP()

//Processamento da Convers�o 
oProc := MsNewProcess():New({|lEnd| ConvProc(lEnd,oProc)},"Lendo","Processando...",.T.)

oProc:Activate()

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������-�������������������������������������������������������Ŀ��
���Rotina    �OKProcDelim� Autor � Jose Carlos Gouveia  � Data � 19.12.04 ���
����������������-��������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Conversao com Delimitador        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKProcDelim()
	
Close(oDlg1)

//Abertura de Arquivo Texto
FT_FUSE(cArqTxt)
FT_FGOTOP()

//Processamento da Convers�o 
oProc := MsNewProcess():New({|lEnd| DelimProc(lEnd,oProc)},"Lendo","Processando...",.T.)

oProc:Activate()

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �  OKConv  � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Configuracao da Conversao        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKConv()
		
//Inicia Variaveis
aRotina	:=	{{	"", ""	, 0 , 1},;
			 {	"", ""	, 0 , 2},;
			 {	"", ""	, 0 , 3},;
			 {	"", ""	, 0 , 4},;
			 {	"", ""	, 0 , 5}  }

Close(oDlg1)

CONV->(dbSeek(cArq))

//Se Nao Localizado, Carrega Tabela do SX3
If ! CONV->(Found())
    
	aCampo := {}
	  
	//Pesquisa SX3
	If SX3->(dbSeek(cArq))

		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cArq 
				
			aAdd(aCampo,{SX3->X3_ARQUIVO,SX3->X3_CAMPO,SX3->X3_TITULO,SX3->X3_TIPO})

			SX3->(dbSkip())
				
		EndDo
		
		For nI:=1 to Len(aCampo)
		
			If RecLock("CONV",.T.)
		
				For nJ:=1 to 4
					CONV->(FieldPut(nJ,aCampo[nI,nJ]))
				Next nJ
		
				MsUnlock()
				
			Endif	
		
		Next nI         
	
	Else

		//Se Nao Localizou Tabela no SX3
		Help("",1,"","HELP","Tabela Nao Localizada no SX3",1,0)
		Return
		
	Endif
		
Endif 

aHeader := {}	

If cYesNo == "S"

	aAdd(aHeader,{ "Campo","CNV_CAMPO","@!",10,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Nome","CNV_NOME","@!",12,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Tipo","CNV_TIPO","@!",1,0,,,"C","CONV",} ) 
	aAdd(aHeader,{ "Ordem","CNV_ORDEM","999",3,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Formula","CNV_FORM","@!",300,0,,,"C","CONV",} )
	
Else

	aAdd(aHeader,{ "Campo","CNV_CAMPO","@!",10,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Nome","CNV_NOME","@!",12,0,,,"C","CONV",} )
	aAdd(aHeader,{ "Tipo","CNV_TIPO","@!",1,0,,,"C","CONV",} )
	aAdd(aHeader,{ "De","CNV_DE","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Ate","CNV_ATE","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Tamanho","CNV_TAM","9999",4,0,,,"N","CONV",} )
	aAdd(aHeader,{ "Formula","CNV_FORM","@!",300,0,,,"C","CONV",} )
	
Endif

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������	
CONV->(dbSeek(cArq))

//Inicia Variaveis
aCols	:= {}
nI		:= 0
nOpc	:= 3 

	
While CONV->(!Eof()) .And. (CONV->CNV_ARQ == cArq)

	nI += 1 
	aAdd(aCols,{})

	If cYesNo == "S"

		aAdd(aCOLS[nI],CONV->CNV_CAMPO)
		aAdd(aCOLS[nI],CONV->CNV_NOME)	
		aAdd(aCOLS[nI],CONV->CNV_TIPO)
		aAdd(aCOLS[nI],CONV->CNV_ORDEM)
		aAdd(aCOLS[nI],CONV->CNV_FORM)
		aAdd(aCOLS[nI], .F.)

	Else
		
		aAdd(aCOLS[nI],CONV->CNV_CAMPO)
		aAdd(aCOLS[nI],CONV->CNV_NOME)	
		aAdd(aCOLS[nI],CONV->CNV_TIPO)
		aAdd(aCOLS[nI],CONV->CNV_DE)
		aAdd(aCOLS[nI],CONV->CNV_ATE)
		aAdd(aCOLS[nI],CONV->CNV_TAM)
		aAdd(aCOLS[nI],CONV->CNV_FORM)
		aAdd(aCOLS[nI], .F.)
		
	Endif
		
	CONV->(dbSkip())
		
End
         
define MSDialog oDlg Title (cCadastro) from 44,5 to 310,645 of oDlg Pixel
// Monta Cabecalho
@ 10, 15  Say "Nome da Tabela"  
@ 23, 08  Get cArq When .F. 

oGet := MSGetDados():New(44,5,128,315,nOpc,"u_fLOK()","u_fTOK","",.T.,,,,1000)
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(u_fTOK(),oDlg:End(),nOpcao:=0)},{||oDlg:End()})
   
If nOpcao == 1
    //Grava Registro
	fGravaCon()
Endif

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �   OKDe   � Autor � Jose Carlos Gouveia   � Data � 03.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Configuracao do DEPARA           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function OKDe()
		
//Inicia Variaveis
aRotina	:=	{{	"", ""	, 0 , 1},;
			 {	"", ""	, 0 , 2},;
			 {	"", ""	, 0 , 3},;
			 {	"", ""	, 0 , 4},;
			 {	"", ""	, 0 , 5}  }
aHeader	:= {}
aCols	:= {}			 

Close(oDlg1)

aAdd(aHeader,{ "De","DE_DE","@!",10,0,,,"C","DEPA",} )             
aAdd(aHeader,{ "Para","DE_PARA","@!",10,0,,,"C","DEPA",} )
	
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������	
DEPA->(dbSeek(cGrp))

//Inicia Variaveis
nI		:= 0
nOpc	:= 3
	
While DEPA->(!Eof()) .And. (DEPA->DE_GRP == cGrp)

	nI += 1 
	aAdd(aCols,{})
	aAdd(aCOLS[nI],DEPA->DE_DE)
	aAdd(aCOLS[nI],DEPA->DE_PARA)
	aAdd(aCOLS[nI], .F.)
		
	DEPA->(dbSkip())
		
End
         
define MSDialog oDlg Title (cCadastro) from 44,5 to 310,645 of oDlg Pixel
// Monta Cabecalho
@ 10, 15  Say "Nome do Grupo"  
@ 23, 08  Get cGrp When .F. 

oGet := MSGetDados():New(44,5,128,315,nOpc,"u_fLOK()","u_fTOK()","",.T.,,,,1000)
ACTIVATE DIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcao:=1,If(u_fTOK(),oDlg:End(),nOpcao:=0)},{||oDlg:End()})
   
If nOpcao == 1
    //Grava Registro
	fGravaDe()
Endif

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � ConvProc � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Conversao                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function ConvProc(lEnd,oObj)

//Set Regua 1 
oObj:SetRegua1(FT_FLASTREC())

While lContinua .And. !FT_FEOF()
	
	CONV->(dbGotop())

	//Set Regua 2
	oObj:SetRegua2(CONV->(RecCount()))

	//Le Linha do Arquivo Texto	
	cSTexto := FT_FREADLN()

	If CONV->(dbSeek(cArq),!Found())
		MsgBox (cArq + " Nao Localizado. Selecionar Configuracao","Erro","STOP")
		Return
	Endif
	
	If RecLock(cArq,.T.)		

		While lContinua .And. CONV->CNV_ARQ == cArq
	    	
			If lAbortPrint .Or. lEnd
				If Aviso('ATEN�AO','Deseja abandonar a Conversao arquivo ' + AllTrim(cArq) + ' ?',{'Sim','N�o'}) == 1
					lContinua := .F.
					Exit
				EndIf	
			Endif
            
			cCampo := cArq + "->" + AllTrim(CONV->CNV_CAMPO)
			nDe	   := CONV->CNV_DE
			nAte   := CONV->CNV_ATE
			nTam   := CONV->CNV_TAM
			
			//���������������������������������������������������������������������Ŀ
			//� Incrementa a regua 2                                                �
			//�����������������������������������������������������������������������
			oObj:IncRegua2("Processando Campo : " + cCampo)
	
	   		//Se Converte Campo
			If nDe > 0
			
				If nTam = 0
					nTam := (nAte - nDe + 1)
				Endif
	 
	    		If CONV->CNV_TIPO == "C"
    				If RecLock(cArq,.F.)
    					If !Empty(CONV->CNV_FORM)
    						cTexto := Subst(cSTexto,nDe,nTam)
							&cCampo := CONV->&CNV_FORM
						Else	    						
		    				&cCampo := Subst(cSTexto,nDe,nTam)
		    			Endif	
		    		Endif	
			    ElseIf CONV->CNV_TIPO == "D"
    				If RecLock(cArq,.F.)
    					If !Empty(CONV->CNV_FORM)
    						cTexto := Subst(cSTexto,nDe,nTam)
							&cCampo := cTod(CONV->&CNV_FORM)
						Else	    						
		    				&cCampo := cTod(Subst(cSTexto,nDe,nTam))
		    			Endif	
		    		Endif	
			    ElseIf CONV->CNV_TIPO == "N"	
    				If RecLock(cArq,.F.)
    					If !Empty(CONV->CNV_FORM)
    						cTexto := Subst(cSTexto,nDe,nTam)
   			    			&cCampo := Val(CONV->&CNV_FORM)
						Else	    						
		    				&cCampo := Val(Subst(cSTexto,nDe,nTam))
		    			Endif	
		    		Endif	  				
			    Endif	         
	        
	    	//Se Somente o Campo Formula esta Preenchido
			ElseIf!Empty(CONV->CNV_FORM)
				
				If CONV->CNV_TIPO == "C"
    				If RecLock(cArq,.F.)
						&cCampo := CONV->&CNV_FORM
		    		Endif	
			    ElseIf CONV->CNV_TIPO == "D"
    				If RecLock(cArq,.F.)
						&cCampo := cTod(CONV->&CNV_FORM)
		    		Endif	
			    ElseIf CONV->CNV_TIPO == "N"	
    				If RecLock(cArq,.F.)
		    			&cCampo := Val(CONV->&CNV_FORM)
		    		Endif	  				
			    Endif	         			
			
			Endif
	
			CONV->(dbSkip())

		Enddo
	
	Endif	
	
	//Salta Linha no Arquivo Texto
	FT_FSKIP()

	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua 1                                                �
	//�����������������������������������������������������������������������
	oObj:IncRegua1("Processando " + cArqTxt)
		
Enddo

//Fechamento do Arquivo Texto
FT_FUSE()

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    �DelimProc � Autor � Jose Carlos Gouveia   � Data � 26.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento da Conversao com Delimitador        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function DelimProc(lEnd,oObj)

Local nRec_  := 0
Local aDados := {}

//Set Regua 1 
oObj:SetRegua1(FT_FLASTREC())
	
//Localizar Ordem
If CONV->(dbSeek(cArq),!Found())
	MsgBox (cArq + " Nao Localizado. Selecionar Configuracao","Erro","STOP")
	Return              
Else 
			
	If CONV->(Eof())
		MsgBox (" Ordem Nao Localizada. Selecionar Configuracao","Erro","STOP")
		Return     
	Else
		nRec_ := CONV->(Recno())	         
	Endif				

Endif

While lContinua .And. !FT_FEOF()

	//Set Regua 2
	oObj:SetRegua2(CONV->(RecCount()))

	//Le Linha do Arquivo Texto	
	cSTexto := FT_FREADLN()
	
	//Se Nao Localiza delimitador
	If At(cDelim1,cSTexto) == 0
		lContinua := .F.
		Loop
	Endif 
	
	aDados := fSepara(cStexto)	

	If RecLock(cArq,.T.)		

		While CONV->(!Eof()) .And. lContinua
	    	
			If lAbortPrint .Or. lEnd
				If Aviso('ATEN�AO','Deseja abandonar a Conversao arquivo ' + AllTrim(cArq) + ' ?',{'Sim','N�o'}) == 1
					lContinua := .F.
					Exit
				EndIf	
			Endif
	        
			//Verifica se Ordem maior que Array		
			If Val(CONV->CNV_ORDEM) > Len(aDados)
				CONV->(dbSkip())
				Loop
			Endif	

			//Verifica Campos Vazios
			If Val(CONV->CNV_ORDEM) = 0 
				If Empty(CONV->CNV_FORM)
					CONV->(dbSkip())
					Loop
				Endif
			Else
				//Carrega Texto
				cTexto := aDados[Val(CONV->CNV_ORDEM)]			
			Endif	
			
			//Carrega Nome do Campo
			cCampo := cArq + "->" + AllTrim(CONV->CNV_CAMPO)
			
			//���������������������������������������������������������������������Ŀ
			//� Incrementa a regua 2                                                �
			//�����������������������������������������������������������������������
			oObj:IncRegua2("Processando Campo : " + cCampo)
						
			If CONV->CNV_TIPO == "C"
   				If RecLock(cArq,.F.)
   					If !Empty(CONV->CNV_FORM)
   						&cCampo := CONV->&CNV_FORM
					Else	    						
	    				&cCampo := cTexto
	    			Endif	
	    		Endif	
		    ElseIf CONV->CNV_TIPO == "D"
   				If RecLock(cArq,.F.)
   					If !Empty(CONV->CNV_FORM)
   						&cCampo := cTod(CONV->&CNV_FORM)
					Else	    						
	    				&cCampo := cTod(cTexto)
	    			Endif	
	    		Endif	
		    ElseIf CONV->CNV_TIPO == "N"	
   				If RecLock(cArq,.F.)
   					If !Empty(CONV->CNV_FORM)
		    			&cCampo := Val(CONV->&CNV_FORM)
					Else	    						
	    				&cCampo := Val(cTexto)
	    			Endif	
	    		Endif	  				
		    Endif	          
					   
			CONV->(dbSkip())
			
		Enddo
		
		//Posiciona Arquivo CONV
		CONV->(dbGoto(nRec_))
		
		//Reinicia aDados
		aDados := {}
	
	Endif
		
	//Salta Linha no Arquivo Texto
	FT_FSKIP()

	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua 1                                                �
	//�����������������������������������������������������������������������
	oObj:IncRegua1("Processando " + cArqTxt)
		
Enddo

//Fechamento do Arquivo Texto
FT_FUSE()

Return
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � fDePara  � Autor � Jose Carlos Gouveia   � Data � 03.12.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento do DePara                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fDePara(cGrp,cDpr)
    
Local cDePara := ''

If Empty(cGrp)
	Return(cDePara)
Endif

//Acrescenta Espaco a Direita
If Len(cGrp) < 4
   cGrp :=	Left((cGrp + Space(4)),4)
Endif	     

If DEPA->(dbSeek(cGrp + cDpr))
	cDePara := DEPA->DE_PARA
Else
	cDePara := ''
Endif		
	
Return(cDePara)

//Fim da Rotina

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FSepara  � Autor � Jose Carlos Gouveia   � Data � 04/02/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Separa Dados delimitados                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CONVERTE													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fSepara(cTxt)

Local aData   := {}
Local cTxtAux := ""

//Se Delimitador de Dados Nao Existe 
If Empty(cDelim2)

	While At(cDelim1,cTxt) > 0
		
		aAdd(aData,Subst(cTxt,1,At(cDelim1,cTxt) - 1))
		
		cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)
		
		If At(cDelim1,cTxt) = 0
			aAdd(aData,cTxt)
		Endif
		
	Enddo
	
Else //Delimitador de Dados Existe
                                  
	While At(cDelim1,cTxt) > 0

		//Primeiro Campo N�o � Delimitador de Dados
		If At(cDelim2,cTxt) != 1
		        
			aAdd(aData,Subst(cTxt,1,At(cDelim1,cTxt) - 1))
		
			cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)		
		Else
			     
			cTxtAux := Subst(cTxt,At(cDelim2,cTxt) + 1)
			cTxtAux := Subst(cTxtAux,1,At(cDelim2,cTxtAux) - 1)
			 
			aAdd(aData,cTxtAux)

			cTxt := Subst(cTxt,At(cDelim1,cTxt) + 1)
			
		Endif
		
		//Fim dos Delimitadores
		If At(cDelim1,cTxt) = 0
			
			//Primeiro Campo N�o � Delimitador de Dados
			If At(cDelim2,cTxt) != 1
				aAdd(aData,cTxt)
			Else
				cTxtAux := Subst(cTxt,At(cDelim2,cTxt) + 1)
				cTxtAux := Subst(cTxtAux,1,At(cDelim2,cTxtAux) - 1)
			 
				aAdd(aData,cTxtAux)

			Endif
				
		Endif
	Enddo	
Endif								

Return(aData)

//Fim da Rotina

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FGETPATH � Autor � Kleber Dias Gomes     � Data � 26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Permite que o usuario decida onde sera criado o arquivo    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CONVERTE													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGetPath()
Local cRet  :=Alltrim(ReadVar())
Local cPath  := cArqTxt

oWnd := GetWndDefault()

While .T.
	If Empty(cPath)
		cPath := cGetFile( "Arquivos Texto de Importacao | *.TXT ",OemToAnsi("Selecione Arquivo"))
	EndIf
	
	If Empty(cPath)
		Return .F.
	EndIf
	&cRet := cPath
	Exit
EndDo

If oWnd != Nil
	GetdRefresh()
EndIf

Return .T.
//Fim da Rotina 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �fGravaCon � Autor � Jose Carlos Gouveia   � Data � 10/04/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Registro do Acols                                    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CONVERTE													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGravaCon()

Local nI, nJ, nT, aCampo

aCampo := {}

If cYesNo == "S"

	aAdd(aCampo,"CNV_CAMPO")
	aAdd(aCampo,"CNV_NOME")
	aAdd(aCampo,"CNV_TIPO") 
	aAdd(aCampo,"CNV_ORDEM")
	aAdd(aCampo,"CNV_FORM")

	nT := Len(aCampo) + 1
		
Else

	aAdd(aCampo,"CNV_CAMPO")
	aAdd(aCampo,"CNV_NOME")
	aAdd(aCampo,"CNV_TIPO")
	aAdd(aCampo,"CNV_DE")
	aAdd(aCampo,"CNV_ATE")
	aAdd(aCampo,"CNV_TAM")
	aAdd(aCampo,"CNV_FORM")

	nT := Len(aCampo) + 1
			
Endif

For nI := 1 to Len(aCols)

	CONV->(dbSeek(cArq + aCols[nI,1]))
	
	If CONV->(! Eof()) //Gravacao em Registro Existente
		
		If aCols[nI,nT] //Elemento Deletado
		
			If RecLock("CONV",.F.)
				CONV->(dbDelete())
			Endif
			
		Else
		
			If RecLock("CONV",.F.) .And. !aCols[nI,nT]
				//Grava Registro
				For nJ := 2 to Len(aCampo)
					CONV->(FieldPut(FieldPos(aCampo[nJ]),aCols[nI,nJ]))
				Next nJ
				
			Endif
			
		Endif

	Else //Incluindo no Registro

		If RecLock("CONV",.T.) .And. !aCols[nI,nT]
			
			//Grava Registro
			CONV->(FieldPut(FieldPos(aCampo[1]),cArq))
		
			For nJ := 2 to Len(aCampo)
				CONV->(FieldPut(FieldPos(aCampo[nJ]),aCols[nI,nJ]))
			Next nJ
				
		Endif
	
	Endif

Next nI

Return
//Fim da Rotina		

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � fGravaDe � Autor � Jose Carlos Gouveia   � Data � 10/04/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Registro do Acols De Para                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CONVERTE													  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function fGravaDe()

Local nI, nJ

For nI := 1 to Len(aCols)

	DEPA->(dbSeek(cGrp + aCols[nI,1]))
	
	If DEPA->(! Eof()) //Gravacao em Registro Existente
		
		If aCols[nI,3] //Elemento Deletado
		
			If RecLock("DEPA",.F.)
				DEPA->(dbDelete())
			Endif
			
		Else
		
			If RecLock("DEPA",.F.)
				//Grava Registro
				For nJ := 1 to 2
					DEPA->(FieldPut(nJ + 1,aCols[nI,nJ]))
				Next nJ
				
			Endif
			
		Endif

	Else //Incluindo no Registro

		If RecLock("DEPA",.T.) .And. !aCols[nI,3]
			//Grava Registro
			DEPA->(FieldPut(1,cGrp))
			For nJ := 1 to 2
				DEPA->(FieldPut(nJ + 1,aCols[nI,nJ]))
			Next nJ
				
		Endif
	
	Endif

Next nI

Return
//Fim da Rotina		

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  fLOk    �Autor  �Jose Carlos Gouveia � Data �  08/11/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao das Linhas do aCols.                             ���
�������������������������������������������������������������������������͹��
���Uso       � CONVERTE													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fLOK()

Local lRet := .T.
Local nLin := n
                     
If (Empty(aCols[nLin,1]) .And. (nI >= nLin)) .And. !aCols[nLin,9]
	MsgStop("Coluna Campo em Branco !!!")
	lRet := .F.
Else
	If (Empty(aCols[nLin,2]) .And. (nI >= nLin)) .And. !aCols[nLin,9]
		MsgStop("Coluna Tipo em Branco !!!")
		lRet := .F.
	Endif	
Endif

//Acrescenta Zero no Campo Ordem
If cYesNo == "S"
	If Val(aCols[nLin,4]) > 0 .And. lRet
		aCols[nLin,4] := Right('00' + AllTrim(aCols[nLin,4]),3)
	Endif		
Endif


Return(lRet)	
//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  fTOk    �Autor  �Jose Carlos Gouveia � Data �  08/11/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao do MsGetDados                                    ���
�������������������������������������������������������������������������͹��
���Uso       � CONVERTE													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fTOk()

lRet  := u_fLOK()

Return(lRet)
//Fim da Rotina

//Fim da Rotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rotina    � CriaTabe � Autor � Jose Carlos Gouveia   � Data � 03.01.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de processamento                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Generico                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function CriaTabe()
                          
//Verificar se Existe Arquivo
If !File("\CONVERTE.DBF")

	aCampo := {}
	
	//Criacao do Array 
	aAdd(aCampo,{ "CNV_ARQ"  ,"C",  3,0} )
	aAdd(aCampo,{ "CNV_CAMPO","C", 10,0} )
	aAdd(aCampo,{ "CNV_NOME ","C", 12,0} )
	aAdd(aCampo,{ "CNV_TIPO" ,"C",  1,0} )
	aAdd(aCampo,{ "CNV_ORDEM","C", 3,0} )              		
	aAdd(aCampo,{ "CNV_DE"   ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_ATE"  ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_TAM"  ,"N",  4,0} )
	aAdd(aCampo,{ "CNV_FORM" ,"C",300,0} )

	//Criacao do Arquivo
	dBCreate("\CONVERTE",aCampo)
Endif

If !File("\DEPARA.DBF")

	aCampo := {}
	
	//Criacao do Array 
	aAdd(aCampo,{ "DE_GRP" ,"C", 4,0} )
	aAdd(aCampo,{ "DE_DE"  ,"C", 10,0} )              
	aAdd(aCampo,{ "DE_PARA","C", 10,0} )

	//Criacao do Arquivo
	dBCreate("\DEPARA",aCampo)
Endif

Return
//Fim da Rotina 

//Fim do Programa 