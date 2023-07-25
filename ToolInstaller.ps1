Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope process

# Run the command 'python -V' to get Python version, and redirect stderr into stdout
$p = & { python -V } 2>&1

# Check if an ErrorRecord was returned (indicating that Python is not installed)
$version = if ($p -is [System.Management.Automation.ErrorRecord]) {
    # Extract the version string from the error message
    $p.Exception.Message -replace '^Python (\d+\.\d+\.\d+).*$','$1'
} else {
    # Otherwise, return the version string as is
    $p
}

# Check if the $version contains a valid version number
if ($version -match '\d+\.\d+\.\d+') {
    Write-Host "Python $version is installed."
	# Change current directory to the user's profile directory
	Set-Location $env:USERPROFILE

# Download get-pip.py using Invoke-WebRequest (similar to curl in this case)
	Write-Host "Downloading get-pip.py..."
	Invoke-WebRequest -Uri https://bootstrap.pypa.io/get-pip.py -OutFile get-pip.py
	Write-Host "Successfully downloaded get-pip.py"
	
	
	# Install pip
	Write-Host "Installing pip..."
	python get-pip.py
	
	
	# Install virtualenv
	Write-Host "Installing virtualenv..."
	python -m pip install virtualenv
	
	
	# Create virtual environment 'spyder-env'
	Write-Host "Creating virtual environment 'spyder-env'..."
	python -m virtualenv spyder-env
	
	
	
	# Activate the virtual environment 'spyder-env'
	Write-Host "Activating virtual environment 'spyder-env'..."
	spyder-env\Scripts\Activate.ps1
	
	python -m pip install spyder
	python -m pip install nnfs
	python -m pip install numpy 
	
	python -m spyder

	Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
	Read-Host "Press a key to end this process."
} else {
     Write-Host "Python is not installed."
	winget install Python
	$scriptPath = $MyInvocation.MyCommand.Path
	Start-process -FilePath "powershell.exe" -ArgumentList "-NoExit", "-File", "`"$scriptPath`"" 
	Exit
}
