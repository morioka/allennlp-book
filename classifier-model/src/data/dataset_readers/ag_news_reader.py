from typing import Dict, List, Iterable

import csv

from allennlp.data import Instance
from allennlp.data.tokenizers import Token
from allennlp.data.dataset_readers import DatasetReader
from allennlp.data.token_indexers import TokenIndexer
from allennlp.data.fields import TextField, LabelField

@DatasetReader.register('ag_news_reader')
class AgNewsReader(DatasetReader):
    def __init__(self, token_indexers: Dict[str, TokenIndexer]) -> None:
        super().__init__()
        self.token_indexers = token_indexers
        self.classes = ["World", "Sports", "Business", "Sci/Tech"]

    def text_to_instance(self, 
                         tokens: List[Token],
                         label: str = None) -> Instance:
        sentence_field = TextField(tokens, self.token_indexers)
        fields = {"sentence": sentence_field}

        if label:
            label_field = LabelField(label)
            fields["label"] = label_field

        return Instance(fields)

    def _read(self, file_path: str) -> Iterable[Instance]:
        with open(file_path, 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                label, sentence = self.classes[int(row[0])-1], row[2]
                yield self.text_to_instance([Token(word) for word in sentence.split(" ")], label)

if __name__ == "__main__":
    r = AgNewsReader()
    dataset = r.read("/Users/kajyuuen/workspace/book-src/ch02/datasets/test.csv")
    print(dataset)
