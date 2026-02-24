#!/bin/bash

# Check if huggingface-hub is installed
if ! python -m pip show huggingface-hub > /dev/null 2>&1; then
  echo "huggingface-hub is not installed. Installing now..."
  python -m pip install huggingface-hub
else
  echo "huggingface-hub is already installed."
fi

# List of files to download
files=(
  "HardBreakRoute_Town01_Route30_Weather3.tar.gz"
  "DynamicObjectCrossing_Town02_Route13_Weather6.tar.gz"
  "Accident_Town03_Route156_Weather0.tar.gz"
  "YieldToEmergencyVehicle_Town04_Route165_Weather7.tar.gz"
  "ConstructionObstacle_Town05_Route68_Weather8.tar.gz"
  "ParkedObstacle_Town10HD_Route371_Weather7.tar.gz"
  "ControlLoss_Town11_Route401_Weather11.tar.gz"
  "AccidentTwoWays_Town12_Route1444_Weather0.tar.gz"
  "OppositeVehicleTakingPriority_Town13_Route600_Weather2.tar.gz"
  "VehicleTurningRoute_Town15_Route443_Weather1.tar.gz"
)

# Download and extract each file
for file in "${files[@]}"; do
  echo "=========================================="
  echo "Downloading: $file"
  huggingface-cli download --resume-download --repo-type dataset rethinklab/Bench2Drive --include "$file" --local-dir ./bench2drive/v1 --local-dir-use-symlinks False
  
  if [ -f "./bench2drive/v1/$file" ]; then
    echo "Extracting: $file"
    tar -xzf "./bench2drive/v1/$file" -C ./bench2drive/v1
    if [ $? -eq 0 ]; then
      echo "Done: $file. Deleting archive."
      rm "./bench2drive/v1/$file"
    else
      echo "Error extracting: $file"
    fi
  else
    echo "File not found: $file"
  fi
  echo ""
done

echo "=========================================="
echo "All files downloaded and extracted successfully!"
