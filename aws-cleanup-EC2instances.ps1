# Import the AWS PowerShell module
Import-Module AWS.Tools.EC2

# Get all EC2 instances
$instances = Get-EC2Instance

# Check if any instances were found
if ($instances.Instances.Count -eq 0) {
    Write-Host "No EC2 instances found."
    exit
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