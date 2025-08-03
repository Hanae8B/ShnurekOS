# Set variables
$buildDir = "build"
$kernelCpp = "kernel/kernel.cpp"
$gdtCpp = "kernel/core/gdt.cpp"
$gdtHeader = "kernel/core/gdt.hpp"
$makefile = "Makefile"
$kernelBin = "$buildDir/kernel.bin"

Write-Host "Checking directory structure and files..."

# Check if important files exist
foreach ($file in @($kernelCpp, $gdtCpp, $gdtHeader, $makefile)) {
    if (-Not (Test-Path $file)) {
        Write-Error "Missing required file: $file"
        exit 1
    } else {
        Write-Host "Found $file"
    }
}

# Build project
Write-Host "Building project..."
# Make sure you have make installed or use your own build commands here
if (-Not (Get-Command make -ErrorAction SilentlyContinue)) {
    Write-Error "Make tool not found. Please install make or use your build system."
    exit 1
}

make

if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed. Check errors above."
    exit 1
} else {
    Write-Host "Build succeeded."
}

# Check that kernel binary was created
if (-Not (Test-Path $kernelBin)) {
    Write-Error "Kernel binary not found at $kernelBin"
    exit 1
} else {
    Write-Host "Kernel binary found at $kernelBin"
}

# Optionally run with QEMU (make sure qemu-system-i386 is installed and in PATH)
Write-Host "Launching QEMU with built kernel..."
qemu-system-i386 -kernel $kernelBin -serial stdio

Write-Host "Done."
