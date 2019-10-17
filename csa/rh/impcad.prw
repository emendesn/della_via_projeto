#define Confirma 1
#define Redigita 2
#define Abandona 3

#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIMPCAD  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cadastramento de Lay-Out para Importacao de Tabelas        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER Function IMPCAD()

PRIVATE aRotina := { { "Pesquisar" , "AxPesquisa", 0 , 1},;
				     { "Importar Arquivos" , "U_IMPARQTXT", 0 , 2},;
                     { "ATUALIZAR" , "U_xIMPCAD", 0 , 4}}  //"Alterar"  
                    

cCadastro := OemToAnsi("ATUALIZACAO CADASTRO")  //"Cadastro de Dependentes"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o Arquivo Esta Vazio                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ChkVazio("SX2")
	Return      
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX2")
dbSetOrder(1)
mBrowse( 6, 1,22,75,"SX2",,,,)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ xImpCad  ³ Autor ³ Reginaldo             ³ Data ³ 09.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de (Manutencao Lay-out Conf. Arquivos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER Function xIMPCAD(cAlias,nReg,nOpcx)


Local cSaveMenuh,nCnt,GetList:={}

Local cNome     := SX2->X2_NOME
Local aSaveArea := GetArea()

Private xAlias    := SX2->X2_CHAVE
Private aAC      := {"Abandona","Confirma"}
Private aColsRec := {}   //--Array que contem o Recno() dos registros da aCols
Private cArquivo :=	"ARQ"+xAlias+".TXT"
While .T.

    nCnt := 0

    If fChkArqTxt(@nCnt) // verifica se existe arquivo texto com configuracao
    else 				 // se nao existir monta dicionario padrao SX3 
	    DbSelectArea("SX3")
        DbSetOrder(1)
	    DbSeek(xAlias)
	    While X3_arquivo = xAlias .and. ! eof()
          If SX3->X3_CONTEXT = "V"
             DbSkip()
             Loop
          EndIF
             
	      nCnt ++     
	      DbSkip()
	    EndDo
    EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a entrada de dados do arquivo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private aTELA[0][0],aGETS[0],aHeader[0],Continua:=.F.,nUsado:=0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o cabecalho                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    ImpaHead() // Monta Cabecalho
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona ponteiro do arquivo cabeca e inicializa variaveis  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcA := 0

    PRIVATE aCOLS[nCnt][nUsado+1]
	nCnt   :=0
	nUsado :=0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gerar o array aCols com os campos                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    gp020Acols(nOpcx)


	nOpca := 0
	DEFINE MSDIALOG oDlg TITLE OemToAnsi("Manutencao Lay-Out") From 9,0 To 28,80 OF oMainWnd  //" Dependentes "
	// Monta Cabecalho
	@ 15.5,  15.0 SAY OemToAnsi("Alias")  
	@ 15.5,  30.5 SAY OemToAnsi(xAlias)
	@ 15.5,  45.0 SAY OemToAnsi("Descricao")  
	@ 15.5,  75.0  SAY OemToAnsi(cNome)
   oGet := MSGetDados():New(34,5,128,315,nOpcx,"u_xgp020LinOk","u_xgp020TudOk","",If(nOpcx=4.Or.nOpcx=5,Nil,.T.),,1)
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca:=If(nOpcx=5,2,1),If(oGet:TudoOk(),oDlg:End(),nOpca:=0)},{||oDlg:End()})
    //--Se nao for Exclusao
   IF nOpcA == Confirma .And. nOpcx # 5
       Begin Transaction
                //--Gravacao
                xgp020grava()

       End Transaction
    Endif

	Exit

EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade da janela                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RestArea(aSaveArea)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³gp020aHead³ Autor ³ Mauro                 ³ Data ³ 23/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criar os Arrays Aheader e aCols dos  dependentes           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ gpea020o                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpaHead()


AADD(aHeader,{ "Habilitado","XX_HABILI","!",;
			1,0, "      ",;
			"Usado? ","C","XXX" } )


AADD(aHeader,{ "Nome Campo","XX_CAMPO ","@!",;
			10,0, "      ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Tipo Campo","XX_TIPO  ","!",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Decimal Campo","XX_DECIMAL","9",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Campo Chave","XX_CHAVE","!",;
			1,0, "       ",;
			"Usado? ","C","XXX" } )


AADD(aHeader,{ "Pos. Inicial","XX_VALID","9999",;
			4,0, "       ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Pos. Final","XX_USADO","9999",;
			4,0, "       ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Formula  ","XX_FORMULA","@!",;
			160,0, "      ",;
			"Usado? ","C","XXX" } )

AADD(aHeader,{ "Tab.De-Para","XX_TABDEPA","@!",;
			10,0, "      ",;
			"Usado? ","C","XXX" } )

nUsado += 9

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³g020aCols ³ Autor ³ Mauro                 ³ Data ³ 23/04/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Criar os Arrays Aheader e aCols dos  dependentes           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ gpea020o                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function gp020aCols(nOpcx)



Local nHandle

nCnt := 0

If File(cArquivo)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo texto informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := fOpen( cArquivo ,64)
	
	If Ferror() # 0 .or. nHandle < 0
	    Help(" ",1,"A210NOPEN")
	    Return( Nil )
	Endif

	TXT := fReadStr( nHandle,256 )
	nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

	aFile   := Directory( cArquivo )
	nSize   := aFile[1,2]
	nLinhas := Int(nSize/nBytes)

	fSeek( nHandle,0,0 )

	For nCount := 1 To nLinhas


    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Lˆ cada linha do arquivo texto ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    TXT := fReadStr( nHandle,nBytes )

		nCnt++
		nUsado := 0
	    For nx := 1 to Len(aHeader)
            nUsado ++

                If nx = 1
    		        aCOLS[nCnt][nUsado] := Substr(txt,1,1)
                ElseIf nx = 2
    		        aCOLS[nCnt][nUsado] := Substr(txt,2,10)
                ElseIf nx = 3
                    aCOLS[nCnt][nUsado] := Substr(txt,12,1)
                ElseIf nx = 4
                    aCOLS[nCnt][nUsado] := Substr(txt,13,1)
                ElseIf nx = 5
                    aCOLS[nCNt][nUsado] := Substr(txt,14,1)
                ElseIf nx = 6
                    aCOLS[nCnt][nUsado] := Substr(txt,15,4)
                ElseIf nx = 7
                    aCOLS[nCnt][nUsado] := Substr(txt,19,4)
                ElseIf nx = 8
                    aCOLS[nCnt][nUsado] := Substr(txt,23,160)
                ElseIf nx = 9
                    aCOLS[nCnt][nUsado] := Substr(txt,183,10)

                EndIf    

        Next

		aCOLS[nCnt][nUsado+1] := .F.

	Next	
    
    fClose(nHandle)

Else
    
    SIX->(Dbseek(xAlias))

    
    nSeq := 0
	
	DbSelectArea("SX3")
	If DbSeek(xAlias)
    	While X3_ARQUIVO = xAlias .and. !eof()
            
            If SX3->X3_CONTEXT = "V"
               DbSkip()
               Loop
            EndIF   
			nCnt++
			nUsado  := 0
            nSeq += SX3->X3_TAMANHO

		    cCampo_ := SX3->X3_CAMPO
		    
		    If cCampo_ $ SIX->CHAVE
		        cIndi_ := "S"
		    Else
		        cIndi_ := "N"		        
		    EndIF    
		    For nx  := 1 to Len(aHeader)
                nUsado ++
                
                
                If nx = 1
    		        aCOLS[nCnt][nUsado] := "S"
                ElseIf nx = 2
    		        aCOLS[nCnt][nUsado] := x3_campo
                ElseIf nx = 3
                    aCOLS[nCnt][nUsado] := x3_tipo
                ElseIf nx = 4
                    aCOLS[nCnt][nUsado] := StrZero(x3_decimal,1)
                ElseIf nx = 5
                    aCOLS[nCnt][nUsado] := cIndi_
                ElseIf nx = 6 
                    aCOLS[nCnt][nUsado] := Strzero(nSeq - sx3->x3_tamanho +1,4)
                ElseIf nx = 7
                    aCOLS[nCnt][nUsado] := Strzero(nSeq,4)
                ElseIf nx = 8
                    aCOLS[nCnt][nUsado] := Space(160)
                ElseIf nx = 9
                    aCOLS[nCnt][nUsado] := Space(10)
                EndIf    

    	    Next

        
		    DbSkip()
		
			aCOLS[nCnt][nUsado+1] := .F.
	    
	    EndDo   

    EndIF
EndIF	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³                   ROTINAS DE CRITICA DE CAMPOS                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³gp020Grava³ Autor ³ J. Ricardo            ³ Data ³ 06.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava no arquivo de Dependentes                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ gp020Grava                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
Static  Function xgp020Grava()
Local ny:=0,nMaxArray:=Len(aHeader)

nHandle  := MSFCREATE(cArquivo)

If FERROR() # 0 .Or. nHandle < 0
	Help("",1,"GPM600HAND")
	FClose(nHandle)
	Return Nil
EndIf


For n:=1 TO Len(aCols)


    //--Verifica se Nao esta Deletado no aCols
    xConteudo := ""
    If aCols[n,nUsado+1] = .F.
	    For ny := 1 To nMaxArray
    	    xConteudo += aCols[n,ny]
	    Next ny
		FWrite( nHandle,xConteudo+chr(13)+chr(10))
    EndIf

Next n

FClose(nHandle)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³gp020LinOk³ Autor ³ J. Ricardo            ³ Data ³ 06.08.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Critica linha digitada                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
user Function xgp020LinOk(o)
Local nx,lRet := .T.

If aCols[n,nUsado+1]  = .F.
/*
			If Trim(aHeader[nx][2]) == "RB_TIPSF" .and. lRet
				Help(" ",1,"A020STIPSF")
				lRet := .F.
				Exit
			Endif
			
		Endif
	Next nx
*/
Endif
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³gp020TudOk³ Autor ³ J. Ricardo            ³ Data ³ 15.02/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
user Function xgp020TudOk(o)
Local lRetorna  := .T.
Continua := .F.
Return lRetorna


User Function ImpArqTxt

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPCAD   ³ Autor ³ R.H. - Reginaldo      ³ Data ³ 24.09.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Importacao dos Cadastro do Recursos Humanos                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Local cArquivo
Local nOpca := 0
Local aRegs	:={}

Local aSays:={ }, aButtons:= { } //<== arrays locais de preferencia
Private lAbortPrint := .F.
cCadastro := OemToAnsi("Importacao de Cadastros") 

Aadd(aRegs,{"GPECAD","01","Arquivo        ?","","","mv_cha","C",030,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"GPECAD","02","Alias do Arquivo?","","","mv_chb","C",003,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{"GPECAD","03","Arq. Config.   ?","","","mv_ccb","C",30,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

ValidPerg(aRegs,"GPECAD")

Pergunte("GPECAD",.F.)

AADD(aSays,OemToAnsi("Este programa importa arquivos de lancamentos") )   

AADD(aButtons, { 5,.T.,{|| Pergunte("GPECAD",.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

IF nOpca == 1
		Processa({|lEnd| GPA210Processa(),"Importacao de cadastros"})
Endif

Return( Nil )

Static Function GPA210Processa()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento	                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqTXT   := alltrim(mv_par01)
cAlias    := UPPER(mv_par02)
cArqConf  := "ARQ"+cAlias+".TXT"

_aStru := {}
_aTab  := {}

fAbreArq(cArqConf)

For nTab := 1 to len(_aStru)

    If len(_aStru[nTab,8]) < 8

    Elseif !Empty(_aStru[nTab,8]) 
       cTabela :=  _aStru[nTab,8]
       fAbreTab(cTabela)
    EndIf
Next     


fImpCadas()

Static Function fImpCadas()

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo := ALLTRIM(mv_par01)

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,68)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif


TXT := fReadStr( nHandle,1285 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1
aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria a Regua de processamento de registros              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
IF cAlias == "SRB"
   if ma280flock("SRB")
      zap             
      DbClearInd()
      RetIndex("SRB") 
      DbReIndex()
   EndIF
EndIF      
*/
ProcRegua(nLinhas)
dbSelectArea(cAlias)
For nCount := 1 To nLinhas

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Move Regua Processamento	                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc("Importando Registros ")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

// verifica se existe campo chave para gravacao



	cChave := ""
    For nChave := 1 to len(_aStru)

       //_aStru[n,1] = CAMPO              01/10
       //_aStru[n,2] = TIPO               11/01
       //_aStru[n,3] = DECIMAL            12/01
       //_aStru[n,4] = CHAVE DE INDICE ?  13/01
       //_aStru[n,5] = POSICAO INICIAL    14/04
       //_aStru[n,6] = POSICAO final      18/04       
       //_aStru[n,7] = FORMULA            22/60
       //_aStru[n,8] = TABELA DE/PARA     82/10

        if _aStru[nChave,4] = "S"

          cCampo  :=  _aStru[nChave,1]
          nPosIni := val(_aStru[nChave,5])
          nPosFim := Val(_aStru[nChave,6])
          cTXT    := Substr(TXT,nPosIni,nPosFim-nPosIni+1)
          cFuncao_ := alltrim(_aStru[nChave,7] )

          If !empty(cFuncao_)
             cTxt := &cFuncao_
          EndIf

          cChave += cTXT

        EndIf
    Next       
    
    dbSelectArea(cAlias)
    dbSetOrder(1)
    IF cAlias == "SRB" //  .OR. cAlias == "SRD" 
       
	   RecLock( cAlias,.T. )    
    
    Else
	    If dbseek(cChave)
        	   RecLock( cAlias,.F. )
	    Else   
        	   RecLock( cAlias,.T. )
        ENDIF
    EndIf

    For nCampo := 1 to len(_aStru)

       //_aStru[n,1] = CAMPO              01/10
       //_aStru[n,2] = TIPO               11/01
       //_aStru[n,3] = DECIMAL            12/01
       //_aStru[n,4] = CHAVE DE INDICE ?  13/01
       //_aStru[n,5] = POSICAO INICIAL    14/04
       //_aStru[n,6] = POSICAO final      18/04       
       //_aStru[n,7] = FORMULA            22/60
       //_aStru[n,8] = TABELA DE/PARA     82/10

    
          cCampo    :=  _aStru[nCampo,1]
          nPosIni   := val(_aStru[nCampo,5])
          nPosFim   := Val(_aStru[nCampo,6])
          cFuncao_  := alltrim(_aStru[nCampo,7] )
          cTab_     := _aStru[ncampo,8]
          
          IF _aStru[nCampo,2] == "N"

             cTxt :=  Substr(TXT,nPosIni,nPosFim-nPosIni+1)
             cTxt := StrTran(cTxt,".","")
             cTxt := StrTran(cTxt,",",".")
             cTxt := Val(cTxt)

          ElseIf _aStru[nCampo,2] == "D"
             cTxt := Substr(TXT,nPosIni,nPosFim-nPosIni+1)
             cTxt := Stod(cTxt)      // AAAAMMDD
//             cTxt := ctod(Substr(cTXT,1,2)+"/"+Substr(cTxt,3,2)+"/"+Substr(cTxt,5,4))    DDMMAAAA      
//               cTxt := Ctod(cTxt)  // DD/MM/AAAA
          Else
             cTxt :=  Substr(TXT,nPosIni,nPosFim-nPosIni+1)
          EndIf   

          If !empty(cFuncao_)
             cTxt := &cFuncao_
          EndIf

          
          nPesq_ := Ascan(_aTab,{|x| x[1] = cTab_ .and. x[2] == cTxt})

          If nPesq_ > 0 
                cTxt := _aTab[nPesq_,3]
          EndIf

          &cCampo := cTXT
    
          
     Next nCampo 
     MsUnlock()

Next nCount

fclose(nHandle)

Return
    

STATIC FUNCTION fAbreArq(cArq)

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo    := cArq
private nLinhas

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,64)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif

TXT := fReadStr( nHandle,256 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )


For nCount := 1 To nLinhas
    

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

    If SUBSTR(TXT,1,10) = "S"
     
       aAdd(_aStru,{ALLTRIM(Substr(TXT,2,10)),substr(TXT,12,1),SUBSTR(TXT,13,3),SUBSTR(TXT,14,1),;
                    SUBSTR(TXT,15,4),SUBSTR(TXT,19,4),ALLTRIM(SUBSTR(TXT,23,160)),alltrim(substr(TXT,183,10))})

       //_aStru[n,1] = CAMPO              01/10
       //_aStru[n,2] = TIPO               11/01
       //_aStru[n,3] = DECIMAL            12/01
       //_aStru[n,4] = CHAVE DE INDICE ?  13/01
       //_aStru[n,5] = POSICAO INICIAL    14/04
       //_aStru[n,6] = POSICAO final      18/04       
       //_aStru[n,7] = FORMULA            22/60
       //_aStru[n,8] = TABELA DE/PARA     82/10
       
    Endif

Next nCount

fclose(cArq)

Return

STATIC FUNCTION fAbreTab(cTabela)

Local tregs,m_mult,p_ant,p_atu,p_cnt
Local nPos1,nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando as Perguntas 									 			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArquivo   := cTabela
private nLinhas

If ! File(cArquivo)
    Help(" ",1,"A210NOPEN")
	 Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo texto informado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHandle := fOpen( cArquivo ,64)
If Ferror() #0 .or. nHandle < 0
    Help(" ",1,"A210NOPEN")
    Return( Nil )
Endif

TXT := fReadStr( nHandle,256 )
nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

aFile   := Directory( cArquivo )
nSize   := aFile[1,2]
nLinhas := Int(nSize/nBytes)

fSeek( nHandle,0,0 )


For nCount := 1 To nLinhas
    

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Lˆ cada linha do arquivo texto ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    TXT := fReadStr( nHandle,nBytes )

    // TABELA,CODIGO DE,CODIGO PARA 
    aAdd(_aTab,{cArquivo,ALLTRIM(Substr(TXT,1,12)),ALLTRIM(substr(TXT,13,12))})

 
Next nCount

fclose(nHandle)

Return


Return


Static Function fChkArqTxt(nCnt)


Local nHandle
Local lret := .f.

If File(cArquivo)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo texto informado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nHandle := fOpen( cArquivo ,64)

	If Ferror() # 0 .or. nHandle < 0
	    Help(" ",1,"A210NOPEN")
	    Return( Nil )
	Endif

	TXT := fReadStr( nHandle,256 )
	nBytes := (At( CHR(13)+CHR(10),TXT )) + 1

	aFile   := Directory( cArquivo )
	nSize   := aFile[1,2]
	nLinhas := Int(nSize/nBytes)

	nCnt := nLinhas

	fClose(nHandle)

	lret := .T.    

EndIf
    
Return(lRet)
