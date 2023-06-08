from transformers import AutoModelForCausalLM, AutoTokenizer
import sys

# Command line prompts are expected to be passed-in as a list of strings
if len(sys.argv) == 0:
    print('no prompt provided')

tokenizer = AutoTokenizer.from_pretrained('replit/replit-code-v1-3b',
                                          trust_remote_code=True)
model = AutoModelForCausalLM.from_pretrained('replit/replit-code-v1-3b',
                                             trust_remote_code=True)
prompt = sys.argv[1]
x = tokenizer.encode(prompt, return_tensors='pt')
y = model.generate(x, max_length=100, do_sample=False,
                   top_p=0.95, top_k=4, temperature=0.2,
                   num_return_sequences=1, eos_token_id=tokenizer.eos_token_id,
                   early_stopping=True, num_beams=1,
                   pad_token_id=1)
generated_code = tokenizer.decode(y[0], skip_special_tokens=True,
                                  clean_up_tokenization_spaces=False)
print(generated_code)
