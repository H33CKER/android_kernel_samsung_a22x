#!/bin/bash

# bot informasi
BOT_TOKEN="8171382745:AAGihLEMgYYHVrlkxL0f7Lr6UZtCyNNodxE"
CHAT_ID="-1002643673545"

# Path variabel
HOME="$(pwd)"
ZIP_NAME="A22-$(date +%Y%m%d-%H%M).zip"
OUT_IMG="$HOME/out/arch/arm64/boot/Image.gz"
ANYKERNEL="$HOME/AnyKernel3"

# Salin & zip
cp "$OUT_IMG" "$ANYKERNEL/"
cd "$ANYKERNEL" || exit 1
zip -r9 "$ZIP_NAME" * > /dev/null
rm -f Image.gz

# Tanggal Dibuat
DATE=$(date +"%d-%m-%Y %H:%M")

# Ambil kernel version
if [ -f "$OUT_IMG" ]; then
  KERNEL_VER=$(gzip -dc "$OUT_IMG" \
                | strings \
                | grep -m1 "Linux version" )
else
  KERNEL_VER="Unknown"
fi

# Caption
CAPTION="*A22-$DATE*
\`\`\`
LocalVersion :
$KERNEL_VER
\`\`\`
[KernelSU-Manajer](https://github.com/rsuntk/KernelSU.git)
*Flash via TWRP only*
"

# Upload ke Telegram
curl -F document=@"$ZIP_NAME" \
     -F "chat_id=$CHAT_ID" \
     -F "caption=$CAPTION" \
     -F "parse_mode=Markdown" \
     https://api.telegram.org/bot$BOT_TOKEN/sendDocument
# clean
cd $ANYKERNEL
rm -rf $ZIP_NAME
cd $HOME
