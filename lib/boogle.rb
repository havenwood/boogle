require 'thread'

require_relative 'boogle/version'

class Boogle
  attr_reader :pages

  def initialize
    @lock = Mutex.new
    @pages = Hash.new { |h, k| h[k] = [] }
  end

  def index page, input
    normalize(input).each do |word|
      @lock.synchronize { @pages[word] << page }
    end
  end

  def search input
    normalize(input).flat_map do |word|
      @lock.synchronize { @pages[word] }
    end.group_by { |page| page }.map do |page, words|
      {'pageId' => page, 'score' => words.size}
    end
  end

  private def normalize input
    input.downcase.gsub(/[[:punct:]]/, '').split.uniq
  end
end
