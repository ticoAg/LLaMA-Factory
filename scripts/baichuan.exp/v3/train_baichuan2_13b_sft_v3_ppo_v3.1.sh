export WANDB_PROJECT=huggingface

proj_dir=.cache/baichuan.exp
root_dir=.cache/baichuan.exp/v3
exp_id=Baichuan2-13B-Base-Sfted-Chat-V3.1
model_name_or_path=Baichuan2-13B-Base-Sfted-V3-Mixed
reward_model=Baichuan2-13B-Base-RM-HH-RLHF
dataset=alpaca_gpt4_zh
template=baichuan2
gpu_vis=0,1,2,3,4,5
acclerate_config=scripts/acc_config/default_config.yaml

wandb online
# wandb offline

CUDA_VISIBLE_DEVICES=$gpu_vis accelerate launch --config_file $acclerate_config src/train_bash.py \
    --stage ppo \
    --do_train \
    --finetuning_type lora \
    --lora_target W_pack \
    --lora_rank 16 \
    --resume_lora_training False \
    --model_name_or_path $root_dir/$model_name_or_path \
    --reward_model $proj_dir/rm/$reward_model \
    --do_sample \
    --top_k 0 \
    --top_p 1 \
    --no_ignore_pad_token_for_loss \
    --output_dir $root_dir/$exp_id \
    --overwrite_output_dir \
        --template $template \
        --dataset $dataset \
        --cutoff_len 4096 \
        --per_device_train_batch_size 8 \
        --gradient_accumulation_steps 1 \
        --preprocessing_num_workers 128 \
        --num_train_epochs 5 \
    --save_steps 500 \
    --warmup_ratio 0.05 \
    --eval_steps 500 \
    --val_size 0.001 \
        --learning_rate 2e-5 \
        --lr_scheduler_type cosine \
        --max_grad_norm 0.5 \
        --adam_epsilon 1e-8 \
    --logging_steps 5 \
    --plot_loss \
    --bf16 \
    --report_to wandb \
    --run_name $exp_id