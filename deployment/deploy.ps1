param(

    [string]
    $subscription,

    [string]
    $location = "uk south",

    [string]
    $assetPrefix

)

$asset = "$assetPrefix-func"

$account = az account show | ConvertFrom-Json -Depth 10
if (!($account -and $account.name -eq $subscription)) {
    az login
    az account set -s $subscription
}

az group create --location $location --name $asset
az deployment group create --mode Incremental `
    --resource-group $asset  `
    --template-file deployment/main.bicep `
    --parameters asset=$asset location=$location

func azure functionapp publish $asset
