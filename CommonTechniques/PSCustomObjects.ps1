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
    -- Basic introduction to Script Methods
    -- Basic introduction to formatting and TypeNames

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


#############################
# PSObject.Copy()
#############################
# PSObject.Copy() makes a clone of the object, which is separate from the original object.
# If you take an object and place it into a variable, this is just a reference to the original object.
# Changes to the new variable are actually made to the original object.

# For example, we are going to place the $Apple object into a new variable and change the name.
# We will see that the changes are not independent.
$Apple = [PSCustomObject]@{
    Name          = 'Apple'
    Type          = 'Fruit'
    Healthy       = $True
    "Price (USD)" = '0.66'
}

$OtherApple = $Apple

# Check the values of each variable
$Apple
$OtherApple

# Update the name of the Name property for the object in the new variable
$OtherApple.Name = "Red Apple"

# Check what both variables look like now. Both have been updated.
$OtherApple
$Apple

# Let's do that the other way around.
$Apple.Name = "Green Apple"

# As you see, we see the same result.
# These objects are have different variables but they reference eachother.
$OtherApple
$Apple

# To actually get different objects, use the PSObject.Copy() method.
$OtherApple = $Apple.PSObject.Copy()

# Check the values of each variable
$Apple
$OtherApple

# Update the name of the Name property for the object in the new variable
$OtherApple.Name = "Red Apple"

# Check what both variables look like now.
# Now we see that these are now independent objects.
$OtherApple
$Apple



#############################
# ScriptMethod
#############################
# Script Methods offer a PowerShell native way to quickly add Methods to an object.
# Although Methods can be very useful in PowerShell, it is probably unlikley that you will need to use ScriptMethod unless you are trying to build very advanced functions.

# Here we create a very simple method that updates the price property.
$Object = [PSCustomObject]@{
    Name          = 'Apple'
    Type          = 'Fruit'
    Healthy       = $True
    "Price (USD)" = '0.66'
}
$ScriptBlock = {
    param([double]$Value)
    $this."Price (USD)" = [double]$this."Price (USD)" + $Value
}
$Object | Add-Member -MemberType ScriptMethod -Name 'UpdatePrice' -Value $ScriptBlock

$Object
$Object.UpdatePrice(1)



#############################
# Bonus - Formatting / TypeNames
#############################

# Ever wondered why not all of the properties show on a lot of objects and you need to use Format-List in order to show them?
# This is controlled by DataTypes and Formatting Files.
# We can give our objects custom PSTypeNames, which can then be used to define the properties that are shown, plus a bunch of other things.

# Here we give our object a PSTypeName and then update the TypeData used in the session to manipulate this object.
$Object = [PSCustomObject]@{
    PSTypeName    = 'CustomObject.Food'
    Name          = 'Apple'
    Type          = 'Fruit'
    Healthy       = $True
    "Price (USD)" = '0.66'
}

# This is what the object looks like without any changes
$Object

# Now lets add some customisations for that TypeName
$TypeData = @{
    TypeName                  = 'CustomObject.Food'
    DefaultDisplayPropertySet = 'Name', 'Price (USD)'
}
Update-TypeData @TypeData

# Here we can now see that we only display two properties by default.
# If we want more, we can use Format-List
$Object
$Object | Format-List *

# For more advanced scenarios, we might want to use a formatting file which is an xml file with the extension .format.ps1xml
# These are generally used in PowerShell modules, as the format is defined in a file and then objects in the module inherit this when their TypeName matches.

# In this example, we take the same object as before, but with a differnt TypeName
$Object = [PSCustomObject]@{
    PSTypeName    = 'My.Food'
    Name          = 'Apple'
    Type          = 'Fruit'
    Healthy       = $True
    "Price (USD)" = '0.66'
}

# Again, check what the object looks like first
$Object

# Now, we import the formatting file into our session.
Update-FormatData -AppendPath "C:\Git\GitHub\PS.TrainingDemos\CommonTechniques\My.Food.format.ps1xml"

# Now we see that the changes in the formatting file have been applied to our object.
$Object