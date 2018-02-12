$TenantName = "Your_Domain_Name"

Function GetAuthToken
{
       param
       (
              [Parameter(Mandatory=$true)]
              $TenantName
       )
 
       $adal = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
       $adalforms = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
 
       [System.Reflection.Assembly]::LoadFrom($adal) | Out-Null
       [System.Reflection.Assembly]::LoadFrom($adalforms) | Out-Null
 
       $clientId = "1950a258-227b-4e31-a9cf-717495945fc2" 
       $redirectUri = "urn:ietf:wg:oauth:2.0:oob"
       $resourceAppIdURI = "https://graph.windows.net"
       $authority = "https://login.windows.net/$TenantName"
       $authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority
       $authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId,$redirectUri, "Auto")
 
       return $authResult
}
 
 $token = GetAuthToken -TenantName $TenantName
 # Building Rest Api header with authorization token
$authHeader = @{
   'Content-Type'='application\json'
   'Authorization'=$token.CreateAuthorizationHeader()
}


$uri = "https://graph.windows.net/$TenantName/activities/auditActivityTypes?api-version=beta"
$activityTypes = (Invoke-RestMethod -Uri $uri –Headers $authHeader –Method Get –Verbose).activityTypes
$activityTypes | Out-GridView