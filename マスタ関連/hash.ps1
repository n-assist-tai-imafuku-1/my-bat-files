# �t�@�C���p�X�𒼐ڎw��
$FilePath = "D:\itk_win11_hp_zbookpw16_g11_V2.ffu"

$hash = Get-FileHash -Path $FilePath -Algorithm SHA256
Write-Host "�t�@�C��: $(Split-Path $FilePath -Leaf)"
Write-Host "�n�b�V��: $($hash.Hash)"