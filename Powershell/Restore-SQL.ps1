<#
.SYNOPSIS
 This script restores SQL Database.
.DESCRIPTION

1.  Check for the existence of a database named ClientDB. Output a message to the console that indicates if the database exists or if it does not. If it already exists, delete it and output a message to the console that it was deleted.

2.  Create a new database named “ClientDB” on the Microsoft SQL server instance. Output a message to the console that the database was created.

3.  Create a new table and name it “Client_A_Contacts” in your new database. Output a message to the console that the table was created.

4.  Insert the data (all rows and columns) from the “NewClientData.csv” file (found in the attached “Requirements2” folder) into the table created in part D3.
.OUTPUTS
Outputs results in a text file.

.EXAMPLE
C:\Source\Requirements2\SqlResults.txt

.NOTES

Author: Haris Faheem 
Student ID: 
Date: 7/15/2022
#>

try {
    
    #import SqlServer Module
    if (Get-Module -Name sqlps) {
        Remove-Module sqlps}
    Import-Module -Name SqlServer
    

    #check to see if database exists 
    $sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"
    if  ($null -eq $looksForDB ) 
    {
       
        Write-Host "$databaseName Not Found! Creating $databaseName " -ForegroundColor Cyan
    
        $sqlServerObject = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $sqlServerInstanceName
        $databaseObject = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $sqlServerObject, $databaseName
        $databaseObject.Create()
        $looksForDB = Get-SqlDatabase -ServerInstance $sqlServerInstanceName -Name $databaseName
    }

    else {
        Write-Host "$databaseName Exists!" -ForegroundColor Green
    }


    #Creating a Table
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Database $databaseName -InputFile C:\Source\Requirements2\CreatTable_ClientDB.sql

    # Adding Records From a CSV file
    $Insert = "INSERT INTO [$("Client_A_Contacts")] (first_name, last_name, city, county, zip, officePhone, mobilePhone)"
    $newClientData = Import-Csv C:\Source\Requirements2\NewClientData.csv

    foreach ($NewClient in $newClientData) 
    {
     $Values = "VALUES ( `
                    '$($NewClient.first_name)', `
                    '$($NewClient.last_name)', `
                    '$($NewClient.city)', `
                    '$($NewClient.county)', `
                    '$($NewClient.zip)', `
                    '$($NewClient.officePhone)', `
                    '$($NewClient.mobilePhone)')"
    $query =$Insert + $Values
    Invoke-Sqlcmd -Database $databaseName -ServerInstance $sqlServerInstanceName -Query $query
        
    }

}
catch { 
    Write-Host "An Error Occurred while Runnig this script!" -ForegroundColor Red
    
}
Write-Host "Restore Completed !" -ForegroundColor Green