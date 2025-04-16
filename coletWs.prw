#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "TOPCONN.CH"

// WSRESTFUL WSRESTXML DESCRIPTION "API REST para consulta das tabelas utilizadas no XML"

// 	WSDATA page AS INTEGER OPTIONAL
// 	WSDATA pageSize AS INTEGER OPTIONAL
// 	WSDATA searchKey AS STRING OPTIONAL

// 	WSMETHOD GET xmldoc DESCRIPTION "" WSSYNTAX "/xmldoc" PATH '/xmldoc' PRODUCES APPLICATION_JSON

// END WSRESTFUL

WSRESTFUL WSCOLET DESCRIPTION "API REST para consulta e atualização coletores"

	WSDATA _dInicio AS STRING OPTIONAL
	WSDATA _dFim AS STRING OPTIONAL

    WSDATA _cCentro  AS STRING OPTIONAL

	// WSMETHOD GET sda DESCRIPTION "Consulta tabela SDA" WSSYNTAX "/sda" PATH '/sda' PRODUCES APPLICATION_JSON
	// WSMETHOD GET kardex DESCRIPTION "Consulta tabela SD3" WSSYNTAX "/kardex" PATH '/kardex' PRODUCES APPLICATION_JSON
	// WSMETHOD GET sb2 DESCRIPTION "Consulta tabela SB2 - Saldos" WSSYNTAX "/sb2" PATH '/sb2' PRODUCES APPLICATION_JSON

	// WSMETHOD GET sh7 DESCRIPTION "Consulta tabela SH7 - PROTHEUS" WSSYNTAX "/sh7" PATH '/sh7' PRODUCES APPLICATION_JSON
	WSMETHOD GET sh8 DESCRIPTION "Consulta tabela SH8 - PROTHEUS" WSSYNTAX "/sh8" PATH '/sh8' PRODUCES APPLICATION_JSON
    //WSMETHOD GET optionsHandler DESCRIPTION "CORS handler" WSSYNTAX "/{*}" PATH '/*' PRODUCES APPLICATION_JSON
    
END WSRESTFUL

WSMETHOD GET sh8 WSRECEIVE _dInicio, _dFim, _cCentro WSREST WSCOLET

Local aRegistros 	:= {}
Local cJsonResult 	:= ''
Local oJsonResult 	:= JsonObject():New()
Local lRet 			:= .T.
Local cAliasOP 	:= GetNextAlias()

Local cCentro 		:= Self:_cCentro

Local cDataIni 		:= Self:_dInicio
Local cDataFim 		:= Self:_dFim

Local cDataIni2 		:= ''
Local cDataFim2 		:= ''


Local nTempoReal, nTempoEst, dDataOp, cHrFim, nHr, nMin, cDtAtual, nDtHr, nDtMin, cAtraso

Local cQueryDebug := ""

cDataIni2 := StrTran(cDataIni, "-", "")  // "20250401"
cDataFim2 := StrTran(cDataFim, "-", "")  // "20250415"


cQueryDebug += "SELECT "
cQueryDebug += "C2_NUM, C2_PRODUTO, B1_DESC, H6_QTDPROD, H8_QUANT, H8_RECURSO, H6_DATAINI, H8_TEMPEND, H6_TEMPO " + CRLF
cQueryDebug += "FROM " + RetSqlName("SC2") + " SC2 " + CRLF
cQueryDebug += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SC2.C2_PRODUTO " + CRLF
cQueryDebug += "INNER JOIN " + RetSqlName("SH6") + " SH6 ON SH6.D_E_L_E_T_ = '' AND SH6.H6_OP = SC2.C2_NUM " + CRLF
cQueryDebug += "INNER JOIN " + RetSqlName("SH8") + " SH8 ON SH8.D_E_L_E_T_ = '' AND SH8.H8_OP = SC2.C2_NUM " + CRLF
cQueryDebug += "WHERE "
cQueryDebug += "SC2.D_E_L_E_T_ = '' " + CRLF
cQueryDebug += "AND H6_DATAINI <= '" + cDataFim2 + "' " + CRLF
cQueryDebug += "AND H6_DATAINI >= '" + cDataIni2 + "' " + CRLF
cQueryDebug += "AND H8_RECURSO = '" + cCentro + "'"

FWLogMsg("?? QUERY DEBUG SQL (manual):")
ConOut("?? QUERY DEBUG SQL (manual):")
FWLogMsg(cQueryDebug)
ConOut(cQueryDebug)


// Adiciona headers de CORS
Self:SetHeader("Access-Control-Allow-Origin", "http://localhost:4200")
Self:SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
Self:SetHeader("Access-Control-Allow-Headers", "Content-Type")
Self:SetHeader("Access-Control-Allow-Credentials", "true")

FWLogMsg("?? Entrou no método SH8")
ConOut("?? Entrou no método SH8")
FWLogMsg("?? Centro: " + cCentro + ", Início: " + cDataIni2 + ", Fim: " + cDataFim2)
ConOut("?? Centro: " + cCentro + ", Início: " + cDataIni2 + ", Fim: " + cDataFim2)


If cCentro == "*"
    BEGINSQL Alias cAliasOP
        SELECT 
            C2_NUM, C2_PRODUTO, B1_DESC, H6_QTDPROD, H8_QUANT, H8_RECURSO, H6_DATAINI, H8_TEMPEND, H8_HRFIM,  H6_TEMPO
        FROM %table:SC2% SC2
            INNER JOIN %table:SB1% SB1  ON SB1.%NotDel%  AND SB1.B1_FILIAL = %xFilial:SC2%  AND SB1.B1_COD = SC2.C2_PRODUTO
            INNER JOIN %table:SH6% SH6  ON SH6.%NotDel%  AND SH6.H6_FILIAL = %xFilial:SC2%  AND SH6.H6_OP = SC2.C2_NUM
            INNER JOIN %table:SH8% SH8  ON SH8.%NotDel%  AND SH8.H8_FILIAL = %xFilial:SC2%  AND SH8.H8_OP = SC2.C2_NUM
        WHERE 
            SC2.%NotDel%  AND SC2.C2_FILIAL = %xFilial:SC2%
            AND H6_DATAINI >= %exp:cDataIni2%
            AND H6_DATAINI <= %exp:cDataFim2%
    ENDSQL
Else
    BEGINSQL Alias cAliasOP
        SELECT 
            C2_NUM, C2_PRODUTO, B1_DESC, H6_QTDPROD, H8_QUANT, H8_RECURSO, H6_DATAINI, H8_TEMPEND, H8_HRFIM,  H6_TEMPO
        FROM %table:SC2% SC2
            INNER JOIN %table:SB1% SB1  ON SB1.%NotDel%  AND SB1.B1_COD = SC2.C2_PRODUTO AND SB1.B1_FILIAL = %xFilial:SC2%
            INNER JOIN %table:SH6% SH6  ON SH6.%NotDel%  AND SH6.H6_OP = SC2.C2_NUM AND SH6.H6_FILIAL = %xFilial:SC2%
            INNER JOIN %table:SH8% SH8  ON SH8.%NotDel%  AND SH8.H8_OP = SC2.C2_NUM AND SH8.H8_FILIAL = %xFilial:SC2%
        WHERE 
            SC2.%NotDel%  AND SC2.C2_FILIAL = %xFilial:SC2%
            AND H6_DATAINI <= %exp:cDataFim2%
            AND H8_RECURSO = %exp:cCentro%
            AND H6_DATAINI >= %exp:cDataIni2%
    ENDSQL
EndIf



FWLogMsg("? Query executada com sucesso")
ConOut("? Query executada com sucesso")
FWLogMsg("?? Registros encontrados: " + cValToChar((cAliasOP)->(RecCount())))
ConOut("?? Registros encontrados: " + cValToChar((cAliasOP)->(RecCount())))


(cAliasOP)->(DBGoTop())

While !(cAliasOP)->(Eof())
    //Variáveis para o cálculo de tempo
    nTempoReal := Val((cAliasOP)->H6_TEMPO)
    nTempoEst  := (cAliasOP)->H8_TEMPEND 
    dDataOp    := StoD((cAliasOP)->H6_DATAINI)
    cHrFim     := (cAliasOP)->H8_HRFIM 
    
    //Cálculo de atraso
     nHr := Val(Left(cHrFim, 2))
     nMin := Val(SubStr(cHrFim, 3, 2))

    cDtAtual := Time() // "14:47:01"
    nDtHr := Val(Left(cDtAtual, 2))
    nDtMin := Val(SubStr(cDtAtual, 4, 2))
    
    cAtraso := "00:00"
    
    If Date() == dDataOp .And. (nDtHr > nHr .Or. (nDtHr == nHr .And. nDtMin > nMin))
        nTotalFim := nHr * 60 + nMin
        nTotalNow := nDtHr * 60 + nDtMin
        nDiff := nTotalNow - nTotalFim
    
        nAH := Int(nDiff / 60)
        nAM := nDiff % 60
    
        cAtraso := StrZero(nAH, 2) + ":" + StrZero(nAM, 2)
    EndIf
    
    oItem := JsonObject():New()
    oItem['centroTrabalho']  := (cAliasOP)->H8_RECURSO
    oItem['ordemProducao']   := (cAliasOP)->C2_NUM
    oItem['codProd']         := (cAliasOP)->C2_PRODUTO
    oItem['descProd']        := (cAliasOP)->B1_DESC
    oItem['saldo']           := (cAliasOP)->(cValToChar(H8_QUANT - H6_QTDPROD))
    oItem['pConclusao']      := (cAliasOP)->(cValToChar((H6_QTDPROD / H8_QUANT) * 100))
    oItem['recurso']         := (cAliasOP)->H8_RECURSO
    oItem['inicio']          := (cAliasOP)->(H6_DATAINI) //
    oItem['tempoEstimado']   := (cAliasOP)->(cValToChar(H8_TEMPEND))
    oItem['tempoReal']       := (cAliasOP)->(H6_TEMPO)
    oItem['PConclusaoTempo'] := cValToChar((nTempoReal / nTempoEst) * 100)
    oItem['tempoRestante']   := cValToChar(nTempoEst - nTempoReal)
    oItem['atraso']          :=  cAtraso    //(cAliasOP)->

    aAdd(aRegistros, oItem)

    (cAliasOP)->(DbSkip())
EndDo


If Select(cAliasOP) > 0
    (cAliasOP)->(DBCloseArea())
EndIf

oJsonResult['items'] := aRegistros

cJsonResult := FwJsonSerialize(oJsonResult)

FreeObj(oJsonResult)

// LOG: Final antes da resposta
FWLogMsg("?? Enviando resposta com " + cValToChar(Len(aRegistros)) + " itens")
ConOut("?? Enviando resposta com " + cValToChar(Len(aRegistros)) + " itens")

Self:SetResponse(cJsonResult)

Return(lRet)



// WSMETHOD GET optionsHandler WSRECEIVE WSREST WSPARFAT
// Local lRet := .T.

// Self:SetHeader("Access-Control-Allow-Origin", "http://localhost:4200")
// Self:SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
// Self:SetHeader("Access-Control-Allow-Headers", "Content-Type")
// Self:SetHeader("Access-Control-Allow-Credentials", "true")
// Self:SetResponse("") // Nenhum conteúdo, apenas confirmação

// Return (lRet)


// WSMETHOD GET sh7 WSRECEIVE dataIni, dataFim, prod, prod2 WSREST WSCOLET 

// Local aRegistros 	:= {}
// Local cJsonResult 	:= ''
// Local oJsonResult 	:= JsonObject():New()
// Local lRet 			:= .T.
// Local cAliasSDA 	:= GetNextAlias()

// Local cDataIni 		:= Self:dataIni
// Local cDataFim 		:= Self:dataFim

// Local cProd 		:= Self:prod
// Local cProd2 		:= Self:prod2

// // Adiciona headers de CORS
// Self:SetHeader("Access-Control-Allow-Origin", "http://localhost:4200")
// Self:SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
// Self:SetHeader("Access-Control-Allow-Headers", "Content-Type")
// Self:SetHeader("Access-Control-Allow-Credentials", "true")

// BEGINSQL Alias cAliasSDA

//     SELECT
//         DA_FILIAL,  
//         DA_PRODUTO,
//         DA_QTDORI,
//         DA_SALDO,
//         DA_DATA,
//         DA_LOTECTL,
//         DA_NUMLOTE,
//         DA_LOCAL
//     FROM 
//      	%table:SDA% SDA
// ENDSQL

// (cAliasSDA)->(DBGoTop())

// While !(cAliasSDA)->(Eof())
//     oItem := JsonObject():New()
//     oItem['produto']       := POSICIONE('SB1', 1, xFilial('SB1') + DA_PRODUTO, 'B1_DESC')
//     oItem['produtoCod']    := (cAliasSDA)->DA_PRODUTO
//     oItem['quantidade_ori']:= (cAliasSDA)->DA_QTDORI
//     oItem['saldo']         := (cAliasSDA)->DA_SALDO
//     oItem['data']          := (cAliasSDA)->DA_DATA
//     oItem['lote']          := (cAliasSDA)->DA_LOTECTL
//     oItem['sublote']       := (cAliasSDA)->DA_NUMLOTE
//     oItem['armazem']       := POSICIONE('NNR', 1, xFilial('NNR') + DA_LOCAL, 'NNR_DESCRI')
//     oItem['endereco']      := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_LOCALIZ')
//     oItem['tipoMov']       := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_TM')
//     oItem['quant_ori']     := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_QUANT')
//     oItem['estorno']       := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_ESTORNO')
//     oItem['dt_mov']        := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_ESTORNO')
//     oItem['armazem_dest']  := POSICIONE('SDB', 1, xFilial('SDB') + DA_PRODUTO, 'DB_LOCAL')

//     aAdd(aRegistros, oItem)

//     (cAliasSDA)->(DbSkip())
// EndDo

// If Select(cAliasSDA) > 0
//     (cAliasSDA)->(DBCloseArea())
// EndIf

// oJsonResult['items'] := aRegistros

// cJsonResult := FwJsonSerialize(oJsonResult)

// FreeObj(oJsonResult)

// Self:SetResponse(cJsonResult)

// Return(lRet)








// WSMETHOD GET sb2 WSRECEIVE WSREST WSCOLET

// Local aRegistros   := {}
// Local cJsonResult  := ''
// Local oJsonResult  := JsonObject():New()
// Local lRet         := .T.
// Local cAliasSB2    := GetNextAlias()

// // Adiciona headers de CORS
// Self:SetHeader("Access-Control-Allow-Origin", "http://localhost:4200")
// Self:SetHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
// Self:SetHeader("Access-Control-Allow-Headers", "Content-Type")
// Self:SetHeader("Access-Control-Allow-Credentials", "true")

// BEGINSQL Alias cAliasSB2

//     SELECT
//         B2_FILIAL,  
//         B2_COD,
//         B2_LOCAL,
//         B2_QATU,
//         B2_CM1,
//         B2_DMOV
//     FROM 
//         %table:SB2% SB2 
// ENDSQL

// (cAliasSB2)->(DBGoTop())

// While !(cAliasSB2)->(Eof())

//     oItem := JsonObject():New()
//     oItem['produtoCod']    := (cAliasSB2)->B2_COD
//     oItem['armazem']       := (cAliasSB2)->B2_LOCAL
//     oItem['saldo']         := (cAliasSB2)->B2_QATU
//     oItem['custouni']      := (cAliasSB2)->B2_CM1
//     oItem['data_ult_mov']  := (cAliasSB2)->B2_DMOV
//     oItem['lote']          := POSICIONE('SBK', 1, xFilial('SBK') + B2_COD, 'BK_LOTECTL')
//     oItem['sublote']       := POSICIONE('SBK', 1, xFilial('SBK') + B2_COD, 'BK_NUMLOTE')
//     oItem['dt_val_lote']   := POSICIONE('SBJ', 1, xFilial('SBJ') + B2_COD, 'BJ_DTVALID')
//     oItem['endereco']      := POSICIONE('SBK', 1, xFilial('SBK') + B2_COD, 'BK_LOCALIZ')

//     aAdd(aRegistros, oItem)

//     (cAliasSB2)->(DbSkip())
// EndDo

// If Select(cAliasSB2) > 0
//     (cAliasSB2)->(DBCloseArea())
// EndIf

// oJsonResult['items'] := aRegistros

// cJsonResult := FwJsonSerialize(oJsonResult)

// FreeObj(oJsonResult)

// Self:SetResponse(cJsonResult)

// Return(lRet)



// WSMETHOD POST postParam WSRECEIVE WSREST WSPARFAT

// Local oJsonResult  := JsonObject():New()
// Local cBody        := self:GetContent()
// Local oRequestData := JsonObject():New()
// Local lRet         := .T.
// Local cErrorMsg    := ''

// self:SetContentType('application/json')

// // Verifica se há um corpo na requisição
// If !Empty(cBody)
//     cErrorMsg := oRequestData:FromJson(cBody)
//     PutMv(oRequestData:GetJsonObject("parametro"), oRequestData:GetJsonObject("valor"))
// else
//     FwAlert('Erro', 'Nenhum corpo na requisição', 'Erro de Requisição' + cErrorMsg)
//     lRet := .F.
//     Return lRet
// EndIf

// // Retorna a confirmação da atualização
// oJsonResult['status'] := "Parâmetros atualizados com sucesso"
// cJsonResult := FwJsonSerialize(oJsonResult)

// FreeObj(oJsonResult)
// Self:SetResponse(cJsonResult)

// Return(lRet)

