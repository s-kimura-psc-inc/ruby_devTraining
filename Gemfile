source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ruby '2.3.3p222'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :test do
  gem 'database_cleaner', '~> 1.3.0'       # �e�X�g���s���DB���N���A
  gem 'capybara', '~> 2.4.3'               # �u���E�U�ł̑�����V�~�����[�g���ăe�X�g���ł���
  gem 'simplecov', :require=>false         # �e�X�g�J�o���b�W(�e�X�g�J�o�[��)
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'                        # Rails�p�@�\��ǉ�����RSpec���b�p�[
  gem 'factory_girl_rails', '~> 4.4.1'     # �e�X�g�f�[�^�̐���
  gem 'spring-commands-rspec', '~> 1.0.2'  # Rspec�Ȃǂ�Rails���v�����[�h����
  gem 'shoulda-matchers'                   # RSpec�Ŏg����֗��ȃ}�b�`���[�W(ActiveRecord)
  # gem 'mongoid-rspec'                      # RSpec�Ŏg����֗��ȃ}�b�`���[�W(Mongoid)
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'guard-rspec'                        # �t�@�C�����ύX���ꂽ��Rsepc���������s
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'pg'

gem 'coffee-script-source', '1.8.0'

gem 'authlogic', '3.6.0'                   # �F�؋@�\��񋟂��郉�C�u����
gem 'composite_primary_keys', '9.0.7'      # ������L�[���`�ł���悤�ɂ��邽�߂̃��C�u����
gem 'materialize-sass', '0.98.2'           # �}�e���A���f�U�C���p��JS/CSS��񋟂��郉�C�u����
gem 'pundit', '1.1.0'                      # �F�@�\��񋟂��郉�C�u����

gem 'i18n_generators'

# Bootstrap
gem 'bootstrap-sass'

# Bootstrap �� datetimepicker ��K�p
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'

#kaminari��K�p
gem 'kaminari'
gem 'kaminari-bootstrap', '~> 3.0.1'
