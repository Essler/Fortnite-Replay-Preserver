$replayDir = "C:\Users\Brandon\Pictures\Screenshots\Fortnite\Test\"
$latestReplay = Get-ChildItem -Path $replayDir | Sort-Object LastAccessTime -Descending | Select-Object -First 1

Write-Output "Latest Replay: $($latestReplay.name)"

[byte[]]$bytes = Get-Content (Join-Path $replayDir $latestReplay) -Encoding Byte

$byteOffset = 0x10
$replayByteValue1 = $bytes[$byteOffset++]
$replayByteValue2 = $bytes[$byteOffset++]
$replayByteValue3 = $bytes[$byteOffset++]

Write-Output "Expiration: $replayByteValue1 $replayByteValue2 $replayByteValue3"

Write-Output "Other Replays:"

Get-ChildItem $replayDir -Filter *.replay | 
Foreach-Object {
    Write-Output $_.FullName
    [byte[]]$bytes = Get-Content (Join-Path $replayDir $_) -Encoding Byte
    
    $byteOffset = 0x10
    $bytes[$byteOffset++] = $replayByteValue1
    $bytes[$byteOffset++] = $replayByteValue2
    $bytes[$byteOffset++] = $replayByteValue3

    $bytes | Set-Content (Join-Path $replayDir $_) -Encoding Byte
}
