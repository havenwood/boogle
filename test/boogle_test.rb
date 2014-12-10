require_relative 'helper'

class BoogleTest < Minitest::Test
  def setup
    @boogle = Boogle.new
  end

  def test_search_without_results
    assert_equal @boogle.search('abracadabra'), []
  end

  def test_index_ignores_punctuation
    @boogle.index 1, 'oh me, my!'

    assert_includes @boogle.pages['oh'], 1
    assert_includes @boogle.pages['me'], 1
    assert_includes @boogle.pages['my'], 1
  end

  def test_index_ignores_capitals
    @boogle.index 1, 'Oh me MY'

    assert_includes @boogle.pages['oh'], 1
    assert_includes @boogle.pages['me'], 1
    assert_includes @boogle.pages['my'], 1
  end

  def test_index_ignores_duplicates
    @boogle.index 1, 'oh oh oh'

    assert_includes @boogle.pages['oh'], 1
    assert_equal @boogle.pages['oh'].count(1), 1
  end

  def test_index_then_single_word_search
    @boogle.index 1, 'oh me, oh my'

    assert_equal @boogle.search('oh'), [{"pageId"=>1, "score"=>1}]
  end

  def test_index_then_multiple_word_search
    @boogle.index 1, 'oh me, oh my'

    assert_equal @boogle.search('oh my goodness'), [{"pageId"=>1, "score"=>2}]
  end
end
