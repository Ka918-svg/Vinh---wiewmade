@echo off
setlocal enabledelayedexpansion

rem tạo file PowerShell tạm
set "psfile=%temp%\gdi_spam.ps1"
> "%psfile%" echo Add-Type -AssemblyName System.Windows.Forms,System.Drawing
>> "%psfile%" echo $rnd = New-Object System.Random
>> "%psfile%" echo for ($i=0; $i -lt 9999; $i++) {
>> "%psfile%" echo     $f = New-Object System.Windows.Forms.Form
>> "%psfile%" echo     $f.Width = 420
>> "%psfile%" echo     $f.Height = 220
>> "%psfile%" echo     $f.FormBorderStyle = 'None'
>> "%psfile%" echo     $f.StartPosition = 'Manual'
>> "%psfile%" echo     $f.TopMost = $true
>> "%psfile%" echo     $f.BackColor = [System.Drawing.Color]::Black
>> "%psfile%" echo     $f.Left = $rnd.Next(0,[System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width - $f.Width)
>> "%psfile%" echo     $f.Top = $rnd.Next(0,[System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height - $f.Height)
>> "%psfile%" echo
>> "%psfile%" echo     $angle = 0
>> "%psfile%" echo     $col = 0
>> "%psfile%" echo
>> "%psfile%" echo     $pic = New-Object System.Windows.Forms.PictureBox
>> "%psfile%" echo     $pic.Dock = 'Fill'
>> "%psfile%" echo     $f.Controls.Add($pic)
>> "%psfile%" echo
>> "%psfile%" echo     $bmp = New-Object System.Drawing.Bitmap $f.ClientSize.Width, $f.ClientSize.Height
>> "%psfile%" echo     $g = [System.Drawing.Graphics]::FromImage($bmp)
>> "%psfile%" echo     $g.SmoothingMode = 'HighQuality'
>> "%psfile%" echo
>> "%psfile%" echo     $timer = New-Object System.Windows.Forms.Timer
>> "%psfile%" echo     $timer.Interval = 60
>> "%psfile%" echo     $timer.Add_Tick({
>> "%psfile%" echo         try {
>> "%psfile%" echo             $g.Clear([System.Drawing.Color]::FromArgb(10,0,0,0))
>> "%psfile%" echo             $col = ($col + 12) % 256
>> "%psfile%" echo             $angle = ($angle + 15) % 360
>> "%psfile%" echo
>> "%psfile%" echo             # vẽ hình tròn cắt đôi (2 bán nguyệt màu khác nhau)
>> "%psfile%" echo             $rect = New-Object System.Drawing.Rectangle 20,20,160,160
>> "%psfile%" echo             $brush1 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, $col, 255 - $col, ($col * 2) % 256))
>> "%psfile%" echo             $brush2 = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(220, 255 - $col, $col, (255 - $col)))
>> "%psfile%" echo             $g.FillPie($brush1, $rect, 0 + $angle, 180)
>> "%psfile%" echo             $g.FillPie($brush2, $rect, 180 + $angle, 180)
>> "%psfile%" echo
>> "%psfile%" echo             # hiệu ứng bit màu chữ (chớp/chuyển màu)
>> "%psfile%" echo             $font = New-Object System.Drawing.Font 'Segoe UI',28,[System.Drawing.FontStyle]::Bold
>> "%psfile%" echo             $brushText = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, ($col*2)%256, (255-$col)%256, $col))
>> "%psfile%" echo             $g.DrawString('Vĩnh đẹp trai', $font, $brushText, 200, 70)
>> "%psfile%" echo
>> "%psfile%" echo             # tạo noise đơn giản (bit effect)
>> "%psfile%" echo             for ($n=0; $n -lt 120; $n++) {
>> "%psfile%" echo                 $x = $rnd.Next($f.ClientSize.Width)
>> "%psfile%" echo                 $y = $rnd.Next($f.ClientSize.Height)
>> "%psfile%" echo                 $g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($rnd.Next(60,200), $rnd.Next(256), $rnd.Next(256), $rnd.Next(256)))), $x, $y, 2, 1)
>> "%psfile%" echo             }
>> "%psfile%" echo
>> "%psfile%" echo             # gán ảnh vào PictureBox
>> "%psfile%" echo             $pic.Image = $bmp.Clone()
>> "%psfile%" echo         } catch {}
>> "%psfile%" echo     })
>> "%psfile%" echo
>> "%psfile%" echo     $timer.Start()
>> "%psfile%" echo
>> "%psfile%" echo     $f.Add_Shown({$t = [System.Threading.Tasks.Task]::Run({Start-Sleep -Milliseconds (500 + (Get-Random -Maximum 2000)); $f.Close()})})
>> "%psfile%" echo     [void]$f.ShowDialog()
>> "%psfile%" echo
>> "%psfile%" echo     $timer.Stop()
>> "%psfile%" echo     $g.Dispose()
>> "%psfile%" echo     $bmp.Dispose()
>> "%psfile%" echo     Start-Sleep -Milliseconds (50 + (Get-Random -Maximum 200))
>> "%psfile%" echo }

rem chạy script trong vòng 60 giây (1 phút) rồi dừng
set COUNT=0
set MAX=60

:loop
if %COUNT% geq %MAX% goto done
start "" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%psfile%"
timeout /t 1 >nul
set /a COUNT+=1
goto loop

:done
timeout /t 1 >nul
del "%psfile%"
endlocal
exit /b
