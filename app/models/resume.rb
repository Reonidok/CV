require "ostruct"
require "yaml"

# Plain Ruby object (no database) that loads the résumé content from
# config/resume.yml and exposes it as nested, dot-accessible structures.
class Resume
  CONFIG_PATH = Rails.root.join("config", "resume.yml")

  def self.load
    data = YAML.safe_load_file(CONFIG_PATH) || {}
    wrap(data)
  end

  # Recursively turn Hashes into OpenStructs so views can use dot access
  # (e.g. resume.contact.email) while Arrays of Hashes become Arrays of OpenStructs.
  def self.wrap(value)
    case value
    when Hash
      OpenStruct.new(value.transform_values { |v| wrap(v) })
    when Array
      value.map { |v| wrap(v) }
    else
      value
    end
  end
end
