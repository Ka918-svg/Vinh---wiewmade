@echo off
setlocal

set "ps=%temp%\gdi_alert.ps1"
> "%ps%" echo Add-Type -AssemblyName System.Windows.Forms,System.Drawing
>> "%ps%" echo $f = New-Object System.Windows.Forms.Form
>> "%ps%" echo $f.FormBorderStyle = 'None'
>> "%ps%" echo $f.WindowState = 'Maximized'
>> "%ps%" echo $f.TopMost = $true
>> "%ps%" echo $bmp = New-Object System.Drawing.Bitmap $f.Width,$f.Height
>> "%ps%" echo $g = [System.Drawing.Graphics]::FromImage($bmp)
>> "%ps%" echo $pic = New-Object System.Windows.Forms.PictureBox
>> "%ps%" echo $pic.Dock = 'Fill'
>> "%ps%" echo $f.Controls.Add($pic)
>> "%ps%" echo $rnd = New-Object System.Random
>> "%ps%" echo $timer = New-Object System.Windows.Forms.Timer
>> "%ps%" echo $timer.Interval = 120
>> "%ps%" echo $timer.Add_Tick({
>> "%ps%" echo   $src = [System.Drawing.Graphics]::FromImage($bmp)
>> "%ps%" echo   $src.CopyFromScreen(0,0,0,0,$bmp.Size)
>> "%ps%" echo   for($x=0;$x -lt $bmp.Width; $x+=40){
>> "%ps%" echo     for($y=0;$y -lt $bmp.Height; $y+=40){
>> "%ps%" echo       $col=$bmp.GetPixel($x,$y)
>> "%ps%" echo       $inv=[System.Drawing.Color]::FromArgb(255,255-$col.R,255-$col.G,255-$col.B)
>> "%ps%" echo       $bmp.SetPixel($x,$y,$inv)
>> "%ps%" echo     }
>> "%ps%" echo   }
>> "%ps%" echo   $font = New-Object System.Drawing.Font 'Segoe UI',36,[System.Drawing.FontStyle]::Bold
>> "%ps%" echo   $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,$rnd.Next(256),$rnd.Next(256),$rnd.Next(256)))
>> "%ps%" echo   $g.DrawString('Đức Vinh! Vinh!', $font, $brush, 50, 50)
>> "%ps%" echo   $cx=[System.Windows.Forms.Cursor]::Position.X
>> "%ps%" echo   $cy=[System.Windows.Forms.Cursor]::Position.Y
>> "%ps%" echo   $g.DrawEllipse([System.Drawing.Pens]::Red, $cx-30, $cy-30, 60, 60)
>> "%ps%" echo   $pic.Image = $bmp
>> "%ps%" echo })
>> "%ps%" echo $timer.Start()
>> "%ps%" echo $job = Start-Job {Start-Sleep -Seconds 60}
>> "%ps%" echo while(-not (Get-Job $job).HasMoreData){ [System.Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 50 }
>> "%ps%" echo $timer.Stop(); $f.Close(); $bmp.Dispose(); $g.Dispose(); exit

start "" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%ps%"
timeout /t 70 >nul
del "%ps%"
endlocal
exit /b
