[System.Xml.XmlWriterSettings] $XmlSettings = New-Object System.Xml.XmlWriterSettings

#Preserve Windows formating
$XmlSettings.Indent = $true

$FilePath="$(Get-Location)\DataModelerTypes\dr_custom_scripts.xml"
Write-Host "Path for the file: $FilePath"
[XML]$XmlDocument =(Select-Xml -Path $FilePath -XPath /).Node
# Get the items collection
$items = $XmlDocument.dr_custom_scripts
# Sort the items and store in $orderedItemsSCR
$orderedItemsSCR_all = $items.scr | Where-Object -Property object -NE "logical" | Where-Object -Property object -NE "relational"
$orderedItemsSCR_Logical = $items.scr | Where-Object -Property object -EQ "logical" | Sort-Object -Property Name
$orderedItemsSCR_Relational = $items.scr | Where-Object -Property object -EQ "relational" | Sort-Object -Property Name
#lib
$orderedItems_LIB = $items.lib
#ddl_transformation_script_set
$orderedItems_DTSS = $items.ddl_transformation_script_set
# Removed existing items from xml variable
$items.RemoveAll()
# Append sorted items
$orderedItemsSCR_all | ForEach-Object { $items.AppendChild($_) }
$orderedItemsSCR_Logical | ForEach-Object { $items.AppendChild($_) }
$orderedItemsSCR_Relational | ForEach-Object { $items.AppendChild($_) }
$orderedItems_LIB | ForEach-Object { $items.AppendChild($_) }
$orderedItems_DTSS | ForEach-Object { $items.AppendChild($_) }

#Preserve Windows formating
$XmlSettings.Indent = $true

#Keeping UTF-8 without BOM
$XmlSettings.Encoding = New-Object System.Text.UTF8Encoding($false)
$FilePath="$(Get-Location)\DataModelerTypes\dr_custom_scripts.xml"
[System.Xml.XmlWriter]$XmlWriter = [System.Xml.XmlWriter]::Create($FilePath, $XmlSettings)
$XmlDocument.Save($XmlWriter)
#Close Handle and flush
$XmlWriter.Dispose()