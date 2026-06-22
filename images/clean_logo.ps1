Add-Type -AssemblyName System.Drawing
$inputFile = "C:\protocolo_abril_2026\images\logopmmg.png"
$outputFile = "C:\protocolo_abril_2026\images\logopmmg_clean.png"

$img = [System.Drawing.Image]::FromFile($inputFile)
$bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.DrawImage($img, 0, 0, $img.Width, $img.Height)
$g.Dispose()
$img.Dispose()

# Make black color transparent
# Using a loop to handle potential near-black pixels if needed, 
# but MakeTransparent([Color]::Black) is a good start.
$bmp.MakeTransparent([System.Drawing.Color]::Black)

$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
