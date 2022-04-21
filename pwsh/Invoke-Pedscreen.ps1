<#
.SYNOPSIS
Run the pedscreen application.

.PARAMETER SiteID
The site identifier; matches the subfolders.

.PARAMETER LocationID
The location identifier.

.PARAMETER DepartmentID
A CLARITY_DEP.DEPARTMENT_ID value.

.PARAMETER Starting
The start of the period.  Default: first day of the prior month.

.PARAMETER Ending
The end of the period.  Default: last day of the prior month.

.PARAMETER Pecarn
Use PECARN mode.

.PARAMETER ListParams
Display all pedscreen parameter values.

.EXAMPLE
# include script file in the PowerShell session
PS> . .\Invoke-Pedscreen.ps1

# run the script in PECARN mode
PS> Invoke-Pedscreen -Pecarn

.EXAMPLE
# include script file in the PowerShell session
PS> . .\Invoke-Pedscreen.ps1

# run the script in PECARN mode, specifying the site, location, and department, for last month's ED visits
PS> Invoke-Pedscreen -SiteID 'choa' -LocationID 'chag' -DepartmentID 211500

.EXAMPLE
# include script file in the PowerShell session
PS> . .\Invoke-Pedscreen.ps1

# display the settings
PS> Invoke-Pedscreen -ListParams

#>
function Invoke-Pedscreen
{
    [CmdletBinding(SupportsShouldProcess)]
    param 
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('site_id')]
        [string]$SiteID,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('location_id')]
        [string]$LocationID,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('department_id')]
        [int]$DepartmentID,

        [datetime]$Starting,

        [datetime]$Ending,

        [switch]$Pecarn,

        [switch]$ListParams,

        [switch]$Continue,

        [switch]$NoOutput
    )

    Begin {}

    Process {

        $Flags=@()

        if (![string]::IsNullOrEmpty($SiteID)) { $Flags += "--site_id $SiteID"}
        if ($LocationID) { $Flags += "--location_id $LocationID"}
        if ($DepartmentID) { $Flags += "--department_id $DepartmentID"}
        if ($Starting) { $Flags += "--date_start $( $Starting.ToString('yyyy-MM-dd') )"}
        if ($Ending) { $Flags += "--date_end $( $Ending.ToString('yyyy-MM-dd') )"}
        if ($Pecarn.IsPresent) { $Flags += "--pecarn"}
        if ($ListParams.IsPresent) { $Flags += "--list_params"}    
        if ($Continue.IsPresent) { $Flags += "--continue"}
        if ($NoOutput.IsPresent) { $Flags += "--no_output"}

        $Expression = "sbt --no-colors ""run $($Flags -join ' ')"""
        Write-Debug "Expression: $Expression"
    
        if ($PSCmdlet.ShouldProcess($Expression, 'Invoke-Expression'))
        {
            Invoke-Expression -Command $Expression
        }
        
    }

    End {}

}
