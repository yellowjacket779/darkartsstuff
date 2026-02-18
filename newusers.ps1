$CsvPath = "C:\temp\users.csv" 
$Domain = "WayneManor.com"
$DefaultPassword = ConvertTo-SecureString "Secure!23" -AsPlainText -Force

$Users = Import-Csv -Path $CsvPath

foreach ($User in $Users) {
    
    # Validation
    if ([string]::IsNullOrWhiteSpace($User.FirstName) -or [string]::IsNullOrWhiteSpace($User.UserID)) {
        Write-Warning "Skipping entry: Missing Name or UserID."
        continue
    }

    # 2. FIXED: Changed .Username to .UserID to match your validation and CSV
    $Username = $User.UserID 
    
    # 3. FIXED: Changed $Lastname to $User.LastName
    $Fullname = "$($User.FirstName) $($User.LastName)"
    $UPN = "$Username@$Domain"

    $UserParams = @{
        Name                  = $FullName
        SamAccountName        = $Username
        UserPrincipalName     = $UPN
        AccountPassword       = $DefaultPassword
        Enabled               = $true
        Path                  = "OU=Users,DC=company,DC=com"
        Title                 = $User.Title
        ChangePasswordAtLogon = $false
    }

    # This runs without try/catch (as requested)
    New-ADUser @UserParams
    Write-Host "Created user: $Username ($FullName)" -ForegroundColor Green
}
