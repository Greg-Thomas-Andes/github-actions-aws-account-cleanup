# AWS Step Function State Machines removal script

# Ensure the AWS PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name AWSPowerShell)) {
  Install-Module -Name AWSPowerShell -Force -Scope CurrentUser
}
Import-Module AWSPowerShell

# Set your AWS credentials and region (if not already configured)
# Set-AWSCredentials -AccessKey YOUR_ACCESS_KEY -SecretKey YOUR_SECRET_KEY
# Set-DefaultAWSRegion -Region YOUR_REGION

# Get all Step Function state machines
$stateMachines = Get-SFNStateMachineList

# Iterate through each state machine
foreach ($stateMachine in $stateMachines) {
  $stateMachineName = $stateMachine.Name
  $stateMachineArn = $stateMachine.StateMachineArn

  Write-Host "Processing state machine: $stateMachineName"

  # Get the current state machine definition
  $currentDefinition = Get-SFNStateMachine -StateMachineArn $stateMachineArn

  # Parse the current definition (assuming it's in JSON format)
  $definitionObject = $currentDefinition.Definition | ConvertFrom-Json

  # Remove the current item from the state machine
  # Note: This is a placeholder. You need to specify how to identify and remove the "current item"
  # For example, you might remove a specific state or modify the state machine structure

  # Convert the modified definition back to JSON
  $newDefinition = $definitionObject | ConvertTo-Json -Depth 100

  # Update the state machine with the new definition
  try {
      Update-SFNStateMachine -StateMachineArn $stateMachineArn -Definition $newDefinition
      Write-Host "Successfully updated state machine: $stateMachineName"
  }
  catch {
      Write-Host "Failed to update state machine: $stateMachineName"
      Write-Host "Error: $_"
  }
}

Write-Host "Script execution completed."