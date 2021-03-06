module Saddler
  module Reporter
    module Github
      class PullRequestReviewComment
        include ::Saddler::Reporter::Support
        include Helper

        # https://developer.github.com/v3/pulls/comments/#create-a-comment
        def report(messages, _options)
          repo_path = '.'
          repo = ::Saddler::Reporter::Support::Git::Repository.new(repo_path)

          data = parse(messages)
          client = Client.new(repo)
          # fetch pull_request_review_comments
          pull_request_review_comments = client.pull_request_review_comments

          patches = client.pull_request_patches

          # build comment
          comments = build_comments_with_patches(data, patches)
          return if comments.empty?

          posting_comments = comments - pull_request_review_comments
          return if posting_comments.empty?

          # create pull_request_review_comments
          posting_comments.each do |posting|
            client.create_pull_request_review_comment(posting)
          end
        end
      end
    end
  end
end
