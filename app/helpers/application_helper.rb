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
end
