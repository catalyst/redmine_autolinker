require_dependency 'issue'
require_dependency 'journal'

def auto_link(klass, fields, options={})
  options ||= {}
  fields = (fields.is_a?(Symbol) ? [fields] : fields).map {|f| f.to_sym }

  klass.class_eval do
    before_save :auto_link
    class << self
      attr_accessor :auto_linked_fields
      attr_accessor :auto_link_when
    end

    def auto_link
      if self.class.auto_link_when && !(self.class.auto_link_when.call(self) rescue false)
        return
      end
      # Intersection of changed fields and fields to link
      to_link = self.changed.map {|c| c.to_sym } & (self.class.auto_linked_fields || [])
      to_link.each do |field|
        linked = RedmineAutoLinker::AutoLinker.link self.send(field)
        self.send(:"#{field}=", linked)
      end
    end
  end
  klass.auto_linked_fields = fields
  klass.auto_link_when = options[:if]
end

[
  [Issue, :description],
  [Journal, :notes],
  [CustomValue, :value, if: Proc.new { |this|
    this.custom_field.format_store.has_key? 'text_formatting'
  }]
].each do |kl, fi, options|
  auto_link kl, fi, options
end
