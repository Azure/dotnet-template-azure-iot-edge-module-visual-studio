# Rename zip file with version
$currentworkdirectory=$env:BUILD_REPOSITORY_LOCALPATH;
$csharpmodulepath="\content-vs\dotnet-template-azure-iot-edge-module\CSharp\"
$csharpmodulebinarypath="\bin\Debug\ProjectTemplates\CSharp\1033\"
$versionfilename="version.txt";
$vesionfilefullpath=Join-Path $currentworkdirectory $csharpmodulepath | Join-Path -ChildPath $versionfilename;
$versionnumber = Get-Content -Raw -Path $vesionfilefullpath | ConvertFrom-Json;
$zipfilename="AzureIoTEdgeModule.zip";
$zipfilefullPath= Join-Path $currentworkdirectory $csharpmodulepath | Join-Path -ChildPath $csharpmodulebinarypath | Join-Path -ChildPath $zipfilename;
$newzipfilename=$zipfilename.Split('.')[0]+'-v'+$versionnumber.version+"."+$zipfilename.Split('.')[1];
$newzipfilefullPath= Join-Path $currentworkdirectory $csharpmodulepath | Join-Path -ChildPath $csharpmodulebinarypath | Join-Path -ChildPath $newzipfilename;
Rename-Item $zipfilefullPath $newzipfilefullPath;
dir "$currentworkdirectory$csharpmodulepath$csharpmodulebinarypath";

#Upload zip file to github repo
$iotedgevstemplatesprojbranch=$env:IOTEDGEVSTEMPLATESPROJBRANCH
$iotedgevstemplatesprojgitpath=$env:IOTEDGEVSTEMPLATESPROJGITPATH
cd ..
git clone $iotedgevstemplatesprojbranch
cd "iot-edge-visual-studio-templates"
git checkout $iotedgevstemplatesprojbranch
$rootworkdirectory= Split-Path -Parent $currentworkdirectory
$csharptemplatepath="\iot-edge-visual-studio-templates\templates\vs2017\CSharp\"
$csharptemplatefullpath=Join-Path $rootworkdirectory $csharptemplatepath
Copy-Item -Path $newzipfilefullPath -Destination $csharptemplatefullpath
dir $csharptemplatefullpath
$gittoken=$env:GITPERSONALACCESSTOKEN
$iotedgevstemplatesprojuri=$iotedgevstemplatesprojgitpath -replace "https://"
$originurl="https://$env:GITUSERNAME:$gittoken@$iotedgevstemplatesprojuri"
git config --global user.name $env:GITUSERNAME
git config --global user.email $env:GITUSEREMAIL
git config --system --unset credential.helper
git add .
git commit -m "upload new azure iot edge module zip file"
git push $originurl