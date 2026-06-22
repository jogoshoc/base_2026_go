Add-Type -AssemblyName System.Drawing

function Clean-LogoPremium {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )
    
    $bmp = [System.Drawing.Bitmap]::FromFile($InputPath)
    $newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($newBmp)
    $graphics.Clear([System.Drawing.Color]::Transparent)
    
    # Threshold for white-ish background (adjust if needed)
    # The user image 1 shows a checkerboard which often means white/gray in simple editors
    # but here it seems it might be actual white or very light gray pixels.
    
    for ($y = 0; $y -lt $bmp.Height; $y++) {
        for ($x = 0; $x -lt $bmp.Width; $x++) {
            $pixel = $bmp.GetPixel($x, $y)
            
            # If the pixel is very white (background), make it transparent
            if ($pixel.R -gt 240 -and $pixel.G -gt 240 -and $pixel.B -gt 240) {
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

Clean-LogoPremium -InputPath "C:\protocolo_abril_2026\images\logopmmg.png" -OutputPath "C:\protocolo_abril_2026\images\logopmmg_clean.png"
