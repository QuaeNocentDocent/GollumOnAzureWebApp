# Example gollum config with omnigollum authentication
# gollum ../wiki --config config.rb
#
# or run from source with
#
# bundle exec bin/gollum ../wiki/ --config config.rb
 
# Remove const to avoid
# warning: already initialized constant FORMAT_NAMES
#
# only remove if it's defined.
# constant Gollum::Page::FORMAT_NAMES not defined (NameError)
Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES
# limit to one format
Gollum::Page::FORMAT_NAMES = { :markdown  => "Markdown" }
 
=begin
Valid formats are:
{ :markdown  => "Markdown",
  :textile   => "Textile",
  :rdoc      => "RDoc",
  :org       => "Org-mode",
  :creole    => "Creole",
  :rest      => "reStructuredText",
  :asciidoc  => "AsciiDoc",
  :mediawiki => "MediaWiki",
  :pod       => "Pod" }
=end
 
# Specify the path to the Wiki.
# gollum_path = '/home/gollum/wiki'
gollum_path = '/home/wiki'
Precious::App.set(:gollum_path, gollum_path)
 
# Specify the wiki options.
wiki_options = {
  :live_preview => false,
  :allow_uploads => true,
  :per_page_uploads => true,
  :allow_editing => true,
  :h1_title => true,
  :css => true,
  :js => true,
  :show_all => true,
  :template_page => true
}
Precious::App.set(:wiki_options, wiki_options)
 
# Set as Sinatra environment as production (no stack traces)
Precious::App.set(:environment, :production)
 
# Setup Omniauth via Omnigollum.
require 'omnigollum'
require 'omniauth-azure-oauth2'
 
options = {
  # OmniAuth::Builder block is passed as a proc
  :providers => Proc.new do
    provider :azure_oauth2, :client_id => 'b5d228d3-71af-4cb3-a1cd-dd826ae195b3', :client_secret => 'SECRET', :tenant_id => 'progel.onmicrosoft.com'
 
  end,
  :dummy_auth => false,
  # Make the entire wiki private
  :protected_routes => ['/*'],
  # Specify committer name as just the user name
  :author_format => Proc.new { |user| user.name },
  # Specify committer e-mail as just the user e-mail
  :author_email => Proc.new { |user| user.email }
 
  # Authorized users
  #  :authorized_users => ENV["OMNIGOLLUM_AUTHORIZED_USERS"].split(",")
}
 
# :omnigollum options *must* be set before the Omnigollum extension is registered
Precious::App.set(:omnigollum, options)
Precious::App.register Omnigollum::Sinatra

