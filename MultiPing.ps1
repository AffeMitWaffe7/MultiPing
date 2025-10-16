$startIP = 40
$endIP = 49
$startsubIP = 0
$endsubIP = 255
$subnet = "10.49"  
 

$results = @()
 
for ($j = $startIP; $j -le $endIP; $j++)
{
    for ($i = $startsubIP; $i -le $endsubIP; $i++) {
        $ip = "$subnet.$j.$i"
        Write-Host "Pingt gerade $ip..."
    
        
        $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet
    
        
        if ($pingResult) {
            try {
                $reverseLookup = [System.Net.Dns]::GetHostEntry($ip).HostName
            } catch {
                $reverseLookup = "Reverse Lookup fehlgeschlagen"
            }
    
            
            $results += [PSCustomObject]@{
                IPAddress = $ip
                Hostname  = $reverseLookup
                Status    = "Erfolgreich gepingt"
            }
        } else {
            
            $results += [PSCustomObject]@{
                IPAddress = $ip
                Hostname  = "N/A"
                Status    = "Ping fehlgeschlagen"
            }
        }
    }
}

$results | Export-Csv -Path "$PSScriptRoot\Ergebnis.csv" -NoTypeInformation -Delimiter ";"
 
Write-Host "Ergebnise wurden gespeichert in Ergebnis.csv"
 