Write-Output "[Full path to locations]"
$bsl = Read-Host "Installed location of steam. Leave empty for default install" `
	"location('C:\Program Files (x86)\Steam')"
if ([string]::IsNullOrEmpty($bsl)) {
	$bsl = "C:\Program Files (x86)\Steam"
}
$sll = Read-Host "Location of SteamLite. Leave emptry to create a SteamLite" `
	"Folder on the desktop"
if ([string]::IsNullOrEmpty($sll)) {
	New-Item -Path "C:\Users\$env:USERNAME\Desktop\SteamLite" `
	-itemtype Directory
	Write-Output "[*] Created SteamLite Folder on your desktop"
	$sll = "C:\Users\$env:USERNAME\Desktop\SteamLite"
}

$baseSteamLocation = $bsl
$steamLiteLocation = $sll

$filesToLookFor = @(
	"vstdlib_s.dll", "vstdlib_s64.dll", "tier0_s.dll",
	"tier0_s64.dll", "steamclient.dll", "steamclient64.dll", "SDL2.dll",
	"video.dll", "libavcodec-57.dll", "libavformat-57.dll",
	"libavresample-3.dll", "libavutil-55.dll", "libswscale-4.dll",
	"Steam.exe", "GameOverlayUI.exe", "GameOverlayRenderer64.dll",
	"GameOverlayRenderer.dll"
)

$foldersToLookFor = @(
	"friends", "graphics", "public", "resource", "servers", "steam", "bin"
)


$files = @(Get-ChildItem $baseSteamLocation | Select -exp Name)

foreach ($f in $filesToLookFor) {
	foreach ($ff in $files) {
		if ($ff -eq $f) {
			Write-Output "[*] Copying file: $ff"
			Copy-Item -Path "$baseSteamLocation\$ff" `
			-Destination $steamLiteLocation
		}
	}
}

foreach ($F in $foldersToLookFor) {
	foreach ($FF in $files) {
		if ($FF -eq $F) {
			Write-Output "[*] Copying folder: $FF"
			Copy-Item -Path $baseSteamLocation\$FF `
			-Destination $steamLiteLocation `
			-Recurse
		}
	}
}