<#
.DESCRIPTION

    This demo introduces the use of TypeAccelerators.
    TypeAccelerators are aliases for .NET classes or types and make using these classes much easier.
    There is a chance that you are already using TypeAccelerators without even knowing it.

    Main concepts covered here:
    -- Checking for TypeAccelerators
    -- Common TypeAccelerators
    -- Comparison of long hand vs TypeAccelerators


    Extra resources with useful information:
        https://4sysops.com/archives/using-powershell-type-accelerators/
        https://devblogs.microsoft.com/scripting/use-powershell-to-find-powershell-type-accelerators/

#>


# We can use the following to check what Type Accelerators ae available
[PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get | Sort-Object -Property Key
([PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get).Count


###########################
# Common TypeAccelerators #
###########################

[DateTime]          # System.DateTime
[GUID]              # System.Guid
[Hashtable]         # System.Collections.Hashtable
[int]               # System.Int32
[IPAddress]         # System.Net.IPAddress
[MailAddress]       # System.Net.Mail.MailAddress
[PSCredential]      # System.Management.Automation.PSCredential
[PSCustomObject]    # System.Management.Automation.PSObject
[string]            # System.String
[switch]            # System.Management.Automation.SwitchParameter
[uri]               # System.Net.Mail.MailAddress
[Version]           # System.Version
[xml]               # System.Xml.XmlDocument


# Type Accelerators are simply shortcuts/aliases to .NET classes
# Here are a few examples are the long hand vs the Type Accelerators way.

# Integer
[System.Int32]20
[int]20

# String
[System.String]"Demo"
[String]"Demo"

####################################################
$Password = ConvertTo-SecureString 'SimplePassword' -AsPlainText -Force
# Creating a Credential Object
# https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSCredential

[System.Management.Automation.PSCredential]::new('User1', $Password)

# Creating custom Credential Objects the Type Accelerators way
[PSCredential]::new('User1', $Password)


####################################################
# Creating custom PowerShell Objects
# https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.PSObject
[System.Management.Automation.PSObject]@{
    Index         = [int]"1"
    PropertyName1 = "Demo Object"
    Author        = "Josh Wright"
}

# Creating custom PowerShell Objects the Type Accelerators way
[PSCustomObject]@{
    Index         = [int]"1"
    PropertyName1 = "Demo Object"
    Author        = "Josh Wright"
}

####################################################
# Creating a URi object
# https://docs.microsoft.com/en-us/dotnet/api/system.uri
[System.Uri]"https://example.com/help"

# Creating custom URi objects the Type Accelerators way
[uri]::new("https://example.com/help")
# OR simply...
[uri]"https://example.com/help"


####################################################
#
# https://docs.microsoft.com/en-us/dotnet/api/system.timespan
# Initializes a new instance of the TimeSpan structure to a specified number of hours, minutes, and seconds.
[System.TimeSpan]::new(1, 0, 0)

# Creating timespan objects the Type Accelerators way
[TimeSpan]::new(1, 0, 0)


####################################################
# Creating version objects
# https://docs.microsoft.com/en-us/dotnet/api/System.Version
[System.Version]::new("1.1.20")

# Creating version objects the Type Accelerators way
[version]::new("1.1.20")
# OR simply...
[version]"1.1.20"