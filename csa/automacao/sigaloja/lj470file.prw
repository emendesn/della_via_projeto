#Include 'rwmake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LJ470FILEº Autor ³Marcio Domingos     º Data ³  05/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºLocacao   ³ Fab.Tradicional  ³Contato ³ mansano@microsiga.com.br       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para filtrar arquivos magneticos da filialº±±
±±º          ³                                                            º±±
±±º          ³ Estrutura do nome do arquivo .NFT                          º±±
±±º          ³                                                            º±±
±±º          ³ OODDNNNNNN.NFT                                             º±±
±±º          ³ Onde:                                                      º±±
±±º          ³ OO - Filial de Origem                                      º±±
±±º          ³ DD - Filial de Destino                                     º±±
±±º          ³ NNNNNN - Numero da NF                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³Nao se aplica												  º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ _aRet = array com os arquivos .NFT da filial               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ P.E. na rotina Recebimento Meio Magnético                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 13797 - Dellavia Pneus                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista  ³Data    ³Bops  ³Manutencao Efetuada                   	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		
		If !DbSeek(xFilial("SF1")+_cDoc+"UN "+_cFornec) // Verifica se a NF já foi importada
	
			AADD(_aRet,{_aArq[_n][1],_aArq[_n][2],_aArq[_n][3],_aArq[_n][4],_aArq[_n][5]})  
			
		Else
			
			Conout("Nota Fiscal já importada ! Filial: "+cFilant+" Nota:"+_cDoc+" Fornecedor:"+_cFornec)	
		
		Endif	
	
	Endif	
Next                        

RestArea(_aArea)

If Len(_aRet) > 0 // Se tiver arquivos da filial retorna array com arquivos
	Return _aRet  
Else            
	Return _cRet  // Se não encontrou arquivos da filial retorna string para apresentar mensagem de erro
Endif	
		
