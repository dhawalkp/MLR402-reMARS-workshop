#!/usr/bin/env bash

IMAGE_NAME=$1

DIR=$2

export IMAGE_NAME=$IMAGE_NAME

### Build container--------
cd container
chmod +x src/serve
docker build -t $IMAGE_NAME .


IMAGE_ID="$(docker inspect --format="{{.Id}}" $IMAGE_NAME)"

echo $IMAGE_ID

docker images

### Download model--------
cd ..


# Check if model directory or files exist, if they don't download the model
# init
# look for empty dira
if [ -d "$DIR" ]
then
    if [ "$(ls -A $DIR)" ]; then
        echo "Existing model directory detected..."
    fi
else
    echo "Can't find the model, make sure the model is already downloaded with download script"
    exit 1
    
    # Below is if we want to download from Hub instead of our trained model
    
    echo "Downloading model..."
    # Install huggingface_hub
    pip install -r run_local/requirements.txt
    mkdir -p $DIR
    python run_local/download_hf_model.py EleutherAI/gpt-j-6B --cache_dir $DIR --revision float16 --allow_regex *.json *.txt *.bin
fi

if [ $3 = "test_local" ] ; then
    docker kill `docker ps -q` || true
    echo "Starting container for local deployemnt"
    docker run -d --name $IMAGE_NAME --gpus all -v $DIR:/opt/ml -p 8080:8080 --rm gptj-inference-endpoint:latest serve
fi






