function New-EmailYandex {
    param (
        [string]$NickName = "",
        [string]$SurName = "", 
        [string]$FirstName = "",
        [int32]$Department = "1",
        [string]$Password = "P@ssw0rd",
        [Parameter(Mandatory = $true)]
        [ValidateSet(
            'OneUser', 
            'MassUser')]
        $WorkLine,
        $PathFile = "",
        [string]$Token = "Paste_Youre_Token"
    )
    
    $ApiURL = 'https://api.directory.yandex.net'
    $ApiUser = '/v6/users/'
    $Headers = @{}
    $Headers.Authorization = 'OAuth ' + $Token
    $WorkURL = "$ApiURL" + "$ApiUser" 
    switch ($WorkLine) {
        OneUser { 
            $Body = @{}
                $Body.department = $Department
                $Body.nickname = $NickName
                $Body.password = $Password
                $Body.name = @{
                    $Body.name.first = $FirstName
                    $Body.name.last = $SurName
            }
            $Response = Invoke-RestMethod -Uri $WorkURL -Method Post -Headers $Headers -Body $Body -ContentType "application/json"    
        }
        MassUser {
            $AllData = Import-Csv -Path $PathFile -Delimiter ";" -Encoding UTF8 -Header NickName,SurName,FirstName,Department
                foreach ($Data in $AllData) {
                    $Body = @{}
                        $Body.department = $Data.Department
                        $Body.nickname = $Data.NickName
                        $Body.password = $Password
                        $Body.name = @{
                            $Body.name.first = $Data.FirstName
                            $Body.name.last = $Data.SurName
                        }
                    $Response = Invoke-RestMethod -Uri $WorkURL -Method Post -Headers $Headers -Body $Body -ContentType "application/json"    
                }
            }
        
}
    return $Response
}
