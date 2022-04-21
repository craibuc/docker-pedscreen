BeforeAll {
  # include script file in PS session
  . ..\Invoke-Pedscreen.ps1

}

# Pester tests
Describe 'Invoke-Pedscreen' {

    Context 'Parameter validation' {

      BeforeAll {
        $Command = Get-Command 'Invoke-Pedscreen'
      }

      Context 'SiteID' {
        BeforeAll {
          $ParameterName='SiteID'
        }

        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [string]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'LocationID' {
        BeforeAll {
          $ParameterName='LocationID'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [string]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'DepartmentID' {
        BeforeAll {
          $ParameterName='DepartmentID'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [int]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'Starting' {
        BeforeAll {
          $ParameterName='Starting'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [datetime]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'Ending' {
        BeforeAll {
          $ParameterName='Ending'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [datetime]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'Pecarn' {
        BeforeAll {
          $ParameterName='Pecarn'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [switch]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

      Context 'ListParams' {
        BeforeAll {
          $ParameterName='ListParams'
        }
        It 'is a [string' {
          $Command | Should -HaveParameter $ParameterName -Type [switch]
        }
        It 'is optional' {
          $Command | Should -HaveParameter $ParameterName -Not -Mandatory
        }
      }

    } # /context
  
    BeforeEach {
      # arrange
      Mock Invoke-Expression
    }

    Context "No parameters supplied" {
      It "runs pedscreen" {
        # act
        Invoke-Pedscreen
  
        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = 'sbt --no-colors "run "'
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }
  
    Context "SiteID supplied" {
      It "runs pedscreen with a site_id" {
        # arrange
        $SiteID='lorem'

        # act
        Invoke-Pedscreen -SiteID $SiteID

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --site_id $SiteID"""
          Write-Debug "Expected: $Expected"

          $Command -eq $Expected
        }
      }
  
    }

    Context "DepartmentID supplied" {
      It "runs pedscreen with a department_id" {
        # arrange
        $DepartmentID=123456

        # act
        Invoke-Pedscreen -DepartmentID $DepartmentID

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --department_id $DepartmentID"""
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }

    Context "Starting supplied" {
      It "runs pedscreen with a Starting date" {
        # arrange
        $Starting=[datetime]'08/01/2021'

        # act
        Invoke-Pedscreen -Starting $Starting

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --date_start $($Starting.ToString('yyyy-MM-dd'))"""
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }

    Context "Ending supplied" {
      It "runs pedscreen with a Ending date" {
        # arrange
        $Ending=[datetime]'08/30/2021'

        # act
        Invoke-Pedscreen -Ending $Ending

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --date_end $($Ending.ToString('yyyy-MM-dd'))"""
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }

    Context "Pecarn supplied" {
      It "runs pedscreen in Pecarn mode" {
        # act
        Invoke-Pedscreen -Pecarn

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --pecarn"""
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }

    Context "ListParams supplied" {
      It "runs pedscreen in parameters mode" {
        # act
        Invoke-Pedscreen -ListParams

        # assert
        Assert-MockCalled Invoke-Expression -ParameterFilter {
          $Expected = "sbt --no-colors ""run --list_params"""
          Write-Debug "Expected: $Expected"
          
          $Command -eq $Expected
        }
      }
    }
  
  } # /describe