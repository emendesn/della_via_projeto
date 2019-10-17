#Include 'rwmake.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ470FILE� Autor �Marcio Domingos     � Data �  05/05/06   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para filtrar arquivos magneticos da filial���
���          �                                                            ���
���          � Estrutura do nome do arquivo .NFT                          ���
���          �                                                            ���
���          � OODDNNNNNN.NFT                                             ���
���          � Onde:                                                      ���
���          � OO - Filial de Origem                                      ���
���          � DD - Filial de Destino                                     ���
���          � NNNNNN - Numero da NF                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Parametros�Nao se aplica												  ���  
�������������������������������������������������������������������������͹��
���Retorno   � _aRet = array com os arquivos .NFT da filial               ���
�������������������������������������������������������������������������͹��
���Aplicacao � P.E. na rotina Recebimento Meio Magn�tico                  ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LJ470FILE()
Local _cArq		:= "*.NFT"
Local _cDirGrv  := GetNewPar("MV_LJDIRGR", "" ) 
Local _aArq		:= {}  
Local _aRet		:= {}
Local _cFile            
Local _cRet		:= "??XX??????.NFT"       
Local _cDoc		:= ""
Local _cFornec	:= ""       
Local _aArea	:= GetArea()

_cFile 	:= 	_cDirGrv + _cArq
_aArq	:=	Directory(_cFile) // Array com todos os arquivos .NFT

For _n:=1 to Len(_aArq)
	If Substr(_aArq[_n][1],3,4) = cFilant  // Seleciono apenas os arquivos da filial corrente        
	
		DbSelectArea("SF1")
		DbSetOrder(1)         
		
		_cDoc		:= Substr(_aArq[_n][1],5,6)
		_cFornec    := "000500"+Substr(_aArq[_n][1],1,2)
		
		If !DbSeek(xFilial("SF1")+_cDoc+"UN "+_cFornec) // Verifica se a NF j� foi importada
	
			AADD(_aRet,{_aArq[_n][1],_aArq[_n][2],_aArq[_n][3],_aArq[_n][4],_aArq[_n][5]})  
			
		Else
			
			Conout("Nota Fiscal j� importada ! Filial: "+cFilant+" Nota:"+_cDoc+" Fornecedor:"+_cFornec)	
		
		Endif	
	
	Endif	
Next                        

RestArea(_aArea)

If Len(_aRet) > 0 // Se tiver arquivos da filial retorna array com arquivos
	Return _aRet  
Else            
	Return _cRet  // Se n�o encontrou arquivos da filial retorna string para apresentar mensagem de erro
Endif	
		
