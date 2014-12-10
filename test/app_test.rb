require 'rack/test'

require_relative 'helper'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_search
    get '/search?query=Elementary,%20dear%20Watson'

    assert last_response.ok?
    assert_equal last_response.headers['Content-Type'], 'application/json'
    assert_equal last_response.body, '{"matches":[]}'
  end

  def test_bad_search_query
    get '/search'

    refute last_response.ok?
  end

  def test_index
    post '/index', JSON.dump({'pageId' => 42, 'content' => 'nada'})

    assert last_response.ok?
    assert_equal last_response.headers['Content-Type'], 'application/json'
  end

  def test_bad_index_verb
    get '/index', JSON.dump({'pageId' => 42, 'content' => 'nada'})

    refute last_response.ok?
  end

  def test_integration
    post '/index', JSON.dump({'pageId' => 1, 'content' => 'words words'})
    post '/index', JSON.dump({'pageId' => 2, 'content' => 'some more words'})

    get '/search?query=words'

    assert last_response.ok?
    assert_equal last_response.headers['Content-Type'], 'application/json'
    assert_equal last_response.body, '{"matches":[{"pageId":1,"score":1},{"pageId":2,"score":1}]}'
  end
end
