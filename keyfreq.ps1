
#requires -Version 2

$signature = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)] 
public static extern short GetAsyncKeyState(int virtualKeyCode); 
'@

$ImportDll = Add-Type -MemberDefinition $signature -Name 'Keypress' -Namespace API -PassThru

# logs the key press frequency over 9 second window. Logs are written 
# in logs/keyfreqX.txt every 9 seconds, where X is unix timestamp of 7am of the
# recording day.
Write-Output "logging keystrokes"

if (Test-Path -Path ".\logs")
{
  # folder exists 
} else
{
  mkdir -p logs
}

while($true)
{
  $num = 0
  $polling_until = (Get-Date).AddSeconds(9)
  while ((Get-Date) -lt $polling_until)
  {
    Start-Sleep -Milliseconds 40
      
    for ($char = 1; $char -le 254; $char++)
    {
      $vkey = $char
      $gotit = $ImportDll::GetAsyncKeyState($vkey)
          
      if ($gotit -eq -32767)
      {
        $num = $num + 1
      }
    }
  }
    
  # append unix time stamp and the number into file
  $unix_timestamp = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalSeconds
  $logfile="logs/keyfreq_$(python rewind7am.py).txt"
  Add-Content -Path $logfile -Value "$unix_timestamp $num"
  Write-Output "logged key frequency: $unix_timestamp $num release events detected into $logfile"
} 