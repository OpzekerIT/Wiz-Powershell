<#
.SYNOPSIS
Controls the state, brightness, and color of a WIZ smart lamp.

.DESCRIPTION
The Set-WizLampState function sends UDP packets to a WIZ smart lamp to control its state (on/off), brightness, and RGB color values. The function requires the IP address of the lamp and allows for optional parameters to set color and brightness.

.PARAMETER lampIP
The IP address of the WIZ lamp. This parameter is mandatory and must be in the format 'xxx.xxx.xxx.xxx'.

.PARAMETER lampPort
The port number of the WIZ lamp. This parameter is optional and defaults to 38899.

.PARAMETER state
The desired state of the lamp. This parameter is mandatory and must be either 'on' or 'off'.

.PARAMETER r
The red component of the RGB color value. This parameter is optional and defaults to 0.

.PARAMETER g
The green component of the RGB color value. This parameter is optional and defaults to 0.

.PARAMETER b
The blue component of the RGB color value. This parameter is optional and defaults to 0.

.PARAMETER brightness
The brightness level of the lamp. This parameter is optional and defaults to 100.

.EXAMPLE
Set-WizLampState -state 'on' -lampIP '192.168.1.10'
Turns the lamp on with the default brightness.

.EXAMPLE
Set-WizLampState -state 'off' -lampIP '192.168.1.10'
Turns the lamp off.

.EXAMPLE
Set-WizLampState -state 'on' -lampIP '192.168.1.10' -brightness 50
Turns the lamp on with 50% brightness.

.EXAMPLE
Set-WizLampState -state 'on' -lampIP '192.168.1.10' -r 255 -g 100 -b 50 -brightness 80
Turns the lamp on with an RGB color value of (255, 100, 50) and 80% brightness.

#>


function Set-WizLampState {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$')]
        [string]$lampIP,
        [int]$lampPort = 38899,
        [Parameter(Mandatory = $true)]
        [ValidateSet('on', 'off')]
        [string]$state = 'on',
        [int]$r = 0,
        [int]$g = 0,  
        [int]$b = 0,
        [int]$brightness = 100
    )
    function Send-UDPPacket {
        param (
            [string]$ip,
            [int]$port,
            [string]$message
        )
    
        $udpClient = New-Object System.Net.Sockets.UdpClient
        $udpClient.Connect($ip, $port)
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($message)
        $udpClient.Send($bytes, $bytes.Length)
        $udpClient.Close()
    }
    
    if ($state -eq 'on') {
        $payload = @{
            method = 'setPilot'
            params = @{
                state   = $true
                dimming = $brightness
            }
        } | ConvertTo-Json
    }
    if ($r -ne 0 -or $g -ne 0 -or $b -ne 0 -and $state -eq 'on') {    
        $payload = @{
            method = 'setPilot'
            params = @{
                r       = $r
                g       = $g
                b       = $b
                state   = $true
                dimming = $brightness
            }
        } | ConvertTo-Json
    }
    if ($state -eq 'off') {
        $payload = @{
            method = 'setPilot'
            params = @{
                state   = $false
                dimming = $brightness
            }
        } | ConvertTo-Json
    }

    Send-UDPPacket -ip $lampIP -port $lampPort -message $payload
}

# Example usage
# Turn the lamp on
# Set-WizLampState -state 'on' -lampIP '192.168.1.10'

# Turn the lamp off
# Set-WizLampState -state 'off' -lampIP '192.168.1.10'

# Turn the lamp on with specific brightness
# Set-WizLampState -state 'on' -lampIP '192.168.1.10' -brightness 50

# Turn the lamp on with specific color and brightness
# Set-WizLampState -state 'on' -lampIP '192.168.1.10' -r 255 -g 100 -b 50 -brightness 80