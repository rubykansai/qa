module ApplicationHelper
  def title_name
    if Rails.env =~ /development|test/
      "#{controller.controller_name} : #{controller.action_name}"
    else
      _("Qa")
    end
  end

  def error_messages_for(*args)
    logger.debug(args.join(","))
  end

  def revision_file
    Rails.root + "REVISION"
  end

  def commit_id
    revision_file.read.chomp
  end

  def deployed_at
    revision_file.mtime
  end

  def link_to_github(commit_id)
    link_to("rubykansai/qa@#{commit_id[0,7]}",
            "https://github.com/rubykansai/qa/commit/#{commit_id}")
  end
end
