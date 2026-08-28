$p = [Environment]::GetEnvironmentVariable('Path','User')
$add = 'D:\dev\flutter_ohos327\bin;D:\DevEco Studio\tools\ohpm\bin;D:\DevEco Studio\tools\hvigor\bin;D:\DevEco Studio\tools\node;D:\DevEco Studio\sdk\default\openharmony\toolchains'
if ($p -notlike '*flutter_ohos327*') {
  [Environment]::SetEnvironmentVariable('Path', "$p;$add", 'User')
  Write-Output 'PATH_UPDATED'
} else {
  Write-Output 'PATH_ALREADY_SET'
}
