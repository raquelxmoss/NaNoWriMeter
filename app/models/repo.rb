class Repo < ActiveRecord::Base
  belongs_to :user
  has_many :snippets

  def update_word_count
    files = get_files
    count = files.map {|f| HTTParty.get("https://raw.githubusercontent.com/#{user.github_username}/#{name}/master/#{f["name"]}")
                           .split(" ")
                           .length }.reduce(:+)
    update(word_count: count)
  end

  def calculate_word_frequency
    result = Hash.new
    files = get_files
    words = files.map {|f| HTTParty.get("https://raw.githubusercontent.com/#{user.github_username}/#{name}/master/#{f["name"]}")
                           .split(" ").map { |w| w.downcase.strip.gsub(/[^a-z|A-Z]/, "") } }
                           .flatten
                           .reject(&:empty?)
                           .reject {|word| STOP_WORDS.include?(word) }
    words.uniq.each { |w| result[w] = words.count(w) }
    result.sort_by {|word, count| count }.reverse
  end

  def get_files
    HTTParty.get("https://api.github.com/repos/#{user.github_username}/#{name}/contents")
                .select {|f| f["name"].downcase != "README.md".downcase }
  end

  def get_diff
    commits = HTTParty.get(get_url)
    commits.each do |commit|
      url = commit["html_url"]
      commit_message = commit["commit"]["message"]
      diff = open("#{url}.diff") { |diff_file| diff_file.read }
        .split("\n")
        .select { |line| line.start_with?('+') }
        .reject { |line| line.start_with?('++') }
        .map { |line| line.slice(1..-1) }
        .join("\n")
    Snippet.create(body: diff, commit_message: commit_message, word_count: diff.split.length, repo_id: id)
    end
  end

  def get_url
    if user.last_submit?
      "https://api.github.com/repos/#{user.github_username}/#{name}/commits?since=#{user.last_submit.to_s.gsub(" ", "%20")}"
    else
      "https://api.github.com/repos/#{user.github_username}/#{name}/commits"
    end
  end
  
end
