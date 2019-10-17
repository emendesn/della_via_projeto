#Include 'rwmake.ch'
#INCLUDE "COLORS.CH"
#Include 'Tbiconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKUSER   ºAutor  ³Marcio Domingos     º Data ³  05/15/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para filtro de Atendimentos do Call Center/Televendas º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TmkUserB()

Local _aEstru		:= {}   
Local aCposBrw  	:= {}      
Local _cCposBrw		:= ""
Local cQuery		:= ""

Private cEnter := Chr(13)
Private cCadastro 	:= "Atendimentos"
Private aCores		:= {  	{"UA_STATUS='CAN'","BR_PRETO"},;
							{"UA_STATUS='LIB'","BR_AMARELO"},;
							{"UA_OPER='1' .And. Empty(UA_DOC)","BR_VERDE"},;
							{"UA_OPER='1' .And. !Empty(UA_DOC)","BR_VERMELHO"},;
							{"UA_OPER='2'","BR_AZUL"},;
							{"UA_OPER='3'","BR_MARROM"}}           
						
                        
						//{ "Pesquisa"   			,"AxPesqui"  	, 0 ,1},;   // Pesquisar
Private aRotina   := {  { "Visualizar" 			,"U_TkCall", 0 ,2},; 	// Visualizar						
						{ "Incluir"  			,"U_TkCall", 0 ,3},; 	// Inclusao do Call Center
						{ "Alterar " 			,"U_TkCall", 0 ,4},;   // Alteracao do Call Center    
						{ "Copiar " 			,"Tk271Copia"	 , 0 ,6},;  // Copiar						
						{ "Legenda"    			,"U_TMKLegenda"  , 0 ,9}} 	// Legenda
						
Private _cVends	 := "" 			

/*
aCposBrw :=  {	{ STR0006, {|| TRB->TRB_CHAVE  }, 'C', Len( SX5->X5_CHAVE )  , 0, '@! ' },; //'Grupo'
               { STR0007, {|| TRB->TRB_DESCRI }, 'C', Len( SX5->X5_DESCRI ) , 0, '@! ' }}  //'Depositos'
*/
                                            
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "LOJA" TABLES "SUA","SX3","SU7"

DbSelectArea("SX3")
DbSetOrder(1)
DbGoTop()
DbSeek("SUA")

Do While 	X3_ARQUIVO == "SUA" .And. !Eof()

	If X3_BROWSE = "S" .And. X3_CONTEXT <> "V"
		AADD(aCposBrw,{Rtrim(X3_TITULO),"{||"+Rtrim(X3_CAMPO)+"}",X3_TIPO,X3_TAMANHO,X3_DECIMAL,X3_PICTURE})
		_cCposBrw	+= Rtrim(X3_CAMPO)+", "
	Endif
	
	DbSkip()	

Enddo                              
_cCposBrw := Substr(_cCposBrw,1,Len(_cCposBrw)-2)
            
_cCodOpe := ""      
_cCond := ".T."
DbSelectArea("SU7")
DbSetOrder(4)              
DbGotop()
If DbSeek(xFilial("SU7")+__cUserId)
	_cCodOpe 	:= SU7->U7_COD
	_cVends		:= SU7->U7_CODVEN
	_cCond 		:= "SUA->UA_FILIAL = '"+xFilial("SUA")+"' .And. SUA->UA_OPERADO = '"+_cCodOpe+"' "
Endif	                            

Dbselectarea("SUA")    
/*
If !cNivel > 5
	Set Filter To &_cCond
Endif	
*/

cQuery 	+= "SELECT "+_cCposBrw //+cEnter
cQuery	+= " FROM "+RetSQLName("SUA") //+cEnter
cQuery	+= " WHERE UA_FILIAL = '"+xFilial("SUA")+"' AND UA_OPERADO = '"+_cCodOpe+"' " //+cEnter
cQuery	+= " AND D_E_L_E_T_ = ' '" //+cEnter

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

mBrowse(,,,,"QRY",aCposBrw,,,,,aCores,,,)
//mBrowse( 6, 1,22,75,"TRB",aCposBrw,,,,,,"M075aFilIni","M075aFilEnd")

/*
If !cNivel > 5
	Set Filter To
Endif	
*/

Return .T.


User Function TkCall(cAlias,nReg,nOpc)

If nOpc == 3      
    
	lInclui 	:= .T.            
	lAltera 	:= .F.
	TK271CallCenter(cAlias,SUA->(Recno()),3,Nil,Nil,Nil,Nil)
	
	
ElseIf nOpc == 4  
                                   
	lAltera 	:= .T.
	lInclui 	:= .F.

	TK271CallCenter(cAlias,SUA->(Recno()),nOpc,Nil,Nil,Nil,Nil)
	
//	TkGetTipoAte("1")	
	                                                           
Else                                                           

	lAltera 	:= .F.
	lInclui 	:= .F.

	TK271CallCenter(cAlias,SUA->(Recno()),nOpc,Nil,Nil,Nil,Nil)	
  
//	TkGetTipoAte("1")	
	
Endif	

If !cNivel > 5
	Set Filter To &_cCond
Endif	

		 
Return .T.


