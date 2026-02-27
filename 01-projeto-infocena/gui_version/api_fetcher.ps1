param (
    [string]$ean,
    [string]$token,
    [string]$jsonPath,
    [string]$imgPath
)

$headers = @{ 
    "X-Cosmos-Token" = $token
    "User-Agent"     = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
    "Accept"         = "application/json, text/plain, */*"
}

$url = "https://api.cosmos.bluesoft.com.br/gtins/$ean"

$tokenHeader = "X-Cosmos-Token: $token"
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

try {
    # Busca o JSON via CURL (adicionado -L para seguir redirects e -o para capturar de forma limpa)
    & curl.exe -s -L -H $tokenHeader -A $userAgent $url -o $jsonPath
    
    # Extrai a URL da imagem (thumbnail) usando um método mais robusto
    $json = Get-Content $jsonPath -Raw
    if ($json -match '"thumbnail"\s*:\s*"(.*?)"') {
        $imgUrl = $matches[1]
        # Baixa a imagem usando os mesmos headers/browser-agent
        & curl.exe -s -L -A $userAgent $imgUrl -o $imgPath
    }
}
catch {
    $_.Exception.Message | Out-File -FilePath $jsonPath -Encoding utf8
    exit 1
}
