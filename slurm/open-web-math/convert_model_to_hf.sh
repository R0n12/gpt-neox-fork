#!/bin/bash
#SBATCH --job-name="llmath_convert"
# #SBATCH --account=dw87
#SBATCH --comment="eleutherai"
#SBATCH --qos=dw87
#SBATCH --partition=dw
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=8GB
#SBATCH --gres=gpu:8
#SBATCH --exclusive
#SBATCH --open-mode=append
#SBATCH --output=convert_mix_3_1b_%j.out
#SBATCH --error=convert_mix_3_1b_%j.out
#SBATCH --time=00:15:00

# BYU cluster

NAME=mix_3_1b
STEP=11632

OUT_NAME=${NAME}_step${STEP}
INPUT_DIR=/home/za2514/compute/saved-weights/open-web-math/${NAME}/global_step${STEP}
OUT_DIR=/home/za2514/compute/saved-weights/open-web-math/${OUT_NAME}
CONFIG_FILE=/home/za2514/compute/math-lm/gpt-neox/configs/open-web-math/${NAME}.yml

source /home/hailey81/miniconda3/bin/activate llmath

which python

export LD_LIBRARY_PATH=/home/hailey81/miniconda3/envs/llmath/lib/
export PATH=/home/hailey81/cuda_install/bin:$PATH

ln -s /home/hailey81/miniconda3/envs/llmath/bin/gcc/ ~/.local/bin/gcc
export PATH=$HOME/.local/bin:$PATH

export WANDB_MODE=offline

export TRAIN_DIR=/home/za2514/compute/math-lm/gpt-neox/

cd ${TRAIN_DIR}
pwd

export PYTHONPATH=$TRAIN_DIR

python tools/convert_module_to_hf.py --input_dir ${INPUT_DIR} --config_file ${CONFIG_FILE} --output_dir ${OUT_DIR}

cp /home/za2514/downloaded-weights/llama_hf/7B/{tokenizer_config.json,tokenizer.json,tokenizer.model} ${OUT_DIR}
echo "exited successfully"
