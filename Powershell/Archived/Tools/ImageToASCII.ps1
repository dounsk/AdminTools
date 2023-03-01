#将任意图片转化为一段 ASCII字符

$Path = "C:\Users\douns\Downloads\01.png" #指定图片位置

 function Convert-ImageToAsciiArt
{
  param(
    [Parameter(Mandatory)][String]
    $Path,

    [ValidateRange(20,20000)]
    [int]$MaxWidth=80,

    # character height:width ratio
    [float]$ratio = 1.5
  )

  # load drawing functionality
  Add-Type -AssemblyName System.Drawing

  # characters from dark to light
  $characters = '$#H&@*+;:-,. '.ToCharArray()
  #$characters = [char]0x2588, ' ' #黑白图片使用这个
  $c = $characters.count

  # load image and get image size
  $image = [Drawing.Image]::FromFile($path)
  [int]$maxheight = $image.Height / ($image.Width / $maxwidth)/ $ratio

  # paint image on a bitmap with the desired size
  $bitmap = new-object Drawing.Bitmap($image,$maxwidth,$maxheight)


  # use a string builder to store the characters
  [System.Text.StringBuilder]$sb = ""

  # take each pixel line...
  for ([int]$y=0; $y -lt $bitmap.Height; $y++){
    # take each pixel column...
    for ([int]$x=0; $x -lt $bitmap.Width; $x++){
      # examine pixel
      $color = $bitmap.GetPixel($x,$y)
      $brightness = $color.GetBrightness()
      # choose the character that best matches the
      # pixel brightness
      [int]$offset = [Math]::Floor($brightness*$c)
      $ch = $characters[$offset]
      if (-not $ch){ $ch = $characters[-1] }
      # add character to line
      $null = $sb.Append($ch)
    }
    # add a new line
    $null = $sb.AppendLine()
  }

  # clean up and return string
  $image.Dispose()
  $sb.ToString()
}



$OutPath = "$env:temp\asciiart.txt"

Convert-ImageToAsciiArt -Path $Path -MaxWidth 150 |
  Set-Content -Path $OutPath -Encoding UTF8

Invoke-Item -Path $OutPath