# Set error action preference to stop on any error
$ErrorActionPreference = "Stop"

# Ensure the AWS PowerShell modules are installed and imported
if (-not (Get-Module -ListAvailable -Name AWS.Tools.Common)) {
    Install-Module -Name AWS.Tools.Common -Force -Scope CurrentUser
}
if (-not (Get-Module -ListAvailable -Name AWS.Tools.StepFunctions)) {
    Install-Module -Name AWS.Tools.StepFunctions -Force -Scope CurrentUser
}

Import-Module AWS.Tools.Common
Import-Module AWS.Tools.StepFunctions

# Get all AWS regions
$regions = Get-AWSRegion | Where-Object Region -match '^ap-(south|southeast|northeast)'

foreach ($region in $regions) {
    $regionName = $region.Region
    Write-Host "Processing region: $regionName"

    # Get all Step Function activities in the current region
    try {
        $activities = Get-SFNActivityList -Region $regionName
    }
    catch {
        Write-Host "Error getting activities in region $regionName : $_"
        continue
    }

    # Iterate through each activity
    foreach ($activity in $activities) {
        $activityName = $activity.Name
        $activityArn = $activity.ActivityArn

        Write-Host "Processing activity: $activityName"

        # Attempt to delete the activity
        try {
            Remove-SFNActivity -ActivityArn $activityArn -Region $regionName -Force
            Write-Host "Successfully removed activity: $activityName"
        }
        catch {
            Write-Host "Failed to remove activity: $activityName"
            Write-Host "Error: $($_.Exception.Message)"
            if ($_.Exception.InnerException) {
                Write-Host "Inner Exception: $($_.Exception.InnerException.Message)"
            }
        }
    }

    Write-Host "Completed processing region: $regionName"
    Write-Host "------------------------"
}

Write-Host "Script execution completed."