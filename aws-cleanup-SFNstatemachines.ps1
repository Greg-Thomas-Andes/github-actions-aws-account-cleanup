# AWS Step Function State Machines removal script

# Ensure the AWS PowerShell module is imported
Import-Module AWS.Tools.StepFunctions

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

    # Get the current state machine definition
    try {
        $currentDefinition = Get-SFNStateMachine -StateMachineArn $stateMachineArn
    }
    catch {
        Write-Host "Error getting state machine definition for $stateMachineName`: $($_.Exception.Message)"
        continue
    }

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
        Write-Host "Error: $($_.Exception.Message)"
    }
}

Write-Host "Script execution completed."