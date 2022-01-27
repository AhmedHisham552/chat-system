class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    belongs_to :chat

    settings do
        mappings dynamic: false do
          indexes :body, type: :text
          indexes :chat_id, type: :integer
        end
    end

end
