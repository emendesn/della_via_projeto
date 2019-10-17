#Include 'rwmake.ch'   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³USER260   ºAutor  ³Microsiga           º Data ³  07/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtro no cadastro de Prospect por operador por grupo de   º±±
±±º          ³ atendimento.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function UserSUS2()

Private aRotina   := {  { "Pesquisa"   			,"AxPesqui"  	, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"AxVisual"		, 0 ,2},; 	// Visualizar						
						{ "Incluir"  			,"AxInclui"		, 0 ,3},; 	// Inclusao do Call Center
						{ "Alterar " 			,"AxAltera"		, 0 ,4},;   // Alteracao do Call Center    
						{ "Excluir " 			,"AxDeleta"	 	, 0 ,5}} 	// Excluir
						
Private cCadastro := "Prospects"

Private _cVends	 := "      &" 						
						
_cCodOpe := ""      
_cCond := ".T."
DbSelectArea("SU7")
DbSetOrder(4)              
DbGotop()
If DbSeek(xFilial("SU7")+__cUserId)

//	_cCodOpe := SU7->U7_COD                 
//	_cCond := "SUA->UA_FILIAL = '"+xFilial("SUA")+"' .And. SUA->UA_OPERADO = '"+_cCodOpe+"' "
	_cGrupo	:= SU7->U7_POSTO
	
Endif	                            

If !Empty(_cGrupo)
	_aAreaSU7	:= GetArea("SU7")
	_cGrupos	:= ""	
	DbSelectArea("SU7")
	DbGoTop()
	Do While !Eof()
		
		If SU7->U7_POSTO == _cGrupo
			_cGrupos 	+= SU7->U7_COD+"&"
			_cVends	    += SU7->U7_CODVEN+"&"
		Endif
		
		DbSkip()
	
	Enddo
	RestArea(_aAreaSU7)	
	
	If !Empty(_cVends)

		_cCond 		:= "SUS->US_FILIAL = '"+xFilial("SUS")+"' .And. SUS->US_VEND $ '"+_cVends+"' "
		
	Endif
	
Endif		

Dbselectarea("SUS")    
If !cNivel > 5
	Set Filter To &_cCond
Endif	

mBrowse(,,,,"SUS",,,,,,,,,1)

If !cNivel > 5
	Set Filter To
Endif	

Return .T.
						
