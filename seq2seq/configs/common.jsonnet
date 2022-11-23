local train_data_path = "data/train.tsv";
local validation_data_path = "data/valid.tsv";

local dataset_reader = {
  "type": "seq2seq",
  "source_tokenizer": {
    "type": "character"
  },
  "target_tokenizer": {
    "type": "character"
  },
  "source_token_indexers": {
    "tokens": {
      "type": "single_id",
      "namespace": "source_tokens"
      }
  },
  "target_token_indexers": {
    "tokens": {
      "namespace": "target_tokens"
    }
  },
  "source_add_start_token": false,
  "source_add_end_token": false,
};

{
  "dataset_reader": dataset_reader,
  "train_data_path": train_data_path,
  "validation_data_path": validation_data_path,
  "data_loader": {
    "batch_sampler": {
      "type": "bucket",
      "batch_size": 100,
      "sorting_keys": ["source_tokens"]
      //"sorting_keys": [["source_tokens", "num_tokens"]]
    }
  },
  "trainer": {
    "num_epochs": 100,
    "patience": 10,
    //"cuda_device": 0,
    "cuda_device": -1,
    "optimizer": {
      "type": "adam",
      "lr": 0.01
    }
  }
}
