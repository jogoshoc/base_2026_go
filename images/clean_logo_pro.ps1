Add-Type -AssemblyName System.Drawing
$imagePath = "C:\protocolo_abril_2026\images\logopmmg.png"
$outputPath = "C:\protocolo_abril_2026\images\logopmmg_clean.png"

$bmp = [System.Drawing.Bitmap]::FromFile($imagePath)
$newBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
$g = [System.Drawing.Graphics]::FromImage($newBmp)
$g.DrawImage($bmp, 0, 0)
$bmp.Dispose()

# Simple color-based transparency (risky for the text, but let's see if we can target ONLY pure black outside)
# Better: Flood fill starting from (0,0)
function FloodFillTransparency($bmp, $x, $y) {
    $targetColor = $bmp.GetPixel($x, $y)
    $stack = New-Object System.Collections.Generic.Stack[System.Drawing.Point]
    $stack.Push((New-Object System.Drawing.Point($x, $y)))
    
    $transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
    
    while ($stack.Count -gt 0) {
        $p = $stack.Pop()
        if ($p.X -lt 0 -or $p.X -ge $bmp.Width -or $p.Y -lt 0 -or $p.Y -ge $bmp.Height) { continue }
        
        $c = $bmp.GetPixel($p.X, $p.Y)
        # Check if color is close to black
        if ($c.R -lt 20 -and $c.G -lt 20 -and $c.B -lt 20 -and $c.A -eq 255) {
            $bmp.SetPixel($p.X, $p.Y, $transparent)
            $stack.Push((New-Object System.Drawing.Point($p.X + 1, $p.Y)))
            $stack.Push((New-Object System.Drawing.Point($p.X - 1, $p.Y)))
            $stack.Push((New-Object System.Drawing.Point($p.X, $p.Y + 1)))
            $stack.Push((New-Object System.Drawing.Point($p.X, $p.Y - 1)))
        }
    }
}

FloodFillTransparency $newBmp 0 0
FloodFillTransparency $newBmp ($newBmp.Width - 1) 0
FloodFillTransparency $newBmp 0 ($newBmp.Height - 1)
FloodFillTransparency $newBmp ($newBmp.Width - 1) ($newBmp.Height - 1)

$newBmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$newBmp.Dispose()
$g.Dispose()
