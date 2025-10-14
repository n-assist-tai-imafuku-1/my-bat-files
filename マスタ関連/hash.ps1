# ファイルパスを直接指定
$FilePath = "D:\itk_win11_hp_zbookpw16_g11_V2.ffu"

$hash = Get-FileHash -Path $FilePath -Algorithm SHA256
Write-Host "ファイル: $(Split-Path $FilePath -Leaf)"
Write-Host "ハッシュ: $($hash.Hash)"