class AlLink < ActiveRecord::Base
  def pattern
    return expression
  end
  def links_to
    return url_template
  end
end
