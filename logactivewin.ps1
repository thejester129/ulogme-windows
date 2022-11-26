

#requires -Version 2
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class ImportDll {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@
# $signature = @'
# [DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
# public static extern short GetAsyncKeyState(int virtualKeyCode); 
# '@

# $ImportDll = Add-Type -MemberDefinition $signature -Name 'Keypress' -Namespace API -PassThru
# logs the active window titles over time. Logs are written 
# in logs/windowX.txt, where X is unix timestamp of 7am of the
# recording day. The logs are written if a window change event occurs
# (with 2 second frequency check time), or every 10 minutes if 
# no changes occur.

Write-Output "logging active windows"

$waittime="2" # number of seconds between executions of loop

$lasttitle=""
while($true)
{
  # get the title of the foreground window
  $TopWindow = [ImportDll]::GetForegroundWindow()
  $curtitle = (Get-Process | Where-Object { $_.MainWindowHandle -eq $TopWindow }).ProcessName
  Write-Output $WindowTitle

  if($curtitle -ne $lasttitle)
  {
    $unix_timestamp = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds
    $logfile="logs/window_$(python rewind7am.py).txt"
    Add-Content -Path $logfile -Value "$unix_timestamp $curtitle"
    Write-Output "logged window change: $unix_timestamp $curtitle"
  }
  $lasttitle = $curtitle
  Start-Sleep -Seconds $waittime
}
