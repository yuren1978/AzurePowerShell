break
# #############################################################################
# Implement WebJobs
# NAME: PS-70532-WEBAPPS-MOD06.ps1
# 
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# 
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

#region Log into Azure
# connect to subscription (ARM)
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150dollar'

# connect to subscription (ASM)
Add-AzureAccount
$sub = '150dollar'
$storage = '532asmstorage'
Set-AzureSubscription -SubscriptionName $sub -CurrentStorageAccountName $storage
Select-AzureSubscription -SubscriptionName $sub -Default
#endregion

Get-AzureWebsite -Name '532mvcapp1' 







