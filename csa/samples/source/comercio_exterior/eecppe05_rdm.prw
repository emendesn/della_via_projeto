#INCLUDE "EECPPE05.ch"
/*
Programa        : EECPPE05.PRW
Objetivo        : Impressao da Proforma Comercial
Autor           : Heder M Oliveira
Data/Hora       : 17/04/00 10:57
Obs.            : 
*/

/*
considera que estah posicionado no registro de processos (pedidos) (EE7)
*/

#include "EECRDM.CH"

/*
Funcao      : EECPPE05
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder
Data/Hora   : 
Revisao     :
Obs.        :
*/
User Function EECPPE05

Local lRet := .T.

// Alterado por Heder M Oliveira - 1/20/2000
// Declara variaveis utilizadas ...
Local lIngles := "INGLES" $ Upper(WorkId->EEA_IDIOMA)
   
Local nAlias := Select()
Local aOrd   := SaveOrd({"EE8","EE2"})
Local cMemo

Private cPict      := if(lIngles,"999,999,999.99","@E 999,999,999.99")

//* by JBJ - 27/06/2001 - 16:31

Private cPictDecPrc, cPictDecPes,;
        cPictDecQtd, cPictPreco ,;
        cPictPeso  , cPictQtde        

If Type ("EE7->EE7_DECPRC") == "N"
   cPictDecPrc := if(EE7->EE7_DECPRC > 0, "."+Replic("9",EE7->EE7_DECPRC),"")
   cPictPreco  := "9,999" +cPictDecPrc
Else
   cPictPreco  := if(lIngles,"9,999","@E 9,999")+".999"
EndIf
     
If Type("EE7->EE7_DECPES") == "N"
   cPictDecPes := if(EE7->EE7_DECPES > 0, "."+Replic("9",EE7->EE7_DECPES),"")
   cPictPeso   := "9,999,999"+cPictDecPes
Else  
   cPictPeso   := "9,999,999.999"
Endif

If Type("EE7->EE7_DECQTD") == "N"
   cPictDecQtd := if(EE7->EE7_DECQTD > 0, "."+Replic("9",EE7->EE7_DECQTD),"")
   cPictQtde  := "9,999,999"+cPictDecQtd
Else
   cPictQtde  := "9,999,999.99"
EndIf

//* JBJ (FIM)

Private lNcm := .f., lPesoBru := .f.
Private cExp_Cod, cEXP_NOME, cEXP_CONTATO, cEXP_FONE, cEXP_FAX, cEXP_CARGO   
Private cC1360,cC3160,cC2160,cC2260,cC2360,cC2460,cC2960,cC3060
Private cDTPROF
Private cObs   := ""

// USADO NO EECF3EE3 VIA SXB "E34" PARA GET ASSINANTE
Private cSEEKEXF:="", cSEEKLOJE:=""

Begin Sequence
   EE2->(dbSetOrder(1))
   EE8->(dbSetOrder(1)) // FILIAL+PEDIDO
   EE8->(dbSeek(xFilial()+EE7->EE7_PEDIDO))
   
   //regras para carregar dados
   IF !EMPTY(EE7->EE7_EXPORT)
      cExp_Cod     := EE7->EE7_EXPORT+EE7->EE7_EXLOJA
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+EE7->EE7_EXPORT+EE7->EE7_EXLOJA,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",1)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",4)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",7)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_EXPORT,EE7->EE7_EXLOJA,"1",2)  //CARGO
      M->cSEEKEXF  := EE7->EE7_EXPORT
      M->cSEEKLOJA := EE7->EE7_EXLOJA
   ELSE
      cExp_Cod     := EE7->EE7_FORN+EE7->EE7_FOLOJA
      cEXP_NOME    := Posicione("SA2",1,xFilial("SA2")+cEXP_COD,"A2_NOME")
      cEXP_CONTATO := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",1,EE7->EE7_RESPON)  //nome do contato seq 1
      cEXP_FONE    := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",4,EE7->EE7_RESPON)  //fone do contato seq 1
      cEXP_FAX     := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",7,EE7->EE7_RESPON)  //fax do contato seq 1
      cEXP_CARGO   := EECCONTATO(CD_SA2,EE7->EE7_FORN,EE7->EE7_FOLOJA,"1",2,EE7->EE7_RESPON)  //CARGO
      M->cSEEKEXF  := EE7->EE7_FORN
      M->cSEEKLOJA := EE7->EE7_FOLOJA
   ENDIF
   
   cC1360 := SPACE(40)
   cC3160 := SPACE(40)
   
   cC2160 := EE7->EE7_IMPODE
   cC2260 := EE7->EE7_ENDIMP
   cC2360 := EE7->EE7_END2IM
   cC2460 := SPACE(60)
   cC2960 := SPACE(60)
   cC3060 := SPACE(60)
   
   IF LEFT(EE7->EE7_IDIOMA,5)=="CAST." .OR. LEFT(EE7->EE7_IDIOMA,5)=="ESP. "
      cDTPROF := AllTrim(Str(Day(dDATABASE)))+", "+Padr(DICIDMES({Left(EE7->EE7_IDIOMA,6),dDATABASE,.F.})+" DE "+Str(Year(dDATABASE),4),25)
   ELSE      
      cDTPROF := Padr(DICIDMES({Left(EE7->EE7_IDIOMA,6),dDATABASE,.F.})+" "+AllTrim(Str(Day(dDATABASE)))+", "+Str(Year(dDATABASE),4),25) 
   ENDIF
   
   // dar get do titulo e das mensagens ...
   IF ! TelaGets()
      lRet := .f.
      Break
   Endif
   
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()
   
   //adicionar registro no HEADER_P
   HEADER_P->(DBAPPEND())
   
   HEADER_P->AVG_FILIAL:=xFilial("SY0")
   HEADER_P->AVG_SEQREL:=cSEQREL
   HEADER_P->AVG_CHAVE :=EE7->EE7_PEDIDO //nr. do processo
   
   //Dados do Exportador/Fornecedor
   HEADER_P->AVG_C01_60:=ALLTRIM(cEXP_NOME) // TITULO 1
   HEADER_P->AVG_C02_60:=ALLTRIM(SA2->A2_END)
   HEADER_P->AVG_C03_60:=ALLTRIM(SA2->A2_EST+" "+AllTrim(BuscaPais(SA2->A2_PAIS))+" CEP: "+Transf(SA2->A2_CEP,AVSX3("A2_CEP",6)))
   HEADER_P->AVG_C04_60:=ALLTRIM("TEL.: "+AllTrim(cEXP_FONE)+" FAX: "+AllTrim(cEXP_FAX))
   
   //Informacoes do Cabecalho    
   HEADER_P->AVG_C06_60 := AllTrim(SA2->A2_MUN)+", "+Upper(DicIdMes({Left(EE7->EE7_IDIOMA,6),dDataBase}))+" "+StrZero(Day(dDATABASE),2)+", "+Str(Year(dDATABASE),4)+"."
   //   HEADER_P->AVG_C01_20 := EE7->EE7_NRCONH
   HEADER_P->AVG_C02_20 := EE7->EE7_PEDIDO
   
   // TO
   HEADER_P->AVG_C07_60 := EE7->EE7_IMPODE
   HEADER_P->AVG_C08_60 := EE7->EE7_ENDIMP
   HEADER_P->AVG_C09_60 := EE7->EE7_END2IM
   
   // Consignee
   HEADER_P->AVG_C10_60 := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_CONSIG+EE7->EE7_COLOJA,"A1_NOME")
   HEADER_P->AVG_C11_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,58,1)
   HEADER_P->AVG_C12_60 := EECMEND("SA1",1,EE7->EE7_CONSIG+EE7->EE7_COLOJA,.T.,60,2)
   
   //DATA PROFORMA
   HEADER_P->AVG_C05_30 := cDTPROF
   
   // Titulos ...
   HEADER_P->AVG_C01_10 := EE7->EE7_MOEDA
   HEADER_P->AVG_C02_10 := "KG" // EE8->EE8_UNIDAD
   
   //PACKING
   HEADER_P->AVG_C13_60 := cC1360
   HEADER_P->AVG_C31_60 := cC3160
   
   // Pesos/Cubagem
   //   HEADER_P->AVG_C03_20 := AllTrim(Transf(EE7->EE7_PESLIQ,cPICT))  //AVSX3("EE7_PESLIQ",6))
   //   HEADER_P->AVG_C04_20 := AllTrim(Transf(EE7->EE7_PESBRU,cPICT))  //AVSX3("EE7_PESBRU",6))

   HEADER_P->AVG_C03_20 := AllTrim(Transf(EE7->EE7_PESLIQ,cPictPeso))  
   HEADER_P->AVG_C04_20 := AllTrim(Transf(EE7->EE7_PESBRU,cPictPeso))  
   cPictCub := AllTrim(StrTran(Upper(AVSX3("EE7_CUBAGE",6)),"@E",""))
   HEADER_P->AVG_C05_20 := Transf(EE7->EE7_CUBAGE,cPictCub)  //AVSX3("EE7_CUBAGE",6))
   
   // TOTAIS
   nFobValue := (EE7->EE7_TOTPED+EE7->EE7_DESCON)-(EE7->EE7_FRPREV+EE7->EE7_FRPCOM+EE7->EE7_SEGPRE+EE7->EE7_DESPIN+AvGetCpo("EE7->EE7_DESP1")+AvGetCpo("EE7->EE7_DESP2"))
   //HEADER_P->AVG_C12_20 := Transf(nFobValue,AVSX3("EE7_TOTPED",6))
   
   HEADER_P->AVG_C14_20 := Transf(nFobValue,cPICT)  //AVSX3("EE7_TOTPED",6))
   HEADER_P->AVG_C15_20 := Transf(EE7->EE7_FRPREV,cPICT)  //AVSX3("EE7_FRPREV",6))
   HEADER_P->AVG_C16_20 := Transf(EE7->EE7_SEGPRE,cPICT)  //AVSX3("EE7_SEGPRE",6))
   HEADER_P->AVG_C17_20 := Transf((EE7->EE7_FRPCOM+EE7->EE7_DESPIN+AvGetCpo("EE7->EE7_DESP1")+AvGetCpo("EE7->EE7_DESP2"))-EE7->EE7_DESCON,cPict)
   HEADER_P->AVG_C18_20 := Transf(EE7->EE7_TOTPED,cPICT)  //AVSX3("EE7_TOTPED",6))
   
   HEADER_P->AVG_C03_10 := EE7->EE7_INCOTE
   
   // pais de origem
   HEADER_P->AVG_C01_30 := Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_NOIDIOM")
   
   // VIA
   SYQ->(dbSetOrder(1))
   SYQ->(dbSeek(xFilial()+EE7->EE7_VIA))
   
   HEADER_P->AVG_C02_30 := IF(Left(SYQ->YQ_COD_DI,1) == "4",IF(lIngles,"BY AIR","CORRETO AEREA"),SYQ->YQ_DESCR) // VIA
   
   //CASE PARA HEADER_P->AVG_C03_30
   IF Left(SYQ->YQ_COD_DI,1) == "1" // MARITIMO
      HEADER_P->AVG_C05_10:="FOB"
   Else 
      HEADER_P->AVG_C05_10:="FCA"
   Endif
   
   SYR->(dbSeek(xFilial()+EE7->EE7_VIA+EE7->EE7_ORIGEM+EE7->EE7_DEST+EE7->EE7_TIPTRA))
   
   IF Posicione("SYJ",1,xFilial("SYJ")+EE7->EE7_INCOTE,"YJ_CLFRETE") $ cSim
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // Porto de Destino
   Else
      HEADER_P->AVG_C13_20 := AllTrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR"))  // Porto de Origem
   Endif
   
   // Port of Unloading
   HEADER_P->AVG_C04_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_DESCR")) // +" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_DESTINO,"Y9_PAIS")))
   // Port of Loading
   HEADER_P->AVG_C03_30 := alltrim(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_DESCR")) //+" "+AllTrim(BuscaPais(Posicione("SY9",2,xFilial("SY9")+SYR->YR_ORIGEM,"Y9_PAIS")))
   
   // MARKS
   cMemo := MSMM(EE7->EE7_CODMAR,AVSX3("EE7_MARCAC",AV_TAMANHO))
   HEADER_P->AVG_C06_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),1)
   HEADER_P->AVG_C07_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),2)
   HEADER_P->AVG_C08_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),3)
   HEADER_P->AVG_C09_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),4)
   HEADER_P->AVG_C10_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),5)
   HEADER_P->AVG_C11_20 := MemoLine(cMemo,AVSX3("EE7_MARCAC",AV_TAMANHO),6)
   
   //DOCUMENTS
   HEADER_P->AVG_C21_60 := cC2160
   HEADER_P->AVG_C22_60 := cC2260
   HEADER_P->AVG_C23_60 := cC2360
   HEADER_P->AVG_C24_60 := cC2460
   HEADER_P->AVG_C29_60 := cC2960
   HEADER_P->AVG_C30_60 := cC3060
   
   // Cond.Pagto ...
   HEADER_P->AVG_C01100 := SY6Descricao(EE7->EE7_CONDPA+Str(EE7->EE7_DIASPA,AVSX3("EE7_DIASPA",3),AVSX3("EE7_DIASPA",4)),EE7->EE7_IDIOMA,1) // Terms of Payment
   
   // I/L
   HEADER_P->AVG_C25_60 := EE7->EE7_LICIMP
   // L/C
   HEADER_P->AVG_C04_10 := EE7->EE7_LC_NUM
   
   // RODAPE
   HEADER_P->AVG_C26_60 := cEXP_NOME
   
   HEADER_P->AVG_C27_60 := cEXP_CONTATO
   HEADER_P->AVG_C28_60 := cEXP_CARGO
   
   HEADER_P->AVG_C01150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),1)
   HEADER_P->AVG_C02150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),2)
   HEADER_P->AVG_C03150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),3)
   HEADER_P->AVG_C04150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),4)
   HEADER_P->AVG_C05150 := MemoLine(cObs,AVSX3("EE4_VM_TEX",3),5)
   
   GravaItens()
         
   HEADER_P->(dbUnlock())
   
   HEADER_H->(dbAppend())
   AvReplace("HEADER_P","HEADER_H")
   HEADER_H->(dbUnlock())
End Sequence   

RestOrd(aOrd)
Select(nAlias)

Return lRet

/*
Funcao      : GravaItens
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : Heder
Data/Hora   : 
Revisao     :
Obs.        :
*/
Static Function GravaItens()

Local nTotQtde := 0, nTotal   := 0
Local cUnidade := "", cNcm, bCond
Local cMemo, i, cNotas

IF lNcm
   bCond := {|| EE8->EE8_POSIPI == cNcm }
Else
   bCond := {|| .t. }
Endif

While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And.;
      EE8->EE8_PEDIDO == EE7->EE7_PEDIDO

   IF lNcm
      cNcm := EE8->EE8_POSIPI
      
      IF cUnidade <> EE8->EE8_UNIDAD  
         cUnidade := EE8->EE8_UNIDAD
         AppendDet()

         IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+ALLTRIM(EE8->EE8_UNIDAD)))
            MsgStop(STR0001+EE8->EE8_UNIDAD+STR0002+EE7->EE7_IDIOMA,STR0003) //"Unidade de medida "###" n�o cadastrada em "###"Aviso"
         Endif
         DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA

         UnlockDet()
      Endif   
      
      AppendDet()
      DETAIL_P->AVG_C01_60 := Transf(EE8->EE8_POSIPI,AVSX3("EE8_POSIPI",6))
      UnlockDet()
      
      AppendDet()
      DETAIL_P->AVG_C01_60 := Replic("-",25)
      UnlockDet()
   Endif
   
   While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And.;
         EE8->EE8_PEDIDO == EE7->EE7_PEDIDO .And. ;
         Eval(bCond)
         
      IF cUnidade <> EE8->EE8_UNIDAD  
         cUnidade := EE8->EE8_UNIDAD
         AppendDet()

         IF ! EE2->(Dbseek(xFilial("EE2")+"8"+"*"+EE7->EE7_IDIOMA+ALLTRIM(EE8->EE8_UNIDAD)))
            MsgStop(STR0001+EE8->EE8_UNIDAD+STR0002+EE7->EE7_IDIOMA,STR0003) //"Unidade de medida "###" n�o cadastrada em "###"Aviso"
         Endif
         DETAIL_P->AVG_C06_20 := AllTrim(EE7->EE7_MOEDA)+"/"+EE2->EE2_DESCMA

         UnlockDet()
      Endif   
      
      AppendDet()
      DETAIL_P->AVG_C01_20 := Transf(EE8->EE8_SLDINI,cPictQtde)
      DETAIL_P->AVG_C02_20 := Transf(EE8->EE8_COD_I,AVSX3("EE8_COD_I",6))
      DETAIL_P->AVG_C03_20 := Alltrim(EE8->EE8_REFCLI)
      
      cMemo := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
      
      DETAIL_P->AVG_C01_60 := MemoLine(cMemo,AVSX3("EE8_VM_DES",3),1)
      DETAIL_P->AVG_C04_20 := AllTrim(Transf(EE8->EE8_PSLQTO,cPictPeso))
      
      IF lPesoBru
         DETAIL_P->AVG_C05_20 := AllTrim(Transf(EE8->EE8_PSBRTO,cPictPeso))
      ENDIF
      
      DETAIL_P->AVG_C06_20 := AllTrim(Transf(EE8->EE8_PRECO,cPictPreco))
      DETAIL_P->AVG_C07_20 := AllTrim(Transf(EE8->EE8_PRCINC,cPict))
      
      For i := 2 To MlCount(cMemo,AVSX3("EE8_VM_DES",3))
         IF !EMPTY(MemoLine(cMemo,AVSX3("EE8_VM_DES",3),i))
            UnlockDet()
            AppendDet()
            DETAIL_P->AVG_C01_60 := MemoLine(cMemo,AVSX3("EE8_VM_DES",3),i)
         ENDIF
      Next
      
      nTotQtde := nTotQtde+EE8->EE8_SLDINI
      nTotal   := nTotal  +EE8->EE8_PRCINC
      
      UnlockDet()
      
      EE8->(dbSkip())         
   Enddo
Enddo

AppendDet()
DETAIL_P->AVG_C01_20 := Replic("-",20)
DETAIL_P->AVG_C04_20 := Replic("-",20)
DETAIL_P->AVG_C05_20 := Replic("-",20)
DETAIL_P->AVG_C07_20 := Replic("-",20)
UnlockDet()

AppendDet()
DETAIL_P->AVG_C01_20 := Transf(nTotQtde,cPictQtde)
DETAIL_P->AVG_C04_20 := Transf(EE7->EE7_PESLIQ,cPictPeso)
DETAIL_P->AVG_C05_20 := Transf(EE7->EE7_PESBRU,cPictPeso)
DETAIL_P->AVG_C07_20 := Transf(nTotal,cPict)
UnlockDet()

HEADER_P->AVG_C12_20 := Transf(nTotal,cPict)

Return NIL

/*
Funcao      : AppendDet
Parametros  : 
Retorno     : 
Objetivos   : Adiciona registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function AppendDet()

Begin Sequence
   DETAIL_P->(dbAppend())
   DETAIL_P->AVG_FILIAL := xFilial("SY0")
   DETAIL_P->AVG_SEQREL := cSEQREL
   DETAIL_P->AVG_CHAVE  := EE7->EE7_PEDIDO //nr. do processo
End Sequence

Return NIL

/*
Funcao      : UnlockDet
Parametros  : 
Retorno     : 
Objetivos   : Desaloca registros no arquivo de detalhes
Autor       : Cristiano A. Ferreira 
Data/Hora   : 05/05/2000
Revisao     : 
Obs.        :
*/
Static Function UnlockDet()

Begin Sequence
   DETAIL_P->(dbUnlock())
   
   DETAIL_H->(dbAppend())
   AvReplace("DETAIL_P","DETAIL_H")
   DETAIL_H->(dbUnlock())
End Sequence

Return NIL

/*
Funcao      : TelaGets
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira 
              03/05/2000 - Protheus
Obs.        :
*/
Static Function TelaGets

Local lRet := .f.
Local nOpc := 0

Local bOk     := {|| nOpc:=1,oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local bSet  := {|x,o| lNcm := x, o:Refresh(), lNcm }
Local bSetP := {|x,o| lPesoBru := x, o:Refresh(), lPesoBru }

Local oDlg, oFld
Local oFldDoc, oBtnOk, oBtnCancel
Local oYes, oNo, oYesP, oNoP, oMark

Local xx := ""

Private cMarca := GetMark(), nMarcado := 0

Begin Sequence
   
   DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 9,0 TO 28,80 OF oMainWnd
       
     oFld := TFolder():New(1,1,{STR0004,STR0005},{STR0006,STR0007},oDlg,,,,.T.,.F.,315,127) //"Documentos Para"###"Observa��es"###"IPC"###"OBS"
     
     aEval(oFld:aDialogs,{|x| x:SetFont(oDlg:oFont) })
     //oFld:SetOption(1)
     
     oFldDoc := oFld:aDialogs[1]
     
     @ 10,001 SAY STR0008 OF oFldDoc SIZE 232,10 PIXEL //"Imprime N.C.M."
          
     oYes := TCheckBox():New(10,42,STR0009,{|x| If(PCount()==0, lNcm,Eval(bSet,x,oNo))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNo  := TCheckBox():New(10,65,STR0010,{|x| If(PCount()==0,!lNcm,Eval(bSet,!x,oYes))},oFldDoc,21,10,,,,,,,,.T.) //"N�o"
     
     @ 10,100 SAY STR0011 OF oFldDoc SIZE 232,10 PIXEL //"Imprime Peso Bruto"
     
     oYesP := TCheckBox():New(10,157,STR0009,{|x| If(PCount()==0,lPesoBru,Eval(bSetP, x,oNoP ))},oFldDoc,21,10,,,,,,,,.T.) //"Sim"
     oNoP  := TCheckBox():New(10,180,STR0010,{|x| If(PCount()==0,!lPesoBru,Eval(bSetP,!x,oYesP))},oFldDoc,21,10,,,,,,,,.T.) //"N�o"

     M->cCONTATO:=EE7->EE7_RESPON  //cEXP_CONTATO
     M->cEXP_CARGO:= "EXPORT COORDINATOR"
      
     @ 20,001 SAY STR0012 OF oFldDoc SIZE 232,10 PIXEL //"Assinante"
     @ 20,043 GET M->cContato OF oFldDoc SIZE 120,08 PIXEL
     
     @ 20,180 SAY STR0013 OF oFldDoc SIZE 232,10 PIXEL //"Embalagem"
     @ 20,220 GET cC1360 OF oFldDoc SIZE 80,08 PIXEL 
     @ 30,220 GET cC3160 OF oFldDoc SIZE 80,08 PIXEL 
     
     @ 30,001 SAY STR0014 OF oFldDoc SIZE 232,10 PIXEL //"Cargo"
     @ 30,043 GET M->cEXP_CARGO OF oFldDoc SIZE 120,08 PIXEL 

     @ 44,001 SAY STR0015 OF oFldDoc SIZE 232,10 PIXEL //"Doct.Para"
     
     @ 44,043 GET cC2160 OF oFldDoc SIZE 120,08 PIXEL
     @ 54,043 GET cC2260 OF oFldDoc SIZE 120,08 PIXEL
     @ 64,043 GET cC2360 OF oFldDoc SIZE 120,08 PIXEL
     @ 74,043 GET cC2460 OF oFldDoc SIZE 120,08 PIXEL
     @ 84,043 GET cC2960 OF oFldDoc SIZE 120,08 PIXEL
     @ 94,043 GET cC3060 OF oFldDoc SIZE 120,08 PIXEL
     
     @ 14,043 GET xx OF oFld:aDialogs[2]     
     oMark := Observacoes("New")
     
     oMark:oBrowse:Hide()
     oFld:bChange := {|nOption| IF(nOption==2,(oMark:oBrowse:Show(),oMark:oBrowse:SetFocus()),oMark:oBrowse:Hide()) }

     DEFINE SBUTTON oBtnOk FROM 130,258 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
     DEFINE SBUTTON oBtnCancel FROM 130,288 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

   ACTIVATE MSDIALOG oDlg CENTERED
   
   lRet := (nOpc == 1)
   cEXP_CONTATO := M->cCONTATO

End Sequence

Observacoes("End")

Return lRet

/*
Funcao      : Observacoes
Parametros  : cAcao := New/End
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira 
              04/05/2000 - Protheus
Obs.        :
*/
Static Function Observacoes(cAcao,oDlg)

Local xRet := nil

Local cPaisEt := Posicione("SA1",1,xFilial("SA1")+EE7->EE7_IMPORT+EE7->EE7_IMLOJA,"A1_PAIS")
Local nAreaOld, aOrd, aSemSx3
Local cTipMen, cIdioma, cTexto, i

Local oMark
Local lInverte := .F.

Static aOld

Begin Sequence
   cAcao := Upper(AllTrim(cAcao))

   IF cAcao == "NEW"
      aOrd := SaveOrd({"EE4","EE1"})
      
      EE1->(dbSetOrder(1))
      EE4->(dbSetOrder(1))
      
      Private aHeader := {}, aCAMPOS := array(EE4->(fcount()))
      aSemSX3 := { {"WKMARCA","C",02,0},{"WKTEXTO","M",10,0}}

      aOld := {Select(), E_CriaTrab("EE4",aSemSX3,"WkMsg")}

      EE1->(dbSeek(xFilial()+TR_MEN+cPAISET))
      
      While !EE1->(Eof()) .And. EE1->EE1_FILIAL == xFilial("EE1") .And.;
            EE1->EE1_TIPREL == TR_MEN .And.;
            EE1->EE1_PAIS == cPAISET
            
         cTipMen := EE1->EE1_TIPMEN+"-"+Tabela("Y8",AVKEY(EE1->EE1_TIPMEN,"X5_CHAVE"))
         cIdioma := Posicione("SYA",1,xFilial("SYA")+EE1->EE1_PAIS,"YA_IDIOMA")
         
         IF EE4->(dbSeek(xFilial()+AvKey(EE1->EE1_DOCUM,"EE4_COD")+AvKey(cTipMen,"EE4_TIPMEN")+AvKey(cIdioma,"EE4_IDIOMA")))
            WkMsg->(dbAppend())
            cTexto := MSMM(EE4->EE4_TEXTO,AVSX3("EE4_VM_TEX",3))
         
            For i:=1 To MlCount(cTexto,AVSX3("EE4_VM_TEX",3))
               WkMsg->WKTEXTO := WkMsg->WKTEXTO+MemoLine(cTexto,AVSX3("EE4_VM_TEX",3),i)+ENTER
            Next     
         
            WkMsg->EE4_TIPMEN := EE4->EE4_TIPMEN
            WkMsg->EE4_COD    := EE4->EE4_COD
         ENDIF
         
         EE1->(dbSkip())
      Enddo
      
      dbSelectArea("WkMsg")
      WkMsg->(dbGoTop())

      aCampos := { {"WKMARCA",," "},;
                   ColBrw("EE4_COD","WkMsg"),;
                   ColBrw("EE4_TIPMEN","WkMsg"),;
                   {{|| MemoLine(WkMsg->WKTEXTO,AVSX3("EE4_VM_TEX",AV_TAMANHO),1)},"",AVSX3("EE4_VM_TEX",AV_TITULO)}}
                       
      oMark := MsSelect():New("WkMsg","WKMARCA",,aCampos,lInverte,@cMarca,{18,3,125,312}) //{1,1,110,315})
      oMark:bAval := {|| EditObs(), oMark:oBrowse:Refresh() }      
      xRet := oMark                                          
      
      RestOrd(aOrd)
   Elseif cAcao == "END"
      IF Select("WkMsg") > 0
         WkMsg->(E_EraseArq(aOld[2]))
      Endif
      
      Select(aOld[1])
   Endif
End Sequence

Return xRet

/*
Funcao      : EditObs
Parametros  : 
Retorno     : 
Objetivos   : 
Autor       : 
Data/Hora   : 
Revisao     : Cristiano A. Ferreira 
              04/05/2000 - Protheus
Obs.        :
*/
Static Function EditObs

Local nOpc, cMemo, oDlg

Local bOk     := {|| nOpc:=1, oDlg:End() }
Local bCancel := {|| oDlg:End() }

Local nRec

IF WkMsg->(!Eof())
   IF Empty(WkMsg->WKMARCA)
      nOpc:=0
      cMemo := WkMsg->WKTEXTO

      DEFINE MSDIALOG oDlg TITLE WorkId->EEA_TITULO FROM 7,0.5 TO 26,79.5 OF oMainWnd
      
         @ 05,05 SAY STR0016 PIXEL //"Tipo Mensagem"
         @ 05,45 GET WkMsg->EE4_TIPMEN WHEN .F. PIXEL
         @ 20,05 GET cMemo MEMO SIZE 300,105 OF oDlg PIXEL HSCROLL 

         DEFINE SBUTTON oBtnOk     FROM 130,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
         DEFINE SBUTTON oBtnCancel FROM 130,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg
      
      ACTIVATE MSDIALOG oDlg CENTERED // ON INIT EnchoiceBar(oDlg,bOk,bCancel)

      IF nOpc == 1
         IF !Empty(nMarcado)
            nRec := WkMsg->(RecNo())
            WkMsg->(dbGoTo(nMarcado))
            WkMsg->WKMARCA := Space(2)
            WkMsg->(dbGoTo(nRec))
         Endif
         cObs := cObs + cMemo
         WkMsg->WKTEXTO := cMemo
         WkMsg->WKMARCA := cMarca
         nMarcado := nRec
      Endif
   Else
      cObs := ""
      WkMsg->WKMARCA := Space(2)
      nMarcado := 0
   Endif
Endif
     
Return NIL

//*------------------------------------------------------------------------------*
//* FIM DO PROGRAMA EECPPE05.PRW                                                 *
//*------------------------------------------------------------------------------*