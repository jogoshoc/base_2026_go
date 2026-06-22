Add-Type -AssemblyName System.Drawing

function Clean-LogoBlack {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )
    
    $bmp = [System.Drawing.Bitmap]::FromFile($InputPath)
    $newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($newBmp)
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        for ($x = 0; $x -lt $bmp.Width; $x++) {
            $pixel = $bmp.GetPixel($x, $y)
            
            # If the pixel is very dark (black background), make it transparent
            # Also handle the "white background" case the user mentioned
            if (($pixel.R -lt 15 -and $pixel.G -lt 15 -and $pixel.B -lt 15) -or 
                ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240)) {
                $newBmp.SetPixel($x, $y, [System.Drawing.Color]::Transparent)
            } else {
                $newBmp.SetPixel($x, $y, $pixel)
            }
        }
    }
    
    $newBmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    $newBmp.Dispose()
    $graphics.Dispose()
}

Clean-LogoBlack -InputPath "C:\protocolo_abril_2026\images\logopmmg.png" -OutputPath "C:\protocolo_abril_2026\images\logopmmg_clean.png"
