<#
.DESCRIPTION

    This demo introduces the use of .NET classes in PowerShell.
    We will see some basic examples of invoking methods and accessing properties.
    To finish, we will see how we can load a 3rd party DLL and access its methods.

    Main concepts covered here:
    -- Background
    -- Checking what's available
    -- Invoking methods
    -- Accessing properties
    -- ActiveDirectory example
    -- Loading custom DLLs
    -- WinSCP example


    Extra resources with useful information:
        https://4sysops.com/wiki/useful-net-classes-for-powershell/


    Requires:
        Dowload .NET assembly / COM library from https://winscp.net/eng/downloads.php
        Extract the ZIP to C:\Temp\WinSCPAutomation

#>

# It is usually possible to get the job done in PowerShell by just using Cmdlets and Functions.
# However, there are times where some functionality is not available in an existing function for cmdlet.
#
# For those times, you may find it useful to drive directly into .NET and use the classes defined there.
# We are then able to access methods and properties from these classes.
#
# If using Microsoft classes, it useful to refer to the .NET API documentation, previously on MSDN:
# https://docs.microsoft.com/en-us/dotnet/api/
#
# Many other products use .NET and can be used in PowerShell. Check the vendor's documentation for help with these.
# Microsoft also publish product specific .NET documentation in other places, such as the SCCM SDK:
# https://docs.microsoft.com/en-us/sccm/develop/core/misc/system-center-configuration-manager-sdk
#
#


# To see a list of extended type data currently loaded, use Get-TypeData
Get-TypeData

# To see a list of assemblies loaded in this session using the following:
[System.AppDomain]::CurrentDomain.GetAssemblies()

# Let's check the properties of a single assembly and what ExportedTypes are available
[System.AppDomain]::CurrentDomain.GetAssemblies()[0] | Format-List *


##################
# Common Classes #
##################

# NOTE, methods are invoked by using parentheses. Some will require one or more values to be passed to them.
# Properties do not end in anything and do not take parameters.

# DateTime is probably one of the most common classes that people use within PowerShell.
# Working with dates and times can be difficult and this class has tons of goddies already built-in.
# https://docs.microsoft.com/en-us/dotnet/api/system.datetime
#
# Popular properties
[datetime]::Now
[datetime]::UtcNow
[datetime]::Today

# Popular methods
# Documentation: static int DaysInMonth(int year, int month)
[datetime]::DaysInMonth(2019, 10)
[datetime]::FromFileTime(132166673169758807)
[datetime]::IsLeapYear(2019)

# This method is very good for ensuring that strings of dates are converted to DateTime objects in the correct way.
# We tell the method which format the datetime is in and it will provide a datetime object in the current culture.
[datetime]::ParseExact("12/30/2019", "MM/dd/yyyy", $null)
[datetime]::ParseExact("30/12/2019", "dd/MM/yyyy", $null)

# https://docs.microsoft.com/en-us/dotnet/api/system.io.fileinfo
[System.IO.File]::GetCreationTime("C:\Windows\regedit.exe")
[System.IO.File]::GetAttributes("C:\Windows\regedit.exe")

# https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.fileversioninfo
[System.Diagnostics.FileVersionInfo]::GetVersionInfo("C:\Windows\regedit.exe")


############################
# Active Directory example #
############################
# Using .NET classes can also be useful when you don't want to install modules on all computers.
# For example, most computers will not have the ActiveDirectory PowerShell module installed, however they should all have the base .NET classes.
# These are available, as the computer needs these in order to function on the domain.
#
# Here we will perform an AD search by doing the following:
# --Get information about the current computer's domain
# --Create a DirectorySearcher object
# --Set the domain as the SearchRoot
# --Set an LDAP filter
# --Select the properties to return
# --Execute the search
$DomainObject = [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()
$ADSISearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
$ADSISearcher.SearchRoot = $DomainObject.GetDirectoryEntry()
$ADSISearcher.Filter = "(&(objectClass=Computer)(operatingSystem=Windows Server*))"
$ADSISearcher.PropertiesToLoad.Add("name") | Out-Null
$ADSISearcher.PropertiesToLoad.Add("description") | Out-Null
$ADComputers = $ADSISearcher.FindAll()
$ADComputers


##################
# Importing DLLs #
##################
# Importing other classes from DLLs
# In this example, we will import the the WinSCP .NET DLL, which will allow us to use classes within this DLL.
# https://winscp.net/eng/docs/library_powershell
#
# We will first unblock the file to allow it to be loaded, then import it into the session.
$WinSCPFile = "C:\Temp\WinSCPAutomation\WinSCPnet.dll"
Get-ChildItem -Path (Split-Path $WinSCPFile -Parent) -Recurse | Unblock-File
Add-Type -Path $WinSCPFile

# We can check the types that are exposed using the following two lines
$WinSCPAssembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.Modules -match "WinSCPnet.dll" }
$WinSCPAssembly.ExportedTypes | Select-Object -Property Name | Sort-Object -Property Name


##################
# WinSCP Example #
##################
# Download a file using SFTP
# https://winscp.net/eng/docs/library_session_getfiles
$SessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol              = [WinSCP.Protocol]::Sftp
    HostName              = "test.rebex.net"
    UserName              = "demo"
    Password              = "password"
    SshHostKeyFingerprint = "ssh-ed25519 256 d7Te2DHmvBNSWJNBWik2KbDTjmWtYHe2bvXTMM9lVg4="
}
$Session = New-Object WinSCP.Session
$Session.Open($SessionOptions)

$TransferOptions = New-Object WinSCP.TransferOptions
$TransferOptions.TransferMode = [WinSCP.TransferMode]::Binary

$Session.GetFiles("/pub/example/readme.txt", "C:\Temp\DownloadedFile.txt", $false, $TransferOptions)