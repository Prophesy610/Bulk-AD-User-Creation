Import-Module ActiveDirectory

# Path to your CSV file
$csvPath = ".\NewUsers.csv"

# Import users from CSV
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
    $fullName = "$($user.FirstName) $($user.LastName)"
    $userPrincipalName = "$($user.Username)@domain.local"

    try {
        New-ADUser `
            -Name $fullName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -SamAccountName $user.Username `
            -UserPrincipalName $userPrincipalName `
            -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
            -Enabled $true `
            -Path $user.OU `
            -Department $user.Department `
            -Title $user.Title `
            -EmailAddress $user.Email `
            -ChangePasswordAtLogon $true

        Write-Host "✅ Created user: $fullName" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to create user $fullName: $_" -ForegroundColor Red
    }
}
