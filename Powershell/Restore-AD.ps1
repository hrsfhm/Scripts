<#
.SYNOPSIS
 This script restores AD.
.DESCRIPTION

1.  Check for the existence of an Active Directory Organizational Unit (OU) named “Finance.” Output a message to the console that indicates if the OU exists or if it does not. If it already exists, delete it and output a message to the console that it was deleted.

2.  Create an OU named “Finance.” Output a message to the console that it was created.

3.  Import the financePersonnel.csv file (found in the attached “Requirements2” directory) into your Active Directory domain and directly into the finance OU. Be sure to include the following properties:

•   First Name

•   Last Name

•   Display Name (First Name + Last Name, including a space between)

•   Postal Code

•   Office Phone

•   Mobile Phone
.OUTPUTS
Outputs results in a text file.

.EXAMPLE
C:\Source\Requirements2\AdResults.txt

.NOTES

Author: Haris Faheem 
Student ID: 
Date: 7/15/2022
#>

try {
    #Creating an Organizational Unit
    Write-Host -ForegroundColor Cyan "[AD]: Starting Active Directory Tasks."
    $AdRoot = (Get-ADDomain).DistinguishedName
    $DnsRoot = (Get-ADDomain).DNSRoot
    $OUCanonicalName = "Finance"
    $OUDisplayName = "Finance"
    $ADPath ="OU=$($OUCanonicalName),$($AdRoot)"

    #Checks if OU exists if it doesnt it Creats a OU
    if (-Not([ADSI]::Exists("LDAP://$($ADPath)"))) {
        New-ADOrganizationalUnit -Path $AdRoot -Name $OUCanonicalName -DisplayName $OUDisplayName -ProtectedFromAccidentalDeletion $false
        Write-Host -ForegroundColor Green "[AD]: $($OUCanonicalName) OU Created"
    }
    else {
        Write-Host "$($OUCanonicalName) Already Exists!" -ForegroundColor Green
    }

    #Adding AD Users from a CSV File
    $financeCSVPath = "C:\Source\Requirements2\financePersonnel.csv"
    $NewADUsers = Import-Csv $financeCSVPath 
    $Path = "OU=Finance,DC=consultingfirm,DC=com"
    
    foreach ($ADUser in $NewADUsers) 
    {
        $First = $ADUser.First_Name
        $Last = $ADUser.Last_Name
        $Name = $First + " " + $Last
        $SamAcct = $ADUser.samAccount
        $Postal = $ADUser.PostalCode
        $Office = $ADUser.OfficePhone
        $Mobile = $ADUser.MobilePhone
        
    # Use Variables to create each user
      New-ADUser    -GivenName $First `
                    -Surname $Last `
                    -Name $Name `
                    -SamAccountName $SamAcct `
                    -DisplayName $Name `
                    -PostalCode $Postal `
                    -MobilePhone $Mobile `
                    -OfficePhone $Office `
                    -Path $path `
        
    }
    
}
catch {
    Write-Host "An Error Occurred while Runnig this script!" -ForegroundColor Red
}