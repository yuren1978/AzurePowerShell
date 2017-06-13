break
# #############################################################################
# Deploy Web Apps
# NAME: PS-70532-WEBAPPS-MOD01.ps1
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

#region Log into Azure
# connect to subscription (ARM)
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName 'Visual Studio Ultimate with MSDN'
Set-AzureRmCurrentStorageAccount -ResourceGroupName 'Default-Web-EastUS' -StorageAccountName '**teststorage' 
Get-AzureRmSubscription

# certificate-based authentication
Get-AzurePublishSettingsFile 
Import-AzurePublishSettingsFile -PublishSettingsFile 'path'

# connect to subscription (ASM)
Add-AzureAccount
Select-AzureSubscription -SubscriptionName 'Visual Studio Ultimate with MSDN' -Default
Set-AzureSubscription -SubscriptionName 'Visual Studio Ultimate with MSDN' -CurrentStorageAccountName '**teststorage'
#endregion

#region Slot management - PowerShell (ARM)

# ASM is weak with deployment slots
Get-Command -Module Azure -noun *slot*
Update-Help -Force -ErrorAction SilentlyContinue
Get-Help -Name Switch-AzureWebsiteSlot -ShowWindow
Start-Process https://msdn.microsoft.com/en-us/library/dn722464.aspx

# Get regions
Get-AzureLocation | Where { $_.Displayname –match 'US' } | Format-Table

# Create web app
New-AzureRmWebApp -ResourceGroupName [resource group name] -Name [web app name] -Location [location] -AppServicePlan [app service plan name]

# Create deployment slot
New-AzureRmWebAppSlot -ResourceGroupName [resource group name] -Name [web app name] -Slot [deployment slot name] -AppServicePlan [app service plan name]

# Swap deployment slot
$ParametersObject = @{targetSlot  = "[slot name – e.g. 'production']"}
Invoke-AzureRmResourceAction -ResourceGroupName [resource group name] -ResourceType Microsoft.Web/sites/slots -ResourceName [web app name]/[slot name] -Action slotsswap -Parameters $ParametersObject -ApiVersion 2015-07-01

# Delete deployment slot
Remove-AzureRmResource -ResourceGroupName [resource group name] -ResourceType Microsoft.Web/sites/slots –Name [web app name]/[slot name] -ApiVersion 2015-07-01

# Sets 3 web role instances to the production slot
Set-AzureRole -ServiceName 'cloudservice' -RoleName 'mywebrole' -Slot 'Production' -Count 3

#endregion

#region Slot management - Azure CLI

# login
azure login

# select subscription
azure account list
azure account set Azure-sub-2

# configure mode
azure config mode arm
azure config mode asm

# Site list
azure site list webappslotstest

# Create staging deployment slot
azure site create webappslottest --slot staging --git

# Site swap
azure site swap webappslotstest

# Delete slot
azure site delete webappslottest --slot staging

# logout
azure logout -u tsw2002@comcast.net

#endregion

#region Web Deploy packages

#ARM can get complex
Start-Process http://timw.info/msdeploy

Publish-AzureWebsiteProject -Name site1 -ProjectFile .\WebApplication1.csproj -Configuration Debug

Publish-AzureWebsiteProject -Name 532webapp -Package 'E:\sites\package.zip' -Slot 'dev2'

Publish-AzureWebsiteProject -Name site1 -ProjectFile .\WebApplication1.csproj -ConnectionString @{ DefaultConnection = "my connection string" }

Publish-AzureWebsiteProject -Name site1 -ProjectFile .\WebApplication1.csproj -DefaultConnection "my connection string"


#endregion







