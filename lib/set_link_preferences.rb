require 'yaml'

module RedmineAutoLinker
  class AutoLinker
    @@link_rules = Array.new

    def self.add_rule pat, url
      unless pat.is_a? Regexp
        pat = pat.start_with?('/') && pat.end_with?('/') ? /#{pat[1..-2]}/ : /#{pat}/
      end
      @@link_rules.push [pat, url]
    end

    # I'm sorry about this function.
    def self.link text
      @@link_rules.each do |pat, url|
        # .match() only matches once. It can be given a starting position though.
        start = 0
        m = pat.match text, start
        # While there is a match for the pattern, replace it
        while m
          # Don't replace the pattern if it's already quoted - ie aready a link.
          unless text[m.begin(0) - 1] == '"'
            new_url = url.clone
            # Replace the parts of the url, repending on the match group (which are numbered from 1, not 0)
            m.captures.each_with_index do |cap, i|
              new_url.gsub! /{{ *#{i + 1} *}}/, cap
            end
            # Replace in the format "link text":http://url-to-some-place.com
            replace = "\"#{m[0]}\":#{new_url}"
            # Insert that value into the middle of the string, from the start of the whole match
            # To one less than the end location of the last match.
            text[m.begin(0)..m.end(m.length - 1) - 1] = replace
            # Increase the start to match from the end of the insert
            start = m.begin(0) + replace.length
          else
            # Still need to increment this so we don't loop infinitely
            start = m.begin(0) + m[0].length
          end
          m = pat.match text, start
        end
      end
      # That was horrible.
      text
    end

    def self.reset!
      @@link_rules = Array.new
    end

    def self.reload
      self.reset!
      AlLink.all.each do |con|
        if con.pattern && con.links_to
          add_rule con.pattern, con.links_to
        end
      end
    end
  end
end

RedmineAutoLinker::AutoLinker.reload
