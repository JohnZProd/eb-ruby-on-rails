git clone https://github.com/railstutorial/sample_app_rails_4
rm -rf .git*
rm -rf sample_app_rails_4/.git*
mv ./Dockerfile sample_app_rails_4/
mv entrypoint.sh sample_app_rails_4/
mv sample_app_rails_4/config/database.yml.example sample_app_rails_4/config/database.yml
