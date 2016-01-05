require_dependency 'issue'

module RedmineAutoLinker
  module IssuePatch
    def self.included(base)
      base.class_eval do
        before_save :auto_link_description
        def auto_link_description
          if self.changed.include? 'description'
            self.description = RedmineAutoLinker::AutoLinker.link self.description
          end
        end
      end
    end
  end
end

Issue.send(:include, RedmineAutoLinker::IssuePatch) unless Issue.included_modules.include? RedmineAutoLinker::IssuePatch
