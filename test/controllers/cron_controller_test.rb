require 'test_helper'

class CronControllerTest < ActionDispatch::IntegrationTest
  test "should get jobs" do
    get cron_jobs_url
    assert_response :success
  end

end
