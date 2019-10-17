#Include "RwMake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LJ7009   �Autor  � Marcio Domingos    � Data �  27/06/05   ���
�������������������������������������������������������������������������͹��
���Descricao �-  Validacao das formas de pagamento.                       ���
�������������������������������������������������������������������������͹��
���Parametros� 1o Array com as informacoes originais.                     ���
���          � 2o Array com as informacoes apos a alteracao do usuario.   ���
�������������������������������������������������������������������������͹��
���Observacao� Ponto de Entrada chamado na confirmacao da tela de         ���
���          � alteracao das parcelas.                                    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LJ7009()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local _aArea1,_nX1,_aArqs1,_aAlias1
Local _lRet
Local _cForma	:= ""
Local _cDForma	:= ""

//������������������������������   Salvando Area   - Inicio ��������������������������������������
_aArea1   := GetArea()
_aArqs1   := {"SLQ","SLR","SL1","SL2"}
_aAlias1  := {}
For _nX1  := 1 To Len(_aArqs1)
	dbSelectArea(_aArqs1[_nX1])
	AAdd(_aAlias1,{ Alias(), IndexOrd(), Recno()})
Next
//������������������������������   Salvando Area  - Fim    ���������������������������������������

//���������������������������������������������������������������������Ŀ
//� Inicializacao de Variaveis                                          �
//�����������������������������������������������������������������������
_lRet      := .T.   

If !Empty(M->LQ_CONDPG) .And. Rtrim(M->LQ_CONDPG) <> "CN"
	
	_cForma := GetAdvFVal("SE4","E4_FORMA",xFilial("SE4")+M->LQ_CONDPG,1,"")
	If !empty(_cForma)
		_cDForma	:= GetAdvFVal("SX5","X5_DESCRI",xFilial("SX5")+"24"+_cForma,1,"")
	Endif	
	
Endif

//For _n := 1 to Len(Paramixb[2])                 

	If ParamIxb[2][1] <> ParamIxb[1][1]
		If ParamIxb[2][1] - dDatabase > GetMV("MV_DIASPG") // Criar Parametro 
			MsgBox("Data invalida !")
			_lRet	:= .F.    
//			Exit
		Endif	
	Endif
	
	If !Empty(_cDForma) .And. _lRet
		If Upper(Rtrim(ParamIxb[2][3])) <> Upper(Rtrim(_cDForma))
			Aviso("Aviso","A forma de pagamento selecionada � diferente da condi��o de pagamento ! Confirma ?",{"OK"},1,"Atencao")
		Endif			
		_lRet := .T.
	Endif	
	
/*	
	If M->LQ_CLIENTE = "000001" .And. !Rtrim(ParamIxb[2][3]) $ "Dinheiro&Cartao de Credito&Cartao de debito Automatico"
		MsgBox("Forma de pagamento invalida !")
		_lRet	:= .F.    
		Exit
	Endif
*/
//Next

//��������������������������������������������Ŀ
//�Notifica o usuario sobre o uso de duplicatas�
//�Norbert - 12/09/05                          �
//����������������������������������������������
P_NotifDP(2)

//��������������������������������������������Ŀ
//�Impede a alteracao de dados de parcelas de  �
//�sinistro - Norbert - 05/12/05               �
//����������������������������������������������
If (_lRet)

	If	(FieldPos("L4_FORMAID") == 0) .And. !P_NaPilha("LJ7CONDPG") .And. ;
		((aPgtos[oPgtos:nAt][5] != NIL) .And. (aPgtos[oPgtos:nAt][5] $ "S/C" ))
		
		_lRet := .F.
		ApMsgAlert("N�o � permitido alterar dados de parcelas de sinistro","N�o permitido")
		
	EndIf

EndIf               

//������������������������������   Restaurando Area   - Inicio �����������������������������������
For _nX1 := 1 To Len(_aAlias1)
	dbSelectArea(_aAlias1[_nX1,1])
	dbSetOrder(_aAlias1[_nX1,2])
	dbGoTo(_aAlias1[_nX1,3])
Next
RestArea(_aArea1)
//������������������������������   Restaurando Area   - Fim    �����������������������������������

Return(_lRet)