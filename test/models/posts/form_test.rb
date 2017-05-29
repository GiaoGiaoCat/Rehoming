require 'test_helper'

class Posts::FormTest < ActiveJob::TestCase
  test '应推一个任务给后台' do
    assert_enqueued_jobs 1 do
      Posts::Form.create(
        forum:    forums(:one),
        author:   users(:yuki),
        content:  '我是评论'
      )
    end
  end
end
