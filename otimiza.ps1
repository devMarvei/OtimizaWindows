# Fun��o para verificar e solicitar execu��o com privil�gios elevados
function Check-Admin {
    param (
        [string]$Message = "Este script requer privil�gios de administrador. Por favor, execute como administrador."
    )

    # Verificar se o script est� sendo executado com privil�gios de administrador
    if (-not [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host $Message
        Start-Sleep -Seconds 3  # Pausa de 3 segundos para leitura da mensagem
        exit  # Encerrar o script
    }
}

# Verificar se o script est� sendo executado como administrador
Check-Admin

# Fun��o para solicitar entrada do usu�rio
function Prompt-User  {
    param (
        [string]$Message
    )
    $input = Read-Host $Message
    return $input
}

# Perguntar se deseja executar o script de otimiza��o
$executeScript = Prompt-User  "DESEJA OTIMIZAR O WINDOWS? (S/N)"
if ($executeScript -eq 'N' -or $executeScript -eq 'n') {
    Write-Host "Execu��o do script de otimiza��o foi cancelada."
} else {
    # Fun��o para desativar servi�os
    $services = @('DiagTrack', 'diagnosticshub.standardcollector.service', 'wisvc', 'MapsBroker', 'WbioSrvc', 'XboxGipSvc', 'XblAuthManager', 'XblGameSave', 'XboxNetApiSvc', 'WerSvc', 'WSearch', 'WMPNetworkSvc', 'W32Time', 'bthserv', 'Fax', 'seclogon')

    # Desativar servi�os para otimiza��o
    Write-Host "Desativando servi�os desnecess�rios..."
    foreach ($service in $services) {
        Stop-Service -Name $service -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "$service desativado."
    }

    # Desativar UAC (Controle de Conta de Usu�rio)
    Write-Host "Desativando Controle de Conta de Usu�rio..."
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0

    # Desativar pol�tica de atualiza��o
    Write-Host "Desativando pol�tica de atualiza��o..."
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableWindowsUpdateAccess" -Value 1

    # Desativar Windows Firewall
    Write-Host "Desativando Windows Firewall..."
    Set-NetFirewallProfile -All -Enabled False

    # Desativar Windows Defender e Prote��es Adicionais
    Write-Host "Desativando Windows Defender e prote��es adicionais..."
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisablePrivacyMode $true
    Set-MpPreference -MAPSReporting Disabled
    Set-MpPreference -SubmitSamplesConsent 2
    Set-MpPreference -DisableBlockAtFirstSeen $true

    # Desativar Cortana
    Write-Host "Desativando Cortana..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaEnabled" -Value 0

    # Desativar Windows Store
Write-Host "Desativando Windows Store..."
Get-AppxPackage -AllUsers | Where-Object { 
    $_.InstallLocation -like '*WindowsApps*' -and 
    $_.Name -notlike '*Microsoft.WindowsCalculator*' -and 
    $_.Name -notlike '*Microsoft.Windows.Photos*' 
} | ForEach-Object { 
    Remove-AppxPackage -Package $_.PackageFullName 
}

    # Desativar efeitos visuais para melhorar desempenho
    Write-Host "Desativando efeitos visuais para melhorar desempenho..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0
 Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarNoThumbnail" -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" -Value 1
}

# Fun��o para perguntar ao usu�rio
function Prompt-User {
    param (
        [string]$message
    )
    $response = Read-Host $message
    return $response
}

# Fun��o para perguntar ao usu�rio
function Prompt-User {
    param (
        [string]$message
    )
    $response = Read-Host $message
    return $response
}

# Definir URLs dos instaladores
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"
$khelpdeskUrl = "https://khelpdesk.com.br/downloads/novo/KHelpDesk.exe?v=40.50"
$winrarUrl = "https://www.rarlab.com/rar/winrar-x64-701br.exe"

# Definir caminho da pasta onde os instaladores ser�o salvos
$installDir = "C:\Novus Tecnologia"
New-Item -ItemType Directory -Path $installDir -Force | Out-Null

# Perguntar se deseja instalar o .NET Framework 3.5
$installNetFx3 = Prompt-User "Deseja instalar o .NET Framework 3.5? (S/N)"
if ($installNetFx3 -eq 'S' -or $installNetFx3 -eq 's') {
    Write-Host "Instalando o .NET Framework 3.5..."
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
    if ($LASTEXITCODE -ne 0) {
        Write-Host "A instala��o do .NET Framework 3.5 falhou. Tentando novamente online..."
        DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
    } else {
        Write-Host "Instala��o do .NET Framework 3.5 conclu�da com sucesso!"
    }
} else {
    Write-Host "Instala��o do .NET Framework 3.5 ignorada."
}

# Perguntar se deseja instalar o Google Chrome e os outros aplicativos
$installChrome = Prompt-User "Deseja instalar o Google Chrome e os outros aplicativos? (S/N)"
if ($installChrome -eq 'S' -or $installChrome -eq 's') {
    # Baixar e instalar o Google Chrome
    Write-Host "Baixando e instalando o Google Chrome..."
    Invoke-WebRequest -Uri $chromeUrl -OutFile "$installDir\chrome_installer.exe"
    $chromeProcess = Start-Process -FilePath "$installDir\chrome_installer.exe" -PassThru
    $chromeProcess.WaitForExit() # Aguarda a conclus�o do processo
    if ($chromeProcess.ExitCode -eq 0) {
        Write-Host "Instala��o do Google Chrome conclu�da com sucesso!"
    } else {
        Write-Host "A instala��o do Google Chrome falhou com o c�digo de sa�da: $($chromeProcess.ExitCode)"
    }

    # Instalar o AnyDesk
    Write-Host "Baixando e instalando o AnyDesk..."
    Invoke-WebRequest -Uri $anydeskUrl -OutFile "$installDir\AnyDesk.exe"
    $anydeskProcess = Start-Process -FilePath "$installDir\AnyDesk.exe" -ArgumentList "/S" -PassThru
    $anydeskProcess.WaitForExit() # Aguarda a conclus�o do processo
    if ($anydeskProcess.ExitCode -eq 0) {
        Write-Host "Instala��o do AnyDesk conclu�da com sucesso!"
    } else {
        Write-Host "A instala��o do AnyDesk falhou com o c�digo de sa�da: $($anydeskProcess.ExitCode)"
    }

    # Instalar o KHelpDesk
    Write-Host "Baixando e instalando o KHelpDesk..."
    Invoke-WebRequest -Uri $khelpdeskUrl -OutFile "$installDir\KHelpDesk.exe"
    $khelpdeskProcess = Start-Process -FilePath "$installDir\KHelpDesk.exe" -ArgumentList "/S" -PassThru
    $khelpdeskProcess.WaitForExit() # Aguarda a conclus�o do processo
    if ($khelpdeskProcess.ExitCode -eq 0) {
        Write-Host "Instala��o do KHelpDesk conclu�da com sucesso!"
    } else {
        Write-Host "A instala��o do KHelpDesk falhou com o c�digo de sa�da: $($khelpdeskProcess.ExitCode)"
    }

    # Instalar o WinRAR
    Write-Host "Baixando e instalando o WinRAR..."
    Invoke-WebRequest -Uri $winrarUrl -OutFile "$installDir\WinRAR.exe"
    $winrarProcess = Start-Process -FilePath "$installDir\WinRAR.exe" -ArgumentList "/S" -PassThru
    $winrarProcess.WaitForExit() # Aguarda a conclus�o do processo
    if ($winrarProcess.ExitCode -eq 0) {
        Write-Host "Instala��o do WinRAR conclu�da com sucesso!"
    } else {
        Write-Host "A instala��o do WinRAR falhou com o c�digo de sa�da: $($winrarProcess.ExitCode)"
    }
} else {
    Write-Host "Instala��o do Google Chrome e outros aplicativos ignorada."
}

# Perguntar ao usu�rio se deseja continuar para o pr�ximo script
do {
    $confirm = Read-Host "VOC� DESEJA BAIXAR OS APLICATIVOS XMENU? (S/N)"
    if ($confirm -ne 'S' -and $confirm -ne 's' -and $confirm -ne 'N' -and $confirm -ne 'n') {
        Write-Host "Entrada inv�lida. Por favor, digite 'S' para sim ou 'N' para n�o."
    }
} while ($confirm -ne 'S' -and $confirm -ne 's' -and $confirm -ne 'N' -and $confirm -ne 'n')

if ($confirm -eq 'S' -or $confirm -eq 's') {
    Write-Host "Baixando e instalando os aplicativos XMENU..."
    # Coloque aqui o c�digo para instalar os aplicativos XMENU
} else {
    Write-Host "Processo conclu�do. Finalizando o script."
}


if ($confirm -eq 'N' -or $confirm -eq 'n') {
    Write-Host "Execu��o do script continuar� sem baixar os aplicativos."
} else {
    # Define o diret�rio de destino
    $dir = "C:\Xmenu Ferramentas"

    # Cria o diret�rio se n�o existir
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    # Downloads
    Write-Host "Baixando arquivos..."

    # Fun��o para baixar arquivos
    function Download-File {
        param (
            [string]$url,
            [string]$filePath
        )
        try {
            Invoke-WebRequest -Uri $url -OutFile $filePath -ErrorAction Stop
            Write-Host "Download conclu�do: $filePath"
        } catch {
            Write-Host "Erro ao baixar $filePath. Verifique a conex�o de internet e tente novamente."
            Write-Host "Detalhes do erro: $_"
        }
    }

    # URLs dos instaladores
    $downloads = @{
        "SQL2008x64.exe" = "https://www.netcontroll.com.br/util/instaladores/netpdv/SQL2008x64.exe"
        "InstaladorConcentrador.exe" = "https://www.netcontroll.com.br/util/instaladores/netpdv/InstaladorConcentrador.exe"
        "NetPDV.exe" = "https://netcontroll.com.br/util/instaladores/netpdv/1.3/40/0/NetPDV.exe"
        "LinkXMenu.exe" = "https://netcontroll.com.br/util/instaladores/LinkXMenu/10/11/LinkXMenu.exe"
        "InstaladorNFCe.exe" = "https://www.netcontroll.com.br/util/instaladores/NFCE/9.1.64.8790/InstaladorNFCe.exe"
        "SetupVSPE_64_1.2.6.789.zip" = "https://eterlogic.com/downloads/SetupVSPE_64_1.2.6.789.zip"
        "winrar-x64-701br.exe" = "https://www.rarlab.com/rar/winrar-x64-701br.exe"
        "AnyDesk.exe" = "https://download.anydesk.com/AnyDesk.exe"
        "KHelpDesk.exe" = "https://khelpdesk.com.br/downloads/novo/KHelpDesk.exe?v=40.50"
        "KHelpDeskGoogleDrive.exe" = "https://drive.usercontent.google.com/download?id=1p_WJkTHpYrfT1V--J-RO838CStdrVOVQ&export=download&authuser=0&confirm=t&uuid=6ed4fb7f-244e-4bd6-8378-775701be4490&at=AN_67v3FnEjgPMj5EK_8OsDST0-s%3A1727750808899"
    }

    # Iterar pelos downloads e baixar cada arquivo
    foreach ($fileName in $downloads.Keys) {
        $url = $downloads[$fileName]
        $filePath = Join-Path -Path $dir -ChildPath $fileName
        Download-File -url $url -filePath $filePath
    }

    Write-Host "Todos os arquivos foram baixados para $dir"
}

# Lista de URLs e seus nomes
$sites = @{
    "Portal Netcontroll" = "https://portal.netcontroll.com.br/#/auth/login"
    "T�cnico XMenu" = "https://tecnico.xmenu.com.br/"
    "Administra��o Netcontroll" = "https://netcontroll.com.br/adm/"
    "Vers�es XMenu" = "https://versoes.xmenu.com.br/"
}

# Perguntar sobre cada URL
foreach ($site in $sites.GetEnumerator()) {
    $siteNome = $site.Key
    $siteUrl = $site.Value

    do {
        $resposta = Read-Host "DESEJA ABRIR O SITE $siteNome ($siteUrl)? (S/N)"
        if ($resposta -ne 'S' -and $resposta -ne 's' -and $resposta -ne 'N' -and $resposta -ne 'n') {
            Write-Host "Resposta inv�lida. Digite 'S' para sim ou 'N' para n�o."
        }
    } while ($resposta -ne 'S' -and $resposta -ne 's' -and $resposta -ne 'N' -and $resposta -ne 'n')

    if ($resposta -eq 'S' -or $resposta -eq 's') {
        Start-Process $siteUrl
        Write-Host "O site $siteNome foi aberto."
    } else {
        Write-Host "O site $siteNome n�o ser� aberto."
    }
}

# Mensagem final ap�s processar todos os sites
Write-Host "Todos os sites foram processados."

# Perguntar sobre abrir o link do Saurus
do {
    $usuarioResposta = Read-Host "Deseja abrir o link https://saurus.com.br/suporte? (s/n)"
    if ($usuarioResposta -ne 's' -and $usuarioResposta -ne 'S' -and $usuarioResposta -ne 'n' -and $usuarioResposta -ne 'N') {
        Write-Host "Resposta inv�lida. Digite 's' para sim ou 'n' para n�o."
    }
} while ($usuarioResposta -ne 's' -and $usuarioResposta -ne 'S' -and $usuarioResposta -ne 'n' -and $usuarioResposta -ne 'N')

if ($usuarioResposta -eq 's' -or $usuarioResposta -eq 'S') {
    Start-Process "https://saurus.com.br/suporte"
    Write-Host "O link foi aberto."
} elseif ($usuarioResposta -eq 'n' -or $usuarioResposta -eq 'N') {
    Write-Host "O link n�o ser� aberto."
}