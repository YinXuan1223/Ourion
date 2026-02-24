#!/bin/bash
set -euo pipefail

# Check if huggingface-hub is installed
if ! python -m pip show huggingface-hub > /dev/null 2>&1; then
  echo "huggingface-hub is not installed. Installing now..."
  python -m pip install -U huggingface-hub
else
  echo "huggingface-hub is already installed."
fi

REPO="rethinklab/Bench2Drive-Map"
LOCAL_DIR="./bench2drive/map"

mkdir -p "$LOCAL_DIR"

# TODO: 把這裡換成 Bench2Drive-Map repo 裡你要的檔名
files=(
  "Town01_HD_map.npz"
  "Town02_HD_map.npz"
  "Town03_HD_map.npz"
  "Town04_HD_map.npz"
  "Town05_HD_map.npz"
  "Town06_HD_map.npz"
  "Town07_HD_map.npz"
  "Town10_HD_map.npz"
  "Town11_HD_map.npz"
  "Town12_HD_map.npz"
  "Town13_HD_map.npz"
  "Town15_HD_map.npz"

)

for file in "${files[@]}"; do
  echo "=========================================="
  echo "Downloading: $file"

  huggingface-cli download \
    --resume-download \
    --repo-type dataset \
    "$REPO" \
    --include "$file" \
    --local-dir "$LOCAL_DIR" \
    --local-dir-use-symlinks False

  path="$LOCAL_DIR/$file"
  if [ -f "$path" ]; then
    case "$path" in
      *.tar.gz|*.tgz)
        echo "Extracting tar.gz: $file"
        tar -xzf "$path" -C "$LOCAL_DIR"
        echo "Done. Deleting archive: $file"
        rm -f "$path"
        ;;
      *.zip)
        echo "Extracting zip: $file"
        unzip -o "$path" -d "$LOCAL_DIR"
        echo "Done. Deleting archive: $file"
        rm -f "$path"
        ;;
      *)
        echo "Downloaded (no extraction rule): $file"
        ;;
    esac
  else
    echo "File not found after download: $file"
  fi

  echo ""
done

echo "=========================================="
echo "All requested files downloaded."