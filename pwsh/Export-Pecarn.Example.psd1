@{
    Pedscreen = @{
        # https://github.com/chop-dbhi/ped-screen/blob/main/doc/Using_Pedscreen.md#supported-program-parameters
        pecarn = $true
        list_params = $true
        continue = $false
        no_output = $false
        <#
        Dates = @(
            @{Starting='1/1/2019';Ending='1/31/2019'}
            @{Starting='2/1/2019';Ending='2/28/2019'}
            @{Starting='3/1/2019';Ending='3/31/2019'}
            @{Starting='4/1/2019';Ending='4/30/2019'}
            @{Starting='7/1/2019';Ending='7/31/2019'}
            @{Starting='10/1/2019';Ending='10/31/2019'}
        )
        #>
        Locations = @(
            @{
                site_id = 'XXXX'
                location_id = 'AAAA'
                department_id = 000000
                name = "Department A"
                disabled = $false # location won't be processed
            }
            @{
                site_id = 'XXXX'
                location_id = 'AAAB'
                department_id = 000000
                name = "Department B"
                disabled = $false
            }
            @{
                site_id = 'XXXX'
                location_id = 'AAAC'
                department_id = 000000
                name = "Department C"
                disabled = $false
            }
        )
        # directory containing pedscreen's build.sbt file
        BuildDirectory='~\Documents\ped-screen'
    }
}