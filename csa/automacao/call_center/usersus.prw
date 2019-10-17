#Include 'rwmake.ch'   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �USERSUS   �Autor  �Microsiga           � Data �  07/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtro no cadastro de Prospect por operador                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function UserSUS()

Private aRotina   := {  { "Pesquisa"   			,"AxPesqui"  	, 0 ,1},;   // Pesquisar
						{ "Visualizar" 			,"AxVisual"		, 0 ,2},; 	// Visualizar						
						{ "Incluir"  			,"AxInclui"		, 0 ,3},; 	// Inclusao do Call Center
						{ "Alterar " 			,"AxAltera"		, 0 ,4},;   // Alteracao do Call Center    
						{ "Excluir " 			,"AxDeleta"	 	, 0 ,5}} 	// Excluir
						
Private cCadastro := "Prospects"
						
_cCodOpe := ""      
_cCond := ".T."
DbSelectArea("SU7")
DbSetOrder(4)              
DbGotop()
If DbSeek(xFilial("SU7")+__cUserId)
	_cCodOpe 	:= SU7->U7_COD                 
	_cVends		:= SU7->U7_CODVEN
	_cCond 		:= "SUS->US_FILIAL = '"+xFilial("SUS")+"' .And. SUS->US_VEND $ '"+_cVends+"' "
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
						
