break
# #############################################################################
# Configure Web Apps for Scale and Resilience
# NAME: PS-70532-WEBAPPS-MOD07.ps1
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# #############################################################################
 
# Authenticate to ARM
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150dollar'
Set-AzureRmContext -SubscriptionId 7be05db5-0dea-4ffe-b309-ebbc94f0684e  # Get-AzureRmSubscription

# Create resource group
New-AzureRmResourceGroup -Name ARMResourceGroup -Location 'South Central US'

# Create app service plan
New-AzureRmAppServicePlan -ResourceGroupName 'ARMResourceGroup' -Name 'ARMServicePlan' -Location 'South Central US' -Tier Standard  -NumberofWorkers 1 -WorkerSize 'Small'

# Migrate a website to the ARMServicePlan
$plan = @{'serverfarm' = 'ARMServicePlan'}
Set-AzureRmResource -ResourceName '532scaleapp1' -ResourceGroupName 'Default-Web-SouthCentralUS' -ResourceType 'Microsoft.Web/sites' -ApiVersion '2014-04-01' -Plan $plan
# There used to be Set-AzureResource and Get-AzureResource

# What is the minimum pricing tier to support SSL certificates?
Start-Process https://azure.microsoft.com/en-us/pricing/details/app-service/plans/

# Enable Always On for an API app
Set-AzureRmResource -ResourceName '532scaleapp1' -ResourceGroupName 'Default-Web-SouthCentralUS' -ResourceType 'Microsoft.Web/sites' -ApiVersion '2014-04-01' -Properties @{"siteConfig" = @{"AlwaysOn" = $false}} 

Update-Help -Force -ErrorAction SilentlyContinue
Get-Help -Name Set-AzureRmWebApp -Online

# ARM template deployment
Set-Location -Path 'D:\azure-quickstart-templates\201-web-app-github-deploy'

Start-Process https://github.com/Azure/azure-quickstart-templates

git clone https://github.com/Azure/azure-quickstart-templates.git

psedit '.\azuredeploy.json'

psedit '.\azuredeploy.parameters.json'

New-AzureRmResourceGroupDeployment -Name TestDeployment1 `
-ResourceGroupName ARMResourceGroup `
-TemplateFile '.\azuredeploy.json' `
-TemplateParameterFile '.\azuredeploy.parameters.json'

# List app service plans
Get-AzureRmAppServicePlan -ResourceGroupName 'ARMResourceGroup'

# Scale up a service plan to a higher pricing tier
Set-AzureRmAppServicePlan -Name 'ARMServicePlan' -ResourceGroupName 'ARMResourceGroup' -Tier Standard
