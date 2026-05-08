# Publish to GitHub + reminder to publish to Business Central
param(
    [string]$Message = ""
)

if ($Message -eq "") {
    $Message = Read-Host "Enter commit message"
}

Write-Host ""
Write-Host "--- Pushing to GitHub ---" -ForegroundColor Cyan

git add .
git commit -m $Message
git push

Write-Host ""
Write-Host "--- GitHub: DONE ---" -ForegroundColor Green
Write-Host ""
Write-Host "--- Now publish to Business Central ---" -ForegroundColor Yellow
Write-Host "Go to VS Code and press Ctrl+F5 to publish to your BC Sandbox (S27)" -ForegroundColor Yellow
Write-Host ""
