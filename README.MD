# Set-WizLampState PowerShell Function

## Overview

The `Set-WizLampState` PowerShell function allows you to control a WIZ smart lamp by sending UDP packets to its IP address. You can turn the lamp on or off, set its brightness, and specify RGB color values.

## Features

- **Turn On/Off**: Change the state of the lamp to on or off.
- **Adjust Brightness**: Set the brightness level of the lamp (0-100).
- **Set RGB Color**: Define the RGB color values to set the lamp to a specific color.

## Parameters

- `lampIP` (Mandatory): The IP address of the WIZ lamp in the format `xxx.xxx.xxx.xxx`.
- `lampPort`: The port number of the WIZ lamp. Defaults to `38899`.
- `state` (Mandatory): The desired state of the lamp (`'on'` or `'off'`).
- `r`: The red component of the RGB color value (0-255). Default is `0`.
- `g`: The green component of the RGB color value (0-255). Default is `0`.
- `b`: The blue component of the RGB color value (0-255). Default is `0`.
- `brightness`: The brightness level of the lamp (0-100). Default is `100`.

## Usage Examples

1. **Turn the Lamp On**:
    ```powershell
    Set-WizLampState -state 'on' -lampIP '192.168.1.10'
    ```

2. **Turn the Lamp Off**:
    ```powershell
    Set-WizLampState -state 'off' -lampIP '192.168.1.10'
    ```

3. **Turn the Lamp On with Specific Brightness**:
    ```powershell
    Set-WizLampState -state 'on' -lampIP '192.168.1.10' -brightness 50
    ```

4. **Turn the Lamp On with Specific RGB Color and Brightness**:
    ```powershell
    Set-WizLampState -state 'on' -lampIP '192.168.1.10' -r 255 -g 100 -b 50 -brightness 80
    ```

## Prerequisites

- PowerShell 5.1 or later.
- A WIZ smart lamp connected to the same network as the computer running this script.

## Installation

1. Copy the function definition into a PowerShell script file (e.g., `Set-WizLampState.ps1`).
2. Load the function into your PowerShell session:
   ```powershell
   . .\Set-WizLampState.ps1
