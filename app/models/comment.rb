class Comment < ActiveRecord::Base
  include InvalidatesCache
  belongs_to :article

  validates :article_id, :presence => true

  def self.for_dashboard
    # @for_dashboard ||= order('created_at DESC').limit(5).all

    Rails.cache.fetch("comment_for_dashboard") do
      order('created_at DESC').limit(5).all
    end

  end

  def word_count
    body.split.count
  end

  def self.total_word_count
    # @total_word_count ||= all.inject(0) {|total, a| total += a.word_count }

    Rails.cache.fetch("comment_total_word_count") do
      all.inject(0) {|total, a| total += a.word_count }
    end
  end
end
