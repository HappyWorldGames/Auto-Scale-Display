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

# Get Scaling
Add-Type @'
using System; 
using System.Runtime.InteropServices;
using System.Drawing;

public class DPI {  
  [DllImport("gdi32.dll")]
  static extern int GetDeviceCaps(IntPtr hdc, int nIndex);

  public enum DeviceCap {
  VERTRES = 10,
  DESKTOPVERTRES = 117
  } 

  public static float scaling() {
  Graphics g = Graphics.FromHwnd(IntPtr.Zero);
  IntPtr desktop = g.GetHdc();
  int LogicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.VERTRES);
  int PhysicalScreenHeight = GetDeviceCaps(desktop, (int)DeviceCap.DESKTOPVERTRES);

  return (float)PhysicalScreenHeight / (float)LogicalScreenHeight;
  }
}
'@ -ReferencedAssemblies 'System.Drawing.dll' -ErrorAction Stop
# Get Scaling
$display_scale = [DPI]::scaling() * 100

$display = Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams

if ($display.Count -gt 1) {
  if ($display_scale -ne 125) { Set-Scaling -scaling $scale1 }
}else {
  if ($display_scale -ne 100) { Set-Scaling -scaling $scale2 }
}
