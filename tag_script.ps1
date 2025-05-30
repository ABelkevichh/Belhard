$url = "git@github.com:ABelkevichh/Belhard.git"

$repo = "D:\cloneProjects"
$repo_clone = "D:\cloneProjects\Belhard"


#Создать папку если нет
if (-not (Test-Path $repo)) {

    mkdir $repo | Out-Null

} 

Set-Location $repo


# Удалить старую копию проекта если есть
if (Test-Path $repo_clone) {
    Remove-Item -Recurse -Force $repo_clone -ErrorAction Stop
}

#клонируем репозиторий и переходим в него
git clone $Url $repo_clone
Set-Location $repo_clone

#попытка узнать тег
try {
    $tag = git describe --tags
} catch {
    Write-Host "Нет ни одного тега в репозитории."
    exit
}


#метод работы с тегом
if ($tag -match "-g[0-9a-f]+$") {
    
    $cleanTag = $tag.Split("-")[0]
    $version = $cleanTag.TrimStart("v").Split(".")
    
    $major = [int]$version[0]
    $minor = [int]$version[1]
    $patch = [int]$version[2]

    $patch++

    $newTag = "v$major.$minor.$patch"

    git tag -a $newTag -m "Release $newTag"
    git push origin $newTag
    Write-Host "Новый релиз создан и отправлен: $newTag"


} else {
    Write-Host "No changes"
    Set-Location $repo
    Remove-Item -Recurse -Force $repo_clone

}