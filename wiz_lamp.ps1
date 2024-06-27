# Define the IP address of the WIZ lamp
$lampIP = '0.0.0.0'
$lampPort = 38899

# Define the JSON payload for turning the lamp on or off
$payloadOn = @{
    method = 'setPilot'
    params = @{
        state = $true
    }
} | ConvertTo-Json

$payloadOff = @{
    method = 'setPilot'
    params = @{
        state = $false
    }
} | ConvertTo-Json

$payloadRed = @{
    method = 'setPilot'
    params = @{
        r     = 255
        g     = 0
        b     = 0
        state = $true
    }
} | ConvertTo-Json

$payloadGreen = @{
    method = 'setPilot'
    params = @{
        r     = 0
        g     = 255
        b     = 0
        state = $true
    }
} | ConvertTo-Json

# Function to send UDP message to the WIZ lamp
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

# Function to set the state of the WIZ lamp
function Set-WizLampState {
    param (
        [string]$state
    )

    switch ($state) {
        'on' {
            $payload = $payloadOn
        }
        'off' {
            $payload = $payloadOff
        }
        'red' {
            $payload = $payloadRed
        }
        'green' {
            $payload = $payloadGreen
        }
        default {
            Write-Error "Invalid state. Use 'on', 'off', or 'red'."
            return
        }
    }

    Send-UDPPacket -ip $lampIP -port $lampPort -message $payload
}

# Example usage
# Turn the lamp on
Set-WizLampState -state 'on'

# Turn the lamp off
# Set-WizLampState -state "off"
