#!/bin/bash

SOURCE="/Users/kukkiiboy/Desktop/統計検定2級アイコン/統計検定2級アイコン.001.png"
DEST="/Users/kukkiiboy/Desktop/アンチグラビティ/1126統計2級/hukusijuukankyou2kyuu/Assets.xcassets/AppIcon.appiconset"

# Ensure destination exists
mkdir -p "$DEST"

# Resize images
sips -z 20 20 "$SOURCE" --out "$DEST/20.png"
sips -z 29 29 "$SOURCE" --out "$DEST/29.png"
sips -z 40 40 "$SOURCE" --out "$DEST/40.png"
sips -z 58 58 "$SOURCE" --out "$DEST/58.png"
sips -z 60 60 "$SOURCE" --out "$DEST/60.png"
sips -z 76 76 "$SOURCE" --out "$DEST/76.png"
sips -z 80 80 "$SOURCE" --out "$DEST/80.png"
sips -z 87 87 "$SOURCE" --out "$DEST/87.png"
sips -z 120 120 "$SOURCE" --out "$DEST/120.png"
sips -z 152 152 "$SOURCE" --out "$DEST/152.png"
sips -z 167 167 "$SOURCE" --out "$DEST/167.png"
sips -z 180 180 "$SOURCE" --out "$DEST/180.png"
sips -z 1024 1024 "$SOURCE" --out "$DEST/1024.png"

# Create Contents.json
cat <<EOF > "$DEST/Contents.json"
{
  "images" : [
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "40.png",
      "scale" : "2x"
    },
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "60.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "58.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "87.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "80.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "120.png",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "120.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "180.png",
      "scale" : "3x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "20.png",
      "scale" : "1x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "40.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "29.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "58.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "40.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "80.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "76.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "152.png",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "167.png",
      "scale" : "2x"
    },
    {
      "size" : "1024x1024",
      "idiom" : "ios-marketing",
      "filename" : "1024.png",
      "scale" : "1x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOF
