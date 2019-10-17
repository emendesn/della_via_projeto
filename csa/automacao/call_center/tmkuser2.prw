#Include 'rwmake.ch'
#INCLUDE "COLORS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKUSER2  �Autor  �Microsiga           � Data �  05/15/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para filtro de Atendimentos do Call Center/Televendas ���
���          � por Grupo de atendimentos                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TmkUser2()

Local _aEstru		:= {}   
Private cCadastro 	:= "Atendimentos"
Private aCores		:= {{"UA_STATUS='CAN'","BR_PRETO"},;
						{"UA_STATUS='LIB'","BR_AMARELO"},;
						{"UA_OPER='1' .And. Empty(UA_DOC)","BR_VERDE"},;
						{"UA_OPER='1' .And. !Empty(UA_DOC)","BR_VERMELHO"},;
						{"UA_OPER='2'","BR_AZUL"},;
						{"UA_OPER='3'","BR_MARROM"}} 						

Private aRotina   	:= {{ "Pesquisa"   			,"AxPesqui"  	, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"U_TkCallCenter", 0 ,2},; 	// Visualizar						
						{ "Incluir"  			,"U_TkCallCenter", 0 ,3},; 	// Inclusao do Call Center
						{ "Alterar " 			,"U_TkCallCenter", 0 ,4},;  // Alteracao do Call Center
						{ "Copiar " 			,"Tk271Copia"	 , 0 ,6},;  // Copiar
						{ "Legenda"    			,"U_TMKLegenda"  , 0 ,9}} 	// Legenda
						
Private _cVends	 	:= "      &" 						
Private bFiltraBrw 	:= {|| Nil}
Private aIndex		:= {}
Private _cCond		:= ""
						
_cCodOpe 	:= ""      
_cGrupo	    := ""
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
	
	If !Empty(_cGrupos)

		_cCond := "SUA->UA_FILIAL = '"+xFilial("SUA")+"' .And. SUA->UA_OPERADO $ '"+_cGrupos+"' "
		
	Endif
	
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


