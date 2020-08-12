# Be sure to restart your server when you modify this file.

Rails.application.config.ruby_bank = HashWithIndifferentAccess.new
config = YAML.load_file(Rails.root.join("config", "ruby_bank.yml"))[Rails.env]

if config
  Rails.application.config.ruby_bank.update(config)
end