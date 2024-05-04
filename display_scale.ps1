$scale1 = 4294967295  # Здесь значение, когда доп. монитор подключен
$scale2 = 4294967294  # Здесь значение, когда доп. монитор отключен

function Set-Scaling {
    # Posted by IanXue-MSFT on
    # https://learn.microsoft.com/en-us/answers/questions/197944/batch-file-or-tool-like-powertoy-to-change-the-res.html
    # $scaling = 0 : 100% (default)
    # $scaling = 1 : 125% 
    # $scaling = 2 : 150% 
    # $scaling = 3 : 175% 
    param($scaling)
    $source = @'
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo(
                      uint uiAction,
                      uint uiParam,
                      uint pvParam,
                      uint fWinIni);
'@
    $apicall = Add-Type -MemberDefinition $source -Name WinAPICall -Namespace SystemParamInfo -PassThru
    $apicall::SystemParametersInfo(0x009F, $scaling, $null, 1) | Out-Null
}

$display = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams

if ($display.Count -gt 1) {
  Set-Scaling -scaling $scale1
}else {
  Set-Scaling -scaling $scale2
}
