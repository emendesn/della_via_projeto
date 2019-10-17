#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLJ430NF   บAutor  ณMarcelo Alcantara	 Data ณ  22/07/2005   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada na apos a geracao do arquivo de distrib 	  บฑฑ
ฑฑบ          ณaltera o nome do arquivo para:							  บฑฑ
ฑฑบ          ณFilialOrigem+filialDest+NumeroNota.NFT					  บฑฑ
ฑฑบ          ณe Copia o arquivo *.NFT para diretorio 					  บฑฑ
ฑฑบ          ณespecificado no parametro MV_DIRDIST                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDella Via Pneus.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function LJ430NF()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPARAMIXB:      ณ
//ณ	1-Numero da NFณ
//ณ	2-Serie da NF ณ
//ณ	3-Loja        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aArea	:=	GetArea()
//Local _cRotina	:=	""                                  

if PARAMIXB[1]== nil
	Return Nil   
endif
Private _cFileOri	:=	PARAMIXB[3] + PARAMIXB[1] //nome do arquivo de origem
Private _cFileDes	:= cFilAnt + PARAMIXB[3] + PARAMIXB[1] //nome do arquivo de destino filial de origem filial de destino e numero da nota

If FunName() # "LOJA430" //Se nao For o modulo de Distrib de Mercadoria
	Return Nil
Endif

// Pega Diretorio do Parametro e Copia o Arquivo
_cDirTransf:= GetMv("MV_LJDIRGR")

IF FRename(_cDirTransf + _cFileOri + ".NFT" , _cDirTransf + _cFileDes + ".NFT") < 0
   msgBox("  Nao foi possivel renomear o arquivo "+_cDirTransf + _cFileOri+", verifique os direitos de gravacao no diretorio ou o parametro MV_LJDIRGR " + AllTrim(Str(Ferror())) )
endif

// Imprime a NF no momento do processamento da nota (Alexandre)
If MsgYesNo("Deseja imprimir a Nota Fiscal agora?")
   U_RFATR01(PARAMIXB[1], PARAMIXB[1], PARAMIXB[2], 2)
Endif

RestArea(_aArea)
Return Nil