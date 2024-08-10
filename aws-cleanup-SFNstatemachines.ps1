# AWS Step Function State Machines removal script

# Ensure the AWS PowerShell module is imported
Import-Module AWS.Tools.StepFunctions

# Set error action preference to continue
$ErrorActionPreference = "Continue"

# Get all Step Function state machines
try {
    $stateMachines = Get-SFNStateMachineList
}
catch {
    Write-Host "Error listing state machines: $($_.Exception.Message)"
    exit 1
}

# Iterate through each state machine
foreach ($stateMachine in $stateMachines) {
    $stateMachineName = $stateMachine.Name
    $stateMachineArn = $stateMachine.StateMachineArn

    Write-Host "Processing state machine: $stateMachineName"

    # Delete the state machine without confirmation
    try {
        Remove-SFNStateMachine -StateMachineArn $stateMachineArn -Force
        Write-Host "Successfully deleted state machine: $stateMachineName"
    }
    catch {
        Write-Host "Failed to delete state machine: $stateMachineName"
        Write-Host "Error: $($_.Exception.Message)"
    }
}

# Reset error action preference
$ErrorActionPreference = "Stop"

Write-Host "Script execution completed."