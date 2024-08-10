# AWS Step Function Activities removal script

# Ensure the AWS PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name AWS.Tools.StepFunctions)) {
  Install-Module -Name AWS.Tools.StepFunctions -Force -Scope CurrentUser
}
Import-Module AWS.Tools.StepFunctions

# Set your AWS credentials and region (if not already configured)
# Set-AWSCredentials -AccessKey YOUR_ACCESS_KEY -SecretKey YOUR_SECRET_KEY
# Set-DefaultAWSRegion -Region YOUR_REGION

# Get all Step Function activities
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

Write-Host "Script execution completed."