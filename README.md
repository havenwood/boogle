# Boogle API with Roda
An implementation of the imaginary "Boogle" API with [Roda](http://roda.jeremyevans.net) and its nifty plugin system.

## POST
Post a book page to the in-memory index by providing a unique `postID` for the page and its `content`.

Example:
```
curl -X POST -H "Content-Type:application/json" -d  "{\"pageId\":1,\"content\":\"Elementary, my dear Watson.\"}" "localhost:9292/index"
```

## GET
Search for pages in the index that contain any words from a search phrase. Duplicate words, capitalization and punctuation are ignored. Results are ordered by score.

Example:
```
curl -H "Content-Type:application/json" "localhost:9292/search?query=Elementary,%20dear%20Watson"
#=> {"matches":[{"pageId":1,"score":3},{"pageId":12,"score":1}]}
```

## Using the API

Clone the repository and install its dependencies:
```bash
git clone git@github.com:havenwood/boogle.git
cd boogle
bundle
```

Run the tests:
```bash
bundle exec rake test
```

Launch the API:
```bash
bundle exec rackup
```
