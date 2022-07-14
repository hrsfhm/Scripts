<#
.SYNOPSIS
 This script prompts the user for input to complete various tasks until the user selects a prompt to exit the script.
.DESCRIPTION
A.  Create a PowerShell script named “prompts.ps1” within the “Requirements1” folder. For the first line, create a comment and include your first and last name along with your student ID.


Note: The remainder of this task should be completed within the same script file, prompts.ps1.


B.  Create a “switch” statement that continues to prompt a user by doing each of the following activities, until a user presses key 5:

1.  Using a regular expression, list files within the Requirements1 folder, with the .log file extension and redirect the results to a new file called “DailyLog.txt” within the same directory without overwriting existing data. Each time the user selects this prompt, the current date should precede the listing. (User presses key 1.)

2.  List the files inside the “Requirements1” folder in tabular format, sorted in ascending alphabetical order. Direct the output into a new file called “C916contents.txt” found in your “Requirements1” folder. (User presses key 2.)

3.  List the current CPU and memory usage. (User presses key 3.)

4.  List all the different running processes inside your system. Sort the output by virtual size used least to greatest, and display it in grid format. (User presses key 4.)

5.  Exit the script execution. (User presses key 5.)


C.  Apply scripting standards throughout your script, including the addition of comments that describe the behavior of each of parts B1–B5.


D.  Apply exception handling using try-catch for System.OutOfMemoryException.

.INPUTS
1-5

.OUTPUTS
Outputs the selected option to the screen

.EXAMPLE
PS.\C:\Source\Requirements1\C916contents.txt

.NOTES

Author: Haris Faheem 
Student ID: 001282031
Date: 7/7/2022
#>

# Try satement - code to run that will prompt user for options 1-5
try {
    # While loop excutes until the user inputs 5 to exit the script.
    while ($userInput -ne 5 ) {
        # Shows user a menu to select from.
        Write-Host "
        1. List files within the Requirements1 folder with .log extension (Output location C\Source\Requirements1\Dailylog.txt) .
        2. List all the files inside the Requirements1 folder. (output location C\Source\Requirements1\C916contents.txt)
        3. List the current CPU and memory usage.
        4. List all the different running process inside your system.
        5. Exit!" -ForegroundColor Magenta

        #User inputs number from the menu when prompted. 
        Write-Host "---Please Choose an option (1-5)---" -ForegroundColor Green
        $userInput = Read-Host "----->"
    
        # switch that shows what each slection number does to perfomed the required output for each prompt option 1-4 and 5 is exit.
        switch ($userInput) {
            
            # (User chooses option 1)
            1{ "TimeStamp: " + (Get-Date) | Out-File -FilePath $PSScriptRoot\Dailylog.txt -Append
                Get-ChildItem -Path $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\Dailylog.txt -Append}


            # (User chooses option 2)
            2{Get-ChildItem "$PSScriptRoot" | Sort-Object Name | Format-Table -AutoSize -Wrap | Out-File -FilePath "$PSScriptRoot\C916content.txt" }
            

            # (User chooses option 3)
            3{ $counterList = "\Processor(_total)\% Processor Time", "\Memory\Committed Bytes"
                Get-Counter -Counter $counterList -MaxSamples 4 -SampleInterval 5 }


            # (User chooses option 4)
            4{Get-Process | Select-Object Id, Name, VM | Sort-Object VM | Out-GridView  }


            # (User chooses option 5)
            5{  }
            Default {}
        }
    }
    


}
# Catch statement that outputs an error  when maximim value of used memory for the current shell is Reached
catch [System.OutOfMemoryException] {
    
    Write-Host "Maximim value of used memory for the current shell is Reached!" -ForegroundColor Red
}