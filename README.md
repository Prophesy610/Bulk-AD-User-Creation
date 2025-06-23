# Bulk-AD-User-Creation
Bulk AD User Creation via CSV (Mail Merge Style)

## Overview

This PowerShell script simplifies the bulk creation of Active Directory (AD) user accounts by reading a CSV input file — similar to a Mail Merge approach — and provisioning each user with unique details (e.g., name, username, email, department).

## 🔗 Use Case

Perfect for system administrators needing to onboard large batches of users (e.g., 100+ employees, students, or contractors) efficiently and consistently in a Windows domain environment.

## 📄 CSV Input Format

Prepare a NewUsers.csv file with the following headers:

     FirstName,LastName,Username,Password,OU,Department,Title,Email
     John,Doe,jdoe,Welcome123!,OU=Staff,DC=domain,DC=local,IT,Analyst,jdoe@domain.local
     ...

Each row represents a unique user.

## 📜 Script: Create-ADUsers.ps1

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


## ✅ Prerequisites

   #### ✅ Active Directory PowerShell module installed

   #### ✅ Script executed from a domain-joined system with appropriate admin rights

   #### ✅ NewUsers.csv file in the same directory or provide full path

   #### ✅ Make sure the OU exists prior to running the script

## 📌 Notes

  You can customize the script to assign group membership, set profile paths, or even auto-generate usernames/passwords.

  Use secure practices — avoid hardcoded passwords in production!

## 🚀 Example Use

.\Create-ADUsers.ps1

## 🤝 Contributing

Got improvements or bug fixes? Feel free to fork and submit a pull request!
