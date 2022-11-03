param(

    [string]
    $subscription,

    [string]
    $assetPrefix

)

$asset = "$assetPrefix-func"

$account = az account show | ConvertFrom-Json -Depth 2
if (!($account -and $account.name -eq $subscription)) {
    az login
    az account set -s $subscription
}

az group delete --name $asset

az logout
