#Include 'rwmake.ch'
#INCLUDE "COLORS.CH"

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

User Function TmkUser()

Local _aEstru	:= {}   
Private cCadastro := "Atendimentos"                 
Private bFiltraBrw 	:= {|| Nil}
Private aIndex		:= {}
Private aCores	:= {  	{"UA_STATUS='CAN'","BR_PRETO"},;
						{"UA_STATUS='LIB'","BR_AMARELO"},;
						{"UA_OPER='1' .And. Empty(UA_DOC)","BR_VERDE"},;
						{"UA_OPER='1' .And. !Empty(UA_DOC)","BR_VERMELHO"},;
						{"UA_OPER='2'","BR_AZUL"},;
						{"UA_OPER='3'","BR_MARROM"}}           
						

Private aRotina   := {  { "Pesquisa"   			,"AxPesqui"  	, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"U_TkCallCenter", 0 ,2},; 	// Visualizar						
						{ "Incluir"  			,"U_TkCallCenter", 0 ,3},; 	// Inclusao do Call Center
						{ "Alterar " 			,"U_TkCallCenter", 0 ,4},;   // Alteracao do Call Center    
						{ "Copiar " 			,"Tk271Copia"	 , 0 ,6},;  // Copiar						
						{ "Legenda"    			,"U_TMKLegenda"  , 0 ,9}} 	// Legenda
						
Private _cVends	 	:= "" 			
Private _cCond		:= ""
            
_cCodOpe := ""      
DbSelectArea("SU7")
DbSetOrder(4)              
DbGotop()
If DbSeek(xFilial("SU7")+__cUserId)
	_cCodOpe 	:= SU7->U7_COD
	_cVends		:= SU7->U7_CODVEN
	_cCond 		:= "SUA->UA_FILIAL = '"+xFilial("SUA")+"' .And. SUA->UA_OPERADO = '"+_cCodOpe+"' "
Endif	                            

Dbselectarea("SUA")    
If !cNivel > 5
//	Set Filter To &_cCond
	bFiltraBrw := {|| FilBrowse("SUA",@aIndex,@_cCond) }
	Eval(bFiltraBrw)
Endif	
mBrowse(,,,,"SUA",,,,,,aCores,,,1)
If !cNivel > 5
	Set Filter To
Endif	

Return .T.


User Function TkCallCenter(cAlias,nReg,nOpc)

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


User Function TMKlegenda()

Local _aLegenda := {} //SITUACOES DO ATENDIMENTO
Local _aArea	:= GetArea()


AADD(_aLegenda,{ 'BR_MARROM'		,'Atendimento'})
AADD(_aLegenda,{ 'BR_AZUL' 			,'Orcamento'})
AADD(_aLegenda,{ 'BR_AMARELO' 		,'Pedido Liberado'})
AADD(_aLegenda,{ 'BR_VERDE'   		,'Faturamento'})
AADD(_aLegenda,{ 'BR_VERMELHO'   	,'NF. Emitida'})
AADD(_aLegenda,{ 'BR_PRETO'   		,'Orc. Cancelado'})


BrwLegenda(cCadastro,'Legenda',_aLegenda)
                            
RestArea(_aArea)
Return


