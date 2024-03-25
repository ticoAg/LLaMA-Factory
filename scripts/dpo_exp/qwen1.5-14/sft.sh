export USE_MODELSCOPE_HUB=1
export WANDB_PROJECT=DPO

export http_proxy=http://127.0.0.1:7890
export HTTP_PROXY=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890
export HTTPS_PROXY=http://127.0.0.1:7890
export all_proxy=http://127.0.0.1:7890
export ALL_PROXY=http://127.0.0.1:7890

deepspeed --num_gpus 5 src/train_bash.py \
    --deepspeed scripts/dpo_exp/qwen1.5-14/ds_z3_config.json \
    --stage sft \
    --do_train \
    --model_name_or_path qwen/Qwen1.5-14B \
    --dataset alpaca_gpt4_en,alpaca_gpt4_zh \
    --dataset_dir ./data \
    --template qwen \
    --finetuning_type full \
    --output_dir .cache/Align-Exp/qwen1.5-14B-sft-full-ckpt \
    --use_fast_tokenizer \
    --overwrite_output_dir \
    --cutoff_len 4096 \
    --preprocessing_num_workers 8 \
    --per_device_train_batch_size 4 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 32 \
    --lr_scheduler_type cosine \
    --logging_steps 1 \
    --save_steps 100 \
    --eval_steps 100 \
    --evaluation_strategy steps \
    --load_best_model_at_end \
    --learning_rate 5e-5 \
    --lr_scheduler_type cosine \
    --num_train_epochs 3.0 \
    --warmup_ratio 0.1 \
    --val_size 0.05 \
    --fp16 \
    --report_to wandb \
    --run_name qwen1.5-14B-sft-full-alpacagpt4