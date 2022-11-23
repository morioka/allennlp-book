from typing import List, Optional

from janome.tokenizer import Tokenizer as JTokenizer

from allennlp.data.tokenizers import Token
from allennlp.data.tokenizers.tokenizer import Tokenizer

@Tokenizer.register("janome")
class JanomeTokenizer(Tokenizer):
    def __init__(self) -> None:
        self.tokenizer = JTokenizer()
        super().__init__()

    def tokenize(self, text: str) -> List[Token]:
        return self.tokenizer.tokenize(text, wakati=True)

if __name__ == "__main__":
    jt = JanomeTokenizer()
    print(jt.tokenize("僕は古明地こいしちゃん！"))