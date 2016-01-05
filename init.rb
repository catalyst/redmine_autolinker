Rails.configuration.to_prepare do
  require_dependency 'set_link_preferences'
  require_dependency 'al_issue_patch'
end

Redmine::Plugin.register :redmine_autolinker do
  name 'Redmine Text Autolinking plugin'
  author 'Will Richardson'
  description 'Auto-adds work request links into issue descriptions'
  version '0.0.1'

  settings :partial => 'settings/autolinker'
end
