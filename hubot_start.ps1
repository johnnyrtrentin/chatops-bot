$HubotPath = "your/hubot/directory"

Write-Host "Starting Hubot Watcher ..."
While (1)
{
    Write-Host "Starting HUBOT"
    Start-Process powershell -ArgumentList "$HubotPath\bin\hubot" -wait
}
