require File.expand_path('../../test_helper', __FILE__)

class RedmineAutoLinkerTest < ActiveSupport::TestCase
  def setup
    RedmineAutoLinker::AutoLinker.reset!
  end

  test 'single replacement' do
    RedmineAutoLinker::AutoLinker.add_rule /WR(\d+)/, 'http://google.com/{{ 1 }}'
    res = RedmineAutoLinker::AutoLinker.link "Linking stuff WR123 abc123"
    ass_e res, 'Linking stuff "WR123":http://google.com/123 abc123'
  end

  def ass_e(a1, a2)
    assert a1 == a2, "'#{a1}' == '#{a2}'"
  end
end
