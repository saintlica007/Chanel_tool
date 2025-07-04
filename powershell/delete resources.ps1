# Define the subscription id and the tag name
$subId = "ae03d72c-e0c2-4161-9029-db3b1ec8b416"
$tagName = "CreatedDate"
$holdname = 'Hold'

# Authenticate using the system-assigned managed identity
# Connect-AzAccount -Identity

# Select the subscription
Select-AzSubscription -SubscriptionId $subId

# Get all the resource groups in the subscription
$rgs = Get-AzResourceGroup

# Loop through each resource group and get the resources in it
foreach ($rg in $rgs) {
  $resources = Get-AzResource -ResourceGroupName $rg.ResourceGroupName

 # Loop through each resource and check the tag value
  foreach ($resource in $resources) {

 # Get the tag value for the current resource
    $tagValue = $resource.Tags[$tagName]
    $holdValue = $resource.Tags[$holdname]
    Write-Host "$($resource.Name) is created on $tagValue "
    if (![string]::IsNullOrEmpty($holdValue))
    {
      Write-Host "$($resource.Name) is created on $tagValue, hold is positive"
      continue
      }
 # If the tag value is not null or empty, parse it as a date
    if (![string]::IsNullOrEmpty($tagValue)) {

 # Parse the tag value as a date in mm/dd/yyyy format
      $createdDate = [datetime]::ParseExact($tagValue, "MM/dd/yyyy-HH:mm:ss", $null)

 # Calculate the difference between the current date and the created date in days
      $daysOld = (Get-Date) - $createdDate | Select-Object -ExpandProperty Days
      Write-Host "resource $($resource.Name) is $daysOld"
 # If the difference is greater than or equal to 30, delete the resource
      if ($daysOld -ge 1) {
        Write-Host "Deleting resource $($resource.Name) with tag value $tagValue"
#        Remove-AzResource -ResourceId $resource.ResourceId -Force
      }
    }
  }
}