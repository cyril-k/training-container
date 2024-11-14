# trainining-container

## Introduction
This is the code for creating Docker container image for simple LLM training.

An example training script for QLoRA finetuning of `llama-2-7b-chat` was used. It was authored by Maxime Labonne (see the [link](https://gist.github.com/mlabonne/8eb9ad60c6340cb48a17385c68e3b1a5)).

The script is put in the container and exposed as an entrypoint, so the arguments for the script can be directly passed to the container.

Try it out:
- Build:
```bash
docker build . -t trainining-container:latest
```
- Run:
```bash
docker run -v ./data:/data trainining-container:latest \
--model_name="trl-internal-testing/dummy-GPT2-correct-vocab" \
--dataset_name="kkondratenko/dummy_dataset" \
--new_model="data/dummy-model" \
--merge_and_push=false \
--lora_r=8 \
--lora_alpha=16 \
--lora_dropout=0.1 \
--output_dir="/data" \
--per_device_train_batch_size=1 \
--per_device_eval_batch_size=1
```

The volume binding `-v ./data:/data` allows to recver the finetuned model weights in a local directory (`./data`) after the training script is finished.

## Adapting the training script

You may adapt the training script in `./app/train.py` to serve your needs. In this case, you may also need to adapt the container entrypoint in the `Dockerfile`: `ENTRYPOINT [ "poetry", "run", "python3.10", "train.py" ]`.