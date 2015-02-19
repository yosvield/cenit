module Setup
  class Webhook
    include Mongoid::Document
    include Mongoid::Timestamps
    include AccountScoped
    include Trackable
    include Setup::Enum

    BuildInDataType.regist(self).referenced_by(:name)
    
    embeds_many :url_parameters, class_name: Setup::Parameter.name, inverse_of: :webhook
    embeds_many :headers, class_name: Setup::Parameter.name, inverse_of: :webhook

    belongs_to :template, class_name: Setup::Template.name, inverse_of: :webhooks

    field :name, type: String
    field :path, type: String
    field :purpose, type: String, default: :send
    field :method, type: String, default: :post
    
    def method_enum
      [:get,:post, :put, :delete, :copy, :head, :options, :link, :unlink, :purge, :lock, :unlock, :propfind]
    end

    validates_presence_of :name, :path, :purpose
    
    accepts_nested_attributes_for :url_parameters, :headers
    
    def relative_url
      "/#{path}"
    end   
  end
end
