class AlLink < ActiveRecord::Base
  validates_presence_of :expression, :url_template

  def pattern
    return expression
  end
  def links_to
    return url_template
  end
end
