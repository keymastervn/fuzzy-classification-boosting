class Mail
	attr_accessor :subject, :body, :from, :uid
	def initialize(uid = nil, from = nil, subject = nil, body = nil)
		@uid = uid
		@from = from
		@subject = subject
		@body = body
	end
end