$CsvPath = "C:\temp\users.csv" #change to 
$Domain = "WayneManor.com"
$DefaultPassword = ConvertTo-SecureString "Secure!23" -AsPlainText -Force

$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {
    
    # Validation
    if ([string]::IsNullOrWhiteSpace($User.FirstName) -or [string]::IsNullOrWhiteSpace($User.username)) {
        Write-Warning "Skipping entry: Missing Name or username."
        continue
    }

    # 2. FIXED: Changed .Username to .username to match your validation and CSV
    $Username = $User.username 
    
    # 3. FIXED: Changed $Lastname to $User.LastName
    $Fullname = "$($User.FirstName) $($User.LastName)"
    $UPN = "$Username@$Domain"

    $UserParams = @{
        Name                  = $FullName
        SamAccountName        = $Username
        UserPrincipalName     = $UPN
        AccountPassword       = $DefaultPassword
        Enabled               = $true
        Path                  = "CN=Users,DC=WayneManor,DC=com"
        Title                 = $User.Title
        ChangePasswordAtLogon = $false
    }

    New-ADUser @UserParams
    Write-Host "Created user: $Username ($FullName)" -ForegroundColor Green
}
