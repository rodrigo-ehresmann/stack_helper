class Question < ApplicationRecord
	belongs_to :user
	validates :title, :text, :tag_body, presence: true
	has_and_belongs_to_many :hashtags
	has_many :answers

	after_create do
		question_tags = self.tag_body.scan(/#\w+/)
		add_tags(question_tags)
	end

	before_update do
		question_tags = self.tag_body.scan(/#\w+/)
		update_tags(question_tags)
	end

	private

	def update_tags(tags)
		tags_to_remove(tags).each(&:delete)
		add_tags(tags_to_insert(tags))
	end

	# For each tag, find or create it, and add to the question itself.
	def add_tags(tags)
		tags.uniq.map do |hashtag|
			tag = Hashtag.find_or_create_by(name: hashtag.downcase.delete('#'))
			self.hashtags << tag
		end
	end

	# Get tags to be inserted.
	def tags_to_insert(tags)
		tags - self.hashtags.map(&:name)
	end

	# Get tags to be removed.
	def tags_to_remove(tags)
		self.hashtags.where.not(name: tags).to_a
	end
end
