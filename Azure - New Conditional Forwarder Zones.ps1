Write-host @"
Starting script to create New Conditional Forwarder zones in DNS servers.

"@

$AzureDCs = "ADDIPS"
$DNSzones = import-csv c:\temp\AzureprivateDnsZones.csv


foreach($PrivateDNSzone in $DNSzones){
    
    if($PrivateDNSzone.NAME -like "privatelink.*"){
        $PrivateDNSzone.NAME = $PrivateDNSzone.NAME.substring($("privatelink.").Length)
    }

    write-host "Creating new Conditional Forwarder zone for"$PrivateDNSzone.NAME
    Add-DnsServerConditionalForwarderZone -Name $PrivateDNSzone.NAME -ReplicationScope "Forest" -MasterServers $AzureDCs
    Add-DnsServerConditionalForwarderZone -Name $PrivateDNSzone.NAME -MasterServers "168.63.129.16"

}

write-host @"
    
    Ending script. 

"@
write-host "New Conditional Forwarder zones created for"$DNSzones.count"Zones"
