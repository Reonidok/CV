# Renders the résumé into a single, self-contained static page (dist/index.html)
# for hosting on GitHub Pages. The CSS is inlined and no JavaScript is emitted,
# so the file works at any URL (including project-page sub-paths) with no asset
# resolution. Only the Google Fonts links remain external.
namespace :static do
  desc "Build a self-contained static résumé into dist/"
  task build: :environment do
    require "fileutils"

    out = Rails.root.join("dist")
    FileUtils.rm_rf(out)
    FileUtils.mkdir_p(out)

    css   = File.read(Rails.root.join("app", "assets", "stylesheets", "application.css"))
    title = "#{Resume.load.name} · Résumé"

    body = ApplicationController.render(
      template: "resume/show",
      layout:   false,
      assigns:  { resume: Resume.load }
    )

    html = <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>#{title}</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&family=DotGothic16&family=Zen+Kaku+Gothic+New:wght@400;500;700;900&display=swap" rel="stylesheet">
        <style>
      #{css}
        </style>
      </head>
      <body>
      #{body}
      </body>
      </html>
    HTML

    File.write(out.join("index.html"), html)
    FileUtils.touch(out.join(".nojekyll")) # tell GitHub Pages not to run Jekyll

    puts "Wrote #{out.join('index.html')} (#{html.bytesize} bytes)"
  end
end
