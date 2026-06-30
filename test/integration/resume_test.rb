require "test_helper"

class ResumeTest < ActionDispatch::IntegrationTest
  test "renders the résumé page from config/resume.yml" do
    get root_path

    assert_response :success
    assert_select "h1.rk-hero__name"
    assert_select ".rk-section__jp", text: "概要"   # SUMMARY heading (Japanese)

    %w[LLC\ YITO Saratov reonidok@gmail.com 技術スタック 履歴書].each do |marker|
      assert_includes @response.body, marker
    end

    # Pixel sprites are painted with box-shadow.
    assert_includes @response.body, "box-shadow:"
  end
end
