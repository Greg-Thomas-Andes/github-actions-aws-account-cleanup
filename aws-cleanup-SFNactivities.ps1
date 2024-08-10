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
$regions = Get-AWSRegion

foreach ($region in $regions) {
  $regionName = $region.Region
  Write-Host "Processing region: $regionName"

  # Set the AWS region
  Set-AWSDefaultRegion -Region $regionName

  # Get all Step Function activities in the current region
  $activities = Get-SFNActivityList

  # Iterate through each activity
  foreach ($activity in $activities) {
      $activityName = $activity.Name
      $activityArn = $activity.ActivityArn

      Write-Host "Processing activity: $activityName"

      # Attempt to delete the activity
      try {
          Remove-SFNActivity -ActivityArn $activityArn
          Write-Host "Successfully removed activity: $activityName"
      }
      catch {
          Write-Host "Failed to remove activity: $activityName"
          Write-Host "Error: $_"
      }
  }

  Write-Host "Completed processing region: $regionName"
  Write-Host "------------------------"
}

Write-Host "Script execution completed."