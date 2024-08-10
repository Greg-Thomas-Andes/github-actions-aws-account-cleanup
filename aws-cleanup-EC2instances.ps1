# Get all EC2 instances
try {
    $instances = Get-EC2Instance
}
catch {
    Write-Host "Error listing EC2 instances: $($_.Exception.Message)"
    exit 1
}

# Check if any instances were found
if ($instances.Instances.Count -eq 0) {
    Write-Host "No EC2 instances found."
    exit 0
}

# Iterate through each instance and terminate it
foreach ($instance in $instances.Instances) {
    $instanceId = $instance.InstanceId
    Write-Host "Terminating instance: $instanceId"
    
    try {
        Remove-EC2Instance -InstanceId $instanceId -Force
        Write-Host "Successfully initiated termination of instance: $instanceId"
    }
    catch {
        Write-Host "Failed to terminate instance $instanceId. Error: $($_.Exception.Message)"
    }
}

Write-Host "Script execution completed. All instances have been queued for termination."