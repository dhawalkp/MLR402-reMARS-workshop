import os
import torch
from transformers import AutoTokenizer, pipeline, AutoModelForCausalLM, GPTJConfig
GPT_WEIGHTS_NAME = "gptj.pt"
def model_fn(model_dir):
    model_config = GPTJConfig.from_json_file(os.path.join(model_dir, 'config.json'))
    model = AutoModelForCausalLM.from_config(model_config)
    state_dict = torch.load(os.path.join(model_dir, GPT_WEIGHTS_NAME))
    model.load_state_dict(state_dict)
    tokenizer = AutoTokenizer.from_pretrained(model_dir)
    if torch.cuda.is_available():
        device = 0
    else:
        device = -1
    generation = pipeline(
        "text-generation", model=model, tokenizer=tokenizer, device=device
    )
    return generation
