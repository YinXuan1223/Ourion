#!/usr/bin/env bash
# [VAE+Style RESUME] Resume the frozen VAE+style fine-tune from iter_4000 for one full
# 16,896-frame pass (-> max_iters=20896). Single GPU 5, bf16, checkpoints to HDD6/yinxuan.
set -o pipefail
export PATH=/mnt/SSD7/dow904/miniconda3/envs/ourion/bin:$PATH
export CUDA_VISIBLE_DEVICES=5

cd /mnt/HDD5/college_student/Ourion   # cwd = repo root so data/ and ckpts/ resolve

CFG=/mnt/HDD8/dow904/orion_stage2_vae_style_ft_resume.py
WORK_DIR=/mnt/HDD6/yinxuan/dow904_ckpt
mkdir -p ${WORK_DIR}/logs
T=$(date +%m%d%H%M)

PYTHONPATH=/mnt/HDD5/college_student/Ourion:$PYTHONPATH \
python -m torch.distributed.launch \
    --nproc_per_node=1 --master_addr=127.0.0.1 --master_port=54643 \
    --nnodes=1 --node_rank=0 \
    adzoo/orion/train.py ${CFG} \
    --launcher pytorch --deterministic \
    --work-dir ${WORK_DIR} \
    2>&1 | tee ${WORK_DIR}/logs/train.${T}
