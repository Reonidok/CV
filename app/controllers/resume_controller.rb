class ResumeController < ApplicationController
  # Loads résumé content from config/resume.yml and renders it through the views.
  def show
    @resume = Resume.load
  end
end
