class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  def confirmation_instructions(record, token, opts = {})
    headers['Custom-header'] = 'Bar'
    opts[:from] = 'castropenna@hotmail.com'
    super
  end
end
