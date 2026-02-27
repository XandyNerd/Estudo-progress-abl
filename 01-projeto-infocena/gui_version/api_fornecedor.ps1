param([string]$cnpj)
try {
    # Limpa o CNPJ de formatações
    $cnpj = $cnpj -replace '[^0-9]', ''
    $url = "https://brasilapi.com.br/api/cnpj/v1/$cnpj"
    $response = Invoke-RestMethod -Uri $url -Method Get
    $data = @{
        razao_social  = $response.razao_social
        nome_fantasia = $response.nome_fantasia
        cep           = $response.cep
        ddd_telefone1 = $response.ddd_telefone1
        logradouro    = $response.logradouro
        bairro        = $response.bairro
        municipio     = $response.municipio
        uf            = $response.uf
        numero        = $response.numero
        complemento   = $response.complemento
    }
    $data | ConvertTo-Json | Out-File "api_fornecedor_res.json" -Encoding Default
    Write-Output "SUCCESS"
}
catch {
    Write-Output "ERROR: $($_.Exception.Message)"
}
