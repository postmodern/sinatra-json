### 0.1.0 / 2015-02-28

* Initial release:
  * Extracted `lib/sinatra/json.rb` from [sinatra-contrib] using:

        git filter-branch --force --prune-empty --index-filter "$(cat git_file_filter.sh)" --tag-name-filter cat -- --all

