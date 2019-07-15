<#
.DESCRIPTION

    This demonstration covers the use of Custom PowerShell Objects.
    Custom PowerShell Objects are one of the most useful things that anyone using PowerShell should master.
    They give you incredible control of objects and the techniques seen here can be seen in most PowerShell functions and scripts that you will come across.

    Main concepts covered here:
    -- Legacy approach
    -- New approach
    -- Updating Objects
    -- Updating existing objects
    -- PSObject.Copy()

    Extra resources with useful information:
        https://powershellexplained.com/2016-10-28-powershell-everything-you-wanted-to-know-about-pscustomobject/
#>


# There are many legacy approaches out there, but this is one of the most popular.
# It creates a new instance of PSObject and then adds new members/properties to the object one by one.
# It works, but it is now considered a legacy approach and also involves a lot of typing.
$Object = New-Object PSObject
$Object | Add-Member -MemberType NoteProperty Name -Value "Orange"
$Object | Add-Member -MemberType NoteProperty Type -Value "Fruit"
$Object | Add-Member -MemberType NoteProperty Healthy -Value $true
$Object

# Introduced in PowerShell Version 3.0
# The PSCustomObject type accelerator is the fastest and easiest way to create a new Object.
# Here is that same object.
[PSCustomObject]@{
    Name    = "Orange"
    Type    = "Fruit"
    Healthy = $true
}

# Let's save this object in a variable so we can work with it later

$Object = [PSCustomObject]@{
    Name    = "Orange"
    Type    = "Fruit"
    Healthy = $true
}

# Now, let's say that we want to add a new property to that object, this is how we do that.
$Object | Add-Member -MemberType NoteProperty -Name "Price (USD)" -Value 0.45

# Generally, it is not a good idea to use spaces and symbols in property names.
# It makes it slightly harder to work with, however this is how we can still pick out these properties at a later date.

# Accessing Property values - Usual approach
$Object.Name

# Accessing Property values - Property names with spaces and/or symbols
$Object."Price (USD)"

# Updating the value of an existing property.
$Object."Price (USD)" = 0.55



# PSCustomObject keep the properties in the order they were specified.
# However when a new property is added, it is just placed at the end of the property list.
# If you know that you do not have a value for a property yet, but want to create the Object first, create an empty object and then update the data later.
# This way the properties will be in the order you want them

$Object = [PSCustomObject]@{
    Name          = $null
    Type          = $null
    Healthy       = $null
    "Price (USD)" = $null
}
$Object.'Price (USD)' = 0.66
$Object.Name = "Apple"



# In many cases, you might not need a whole new custom object.
# Sometimes you just want to join data from one object and add it to an existing object.
# We can do this in a similar way.

# In this example, we are getting the Folder Object, but bby default Get-Item does not have the Owner information.
# No problem though, we know that we can get that from the Get-Acl cmdlet.
# Now there is no need to create a whole new object, we can simply take the Owner value and add it to the object from Get-Item

# NOTE: This does not do anything to the actual object. This only builds a logical object in PowerShell

$Folder = Get-Item -Path C:\Temp
$Folder | Add-Member -MemberType NoteProperty -Name Owner -Value (Get-Acl -Path C:\Temp).Owner
$Folder | Select-Object FullName, CreationTime, Owner


# PSObject.Copy()