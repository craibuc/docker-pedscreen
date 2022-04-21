<#PSScriptInfo
.VERSION 0.1.5
.GUID 967f86c3-5079-483e-bdef-d5ae66ab69eb
.AUTHOR Craig Buchanan <craig.buchanan@cogniza.com>
.COMPANYNAME Cogniza, Inc.
.COPYRIGHT
.TAGS pecarn, pedscreen, sbt, scala
.LICENSEURI
.PROJECTURI
.ICONURI
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA 
#>

<# 
.DESCRIPTION 
Export PECARN data.

.EXAMPLE
PS> .\Export-Pecarn.ps1 -WhatIf

Run the export for the prior month's ED visits, in trial mode.  The extract will not be performed.

.EXAMPLE
PS> .\Export-Pecarn.ps1

Run the export for the prior month's ED visits

.EXAMPLE
PS> [pscustomobject]@{Starting='2/1/2019';Ending='2/28/2019'},
[pscustomobject]@{Starting='3/1/2019';Ending='3/31/2019'},
[pscustomobject]@{Starting='4/1/2019';Ending='4/30/2019'},
[pscustomobject]@{Starting='7/1/2019';Ending='7/31/2019'},
[pscustomobject]@{Starting='10/1/2019';Ending='10/31/2019'} | % {
   ./Export-Pecarn.ps1 -Starting $_.Starting -Ending $_.Ending -WhatIf
}

Process multiple months

.NOTES
Most settings are contained in a PowerShell data file (Export-Pecarn.psd1)
#> 

[CmdletBinding(SupportsShouldProcess)]
Param(
    [datetime]$Starting = (Get-Date -Day 1).Date.AddMonths(-1),

    [datetime]$Ending = (Get-Date -Day 1).Date.AddDays(-1),

    [switch]$PassThru
)

Write-Debug "Starting: $Starting"
Write-Debug "Ending: $Ending"

try 
{

    #
    # Dependencies
    #

    . .\Invoke-Pedscreen.ps1

    #
    # Variables
    #

    $ScriptName = (Get-Item $PSCommandPath).BaseName
    $Here = Split-Path $PSCommandPath -Parent

    #
    # Settings
    # 
    
    Write-Verbose "Settings..."

    # Export-Pecarn.psd1
    $SettingsPath = Join-Path $Here "$ScriptName.psd1"

    if ( -Not (Test-Path $SettingsPath) )
    {
        $ErrorMessage = "Settings file '$SettingsPath' not found.  Processing halted."
        throw New-Object System.IO.FileNotFoundException::new( $ErrorMessage, $SettingsPath )
    }

    $Settings = Import-PowerShellDataFile $SettingsPath 
    
    # ped-screen/
    $BuildDirectory = Resolve-Path $Settings.Pedscreen.BuildDirectory
    
    # ~/AppData/PexDex/Perl/lists
    # $DeidListDirectory = Resolve-Path $Settings.Deid.ListDirectory

    #
    # SMTP settings
    #
    $SmtpSettings = $Settings.SmtpSettings

    #
    # pedscreen.properties
    #

    # $PropertiesPath = Join-Path $BuildDirectory "conf\local" "pedscreen.properties"
    # $Properties = Get-Content $PropertiesPath | ConvertFrom-StringData

    # change to directory that contains build.sbt (.\ped-screen)
    Push-Location $BuildDirectory

    #
    # process the dates in the PSD1 file if specified, or the values supplied when the script was called
    #

    $Settings.Pedscreen.Dates.Count -gt 0 ? $Settings.Pedscreen.Dates : @{Starting=$Starting;Ending=$Ending} | ForEach-Object {

        # $Date = $_
        $StartingDate = [datetime]$_.Starting
        $EndingDate = [datetime]$_.Ending

        #
        # process each site and department
        #

        $Settings.Pedscreen.Locations | Where-Object { !$_.disabled } | ForEach-Object {

            $Location = [pscustomobject]$_
            Write-Verbose ("Processing {0} [{1}]: {2} - {3}..." -f  $Location.name, ($Location.location_id ? $Location.location_id : $Location.site_id), $StartingDate.ToString('MM/dd/yy'), $EndingDate.ToString('MM/dd/yy') )

            $Start = Get-Date

            # ped-screen/output/[site_id]
            $OutputDirectory = Join-Path $BuildDirectory "output" $Location.site_id.ToLower()

            # ped-screen/output/[site_id]/lists
            # $ListDirectory = Join-Path $BuildDirectory 'output' $Location.site_id.ToLower() 'lists'

            #
            # run ped-screen (generate extract)
            #

            $Splat = @{
                Starting = $StartingDate
                Ending = $EndingDate
                Pecarn = $Settings.Pedscreen.pecarn
                ListParams = $Settings.Pedscreen.list_params
                Continue = $Settings.Pedscreen.continue
                NoOutput = $Settings.Pedscreen.no_output
            }

            Write-Verbose "Invoking pedscreen..."
            $Location | Invoke-Pedscreen @splat -WhatIf:$WhatIfPreference

            #
            # Rename list folder to include location and date range
            #

            # Write-Verbose "Renaming list folder..."
            # $Lists = "{0}_{1}_to_{2}_lists" -f $Location.location_id, $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd')

            # Move-Item -Path $ListDirectory -Destination ( Join-Path $BuildDirectory 'output' $Location.site_id $Lists ) -Force -WhatIf:$WhatIfPreference

            if ($PassThru.IsPresent)
            {
                [pscustomobject]@{
                    Path = $OutputDirectory
                    # Lists = $Lists
                    Lists = "{0}_{1}_to_{2}_lists" -f $Location.location_id, $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd')
                    XML= "{0}_{1}_to_{2}.xml" -f $Location.location_id, $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd')
                    PID = "PID_{0}_{1}_to_{2}.txt" -f $Location.location_id, $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd')
                }    
            }

            # Write-Verbose "Copy XML to PexDex..."
            
            # Write-Verbose "Copy PID to PexDex..."

            # Write-Verbose "Copy list to PexDex..."
            # Get-ChildItem -Path $ListDirectory -Filter *.txt | Copy-Item -Destination $DeidListDirectory -Force

            if ($SmtpSettings)
            {
                $TimeSpan = ((Get-Date) - $Start)
                $Duration = "{0}:{1}:{2}" -f $TimeSpan.Hours, $TimeSpan.Minutes, $TimeSpan.Seconds

                $Subject = "{0} [{1}]: {2} - {3}" -f  $Location.name, ($Location.location_id ? $Location.location_id : $Location.site_id), $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd')
                $Body = "<table>
                <tr><td>Location:</td><td>{0} [{1}]</td></tr>
                <tr><td>Starting:</td><td>{2}</td></tr>
                <tr><td>Ending:</td><td>{3}</td></tr>
                <tr><td>Duration:</td><td>{4}</td></tr>
                </table>" -f $Location.name, ($Location.location_id ? $Location.location_id : $Location.site_id), $StartingDate.ToString('yyyy-MM-dd'), $EndingDate.ToString('yyyy-MM-dd'), $Duration

                if ( $PSCmdlet.ShouldProcess( $Subject, 'Send-MailMessage' ) )
                {
                    Send-MailMessage @SmtpSettings -Subject $Subject -Body $Body -WarningAction:Ignore
                }

            }

        } # /ForEach-Object (Location)
    
    } # /ForEach-Object (Date)

    $ReturnCode = 0
}
catch
{
    Write-Error $_.Exception.Message
    $ReturnCode = [int]0xBAD
}
finally
{
    Write-Verbose "Finally..."

    Pop-Location

    $ReturnCode
}