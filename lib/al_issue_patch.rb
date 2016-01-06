require_dependency 'issue'
require_dependency 'journal'

def auto_link(klass, fields)
  fields = (fields.is_a?(Symbol) ? [fields] : fields).map {|f| f.to_sym }

  klass.class_eval do
    before_save :auto_link
    class << self
      attr_accessor :auto_linked_fields
    end

    def auto_link
      # Intersection of changed fields and fields to link
      to_link = self.changed.map {|c| c.to_sym } & (self.class.auto_linked_fields || [])
      to_link.each do |field|
        linked = RedmineAutoLinker::AutoLinker.link self.send(field)
        self.send(:"#{field}=", linked)
      end
    end
  end
  klass.auto_linked_fields = fields
end

[[Issue, :description], [Journal, :notes]].each do |kl, fi|
  auto_link kl, fi
end
