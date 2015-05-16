$APIKey = ""
$UserName = ""
$Password = ""

$RootAPIURL = "http://trackit/TrackitWebAPI/api"
$Headers = @{"TrackItAPIKey"=$APIKey}

Function Invoke-TrackITLogin {
    param(
        [parameter(Mandatory = $true)]$Username, 
        [parameter(Mandatory = $true)]$Pwd
    )
    $URL = ($RootAPIURL + "/login?username=" + $Username + "&pwd=" + $Pwd)
    $result = Invoke-RestMethod -Uri $URL -Method Get
    $script:APIKey = $result.data.apiKey
    $script:UserName = $Username
    $script:Password = $Pwd
    $script:Headers = @{"TrackItAPIKey"=$APIKey}
}

function Get-TrackITAPIURL {
    param(
        [parameter(Mandatory = $true)]$FunctionName, 
        $Parameters = @{}
    )
    $URLEncodedParameters = @{}
    $Parameters.Keys | % { $URLEncodedParameters.Add($_.ToLower(), [Uri]::EscapeDataString($Parameters[$_])) }

    $FormattedParameters = $($URLEncodedParameters.Keys | % { $_ +"/" + $URLEncodedParameters[$_] }) -join "/"

    $URL = $RootAPIURL + "/" + $FunctionName + "/" + $FormattedParameters + "/format/" + $Format
    $URL
}

function Invoke-TrackITAPIFunction {
    param(
        [parameter(Mandatory = $true)]$FunctionName,
        $Parameters = @{}
    )
    $URL = Get-KabanizeAPIURL -FunctionName $FunctionName -Parameters $Parameters
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers
}

function Get-TrackITWorkOrder {
    param(
        [parameter(Mandatory = $true)]$WorkOrderNumber
    )
    $URL = ($RootAPIURL + "/workorder/Get/" + $WorkOrderNumber)
    Invoke-RestMethod -Method Get -Uri $URL -Headers $Headers
}

function Edit-TrackITWorkOrder {
    param(
        [parameter(Mandatory = $true)]$WorkOrderNumber,
        $Id,
        $AssetName,
        $AssignedTechnician,
        $Category,
        $Location,
        $Department,
        $Hours,
        $Charge,
        $Priority,
        $RequestorName,
        $StatusName,
        $SubType,
        $Summary,
        $Type,
        $UdfText1,
        $UdfText2,
        $UdfText3,
        $UdfText4,
        $UdfText5,
        $UdfText6,
        $UdfDate1,
        $UdfDate2,
        $UdfDate3,
        $UdfDate4,
        $UdfDate5,
        $UdfDate6,
        $UdfNumeric,
        $UdfInt,
        $UdfLookup1,
        $UdfLookup2,
        $UdfLookup3,
        $UdfLookup4,
        $UdfLookup5,
        $UdfLookup6,
        $UdfLookup7,
        $UdfLookup8,
        $ParentIncidentId
    )

    $URL = ($RootAPIURL + "/workorder/update/" + $WorkOrderNumber)
    $Headers = @{"TrackItAPIKey"=$APIKey}
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($PSBoundParameters | ConvertTo-Json)

    <#$response = try { 
        Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($PSBoundParameters | ConvertTo-Json)
    } catch { 
        $Error = $_.ErrorDetails.Message|ConvertFrom-Json

        if($Error.Code -eq "Web.Lifecycle.004") {
            Invoke-TrackITLogin -Username $UserName -Pwd $Password

        <#$results = $_ | FL *
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $response = $reader.ReadToEnd();#>
    #>}
    #$response
}

function New-TrackITWorkOrder {
    param(
        $Id,
        $AssetName,
        $AssignedTechnician,
        $Category,
        $Location,
        $Department,
        $Hours,
        $Charge,
        $Priority,
        $RequestorName,
        $StatusName,
        $SubType,
        $Summary,
        $Type,
        $UdfText1,
        $UdfText2,
        $UdfText3,
        $UdfText4,
        $UdfText5,
        $UdfText6,
        $UdfDate1,
        $UdfDate2,
        $UdfDate3,
        $UdfDate4,
        $UdfDate5,
        $UdfDate6,
        $UdfNumeric,
        $UdfInt,
        $UdfLookup1,
        $UdfLookup2,
        $UdfLookup3,
        $UdfLookup4,
        $UdfLookup5,
        $UdfLookup6,
        $UdfLookup7,
        $UdfLookup8,
        $ParentIncidentId
    )
    $URL = ($RootAPIURL + "/workorder/Create")
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($PSBoundParameters | ConvertTo-Json)
}

function Edit-TrackITWorkOrderStatus {
    param(
        [parameter(Mandatory = $true)]$WorkOrderNumber,
        $Status
    )
    $URL = ($RootAPIURL + "/workorder/ChangeStatus/" + $WorkOrderNumber)
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($Status | ConvertTo-Json)
}

function Close-TrackITWorkOrder {
    param(
        [parameter(Mandatory = $true)]$WorkOrderNumber,
        $Resolution
    )
    $URL = ($RootAPIURL + "/workorder/Close/" + $WorkOrderNumber)
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($Resolution | ConvertTo-Json)
}

function Add-TrackITWorkOrderNote {
    param(
        [parameter(Mandatory = $true)]$WorkOrderNumber,
        [parameter(Mandatory = $true)]$FullText#,
        #[Switch]$Private
    )

    $URL = ($RootAPIURL + "/workorder/AddNote/" + $WorkOrderNumber)
    Invoke-RestMethod -Method Post -Uri $URL -Headers $Headers -ContentType "text/json" -Body ($PSBoundParameters | ConvertTo-Json)
}


Export-ModuleMember -function Invoke-TrackITLogin 
Export-ModuleMember -function Get-TrackITWorkOrder
Export-ModuleMember -function Edit-TrackITWorkOrder
Export-ModuleMember -function New-TrackITWorkOrder
Export-ModuleMember -function Edit-TrackITWorkOrderStatus
Export-ModuleMember -function Close-TrackITWorkOrder
Export-ModuleMember -function Add-TrackITWorkOrderNote